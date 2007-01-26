Return-Path: <linux-kernel-owner+w=401wt.eu-S1030757AbXAZGFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030757AbXAZGFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030777AbXAZGFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:05:05 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36169 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030757AbXAZGFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:05:01 -0500
Date: Fri, 26 Jan 2007 11:35:03 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: riel@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Track number of users in the system
Message-ID: <20070126060503.GC2487@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070126060142.GA2487@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126060142.GA2487@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tracks number of users in a system and divides cpu bandwidth 
equally among them.

Signed-off-by : Srivatsa Vaddagiri <vatsa@in.ibm.com>


---


diff -puN include/linux/sched.h~user-interface include/linux/sched.h
--- linux-2.6.20-rc5/include/linux/sched.h~user-interface	2007-01-25 20:44:53.000000000 +0530
+++ linux-2.6.20-rc5-vatsa/include/linux/sched.h	2007-01-25 20:44:53.000000000 +0530
@@ -533,7 +533,18 @@ struct signal_struct {
 
 #ifdef CONFIG_FAIRSCHED
 struct cpu_usage;
-#endif
+
+int sched_alloc_user(struct user_struct *user);
+void sched_free_user(struct user_struct *user);
+void sched_move_task(void);
+
+#else
+
+static inline int sched_alloc_user(struct user_struct *user) { return 0; }
+static inline void sched_free_user(struct user_struct *user) { }
+static inline void sched_move_task(void) { }
+
+#endif /* CONFIG_FAIRSCHED */
 
 /*
  * Some day this will be a full-fledged user tracking system..
@@ -562,6 +573,7 @@ struct user_struct {
 #ifdef CONFIG_FAIRSCHED
 	int cpu_limit;
 	struct cpu_usage *cpu_usage;
+	struct list_head fair_sched_list;
 #endif
 };
 
diff -puN kernel/user.c~user-interface kernel/user.c
--- linux-2.6.20-rc5/kernel/user.c~user-interface	2007-01-25 20:44:53.000000000 +0530
+++ linux-2.6.20-rc5-vatsa/kernel/user.c	2007-01-25 20:44:53.000000000 +0530
@@ -51,6 +51,10 @@ struct user_struct root_user = {
 	.uid_keyring	= &root_user_keyring,
 	.session_keyring = &root_session_keyring,
 #endif
+#ifdef CONFIG_FAIRSCHED
+	.cpu_limit = 0,		/* No limit */
+	.fair_sched_list = LIST_HEAD_INIT(root_user.fair_sched_list),
+#endif
 };
 
 /*
@@ -112,6 +116,7 @@ void free_uid(struct user_struct *up)
 	if (atomic_dec_and_lock(&up->__count, &uidhash_lock)) {
 		uid_hash_remove(up);
 		spin_unlock_irqrestore(&uidhash_lock, flags);
+		sched_free_user(up);
 		key_put(up->uid_keyring);
 		key_put(up->session_keyring);
 		kmem_cache_free(uid_cachep, up);
@@ -153,6 +158,8 @@ struct user_struct * alloc_uid(uid_t uid
 			return NULL;
 		}
 
+		sched_alloc_user(new);
+
 		/*
 		 * Before adding this, check whether we raced
 		 * on adding the same user already..
@@ -163,6 +170,7 @@ struct user_struct * alloc_uid(uid_t uid
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
 			kmem_cache_free(uid_cachep, new);
+			sched_free_user(new);
 		} else {
 			uid_hash_insert(new, hashent);
 			up = new;
@@ -186,6 +194,7 @@ void switch_uid(struct user_struct *new_
 	atomic_inc(&new_user->processes);
 	atomic_dec(&old_user->processes);
 	switch_uid_keyring(new_user);
+	sched_move_task();
 	current->user = new_user;
 
 	/*
diff -puN kernel/sched.c~user-interface kernel/sched.c
--- linux-2.6.20-rc5/kernel/sched.c~user-interface	2007-01-25 20:44:53.000000000 +0530
+++ linux-2.6.20-rc5-vatsa/kernel/sched.c	2007-01-26 09:04:04.000000000 +0530
@@ -7221,3 +7221,63 @@ void set_curr_task(int cpu, struct task_
 }
 
 #endif
+
+#ifdef CONFIG_FAIRSCHED
+
+static struct list_head user_list = LIST_HEAD_INIT(user_list);
+static atomic_t non_root_users;
+
+static void recalc_user_limits(void)
+{
+	int nr_users;
+	struct user_struct *user;
+
+	nr_users = atomic_read(&non_root_users);
+	if (!nr_users)
+		return;
+
+	list_for_each_entry(user, &user_list, fair_sched_list)
+		user->cpu_limit = 100/nr_users;
+}
+
+/* Allocate cpu_usage structure for the new task-group */
+int sched_alloc_user(struct user_struct *user)
+{
+	int i;
+
+	user->cpu_usage = alloc_percpu(struct cpu_usage);
+	if (!user->cpu_usage)
+		return -ENOMEM;
+
+	for_each_possible_cpu(i) {
+		struct cpu_usage *cu;
+
+		cu = per_cpu_ptr(user->cpu_usage, i);
+		cu->tokens = 1;
+		cu->last_update = 0;
+		cu->starve_count = 0;
+	}
+
+	list_add(&user->fair_sched_list, &user_list);
+	atomic_inc(&non_root_users);
+
+	recalc_user_limits();
+
+	return 0;
+}
+
+/* Deallocate cpu_usage structure */
+void sched_free_user(struct user_struct *user)
+{
+	list_del(&user->fair_sched_list);
+	atomic_dec(&non_root_users);
+	recalc_user_limits();
+	free_percpu(user->cpu_usage);
+}
+
+void sched_move_task(void)
+{
+	clear_tsk_starving(current);
+}
+
+#endif
diff -puN init/Kconfig~user-interface init/Kconfig
--- linux-2.6.20-rc5/init/Kconfig~user-interface	2007-01-25 20:44:53.000000000 +0530
+++ linux-2.6.20-rc5-vatsa/init/Kconfig	2007-01-25 20:44:54.000000000 +0530
@@ -249,6 +249,13 @@ config CPUSETS
 
 	  Say N if unsure.
 
+config FAIRSCHED
+	bool "Fair user CPU scheduler"
+	depends on EXPERIMENTAL
+	help
+	  This options lets you allocate equal cpu bandwidth to each
+	  non-root user.
+
 config SYSFS_DEPRECATED
 	bool "Create deprecated sysfs files"
 	default y
_

-- 
Regards,
vatsa
