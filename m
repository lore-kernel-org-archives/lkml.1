Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbXI0USU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbXI0USU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 16:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbXI0USI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 16:18:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:2124 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360AbXI0USG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 16:18:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,204,1188802800"; 
   d="scan'208";a="155144725"
Date: Thu, 27 Sep 2007 13:17:39 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS params patch update.
Message-ID: <20070927201739.GA2831@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20070926223712.GA22029@linux.intel.com> <20070926224026.GA23218@linux.intel.com> <20070927022440.GB25873@linux-sh.org> <20070926210515.6725e745.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926210515.6725e745.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 09:05:15PM -0700, Randy Dunlap wrote:
> On Thu, 27 Sep 2007 11:24:40 +0900 Paul Mundt wrote:
> 
> > > +/* static helper functions */
> > > +static s32 max_compare(s32 v1, s32 v2)
> > > +{
> > > +	if (v1 < v2)
> > > +		return v2;
> > > +	else
> > > +		return v1;
> > > +}
> > > +
> > > +static s32 min_compare(s32 v1, s32 v2)
> > > +{
> > > +	if (v1 < v2)
> > > +		return v1;
> > > +	else
> > > +		return v2;
> > > +}
> > > +
> > min()/max() instead?
> 
> Other code wants function pointers to the min & max functions.
> That's why they are here AFAICT.
> 
> 
> > > +/* assumes qos_lock is held */
> > > +static void update_target(int i)
> > > +{
> > 'target' might be a more meaningful variable name.
> 
> Anything but 'i'.
> 
> ---


Updated qos PM parameter patch:
Note: the replacing of latency.c with this is a separate patch.

this patch attempts to address the issues raised so far.

--mgross



Signed-off-by: mark gross <mgross@linux.intel.com>

mgross@mgross-t43:~/workstuff/power_qos$ diffstat -p1 qos_params_sept_27.patch 
 include/linux/qos_params.h |   35 +++
 kernel/Makefile            |    2 
 kernel/qos_params.c        |  413 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 449 insertions(+), 1 deletion(-)


diff -urN -X linux-2.6.23-rc8/Documentation/dontdiff linux-2.6.23-rc8/include/linux/qos_params.h linux-2.6.23-rc8-qos/include/linux/qos_params.h
--- linux-2.6.23-rc8/include/linux/qos_params.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.23-rc8-qos/include/linux/qos_params.h	2007-09-27 08:42:54.000000000 -0700
@@ -0,0 +1,35 @@
+/* interface for the qos_power infrastructure of the linux kernel.
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
+#define QOS_RESERVED 0
+#define QOS_CPU_DMA_LATENCY 1
+#define QOS_NETWORK_LATENCY 2
+#define QOS_NETWORK_THROUGHPUT 3
+
+#define QOS_NUM_CLASSES 4
+#define QOS_DEFAULT_VALUE -1
+
+int qos_add_requirement(int qos, char *name, s32 value);
+int qos_update_requirement(int qos, char *name, s32 new_value);
+void qos_remove_requirement(int qos, char *name);
+
+int qos_requirement(int qos);
+
+int qos_add_notifier(int qos, struct notifier_block *notifier);
+int qos_remove_notifier(int qos, struct notifier_block *notifier);
+
diff -urN -X linux-2.6.23-rc8/Documentation/dontdiff linux-2.6.23-rc8/kernel/Makefile linux-2.6.23-rc8-qos/kernel/Makefile
--- linux-2.6.23-rc8/kernel/Makefile	2007-09-26 13:54:54.000000000 -0700
+++ linux-2.6.23-rc8-qos/kernel/Makefile	2007-09-26 14:06:38.000000000 -0700
@@ -9,7 +9,7 @@
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o die_notifier.o \
-	    utsname.o
+	    utsname.o qos_params.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
diff -urN -X linux-2.6.23-rc8/Documentation/dontdiff linux-2.6.23-rc8/kernel/qos_params.c linux-2.6.23-rc8-qos/kernel/qos_params.c
--- linux-2.6.23-rc8/kernel/qos_params.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.23-rc8-qos/kernel/qos_params.c	2007-09-27 12:46:13.000000000 -0700
@@ -0,0 +1,413 @@
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
+ * There are lists of qos_objects each one wrapping requirements, notifiers
+ *
+ * User mode requirements on a QOS parameter register themselves to the
+ * subsystem by opening the device node /dev/... and writing there request to
+ * the node.  As long as the process holds a file handle open to the node the
+ * client continues to be accounted for.  Upon file release the usermode
+ * requirement is removed and a new qos target is computed.  This way when the
+ * requirement that the application has is cleaned up when closes the file
+ * pointer or exits the qos_object will get an opportunity to clean up.
+ *
+ * mark gross mgross@linux.intel.com
+ */
+
+#include <linux/qos_params.h>
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
+ * or qos_object list and qos_objects need to happen with qos_lock held, taken
+ * with _irqsave.  One lock to rule them all
+ */
+
+struct qos_object {
+	struct requirement_list requirements;
+	struct srcu_notifier_head notifiers;
+	struct miscdevice qos_power_miscdev;
+	char *name;
+	s32 default_value;
+	s32 target_value;
+	s32 (*comparitor)(s32, s32);
+};
+static struct qos_object qos_array[QOS_NUM_CLASSES];
+static DEFINE_SPINLOCK(qos_lock);
+
+static ssize_t qos_power_write(struct file *filp, const char __user *buf,
+		size_t count, loff_t *f_pos);
+static int qos_power_open(struct inode *inode, struct file *filp);
+static int qos_power_release(struct inode *inode, struct file *filp);
+
+static const struct file_operations qos_power_fops = {
+	.write = qos_power_write,
+	.open = qos_power_open,
+	.release = qos_power_release,
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
+/* assumes qos_lock is held */
+static void update_target(int target)
+{
+	s32 extreme_value;
+	struct requirement_list *node;
+
+	extreme_value = qos_array[target].default_value;
+	list_for_each_entry(node, &qos_array[target].requirements.list, list) {
+		extreme_value = qos_array[target].comparitor(
+				extreme_value, node->value);
+	}
+	if (qos_array[target].target_value != extreme_value) {
+		qos_array[target].target_value = extreme_value;
+		printk(KERN_ERR "new target for qos %d is %d\n", target,
+			qos_array[target].target_value);
+		srcu_notifier_call_chain(&qos_array[target].notifiers,
+			(unsigned long) qos_array[target].target_value, NULL);
+	}
+}
+
+static int register_new_qos_misc(struct qos_object *qos)
+{
+	int ret;
+
+	qos->qos_power_miscdev.minor = MISC_DYNAMIC_MINOR;
+	qos->qos_power_miscdev.name = qos->name;
+	qos->qos_power_miscdev.fops = &qos_power_fops;
+
+	ret = misc_register(&qos->qos_power_miscdev);
+
+	return ret;
+}
+
+
+/* constructors */
+static int init_qos_object(int qos_class, const char *name, s32 default_value,
+	s32 (*comparitor)(s32, s32))
+{
+	int ret = -ENOMEM;
+	struct qos_object *qos = NULL;
+
+	if (qos_class < QOS_NUM_CLASSES) {
+		qos = &qos_array[qos_class];
+		qos->name = kstrdup(name, GFP_KERNEL);
+		if (!qos->name)
+			goto cleanup;
+
+		qos->default_value = default_value;
+		qos->target_value = default_value;
+		qos->comparitor = comparitor;
+		srcu_init_notifier_head(&qos->notifiers);
+		INIT_LIST_HEAD(&qos->requirements.list);
+		ret = register_new_qos_misc(qos);
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
+static int find_qos_object_by_minor(int minor)
+{
+	int qos_class;
+
+	for (qos_class = 0; qos_class < QOS_NUM_CLASSES; qos_class++) {
+		if (minor == qos_array[qos_class].qos_power_miscdev.minor)
+			return qos_class;
+	}
+	return -1;
+}
+
+static int new_latency_qos(int qos_class, const char *name)
+{
+	return init_qos_object(qos_class, name, 2000 * USEC_PER_SEC,
+			min_compare);
+	/* 2000 sec is about infinite */
+}
+
+static int new_throughput_qos(int qos_class, const char *name)
+{
+	return init_qos_object(qos_class, name, 0, max_compare);
+}
+
+/**
+ * qos_requirement - returns current system wide qos expectation
+ * @qos_class: identification of which qos value is requested
+ *
+ * This function returns the current target value in an atomic manner.
+ */
+int qos_requirement(int qos_class)
+{
+	int ret_val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qos_lock, flags);
+	ret_val = qos_array[qos_class].target_value;
+	spin_unlock_irqrestore(&qos_lock, flags);
+
+	return ret_val;
+}
+EXPORT_SYMBOL_GPL(qos_requirement);
+
+/**
+ * qos_add_requirement - inserts new qos request into the list
+ * @qos_class: identifies which list of qos request to us
+ * @name: identifies the request
+ * @value: defines the qos request
+ *
+ * This function inserts a new entry in the qos_class list of requested qos
+ * performance charactoistics.  It recomputes the agregate QoS expectations for
+ * the qos_class of parrameters.
+ */
+int qos_add_requirement(int qos_class, char *name, s32 value)
+{
+	struct requirement_list *dep;
+	unsigned long flags;
+
+	dep = kzalloc(sizeof(struct requirement_list), GFP_KERNEL);
+	if (dep) {
+		if (value == QOS_DEFAULT_VALUE)
+			dep->value = qos_array[qos_class].default_value;
+		else
+			dep->value = value;
+		dep->name = kstrdup(name, GFP_KERNEL);
+		if (!dep->name)
+			goto cleanup;
+
+		spin_lock_irqsave(&qos_lock, flags);
+		list_add(&dep->list, &qos_array[qos_class].requirements.list);
+		update_target(qos_class);
+		spin_unlock_irqrestore(&qos_lock, flags);
+
+		return 0;
+	}
+
+cleanup:
+	kfree(dep);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(qos_add_requirement);
+
+/**
+ * qos_update_requirement - modifies an existing qos request
+ * @qos_class: identifies which list of qos request to us
+ * @name: identifies the request
+ * @value: defines the qos request
+ *
+ * Updates an existing qos requierement for the qos_class of parameters along
+ * with updating the target qos_class value.
+ *
+ * If the named request isn't in the lest then no change is made.
+ */
+int qos_update_requirement(int qos_class, char *name, s32 new_value)
+{
+	unsigned long flags;
+	struct requirement_list *node;
+	int pending_update = 0;
+
+	spin_lock_irqsave(&qos_lock, flags);
+	list_for_each_entry(node,
+		&qos_array[qos_class].requirements.list, list) {
+		if (strcmp(node->name, name) == 0) {
+			if (new_value == QOS_DEFAULT_VALUE)
+				node->value =
+					qos_array[qos_class].default_value;
+			else
+				node->value = new_value;
+			pending_update = 1;
+			break;
+		}
+	}
+	if (pending_update)
+		update_target(qos_class);
+
+	spin_unlock_irqrestore(&qos_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qos_update_requirement);
+
+/**
+ * qos_remove_requirement - modifies an existing qos request
+ * @qos_class: identifies which list of qos request to us
+ * @name: identifies the request
+ *
+ * Will remove named qos request from qos_class list of parrameters and
+ * recompute the current target value for the qos_class.
+ */
+void qos_remove_requirement(int qos_class, char *name)
+{
+	unsigned long flags;
+	struct requirement_list *node;
+	int pending_update = 0;
+
+	spin_lock_irqsave(&qos_lock, flags);
+	list_for_each_entry(node,
+		&qos_array[qos_class].requirements.list, list) {
+		if (strcmp(node->name, name) == 0) {
+			kfree(node->name);
+			list_del(&node->list);
+			kfree(node);
+			pending_update = 1;
+			break;
+		}
+	}
+	if (pending_update)
+		update_target(qos_class);
+	spin_unlock_irqrestore(&qos_lock, flags);
+}
+EXPORT_SYMBOL_GPL(qos_remove_requirement);
+
+/**
+ * qos_add_notifier - sets notification entry for changes to target value
+ * @qos_class: identifies which qos target changes should be notified.
+ * @notifier: notifier block managed by caller.
+ *
+ * will register the notifier into a notification chain that gets called
+ * uppon changes to the qos_class target value.
+ */
+ int qos_add_notifier(int qos_class, struct notifier_block *notifier)
+{
+	unsigned long flags;
+	int retval;
+
+	spin_lock_irqsave(&qos_lock, flags);
+	retval = srcu_notifier_chain_register(&qos_array[qos_class].notifiers,
+			notifier);
+	spin_unlock_irqrestore(&qos_lock, flags);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(qos_add_notifier);
+
+/**
+ * qos_remove_notifier - deletes notification entry from chain.
+ * @qos_class: identifies which qos target changes are notified.
+ * @notifier: notifier block to be removed.
+ *
+ * will remove the notifier from the notification chain that gets called
+ * uppon changes to the qos_class target value.
+ */
+int qos_remove_notifier(int qos_class, struct notifier_block *notifier)
+{
+	unsigned long flags;
+	int retval;
+
+	spin_lock_irqsave(&qos_lock, flags);
+	retval = srcu_notifier_chain_unregister(&qos_array[qos_class].notifiers,
+			notifier);
+	spin_unlock_irqrestore(&qos_lock, flags);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(qos_remove_notifier);
+
+#define PID_NAME_LEN sizeof("process_1234567890")
+static char name[PID_NAME_LEN];
+
+static int qos_power_open(struct inode *inode, struct file *filp)
+{
+	int ret;
+	int qos_class;
+
+	qos_class = find_qos_object_by_minor(iminor(inode));
+	if (qos_class >= 0) {
+		filp->private_data = (void *) qos_class;
+		sprintf(name, "process_%d", current->pid);
+		ret = qos_add_requirement(qos_class, name, QOS_DEFAULT_VALUE);
+		if (ret >= 0)
+			return 0;
+	}
+
+	return -EPERM;
+}
+
+static int qos_power_release(struct inode *inode, struct file *filp)
+{
+	int qos_class;
+
+	qos_class = (int) filp->private_data;
+	sprintf(name, "process_%d", current->pid);
+	qos_remove_requirement(qos_class, name);
+
+	return 0;
+}
+
+static ssize_t qos_power_write(struct file *filp, const char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	s32 value;
+	int qos_class;
+
+	qos_class = (int) filp->private_data;
+	if (count != sizeof(s32))
+		return -EINVAL;
+	if (copy_from_user(&value, buf, sizeof(s32)))
+		return -EFAULT;
+	sprintf(name, "process_%d", current->pid);
+	qos_update_requirement(qos_class, name, value);
+
+	return  sizeof(s32);
+}
+
+
+static int __init qos_power_init(void)
+{
+	int ret = 0;
+	ret = new_latency_qos(QOS_CPU_DMA_LATENCY, "cpu_dma_latency");
+	if (ret < 0) {
+		printk(KERN_ERR "qos_param: cpu_dma_latency setup failed\n");
+		return ret;
+	}
+	ret = new_latency_qos(QOS_NETWORK_LATENCY, "network_latency");
+	if (ret < 0) {
+		printk(KERN_ERR "qos_param: network_latency setup failed\n");
+		return ret;
+	}
+	ret = new_throughput_qos(QOS_NETWORK_THROUGHPUT, "network_throughput");
+	if (ret < 0)
+		printk(KERN_ERR "qos_param: network_throughput setup failed\n");
+
+	return ret;
+}
+
+late_initcall(qos_power_init);
