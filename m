Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbXJCRQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbXJCRQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbXJCRP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:15:57 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:41965 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbXJCRPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:15:55 -0400
Date: Wed, 3 Oct 2007 22:40:29 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: [RFC/PATCH -v2] Add sysfs control to modify a user's cpu share
Message-ID: <20071003171029.GA5423@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1190724893.13716.8.camel@Homer.simpson.net> <20070925131717.GM26289@linux.vnet.ibm.com> <1190725693.13716.10.camel@Homer.simpson.net> <20070925132528.GN26289@linux.vnet.ibm.com> <1190726682.11260.1.camel@Homer.simpson.net> <20070925140559.GB26310@linux.vnet.ibm.com> <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu> <20071001140454.GA19439@linux.vnet.ibm.com> <20071001144402.GA3505@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001144402.GA3505@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Can you please drop commit b1add858a10cece3a68b2d8cb9e7350843700a58 (last
version of this patch) and try this instead?
---
Adds tunables in sysfs to modify a user's cpu share.

A directory is created in sysfs for each new user in the system.

	/sys/kernel/uids/<uid>/cpu_share

Reading this file returns the cpu shares granted for the user.
Writing into this file modifies the cpu share for the user. Only an
administrator is allowed to modify a user's cpu share.

Ex:
	# cd /sys/kernel/uids/
	# cat 512/cpu_share
	1024
	# echo 2048 > 512/cpu_share
	# cat 512/cpu_share
	2048
	#

Changelog since v1:
1. Added a mutex to serialize directory creation/destruction for a user in
   sysfs
2. Added a spinlock in the task_group structure to serialize writes to
   tg->shares.
3. Removed /proc/root_user_cpu_shares.
4. Added Documentation about the group scheduler.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

---
 Documentation/sched-design-CFS.txt |   67 ++++++++++
 include/linux/sched.h              |   11 +
 kernel/ksysfs.c                    |    8 +
 kernel/sched.c                     |   14 +-
 kernel/sched_debug.c               |   48 -------
 kernel/user.c                      |  242 ++++++++++++++++++++++++++++++++-----
 6 files changed, 310 insertions(+), 80 deletions(-)

Index: linux-2.6.23-rc8-sched-devel/Documentation/sched-design-CFS.txt
===================================================================
--- linux-2.6.23-rc8-sched-devel.orig/Documentation/sched-design-CFS.txt
+++ linux-2.6.23-rc8-sched-devel/Documentation/sched-design-CFS.txt
@@ -117,3 +117,70 @@ Some implementation details:
    iterators of the scheduling modules are used. The balancing code got
    quite a bit simpler as a result.
 
+
+Group scheduler extension to CFS
+================================
+
+Normally the scheduler operates on individual tasks and strives to provide
+fair CPU time to each task. Sometimes, it may be desirable to group tasks
+and provide fair CPU time to each such task group. For example, it may
+be desirable to first provide fair CPU time to each user on the system
+and then to each task belonging to a user.
+
+CONFIG_FAIR_GROUP_SCHED strives to achieve exactly that. It lets
+SCHED_NORMAL/BATCH tasks be be grouped and divides CPU time fairly among such
+groups. At present, there are two (mutually exclusive) mechanisms to group
+tasks for CPU bandwidth control purpose:
+
+	- Based on user id (CONFIG_FAIR_USER_SCHED)
+		In this option, tasks are grouped according to their user id.
+	- Based on "cgroup" pseudo filesystem (CONFIG_FAIR_CGROUP_SCHED)
+		This options lets the administrator create arbitrary groups
+		of tasks, using the "cgroup" pseudo filesystem. See
+		Documentation/cgroups.txt for more information about this
+		filesystem.
+
+Only one of these options to group tasks can be chosen and not both.
+
+Group scheduler tunables:
+
+When CONFIG_FAIR_USER_SCHED is defined, a directory is created in sysfs for
+each new user and a "cpu_share" file is added in that directory.
+
+	# cd /sys/kernel/uids
+	# cat 512/cpu_share		# Display user 512's CPU share
+	1024
+	# echo 2048 > 512/cpu_share	# Modify user 512's CPU share
+	# cat 512/cpu_share		# Display user 512's CPU share
+	2048
+	#
+
+CPU bandwidth between two users are divided in the ratio of their CPU shares.
+For ex: if you would like user "root" to get twice the bandwidth of user
+"guest", then set the cpu_share for both the users such that "root"'s
+cpu_share is twice "guest"'s cpu_share
+
+
+When CONFIG_FAIR_CGROUP_SCHED is defined, a "cpu.shares" file is created
+for each group created using the pseudo filesystem. See example steps
+below to create task groups and modify their CPU share using the "cgroups"
+pseudo filesystem
+
+	# mkdir /dev/cpuctl
+	# mount -t cgroup -ocpu none /dev/cpuctl
+	# cd /dev/cpuctl
+
+	# mkdir multimedia	# create "multimedia" group of tasks
+	# mkdir browser		# create "browser" group of tasks
+
+	# #Configure the multimedia group to receive twice the CPU bandwidth
+	# #that of browser group
+
+	# echo 2048 > multimedia/cpu.shares
+	# echo 1024 > browser/cpu.shares
+
+	# firefox &	# Launch firefox and move it to "browser" group
+	# echo <firefox_pid> > browser/tasks
+
+	# #Launch gmplayer (or your favourite movie player)
+	# echo <movie_player_pid> > multimedia/tasks
Index: linux-2.6.23-rc8-sched-devel/include/linux/sched.h
===================================================================
--- linux-2.6.23-rc8-sched-devel.orig/include/linux/sched.h
+++ linux-2.6.23-rc8-sched-devel/include/linux/sched.h
@@ -86,6 +86,7 @@ struct sched_param {
 #include <linux/timer.h>
 #include <linux/hrtimer.h>
 #include <linux/task_io_accounting.h>
+#include <linux/kobject.h>
 
 #include <asm/processor.h>
 
@@ -598,9 +599,18 @@ struct user_struct {
 
 #ifdef CONFIG_FAIR_USER_SCHED
 	struct task_group *tg;
+	struct kset kset;
+	struct subsys_attribute user_attr;
+	struct work_struct work;
 #endif
 };
 
+#ifdef CONFIG_FAIR_USER_SCHED
+extern int uids_kobject_init(void);
+#else
+static inline int uids_kobject_init(void) { return 0; }
+#endif
+
 extern struct user_struct *find_user(uid_t);
 
 extern struct user_struct root_user;
@@ -1846,6 +1856,7 @@ extern struct task_group *sched_create_g
 extern void sched_destroy_group(struct task_group *tg);
 extern void sched_move_task(struct task_struct *tsk);
 extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
+extern unsigned long sched_group_shares(struct task_group *tg);
 
 #endif
 
Index: linux-2.6.23-rc8-sched-devel/kernel/ksysfs.c
===================================================================
--- linux-2.6.23-rc8-sched-devel.orig/kernel/ksysfs.c
+++ linux-2.6.23-rc8-sched-devel/kernel/ksysfs.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kexec.h>
+#include <linux/sched.h>
 
 #define KERNEL_ATTR_RO(_name) \
 static struct subsys_attribute _name##_attr = __ATTR_RO(_name)
@@ -116,6 +117,13 @@ static int __init ksysfs_init(void)
 					      &notes_attr);
 	}
 
+	/*
+	 * Create "/sys/kernel/uids" directory and corresponding root user's
+	 * directory under it.
+	 */
+	if (!error)
+		error = uids_kobject_init();
+
 	return error;
 }
 
Index: linux-2.6.23-rc8-sched-devel/kernel/sched.c
===================================================================
--- linux-2.6.23-rc8-sched-devel.orig/kernel/sched.c
+++ linux-2.6.23-rc8-sched-devel/kernel/sched.c
@@ -161,6 +161,8 @@ struct task_group {
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
 	unsigned long shares;
+	/* spinlock to serialize modification to shares */
+	spinlock_t lock;
 };
 
 /* Default task group's sched entity on each cpu */
@@ -6552,6 +6554,7 @@ void __init sched_init(void)
 			se->parent = NULL;
 		}
 		init_task_group.shares = init_task_group_load;
+		spin_lock_init(&init_task_group.lock);
 #endif
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
@@ -6796,6 +6799,7 @@ struct task_group *sched_create_group(vo
 	}
 
 	tg->shares = NICE_0_LOAD;
+	spin_lock_init(&tg->lock);
 
 	return tg;
 
@@ -6916,8 +6920,9 @@ int sched_group_set_shares(struct task_g
 {
 	int i;
 
+	spin_lock(&tg->lock);
 	if (tg->shares == shares)
-		return 0;
+		goto done;
 
 	/* return -EINVAL if the new value is not sane */
 
@@ -6925,7 +6930,14 @@ int sched_group_set_shares(struct task_g
 	for_each_possible_cpu(i)
 		set_se_shares(tg->se[i], shares);
 
+done:
+	spin_unlock(&tg->lock);
 	return 0;
 }
 
+unsigned long sched_group_shares(struct task_group *tg)
+{
+	return tg->shares;
+}
+
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
Index: linux-2.6.23-rc8-sched-devel/kernel/sched_debug.c
===================================================================
--- linux-2.6.23-rc8-sched-devel.orig/kernel/sched_debug.c
+++ linux-2.6.23-rc8-sched-devel/kernel/sched_debug.c
@@ -231,45 +231,6 @@ static void sysrq_sched_debug_show(void)
 	sched_debug_show(NULL, NULL);
 }
 
-#ifdef CONFIG_FAIR_USER_SCHED
-
-static DEFINE_MUTEX(root_user_share_mutex);
-
-static int
-root_user_share_read_proc(char *page, char **start, off_t off, int count,
-				 int *eof, void *data)
-{
-	return sprintf(page, "%d\n", init_task_group_load);
-}
-
-static int
-root_user_share_write_proc(struct file *file, const char __user *buffer,
-				 unsigned long count, void *data)
-{
-	unsigned long shares;
-	char kbuf[sizeof(unsigned long)+1];
-	int rc = 0;
-
-	if (copy_from_user(kbuf, buffer, sizeof(kbuf)))
-		return -EFAULT;
-
-	shares = simple_strtoul(kbuf, NULL, 0);
-
-	if (!shares)
-		shares = NICE_0_LOAD;
-
-	mutex_lock(&root_user_share_mutex);
-
-	init_task_group_load = shares;
-	rc = sched_group_set_shares(&init_task_group, shares);
-
-	mutex_unlock(&root_user_share_mutex);
-
-	return (rc < 0 ? rc : count);
-}
-
-#endif	/* CONFIG_FAIR_USER_SCHED */
-
 static int sched_debug_open(struct inode *inode, struct file *filp)
 {
 	return single_open(filp, sched_debug_show, NULL);
@@ -292,15 +253,6 @@ static int __init init_sched_debug_procf
 
 	pe->proc_fops = &sched_debug_fops;
 
-#ifdef CONFIG_FAIR_USER_SCHED
-	pe = create_proc_entry("root_user_cpu_share", 0644, NULL);
-	if (!pe)
-		return -ENOMEM;
-
-	pe->read_proc = root_user_share_read_proc;
-	pe->write_proc = root_user_share_write_proc;
-#endif
-
 	return 0;
 }
 
Index: linux-2.6.23-rc8-sched-devel/kernel/user.c
===================================================================
--- linux-2.6.23-rc8-sched-devel.orig/kernel/user.c
+++ linux-2.6.23-rc8-sched-devel/kernel/user.c
@@ -55,7 +55,41 @@ struct user_struct root_user = {
 #endif
 };
 
+/*
+ * These routines must be called with the uidhash spinlock held!
+ */
+static inline void uid_hash_insert(struct user_struct *up,
+						struct hlist_head *hashent)
+{
+	hlist_add_head(&up->uidhash_node, hashent);
+}
+
+static inline void uid_hash_remove(struct user_struct *up)
+{
+	hlist_del_init(&up->uidhash_node);
+}
+
+static inline struct user_struct *uid_hash_find(uid_t uid,
+						struct hlist_head *hashent)
+{
+	struct user_struct *user;
+	struct hlist_node *h;
+
+	hlist_for_each_entry(user, h, hashent, uidhash_node) {
+		if (user->uid == uid) {
+			atomic_inc(&user->__count);
+			return user;
+		}
+	}
+
+	return NULL;
+}
+
 #ifdef CONFIG_FAIR_USER_SCHED
+
+static struct kobject uids_kobject; /* represents /sys/kernel/uids directory */
+static DEFINE_MUTEX(uids_mutex);
+
 static void sched_destroy_user(struct user_struct *up)
 {
 	sched_destroy_group(up->tg);
@@ -77,42 +111,173 @@ static void sched_switch_user(struct tas
 	sched_move_task(p);
 }
 
-#else	/* CONFIG_FAIR_USER_SCHED */
+static inline void uids_mutex_lock(void)
+{
+	mutex_lock(&uids_mutex);
+}
 
-static void sched_destroy_user(struct user_struct *up) { }
-static int sched_create_user(struct user_struct *up) { return 0; }
-static void sched_switch_user(struct task_struct *p) { }
+static inline void uids_mutex_unlock(void)
+{
+	mutex_unlock(&uids_mutex);
+}
 
-#endif	/* CONFIG_FAIR_USER_SCHED */
+/* return cpu shares held by the user */
+ssize_t cpu_shares_show(struct kset *kset, char *buffer)
+{
+	struct user_struct *up = container_of(kset, struct user_struct, kset);
 
-/*
- * These routines must be called with the uidhash spinlock held!
- */
-static inline void uid_hash_insert(struct user_struct *up, struct hlist_head *hashent)
+	return sprintf(buffer, "%lu\n", sched_group_shares(up->tg));
+}
+
+/* modify cpu shares held by the user */
+ssize_t cpu_shares_store(struct kset *kset, const char *buffer, size_t size)
 {
-	hlist_add_head(&up->uidhash_node, hashent);
+	struct user_struct *up = container_of(kset, struct user_struct, kset);
+	unsigned long shares;
+	int rc;
+
+	sscanf(buffer, "%lu", &shares);
+
+	rc = sched_group_set_shares(up->tg, shares);
+
+	return (rc ? rc : size);
 }
 
-static inline void uid_hash_remove(struct user_struct *up)
+static void user_attr_init(struct subsys_attribute *sa, char *name, int mode)
 {
-	hlist_del_init(&up->uidhash_node);
+	sa->attr.name = name;
+	sa->attr.mode = mode;
+	sa->show = cpu_shares_show;
+	sa->store = cpu_shares_store;
 }
 
-static inline struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
+/* Create "/sys/kernel/uids/<uid>" directory and
+ *  "/sys/kernel/uids/<uid>/cpu_share" file for this user.
+ */
+static int user_kobject_create(struct user_struct *up)
 {
-	struct user_struct *user;
-	struct hlist_node *h;
+	struct kset *kset = &up->kset;
+	struct kobject *kobj = &kset->kobj;
+	int error;
+
+	memset(kset, 0, sizeof(struct kset));
+	kobj->parent = &uids_kobject;	/* create under /sys/kernel/uids dir */
+	kobject_set_name(kobj, "%d", up->uid);
+	kset_init(kset);
+	user_attr_init(&up->user_attr, "cpu_share", 0644);
+
+	error = kobject_add(kobj);
+	if (error)
+		goto done;
+
+	error = sysfs_create_file(kobj, &up->user_attr.attr);
+	if (error)
+		kobject_del(kobj);
+
+done:
+	return error;
+}
+
+/* create these in sysfs filesystem:
+ * 	"/sys/kernel/uids" directory
+ * 	"/sys/kernel/uids/0" directory (for root user)
+ * 	"/sys/kernel/uids/0/cpu_share" file (for root user)
+ */
+int __init uids_kobject_init(void)
+{
+	int error;
 
-	hlist_for_each_entry(user, h, hashent, uidhash_node) {
-		if(user->uid == uid) {
-			atomic_inc(&user->__count);
-			return user;
-		}
+	/* create under /sys/kernel dir */
+	uids_kobject.parent = &kernel_subsys.kobj;
+	kobject_set_name(&uids_kobject, "uids");
+	kobject_init(&uids_kobject);
+
+	error = kobject_add(&uids_kobject);
+	if (!error)
+		error = user_kobject_create(&root_user);
+
+	return error;
+}
+
+/* work function to remove sysfs directory for a user and free up
+ * corresponding structures.
+ */
+static void remove_user_sysfs_dir(struct work_struct *w)
+{
+	struct user_struct *up = container_of(w, struct user_struct, work);
+	struct kobject *kobj = &up->kset.kobj;
+	unsigned long flags;
+	int remove_user = 0;
+
+	/* Make uid_hash_remove() + sysfs_remove_file() + kobject_del()
+	 * atomic.
+	 */
+	uids_mutex_lock();
+
+	local_irq_save(flags);
+
+	if (atomic_dec_and_lock(&up->__count, &uidhash_lock)) {
+		uid_hash_remove(up);
+		remove_user = 1;
+		spin_unlock_irqrestore(&uidhash_lock, flags);
+	} else {
+		local_irq_restore(flags);
 	}
 
-	return NULL;
+	if (!remove_user)
+		goto done;
+
+	sysfs_remove_file(kobj, &up->user_attr.attr);
+	kobject_del(kobj);
+
+	sched_destroy_user(up);
+	key_put(up->uid_keyring);
+	key_put(up->session_keyring);
+	kmem_cache_free(uid_cachep, up);
+
+done:
+	uids_mutex_unlock();
+}
+
+/* IRQs are disabled and uidhash_lock is held upon function entry.
+ * IRQ state (as stored in flags) is restored and uidhash_lock released
+ * upon function exit.
+ */
+static inline void free_user(struct user_struct *up, unsigned long flags)
+{
+	/* restore back the count */
+	atomic_inc(&up->__count);
+	spin_unlock_irqrestore(&uidhash_lock, flags);
+
+	INIT_WORK(&up->work, remove_user_sysfs_dir);
+	schedule_work(&up->work);
+}
+
+#else	/* CONFIG_FAIR_USER_SCHED */
+
+static void sched_destroy_user(struct user_struct *up) { }
+static int sched_create_user(struct user_struct *up) { return 0; }
+static void sched_switch_user(struct task_struct *p) { }
+static inline int user_kobject_create(struct user_struct *up) { return 0; }
+static inline void uids_mutex_lock(void) { }
+static inline void uids_mutex_unlock(void) { }
+
+/* IRQs are disabled and uidhash_lock is held upon function entry.
+ * IRQ state (as stored in flags) is restored and uidhash_lock released
+ * upon function exit.
+ */
+static inline void free_user(struct user_struct *up, unsigned long flags)
+{
+	uid_hash_remove(up);
+	spin_unlock_irqrestore(&uidhash_lock, flags);
+	sched_destroy_user(up);
+	key_put(up->uid_keyring);
+	key_put(up->session_keyring);
+	kmem_cache_free(uid_cachep, up);
 }
 
+#endif	/* CONFIG_FAIR_USER_SCHED */
+
 /*
  * Locate the user_struct for the passed UID.  If found, take a ref on it.  The
  * caller must undo that ref with free_uid().
@@ -139,16 +304,10 @@ void free_uid(struct user_struct *up)
 		return;
 
 	local_irq_save(flags);
-	if (atomic_dec_and_lock(&up->__count, &uidhash_lock)) {
-		uid_hash_remove(up);
-		spin_unlock_irqrestore(&uidhash_lock, flags);
-		sched_destroy_user(up);
-		key_put(up->uid_keyring);
-		key_put(up->session_keyring);
-		kmem_cache_free(uid_cachep, up);
-	} else {
+	if (atomic_dec_and_lock(&up->__count, &uidhash_lock))
+		free_user(up, flags);
+	else
 		local_irq_restore(flags);
-	}
 }
 
 struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
@@ -156,6 +315,11 @@ struct user_struct * alloc_uid(struct us
 	struct hlist_head *hashent = uidhashentry(ns, uid);
 	struct user_struct *up;
 
+	/* Make uid_hash_find() + user_kobject_create() + uid_hash_insert()
+	 * atomic.
+	 */
+	uids_mutex_lock();
+
 	spin_lock_irq(&uidhash_lock);
 	up = uid_hash_find(uid, hashent);
 	spin_unlock_irq(&uidhash_lock);
@@ -191,6 +355,15 @@ struct user_struct * alloc_uid(struct us
 			return NULL;
 		}
 
+		if (user_kobject_create(new)) {
+			sched_destroy_user(new);
+			key_put(new->uid_keyring);
+			key_put(new->session_keyring);
+			kmem_cache_free(uid_cachep, new);
+			uids_mutex_unlock();
+			return NULL;
+		}
+
 		/*
 		 * Before adding this, check whether we raced
 		 * on adding the same user already..
@@ -198,7 +371,11 @@ struct user_struct * alloc_uid(struct us
 		spin_lock_irq(&uidhash_lock);
 		up = uid_hash_find(uid, hashent);
 		if (up) {
-			sched_destroy_user(new);
+			/* This case is not possible when CONFIG_FAIR_USER_SCHED
+			 * is defined, since we serialize alloc_uid() using
+			 * uids_mutex. Hence no need to call
+			 * sched_destroy_user() or remove_user_sysfs_dir().
+			 */
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
 			kmem_cache_free(uid_cachep, new);
@@ -209,6 +386,9 @@ struct user_struct * alloc_uid(struct us
 		spin_unlock_irq(&uidhash_lock);
 
 	}
+
+	uids_mutex_unlock();
+
 	return up;
 }
 
-- 
regards,
Dhaval
