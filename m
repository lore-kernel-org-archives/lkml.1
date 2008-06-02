Return-Path: <linux-kernel-owner+w=401wt.eu-S1762118AbYFBNsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762118AbYFBNsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761050AbYFBNrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:47:40 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49901 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761861AbYFBNri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:47:38 -0400
Message-Id: <20080602134439.953880460@theryb.frec.bull.fr>
References: <20080602134438.224352910@theryb.frec.bull.fr>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 15:46:18 +0200
From: Benjamin Thery <benjamin.thery@bull.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Eric Biederman <ebiederm@xmission.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       Benjamin Thery <benjamin.thery@bull.net>
Subject: [PATCH 10/10] sysfs: user namespaces: fix bug with
 clone(CLONE_NEWUSER) with fairsched
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the /sys/kernel/uids directory to be tagged so that processes in
different user namespaces can remount /sys and see their own uid
listings.

Without this patch, having CONFIG_FAIR_SCHED=y makes user namespaces
unusable, because when you 
  clone(CLONE_NEWUSER)
it will auto-create the root userid and try to create
/sys/kernel/uids/0.  Since that already exists from the parent user
namespace, the create fails, and the clone misleadingly ends up
returning -ENOMEM.

This patch fixes the issue by allowing each user namespace to remount
/sys, and having /sys filter the /sys/kernel/uid/ entries by user
namespace.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Benjamin Thery <benjamin.thery@bull.net>
---
 fs/sysfs/mount.c               |   24 ++++++++++++++++++++++++
 include/linux/sched.h          |    1 +
 include/linux/sysfs.h          |    9 +++++++++
 include/linux/user_namespace.h |    1 +
 kernel/user.c                  |   21 +++++++++++++++++++++
 kernel/user_namespace.c        |    3 ++-
 6 files changed, 58 insertions(+), 1 deletion(-)

Index: linux-mm/fs/sysfs/mount.c
===================================================================
--- linux-mm.orig/fs/sysfs/mount.c
+++ linux-mm/fs/sysfs/mount.c
@@ -81,6 +81,7 @@ static int sysfs_fill_super(struct super
 	sb->s_root = root;
 	sb->s_fs_info = info;
 	info->tag.net_ns = hold_net(current->nsproxy->net_ns);
+	info->tag.user_ns = current->nsproxy->user_ns;
 	return 0;
 
 out_err:
@@ -100,6 +101,8 @@ static int sysfs_test_super(struct super
 
 	if (task->nsproxy->net_ns != info->tag.net_ns)
 		found = 0;
+	if (task->nsproxy->user_ns != info->tag.user_ns)
+		found = 0;
 
 	return found;
 }
@@ -214,6 +217,27 @@ static struct pernet_operations sysfs_ne
 };
 #endif
 
+#ifdef CONFIG_USER_NS
+void sysfs_userns_exit(struct user_namespace *user_ns)
+{
+	/* Allow the net namespace to go away while sysfs is still mounted. */
+	struct super_block *sb;
+	printk(KERN_NOTICE "sysfs: user namespace exiting\n");
+	mutex_lock(&sysfs_rename_mutex);
+	sysfs_grab_supers();
+	mutex_lock(&sysfs_mutex);
+	list_for_each_entry(sb, &sysfs_fs_type.fs_supers, s_instances) {
+		struct sysfs_super_info *info = sysfs_info(sb);
+		if (info->tag.user_ns != user_ns)
+			continue;
+		info->tag.user_ns = NULL;
+	}
+	mutex_unlock(&sysfs_mutex);
+	sysfs_release_supers();
+	mutex_unlock(&sysfs_rename_mutex);
+}
+#endif
+
 int __init sysfs_init(void)
 {
 	int err = -ENOMEM;
Index: linux-mm/include/linux/sched.h
===================================================================
--- linux-mm.orig/include/linux/sched.h
+++ linux-mm/include/linux/sched.h
@@ -600,6 +600,7 @@ struct user_struct {
 	/* Hash table maintenance information */
 	struct hlist_node uidhash_node;
 	uid_t uid;
+	struct user_namespace *user_ns;
 
 #ifdef CONFIG_USER_SCHED
 	struct task_group *tg;
Index: linux-mm/include/linux/sysfs.h
===================================================================
--- linux-mm.orig/include/linux/sysfs.h
+++ linux-mm/include/linux/sysfs.h
@@ -20,6 +20,7 @@
 struct kobject;
 struct module;
 struct net;
+struct user_namespace;
 
 /* FIXME
  * The *owner field is no longer used, but leave around
@@ -81,6 +82,7 @@ struct sysfs_ops {
 
 struct sysfs_tag_info {
 	struct net *net_ns;
+	struct user_namespace *user_ns;
 };
 
 struct sysfs_tagged_dir_operations {
@@ -138,6 +140,9 @@ int sysfs_enable_tagging(struct kobject 
 
 extern int __must_check sysfs_init(void);
 
+struct user_namespace;
+void sysfs_userns_exit(struct user_namespace *user_ns);
+
 #else /* CONFIG_SYSFS */
 
 static inline int sysfs_schedule_callback(struct kobject *kobj,
@@ -254,6 +259,10 @@ static inline int __must_check sysfs_ini
 	return 0;
 }
 
+static inline void sysfs_userns_exit(struct user_namespace *user_ns)
+{
+}
+
 static inline void sysfs_printk_last_file(void)
 {
 }
Index: linux-mm/include/linux/user_namespace.h
===================================================================
--- linux-mm.orig/include/linux/user_namespace.h
+++ linux-mm/include/linux/user_namespace.h
@@ -12,6 +12,7 @@
 struct user_namespace {
 	struct kref		kref;
 	struct hlist_head	uidhash_table[UIDHASH_SZ];
+	struct kset		*kset;
 	struct user_struct	*root_user;
 };
 
Index: linux-mm/kernel/user.c
===================================================================
--- linux-mm.orig/kernel/user.c
+++ linux-mm/kernel/user.c
@@ -53,6 +53,7 @@ struct user_struct root_user = {
 	.files		= ATOMIC_INIT(0),
 	.sigpending	= ATOMIC_INIT(0),
 	.locked_shm     = 0,
+	.user_ns	= &init_user_ns,
 #ifdef CONFIG_USER_SCHED
 	.tg		= &init_task_group,
 #endif
@@ -236,6 +237,23 @@ static void uids_release(struct kobject 
 	return;
 }
 
+static const void *userns_sb_tag(struct sysfs_tag_info *info)
+{
+	return info->user_ns;
+}
+
+static const void *userns_kobject_tag(struct kobject *kobj)
+{
+	struct user_struct *up;
+	up = container_of(kobj, struct user_struct, kobj);
+	return up->user_ns;
+}
+
+static struct sysfs_tagged_dir_operations userns_tagged_dir_operations = {
+	.sb_tag = userns_sb_tag,
+	.kobject_tag = userns_kobject_tag,
+};
+
 static struct kobj_type uids_ktype = {
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_attrs = uids_attributes,
@@ -272,6 +290,8 @@ int __init uids_sysfs_init(void)
 	if (!uids_kset)
 		return -ENOMEM;
 
+	sysfs_enable_tagging(&uids_kset->kobj, &userns_tagged_dir_operations);
+
 	return uids_user_create(&root_user);
 }
 
@@ -404,6 +424,7 @@ struct user_struct *alloc_uid(struct use
 			goto out_unlock;
 
 		new->uid = uid;
+		new->user_ns = ns;
 		atomic_set(&new->__count, 1);
 
 		if (sched_create_user(new) < 0)
Index: linux-mm/kernel/user_namespace.c
===================================================================
--- linux-mm.orig/kernel/user_namespace.c
+++ linux-mm/kernel/user_namespace.c
@@ -22,7 +22,7 @@ static struct user_namespace *clone_user
 	struct user_struct *new_user;
 	int n;
 
-	ns = kmalloc(sizeof(struct user_namespace), GFP_KERNEL);
+	ns = kzalloc(sizeof(struct user_namespace), GFP_KERNEL);
 	if (!ns)
 		return ERR_PTR(-ENOMEM);
 
@@ -71,6 +71,7 @@ void free_user_ns(struct kref *kref)
 	struct user_namespace *ns;
 
 	ns = container_of(kref, struct user_namespace, kref);
+	sysfs_userns_exit(ns);
 	release_uids(ns);
 	kfree(ns);
 }

-- 
