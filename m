Return-Path: <linux-kernel-owner+w=401wt.eu-S1764984AbYBOU56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764984AbYBOU56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762942AbYBOUzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:55:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:55889 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762196AbYBOUzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:55:48 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/7] kgdb-light-v10: fix NMI hangs
Date: Fri, 15 Feb 2008 14:55:53 -0600
Message-Id: <1203108958-1818-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1203108958-1818-2-git-send-email-jason.wessel@windriver.com>
References: <1203108958-1818-1-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 15 Feb 2008 20:55:33.0859 (UTC) FILETIME=[1B882330:01C87015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the hang regression with kgdb when the NMI interrupt
comes in while the master core is returning from an exception.

Adjust the NMI logic such that KGDB will not stop NMI exceptions from
occurring by in general returning NOTIFY_DONE.  It is not possible to
distinguish the debug NMI sync vs the normal NMI apic interrupt so
kgdb needs to catch the unknown NMI if it the debugger was previously
active on one of the cpus.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c     |   18 +++++++++++++++---
 arch/x86/kernel/traps_32.c |    2 ++
 arch/x86/kernel/traps_64.c |    2 ++
 include/asm-x86/kdebug.h   |    1 +
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index bc762d8..83d97bb 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -41,6 +41,7 @@
 #include <linux/kgdb.h>
 #include <linux/init.h>
 #include <linux/smp.h>
+#include <linux/nmi.h>
 
 #include <asm/apicdef.h>
 #include <asm/system.h>
@@ -290,6 +291,8 @@ single_step_cont(struct pt_regs *regs, struct die_args *args)
 	return NOTIFY_STOP;
 }
 
+static int was_in_debug_nmi[NR_CPUS];
+
 static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 {
 	struct pt_regs *regs = args->regs;
@@ -299,15 +302,24 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 		if (atomic_read(&kgdb_active) != -1) {
 			/* KGDB CPU roundup */
 			kgdb_nmicallback(raw_smp_processor_id(), regs);
+			was_in_debug_nmi[raw_smp_processor_id()] = 1;
+			touch_nmi_watchdog();
 			return NOTIFY_STOP;
 		}
 		return NOTIFY_DONE;
 
 	case DIE_NMI_IPI:
 		if (atomic_read(&kgdb_active) != -1) {
-			/* KGDB CPU roundup: */
-			if (kgdb_nmicallback(raw_smp_processor_id(), regs))
-				return NOTIFY_DONE;
+			/* KGDB CPU roundup */
+			kgdb_nmicallback(raw_smp_processor_id(), regs);
+			was_in_debug_nmi[raw_smp_processor_id()] = 1;
+			touch_nmi_watchdog();
+		}
+		return NOTIFY_DONE;
+
+	case DIE_NMIUNKNOWN:
+		if (was_in_debug_nmi[raw_smp_processor_id()]) {
+			was_in_debug_nmi[raw_smp_processor_id()] = 0;
 			return NOTIFY_STOP;
 		}
 		return NOTIFY_DONE;
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index b22c01e..c5421f3 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -708,6 +708,8 @@ io_check_error(unsigned char reason, struct pt_regs * regs)
 static __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs * regs)
 {
+	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
+		return;
 #ifdef CONFIG_MCA
 	/* Might actually be able to figure out what the guilty party
 	* is. */
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index efc66df..de786e0 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -806,6 +806,8 @@ io_check_error(unsigned char reason, struct pt_regs * regs)
 static __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs * regs)
 {
+	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
+		return;
 	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x.\n",
 		reason);
 	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
diff --git a/include/asm-x86/kdebug.h b/include/asm-x86/kdebug.h
index dd442a1..ae687ce 100644
--- a/include/asm-x86/kdebug.h
+++ b/include/asm-x86/kdebug.h
@@ -20,6 +20,7 @@ enum die_val {
 	DIE_CALL,
 	DIE_NMI_IPI,
 	DIE_PAGE_FAULT,
+	DIE_NMIUNKNOWN,
 };
 
 extern void printk_address(unsigned long address, int reliable);
-- 
1.5.4

