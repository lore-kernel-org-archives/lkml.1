Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbYAYBGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbYAYBGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 20:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbYAYBF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 20:05:56 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:15471 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbYAYBFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 20:05:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SCcJe7hvBe2pqzViEr6w2M3t5zbgTZXTxAb9WKDZNxVuoy4euM2UZO1K0FuA74hTbeErSBIFjmP4zyuCTLjL5KhluTgmdurgYVF7ia3tr5xnuOkFBqNfRzrTTshKIqpzXpbaLFqSNv5kj23xHS795lPvzQkC/vdl3AmsXXPg1A4=
Subject: [PATCH 2/2] x86: Further shrink ifdef sections in fault.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 Jan 2008 17:05:57 -0800
Message-Id: <1201223157.16972.172.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the vmalloc address tests from the if statement into
vmalloc_fault.  This allows 32 and 64 bit to share the same
if block.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 95fe8bf..bdf0282 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -468,6 +468,9 @@ static int vmalloc_fault(unsigned long address)
 	pmd_t *pmd, *pmd_ref;
 	pte_t *pte, *pte_ref;
 
+	if (!(address >= VMALLOC_START && address < VMALLOC_END))
+		return -1;
+
 	/* Copy kernel mappings over when needed. This can also
 	   happen within a race in page table update. In the later
 	   case just flush. */
@@ -563,6 +566,9 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	 */
 #ifdef CONFIG_X86_32
 	if (unlikely(address >= TASK_SIZE)) {
+#else
+	if (unlikely(address >= TASK_SIZE64)) {
+#endif
 		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
 		    vmalloc_fault(address) >= 0)
 			return;
@@ -573,6 +579,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 		goto bad_area_nosemaphore;
 	}
 
+#ifdef CONFIG_X86_32
 	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
 	   fault has been handled. */
 	if (regs->flags & (X86_EFLAGS_IF|VM_MASK))
@@ -585,23 +592,6 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
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
-		/*
-		 * Don't take the mm semaphore here. If we fixup a prefetch
-		 * fault we could otherwise deadlock.
-		 */
-		goto bad_area_nosemaphore;
-	}
 	if (likely(regs->flags & X86_EFLAGS_IF))
 		local_irq_enable();
 
-- 
1.5.4.rc4.1130.g9ad85

