Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbXKWUBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbXKWUBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 15:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbXKWUAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 15:00:45 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:56097 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757318AbXKWUAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 15:00:44 -0500
Date: Fri, 23 Nov 2007 22:59:42 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/2] do_wait: cleanup delay_group_leader() usage
Message-ID: <20071123195942.GA166@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

eligible_child() == 2 means delay_group_leader(). With the previous patch this
only matters for EXIT_ZOMBIE task, we can move that special check to the only
place it is really needed.

Also, with this patch we don't skip security_task_wait() for the group leaders
in a non-empty thread group. I don't really understand the exact semantics of
security_task_wait(), but imho this change is a bugfix.

Also rearrange the code a bit to kill an ugly "check_continued" backdoor.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/exit.c~6_delay_leader	2007-11-23 20:31:21.000000000 +0300
+++ PT/kernel/exit.c	2007-11-23 21:29:44.000000000 +0300
@@ -1137,12 +1137,6 @@ static int eligible_child(pid_t pid, int
 	if (((p->exit_signal != SIGCHLD) ^ ((options & __WCLONE) != 0))
 	    && !(options & __WALL))
 		return 0;
-	/*
-	 * Do not consider thread group leaders that are
-	 * in a non-empty thread group:
-	 */
-	if (delay_group_leader(p))
-		return 2;
 
 	err = security_task_wait(p);
 	if (err)
@@ -1494,10 +1488,9 @@ repeat:
 	tsk = current;
 	do {
 		struct task_struct *p;
-		int ret;
 
 		list_for_each_entry(p, &tsk->children, sibling) {
-			ret = eligible_child(pid, options, p);
+			int ret = eligible_child(pid, options, p);
 			if (!ret)
 				continue;
 
@@ -1521,19 +1514,17 @@ repeat:
 				retval = wait_task_stopped(p,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
-			} else if (p->exit_state == EXIT_ZOMBIE) {
+			} else if (p->exit_state == EXIT_ZOMBIE &&
+					!delay_group_leader(p)) {
 				/*
-				 * Eligible but we cannot release it yet:
+				 * We don't reap group leaders with subthreads.
 				 */
-				if (ret == 2)
-					goto check_continued;
 				if (!likely(options & WEXITED))
 					continue;
 				retval = wait_task_zombie(p,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
 			} else if (p->exit_state != EXIT_DEAD) {
-check_continued:
 				/*
 				 * It's running now, so it might later
 				 * exit, stop, or stop and then continue.

