Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbZDOKOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbZDOKOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759387AbZDOKOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:14:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:55497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759383AbZDOKOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:14:03 -0400
Date: Wed, 15 Apr 2009 10:13:37 GMT
From: tip-bot for Jiri Pirko <jpirko@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu, jpirko@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, jpirko@redhat.com,
       mingo@elte.hu
In-Reply-To: <20090414181715.GA3634@psychotron.englab.brq.redhat.com>
References: <20090414181715.GA3634@psychotron.englab.brq.redhat.com>
Subject: [tip:core/rcu] rculist: use list_entry_rcu in places where it's appropriate
Message-ID: <tip-05725f7eb4b8acb147c5fc7b91397b1f6bcab00d@git.kernel.org>
Git-Commit-ID: 05725f7eb4b8acb147c5fc7b91397b1f6bcab00d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Apr 2009 10:13:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05725f7eb4b8acb147c5fc7b91397b1f6bcab00d
Gitweb:     http://git.kernel.org/tip/05725f7eb4b8acb147c5fc7b91397b1f6bcab00d
Author:     Jiri Pirko <jpirko@redhat.com>
AuthorDate: Tue, 14 Apr 2009 20:17:16 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Apr 2009 12:05:25 +0200

rculist: use list_entry_rcu in places where it's appropriate

Use previously introduced list_entry_rcu instead of an open-coded
list_entry + rcu_dereference combination.

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: dipankar@in.ibm.com
LKML-Reference: <20090414181715.GA3634@psychotron.englab.brq.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h           |    8 +++++---
 ipc/sem.c                       |    4 ++--
 security/integrity/ima/ima_fs.c |    4 ++--
 security/smack/smackfs.c        |    8 ++++----
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4c38bc..886df41 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -77,6 +77,7 @@ struct sched_param {
 #include <linux/proportions.h>
 #include <linux/seccomp.h>
 #include <linux/rcupdate.h>
+#include <linux/rculist.h>
 #include <linux/rtmutex.h>
 
 #include <linux/time.h>
@@ -2010,7 +2011,8 @@ static inline unsigned long wait_task_inactive(struct task_struct *p,
 }
 #endif
 
-#define next_task(p)	list_entry(rcu_dereference((p)->tasks.next), struct task_struct, tasks)
+#define next_task(p) \
+	list_entry_rcu((p)->tasks.next, struct task_struct, tasks)
 
 #define for_each_process(p) \
 	for (p = &init_task ; (p = next_task(p)) != &init_task ; )
@@ -2049,8 +2051,8 @@ int same_thread_group(struct task_struct *p1, struct task_struct *p2)
 
 static inline struct task_struct *next_thread(const struct task_struct *p)
 {
-	return list_entry(rcu_dereference(p->thread_group.next),
-			  struct task_struct, thread_group);
+	return list_entry_rcu(p->thread_group.next,
+			      struct task_struct, thread_group);
 }
 
 static inline int thread_group_empty(struct task_struct *p)
diff --git a/ipc/sem.c b/ipc/sem.c
index 16a2189..87c2b64 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1290,8 +1290,8 @@ void exit_sem(struct task_struct *tsk)
 		int i;
 
 		rcu_read_lock();
-		un = list_entry(rcu_dereference(ulp->list_proc.next),
-					struct sem_undo, list_proc);
+		un = list_entry_rcu(ulp->list_proc.next,
+				    struct sem_undo, list_proc);
 		if (&un->list_proc == &ulp->list_proc)
 			semid = -1;
 		 else
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index ffbe259..510186f 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -84,8 +84,8 @@ static void *ima_measurements_next(struct seq_file *m, void *v, loff_t *pos)
 	 * against concurrent list-extension
 	 */
 	rcu_read_lock();
-	qe = list_entry(rcu_dereference(qe->later.next),
-			struct ima_queue_entry, later);
+	qe = list_entry_rcu(qe->later.next,
+			    struct ima_queue_entry, later);
 	rcu_read_unlock();
 	(*pos)++;
 
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index e03a7e1..11d2cb1 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -734,8 +734,8 @@ static void smk_netlbladdr_insert(struct smk_netlbladdr *new)
 		return;
 	}
 
-	m = list_entry(rcu_dereference(smk_netlbladdr_list.next),
-			 struct smk_netlbladdr, list);
+	m = list_entry_rcu(smk_netlbladdr_list.next,
+			   struct smk_netlbladdr, list);
 
 	/* the comparison '>' is a bit hacky, but works */
 	if (new->smk_mask.s_addr > m->smk_mask.s_addr) {
@@ -748,8 +748,8 @@ static void smk_netlbladdr_insert(struct smk_netlbladdr *new)
 			list_add_rcu(&new->list, &m->list);
 			return;
 		}
-		m_next = list_entry(rcu_dereference(m->list.next),
-				 struct smk_netlbladdr, list);
+		m_next = list_entry_rcu(m->list.next,
+					struct smk_netlbladdr, list);
 		if (new->smk_mask.s_addr > m_next->smk_mask.s_addr) {
 			list_add_rcu(&new->list, &m->list);
 			return;
