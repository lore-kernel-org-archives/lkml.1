Return-Path: <linux-kernel-owner+w=401wt.eu-S933117AbXBLHkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117AbXBLHkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933108AbXBLHib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:38:31 -0500
Received: from mx1.suse.de ([195.135.220.2]:38389 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933087AbXBLHiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:04 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [16/39] x86: simplify notify_page_fault()
Message-Id: <20070212073803.6975613D7F@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Remove all parameters from this function that aren't really variable.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/mm/fault.c   |   18 ++++++++----------
 arch/x86_64/mm/fault.c |   18 ++++++++----------
 2 files changed, 16 insertions(+), 20 deletions(-)

Index: linux/arch/i386/mm/fault.c
===================================================================
--- linux.orig/arch/i386/mm/fault.c
+++ linux/arch/i386/mm/fault.c
@@ -46,17 +46,17 @@ int unregister_page_fault_notifier(struc
 }
 EXPORT_SYMBOL_GPL(unregister_page_fault_notifier);
 
-static inline int notify_page_fault(enum die_val val, const char *str,
-			struct pt_regs *regs, long err, int trap, int sig)
+static inline int notify_page_fault(struct pt_regs *regs, long err)
 {
 	struct die_args args = {
 		.regs = regs,
-		.str = str,
+		.str = "page fault",
 		.err = err,
-		.trapnr = trap,
-		.signr = sig
+		.trapnr = 14,
+		.signr = SIGSEGV
 	};
-	return atomic_notifier_call_chain(&notify_page_fault_chain, val, &args);
+	return atomic_notifier_call_chain(&notify_page_fault_chain,
+	                                  DIE_PAGE_FAULT, &args);
 }
 
 /*
@@ -353,8 +353,7 @@ fastcall void __kprobes do_page_fault(st
 	if (unlikely(address >= TASK_SIZE)) {
 		if (!(error_code & 0x0000000d) && vmalloc_fault(address) >= 0)
 			return;
-		if (notify_page_fault(DIE_PAGE_FAULT, "page fault", regs, error_code, 14,
-						SIGSEGV) == NOTIFY_STOP)
+		if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -363,8 +362,7 @@ fastcall void __kprobes do_page_fault(st
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(DIE_PAGE_FAULT, "page fault", regs, error_code, 14,
-					SIGSEGV) == NOTIFY_STOP)
+	if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
 		return;
 
 	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
Index: linux/arch/x86_64/mm/fault.c
===================================================================
--- linux.orig/arch/x86_64/mm/fault.c
+++ linux/arch/x86_64/mm/fault.c
@@ -56,17 +56,17 @@ int unregister_page_fault_notifier(struc
 }
 EXPORT_SYMBOL_GPL(unregister_page_fault_notifier);
 
-static inline int notify_page_fault(enum die_val val, const char *str,
-			struct pt_regs *regs, long err, int trap, int sig)
+static inline int notify_page_fault(struct pt_regs *regs, long err)
 {
 	struct die_args args = {
 		.regs = regs,
-		.str = str,
+		.str = "page fault",
 		.err = err,
-		.trapnr = trap,
-		.signr = sig
+		.trapnr = 14,
+		.signr = SIGSEGV
 	};
-	return atomic_notifier_call_chain(&notify_page_fault_chain, val, &args);
+	return atomic_notifier_call_chain(&notify_page_fault_chain,
+	                                  DIE_PAGE_FAULT, &args);
 }
 
 void bust_spinlocks(int yes)
@@ -376,8 +376,7 @@ asmlinkage void __kprobes do_page_fault(
 			if (vmalloc_fault(address) >= 0)
 				return;
 		}
-		if (notify_page_fault(DIE_PAGE_FAULT, "page fault", regs, error_code, 14,
-						SIGSEGV) == NOTIFY_STOP)
+		if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -386,8 +385,7 @@ asmlinkage void __kprobes do_page_fault(
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(DIE_PAGE_FAULT, "page fault", regs, error_code, 14,
-					SIGSEGV) == NOTIFY_STOP)
+	if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
 		return;
 
 	if (likely(regs->eflags & X86_EFLAGS_IF))
