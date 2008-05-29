Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYE2SRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYE2SRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbYE2SRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:17:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54023 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbYE2SRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:17:06 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5306"; a="3500816"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu
Cc: pj@sgi.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH] sched: Move cpu masks from kernel/sched.c into kernel/cpu.c
Date: Thu, 29 May 2008 11:17:02 -0700
Message-Id: <1212085023-22284-2-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1212085023-22284-1-git-send-email-maxk@qualcomm.com>
References: <1212085023-22284-1-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/cpu.c seems a more logical place for those maps since they do not really
have much to do with the scheduler these days.

kernel/cpu.c is now built for the UP kernel too, but it does not affect the size
the kernel sections.

$ size vmlinux

before
   text       data        bss        dec        hex    filename
3313797     307060     310352    3931209     3bfc49    vmlinux

after
   text       data        bss        dec        hex    filename
3313797     307060     310352    3931209     3bfc49    vmlinux

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 kernel/Makefile |    4 ++--
 kernel/cpu.c    |   24 ++++++++++++++++++++++++
 kernel/sched.c  |   18 ------------------
 3 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 6c584c5..bb8da0a 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
-	    exit.o itimer.o time.o softirq.o resource.o \
+	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
 	    sysctl.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
@@ -27,7 +27,7 @@ obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
-obj-$(CONFIG_SMP) += cpu.o spinlock.o
+obj-$(CONFIG_SMP) += spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 2eff3f6..6aa48cf 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -15,6 +15,28 @@
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
 
+/*
+ * Represents all cpu's present in the system
+ * In systems capable of hotplug, this map could dynamically grow
+ * as new cpu's are detected in the system via any platform specific
+ * method, such as ACPI for e.g.
+ */
+cpumask_t cpu_present_map __read_mostly;
+EXPORT_SYMBOL(cpu_present_map);
+
+#ifndef CONFIG_SMP
+
+/*
+ * Represents all cpu's that are currently online.
+ */
+cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
+EXPORT_SYMBOL(cpu_online_map);
+
+cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;
+EXPORT_SYMBOL(cpu_possible_map);
+
+#else /* CONFIG_SMP */
+
 /* Serializes the updates to cpu_online_map, cpu_present_map */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
@@ -413,3 +435,5 @@ out:
 	cpu_maps_update_done();
 }
 #endif /* CONFIG_PM_SLEEP_SMP */
+
+#endif /* CONFIG_SMP */
diff --git a/kernel/sched.c b/kernel/sched.c
index fc8f46b..5ebf6a7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4850,24 +4850,6 @@ asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 	return sched_setaffinity(pid, new_mask);
 }
 
-/*
- * Represents all cpu's present in the system
- * In systems capable of hotplug, this map could dynamically grow
- * as new cpu's are detected in the system via any platform specific
- * method, such as ACPI for e.g.
- */
-
-cpumask_t cpu_present_map __read_mostly;
-EXPORT_SYMBOL(cpu_present_map);
-
-#ifndef CONFIG_SMP
-cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
-EXPORT_SYMBOL(cpu_online_map);
-
-cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;
-EXPORT_SYMBOL(cpu_possible_map);
-#endif
-
 long sched_getaffinity(pid_t pid, cpumask_t *mask)
 {
 	struct task_struct *p;
-- 
1.5.4.5

