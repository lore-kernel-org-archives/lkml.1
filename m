Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYDKHyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYDKHyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 03:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbYDKHyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 03:54:32 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:57227 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbYDKHyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:54:31 -0400
Message-ID: <47FF1910.1070001@ah.jp.nec.com>
Date: Fri, 11 Apr 2008 16:53:52 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
CC: kdb@oss.sgi.com, vgoyal@in.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>, nickpiggin@yahoo.com.au,
       Randy Dunlap <rdunlap@xenotime.net>, greg@kroah.com
Subject: [PATCH 1/2] add tunable_notifier function ,take2
References: <47FF0EA5.8090804@ah.jp.nec.com>
In-Reply-To: <47FF0EA5.8090804@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new notifier function tunable_notifier_chain. Its base is
atomic_notifier_chain.

Thanks,

---

Signed-off-by: Takenori Nagano <t-nagano@ah.jp.nec.com>

---
diff -uprN linux-2.6.25-rc8-mm1.orig/include/linux/notifier.h linux-2.6.25-rc8-mm1/include/linux/notifier.h
--- linux-2.6.25-rc8-mm1.orig/include/linux/notifier.h	2008-04-08 16:37:43.700000000 +0900
+++ linux-2.6.25-rc8-mm1/include/linux/notifier.h	2008-04-09 20:01:10.328000000 +0900
@@ -13,6 +13,7 @@
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/srcu.h>
+#include <linux/kobject.h>
 
 /*
  * Notifier chains are of four types:
@@ -53,6 +54,13 @@ struct notifier_block {
 	int priority;
 };
 
+struct tunable_atomic_notifier_block {
+	struct notifier_block *nb;
+	struct tunable_atomic_notifier_head *head;
+	struct kobject kobj;
+	char *desc;
+};
+
 struct atomic_notifier_head {
 	spinlock_t lock;
 	struct notifier_block *head;
@@ -63,6 +71,13 @@ struct blocking_notifier_head {
 	struct notifier_block *head;
 };
 
+struct tunable_atomic_notifier_head {
+	spinlock_t lock;
+	struct notifier_block *head;
+	char *name;
+	struct kset *notifier_sub_kset;
+};
+
 struct raw_notifier_head {
 	struct notifier_block *head;
 };
@@ -73,6 +88,13 @@ struct srcu_notifier_head {
 	struct notifier_block *head;
 };
 
+struct control_file_info {
+	struct tunable_atomic_notifier_head *nh;
+	struct tunable_atomic_notifier_block *n;
+	char *name;
+	struct control_file_info *next;
+};
+
 #define ATOMIC_INIT_NOTIFIER_HEAD(name) do {	\
 		spin_lock_init(&(name)->lock);	\
 		(name)->head = NULL;		\
@@ -81,6 +103,12 @@ struct srcu_notifier_head {
 		init_rwsem(&(name)->rwsem);	\
 		(name)->head = NULL;		\
 	} while (0)
+#define TUNABLE_ATOMIC_INIT_NOTIFIER(val1, val2) do {		\
+		spin_lock_init(&(val1)->lock);			\
+		(val1)->head = NULL;				\
+		(val1)->name = val2;				\
+		(val1)->notifier_sub_kset = NULL;		\
+	} while (0)
 #define RAW_INIT_NOTIFIER_HEAD(name) do {	\
 		(name)->head = NULL;		\
 	} while (0)
@@ -96,6 +124,11 @@ extern void srcu_init_notifier_head(stru
 #define BLOCKING_NOTIFIER_INIT(name) {				\
 		.rwsem = __RWSEM_INITIALIZER((name).rwsem),	\
 		.head = NULL }
+#define TUNABLE_ATOMIC_NOTIFIER_INIT(val1, val2) {		\
+		.lock =__SPIN_LOCK_UNLOCKED(val1.lock),		\
+		.head = NULL,					\
+		.name = val2,					\
+		.notifier_sub_kset = NULL }
 #define RAW_NOTIFIER_INIT(name)	{				\
 		.head = NULL }
 /* srcu_notifier_heads cannot be initialized statically */
@@ -106,6 +139,9 @@ extern void srcu_init_notifier_head(stru
 #define BLOCKING_NOTIFIER_HEAD(name)				\
 	struct blocking_notifier_head name =			\
 		BLOCKING_NOTIFIER_INIT(name)
+#define TUNABLE_ATOMIC_NOTIFIER_HEAD(name, val)			\
+	struct tunable_atomic_notifier_head name =			\
+		TUNABLE_ATOMIC_NOTIFIER_INIT(name, val)
 #define RAW_NOTIFIER_HEAD(name)					\
 	struct raw_notifier_head name =				\
 		RAW_NOTIFIER_INIT(name)
@@ -116,6 +152,10 @@ extern int atomic_notifier_chain_registe
 		struct notifier_block *nb);
 extern int blocking_notifier_chain_register(struct blocking_notifier_head *nh,
 		struct notifier_block *nb);
+extern int tunable_atomic_notifier_chain_register(
+				struct tunable_atomic_notifier_head *nh,
+				struct tunable_atomic_notifier_block *nb,
+				char *name, char *desc);
 extern int raw_notifier_chain_register(struct raw_notifier_head *nh,
 		struct notifier_block *nb);
 extern int srcu_notifier_chain_register(struct srcu_notifier_head *nh,
@@ -129,6 +169,9 @@ extern int atomic_notifier_chain_unregis
 		struct notifier_block *nb);
 extern int blocking_notifier_chain_unregister(struct blocking_notifier_head *nh,
 		struct notifier_block *nb);
+extern int tunable_atomic_notifier_chain_unregister(
+				struct tunable_atomic_notifier_head *nh,
+				struct tunable_atomic_notifier_block *nb);
 extern int raw_notifier_chain_unregister(struct raw_notifier_head *nh,
 		struct notifier_block *nb);
 extern int srcu_notifier_chain_unregister(struct srcu_notifier_head *nh,
@@ -142,6 +185,14 @@ extern int blocking_notifier_call_chain(
 		unsigned long val, void *v);
 extern int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 	unsigned long val, void *v, int nr_to_call, int *nr_calls);
+extern int tunable_atomic_notifier_call_chain(
+				struct tunable_atomic_notifier_head *nh,
+				unsigned long val, void *v);
+extern int __tunable_atomic_notifier_call_chain(
+				struct tunable_atomic_notifier_head *nh,
+				unsigned long val,  void *v,
+				int nr_to_call, int *nr_calls);
+extern int tunable_atomic_notifier_init(void);
 extern int raw_notifier_call_chain(struct raw_notifier_head *nh,
 		unsigned long val, void *v);
 extern int __raw_notifier_call_chain(struct raw_notifier_head *nh,
diff -uprN linux-2.6.25-rc8-mm1.orig/kernel/ksysfs.c linux-2.6.25-rc8-mm1/kernel/ksysfs.c
--- linux-2.6.25-rc8-mm1.orig/kernel/ksysfs.c	2008-04-02 04:44:26.000000000 +0900
+++ linux-2.6.25-rc8-mm1/kernel/ksysfs.c	2008-04-09 20:11:15.440000000 +0900
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/kexec.h>
 #include <linux/sched.h>
+#include <linux/notifier.h>
 
 #define KERNEL_ATTR_RO(_name) \
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
@@ -146,7 +147,10 @@ static int __init ksysfs_init(void)
 	if (error)
 		goto notes_exit;
 
-	return 0;
+	/* create the /sys/kernel/notifiers directory */
+	error = tunable_atomic_notifier_init();
+
+	return error;
 
 notes_exit:
 	if (notes_size > 0)
diff -uprN linux-2.6.25-rc8-mm1.orig/kernel/notifier.c linux-2.6.25-rc8-mm1/kernel/notifier.c
--- linux-2.6.25-rc8-mm1.orig/kernel/notifier.c	2008-04-08 16:37:44.904000000 +0900
+++ linux-2.6.25-rc8-mm1/kernel/notifier.c	2008-04-11 16:31:14.765088353 +0900
@@ -319,6 +319,261 @@ int blocking_notifier_call_chain(struct 
 EXPORT_SYMBOL_GPL(blocking_notifier_call_chain);
 
 /*
+ *	Tunable atomic notifier chain routines. Registration and unregistration
+ *	use a spinlock, and call_chain is synchronized by RCU (no locks).
+ *	User can change the list order to use /sys/kernel/notifiers/list-name/.
+ */
+
+static ssize_t priority_show(struct kobject *kobj, 
+				struct kobj_attribute *attr, const char *buf)
+{
+	struct tunable_atomic_notifier_block *n = container_of(kobj,
+				struct tunable_atomic_notifier_block, kobj);
+
+	return sprintf(buf, "%d\n", n->nb->priority);
+}
+
+static ssize_t priority_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t size)
+{
+	struct tunable_atomic_notifier_block *n = container_of(kobj,
+				struct tunable_atomic_notifier_block, kobj);
+	struct tunable_atomic_notifier_head *nh = n->head;
+	unsigned long flags;
+	int priority, ret;
+
+	sscanf(buf, "%d", &priority);
+	n->nb->priority = priority;
+
+	spin_lock_irqsave(&nh->lock, flags);
+	ret = notifier_chain_unregister(&nh->head, n->nb);
+	if (ret)
+		goto out_unlock;
+	ret = notifier_chain_register(&nh->head, n->nb);
+
+out_unlock:
+	spin_unlock_irqrestore(&nh->lock, flags);
+
+	return (ret ? ret : size);
+
+}
+
+static ssize_t description_show(struct kobject *kobj,
+				struct kobj_attribute *attr, const char *buf)
+{
+	struct tunable_atomic_notifier_block *n = container_of(kobj,
+				struct tunable_atomic_notifier_block, kobj);
+
+	if (n->desc)
+		return sprintf(buf, "%s\n", n->desc);
+
+	return sprintf(buf, "Description is not available\n");
+}
+
+static struct kobj_attribute priority_attr = 
+	__ATTR(priority, 0644, priority_show, priority_store);
+static struct kobj_attribute description_attr =
+	__ATTR_RO(description);
+
+static struct attribute *notifiers_attributes[] = {
+	&priority_attr.attr, &description_attr.attr, NULL 
+};
+
+static struct kobj_type notifiers_ktype = {
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_attrs = notifiers_attributes,
+};
+
+static struct kobject *notifiers_kobj;
+struct control_file_info *base;
+
+int notifiers_kobject_create(struct tunable_atomic_notifier_head *nh,
+			struct tunable_atomic_notifier_block *n, char *name)
+{
+	int error = -ENOMEM;
+	struct kobject *kobj = &n->kobj;
+
+	if (!nh->notifier_sub_kset) {
+		nh->notifier_sub_kset = kset_create_and_add(nh->name, NULL,
+							notifiers_kobj);
+		if (!nh->notifier_sub_kset)
+			goto out;
+	}
+
+	memset(kobj, 0, sizeof(struct kobject));
+	kobj->kset = nh->notifier_sub_kset;
+	error = kobject_init_and_add(kobj, &notifiers_ktype, NULL, "%s", name);
+	if (error)
+		kobject_put(kobj);
+
+out:
+	return error;
+}
+
+/**
+ *	tunable_atomic_notifier_chain_register - Add notifier to an tunable notifier chain
+ *	@nh: Pointer to head of the tunable notifier chain
+ *	@n: New entry in notifier chain
+ *	@name: Pointer to the name of the new notifier entry
+ *	@desc: Pointer to the description of new entry
+ *
+ *	Adds a notifier to an tunable notifier chain and makes control dir.
+ *	This function must be called after kmem_cache_init().
+ *
+ *	Returns zero on success or %-ENODEV on failure.
+ */
+
+int tunable_atomic_notifier_chain_register(
+		struct tunable_atomic_notifier_head *nh,
+		struct tunable_atomic_notifier_block *n, char *name, char *desc)
+{
+	unsigned long flags;
+	int ret;
+
+	if (!name)
+		return -EINVAL;
+	if (desc)
+		n->desc = desc;
+
+	if (!notifiers_kobj) {
+		struct control_file_info *temp, *new;
+
+		temp = kmalloc(sizeof(struct control_file_info), GFP_ATOMIC);
+		if (!temp)
+			return -ENOMEM;
+		temp->nh = nh;
+		temp->n = n;
+		temp->name = name;
+		temp->next = NULL;
+		if (!base)
+			base = temp;
+		else {
+			new = base;
+			while (new->next) {	
+				new = new->next;
+			}
+			new->next = temp;
+		}
+		goto regist;
+	}
+
+	ret = notifiers_kobject_create(nh, n, name);
+	if (ret)
+		return ret;
+
+regist:
+	spin_lock_irqsave(&nh->lock, flags);
+	ret = notifier_chain_register(&nh->head, n->nb);
+	spin_unlock_irqrestore(&nh->lock, flags);
+	n->head = nh;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tunable_atomic_notifier_chain_register);
+
+/**
+ *	tunable_atomic_notifier_chain_unregister - Remove notifier from a tunable notifier chain
+ *	@nh: Pointer to head of the tunable notifier chain
+ *	@n: Entry to remove from notifier chain
+ *
+ *	Removes a notifier from a tunable notifier chain.
+ *
+ *	Retunrns zero on success or %-ENOENT on failure.
+ */
+
+int tunable_atomic_notifier_chain_unregister(
+				struct tunable_atomic_notifier_head *nh,
+				struct tunable_atomic_notifier_block *n)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&nh->lock, flags);
+	ret = notifier_chain_unregister(&nh->head, n->nb);
+	spin_unlock_irqrestore(&nh->lock, flags);
+	synchronize_rcu();
+
+	if (ret)
+		return ret;
+
+	kobject_del(&n->kobj);
+	kobject_put(&n->kobj);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tunable_atomic_notifier_chain_unregister);
+
+/**
+ *	__tunable_atomic_notifier_call_chain - Call functions in a tunable notifier chain
+ *	@nh: Pointer to head of the tunable notifier chain
+ *	@val: Value passed unmodified to notifier function
+ *	@v: Pointer passed unmodified to notifier function
+ *	@nr_to_call: See the comment for notifier_call_chain
+ *	@nr_calls: See the comment for notifier_call_chain
+ *
+ *	Calls each function in a notifier chain in turn. The functions
+ *	run in an atomic context, so they must not block.
+ *	This routine uses RCU to synchronize with changes to the chain.
+ *
+ *	If the return value of the notifier can be and'ed
+ *	with %NOTIFY_STOP_MASK then tunable_atomic_notifier_call_chain()
+ *	will return immediately, with the return value of
+ *	the notifier function which halted execution.
+ *	Otherwise the return value is the return value
+ *	of the last notifier function called.
+ */
+
+int __kprobes __tunable_atomic_notifier_call_chain(
+					struct tunable_atomic_notifier_head *nh,
+					unsigned long val, void *v,
+					int nr_to_call, int *nr_calls)
+{
+	int ret;
+
+	rcu_read_lock();
+	ret = notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__tunable_atomic_notifier_call_chain);
+
+int __kprobes tunable_atomic_notifier_call_chain(
+					struct tunable_atomic_notifier_head *nh,
+					unsigned long val, void *v)
+{
+	return __tunable_atomic_notifier_call_chain(nh, val, v, -1, NULL);
+}
+EXPORT_SYMBOL_GPL(tunable_atomic_notifier_call_chain);
+
+int __init tunable_atomic_notifier_init(void) {
+	struct control_file_info *prev, *temp = base;
+	struct tunable_atomic_notifier_head *nh;
+	struct tunable_atomic_notifier_block *n;
+	char *name;
+	int error;
+
+	notifiers_kobj = kobject_create_and_add("notifiers", kernel_kobj);
+
+	if (!notifiers_kobj)
+		return -ENOMEM;
+
+	while (temp) {
+		nh = temp->nh;
+		n = temp->n;
+		name = temp->name;
+
+		error = notifiers_kobject_create(nh, n, name);
+		if (error)
+			printk("%s: %s is failed to create. err = %d\n",
+							nh->name, name, error);
+		prev = temp;
+		temp = temp->next;
+		kfree(prev);
+	}
+	return 0;
+}
+
+/*
  *	Raw notifier chain routines.  There is no protection;
  *	the caller must provide it.  Use at your own risk!
  */

