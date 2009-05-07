Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbZEHAdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbZEHAdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759122AbZEHAK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:56 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52704
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755347AbZEHAJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:59 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 6/8] x86: use flush_tlb_others to implement flush_tlb_all
Date: Thu,  7 May 2009 13:25:00 -0700
Message-Id: <1241727902-3176-7-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241727902-3176-1-git-send-email-jeremy@goop.org>
References: <1241727902-3176-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Use the flush_tlb_others() call to implement flush_tlb_all().  This is
useful because flush_tlb_others() already goes via paravirt_ops, and so
will be properly paravirtualized.  This needs a small extension of the
extension to the existing native_flush_tlb_others: the global flush is
indicated by setting the "mm" parameter to NULL, so that kernel mappings
are also flushed.

(Nothing similar is required for xen_flush_tlb_others, as we don't use
global mappings in a guest-visible way under Xen.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/tlb.c  |   29 ++++++++++++++++++-----------
 arch/x86/xen/mmu.c |    7 +++++++
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 821e970..e69bdad 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -147,13 +147,25 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 		 * BUG();
 		 */
 
-	if (f->flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
-		if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
+	if (f->flush_mm == NULL ||
+	    f->flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
+		int tlbstate = percpu_read(cpu_tlbstate.state);
+
+		/* 
+		 * flush_mm == NULL means flush everything, including
+		 * global tlbs, which will only happen when flushing
+		 * kernel mappings. 
+		 */
+		if (f->flush_mm == NULL)
+			__flush_tlb_all();
+		else if (tlbstate == TLBSTATE_OK) {
 			if (f->flush_va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
 				__flush_tlb_one(f->flush_va);
-		} else
+		}
+
+		if (tlbstate == TLBSTATE_LAZY)
 			leave_mm(cpu);
 	}
 out:
@@ -275,16 +287,11 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 	preempt_enable();
 }
 
-static void do_flush_tlb_all(void *info)
+void flush_tlb_all(void)
 {
-	unsigned long cpu = smp_processor_id();
+	flush_tlb_others(cpu_online_mask, NULL, TLB_FLUSH_ALL);
 
 	__flush_tlb_all();
 	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
-		leave_mm(cpu);
-}
-
-void flush_tlb_all(void)
-{
-	on_each_cpu(do_flush_tlb_all, NULL, 1);
+		leave_mm(smp_processor_id());
 }
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 5af62d8..0e13477 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1284,6 +1284,13 @@ static void xen_flush_tlb_single(unsigned long addr)
 	preempt_enable();
 }
 
+/* 
+ * Flush tlb on other cpus.  Xen can do this via a single hypercall
+ * rather than explicit IPIs, which has the nice property of avoiding
+ * any cpus which don't actually have dirty tlbs.  Unfortunately it
+ * doesn't give us an opportunity to kick out cpus which are in lazy
+ * tlb state, so we may end up reflushing some cpus unnecessarily.
+ */
 static void xen_flush_tlb_others(const struct cpumask *cpus,
 				 struct mm_struct *mm, unsigned long va)
 {
-- 
1.6.0.6

