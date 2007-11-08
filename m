Return-Path: <linux-kernel-owner+w=401wt.eu-S1762109AbXKHWgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762109AbXKHWgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 17:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759983AbXKHWgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 17:36:12 -0500
Received: from mga07.intel.com ([143.182.124.22]:28779 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758083AbXKHWgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 17:36:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,391,1188802800"; 
   d="scan'208";a="314641224"
Date: Thu, 8 Nov 2007 14:30:07 -0800
From: Mark Gross <mgross@linux.intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-mm1 breaks C-state support on Intel T7200 x86_64
Message-ID: <20071108223007.GB5775@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <3624.1194542384@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3624.1194542384@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 12:19:44PM -0500, Valdis.Kletnieks@vt.edu wrote:
> (Sorry for not reporting this sooner - I haven't been running off battery
> much in the last 3 weeks, so I didn't notice it till now...)
> 
> Dell Latitude D820 laptop, T7200 Core2 Duo CPU, x86_64 kernel.
> 
> As reported by 'powertop' on a basically idle machine:
> 
> 2.6.23-mm1:
> 
> Cn                Avg residency       P-states (frequencies)
> C0 (cpu running)        (100.0%)        2.00 Ghz     0.8%
> C1                0.0ms ( 0.0%)         1.67 Ghz     0.0%
> C2                0.0ms ( 0.0%)         1333 Mhz     0.0%
> C3                0.0ms ( 0.0%)         1000 Mhz    99.2%
> 
> 2.6.23-rc8-mm2:
> 
> Cn                Avg residency       P-states (frequencies)
> C0 (cpu running)        ( 0.3%)         2.00 Ghz     0.0%
> C1                0.0ms ( 0.0%)         1.67 Ghz     0.0%
> C2                0.0ms ( 0.0%)         1333 Mhz     0.0%
> C3               31.5ms (99.7%)         1000 Mhz   100.0%
> 
> In addition, the ACPI power estimate reported about 25 watts for 23-mm1,
> but only 21 watts for -rc8-mm2, a significant regression.
> 
> I bisected this down to this set of patches:
> 
> pm-qos-infrastructure-and-interface.patch
> pm-qos-infrastructure-and-interface-fix.patch
> pm-qos-infrastructure-and-interface-vs-git-acpi.patch
> pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
> latencyc-use-qos-infrastructure.patch
> 
> The patch says:
> 
>   To register the default pm_qos target for the specific parameter, the
>   process must open one of /dev/[cpu_dma_latency, network_latency,
>   network_throughput]
> 
>   As long as the device node is held open that process has a registered
>   requirement on the parameter.  The name of the requirement is
>   "process_<PID>" derived from the current->pid from within the open system
>   call.
> 
> I shouldn't have to have a process open a /dev/file, write a number, and then
> stay around forever so the file doesn't close in order to get the same behavior
> I was getting by default before.  What needs to happen to get this to not
> be a behavior regression/change?
> 
> 
> 
> 

wing patch fixes up the cpuidle / pm-qos integration.

I suspect that this is folded into another mm patch but it should fix
C-state issue identified.

--mgross



Signed-off-by: mark gross <mgross@linux.intel.com>

-------------

Index: linux-2.6.23-mm1/drivers/cpuidle/cpuidle.c
===================================================================
--- linux-2.6.23-mm1.orig/drivers/cpuidle/cpuidle.c	2007-11-08 13:09:53.000000000 -0800
+++ linux-2.6.23-mm1/drivers/cpuidle/cpuidle.c	2007-11-08 13:25:13.000000000 -0800
@@ -268,7 +268,7 @@
 
 static inline void latency_notifier_init(struct notifier_block *n)
 {
-        pm_qos_add_notifier(PM_QOS_CPUIDLE, n);
+	pm_qos_add_notifier(PM_QOS_CPU_DMA_LATENCY, n);
 }
 
 #else /* CONFIG_SMP */
Index: linux-2.6.23-mm1/drivers/cpuidle/governors/ladder.c
===================================================================
--- linux-2.6.23-mm1.orig/drivers/cpuidle/governors/ladder.c	2007-11-08 13:09:53.000000000 -0800
+++ linux-2.6.23-mm1/drivers/cpuidle/governors/ladder.c	2007-11-08 13:11:30.000000000 -0800
@@ -82,7 +82,7 @@
 	if (last_idx < dev->state_count - 1 &&
 	    last_residency > last_state->threshold.promotion_time &&
 	    dev->states[last_idx + 1].exit_latency <=
-			pm_qos_requirement(PM_QOS_CPUIDLE)) {
+			pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY)) {
 		last_state->stats.promotion_count++;
 		last_state->stats.demotion_count = 0;
 		if (last_state->stats.promotion_count >= last_state->threshold.promotion_count) {
Index: linux-2.6.23-mm1/drivers/cpuidle/governors/menu.c
===================================================================
--- linux-2.6.23-mm1.orig/drivers/cpuidle/governors/menu.c	2007-11-08 13:12:11.000000000 -0800
+++ linux-2.6.23-mm1/drivers/cpuidle/governors/menu.c	2007-11-08 13:24:03.000000000 -0800
@@ -48,7 +48,8 @@
 			break;
 		if (s->target_residency > data->predicted_us)
 			break;
-		if (s->exit_latency > pm_qos_requirement(PM_QOS_CPUIDLE))
+		if (s->exit_latency >
+			pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY))
 			break;
 	}
 
Index: linux-2.6.23-mm1/include/linux/pm_qos_params.h
===================================================================
--- linux-2.6.23-mm1.orig/include/linux/pm_qos_params.h	2007-11-08 13:09:53.000000000 -0800
+++ linux-2.6.23-mm1/include/linux/pm_qos_params.h	2007-11-08 13:14:05.000000000 -0800
@@ -6,23 +6,12 @@
 #include <linux/notifier.h>
 #include <linux/miscdevice.h>
 
-struct requirement_list {
-	struct list_head list;
-	union {
-		s32 value;
-		s32 usec;
-		s32 kbps;
-	};
-	char *name;
-};
-
 #define PM_QOS_RESERVED 0
 #define PM_QOS_CPU_DMA_LATENCY 1
 #define PM_QOS_NETWORK_LATENCY 2
 #define PM_QOS_NETWORK_THROUGHPUT 3
-#define PM_QOS_CPUIDLE 4
 
-#define PM_QOS_NUM_CLASSES 5
+#define PM_QOS_NUM_CLASSES 4
 #define PM_QOS_DEFAULT_VALUE -1
 
 int pm_qos_add_requirement(int qos, char *name, s32 value);
Index: linux-2.6.23-mm1/kernel/pm_qos_params.c
===================================================================
--- linux-2.6.23-mm1.orig/kernel/pm_qos_params.c	2007-11-08 13:09:54.000000000 -0800
+++ linux-2.6.23-mm1/kernel/pm_qos_params.c	2007-11-08 13:14:28.000000000 -0800
@@ -47,6 +47,16 @@
  * held, taken with _irqsave.  One lock to rule them all
  */
 
+struct requirement_list {
+	struct list_head list;
+	union {
+		s32 value;
+		s32 usec;
+		s32 kbps;
+	};
+	char *name;
+};
+
 struct pm_qos_object {
 	struct requirement_list requirements;
 	struct srcu_notifier_head notifiers;
