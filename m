Return-Path: <linux-kernel-owner+w=401wt.eu-S1761220AbXJQVXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220AbXJQVXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbXJQVWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:22:55 -0400
Received: from mga06.intel.com ([134.134.136.21]:49444 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756430AbXJQVWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:22:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,291,1188802800"; 
   d="scan'208";a="249497802"
Date: Wed, 17 Oct 2007 14:15:53 -0700
From: Mark Gross <mgross@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH] static initialization with blocking notifiers.  was :wqRe: 2.6.23-mm1
Message-ID: <20071017211553.GA27026@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <200710152240.03543.rjw@sisk.pl> <20071016195834.GA23157@linux.intel.com> <200710162228.14136.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710162228.14136.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't see my patch show up on the list so I'm resending it.



On Wed, Oct 17, 2007 at 01:53:48AM +0200, Rafael J. Wysocki wrote:
> On Wednesday, 17 October 2007 01:31, Mark Gross wrote:
> > On Tue, Oct 16, 2007 at 10:28:13PM +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, 16 October 2007 21:58, Mark Gross wrote:
> > > > On Mon, Oct 15, 2007 at 10:40:02PM +0200, Rafael J. Wysocki wrote:
> > > > > On Monday, 15 October 2007 18:09, Mark Gross wrote:
> > > > > > On Fri, Oct 12, 2007 at 11:32:40PM +0200, Rafael J. Wysocki wrote:
> > > > > > > On Friday, 12 October 2007 06:31, Andrew Morton wrote:
> > > > > > > > 
> > > > > > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> > > > > > > > 
> > > > > > > > - I've been largely avoiding applying anything since rc8-mm2 in an attempt
> > > > > > > >   to stabilise things for the 2.6.23 merge.
> > > > > > > > 
> > > > > > > >   But that didn't stop all the subsystem maintainers from going nuts, with
> > > > > > > >   the usual accuracy.  We're up to a 37MB diff now, but it seems to be working
> > > > > > > >   a bit better.
> > > > > > > 
> > > > > > > I get many traces similar to the one below from it (w/ hotfixes):
> > > > > > > 
> > > > > > > WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()
> > > > > > 
> > > > > > This is from : WARN_ON(irqs_disabled()) in the cmp_call_function_mask
> > > > > > processor_idle.c is registering a acpi_processor_latency_notify 
> > > > > > 
> > > > > > my code changed the notifier call from blocking_notifier_call_chain to
> > > > > > srcu_notifier_call_chain, because dynamic creation of notifier chains at
> > > > > > runtime where easier with the srcu_notifier_call_chain than the
> > > > > > blocking_notifier_call_chain.  
> > > > > > 
> > > > > > As dynamic creation of PM_QOS parameters are no longer needed I can
> > > > > > change the notifiers back to match what was in lanency.c
> > > > > > 
> > > > > > However; looking at the call tree differences between
> > > > > > blockin_notifier_call_chain and srcu_notifier_call_chain I cannot see a
> > > > > > difference in irq enabling / disabling.  I'm not confident this will
> > > > > > address this yet.
> > > > > 
> > > > > Well, you can send me a patch to check. :-)

The following is a patch to update the pm_qos code in the mm1 tree.  It
removes the PM_QOS_CPUIDLE parameter (replacing it with
PM_CPU_DMA_LATENCY), It changes the notifications from srcu to blocking
in hopes of fixing the WARNS reported by xxx, and it changes the
initialization to me largely static to avoid initialization race with
cpu-idle.

I think we will have to re-visit the static vrs dynamic initialization
and this init race in a while to support pm_qos parameters per power
domain (i.e. per cpu-socket) based on platform information (ACPI) but
for now lets see if this fixes the warning's reported.

Thanks,

Signed-off-by: mark gross <mgross@linux.intel.com>


Binary files linux-2.6.23-mm1/arch/x86_64/ia32/vsyscall-syscall.so.dbg and linux-2.6.23-mm1-pmqos/arch/x86_64/ia32/vsyscall-syscall.so.dbg differ
Binary files linux-2.6.23-mm1/arch/x86_64/ia32/vsyscall-sysenter.so.dbg and linux-2.6.23-mm1-pmqos/arch/x86_64/ia32/vsyscall-sysenter.so.dbg differ
Binary files linux-2.6.23-mm1/arch/x86_64/vdso/vdso.so.dbg and linux-2.6.23-mm1-pmqos/arch/x86_64/vdso/vdso.so.dbg differ
diff -urN -X linux-2.6.23-mm1/Documentation/dontdiff linux-2.6.23-mm1/drivers/cpuidle/cpuidle.c linux-2.6.23-mm1-pmqos/drivers/cpuidle/cpuidle.c
--- linux-2.6.23-mm1/drivers/cpuidle/cpuidle.c	2007-10-16 15:03:30.000000000 -0700
+++ linux-2.6.23-mm1-pmqos/drivers/cpuidle/cpuidle.c	2007-10-17 09:26:21.000000000 -0700
@@ -268,7 +268,7 @@
 
 static inline void latency_notifier_init(struct notifier_block *n)
 {
-        pm_qos_add_notifier(PM_QOS_CPUIDLE, n);
+        pm_qos_add_notifier(PM_QOS_CPU_DMA_LATENCY, n);
 }
 
 #else /* CONFIG_SMP */
diff -urN -X linux-2.6.23-mm1/Documentation/dontdiff linux-2.6.23-mm1/drivers/cpuidle/governors/ladder.c linux-2.6.23-mm1-pmqos/drivers/cpuidle/governors/ladder.c
--- linux-2.6.23-mm1/drivers/cpuidle/governors/ladder.c	2007-10-16 15:03:30.000000000 -0700
+++ linux-2.6.23-mm1-pmqos/drivers/cpuidle/governors/ladder.c	2007-10-17 09:26:21.000000000 -0700
@@ -82,7 +82,7 @@
 	if (last_idx < dev->state_count - 1 &&
 	    last_residency > last_state->threshold.promotion_time &&
 	    dev->states[last_idx + 1].exit_latency <=
-			pm_qos_requirement(PM_QOS_CPUIDLE)) {
+			pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY)) {
 		last_state->stats.promotion_count++;
 		last_state->stats.demotion_count = 0;
 		if (last_state->stats.promotion_count >= last_state->threshold.promotion_count) {
diff -urN -X linux-2.6.23-mm1/Documentation/dontdiff linux-2.6.23-mm1/drivers/cpuidle/governors/menu.c linux-2.6.23-mm1-pmqos/drivers/cpuidle/governors/menu.c
--- linux-2.6.23-mm1/drivers/cpuidle/governors/menu.c	2007-10-16 15:03:30.000000000 -0700
+++ linux-2.6.23-mm1-pmqos/drivers/cpuidle/governors/menu.c	2007-10-17 09:26:21.000000000 -0700
@@ -48,7 +48,7 @@
 			break;
 		if (s->target_residency > data->predicted_us)
 			break;
-		if (s->exit_latency > pm_qos_requirement(PM_QOS_CPUIDLE))
+		if (s->exit_latency > pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY))
 			break;
 	}
 
diff -urN -X linux-2.6.23-mm1/Documentation/dontdiff linux-2.6.23-mm1/include/linux/pm_qos_params.h linux-2.6.23-mm1-pmqos/include/linux/pm_qos_params.h
--- linux-2.6.23-mm1/include/linux/pm_qos_params.h	2007-10-16 15:04:26.000000000 -0700
+++ linux-2.6.23-mm1-pmqos/include/linux/pm_qos_params.h	2007-10-17 09:54:00.000000000 -0700
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
diff -urN -X linux-2.6.23-mm1/Documentation/dontdiff linux-2.6.23-mm1/kernel/pm_qos_params.c linux-2.6.23-mm1-pmqos/kernel/pm_qos_params.c
--- linux-2.6.23-mm1/kernel/pm_qos_params.c	2007-10-16 15:04:27.000000000 -0700
+++ linux-2.6.23-mm1-pmqos/kernel/pm_qos_params.c	2007-10-17 09:24:46.000000000 -0700
@@ -46,17 +46,70 @@
  * or pm_qos_object list and pm_qos_objects need to happen with pm_qos_lock
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
+static s32 max_compare(s32 v1, s32 v2);
+static s32 min_compare(s32 v1, s32 v2);
 
 struct pm_qos_object {
 	struct requirement_list requirements;
-	struct srcu_notifier_head notifiers;
+	struct blocking_notifier_head *notifiers;
 	struct miscdevice pm_qos_power_miscdev;
 	char *name;
 	s32 default_value;
 	s32 target_value;
 	s32 (*comparitor)(s32, s32);
 };
-static struct pm_qos_object pm_qos_array[PM_QOS_NUM_CLASSES];
+
+static struct pm_qos_object null_pm_qos;
+static BLOCKING_NOTIFIER_HEAD(cpu_dma_lat_notifier);
+static struct pm_qos_object cpu_dma_pm_qos = {
+	.requirements = {LIST_HEAD_INIT(cpu_dma_pm_qos.requirements.list)},
+	.notifiers = &cpu_dma_lat_notifier,
+	.name = "cpu_dma_latency",
+	.default_value = 2000 * USEC_PER_SEC,
+	.target_value = 2000 * USEC_PER_SEC,
+	.comparitor = min_compare
+};
+
+static BLOCKING_NOTIFIER_HEAD(network_lat_notifier);
+static struct pm_qos_object network_lat_pm_qos = {
+	.requirements = {LIST_HEAD_INIT(network_lat_pm_qos.requirements.list)},
+	.notifiers = &network_lat_notifier,
+	.name = "network_latency",
+	.default_value = 2000 * USEC_PER_SEC,
+	.target_value = 2000 * USEC_PER_SEC,
+	.comparitor = min_compare
+};
+
+
+static BLOCKING_NOTIFIER_HEAD(network_throughput_notifier);
+static struct pm_qos_object network_throughput_pm_qos = {
+	.requirements =
+		{LIST_HEAD_INIT(network_throughput_pm_qos.requirements.list)},
+	.notifiers = &network_throughput_notifier,
+	.name = "network_throughput",
+	.default_value = 0,
+	.target_value = 0,
+	.comparitor = max_compare
+};
+
+
+static struct pm_qos_object *pm_qos_array[] = {
+	&null_pm_qos,
+	&cpu_dma_pm_qos,
+	&network_lat_pm_qos,
+	&network_throughput_pm_qos
+};
+
 static DEFINE_SPINLOCK(pm_qos_lock);
 
 static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
@@ -81,29 +134,31 @@
 	return min(v1, v2);
 }
 
+
+
 /* assumes pm_qos_lock is held */
 static void update_target(int target)
 {
 	s32 extreme_value;
 	struct requirement_list *node;
 
-	extreme_value = pm_qos_array[target].default_value;
+	extreme_value = pm_qos_array[target]->default_value;
 	list_for_each_entry(node,
-			&pm_qos_array[target].requirements.list, list) {
-		extreme_value = pm_qos_array[target].comparitor(
+			&pm_qos_array[target]->requirements.list, list) {
+		extreme_value = pm_qos_array[target]->comparitor(
 				extreme_value, node->value);
 	}
-	if (pm_qos_array[target].target_value != extreme_value) {
-		pm_qos_array[target].target_value = extreme_value;
+	if (pm_qos_array[target]->target_value != extreme_value) {
+		pm_qos_array[target]->target_value = extreme_value;
 		pr_debug(KERN_ERR "new target for qos %d is %d\n", target,
-			pm_qos_array[target].target_value);
-		srcu_notifier_call_chain(&pm_qos_array[target].notifiers,
-			(unsigned long) pm_qos_array[target].target_value,
+			pm_qos_array[target]->target_value);
+		blocking_notifier_call_chain(pm_qos_array[target]->notifiers,
+			(unsigned long) pm_qos_array[target]->target_value,
 						NULL);
 	}
 }
 
-static int register_new_pm_qos_misc(struct pm_qos_object *qos)
+static int register_pm_qos_misc(struct pm_qos_object *qos)
 {
 	qos->pm_qos_power_miscdev.minor = MISC_DYNAMIC_MINOR;
 	qos->pm_qos_power_miscdev.name = qos->name;
@@ -112,38 +167,6 @@
 	return misc_register(&qos->pm_qos_power_miscdev);
 }
 
-
-/* constructors */
-static int init_pm_qos_object(int pm_qos_class, const char *name,
-			s32 default_value, s32 (*comparitor)(s32, s32))
-{
-	int ret = -ENOMEM;
-	struct pm_qos_object *qos = NULL;
-
-	if (pm_qos_class < PM_QOS_NUM_CLASSES) {
-		qos = &pm_qos_array[pm_qos_class];
-		qos->name = kstrdup(name, GFP_KERNEL);
-		if (!qos->name)
-			goto cleanup;
-
-		qos->default_value = default_value;
-		qos->target_value = default_value;
-		qos->comparitor = comparitor;
-		srcu_init_notifier_head(&qos->notifiers);
-		INIT_LIST_HEAD(&qos->requirements.list);
-		ret = register_new_pm_qos_misc(qos);
-		if (ret < 0)
-			goto cleanup;
-	} else
-		ret = -EINVAL;
-
-	return ret;
-cleanup:
-	kfree(qos->name);
-
-	return ret;
-}
-
 static int find_pm_qos_object_by_minor(int minor)
 {
 	int pm_qos_class;
@@ -151,24 +174,12 @@
 	for (pm_qos_class = 0;
 		pm_qos_class < PM_QOS_NUM_CLASSES; pm_qos_class++) {
 		if (minor ==
-			pm_qos_array[pm_qos_class].pm_qos_power_miscdev.minor)
+			pm_qos_array[pm_qos_class]->pm_qos_power_miscdev.minor)
 			return pm_qos_class;
 	}
 	return -1;
 }
 
-static int new_latency_qos(int pm_qos_class, const char *name)
-{
-	return init_pm_qos_object(pm_qos_class, name, 2000 * USEC_PER_SEC,
-			min_compare);
-	/* 2000 sec is about infinite */
-}
-
-static int new_throughput_qos(int pm_qos_class, const char *name)
-{
-	return init_pm_qos_object(pm_qos_class, name, 0, max_compare);
-}
-
 /**
  * pm_qos_requirement - returns current system wide qos expectation
  * @pm_qos_class: identification of which qos value is requested
@@ -181,7 +192,7 @@
 	unsigned long flags;
 
 	spin_lock_irqsave(&pm_qos_lock, flags);
-	ret_val = pm_qos_array[pm_qos_class].target_value;
+	ret_val = pm_qos_array[pm_qos_class]->target_value;
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	return ret_val;
@@ -206,7 +217,7 @@
 	dep = kzalloc(sizeof(struct requirement_list), GFP_KERNEL);
 	if (dep) {
 		if (value == PM_QOS_DEFAULT_VALUE)
-			dep->value = pm_qos_array[pm_qos_class].default_value;
+			dep->value = pm_qos_array[pm_qos_class]->default_value;
 		else
 			dep->value = value;
 		dep->name = kstrdup(name, GFP_KERNEL);
@@ -215,7 +226,7 @@
 
 		spin_lock_irqsave(&pm_qos_lock, flags);
 		list_add(&dep->list,
-			&pm_qos_array[pm_qos_class].requirements.list);
+			&pm_qos_array[pm_qos_class]->requirements.list);
 		update_target(pm_qos_class);
 		spin_unlock_irqrestore(&pm_qos_lock, flags);
 
@@ -247,11 +258,11 @@
 
 	spin_lock_irqsave(&pm_qos_lock, flags);
 	list_for_each_entry(node,
-		&pm_qos_array[pm_qos_class].requirements.list, list) {
+		&pm_qos_array[pm_qos_class]->requirements.list, list) {
 		if (strcmp(node->name, name) == 0) {
 			if (new_value == PM_QOS_DEFAULT_VALUE)
 				node->value =
-				pm_qos_array[pm_qos_class].default_value;
+				pm_qos_array[pm_qos_class]->default_value;
 			else
 				node->value = new_value;
 			pending_update = 1;
@@ -283,7 +294,7 @@
 
 	spin_lock_irqsave(&pm_qos_lock, flags);
 	list_for_each_entry(node,
-		&pm_qos_array[pm_qos_class].requirements.list, list) {
+		&pm_qos_array[pm_qos_class]->requirements.list, list) {
 		if (strcmp(node->name, name) == 0) {
 			kfree(node->name);
 			list_del(&node->list);
@@ -312,8 +323,8 @@
 	int retval;
 
 	spin_lock_irqsave(&pm_qos_lock, flags);
-	retval = srcu_notifier_chain_register(
-			&pm_qos_array[pm_qos_class].notifiers, notifier);
+	retval = blocking_notifier_chain_register(
+			pm_qos_array[pm_qos_class]->notifiers, notifier);
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	return retval;
@@ -334,8 +345,8 @@
 	int retval;
 
 	spin_lock_irqsave(&pm_qos_lock, flags);
-	retval = srcu_notifier_chain_unregister(
-			&pm_qos_array[pm_qos_class].notifiers, notifier);
+	retval = blocking_notifier_chain_unregister(
+			pm_qos_array[pm_qos_class]->notifiers, notifier);
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	return retval;
@@ -395,18 +406,18 @@
 static int __init pm_qos_power_init(void)
 {
 	int ret = 0;
-	ret = new_latency_qos(PM_QOS_CPU_DMA_LATENCY, "cpu_dma_latency");
+
+	ret = register_pm_qos_misc(&cpu_dma_pm_qos);
 	if (ret < 0) {
 		printk(KERN_ERR "pm_qos_param: cpu_dma_latency setup failed\n");
 		return ret;
 	}
-	ret = new_latency_qos(PM_QOS_NETWORK_LATENCY, "network_latency");
+	ret = register_pm_qos_misc(&network_lat_pm_qos);
 	if (ret < 0) {
 		printk(KERN_ERR "pm_qos_param: network_latency setup failed\n");
 		return ret;
 	}
-	ret = new_throughput_qos(PM_QOS_NETWORK_THROUGHPUT,
-			"network_throughput");
+	ret = register_pm_qos_misc(&network_throughput_pm_qos);
 	if (ret < 0)
 		printk(KERN_ERR
 			"pm_qos_param: network_throughput setup failed\n");

