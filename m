Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab0BLWh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:37:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:44354 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab0BLWhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:37:19 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 26/28] kdb,panic,debug_core: Allow the debug core to receive a panic before smp_send_stop()
Date: Fri, 12 Feb 2010 16:35:41 -0600
Message-Id: <1266014143-29444-27-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:36:26.0786 (UTC) FILETIME=[D0158020:01CAAC33]
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
 kernel/debug/debug_core.c |   18 ++++++++++++++++++
 kernel/panic.c            |    7 ++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index bfdba97..580fc3b 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -754,11 +754,27 @@ static struct sysrq_key_op sysrq_dbg_op = {
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
@@ -778,6 +794,8 @@ static void kgdb_unregister_callbacks(void)
 	 */
 	if (kgdb_io_module_registered) {
 		kgdb_io_module_registered = 0;
+		atomic_notifier_chain_unregister(&panic_notifier_list,
+					       &kgdb_panic_event_nb);
 		kgdb_arch_exit();
 #ifdef CONFIG_MAGIC_SYSRQ
 		unregister_sysrq_key('g', &sysrq_dbg_op);
diff --git a/kernel/panic.c b/kernel/panic.c
index c787333..428d15b 100644
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
@@ -91,8 +94,6 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	smp_send_stop();
 
-	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
-
 	bust_spinlocks(0);
 
 	if (!panic_blink)
-- 
1.6.4.rc1

