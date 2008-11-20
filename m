Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbYKTT2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbYKTT2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYKTT2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:28:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36430 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbYKTT2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:28:39 -0500
Date: Thu, 20 Nov 2008 21:28:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] processes: reparent_thread: don't call
	kill_orphaned_pgrp() if task_detached()
Message-ID: <20081120202848.GA27241@redhat.com>
References: <20081118175901.GA17134@redhat.com> <20081119185148.DC1D31544EB@magilla.localdomain> <m1skpncg2b.fsf@frodo.ebiederm.org> <20081120145234.GA3325@redhat.com> <m13ahm9slb.fsf@frodo.ebiederm.org> <20081120200050.GA24467@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120200050.GA24467@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needs an ack from someone who understands orphaned groups.

If task_detached(p) == T, then either

	a) p is not the main thread, we will find the group leader
	   on the ->children list.
or
	b) p is the group leader but its ->exit_state = EXIT_DEAD.
	   This can only happen when the last sub-thread has died,
	   but in that case that thread has already called
	   kill_orphaned_pgrp() from exit_notify().

In both cases kill_orphaned_pgrp() looks bogus.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- K-28/kernel/exit.c~1_IGNORE_DETACHED	2008-11-17 02:02:12.000000000 +0100
+++ K-28/kernel/exit.c	2008-11-20 20:21:02.000000000 +0100
@@ -816,6 +816,8 @@ static void reparent_thread(struct task_
 
 	list_move_tail(&p->sibling, &p->real_parent->children);
 
+	if (task_detached(p))
+		return;
 	/* If this is a threaded reparent there is no need to
 	 * notify anyone anything has happened.
 	 */
@@ -823,15 +825,13 @@ static void reparent_thread(struct task_
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

