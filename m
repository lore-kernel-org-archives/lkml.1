Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbXCMEpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbXCMEpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 00:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbXCMEpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 00:45:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53935 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbXCMEo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 00:44:59 -0400
Date: Mon, 12 Mar 2007 21:44:55 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@osdl.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] Remove the likely(pid) check in copy_process
Message-ID: <20070313044455.GD8884@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [PATCH 4/5] Remove the likely(pid) check in copy_process

Now that we pass in a struct pid parameter to copy_process()
and even the swapper (pid_t == 0) has a valid struct pid,
we no longer need this check.

Changelog: 
	Per Eric Biederman's comments, moved this out to a separate
	patch for easier review.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: containers@lists.osdl.org
Acked-by: Eric W. Biederman <ebiederm@xmission.com>

---
 kernel/fork.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

Index: lx26-20-mm2c/kernel/fork.c
===================================================================
--- lx26-20-mm2c.orig/kernel/fork.c	2007-02-28 15:08:46.000000000 -0800
+++ lx26-20-mm2c/kernel/fork.c	2007-02-28 15:33:20.000000000 -0800
@@ -1249,26 +1249,24 @@ static struct task_struct *copy_process(
 		}
 	}
 
-	if (likely(p->pid)) {
-		add_parent(p);
-		tracehook_init_task(p);
-
-		if (thread_group_leader(p)) {
-			pid_t pgid = process_group(current);
-			pid_t sid = process_session(current);
-
-			p->signal->tty = current->signal->tty;
-			p->signal->pgrp = pgid;
-			set_signal_session(p->signal, process_session(current));
-			attach_pid(p, PIDTYPE_PGID, find_pid(pgid));
-			attach_pid(p, PIDTYPE_SID, find_pid(sid));
+	add_parent(p);
+	tracehook_init_task(p);
 
-			list_add_tail_rcu(&p->tasks, &init_task.tasks);
-			__get_cpu_var(process_counts)++;
-		}
-		attach_pid(p, PIDTYPE_PID, pid);
-		nr_threads++;
+	if (thread_group_leader(p)) {
+		pid_t pgid = process_group(current);
+		pid_t sid = process_session(current);
+
+		p->signal->tty = current->signal->tty;
+		p->signal->pgrp = pgid;
+		set_signal_session(p->signal, process_session(current));
+		attach_pid(p, PIDTYPE_PGID, find_pid(pgid));
+		attach_pid(p, PIDTYPE_SID, find_pid(sid));
+
+		list_add_tail_rcu(&p->tasks, &init_task.tasks);
+		__get_cpu_var(process_counts)++;
 	}
+	attach_pid(p, PIDTYPE_PID, pid);
+	nr_threads++;
 
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
