Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbYHXPqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbYHXPqH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 11:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYHXPpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 11:45:24 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60260 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbYHXPpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 11:45:22 -0400
Date: Sun, 24 Aug 2008 19:49:11 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Robert Rex <robert.rex@exasol.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] pid_ns: zap_pid_ns_processes: fix the ->child_reaper changing
Message-ID: <20080824154911.GA3777@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zap_pid_ns_processes() sets pid_ns->child_reaper = NULL, this is wrong.

Yes, we have already killed all tasks in this namespace, and sys_wait4()
doesn't see any child. But this doesn't mean ->children list is empty,
we may have EXIT_DEAD tasks which are not visible to do_wait(). In that
case the subsequent forget_original_parent() will crash the kernel because
it will try to re-parent these tasks to the NULL reaper.

Even if there are no childs, it is not good that forget_original_parent()
uses reaper == NULL.

Change the code to set ->child_reaper = init_pid_ns.child_reaper instead.
We could use pid_ns->parent->child_reaper as well, I think this does not
really matter. These EXIT_DEAD tasks are not visible to the new ->parent
after re-parenting, they will silently do release_task() eventually.

Note that we must change ->child_reaper, otherwise forget_original_parent()
will use reaper == father, and in that case we will hit the (correct)
BUG_ON(!list_empty(&father->children)).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.27-rc4/kernel/pid_namespace.c~1_ZAP_DONT_CLEAR_REAPER	2008-07-30 13:12:49.000000000 +0400
+++ 2.6.27-rc4/kernel/pid_namespace.c	2008-08-24 17:22:59.000000000 +0400
@@ -179,9 +179,12 @@ void zap_pid_ns_processes(struct pid_nam
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
-
-	/* Child reaper for the pid namespace is going away */
-	pid_ns->child_reaper = NULL;
+	/*
+	 * We can not clear ->child_reaper or leave it alone.
+	 * There may by stealth EXIT_DEAD tasks on ->children,
+	 * forget_original_parent() must move them somewhere.
+	 */
+	pid_ns->child_reaper = init_pid_ns.child_reaper;
 	acct_exit_ns(pid_ns);
 	return;
 }

