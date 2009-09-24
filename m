Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbZIXRCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbZIXRCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZIXRCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:02:40 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50931 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbZIXRCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:02:39 -0400
Date: Thu, 24 Sep 2009 10:01:54 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: [RFC][v7][PATCH 5/9]: Add target_pids parameter to alloc_pid()
Message-ID: <20090924170154.GE16989@us.ibm.com>
References: <20090924165548.GA16586@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924165548.GA16586@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Subject: [RFC][v7][PATCH 5/9]: Add target_pids parameter to alloc_pid()

This parameter is currently NULL, but will be used in a follow-on patch.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 include/linux/pid.h |    2 +-
 kernel/fork.c       |    3 ++-
 kernel/pid.c        |    9 +++++++--
 3 files changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/pid.h
===================================================================
--- linux-2.6.orig/include/linux/pid.h	2009-09-10 10:19:20.000000000 -0700
+++ linux-2.6/include/linux/pid.h	2009-09-10 10:29:10.000000000 -0700
@@ -119,7 +119,7 @@ extern struct pid *find_get_pid(int nr);
 extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
 int next_pidmap(struct pid_namespace *pid_ns, int last);
 
-extern struct pid *alloc_pid(struct pid_namespace *ns);
+extern struct pid *alloc_pid(struct pid_namespace *ns, pid_t *target_pids);
 extern void free_pid(struct pid *pid);
 
 /*
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c	2009-09-10 10:19:20.000000000 -0700
+++ linux-2.6/kernel/fork.c	2009-09-10 10:29:10.000000000 -0700
@@ -940,6 +940,7 @@ static struct task_struct *copy_process(
 	int retval;
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
+	pid_t *target_pids = NULL;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1110,7 +1111,7 @@ static struct task_struct *copy_process(
 		goto bad_fork_cleanup_io;
 
 	if (pid != &init_struct_pid) {
-		pid = alloc_pid(p->nsproxy->pid_ns);
+		pid = alloc_pid(p->nsproxy->pid_ns, target_pids);
 		if (IS_ERR(pid)) {
 			retval = PTR_ERR(pid);
 			goto bad_fork_cleanup_io;
Index: linux-2.6/kernel/pid.c
===================================================================
--- linux-2.6.orig/kernel/pid.c	2009-09-10 10:23:27.000000000 -0700
+++ linux-2.6/kernel/pid.c	2009-09-10 10:29:10.000000000 -0700
@@ -272,13 +272,14 @@ void free_pid(struct pid *pid)
 	call_rcu(&pid->rcu, delayed_put_pid);
 }
 
-struct pid *alloc_pid(struct pid_namespace *ns)
+struct pid *alloc_pid(struct pid_namespace *ns, pid_t *target_pids)
 {
 	struct pid *pid;
 	enum pid_type type;
 	int i, nr;
 	struct pid_namespace *tmp;
 	struct upid *upid;
+	int tpid;
 
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
 	if (!pid) {
@@ -288,7 +289,11 @@ struct pid *alloc_pid(struct pid_namespa
 
 	tmp = ns;
 	for (i = ns->level; i >= 0; i--) {
-		nr = alloc_pidmap(tmp, 0);
+		tpid = 0;
+		if (target_pids)
+			tpid = target_pids[i];
+
+		nr = alloc_pidmap(tmp, tpid);
 		if (nr < 0)
 			goto out_free;
 
