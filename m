Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849Ab0ANPFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab0ANPFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850Ab0ANPBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:01:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:47748 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab0ANPBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:01:14 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 20/40] arm,kgdb: Add hook to catch an oops with debugger
Date: Thu, 14 Jan 2010 08:59:16 -0600
Message-Id: <1263481176-1897-21-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Jan 2010 15:00:45.0163 (UTC) FILETIME=[593A2BB0:01CA952A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add in a low level hook to catch calls to die() in the debugger.

After the debugger is done, the standard system rules will be in play
for the original exception.

The kdb debugger wants a chance to catch these sorts of exceptions for
analysis.

CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/arm/include/asm/kgdb.h |   11 +++++++++++
 arch/arm/kernel/kgdb.c      |    8 ++++++++
 arch/arm/kernel/traps.c     |    5 +++++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/kgdb.h b/arch/arm/include/asm/kgdb.h
index 67af4b8..17c69ae 100644
--- a/arch/arm/include/asm/kgdb.h
+++ b/arch/arm/include/asm/kgdb.h
@@ -11,6 +11,7 @@
 #define __ARM_KGDB_H__
 
 #include <linux/ptrace.h>
+#include <linux/notifier.h>
 
 /*
  * GDB assumes that we're a user process being debugged, so
@@ -95,6 +96,16 @@ extern int kgdb_fault_expected;
 #define _PC			15
 #define _CPSR			(GDB_MAX_REGS - 1)
 
+#ifdef CONFIG_KGDB
+int kgdb_die_hook(int cmd, const char *str, struct pt_regs *regs, int err);
+#else
+static inline int kgdb_die_hook(int cmd, const char *str,
+				struct pt_regs *regs, int err)
+{
+	return NOTIFY_DONE;
+}
+#endif
+
 /*
  * So that we can denote the end of a frame for tracing,
  * in the simple case:
diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index bb17e9b..3c0e5e5 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -10,6 +10,7 @@
  *           Deepak Saxena <dsaxena@plexity.net>
  */
 #include <linux/kgdb.h>
+#include <linux/notifier.h>
 #include <asm/traps.h>
 
 /* Make a local copy of the registers passed into the handler (bletch) */
@@ -189,6 +190,13 @@ void kgdb_arch_exit(void)
 	unregister_undef_hook(&kgdb_compiled_brkpt_hook);
 }
 
+int kgdb_die_hook(int cmd, const char *str, struct pt_regs *regs, int err)
+{
+	if (kgdb_handle_exception(1, err, cmd, regs))
+		return NOTIFY_DONE;
+	return NOTIFY_STOP;
+}
+
 /*
  * Register our undef instruction hooks with ARM undef core.
  * We regsiter a hook specifically looking for the KGB break inst
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 3f361a7..707e824 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -21,6 +21,9 @@
 #include <linux/hardirq.h>
 #include <linux/init.h>
 #include <linux/uaccess.h>
+#include <linux/kgdb.h>
+#include <linux/kdebug.h>
+#include <linux/notifier.h>
 
 #include <asm/atomic.h>
 #include <asm/cacheflush.h>
@@ -254,6 +257,8 @@ NORET_TYPE void die(const char *str, struct pt_regs *regs, int err)
 {
 	struct thread_info *thread = current_thread_info();
 
+	kgdb_die_hook(DIE_OOPS, str, regs, err);
+
 	oops_enter();
 
 	spin_lock_irq(&die_lock);
-- 
1.6.3.1.9.g95405b

