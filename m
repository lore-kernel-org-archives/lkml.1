Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbXJAOJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbXJAOJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbXJAOJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:09:41 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:41056 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbXJAOJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:09:40 -0400
Date: Mon, 1 Oct 2007 19:34:54 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: [RFC/PATCH] Add sysfs control to modify a user's cpu share
Message-ID: <20071001140454.GA19439@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20070925102855.GL26289@linux.vnet.ibm.com> <1190723327.7112.5.camel@Homer.simpson.net> <1190724893.13716.8.camel@Homer.simpson.net> <20070925131717.GM26289@linux.vnet.ibm.com> <1190725693.13716.10.camel@Homer.simpson.net> <20070925132528.GN26289@linux.vnet.ibm.com> <1190726682.11260.1.camel@Homer.simpson.net> <20070925140559.GB26310@linux.vnet.ibm.com> <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926210737.GA8663@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

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

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

---
 include/linux/sched.h |   11 +++++
 kernel/ksysfs.c       |    4 +
 kernel/sched.c        |    5 ++
 kernel/user.c         |  110 +++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 129 insertions(+), 1 deletion(-)

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
+ 	struct kset kset;
+ 	struct subsys_attribute user_attr;
+ 	struct work_struct work;
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
@@ -116,6 +117,9 @@ static int __init ksysfs_init(void)
 					      &notes_attr);
 	}
 
+	if (!error)
+		error = uids_kobject_init();
+
 	return error;
 }
 
Index: linux-2.6.23-rc8-sched-devel/kernel/sched.c
===================================================================
--- linux-2.6.23-rc8-sched-devel.orig/kernel/sched.c
+++ linux-2.6.23-rc8-sched-devel/kernel/sched.c
@@ -6928,4 +6928,9 @@ int sched_group_set_shares(struct task_g
 	return 0;
 }
 
+unsigned long sched_group_shares(struct task_group *tg)
+{
+	return tg->shares;
+}
+
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
Index: linux-2.6.23-rc8-sched-devel/kernel/user.c
===================================================================
--- linux-2.6.23-rc8-sched-devel.orig/kernel/user.c
+++ linux-2.6.23-rc8-sched-devel/kernel/user.c
@@ -56,6 +56,62 @@ struct user_struct root_user = {
 };
 
 #ifdef CONFIG_FAIR_USER_SCHED
+
+static struct kobject uids_kobject;
+
+ssize_t cpu_shares_show(struct kset *kset, char *buffer)
+{
+	struct user_struct *up = container_of(kset, struct user_struct, kset);
+
+	return sprintf(buffer, "%lu\n", sched_group_shares(up->tg));
+}
+
+ssize_t cpu_shares_store(struct kset *kset, const char *buffer, size_t size)
+{
+	struct user_struct *up = container_of(kset, struct user_struct, kset);
+	unsigned long shares;
+	int rc;
+
+	sscanf(buffer, "%lu", &shares);
+
+	rc = sched_group_set_shares(up->tg, shares);
+
+	return (rc ? rc : size);
+}
+
+static void user_attr_init(struct subsys_attribute *sa, char *name, int mode)
+{
+	sa->attr.name = name;
+	sa->attr.mode = mode;
+	sa->show = cpu_shares_show;
+	sa->store = cpu_shares_store;
+}
+
+static int user_kobject_create(struct user_struct *up)
+{
+	struct kset *kset = &up->kset;
+	struct kobject *kobj = &kset->kobj;
+	int error;
+
+	memset(kset, 0, sizeof(struct kset));
+	kobj->parent = &uids_kobject;
+	kobject_set_name(kobj, "%d", up->uid);
+	kset_init(kset);
+	user_attr_init(&up->user_attr, "cpu_share", 0644);
+
+	error = kobject_add(kobj);
+
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
 static void sched_destroy_user(struct user_struct *up)
 {
 	sched_destroy_group(up->tg);
@@ -77,11 +133,53 @@ static void sched_switch_user(struct tas
 	sched_move_task(p);
 }
 
+int __init uids_kobject_init(void)
+{
+	int error;
+
+	uids_kobject.parent = &kernel_subsys.kobj;
+	kobject_set_name(&uids_kobject, "uids");
+	kobject_init(&uids_kobject);
+	error = kobject_add(&uids_kobject);
+
+	if (!error)
+		error = user_kobject_create(&root_user);
+
+	return error;
+}
+
+static void remove_user_sysfs_dir(struct work_struct *w)
+{
+	struct user_struct *up = container_of(w, struct user_struct, work);
+	struct kobject *kobj = &up->kset.kobj;
+
+	sysfs_remove_file(kobj, &up->user_attr.attr);
+	kobject_del(kobj);
+	kmem_cache_free(uid_cachep, up);
+}
+
+static inline void free_user(struct user_struct *up)
+{
+	struct kobject *kobj = &up->kset.kobj;
+
+	if (!kobj->sd)
+		return;
+
+	INIT_WORK(&up->work, remove_user_sysfs_dir);
+	schedule_work(&up->work);
+}
+
 #else	/* CONFIG_FAIR_USER_SCHED */
 
 static void sched_destroy_user(struct user_struct *up) { }
 static int sched_create_user(struct user_struct *up) { return 0; }
 static void sched_switch_user(struct task_struct *p) { }
+static inline int user_kobject_create(struct user_struct *up) { return 0; }
+
+static inline void free_user(struct user_struct *up)
+{
+	kmem_cache_free(uid_cachep, up);
+}
 
 #endif	/* CONFIG_FAIR_USER_SCHED */
 
@@ -145,7 +243,7 @@ void free_uid(struct user_struct *up)
 		sched_destroy_user(up);
 		key_put(up->uid_keyring);
 		key_put(up->session_keyring);
-		kmem_cache_free(uid_cachep, up);
+		free_user(up);
 	} else {
 		local_irq_restore(flags);
 	}
@@ -155,6 +253,7 @@ struct user_struct * alloc_uid(struct us
 {
 	struct hlist_head *hashent = uidhashentry(ns, uid);
 	struct user_struct *up;
+	int create_sysfs_dir = 0;
 
 	spin_lock_irq(&uidhash_lock);
 	up = uid_hash_find(uid, hashent);
@@ -205,10 +304,19 @@ struct user_struct * alloc_uid(struct us
 		} else {
 			uid_hash_insert(new, hashent);
 			up = new;
+			create_sysfs_dir = 1;
 		}
 		spin_unlock_irq(&uidhash_lock);
 
 	}
+
+	if (create_sysfs_dir) {
+		if (user_kobject_create(up)) {
+			free_uid(up);
+			up = NULL;
+		}
+	}
+
 	return up;
 }
 
-- 
regards,
Dhaval
