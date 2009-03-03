Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZCCLPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZCCLPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbZCCLPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:15:07 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37911 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbZCCLPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:15:06 -0500
Subject: [PATCH 1/3] x86: add sanity checks to init_32.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Mar 2009 13:15:02 +0200
Message-Id: <1236078902.2675.16.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: unification

This patch adds sanity checks that are already in init_64.c to init_32.c.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_32.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index a0c32d5..ee4b032 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1193,18 +1193,21 @@ void mark_rodata_ro(void)
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
-#ifdef CONFIG_DEBUG_PAGEALLOC
+	unsigned long addr = begin;
+
+	if (addr >= end)
+		return;
+
 	/*
 	 * If debugging page accesses then do not free this memory but
 	 * mark them not present - any buggy init-section access will
 	 * create a kernel page fault:
 	 */
+#ifdef CONFIG_DEBUG_PAGEALLOC
 	printk(KERN_INFO "debug: unmapping init memory %08lx..%08lx\n",
 		begin, PAGE_ALIGN(end));
 	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
 #else
-	unsigned long addr;
-
 	/*
 	 * We just marked the kernel text read only above, now that
 	 * we are going to free part of that, we need to make that
@@ -1212,14 +1215,16 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 	 */
 	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
 
-	for (addr = begin; addr < end; addr += PAGE_SIZE) {
+	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
+
+	for (; addr < end; addr += PAGE_SIZE) {
 		ClearPageReserved(virt_to_page(addr));
 		init_page_count(virt_to_page(addr));
-		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
+		memset((void *)(addr & ~(PAGE_SIZE-1)),
+			POISON_FREE_INITMEM, PAGE_SIZE);
 		free_page(addr);
 		totalram_pages++;
 	}
-	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 #endif
 }
 
-- 
1.5.4.3



