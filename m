Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbXKBPpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbXKBPpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758683AbXKBPoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:44:32 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53863 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760111AbXKBPob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:44:31 -0400
Date: Fri, 2 Nov 2007 16:44:09 +0100
From: Adrian Bunk <bunk@kernel.org>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper prototype for kernel/sched.c:migration_init()
Message-ID: <20071102154409.GM30287@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper prototype for migration_init() in 
include/linux/sched.h

Since there's no point in always returning 0 to a caller that doesn't 
check the return value it also changes the function to return void.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/sched.h |    8 ++++++++
 init/main.c           |    4 +---
 kernel/sched.c        |    4 +---
 3 files changed, 10 insertions(+), 6 deletions(-)

78199d6267bc667b7508606b1ba9c1dc2a694239 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 155d743..9bdc784 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1983,6 +1983,14 @@ static inline void inc_syscw(struct task_struct *tsk)
 }
 #endif
 
+#ifdef CONFIG_SMP
+void migration_init(void);
+#else
+static inline void migration_init(void)
+{
+}
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/init/main.c b/init/main.c
index f605a96..80b04b6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -56,6 +56,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
+#include <linux/sched.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -747,11 +748,8 @@ __setup("nosoftlockup", nosoftlockup_setup);
 static void __init do_pre_smp_initcalls(void)
 {
 	extern int spawn_ksoftirqd(void);
-#ifdef CONFIG_SMP
-	extern int migration_init(void);
 
 	migration_init();
-#endif
 	spawn_ksoftirqd();
 	if (!nosoftlockup)
 		spawn_softlockup_task();
diff --git a/kernel/sched.c b/kernel/sched.c
index 3f6bd11..2f8b4e7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5621,7 +5621,7 @@ static struct notifier_block __cpuinitdata migration_notifier = {
 	.priority = 10
 };
 
-int __init migration_init(void)
+void __init migration_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int err;
@@ -5631,8 +5631,6 @@ int __init migration_init(void)
 	BUG_ON(err == NOTIFY_BAD);
 	migration_call(&migration_notifier, CPU_ONLINE, cpu);
 	register_cpu_notifier(&migration_notifier);
-
-	return 0;
 }
 #endif
 

