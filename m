Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbYA2DuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbYA2DuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 22:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYA2Dty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 22:49:54 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:29047 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYA2Dtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 22:49:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tl7aheL5TX+C5GL9e5o1dNuGWEIX3S2NfPgiOSDRcOJav8c+yAXsFv5oS/zfzeTRRwf/ChqkyURxo8DaaKYCv7Vjkq16DQzsC53yZixSU+MrC6D1ndFaq+GDM3VZQiUKKPXwpOfkfuFAGhqLW+y/9dILAyLUxLpKgEmQzsLgMTo=
Subject: [PATCH] x86: Reduce ifdef sections in fault.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 19:50:04 -0800
Message-Id: <1201578604.19875.59.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault.c |   31 +++++++++----------------------
 1 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index e28cc52..2737493 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -508,6 +508,10 @@ static int vmalloc_fault(unsigned long address)
 	pmd_t *pmd, *pmd_ref;
 	pte_t *pte, *pte_ref;
 
+	/* Make sure we are in vmalloc area */
+	if (!(address >= VMALLOC_START && address < VMALLOC_END))
+		return -1;
+
 	/* Copy kernel mappings over when needed. This can also
 	   happen within a race in page table update. In the later
 	   case just flush. */
@@ -603,6 +607,9 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	 */
 #ifdef CONFIG_X86_32
 	if (unlikely(address >= TASK_SIZE)) {
+#else
+	if (unlikely(address >= TASK_SIZE64)) {
+#endif
 		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
 		    vmalloc_fault(address) >= 0)
 			return;
@@ -618,6 +625,8 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 		goto bad_area_nosemaphore;
 	}
 
+
+#ifdef CONFIG_X86_32
 	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
 	   fault has been handled. */
 	if (regs->flags & (X86_EFLAGS_IF|VM_MASK))
@@ -630,28 +639,6 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	if (in_atomic() || !mm)
 		goto bad_area_nosemaphore;
 #else /* CONFIG_X86_64 */
-	if (unlikely(address >= TASK_SIZE64)) {
-		/*
-		 * Don't check for the module range here: its PML4
-		 * is always initialized because it's shared with the main
-		 * kernel text. Only vmalloc may need PML4 syncups.
-		 */
-		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
-		      ((address >= VMALLOC_START && address < VMALLOC_END))) {
-			if (vmalloc_fault(address) >= 0)
-				return;
-		}
-
-		/* Can handle a stale RO->RW TLB */
-		if (spurious_fault(address, error_code))
-			return;
-
-		/*
-		 * Don't take the mm semaphore here. If we fixup a prefetch
-		 * fault we could otherwise deadlock.
-		 */
-		goto bad_area_nosemaphore;
-	}
 	if (likely(regs->flags & X86_EFLAGS_IF))
 		local_irq_enable();
 
-- 
1.5.4.rc4.1142.gf5a97



