Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbZA2IJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbZA2IJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZA2IIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:08:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45864 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbZA2IIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:08:36 -0500
Date: Thu, 29 Jan 2009 09:05:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] reparent_thread: don't call kill_orphaned_pgrp() if
	task_detached()
Message-ID: <20090129080555.GA26867@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If task_detached(p) == T, then either

	a) p is not the main thread, we will find the group leader
	   on the ->children list.
or
	b) p is the group leader but its ->exit_state = EXIT_DEAD.
	   This can only happen when the last sub-thread has died,
	   but in that case that thread has already called
	   kill_orphaned_pgrp() from exit_notify().

In both cases kill_orphaned_pgrp() looks bogus.

Move the task_detached() check up and simplify the code, this is also
right from the "common sense" pov: we should do nothing with the detached
childs, except move them to the new parent's ->children list.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/exit.c~5_SIMPLIFY_REPARENT_THREAD	2009-01-29 04:09:40.000000000 +0100
+++ 6.29-rc3/kernel/exit.c	2009-01-29 06:21:51.000000000 +0100
@@ -812,6 +812,8 @@ static void reparent_thread(struct task_
 
 	list_move_tail(&p->sibling, &p->real_parent->children);
 
+	if (task_detached(p))
+		return;
 	/* If this is a threaded reparent there is no need to
 	 * notify anyone anything has happened.
 	 */
@@ -819,15 +821,13 @@ static void reparent_thread(struct task_
 		return;
 
 	/* We don't want people slaying init.  */
-	if (!task_detached(p))
-		p->exit_signal = SIGCHLD;
+	p->exit_signal = SIGCHLD;
 
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
 	 */
 	if (!ptrace_reparented(p) &&
-	    p->exit_state == EXIT_ZOMBIE &&
-	    !task_detached(p) && thread_group_empty(p))
+	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p))
 		do_notify_parent(p, p->exit_signal);
 
 	kill_orphaned_pgrp(p, father);

