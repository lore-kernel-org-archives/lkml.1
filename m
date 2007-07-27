Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbXG0EbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbXG0EbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 00:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbXG0Eaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 00:30:52 -0400
Received: from mx.inf.ufpr.br ([200.17.202.3]:40215 "EHLO urquell.c3sl.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbXG0Eaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 00:30:52 -0400
From: Tiago Vignatti <vignatti@c3sl.ufpr.br>
To: linux-kernel@vger.kernel.org
Cc: Tiago Vignatti <vignatti@c3sl.ufpr.br>
Subject: [PATCH] Exports address to the page fault notifier.
Date: Fri, 27 Jul 2007 01:30:50 -0300
Message-Id: <1185510650278-git-send-email-vignatti@c3sl.ufpr.br>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <11855106502612-git-send-email-vignatti@c3sl.ufpr.br>
References: <11855106502612-git-send-email-vignatti@c3sl.ufpr.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tiago Vignatti <vignatti@c3sl.ufpr.br>
---
 arch/i386/mm/fault.c   |    9 +++++----
 include/linux/kdebug.h |    1 +
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
index 01ffdd4..c405802 100644
--- a/arch/i386/mm/fault.c
+++ b/arch/i386/mm/fault.c
@@ -47,14 +47,15 @@ int unregister_page_fault_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(unregister_page_fault_notifier);
 
-static inline int notify_page_fault(struct pt_regs *regs, long err)
+static inline int notify_page_fault(struct pt_regs *regs, long err, unsigned long address)
 {
 	struct die_args args = {
 		.regs = regs,
 		.str = "page fault",
 		.err = err,
 		.trapnr = 14,
-		.signr = SIGSEGV
+		.signr = SIGSEGV,
+		.address = address
 	};
 	return atomic_notifier_call_chain(&notify_page_fault_chain,
 	                                  DIE_PAGE_FAULT, &args);
@@ -330,7 +331,7 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
 	if (unlikely(address >= TASK_SIZE)) {
 		if (!(error_code & 0x0000000d) && vmalloc_fault(address) >= 0)
 			return;
-		if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
+		if (notify_page_fault(regs, error_code, address) == NOTIFY_STOP)
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -339,7 +340,7 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
+	if (notify_page_fault(regs, error_code, address) == NOTIFY_STOP)
 		return;
 
 	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
diff --git a/include/linux/kdebug.h b/include/linux/kdebug.h
index 5db38d6..e8005c2 100644
--- a/include/linux/kdebug.h
+++ b/include/linux/kdebug.h
@@ -9,6 +9,7 @@ struct die_args {
 	long err;
 	int trapnr;
 	int signr;
+	unsigned long address;
 };
 
 int register_die_notifier(struct notifier_block *nb);
-- 
1.5.2.4

