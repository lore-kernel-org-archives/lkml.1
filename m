Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924Ab0ANPEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab0ANPEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863Ab0ANPB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:01:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:47799 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab0ANPBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:01:24 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 28/40] kdb,panic,debug_core: Allow the debug core to receive a panic before smp_send_stop()
Date: Thu, 14 Jan 2010 08:59:24 -0600
Message-Id: <1263481176-1897-29-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Jan 2010 15:01:03.0022 (UTC) FILETIME=[63DF3CE0:01CA952A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is highly desirable to trap into kdb on panic, and in order
to do so the notifier must be called before smp_send_stop(),
else the debug_core will not be able to correctly trap
all the CPUs.

CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/kdb.h       |    1 +
 kernel/debug/debug_core.c |   19 +++++++++++++++++++
 kernel/panic.c            |    7 ++++---
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 118fd49..75d8777 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -113,5 +113,6 @@ extern void kdb_si_swapinfo(struct sysinfo *);
 
 #else /* ! CONFIG_KGDB_KDB */
 #define KDB_IS_RUNNING() (0)
+#define kdb_printf(...)
 #endif	/* CONFIG_KGDB_KDB */
 #endif	/* !_KDB_H */
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 344e332..d755fd1 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -46,6 +46,7 @@
 #include <linux/pid.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <linux/kdb.h>
 
 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
@@ -749,11 +750,27 @@ static struct sysrq_key_op sysrq_dbg_op = {
 };
 #endif
 
+static int kgdb_panic_event(struct notifier_block *self,
+			    unsigned long val,
+			    void *data)
+{
+	if (dbg_kdb_mode)
+		kdb_printf("PANIC: %s\n", (char *)data);
+	kgdb_breakpoint();
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block kgdb_panic_event_nb = {
+       .notifier_call  = kgdb_panic_event,
+};
+
 static void kgdb_register_callbacks(void)
 {
 	if (!kgdb_io_module_registered) {
 		kgdb_io_module_registered = 1;
 		kgdb_arch_init();
+		atomic_notifier_chain_register(&panic_notifier_list,
+					       &kgdb_panic_event_nb);
 #ifdef CONFIG_MAGIC_SYSRQ
 		register_sysrq_key('g', &sysrq_dbg_op);
 #endif
@@ -773,6 +790,8 @@ static void kgdb_unregister_callbacks(void)
 	 */
 	if (kgdb_io_module_registered) {
 		kgdb_io_module_registered = 0;
+		atomic_notifier_chain_unregister(&panic_notifier_list,
+					       &kgdb_panic_event_nb);
 		kgdb_arch_exit();
 #ifdef CONFIG_MAGIC_SYSRQ
 		unregister_sysrq_key('g', &sysrq_dbg_op);
diff --git a/kernel/panic.c b/kernel/panic.c
index 5827f7b..1f4fb47 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -66,10 +66,13 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	preempt_disable();
 
-	bust_spinlocks(1);
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
+
+	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
+
+	bust_spinlocks(1);
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 	dump_stack();
@@ -90,8 +93,6 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	smp_send_stop();
 
-	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
-
 	bust_spinlocks(0);
 
 	if (!panic_blink)
-- 
1.6.3.1.9.g95405b

