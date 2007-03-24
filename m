Return-Path: <linux-kernel-owner+w=401wt.eu-S964778AbXCXX7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778AbXCXX7H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 19:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964790AbXCXX7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 19:59:06 -0400
Received: from 70-91-206-233-BusName-SFBA.hfc.comcastbusiness.net ([70.91.206.233]:44227
	"EHLO winkc2d1.saville.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S964778AbXCXX7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 19:59:04 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Mar 2007 19:59:03 EDT
From: Wink Saville <wink@saville.com>
To: linux-kernel@vger.kernel.org
Cc: Wink Saville <wink@saville.com>
Subject: [PATCH 3/3] Initialize and use trec_snapshot and trec_print_snapshot.
Date: Sat, 24 Mar 2007 16:51:39 -0700
Message-Id: <1174780300775-git-send-email-wink@saville.com>
X-Mailer: git-send-email 1.5.0.rc2
In-Reply-To: <11747803002933-git-send-email-wink@saville.com>
References: trec-take2 <11747802992043-git-send-email-wink@saville.com> <11747803002933-git-send-email-wink@saville.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trec's are initialized early in main.c and then dump
trec's in die(), panic() and do_page_fault().

Signed-off-by: Wink Saville <wink@saville.com>
---
 arch/x86_64/kernel/traps.c |    5 +++++
 arch/x86_64/mm/fault.c     |    6 ++++++
 init/main.c                |    4 ++++
 kernel/panic.c             |    5 +++++
 4 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86_64/kernel/traps.c b/arch/x86_64/kernel/traps.c
index 09d2e8a..b4f1a36 100644
--- a/arch/x86_64/kernel/traps.c
+++ b/arch/x86_64/kernel/traps.c
@@ -32,6 +32,7 @@
 #include <linux/unwind.h>
 #include <linux/uaccess.h>
 #include <linux/bug.h>
+#include <linux/trec.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -547,9 +548,13 @@ void die(const char * str, struct pt_regs * regs, long err)
 {
 	unsigned long flags = oops_begin();
 
+	trec_snapshot();
+
 	if (!user_mode(regs))
 		report_bug(regs->rip);
 
+	trec_print_snapshot();
+
 	__die(str, regs, err);
 	oops_end(flags);
 	do_exit(SIGSEGV); 
diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
index 6ada723..e92f6bc 100644
--- a/arch/x86_64/mm/fault.c
+++ b/arch/x86_64/mm/fault.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
+#include <linux/trec.h>
 
 #include <asm/system.h>
 #include <asm/pgalloc.h>
@@ -535,6 +536,8 @@ no_context:
 
 	flags = oops_begin();
 
+	trec_snapshot();
+
 	if (address < PAGE_SIZE)
 		printk(KERN_ALERT "Unable to handle kernel NULL pointer dereference");
 	else
@@ -548,6 +551,9 @@ no_context:
 	__die("Oops", regs, error_code);
 	/* Executive summary in case the body of the oops scrolled away */
 	printk(KERN_EMERG "CR2: %016lx\n", address);
+	
+	trec_print_snapshot();
+
 	oops_end(flags);
 	do_exit(SIGKILL);
 
diff --git a/init/main.c b/init/main.c
index a92989e..46bc440 100644
--- a/init/main.c
+++ b/init/main.c
@@ -54,6 +54,7 @@
 #include <linux/lockdep.h>
 #include <linux/pid_namespace.h>
 #include <linux/device.h>
+#include <linux/trec.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -517,6 +518,9 @@ asmlinkage void __init start_kernel(void)
 	early_boot_irqs_off();
 	early_init_irq_lock_class();
 
+	trec_init();
+	TREC0();
+
 /*
  * Interrupts are still disabled. Do necessary setups, then
  * enable them
diff --git a/kernel/panic.c b/kernel/panic.c
index 623d182..52812f2 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -19,6 +19,7 @@
 #include <linux/nmi.h>
 #include <linux/kexec.h>
 #include <linux/debug_locks.h>
+#include <linux/trec.h>
 
 int panic_on_oops;
 int tainted;
@@ -66,6 +67,8 @@ NORET_TYPE void panic(const char * fmt, ...)
         unsigned long caller = (unsigned long) __builtin_return_address(0);
 #endif
 
+	trec_snapshot();
+
 	/*
 	 * It's possible to come here directly from a panic-assertion and not
 	 * have preempt disabled. Some functions called from here want
@@ -96,6 +99,8 @@ NORET_TYPE void panic(const char * fmt, ...)
 	smp_send_stop();
 #endif
 
+	trec_print_snapshot();
+
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
 	if (!panic_blink)
-- 
1.5.0.rc2

