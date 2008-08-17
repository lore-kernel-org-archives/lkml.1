Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYHQKds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYHQKds (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 06:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYHQKdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 06:33:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:32091 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbYHQKdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 06:33:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=JZH9ZN4sSrfK8GHTpYpfwfoKJq+vm9aIO94wBWJNZKv44FaHiBy0mDY46iPS53kY6V
         6H9ukeHAdJBhFIa4uq2vNtORIcjOB7NJcYC28fT3xRYY9Sa3ENx7cQPZG8erOKzVhZmt
         K0xd0Y56yXZiiXfAFv+9KVTvjuQddeM1//CFA=
Message-ID: <48A7FE7B.3060309@gmail.com>
Date: Sun, 17 Aug 2008 12:33:31 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>, Ulrich Drepper <drepper@redhat.com>
Subject: [RFC] [PATCH -mm] cgroup: uid-based rules to add processes efficiently
 in the right cgroup
References: <20080701191126.GA17376@redhat.com> <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com> <20080703155446.GB9275@redhat.com> <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com> <20080710104852.797fe79c@cuia.bos.redhat.com> <20080710154035.GA12043@redhat.com> <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com> <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com> <20080714152142.GJ16673@redhat.com>
In-Reply-To: <20080714152142.GJ16673@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem of placing tasks in respective cgroups seems to be correctly
addressed by userspace lib wrappers or classifier daemons [1].

However, this is an attempt to implement an in-kernel classifier.

[ I wrote this patch for a "special purpose" environment, where a lot of
short-lived processes belonging to different users are spawned by
different daemons, so the main goal here would be to remove the dealy
needed by userspace classification and place the tasks in the right
cgroup at the time they're created. This is just an ugly hack for now
and it works only for uid-based rules, gid-based rules could be
implemented in a similar way. ]

UID:cgroup associations are stored in a RCU-protected hash list.

The kernel<->userspace interface works as following:
 - the file "uids" is added in the cgroup filesystem
 - a UID can be placed only in a single cgroup
 - a cgroup can have multiple UIDs

Respect to the userspace solution (e.g. classifier daemon) this solution
has the advantage of removing the delay for task classification, that
means each task always runs in the appropriate cgroup at the time is
created (fork, exec) or when the uid changes (setuid).

OTOH the disadvantage is to introduce the complexity in the kernel.

[1] http://lkml.org/lkml/2008/7/1/391

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 include/linux/cgroup.h |    9 +++
 kernel/cgroup.c        |  141 +++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sys.c           |    6 ++-
 3 files changed, 154 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 30934e4..243819a 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -393,6 +393,7 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
 void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it);
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *, struct task_struct *);
+struct cgroup *uid_to_cgroup(uid_t uid);
 
 #else /* !CONFIG_CGROUPS */
 
@@ -411,6 +412,14 @@ static inline int cgroupstats_build(struct cgroupstats *stats,
 {
 	return -EINVAL;
 }
+static inline int cgroup_attach_task(struct cgroup *, struct task_struct *)
+{
+	return 0;
+}
+static inline struct cgroup *uid_to_cgroup(uid_t uid)
+{
+	return NULL;
+}
 
 #endif /* !CONFIG_CGROUPS */
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 791246a..5a010db 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1318,6 +1318,7 @@ enum cgroup_filetype {
 	FILE_ROOT,
 	FILE_DIR,
 	FILE_TASKLIST,
+	FILE_UIDLIST,
 	FILE_NOTIFY_ON_RELEASE,
 	FILE_RELEASE_AGENT,
 };
@@ -2203,6 +2204,131 @@ static int cgroup_write_notify_on_release(struct cgroup *cgrp,
 	return 0;
 }
 
+#define CGROUP_UID_HASH_SHIFT	9
+#define CGROUP_UID_HASH_SIZE	(1UL << CGROUP_UID_HASH_SHIFT)
+#define cgroup_uid_hashfn(__uid) \
+		hash_long((unsigned long)__uid, CGROUP_UID_HASH_SHIFT)
+
+struct cgroup_uid {
+	uid_t uid;
+	struct cgroup *cgroup;
+	struct hlist_node cgroup_uid_chain;
+};
+
+/* hash list to store uid:cgroup associations (protected by RCU locking) */
+static struct hlist_head *cgroup_uids;
+
+/* spinlock to protect cgroup_uids write operations */
+static __cacheline_aligned DEFINE_SPINLOCK(cgroup_uid_lock);
+
+/*
+ * Note: called with rcu_read_lock() held.
+ */
+static struct cgroup_uid *cgroup_uid_find_item(uid_t uid)
+{
+	struct hlist_node *item;
+	struct cgroup_uid *u;
+
+	hlist_for_each_entry_rcu(u, item, &cgroup_uids[cgroup_uid_hashfn(uid)],
+			cgroup_uid_chain)
+		if (u->uid == uid)
+			return u;
+	return NULL;
+}
+
+struct cgroup *uid_to_cgroup(uid_t uid)
+{
+	struct cgroup_uid *cu;
+	struct cgroup *ret;
+
+	rcu_read_lock();
+	cu = cgroup_uid_find_item(uid);
+	ret = cu ? cu->cgroup : NULL;
+	rcu_read_unlock();
+	return ret;
+}
+
+static int cgroup_uid_read(struct cgroup *cgrp, struct cftype *cft,
+				struct seq_file *m)
+{
+	struct hlist_node *item;
+	struct cgroup_uid *u;
+	int i;
+
+	rcu_read_lock();
+	for (i = 0; i < CGROUP_UID_HASH_SIZE; i++)
+		hlist_for_each_entry_rcu(u, item, &cgroup_uids[i],
+				cgroup_uid_chain)
+			if (u->cgroup == cgrp)
+				seq_printf(m, "%u\n", u->uid);
+	rcu_read_unlock();
+	return 0;
+}
+
+static int cgroup_uid_write(struct cgroup *cgrp, struct cftype *cft, u64 uid)
+{
+	struct cgroup_uid *u, *old_u;
+
+	u = kmalloc(sizeof(*u), GFP_KERNEL);
+	if (unlikely(!u))
+		return -ENOMEM;
+	u->uid = (uid_t)uid;
+	u->cgroup = cgrp;
+
+	spin_lock_irq(&cgroup_uid_lock);
+	old_u = cgroup_uid_find_item(uid);
+	if (old_u) {
+		/* Replace old element with newer */
+		hlist_replace_rcu(&old_u->cgroup_uid_chain,
+				&u->cgroup_uid_chain);
+		spin_unlock_irq(&cgroup_uid_lock);
+		synchronize_rcu();
+		kfree(old_u);
+		return 0;
+	}
+	/* Add the new element to the cgroup uid hash list */
+	hlist_add_head_rcu(&u->cgroup_uid_chain,
+			&cgroup_uids[cgroup_uid_hashfn(uid)]);
+	spin_unlock_irq(&cgroup_uid_lock);
+	return 0;
+}
+
+static int cgroup_uid_cleanup(struct cgroup *cgrp)
+{
+	HLIST_HEAD(old_items);
+	struct hlist_node *item, *n;
+	struct cgroup_uid *u;
+	int i;
+
+	spin_lock_irq(&cgroup_uid_lock);
+	for (i = 0; i < CGROUP_UID_HASH_SIZE; i++)
+		hlist_for_each_entry_safe(u, item, n, &cgroup_uids[i],
+				cgroup_uid_chain)
+			if (u->cgroup == cgrp) {
+				hlist_del_rcu(&u->cgroup_uid_chain);
+				hlist_add_head(&u->cgroup_uid_chain,
+						&old_items);
+			}
+	spin_unlock_irq(&cgroup_uid_lock);
+	synchronize_rcu();
+	hlist_for_each_entry_safe(u, item, n, &old_items, cgroup_uid_chain)
+		kfree(u);
+	return 0;
+}
+
+static int __init init_cgroup_uid(void)
+{
+	int i;
+
+	cgroup_uids = kmalloc(sizeof(*cgroup_uids) * CGROUP_UID_HASH_SIZE,
+				GFP_KERNEL);
+	if (unlikely(!cgroup_uids))
+		return -ENOMEM;
+	for (i = 0; i < CGROUP_UID_HASH_SIZE; i++)
+		INIT_HLIST_HEAD(&cgroup_uids[i]);
+	return 0;
+}
+
 /*
  * for the common functions, 'private' gives the type of file
  */
@@ -2215,7 +2341,12 @@ static struct cftype files[] = {
 		.release = cgroup_tasks_release,
 		.private = FILE_TASKLIST,
 	},
-
+	{
+		.name = "uids",
+		.read_seq_string = cgroup_uid_read,
+		.write_u64 = cgroup_uid_write,
+		.private = FILE_UIDLIST,
+	},
 	{
 		.name = "notify_on_release",
 		.read_u64 = cgroup_read_notify_on_release,
@@ -2434,6 +2565,8 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 		return -EBUSY;
 	}
 
+	cgroup_uid_cleanup(cgrp);
+
 	spin_lock(&release_list_lock);
 	set_bit(CGRP_REMOVED, &cgrp->flags);
 	if (!list_empty(&cgrp->release_list))
@@ -2550,6 +2683,8 @@ int __init cgroup_init(void)
 	if (err)
 		return err;
 
+	init_cgroup_uid();
+
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
 		if (!ss->early_init)
@@ -2700,11 +2835,15 @@ static struct file_operations proc_cgroupstats_operations = {
  */
 void cgroup_fork(struct task_struct *child)
 {
+	struct cgroup *cgrp = uid_to_cgroup(child->uid);
+
 	task_lock(current);
 	child->cgroups = current->cgroups;
 	get_css_set(child->cgroups);
 	task_unlock(current);
 	INIT_LIST_HEAD(&child->cg_list);
+	if (cgrp)
+		cgroup_attach_task(cgrp, child);
 }
 
 /**
diff --git a/kernel/sys.c b/kernel/sys.c
index c018580..d22e815 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -19,6 +19,7 @@
 #include <linux/kexec.h>
 #include <linux/workqueue.h>
 #include <linux/capability.h>
+#include <linux/cgroup.h>
 #include <linux/device.h>
 #include <linux/key.h>
 #include <linux/times.h>
@@ -548,10 +549,11 @@ asmlinkage long sys_setgid(gid_t gid)
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
 }
-  
+
 static int set_user(uid_t new_ruid, int dumpclear)
 {
 	struct user_struct *new_user;
+	struct cgroup *cgrp = uid_to_cgroup(new_ruid);
 
 	new_user = alloc_uid(current->nsproxy->user_ns, new_ruid);
 	if (!new_user)
@@ -571,6 +573,8 @@ static int set_user(uid_t new_ruid, int dumpclear)
 		smp_wmb();
 	}
 	current->uid = new_ruid;
+	if (cgrp)
+		cgroup_attach_task(cgrp, current);
 	return 0;
 }
 
