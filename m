Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab0BXUFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:05:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63878 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab0BXUF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:05:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: [PATCH 08/10] pid: __rcu annotations
Date: Wed, 24 Feb 2010 21:04:04 +0100
Message-Id: <1267041846-10469-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267041846-10469-1-git-send-email-arnd@arndb.de>
References: <1267041846-10469-1-git-send-email-arnd@arndb.de>
In-Reply-To: <20100223180127.GF6700@linux.vnet.ibm.com>
References: <20100223180127.GF6700@linux.vnet.ibm.com>
X-Provags-ID: V01U2FsdGVkX19UZt8XMfYzMH5m9G5c42B1LWgzS/KwTStMWNz
 +2y/4flrlX8IshlCUdFqCM8DIgFRmUjxt6hGGsqQC/j/SbELSg
 Aik512X0krwcwDKUGNRKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This demonstrates static initialization of __rcu annotated
variables using RCU_INIT_POINTER.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/init_task.h |    6 +++---
 include/linux/pid.h       |    9 +++++----
 kernel/pid.c              |    8 ++++----
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index abec69b..c9cf902 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -53,9 +53,9 @@ extern struct group_info init_groups;
 #define INIT_STRUCT_PID {						\
 	.count 		= ATOMIC_INIT(1),				\
 	.tasks		= {						\
-		{ .first = &init_task.pids[PIDTYPE_PID].node },		\
-		{ .first = &init_task.pids[PIDTYPE_PGID].node },	\
-		{ .first = &init_task.pids[PIDTYPE_SID].node },		\
+		{ RCU_INIT_POINTER(.first, &init_task.pids[PIDTYPE_PID].node)  }, \
+		{ RCU_INIT_POINTER(.first, &init_task.pids[PIDTYPE_PGID].node) }, \
+		{ RCU_INIT_POINTER(.first, &init_task.pids[PIDTYPE_SID].node)  }, \
 	},								\
 	.rcu		= RCU_HEAD_INIT,				\
 	.level		= 0,						\
diff --git a/include/linux/pid.h b/include/linux/pid.h
index 49f1c2f..8eb2aa1 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -2,6 +2,7 @@
 #define _LINUX_PID_H
 
 #include <linux/rcupdate.h>
+#include <linux/rculist.h>
 
 enum pid_type
 {
@@ -51,7 +52,7 @@ struct upid {
 	/* Try to keep pid_chain in the same cacheline as nr for find_vpid */
 	int nr;
 	struct pid_namespace *ns;
-	struct hlist_node pid_chain;
+	struct rcu_hlist_node pid_chain;
 };
 
 struct pid
@@ -59,7 +60,7 @@ struct pid
 	atomic_t count;
 	unsigned int level;
 	/* lists of tasks that use this pid */
-	struct hlist_head tasks[PIDTYPE_MAX];
+	struct rcu_hlist_head tasks[PIDTYPE_MAX];
 	struct rcu_head rcu;
 	struct upid numbers[1];
 };
@@ -68,7 +69,7 @@ extern struct pid init_struct_pid;
 
 struct pid_link
 {
-	struct hlist_node node;
+	struct rcu_hlist_node node;
 	struct pid *pid;
 };
 
@@ -164,7 +165,7 @@ pid_t pid_vnr(struct pid *pid);
 
 #define do_each_pid_task(pid, type, task)				\
 	do {								\
-		struct hlist_node *pos___;				\
+		struct rcu_hlist_node *pos___;				\
 		if ((pid) != NULL)					\
 			hlist_for_each_entry_rcu((task), pos___,	\
 				&(pid)->tasks[type], pids[type].node) {
diff --git a/kernel/pid.c b/kernel/pid.c
index 2e17c9c..871d75e 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -39,7 +39,7 @@
 
 #define pid_hashfn(nr, ns)	\
 	hash_long((unsigned long)nr + (unsigned long)ns, pidhash_shift)
-static struct hlist_head *pid_hash;
+static struct rcu_hlist_head *pid_hash;
 static unsigned int pidhash_shift = 4;
 struct pid init_struct_pid = INIT_STRUCT_PID;
 
@@ -290,7 +290,7 @@ out_free:
 
 struct pid *find_pid_ns(int nr, struct pid_namespace *ns)
 {
-	struct hlist_node *elem;
+	struct rcu_hlist_node *elem;
 	struct upid *pnr;
 
 	hlist_for_each_entry_rcu(pnr, elem,
@@ -336,7 +336,7 @@ static void __change_pid(struct task_struct *task, enum pid_type type,
 	link->pid = new;
 
 	for (tmp = PIDTYPE_MAX; --tmp >= 0; )
-		if (!hlist_empty(&pid->tasks[tmp]))
+		if (!hlist_empty_rcu(&pid->tasks[tmp]))
 			return;
 
 	free_pid(pid);
@@ -366,7 +366,7 @@ struct task_struct *pid_task(struct pid *pid, enum pid_type type)
 {
 	struct task_struct *result = NULL;
 	if (pid) {
-		struct hlist_node *first;
+		struct rcu_hlist_node *first;
 		first = rcu_dereference(pid->tasks[type].first);
 		if (first)
 			result = hlist_entry(first, struct task_struct, pids[(type)].node);
-- 
1.6.3.3

