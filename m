Return-Path: <linux-kernel-owner+w=401wt.eu-S932273AbYALByX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbYALByX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 20:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762901AbYALByP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 20:54:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:8441 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbYALByO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 20:54:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sKzBQxbBSWOxQvLxFdG5tgOVZx00ogorzpsGnQwvxllYASxEBPGucMPfwRPoobLaxT0HPct5u1f5eydl/w9mjavo71fW6F6XB7c2g5Kug9iqu59eiZ79V6jECdpbLTF3dkuO5UfM+8y4/ttBLMXYdVKU2+u1yWktvUF1K3Ppy/k=
Subject: [PATCH-RFC] x86: do_page_fault small unification
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 17:54:18 -0800
Message-Id: <1200102858.19760.73.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy the prefetch of map_sem from X86_64 and move the check
notify_page_fault (soon to be kprobe_handle_fault) out of
the unlikely if() statement.

This makes the X86_32|64 pagefault handlers closer to each
other.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, I'll go back to the zero changes unifications now, just
wanted to send the last few for comment as they will eventually
need to be dealt with.

 arch/x86/mm/fault_32.c |   16 +++++++---------
 arch/x86/mm/fault_64.c |    7 ++-----
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index f8fc240..363267a 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -306,13 +306,18 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	 */
 	trace_hardirqs_fixup();
 
+	tsk = current;
+	mm = tsk->mm;
+	prefetchw(&mm->mmap_sem);
+
 	/* get the address */
 	address = read_cr2();
 
-	tsk = current;
-
 	si_code = SEGV_MAPERR;
 
+	if (notify_page_fault(regs))
+		return;
+
 	/*
 	 * We fault-in kernel-space virtual memory on-demand. The
 	 * 'reference' page table is init_mm.pgd.
@@ -330,8 +335,6 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
 		    vmalloc_fault(address) >= 0)
 			return;
-		if (notify_page_fault(regs))
-			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
 		 * fault we could otherwise deadlock.
@@ -339,16 +342,11 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(regs))
-		return;
-
 	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
 	   fault has been handled. */
 	if (regs->flags & (X86_EFLAGS_IF|VM_MASK))
 		local_irq_enable();
 
-	mm = tsk->mm;
-
 	/*
 	 * If we're in an interrupt, have no user context or are running in an
 	 * atomic region then we must not take the fault.
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 11e9398..128f812 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -366,6 +366,8 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 
 	si_code = SEGV_MAPERR;
 
+	if (notify_page_fault(regs))
+		return;
 
 	/*
 	 * We fault-in kernel-space virtual memory on-demand. The
@@ -391,8 +393,6 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 			if (vmalloc_fault(address) >= 0)
 				return;
 		}
-		if (notify_page_fault(regs))
-			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
 		 * fault we could otherwise deadlock.
@@ -400,9 +400,6 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(regs))
-		return;
-
 	if (likely(regs->flags & X86_EFLAGS_IF))
 		local_irq_enable();
 
-- 
1.5.4.rc2.1164.g6451



