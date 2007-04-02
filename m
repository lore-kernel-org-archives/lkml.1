Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbXDBFkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbXDBFkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbXDBFkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:40:39 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:37986 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbXDBFki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:40:38 -0400
Date: Mon, 2 Apr 2007 11:10:17 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: [PATCH 5/8] __cpu_up: use singlethreaded workqueue
Message-ID: <20070402054017.GE12962@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402053457.GA9076@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently i386 and x86_64 __cpu_up uses the services of the kevents
workqueue to bring the cpu up. Change this and use kthread workqueue
instead which is single_threaded and won't be frozen during 
CPU_HOTPLUG.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
--
 arch/i386/kernel/smpboot.c   |    3 ++-
 arch/x86_64/kernel/smpboot.c |    5 +++--
 include/linux/kthread.h      |    5 +++--
 kernel/kthread.c             |   16 +++++++++++++---
 4 files changed, 21 insertions(+), 8 deletions(-)

Index: linux-2.6.21-rc5/include/linux/kthread.h
===================================================================
--- linux-2.6.21-rc5.orig/include/linux/kthread.h
+++ linux-2.6.21-rc5/include/linux/kthread.h
@@ -3,7 +3,7 @@
 /* Simple interface for creating and stopping kernel threads without mess. */
 #include <linux/err.h>
 #include <linux/sched.h>
-
+#include <linux/workqueue.h>
 struct task_struct *kthread_create(int (*threadfn)(void *data),
 				   void *data,
 				   const char namefmt[], ...);
@@ -29,5 +29,6 @@ struct task_struct *kthread_create(int (
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 int kthread_stop(struct task_struct *k);
 int kthread_should_stop(void);
-
+extern void kthreadwq_queue_work(struct work_struct *w);
+extern int kthreadwq_up(void);
 #endif /* _LINUX_KTHREAD_H */
Index: linux-2.6.21-rc5/kernel/kthread.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/kthread.c
+++ linux-2.6.21-rc5/kernel/kthread.c
@@ -112,7 +112,7 @@ static int kthread(void *_create)
 	return 0;
 }
 
-/* We are keventd: create a thread. */
+/* We are keventd: create a thread. Hmm, Are we?? */
 static void keventd_create_kthread(struct work_struct *work)
 {
 	struct kthread_create_info *create =
@@ -132,6 +132,16 @@ static void keventd_create_kthread(struc
 	complete(&create->done);
 }
 
+void kthreadwq_queue_work(struct work_struct *work)
+{
+	queue_work(helper_wq, work);
+}
+
+int kthreadwq_up()
+{
+	return (helper_wq != NULL);
+}
+
 /**
  * kthread_create - create a kthread.
  * @threadfn: the function to run until signal_pending(current).
@@ -167,10 +177,10 @@ struct task_struct *kthread_create(int (
 	/*
 	 * The workqueue needs to start up first:
 	 */
-	if (!helper_wq)
+	if (!kthreadwq_up())
 		create.work.func(&create.work);
 	else {
-		queue_work(helper_wq, &create.work);
+		kthreadwq_queue_work(&create.work);
 		wait_for_completion(&create.done);
 	}
 	if (!IS_ERR(create.result)) {
Index: linux-2.6.21-rc5/arch/i386/kernel/smpboot.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/kernel/smpboot.c
+++ linux-2.6.21-rc5/arch/i386/kernel/smpboot.c
@@ -46,6 +46,7 @@
 #include <linux/cpu.h>
 #include <linux/percpu.h>
 #include <linux/nmi.h>
+#include <linux/kthread.h>
 
 #include <linux/delay.h>
 #include <linux/mc146818rtc.h>
@@ -968,7 +969,7 @@ static int __cpuinit __smp_prepare_cpu(i
 	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + USER_PGD_PTRS,
 			min_t(unsigned long, KERNEL_PGD_PTRS, USER_PGD_PTRS));
 	flush_tlb_all();
-	schedule_work(&info.task);
+	kthreadwq_queue_work(&info.task);
 	wait_for_completion(&done);
 
 	zap_low_mappings();
Index: linux-2.6.21-rc5/arch/x86_64/kernel/smpboot.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/x86_64/kernel/smpboot.c
+++ linux-2.6.21-rc5/arch/x86_64/kernel/smpboot.c
@@ -50,6 +50,7 @@
 #include <linux/mc146818rtc.h>
 #include <linux/smp.h>
 #include <linux/kdebug.h>
+#include <linux/kthread.h>
 
 #include <asm/mtrr.h>
 #include <asm/pgalloc.h>
@@ -613,10 +614,10 @@ static int __cpuinit do_boot_cpu(int cpu
 	 * in context of keventd(), we would end up with locking up the keventd
 	 * thread.
 	 */
-	if (!keventd_up() || current_is_keventd())
+	if (!kthreadwq_up())
 		c_idle.work.func(&c_idle.work);
 	else {
-		schedule_work(&c_idle.work);
+		kthreadwq_queue_work(&c_idle.work);
 		wait_for_completion(&c_idle.done);
 	}
 
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
