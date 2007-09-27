Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbXI0Akw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbXI0Akw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 20:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbXI0Ako
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 20:40:44 -0400
Received: from mga10.intel.com ([192.55.52.92]:62814 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751831AbXI0Akn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 20:40:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,200,1188802800"; 
   d="scan'208";a="154142799"
Date: Wed, 26 Sep 2007 17:40:20 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS params patch
Message-ID: <20070927004020.GB29906@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20070926223712.GA22029@linux.intel.com> <20070926224026.GA23218@linux.intel.com> <20070926164159.3b43479b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926164159.3b43479b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 04:41:59PM -0700, Randy Dunlap wrote:
> On Wed, 26 Sep 2007 15:40:26 -0700 Mark Gross wrote:
> 
> > The following is the qos_param patch that implements a genralization of
> > latency.c.
> > 
> 
> Just some general comments (as on irc):
> 
> - use 'diffstat -p1 -w70' to summarize each patch
> - use checkpatch.pl to check for coding style and other buglets

done

> - has no API docs  :(
not done yet.
> 
> 
> 
> 
> > +/* assumes qos_lock is held */
> > +static void update_target(int i)
> 
> I'd prefer a better arg name than 'i'.

I do too, but i in this case is an Index.

> > +{
> 
> ---
> ~Randy
> Phaedrus says that Quality is about caring.

updated patch:

Signed-off-by: mark gross <mgross@linux.intel.com>
 Makefile           |    2 
 linux/qos_params.h |   35 +++++
 qos_params.c       |  354 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 390 insertions(+), 1 deletion(-)



diff -urN -X linux-2.6.23-rc8/Documentation/dontdiff linux-2.6.23-rc8/include/linux/qos_params.h linux-2.6.23-rc8-qos/include/linux/qos_params.h
--- linux-2.6.23-rc8/include/linux/qos_params.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.23-rc8-qos/include/linux/qos_params.h	2007-09-26 14:05:20.000000000 -0700
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
+		};
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
+++ linux-2.6.23-rc8-qos/kernel/qos_params.c	2007-09-26 17:09:44.000000000 -0700
@@ -0,0 +1,354 @@
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
+	if (v1 < v2)
+		return v2;
+	else
+		return v1;
+}
+
+static s32 min_compare(s32 v1, s32 v2)
+{
+	if (v1 < v2)
+		return v1;
+	else
+		return v2;
+}
+
+/* assumes qos_lock is held */
+static void update_target(int i)
+{
+	s32 extreme_value;
+	struct requirement_list *node;
+
+	extreme_value = qos_array[i].default_value;
+	list_for_each_entry(node, &qos_array[i].requirements.list, list) {
+		extreme_value = qos_array[i].comparitor(
+				extreme_value, node->value);
+	}
+	if (qos_array[i].target_value != extreme_value) {
+		qos_array[i].target_value = extreme_value;
+		printk(KERN_ERR "new target for qos %d is %d\n", i,
+			qos_array[i].target_value);
+		srcu_notifier_call_chain(&qos_array[i].notifiers,
+			(unsigned long) qos_array[i].target_value, NULL);
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
+	ret = misc_register(& qos->qos_power_miscdev);
+	if (ret < 0)
+		printk(KERN_ERR "qos_power: misc_register returns %d.\n", ret);
+
+	return ret;
+}
+
+
+/* constructors */
+static void init_qos_object(int i, const char *name, s32 default_value,
+	s32 (*comparitor)(s32, s32))
+{
+	struct qos_object *qos = NULL;
+
+	if (i < QOS_NUM_CLASSES) {
+		qos = &qos_array[i];
+		qos->name = kstrdup(name, GFP_KERNEL);
+		if (!qos->name)
+			goto cleanup;
+
+		qos->default_value = default_value;
+		qos->target_value = default_value;
+		qos->comparitor = comparitor;
+		srcu_init_notifier_head(&qos->notifiers);
+		INIT_LIST_HEAD(&qos->requirements.list);
+		if (register_new_qos_misc(qos) < 0)
+			goto cleanup;
+	}
+	return;
+cleanup:
+	kfree(qos->name);
+}
+
+static int find_qos_object_by_minor(int minor)
+{
+	int i;
+
+	for (i = 0; i < QOS_NUM_CLASSES; i++) {
+		if (minor == qos_array[i].qos_power_miscdev.minor)
+			return i;
+	}
+	return -1;
+}
+
+static void new_latency_qos(int i, const char *name)
+{
+	init_qos_object(i, name, 2000 * USEC_PER_SEC, min_compare);
+	/* 2000 sec is about infinite */
+}
+
+static void new_throughput_qos(int i, const char *name)
+{
+	init_qos_object(i, name, 0, max_compare);
+}
+
+/* accessors: */
+
+int qos_requirement(int i)
+{
+	int ret_val;
+	unsigned long flags;
+	spin_lock_irqsave(&qos_lock, flags);
+
+	ret_val = qos_array[i].target_value;
+	spin_unlock_irqrestore(&qos_lock, flags);
+
+	return ret_val;
+}
+EXPORT_SYMBOL_GPL(qos_requirement);
+
+
+int qos_add_requirement(int i, char *name, s32 value)
+{
+	struct requirement_list *dep;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qos_lock, flags);
+	dep = kzalloc(sizeof(struct requirement_list), GFP_KERNEL);
+	if (dep) {
+		if (value == QOS_DEFAULT_VALUE)
+			dep->value = qos_array[i].default_value;
+		else
+			dep->value = value;
+		dep->name = kstrdup(name, GFP_KERNEL);
+		if (!dep->name)
+			goto cleanup;
+
+		list_add(&dep->list, &qos_array[i].requirements.list);
+		update_target(i);
+		spin_unlock_irqrestore(&qos_lock, flags);
+
+		return 0;
+	}
+	spin_unlock_irqrestore(&qos_lock, flags);
+
+cleanup:
+	kfree(dep);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(qos_add_requirement);
+
+
+int qos_update_requirement(int i, char *name, s32 new_value)
+{
+	unsigned long flags;
+	struct requirement_list *node;
+	int pending_update = 0;
+
+	spin_lock_irqsave(&qos_lock, flags);
+	list_for_each_entry(node, &qos_array[i].requirements.list, list) {
+		if (strcmp(node->name, name) == 0) {
+			if (new_value == QOS_DEFAULT_VALUE)
+				node->value = qos_array[i].default_value;
+			else
+				node->value = new_value;
+			pending_update = 1;
+			break;
+		}
+	}
+	if (pending_update)
+		update_target(i);
+
+	spin_unlock_irqrestore(&qos_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qos_update_requirement);
+
+void qos_remove_requirement(int i, char *name)
+{
+	unsigned long flags;
+	struct requirement_list *node;
+	int pending_update = 0;
+
+	spin_lock_irqsave(&qos_lock, flags);
+	list_for_each_entry(node, &qos_array[i].requirements.list, list) {
+		if (strcmp(node->name, name) == 0) {
+			kfree(node->name);
+			list_del(&node->list);
+			kfree(node);
+			pending_update = 1;
+			break;
+		}
+	}
+	if (pending_update)
+		update_target(i);
+	spin_unlock_irqrestore(&qos_lock, flags);
+}
+EXPORT_SYMBOL_GPL(qos_remove_requirement);
+
+int qos_add_notifier(int i, struct notifier_block *notifier)
+{
+	unsigned long flags;
+	int retval;
+
+	spin_lock_irqsave(&qos_lock, flags);
+	retval = srcu_notifier_chain_register(&qos_array[i].notifiers,
+			notifier);
+	spin_unlock_irqrestore(&qos_lock, flags);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(qos_add_notifier);
+
+int qos_remove_notifier(int i, struct notifier_block *notifier)
+{
+	unsigned long flags;
+	int retval;
+
+	spin_lock_irqsave(&qos_lock, flags);
+	retval = srcu_notifier_chain_unregister(&qos_array[i].notifiers,
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
+	int i;
+
+	i = find_qos_object_by_minor(iminor(inode));
+	if (i >= 0) {
+		filp->private_data = (void *) i;
+		sprintf(name, "process_%d", current->pid);
+		ret = qos_add_requirement(i, name, QOS_DEFAULT_VALUE);
+		if (ret >= 0)
+			return 0;
+	}
+
+	return -EPERM;
+}
+
+static int qos_power_release(struct inode *inode, struct file *filp)
+{
+	int qos;
+
+	qos = (int) filp->private_data;
+	sprintf(name, "process_%d", current->pid);
+	qos_remove_requirement(qos, name);
+
+	return 0;
+}
+
+static ssize_t qos_power_write(struct file *filp, const char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	s32 value;
+	int qos;
+
+	qos = (int) filp->private_data;
+	if (count != sizeof(s32))
+		return -EINVAL;
+	if (copy_from_user(&value, buf, sizeof(s32)))
+		return -EFAULT;
+	sprintf(name, "process_%d", current->pid);
+	qos_update_requirement(qos, name, value);
+
+	return  sizeof(s32);
+}
+
+
+static int __init qos_power_init(void)
+{
+	new_latency_qos(QOS_CPU_DMA_LATENCY, "cpu_dma_latency");
+	new_latency_qos(QOS_NETWORK_LATENCY, "network_latency");
+	new_throughput_qos(QOS_NETWORK_THROUGHPUT, "network_throughput");
+
+	return 0;
+}
+
+late_initcall(qos_power_init);
