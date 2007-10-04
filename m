Return-Path: <linux-kernel-owner+w=401wt.eu-S1762278AbXJDLnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278AbXJDLnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758237AbXJDLlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:41:01 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:35015 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761905AbXJDLk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:40:57 -0400
Message-ID: <4704D0BA.4090507@ah.jp.nec.com>
Date: Thu, 04 Oct 2007 20:38:34 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: vgoyal@in.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       k-miyoshi@cb.jp.nec.com, kexec@lists.infradead.org,
       Bernhard Walle <bwalle@suse.de>, Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: [PATCH 1/2] add tunable_notifier function
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new notifier function tunable_notifier_chain. Its base is
atomic_notifier_chain.

Thanks,

---

Signed-off-by: Takenori Nagano <t-nagano@ah.jp.nec.com>

---
diff -uprN linux-2.6.23-rc9.orig/include/linux/notifier.h
linux-2.6.23-rc9/include/linux/notifier.h
--- linux-2.6.23-rc9.orig/include/linux/notifier.h	2007-10-02 12:24:52.000000000
+0900
+++ linux-2.6.23-rc9/include/linux/notifier.h	2007-10-03 14:48:04.288000000 +0900
@@ -13,6 +13,7 @@
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/srcu.h>
+#include <linux/kobject.h>

 /*
  * Notifier chains are of four types:
@@ -53,6 +54,14 @@ struct notifier_block {
 	int priority;
 };

+struct tunable_notifier_block {
+	struct notifier_block *nb;
+	struct tunable_notifier_head *head;
+	struct dentry *dir;
+	struct dentry *pri_dentry;
+	struct dentry *desc_dentry;
+};
+
 struct atomic_notifier_head {
 	spinlock_t lock;
 	struct notifier_block *head;
@@ -63,6 +72,13 @@ struct blocking_notifier_head {
 	struct notifier_block *head;
 };

+struct tunable_notifier_head {
+	spinlock_t lock;
+	struct notifier_block *head;
+	char *name;
+	struct dentry *dir;
+};
+
 struct raw_notifier_head {
 	struct notifier_block *head;
 };
@@ -81,6 +97,12 @@ struct srcu_notifier_head {
 		init_rwsem(&(name)->rwsem);	\
 		(name)->head = NULL;		\
 	} while (0)
+#define TUNABLE_INIT_NOTIFIER(val1, val2) do {	\
+		spin_lock_init(&(val1)->lock);		\
+		(val1)->head = NULL;			\
+		(val1)->name = val2;			\
+		(val1)->dir = NULL;			\
+	} while (0)
 #define RAW_INIT_NOTIFIER_HEAD(name) do {	\
 		(name)->head = NULL;		\
 	} while (0)
@@ -96,6 +118,11 @@ extern void srcu_init_notifier_head(stru
 #define BLOCKING_NOTIFIER_INIT(name) {				\
 		.rwsem = __RWSEM_INITIALIZER((name).rwsem),	\
 		.head = NULL }
+#define TUNABLE_NOTIFIER_INIT(val1, val2) {			\
+		.lock =__SPIN_LOCK_UNLOCKED(val1.lock),		\
+		.head = NULL,					\
+		.name = val2,						\
+		.dir = NULL }
 #define RAW_NOTIFIER_INIT(name)	{				\
 		.head = NULL }
 /* srcu_notifier_heads cannot be initialized statically */
@@ -106,6 +133,9 @@ extern void srcu_init_notifier_head(stru
 #define BLOCKING_NOTIFIER_HEAD(name)				\
 	struct blocking_notifier_head name =			\
 		BLOCKING_NOTIFIER_INIT(name)
+#define TUNABLE_NOTIFIER_HEAD(name, val)			\
+	struct tunable_notifier_head name =			\
+		TUNABLE_NOTIFIER_INIT(name, val)
 #define RAW_NOTIFIER_HEAD(name)					\
 	struct raw_notifier_head name =				\
 		RAW_NOTIFIER_INIT(name)
@@ -116,6 +146,8 @@ extern int atomic_notifier_chain_registe
 		struct notifier_block *nb);
 extern int blocking_notifier_chain_register(struct blocking_notifier_head *nh,
 		struct notifier_block *nb);
+extern int tunable_notifier_chain_register(struct tunable_notifier_head *nh,
+		struct tunable_notifier_block *nb, char *name, char *desc);
 extern int raw_notifier_chain_register(struct raw_notifier_head *nh,
 		struct notifier_block *nb);
 extern int srcu_notifier_chain_register(struct srcu_notifier_head *nh,
@@ -125,6 +157,8 @@ extern int atomic_notifier_chain_unregis
 		struct notifier_block *nb);
 extern int blocking_notifier_chain_unregister(struct blocking_notifier_head *nh,
 		struct notifier_block *nb);
+extern int tunable_notifier_chain_unregister(struct tunable_notifier_head *nh,
+		struct tunable_notifier_block *nb);
 extern int raw_notifier_chain_unregister(struct raw_notifier_head *nh,
 		struct notifier_block *nb);
 extern int srcu_notifier_chain_unregister(struct srcu_notifier_head *nh,
@@ -138,6 +172,10 @@ extern int blocking_notifier_call_chain(
 		unsigned long val, void *v);
 extern int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 	unsigned long val, void *v, int nr_to_call, int *nr_calls);
+extern int tunable_notifier_call_chain(struct tunable_notifier_head *nh,
+		unsigned long val, void *v);
+extern int __tunable_notifier_call_chain(struct tunable_notifier_head *nh,
+	unsigned long val, void *v, int nr_to_call, int *nr_calls);
 extern int raw_notifier_call_chain(struct raw_notifier_head *nh,
 		unsigned long val, void *v);
 extern int __raw_notifier_call_chain(struct raw_notifier_head *nh,
diff -uprN linux-2.6.23-rc9.orig/kernel/sys.c linux-2.6.23-rc9/kernel/sys.c
--- linux-2.6.23-rc9.orig/kernel/sys.c	2007-10-02 12:24:52.000000000 +0900
+++ linux-2.6.23-rc9/kernel/sys.c	2007-10-03 14:48:15.160000000 +0900
@@ -38,6 +38,7 @@
 #include <linux/syscalls.h>
 #include <linux/kprobes.h>
 #include <linux/user_namespace.h>
+#include <linux/debugfs.h>

 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -393,6 +394,234 @@ int blocking_notifier_call_chain(struct
 EXPORT_SYMBOL_GPL(blocking_notifier_call_chain);

 /*
+ *	Tunable notifier chain routines. Registration and unregistration
+ *	use a spinlock, and call_chain is synchronized by RCU (no locks).
+ *	User can change the list order to use /sys/kernel/debug/list-name/.
+ */
+
+static ssize_t priority_read(struct file *file,
+			char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct tunable_notifier_block *n = file->f_dentry->d_inode->i_private;
+	int priority = n->nb->priority;
+	char buf[64], *s;
+
+	s = buf;
+	s += sprintf(s, "%d\n", priority);
+
+	return simple_read_from_buffer((void __user *)user_buf, count,
+							ppos, buf, s - buf);
+}
+
+static ssize_t priority_write(struct file *file,
+		const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct tunable_notifier_block *n = file->f_dentry->d_inode->i_private;
+	struct tunable_notifier_head *nh = n->head;
+	char *buf, *end;
+	int ret = -ENOMEM, priority;
+	unsigned long tmp, flags;
+
+	buf = kmalloc(count + 1, GFP_KERNEL);
+	if (!buf)
+		goto out;
+
+	buf[count] = 0;
+	ret = -EFAULT;
+	if (copy_from_user(buf, user_buf, count))
+		goto out_free;
+
+	ret = -EINVAL;
+	tmp = simple_strtoul(buf, &end, 10);
+	if ((end == buf) || (tmp > INT_MAX))
+		goto out_free;
+
+	priority = (int)tmp;
+	n->nb->priority = priority;
+
+	spin_lock_irqsave(&nh->lock, flags);
+	ret = notifier_chain_unregister(&nh->head, n->nb);
+	if (ret)
+		goto out_unlock;
+	ret = notifier_chain_register(&nh->head, n->nb);
+	if (!ret)
+		ret = count;
+
+out_unlock:
+	spin_unlock_irqrestore(&nh->lock, flags);
+out_free:
+	kfree(buf);
+out:
+	return ret;
+
+}
+
+static const struct file_operations pri_fops = {
+	.read = priority_read,
+	.write = priority_write,
+};
+
+static ssize_t description_read(struct file *file,
+			char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char *desc = file->f_dentry->d_inode->i_private;
+	int avail = strlen(desc);
+
+	return simple_read_from_buffer(user_buf, count, ppos, desc, avail);
+}
+
+static const struct file_operations desc_fops = {
+	.read = description_read,
+};
+
+/**
+ *	tunable_notifier_chain_register - Add notifier to an tunable notifier chain
+ *	@nh: Pointer to head of the tunable notifier chain
+ *	@n: New entry in notifier chain
+ *	@name: Pointer to the name of this notifier chain
+ *	@desc: Pointer to the description of new entry
+ *
+ *	Adds a notifier to an tunable notifier chain and makes control dir.
+ *
+ *	Returns zero on success or %-ENODEV on failure.
+ */
+
+int tunable_notifier_chain_register(struct tunable_notifier_head *nh,
+		struct tunable_notifier_block *n, char *name, char *desc)
+{
+	unsigned long flags;
+	int ret = -EINVAL;
+	struct dentry *nh_dir, *nb_dir, *pri_dentry, *desc_dentry = NULL;
+
+	if (!name)
+		goto nb_fail;
+
+	ret = -ENOMEM;
+	if (!nh->dir) {
+		nh_dir = debugfs_create_dir(nh->name, NULL);
+		if (!nh_dir)
+			return ret;
+		nh->dir = nh_dir;
+	} else
+		nh_dir = nh->dir;
+
+	nb_dir = debugfs_create_dir(name, nh_dir);
+	if (!nb_dir)
+		goto nb_fail;
+	n->dir = nb_dir;
+
+	pri_dentry = debugfs_create_file("priority",0600, nb_dir, n, &pri_fops);
+	if (!pri_dentry)
+		goto pri_fail;
+	n->pri_dentry = pri_dentry;
+
+	if (desc) {
+		desc_dentry = debugfs_create_file("description", 0400, nb_dir,
+							desc, &desc_fops);
+		if (!desc_dentry)
+			goto desc_fail;
+		n->desc_dentry = desc_dentry;
+	}
+
+	spin_lock_irqsave(&nh->lock, flags);
+	ret = notifier_chain_register(&nh->head, n->nb);
+	spin_unlock_irqrestore(&nh->lock, flags);
+
+	if (ret)
+		goto reg_fail;
+	
+	n->head = nh;
+
+	return ret;
+
+reg_fail:
+	debugfs_remove(desc_dentry);
+desc_fail:
+	debugfs_remove(pri_dentry);
+pri_fail:
+	debugfs_remove(nb_dir);
+nb_fail:
+	return ret;
+}
+
+EXPORT_SYMBOL_GPL(tunable_notifier_chain_register);
+
+/**
+ *	tunable_notifier_chain_unregister - Remove notifier from a tunable notifier
chain
+ *	@nh: Pointer to head of the tunable notifier chain
+ *	@n: Entry to remove from notifier chain
+ *
+ *	Removes a notifier from a tunable notifier chain.
+ *
+ *	Retunrns zero on success or %-ENOENT on failure.
+ */
+
+int tunable_notifier_chain_unregister(struct tunable_notifier_head *nh,
+		struct tunable_notifier_block *n)
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
+	debugfs_remove(n->desc_dentry);
+	debugfs_remove(n->pri_dentry);
+	debugfs_remove(n->dir);
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(tunable_notifier_chain_unregister);
+
+/**
+ *	__tunable_notifier_call_chain - Call functions in a tunable notifier chain
+ *	@nh: Pointer to head of the tunable notifier chain
+ *	@val: Value passed unmodified to notifier function
+ *	@v: Pointer passed unmodified to notifier function
+ *	@nt_to_call: See the comment for notifier_call_chain
+ *	@nr_calls: See the comment for notifier_call_chain
+ *
+ *	Calls each function in a notifier chain in turn. The functions
+ *	run in an atomic context, so they must not block.
+ *	This routine uses RCU to synchronize with changes to the chain.
+ *
+ *	If the return value of the notifier can be and'ed
+ *	with %NOTIFY_STOP_MASK then tunable_notifier_call_chain()
+ *	will return immediately, with the return value of
+ *	the notifier function which halted execution.
+ *	Otherwise the return value is the return value
+ *	of the last notifier function called.
+ */
+
+int __kprobes __tunable_notifier_call_chain(struct tunable_notifier_head *nh,
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
+
+EXPORT_SYMBOL_GPL(__tunable_notifier_call_chain);
+
+int __kprobes tunable_notifier_call_chain(struct tunable_notifier_head *nh,
+						unsigned long val, void *v)
+{
+	return __tunable_notifier_call_chain(nh, val, v, -1, NULL);
+}
+
+EXPORT_SYMBOL_GPL(tunable_notifier_call_chain);
+
+/*
  *	Raw notifier chain routines.  There is no protection;
  *	the caller must provide it.  Use at your own risk!
  */

