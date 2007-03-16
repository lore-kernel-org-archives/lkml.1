Return-Path: <linux-kernel-owner+w=401wt.eu-S965986AbXCPWJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965986AbXCPWJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 18:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965988AbXCPWJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 18:09:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:28454 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965986AbXCPWJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 18:09:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,293,1170662400"; 
   d="scan'208"; a="197837988:sNHT132049183"
Date: Fri, 16 Mar 2007 15:09:03 -0700
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@osdl.org>, Dave Jones <davej@redhat.com>,
       tglx@linutronix.de
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] Export not_critical_when_idle feature in workqueue and use it in ondemand 
Message-ID: <20070316220903.GB6109@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Add a new not_critical_when_idle parameter to queue_delayed_work_on(). This
parameter can be used to schedule work that are 'unimportant' when
CPU is idle and can be called later, when CPU eventually comes out of idle.

Use this parameter in cpufreq ondemand governor.
 
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.20/kernel/workqueue.c
===================================================================
--- linux-2.6.20.orig/kernel/workqueue.c	2007-03-16 14:51:00.000000000 -0700
+++ linux-2.6.20/kernel/workqueue.c	2007-03-16 14:51:21.000000000 -0700
@@ -271,11 +271,13 @@
  * @wq: workqueue to use
  * @dwork: work to queue
  * @delay: number of jiffies to wait before queueing
+ * @not_critical_when_idle: 1 indicates work is not critical when CPU is idle
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
  */
 int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
-			struct delayed_work *dwork, unsigned long delay)
+			struct delayed_work *dwork, unsigned long delay,
+			int not_critical_when_idle)
 {
 	int ret = 0;
 	struct timer_list *timer = &dwork->timer;
@@ -290,7 +292,7 @@
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
-		add_timer_on(timer, cpu, 0);
+		add_timer_on(timer, cpu, not_critical_when_idle);
 		ret = 1;
 	}
 	return ret;
@@ -614,7 +616,7 @@
 int schedule_delayed_work_on(int cpu,
 			struct delayed_work *dwork, unsigned long delay)
 {
-	return queue_delayed_work_on(cpu, keventd_wq, dwork, delay);
+	return queue_delayed_work_on(cpu, keventd_wq, dwork, delay, 0);
 }
 EXPORT_SYMBOL(schedule_delayed_work_on);
 
Index: linux-2.6.20/drivers/cpufreq/cpufreq_ondemand.c
===================================================================
--- linux-2.6.20.orig/drivers/cpufreq/cpufreq_ondemand.c	2007-03-16 14:51:00.000000000 -0700
+++ linux-2.6.20/drivers/cpufreq/cpufreq_ondemand.c	2007-03-16 14:51:21.000000000 -0700
@@ -457,7 +457,7 @@
 	                        	dbs_info->freq_lo,
 	                        	CPUFREQ_RELATION_H);
 	}
-	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay);
+	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay, 1);
 	unlock_policy_rwsem_write(cpu);
 }
 
@@ -472,7 +472,7 @@
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
 	INIT_DELAYED_WORK(&dbs_info->work, do_dbs_timer);
 	queue_delayed_work_on(dbs_info->cpu, kondemand_wq, &dbs_info->work,
-	                      delay);
+	                      delay, 1);
 }
 
 static inline void dbs_timer_exit(struct cpu_dbs_info_s *dbs_info)
Index: linux-2.6.20/include/linux/workqueue.h
===================================================================
--- linux-2.6.20.orig/include/linux/workqueue.h	2007-03-16 14:51:00.000000000 -0700
+++ linux-2.6.20/include/linux/workqueue.h	2007-03-16 14:51:21.000000000 -0700
@@ -170,7 +170,8 @@
 extern int FASTCALL(queue_work(struct workqueue_struct *wq, struct work_struct *work));
 extern int FASTCALL(queue_delayed_work(struct workqueue_struct *wq, struct delayed_work *work, unsigned long delay));
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
-	struct delayed_work *work, unsigned long delay);
+	struct delayed_work *work, unsigned long delay,
+	int not_critical_when_idle);
 extern void FASTCALL(flush_workqueue(struct workqueue_struct *wq));
 
 extern int FASTCALL(schedule_work(struct work_struct *work));
