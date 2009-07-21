Return-Path: <linux-kernel-owner+w=401wt.eu-S1752282AbZGUFBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbZGUFBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 01:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZGUFBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 01:01:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbZGUFBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 01:01:11 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] taskstats-fork: Add a new taskstats command to get notification on fork/clone
Date: Tue, 21 Jul 2009 10:31:48 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: balbir@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907211031.48294.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new taskstats command to register for notification, whenever a new task
forks in the cpumask specified.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/include/linux/taskstats.h b/include/linux/taskstats.h
index 341dddb..1623a1f 100644
--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -188,6 +188,7 @@ enum {
 	TASKSTATS_TYPE_STATS,		/* taskstats structure */
 	TASKSTATS_TYPE_AGGR_PID,	/* contains pid + stats */
 	TASKSTATS_TYPE_AGGR_TGID,	/* contains tgid + stats */
+	TASKSTATS_TYPE_PID_TGID,	/* contains pid + tgid */
 	__TASKSTATS_TYPE_MAX,
 };
 
@@ -199,6 +200,8 @@ enum {
 	TASKSTATS_CMD_ATTR_TGID,
 	TASKSTATS_CMD_ATTR_REGISTER_CPUMASK,
 	TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK,
+	TASKSTATS_CMD_ATTR_REGISTER_FORK_CPUMASK,
+	TASKSTATS_CMD_ATTR_DEREGISTER_FORK_CPUMASK,
 	__TASKSTATS_CMD_ATTR_MAX,
 };
 
diff --git a/include/linux/taskstats_kern.h b/include/linux/taskstats_kern.h
index 7e9680f..b727370 100644
--- a/include/linux/taskstats_kern.h
+++ b/include/linux/taskstats_kern.h
@@ -26,9 +26,12 @@ static inline void taskstats_tgid_free(struct signal_struct *sig)
 		kmem_cache_free(taskstats_cache, sig->stats);
 }
 
+extern void taskstats_fork(struct task_struct *);
 extern void taskstats_exit(struct task_struct *, int group_dead);
 extern void taskstats_init_early(void);
 #else
+static inline void taskstats_fork(struct task_struct *tsk)
+{}
 static inline void taskstats_exit(struct task_struct *tsk, int group_dead)
 {}
 static inline void taskstats_tgid_init(struct signal_struct *sig)
diff --git a/kernel/fork.c b/kernel/fork.c
index 467746b..8ed8c9f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1447,6 +1447,7 @@ long do_fork(unsigned long clone_flags,
 			freezer_count();
 			tracehook_report_vfork_done(p, nr);
 		}
+		taskstats_fork(p);
 	} else {
 		nr = PTR_ERR(p);
 	}
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 888adbc..8fcb7d3 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -51,7 +51,9 @@ __read_mostly = {
 	[TASKSTATS_CMD_ATTR_PID]  = { .type = NLA_U32 },
 	[TASKSTATS_CMD_ATTR_TGID] = { .type = NLA_U32 },
 	[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK] = { .type = NLA_STRING },
-	[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK] = { .type = NLA_STRING },};
+	[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK] = { .type = NLA_STRING },
+	[TASKSTATS_CMD_ATTR_REGISTER_FORK_CPUMASK] = { .type = NLA_STRING },
+	[TASKSTATS_CMD_ATTR_DEREGISTER_FORK_CPUMASK] = { .type = NLA_STRING },};
 
 static struct nla_policy
 cgroupstats_cmd_get_policy[CGROUPSTATS_CMD_ATTR_MAX+1] __read_mostly = {
@@ -68,7 +70,13 @@ struct listener_list {
 	struct rw_semaphore sem;
 	struct list_head list;
 };
-static DEFINE_PER_CPU(struct listener_list, listener_array);
+static DEFINE_PER_CPU(struct listener_list, fork_listener_array);
+static DEFINE_PER_CPU(struct listener_list, exit_listener_array);
+
+enum forkexit {
+	FORK,
+	EXIT
+};
 
 enum actions {
 	REGISTER,
@@ -290,7 +298,8 @@ ret:
 	return;
 }
 
-static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
+static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd,
+							 enum forkexit forkexit)
 {
 	struct listener_list *listeners;
 	struct listener *s, *tmp;
@@ -309,7 +318,11 @@ static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
 			INIT_LIST_HEAD(&s->list);
 			s->valid = 1;
 
-			listeners = &per_cpu(listener_array, cpu);
+			if (forkexit == FORK)
+				listeners = &per_cpu(fork_listener_array, cpu);
+			else /* forkexit == EXIT */
+				listeners = &per_cpu(exit_listener_array, cpu);
+
 			down_write(&listeners->sem);
 			list_add(&s->list, &listeners->list);
 			up_write(&listeners->sem);
@@ -320,7 +333,12 @@ static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
 	/* Deregister or cleanup */
 cleanup:
 	for_each_cpu(cpu, mask) {
-		listeners = &per_cpu(listener_array, cpu);
+
+		if (forkexit == FORK)
+			listeners = &per_cpu(fork_listener_array, cpu);
+		else /* forkexit == EXIT */
+			listeners = &per_cpu(exit_listener_array, cpu);
+
 		down_write(&listeners->sem);
 		list_for_each_entry_safe(s, tmp, &listeners->list, list) {
 			if (s->pid == pid) {
@@ -436,11 +454,27 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
 
+	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_REGISTER_FORK_CPUMASK], mask);
+	if (rc < 0)
+		goto free_return_rc;
+	if (rc == 0) {
+		rc = add_del_listener(info->snd_pid, mask, REGISTER, FORK);
+		goto free_return_rc;
+	}
+
+	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_DEREGISTER_FORK_CPUMASK], mask);
+	if (rc < 0)
+		goto free_return_rc;
+	if (rc == 0) {
+		rc = add_del_listener(info->snd_pid, mask, DEREGISTER, FORK);
+		goto free_return_rc;
+	}
+
 	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK], mask);
 	if (rc < 0)
 		goto free_return_rc;
 	if (rc == 0) {
-		rc = add_del_listener(info->snd_pid, mask, REGISTER);
+		rc = add_del_listener(info->snd_pid, mask, REGISTER, EXIT);
 		goto free_return_rc;
 	}
 
@@ -448,7 +482,7 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 	if (rc < 0)
 		goto free_return_rc;
 	if (rc == 0) {
-		rc = add_del_listener(info->snd_pid, mask, DEREGISTER);
+		rc = add_del_listener(info->snd_pid, mask, DEREGISTER, EXIT);
 free_return_rc:
 		free_cpumask_var(mask);
 		return rc;
@@ -517,6 +551,44 @@ ret:
 	return sig->stats;
 }
 
+/* Send pid out on fork/clone */
+void taskstats_fork(struct task_struct *tsk)
+{
+	struct sk_buff *rep_skb;
+	size_t size;
+	struct listener_list *listeners;
+	struct nlattr *na;
+
+	if (!family_registered)
+		return;
+
+	size = nla_total_size(sizeof(u32)) + nla_total_size(sizeof(tsk->tgid))
+				 + nla_total_size(0);
+
+	listeners = &__raw_get_cpu_var(fork_listener_array);
+	if (list_empty(&listeners->list))
+		return;
+
+	if (prepare_reply(NULL, TASKSTATS_CMD_NEW, &rep_skb, size) < 0)
+		return;
+
+	na = nla_nest_start(rep_skb, TASKSTATS_TYPE_PID_TGID);
+	if (!na)
+		goto err;
+	if (nla_put(rep_skb, TASKSTATS_TYPE_PID, sizeof(tsk->pid), &tsk->pid) < 0)
+		goto err;
+	if (nla_put(rep_skb, TASKSTATS_TYPE_TGID, sizeof(tsk->tgid), &tsk->tgid) < 0)
+		goto err;
+        nla_nest_end(rep_skb, na);
+
+	send_cpu_listeners(rep_skb, listeners);
+	return;
+
+err:
+	nlmsg_free(rep_skb);
+
+}
+
 /* Send pid data out on exit */
 void taskstats_exit(struct task_struct *tsk, int group_dead)
 {
@@ -544,7 +616,7 @@ void taskstats_exit(struct task_struct *tsk, int group_dead)
 		fill_tgid_exit(tsk);
 	}
 
-	listeners = &__raw_get_cpu_var(listener_array);
+	listeners = &__raw_get_cpu_var(exit_listener_array);
 	if (list_empty(&listeners->list))
 		return;
 
@@ -598,8 +670,10 @@ void __init taskstats_init_early(void)
 
 	taskstats_cache = KMEM_CACHE(taskstats, SLAB_PANIC);
 	for_each_possible_cpu(i) {
-		INIT_LIST_HEAD(&(per_cpu(listener_array, i).list));
-		init_rwsem(&(per_cpu(listener_array, i).sem));
+		INIT_LIST_HEAD(&(per_cpu(fork_listener_array, i).list));
+		init_rwsem(&(per_cpu(fork_listener_array, i).sem));
+		INIT_LIST_HEAD(&(per_cpu(exit_listener_array, i).list));
+		init_rwsem(&(per_cpu(exit_listener_array, i).sem));
 	}
 }
 

