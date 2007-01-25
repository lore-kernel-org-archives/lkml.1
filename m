Return-Path: <linux-kernel-owner+w=401wt.eu-S965140AbXAYPFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965140AbXAYPFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965387AbXAYPFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:05:49 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:57198 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965140AbXAYPFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:05:48 -0500
Date: Thu, 25 Jan 2007 09:05:42 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Daniel Hokka Zakrisson <daniel@hozac.com>, herbert@13thfloor.at,
       akpm@osdl.org, trond.myklebust@fys.uio.no,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH] namespaces: fix race at task exit
Message-ID: <20070125150542.GA27472@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In do_exit(), the exit_task_namespaces() was placed after
exit_notify() because exit_notify ends up using the pid
namespace both to access the reaper, and for detaching the
pid.  However, this placement allows an nfs server to reap
the task before exit_task_namespaces() completes.

This patch moves the exit_task_namespaces() into release_task,
below release_thread() which puts the pids(), and just above
the call_rcu(delayed_put_task_struct).  I believe this should
solve both problems.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

---

 kernel/exit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

765277a4170d7bbd1c4613de661ec6ac64d5580a
diff --git a/kernel/exit.c b/kernel/exit.c
index 3540172..ab9ae30 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -174,6 +174,7 @@ repeat:
 	write_unlock_irq(&tasklist_lock);
 	proc_flush_task(p);
 	release_thread(p);
+	exit_task_namespaces(p);
 	call_rcu(&p->rcu, delayed_put_task_struct);
 
 	p = leader;
@@ -939,7 +940,6 @@ fastcall NORET_TYPE void do_exit(long co
 	tsk->exit_code = code;
 	proc_exit_connector(tsk);
 	exit_notify(tsk);
-	exit_task_namespaces(tsk);
 #ifdef CONFIG_NUMA
 	mpol_free(tsk->mempolicy);
 	tsk->mempolicy = NULL;
-- 
1.1.6
