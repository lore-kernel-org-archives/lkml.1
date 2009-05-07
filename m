Return-Path: <linux-kernel-owner+w=401wt.eu-S1763262AbZEHAQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763262AbZEHAQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbZEHAKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:11 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52713
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754565AbZEHAJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:56 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 3/8] xen: cache cr0 value to avoid trap'n'emulate for read_cr0
Date: Thu,  7 May 2009 13:24:57 -0700
Message-Id: <1241727902-3176-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241727902-3176-1-git-send-email-jeremy@goop.org>
References: <1241727902-3176-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

stts() is implemented in terms of read_cr0/write_cr0 to update the
state of the TS bit.  This happens during context switch, and so
is fairly performance critical.  Rather than falling back to
a trap-and-emulate native read_cr0, implement our own by caching
the last-written value from write_cr0 (the TS bit is the only one
we really care about).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index cbb31eb..9c6de48 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -656,10 +656,26 @@ static void xen_clts(void)
 	xen_mc_issue(PARAVIRT_LAZY_CPU);
 }
 
+static DEFINE_PER_CPU(unsigned long, xen_cr0_value);
+
+static unsigned long xen_read_cr0(void)
+{
+	unsigned long cr0 = percpu_read(xen_cr0_value);
+
+	if (unlikely(cr0 == 0)) {
+		cr0 = native_read_cr0();
+		percpu_write(xen_cr0_value, cr0);
+	}
+
+	return cr0;
+}
+
 static void xen_write_cr0(unsigned long cr0)
 {
 	struct multicall_space mcs;
 
+	percpu_write(xen_cr0_value, cr0);
+
 	/* Only pay attention to cr0.TS; everything else is
 	   ignored. */
 	mcs = xen_mc_entry(0);
@@ -845,7 +861,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 
 	.clts = xen_clts,
 
-	.read_cr0 = native_read_cr0,
+	.read_cr0 = xen_read_cr0,
 	.write_cr0 = xen_write_cr0,
 
 	.read_cr4 = native_read_cr4,
-- 
1.6.0.6

