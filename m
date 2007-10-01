Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbXJAXri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbXJAXri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 19:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbXJAXrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 19:47:21 -0400
Received: from mga07.intel.com ([143.182.124.22]:45048 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753152AbXJAXrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 19:47:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,218,1188802800"; 
   d="scan'208";a="290712789"
Date: Mon, 1 Oct 2007 16:45:28 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
Cc: mark.gross@intel.com
Subject: [PATCH] PM_QOS 1 of 2
Message-ID: <20071001234528.GA5238@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following is the cleaned up patch implementing the power management
quality of service infrastructure discussed at the pm summit last June.

It is a genralization of the latency code put into the kernel last year
by Arjan.

I would like to get this code included in the MM tree and to get some
milage on it.

One thing to note about this implementation is that it exposes an
interface to user space for registering pm_qos constraints in addition
to the kernel exports.  Its a file based interface where a module can
register a constraint and the constraint is valid only as long as the
device node is held open.  Upon closing of the device node that
constraint is cleaned up.

The patch set is in two postings.  
1) the base parameter code (this email)
2) replacing of latency.c/latenc.h with pm_qos_params.c/pm_qos_params.h


thanks,

--mgross


Signed-off-by: mark gross <mgross@linux.intel.com>

-----------

diff -urN -X linux-2.6.23-rc8/Documentation/dontdiff linux-2.6.23-rc8/include/linux/pm_qos_params.h linux-2.6.23-rc8-qos/include/linux/pm_qos_params.h
--- linux-2.6.23-rc8/include/linux/pm_qos_params.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.23-rc8-qos/include/linux/pm_qos_params.h	2007-10-01 11:19:13.000000000 -0700
@@ -0,0 +1,35 @@
+/* interface for the pm_qos_power infrastructure of the linux kernel.
+ *
+ * Mark Gross
+ */
+#include <linux/list.h>
+#include <linux/notifier.h>
+#include <linux/miscdevice.h>
+
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
+#define PM_QOS_RESERVED 0
+#define PM_QOS_CPU_DMA_LATENCY 1
+#define PM_QOS_NETWORK_LATENCY 2
+#define PM_QOS_NETWORK_THROUGHPUT 3
+
+#define PM_QOS_NUM_CLASSES 4
+#define PM_QOS_DEFAULT_VALUE -1
+
+int pm_qos_add_requirement(int qos, char *name, s32 value);
+int pm_qos_update_requirement(int qos, char *name, s32 new_value);
+void pm_qos_remove_requirement(int qos, char *name);
+
+int pm_qos_requirement(int qos);
+
+int pm_qos_add_notifier(int qos, struct notifier_block *notifier);
+int pm_qos_remove_notifier(int qos, struct notifier_block *notifier);
+
diff -urN -X linux-2.6.23-rc8/Documentation/dontdiff linux-2.6.23-rc8/kernel/Makefile linux-2.6.23-rc8-qos/kernel/Makefile
--- linux-2.6.23-rc8/kernel/Makefile	2007-09-26 13:54:54.000000000 -0700
+++ linux-2.6.23-rc8-qos/kernel/Makefile	2007-10-01 11:13:35.000000000 -0700
@@ -9,7 +9,7 @@
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o die_notifier.o \
-	    utsname.o
+	    utsname.o pm_qos_params.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
diff -urN -X linux-2.6.23-rc8/Documentation/dontdiff linux-2.6.23-rc8/kernel/pm_qos_params.c linux-2.6.23-rc8-qos/kernel/pm_qos_params.c
--- linux-2.6.23-rc8/kernel/pm_qos_params.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.23-rc8-qos/kernel/pm_qos_params.c	2007-10-01 16:03:31.000000000 -0700
@@ -0,0 +1,417 @@
+/*
+ * This module exposes the interface to kernel space for specifying
+ * QoS dependencies.  It provides infrastructure for registration of:
+ *
+ * Dependents on a QoS value : register requirements
+ * Watchers of QoS value : get notified when target QoS value changes
+ *
+ * This QoS design is best effort based.  Dependents register their QoS needs.
+ * Watchers register to keep track of the current QoS needs of the system.
+ *
+ * There are 3 basic classes of QoS parameter: latency, timeout, throughput
+ * each have defined units:
+ * latency: usec
+ * timeout: usec <-- currently not used.
+ * throughput: kbs (kilo byte / sec)
+ *
+ * There are lists of pm_qos_objects each one wrapping requirements, notifiers
+ *
+ * User mode requirements on a QOS parameter register themselves to the
+ * subsystem by opening the device node /dev/... and writing there request to
+ * the node.  As long as the process holds a file handle open to the node the
+ * client continues to be accounted for.  Upon file release the usermode
+ * requirement is removed and a new qos target is computed.  This way when the
+ * requirement that the application has is cleaned up when closes the file
+ * pointer or exits the pm_qos_object will get an opportunity to clean up.
+ *
+ * mark gross mgross@linux.intel.com
+ */
+
+#include <linux/pm_qos_params.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+#include <linux/fs.h>
+#include <linux/device.h>
+#include <linux/miscdevice.h>
+#include <linux/string.h>
+#include <linux/platform_device.h>
+#include <linux/init.h>
+
+#include <linux/uaccess.h>
+
+/*
+ * locking rule: all changes to target_value or requirements or notifiers lists
+ * or pm_qos_object list and pm_qos_objects need to happen with pm_qos_lock
+ * held, taken with _irqsave.  One lock to rule them all
+ */
+
+struct pm_qos_object {
+	struct requirement_list requirements;
+	struct srcu_notifier_head notifiers;
+	struct miscdevice pm_qos_power_miscdev;
+	char *name;
+	s32 default_value;
+	s32 target_value;
+	s32 (*comparitor)(s32, s32);
+};
+static struct pm_qos_object pm_qos_array[PM_QOS_NUM_CLASSES];
+static DEFINE_SPINLOCK(pm_qos_lock);
+
+static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
+		size_t count, loff_t *f_pos);
+static int pm_qos_power_open(struct inode *inode, struct file *filp);
+static int pm_qos_power_release(struct inode *inode, struct file *filp);
+
+static const struct file_operations pm_qos_power_fops = {
+	.write = pm_qos_power_write,
+	.open = pm_qos_power_open,
+	.release = pm_qos_power_release,
+};
+
+/* static helper functions */
+static s32 max_compare(s32 v1, s32 v2)
+{
+	return max(v1, v2);
+}
+
+static s32 min_compare(s32 v1, s32 v2)
+{
+	return min(v1, v2);
+}
+
+/* assumes pm_qos_lock is held */
+static void update_target(int target)
+{
+	s32 extreme_value;
+	struct requirement_list *node;
+
+	extreme_value = pm_qos_array[target].default_value;
+	list_for_each_entry(node,
+			&pm_qos_array[target].requirements.list, list) {
+		extreme_value = pm_qos_array[target].comparitor(
+				extreme_value, node->value);
+	}
+	if (pm_qos_array[target].target_value != extreme_value) {
+		pm_qos_array[target].target_value = extreme_value;
+		pr_debug(KERN_ERR "new target for qos %d is %d\n", target,
+			pm_qos_array[target].target_value);
+		srcu_notifier_call_chain(&pm_qos_array[target].notifiers,
+			(unsigned long) pm_qos_array[target].target_value,
+						NULL);
+	}
+}
+
+static int register_new_pm_qos_misc(struct pm_qos_object *qos)
+{
+	qos->pm_qos_power_miscdev.minor = MISC_DYNAMIC_MINOR;
+	qos->pm_qos_power_miscdev.name = qos->name;
+	qos->pm_qos_power_miscdev.fops = &pm_qos_power_fops;
+
+	return misc_register(&qos->pm_qos_power_miscdev);
+}
+
+
+/* constructors */
+static int init_pm_qos_object(int pm_qos_class, const char *name,
+			s32 default_value, s32 (*comparitor)(s32, s32))
+{
+	int ret = -ENOMEM;
+	struct pm_qos_object *qos = NULL;
+
+	if (pm_qos_class < PM_QOS_NUM_CLASSES) {
+		qos = &pm_qos_array[pm_qos_class];
+		qos->name = kstrdup(name, GFP_KERNEL);
+		if (!qos->name)
+			goto cleanup;
+
+		qos->default_value = default_value;
+		qos->target_value = default_value;
+		qos->comparitor = comparitor;
+		srcu_init_notifier_head(&qos->notifiers);
+		INIT_LIST_HEAD(&qos->requirements.list);
+		ret = register_new_pm_qos_misc(qos);
+		if (ret < 0)
+			goto cleanup;
+	} else
+		ret = -EINVAL;
+
+	return ret;
+cleanup:
+	kfree(qos->name);
+
+	return ret;
+}
+
+static int find_pm_qos_object_by_minor(int minor)
+{
+	int pm_qos_class;
+
+	for (pm_qos_class = 0;
+		pm_qos_class < PM_QOS_NUM_CLASSES; pm_qos_class++) {
+		if (minor ==
+			pm_qos_array[pm_qos_class].pm_qos_power_miscdev.minor)
+			return pm_qos_class;
+	}
+	return -1;
+}
+
+static int new_latency_qos(int pm_qos_class, const char *name)
+{
+	return init_pm_qos_object(pm_qos_class, name, 2000 * USEC_PER_SEC,
+			min_compare);
+	/* 2000 sec is about infinite */
+}
+
+static int new_throughput_qos(int pm_qos_class, const char *name)
+{
+	return init_pm_qos_object(pm_qos_class, name, 0, max_compare);
+}
+
+/**
+ * pm_qos_requirement - returns current system wide qos expectation
+ * @pm_qos_class: identification of which qos value is requested
+ *
+ * This function returns the current target value in an atomic manner.
+ */
+int pm_qos_requirement(int pm_qos_class)
+{
+	int ret_val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pm_qos_lock, flags);
+	ret_val = pm_qos_array[pm_qos_class].target_value;
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+
+	return ret_val;
+}
+EXPORT_SYMBOL_GPL(pm_qos_requirement);
+
+/**
+ * pm_qos_add_requirement - inserts new qos request into the list
+ * @pm_qos_class: identifies which list of qos request to us
+ * @name: identifies the request
+ * @value: defines the qos request
+ *
+ * This function inserts a new entry in the pm_qos_class list of requested qos
+ * performance charactoistics.  It recomputes the agregate QoS expectations for
+ * the pm_qos_class of parrameters.
+ */
+int pm_qos_add_requirement(int pm_qos_class, char *name, s32 value)
+{
+	struct requirement_list *dep;
+	unsigned long flags;
+
+	dep = kzalloc(sizeof(struct requirement_list), GFP_KERNEL);
+	if (dep) {
+		if (value == PM_QOS_DEFAULT_VALUE)
+			dep->value = pm_qos_array[pm_qos_class].default_value;
+		else
+			dep->value = value;
+		dep->name = kstrdup(name, GFP_KERNEL);
+		if (!dep->name)
+			goto cleanup;
+
+		spin_lock_irqsave(&pm_qos_lock, flags);
+		list_add(&dep->list,
+			&pm_qos_array[pm_qos_class].requirements.list);
+		update_target(pm_qos_class);
+		spin_unlock_irqrestore(&pm_qos_lock, flags);
+
+		return 0;
+	}
+
+cleanup:
+	kfree(dep);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(pm_qos_add_requirement);
+
+/**
+ * pm_qos_update_requirement - modifies an existing qos request
+ * @pm_qos_class: identifies which list of qos request to us
+ * @name: identifies the request
+ * @value: defines the qos request
+ *
+ * Updates an existing qos requierement for the pm_qos_class of parameters along
+ * with updating the target pm_qos_class value.
+ *
+ * If the named request isn't in the lest then no change is made.
+ */
+int pm_qos_update_requirement(int pm_qos_class, char *name, s32 new_value)
+{
+	unsigned long flags;
+	struct requirement_list *node;
+	int pending_update = 0;
+
+	spin_lock_irqsave(&pm_qos_lock, flags);
+	list_for_each_entry(node,
+		&pm_qos_array[pm_qos_class].requirements.list, list) {
+		if (strcmp(node->name, name) == 0) {
+			if (new_value == PM_QOS_DEFAULT_VALUE)
+				node->value =
+				pm_qos_array[pm_qos_class].default_value;
+			else
+				node->value = new_value;
+			pending_update = 1;
+			break;
+		}
+	}
+	if (pending_update)
+		update_target(pm_qos_class);
+
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pm_qos_update_requirement);
+
+/**
+ * pm_qos_remove_requirement - modifies an existing qos request
+ * @pm_qos_class: identifies which list of qos request to us
+ * @name: identifies the request
+ *
+ * Will remove named qos request from pm_qos_class list of parrameters and
+ * recompute the current target value for the pm_qos_class.
+ */
+void pm_qos_remove_requirement(int pm_qos_class, char *name)
+{
+	unsigned long flags;
+	struct requirement_list *node;
+	int pending_update = 0;
+
+	spin_lock_irqsave(&pm_qos_lock, flags);
+	list_for_each_entry(node,
+		&pm_qos_array[pm_qos_class].requirements.list, list) {
+		if (strcmp(node->name, name) == 0) {
+			kfree(node->name);
+			list_del(&node->list);
+			kfree(node);
+			pending_update = 1;
+			break;
+		}
+	}
+	if (pending_update)
+		update_target(pm_qos_class);
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_qos_remove_requirement);
+
+/**
+ * pm_qos_add_notifier - sets notification entry for changes to target value
+ * @pm_qos_class: identifies which qos target changes should be notified.
+ * @notifier: notifier block managed by caller.
+ *
+ * will register the notifier into a notification chain that gets called
+ * uppon changes to the pm_qos_class target value.
+ */
+ int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
+{
+	unsigned long flags;
+	int retval;
+
+	spin_lock_irqsave(&pm_qos_lock, flags);
+	retval = srcu_notifier_chain_register(
+			&pm_qos_array[pm_qos_class].notifiers, notifier);
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(pm_qos_add_notifier);
+
+/**
+ * pm_qos_remove_notifier - deletes notification entry from chain.
+ * @pm_qos_class: identifies which qos target changes are notified.
+ * @notifier: notifier block to be removed.
+ *
+ * will remove the notifier from the notification chain that gets called
+ * uppon changes to the pm_qos_class target value.
+ */
+int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier)
+{
+	unsigned long flags;
+	int retval;
+
+	spin_lock_irqsave(&pm_qos_lock, flags);
+	retval = srcu_notifier_chain_unregister(
+			&pm_qos_array[pm_qos_class].notifiers, notifier);
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(pm_qos_remove_notifier);
+
+#define PID_NAME_LEN sizeof("process_1234567890")
+static char name[PID_NAME_LEN];
+
+static int pm_qos_power_open(struct inode *inode, struct file *filp)
+{
+	int ret;
+	int pm_qos_class;
+
+	pm_qos_class = find_pm_qos_object_by_minor(iminor(inode));
+	if (pm_qos_class >= 0) {
+		filp->private_data = (void *) pm_qos_class;
+		sprintf(name, "process_%d", current->pid);
+		ret = pm_qos_add_requirement(pm_qos_class, name,
+					PM_QOS_DEFAULT_VALUE);
+		if (ret >= 0)
+			return 0;
+	}
+
+	return -EPERM;
+}
+
+static int pm_qos_power_release(struct inode *inode, struct file *filp)
+{
+	int pm_qos_class;
+
+	pm_qos_class = (int) filp->private_data;
+	sprintf(name, "process_%d", current->pid);
+	pm_qos_remove_requirement(pm_qos_class, name);
+
+	return 0;
+}
+
+static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	s32 value;
+	int pm_qos_class;
+
+	pm_qos_class = (int) filp->private_data;
+	if (count != sizeof(s32))
+		return -EINVAL;
+	if (copy_from_user(&value, buf, sizeof(s32)))
+		return -EFAULT;
+	sprintf(name, "process_%d", current->pid);
+	pm_qos_update_requirement(pm_qos_class, name, value);
+
+	return  sizeof(s32);
+}
+
+
+static int __init pm_qos_power_init(void)
+{
+	int ret = 0;
+	ret = new_latency_qos(PM_QOS_CPU_DMA_LATENCY, "cpu_dma_latency");
+	if (ret < 0) {
+		printk(KERN_ERR "pm_qos_param: cpu_dma_latency setup failed\n");
+		return ret;
+	}
+	ret = new_latency_qos(PM_QOS_NETWORK_LATENCY, "network_latency");
+	if (ret < 0) {
+		printk(KERN_ERR "pm_qos_param: network_latency setup failed\n");
+		return ret;
+	}
+	ret = new_throughput_qos(PM_QOS_NETWORK_THROUGHPUT,
+			"network_throughput");
+	if (ret < 0)
+		printk(KERN_ERR
+			"pm_qos_param: network_throughput setup failed\n");
+
+	return ret;
+}
+
+late_initcall(pm_qos_power_init);
