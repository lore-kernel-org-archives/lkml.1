Return-Path: <linux-kernel-owner+w=401wt.eu-S1761774AbXGFIGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761774AbXGFIGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 04:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761373AbXGFIFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 04:05:43 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:2296 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760733AbXGFIFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 04:05:41 -0400
Message-ID: <468DF76A.7060106@openvz.org>
Date: Fri, 06 Jul 2007 12:03:54 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Sukadev Bhattiprolu <sukadev@us.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: [PATCH 2/16] Miscelaneous preparations for namespaces
References: <468DF6F7.1010906@openvz.org>
In-Reply-To: <468DF6F7.1010906@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The most importaint change is moving exit_task_namespaces()
inside exit_notify() to makes it possible to notify the
exiting task's parent. However this should be done before
release_task() to address the issue pointed by Sukadev with
NFS kernel thread.

Other changes are small and do not deserve separate description.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

 include/linux/pid_namespace.h |    7 ++++---
 kernel/exit.c                 |    3 ++-
 kernel/pid.c                  |    2 ++
 3 files changed, 8 insertions(+), 4 deletions(-)

--- ./include/linux/pid_namespace.h.ve1	2007-07-06 10:58:57.000000000 +0400
+++ ./include/linux/pid_namespace.h	2007-07-06 11:03:18.000000000 +0400
@@ -4,7 +4,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/threads.h>
-#include <linux/pid.h>
 #include <linux/nsproxy.h>
 #include <linux/kref.h>
 
@@ -24,9 +23,10 @@ struct pid_namespace {
 
 extern struct pid_namespace init_pid_ns;
 
-static inline void get_pid_ns(struct pid_namespace *ns)
+static inline struct pid_namespace *get_pid_ns(struct pid_namespace *ns)
 {
 	kref_get(&ns->kref);
+	return ns;
 }
 
 extern struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *ns);
@@ -39,7 +39,8 @@ static inline void put_pid_ns(struct pid
 
 static inline struct task_struct *child_reaper(struct task_struct *tsk)
 {
-	return init_pid_ns.child_reaper;
+	BUG_ON(tsk != current);
+	return tsk->nsproxy->pid_ns->child_reaper;
 }
 
 #endif /* _LINUX_PID_NS_H */
--- ./kernel/exit.c.ve1	2007-07-06 11:02:55.000000000 +0400
+++ ./kernel/exit.c	2007-07-06 11:02:55.000000000 +0400
@@ -862,6 +862,8 @@ static void exit_notify(struct task_stru
 		release_task(t);
 	}
 
+	exit_task_namespaces(tsk);
+
 	/* If the process is dead, release it - nobody will wait for it */
 	if (state == EXIT_DEAD)
 		release_task(tsk);
@@ -1002,7 +1004,6 @@ fastcall NORET_TYPE void do_exit(long co
 
 	tsk->exit_code = code;
 	proc_exit_connector(tsk);
-	exit_task_namespaces(tsk);
 	exit_notify(tsk);
 #ifdef CONFIG_NUMA
 	mpol_free(tsk->mempolicy);
--- ./kernel/pid.c.ve1	2007-07-06 10:58:57.000000000 +0400
+++ ./kernel/pid.c	2007-07-06 11:02:55.000000000 +0400
@@ -71,6 +71,8 @@ struct pid_namespace init_pid_ns = {
 	.child_reaper = &init_task
 };
 
+EXPORT_SYMBOL_GPL(init_pid_ns);
+
 /*
  * Note: disable interrupts while the pidmap_lock is held as an
  * interrupt might come in and do read_lock(&tasklist_lock).
