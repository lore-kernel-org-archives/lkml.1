Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYIKPq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYIKPq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYIKPqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:46:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:42068 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYIKPqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:46:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=oKLyhr0oHPm07VlXW4FQUdR0+UvMY432c6x0bkHjD81lI9Pbxj128/jzo0vBs54/Y0
         /Z6I7Ke0KboY1NKi6nRza/b/gkO+VjgW5pJBpHm4hNJwMnFclLvJCWq5KksbVBHgX1JO
         +bTvEc+1Ia7X3yXX6sO3J4+tWCoibpdjDYVXc=
Date: Thu, 11 Sep 2008 17:46:16 +0200
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kmemcheck: lazy checking for MOVS instructions
Message-ID: <20080911154616.GA16042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comments, anyone?

>From 36190b27a77b8ff5bbea09cf765c1f335c3920e4 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 11 Sep 2008 17:31:07 +0200
Subject: [PATCH] kmemcheck: lazy checking for MOVS instructions

This patch adds the support for lazy (as opposed to eager) checking
for [REP] MOVS instructions (mostly used in memcpy()). This means
that if both the source and destination addresses are tracked by
kmemcheck, we copy the shadow memory instead of checking that it is
initialized.

In this way, we get rid of a few more false positives.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/mm/kmemcheck/kmemcheck.c |  121 +++++++++++++++++++++++++++++++++++--
 1 files changed, 115 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
index eef8c6a..640f8bb 100644
--- a/arch/x86/mm/kmemcheck/kmemcheck.c
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -391,6 +391,118 @@ static void kmemcheck_write(struct pt_regs *regs,
 	kmemcheck_write_strict(regs, next_page, next_addr - next_page);
 }
 
+/*
+ * Copying is hard. We have two addresses, each of which may be split across
+ * a page (and each page will have different shadow addresses).
+ */
+static void kmemcheck_copy(struct pt_regs *regs,
+	unsigned long src_addr, unsigned long dst_addr, unsigned int size)
+{
+	uint8_t shadow[8];
+	enum kmemcheck_shadow status;
+
+	unsigned long page;
+	unsigned long next_addr;
+	unsigned long next_page;
+
+	uint8_t *x;
+	unsigned int i;
+	unsigned int n;
+
+	BUG_ON(size > sizeof(shadow));
+
+	page = src_addr & PAGE_MASK;
+	next_addr = src_addr + size - 1;
+	next_page = next_addr & PAGE_MASK;
+
+	if (likely(page == next_page)) {
+		/* Same page */
+		kmemcheck_save_addr(src_addr);
+		x = kmemcheck_shadow_lookup(src_addr);
+		if (x) {
+			for (i = 0; i < size; ++i)
+				shadow[i] = x[i];
+		} else {
+			for (i = 0; i < size; ++i)
+				shadow[i] = KMEMCHECK_SHADOW_INITIALIZED;
+		}
+	} else {
+		n = next_page - src_addr;
+
+		/* First page */
+		kmemcheck_save_addr(src_addr);
+		x = kmemcheck_shadow_lookup(src_addr);
+		if (x) {
+			for (i = 0; i < n; ++i)
+				shadow[i] = x[i];
+		} else {
+			/* Not tracked */
+			for (i = 0; i < n; ++i)
+				shadow[i] = KMEMCHECK_SHADOW_INITIALIZED;
+		}
+
+		/* Second page */
+		kmemcheck_save_addr(next_page);
+		x = kmemcheck_shadow_lookup(next_page);
+		if (x) {
+			for (i = n; i < size; ++i)
+				shadow[i] = x[i];
+		} else {
+			/* Not tracked */
+			for (i = n; i < size; ++i)
+				shadow[i] = KMEMCHECK_SHADOW_INITIALIZED;
+		}
+	}
+
+	page = dst_addr & PAGE_MASK;
+	next_addr = dst_addr + size - 1;
+	next_page = next_addr & PAGE_MASK;
+
+	if (likely(page == next_page)) {
+		/* Same page */
+		kmemcheck_save_addr(dst_addr);
+		x = kmemcheck_shadow_lookup(dst_addr);
+		if (x) {
+			for (i = 0; i < size; ++i) {
+				x[i] = shadow[i];
+				shadow[i] = KMEMCHECK_SHADOW_INITIALIZED;
+			}
+		}
+	} else {
+		n = next_page - dst_addr;
+
+		/* First page */
+		kmemcheck_save_addr(dst_addr);
+		x = kmemcheck_shadow_lookup(dst_addr);
+		if (x) {
+			for (i = 0; i < n; ++i) {
+				x[i] = shadow[i];
+				shadow[i] = KMEMCHECK_SHADOW_INITIALIZED;
+			}
+		}
+
+		/* Second page */
+		kmemcheck_save_addr(next_page);
+		x = kmemcheck_shadow_lookup(next_page);
+		if (x) {
+			for (i = n; i < size; ++i) {
+				x[i] = shadow[i];
+				shadow[i] = KMEMCHECK_SHADOW_INITIALIZED;
+			}
+		}
+	}
+
+	status = kmemcheck_shadow_test(shadow, size);
+	if (status == KMEMCHECK_SHADOW_INITIALIZED)
+		return;
+
+	if (kmemcheck_enabled)
+		kmemcheck_error_save(status, src_addr, size, regs);
+
+	if (kmemcheck_enabled == 2)
+		kmemcheck_enabled = 0;
+}
+
 enum kmemcheck_method {
 	KMEMCHECK_READ,
 	KMEMCHECK_WRITE,
@@ -446,8 +558,7 @@ static void kmemcheck_access(struct pt_regs *regs,
 		case 0xa5:
 			BUG_ON(regs->ip != (unsigned long) rep_prefix);
 
-			kmemcheck_read(regs, regs->si, size);
-			kmemcheck_write(regs, regs->di, size);
+			kmemcheck_copy(regs, regs->si, regs->di, size);
 			data->rep = rep_prefix;
 			data->rex = rex_prefix;
 			data->insn = insn_primary;
@@ -514,8 +625,7 @@ static void kmemcheck_access(struct pt_regs *regs,
 		 * These instructions are special because they take two
 		 * addresses, but we only get one page fault.
 		 */
-		kmemcheck_read(regs, regs->si, size);
-		kmemcheck_write(regs, regs->di, size);
+		kmemcheck_copy(regs, regs->si, regs->di, size);
 		goto out;
 
 		/* CMPS, CMPSB, CMPSW, CMPSD */
@@ -607,8 +717,7 @@ bool kmemcheck_trap(struct pt_regs *regs)
 		switch (data->insn[0]) {
 		case 0xa4:
 		case 0xa5:
-			kmemcheck_read(regs, regs->si, data->size);
-			kmemcheck_write(regs, regs->di, data->size);
+			kmemcheck_copy(regs, regs->si, regs->di, data->size);
 			break;
 		case 0xaa:
 		case 0xab:
-- 
1.5.5.1

