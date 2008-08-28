Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbYH1Tnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbYH1Tnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbYH1Tnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:43:32 -0400
Received: from mga10.intel.com ([192.55.52.92]:59447 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753852AbYH1Tnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:43:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,288,1217833200"; 
   d="scan'208";a="374498722"
Date: Thu, 28 Aug 2008 12:44:20 -0700
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, arjan <arjan@infradead.org>,
       John Kacur <jkacur@gmail.com>
Subject: Re: [PATCH RFC] pm_qos_requirement might sleep
Message-ID: <20080828194420.GB6802@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20080812224926.GA20652@linux.intel.com> <520f0cf10808130124o301b6691ra37ac9007120b9df@mail.gmail.com> <20080814155241.GA31050@linux.intel.com> <1218736137.10800.234.camel@twins> <520f0cf10808141551k283aecb8y647d0f5ae321b81f@mail.gmail.com> <20080825163412.GA21910@linux.intel.com> <1219682129.8515.81.camel@twins> <520f0cf10808260148k47368b71he2737ea1a59bbe4d@mail.gmail.com> <20080826161802.GB9862@linux.intel.com> <520f0cf10808261045v9dddcdcnd1a86b224aa3feb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520f0cf10808261045v9dddcdcnd1a86b224aa3feb0@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Kacur <jkacur at gmail dot com>

Patch to make PM_QOS and CPU_IDLE play nicer when ran with the
RT-Preempt kernel.  CPU_IDLE polls the target_value's of some of the
pm_qos parameters from the idle loop causing sleeping locking
warnings.  Changing the target_value to an atomic avoids this issue.

Signed-off-by: mark gross <mgross@linux.intel.com>

Thanks,

--mgross


Remove the spinlock in pm_qos_requirement by making target_value an atomic type.
This is necessary for real-time since pm_qos_requirement is called by idle and
cannot be allowed to sleep.
Signed-off-by: John Kacur <jkacur at gmail dot com>

Index: linux-2.6/kernel/pm_qos_params.c
===================================================================
--- linux-2.6.orig/kernel/pm_qos_params.c	2008-08-08 07:52:01.000000000 -0700
+++ linux-2.6/kernel/pm_qos_params.c	2008-08-28 12:14:55.000000000 -0700
@@ -43,7 +43,7 @@
 #include <linux/uaccess.h>
 
 /*
- * locking rule: all changes to target_value or requirements or notifiers lists
+ * locking rule: all changes to requirements or notifiers lists
  * or pm_qos_object list and pm_qos_objects need to happen with pm_qos_lock
  * held, taken with _irqsave.  One lock to rule them all
  */
@@ -66,7 +66,7 @@
 	struct miscdevice pm_qos_power_miscdev;
 	char *name;
 	s32 default_value;
-	s32 target_value;
+	atomic_t target_value;
 	s32 (*comparitor)(s32, s32);
 };
 
@@ -77,7 +77,7 @@
 	.notifiers = &cpu_dma_lat_notifier,
 	.name = "cpu_dma_latency",
 	.default_value = 2000 * USEC_PER_SEC,
-	.target_value = 2000 * USEC_PER_SEC,
+	.target_value = ATOMIC_INIT(2000 * USEC_PER_SEC),
 	.comparitor = min_compare
 };
 
@@ -87,7 +87,7 @@
 	.notifiers = &network_lat_notifier,
 	.name = "network_latency",
 	.default_value = 2000 * USEC_PER_SEC,
-	.target_value = 2000 * USEC_PER_SEC,
+	.target_value = ATOMIC_INIT(2000 * USEC_PER_SEC),
 	.comparitor = min_compare
 };
 
@@ -99,7 +99,7 @@
 	.notifiers = &network_throughput_notifier,
 	.name = "network_throughput",
 	.default_value = 0,
-	.target_value = 0,
+	.target_value = ATOMIC_INIT(0),
 	.comparitor = max_compare
 };
 
@@ -150,11 +150,11 @@
 		extreme_value = pm_qos_array[target]->comparitor(
 				extreme_value, node->value);
 	}
-	if (pm_qos_array[target]->target_value != extreme_value) {
+	if (atomic_read(&pm_qos_array[target]->target_value) != extreme_value) {
 		call_notifier = 1;
-		pm_qos_array[target]->target_value = extreme_value;
+		atomic_set(&pm_qos_array[target]->target_value, extreme_value);
 		pr_debug(KERN_ERR "new target for qos %d is %d\n", target,
-			pm_qos_array[target]->target_value);
+			atomic_read(&pm_qos_array[target]->target_value));
 	}
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
@@ -193,14 +193,7 @@
  */
 int pm_qos_requirement(int pm_qos_class)
 {
-	int ret_val;
-	unsigned long flags;
-
-	spin_lock_irqsave(&pm_qos_lock, flags);
-	ret_val = pm_qos_array[pm_qos_class]->target_value;
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
-
-	return ret_val;
+	return atomic_read(&pm_qos_array[pm_qos_class]->target_value);
 }
 EXPORT_SYMBOL_GPL(pm_qos_requirement);
 
