Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYAIAtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYAIAtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYAIAsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:48:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:59312 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbYAIAsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:48:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RRNjI3MlV76qzOuRrnjATYpLsKgpJkuITkIq/r9pFxgS64qrQIMQ8IQj3On/pvBuVqnaD6AWdg2NDpG0kl/ecbDtAdY6sbwJc6Ss7luRuj5qaLF3NqNidM6k4xgCRkcTC8lRNP1mIqiz0JpQMgdoShmZZQL0vtNEDX9hDiYWCTU=
Subject: [PATCH] x86: More users of PF_ constants in fault_32|64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 16:48:54 -0800
Message-Id: <1199839734.6424.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be the last of the error_code tests that could use
the PF_ defines.  Makes X86_32|64 a little closer.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault_32.c |    7 ++++---
 arch/x86/mm/fault_64.c |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 50a9930..adf5fed 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -404,7 +404,8 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	 * protection error (error_code & 9) == 0.
 	 */
 	if (unlikely(address >= TASK_SIZE)) {
-		if (!(error_code & 0x0000000d) && vmalloc_fault(address) >= 0)
+		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
+		    vmalloc_fault(address) >= 0)
 			return;
 		if (notify_page_fault(regs))
 			return;
@@ -607,7 +608,7 @@ no_context:
 		__typeof__(pte_val(__pte(0))) page;
 
 #ifdef CONFIG_X86_PAE
-		if (error_code & 16) {
+		if (error_code & PF_INSTR) {
 			pte_t *pte = lookup_address(address);
 
 			if (pte && pte_present(*pte) && !pte_exec_kernel(*pte))
@@ -678,7 +679,7 @@ out_of_memory:
 		goto survive;
 	}
 	printk("VM: killing process %s\n", tsk->comm);
-	if (error_code & 4)
+	if (error_code & PF_USER)
 		do_group_exit(SIGKILL);
 	goto no_context;
 
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 018ab78..267a1d5 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -681,7 +681,7 @@ out_of_memory:
 		goto again;
 	}
 	printk("VM: killing process %s\n", tsk->comm);
-	if (error_code & 4)
+	if (error_code & PF_USER)
 		do_group_exit(SIGKILL);
 	goto no_context;
 
-- 
1.5.4.rc2.1164.g6451

