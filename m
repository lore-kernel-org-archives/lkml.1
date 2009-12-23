Return-Path: <linux-kernel-owner+w=401wt.eu-S1751047AbZLWVVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751047AbZLWVVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbZLWVU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:20:57 -0500
Received: from mail.windriver.com ([147.11.1.11]:45146 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394AbZLWVUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:20:55 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 28/37] kdb,panic,debug_core: Allow the debug core to receive a panic before smp_send_stop()
Date: Wed, 23 Dec 2009 15:19:41 -0600
Message-Id: <1261603190-5036-29-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-28-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-12-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-13-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-14-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-16-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-17-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-18-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-19-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-20-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-21-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-22-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-23-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-24-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-25-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-26-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-27-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-28-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:29.0223 (UTC) FILETIME=[C07F5370:01CA8415]
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
index 387a916..3504c1c 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -114,5 +114,6 @@ extern void kdb_si_swapinfo(struct sysinfo *);
 
 #else /* ! CONFIG_KGDB_KDB */
 #define KDB_IS_RUNNING() (0)
+#define kdb_printf(...)
 #endif	/* CONFIG_KGDB_KDB */
 #endif	/* !_KDB_H */
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index e6c6f8a..b28a0a4 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -46,6 +46,7 @@
 #include <linux/pid.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <linux/kdb.h>
 
 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
@@ -750,11 +751,27 @@ static struct sysrq_key_op sysrq_dbg_op = {
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
@@ -774,6 +791,8 @@ static void kgdb_unregister_callbacks(void)
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
1.6.4.rc1

