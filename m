Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbXCMEpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbXCMEpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 00:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbXCMEpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 00:45:51 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37303 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbXCMEpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 00:45:50 -0400
Date: Mon, 12 Mar 2007 21:45:46 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@osdl.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] Use task_pgrp() task_session() in copy_process()
Message-ID: <20070313044546.GE8884@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [PATCH 5/5] Use task_pgrp() task_session() in copy_process().

Use task_pgrp() and task_session() in copy_process(), and
avoid find_pid() call when attaching the task to its process
group and session.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: containers@lists.osdl.org
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/fork.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: lx26-21-rc3-mm2/kernel/fork.c
===================================================================
--- lx26-21-rc3-mm2.orig/kernel/fork.c	2007-03-12 17:18:03.000000000 -0700
+++ lx26-21-rc3-mm2/kernel/fork.c	2007-03-12 17:18:11.000000000 -0700
@@ -1252,14 +1252,11 @@ static struct task_struct *copy_process(
 	tracehook_init_task(p);
 
 	if (thread_group_leader(p)) {
-		pid_t pgid = process_group(current);
-		pid_t sid = process_session(current);
-
 		p->signal->tty = current->signal->tty;
-		p->signal->pgrp = pgid;
+		p->signal->pgrp = process_group(current);
 		set_signal_session(p->signal, process_session(current));
-		attach_pid(p, PIDTYPE_PGID, find_pid(pgid));
-		attach_pid(p, PIDTYPE_SID, find_pid(sid));
+		attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
+		attach_pid(p, PIDTYPE_SID, task_session(current));
 
 		list_add_tail_rcu(&p->tasks, &init_task.tasks);
 		__get_cpu_var(process_counts)++;
