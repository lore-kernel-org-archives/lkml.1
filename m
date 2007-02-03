Return-Path: <linux-kernel-owner+w=401wt.eu-S1946235AbXBCCfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946235AbXBCCfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946236AbXBCCfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:35:44 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52634 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946233AbXBCCfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:35:42 -0500
Message-Id: <20070203023928.378027000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:16 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Galbraith <efault@gmx.de>, Albert Cahalan <acahalan@gmail.com>,
       Andrew Morton <akpm@osdl.org>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Coywolf Qi Hunt <qiyong@fc-cn.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Linus Torvalds <torvalds@osdl.org>
Subject: [patch 12/59] [PATCH] Fix reparenting to the same thread group. (take 2)
Content-Disposition: inline; filename=fix-reparenting-to-the-same-thread-group.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Eric W. Biederman <ebiederm@xmission.com>

This patch fixes the case when we reparent to a different thread in the
same thread group.  This modifies the code so that we do not send
signals and do not change the signal to send to SIGCHLD unless we have
change the thread group of our parents.  It also suppresses sending
pdeath_sig in this cas as well since the result of geppid doesn't
change.

Thanks to Oleg for spotting my bug of only fixing this for non-ptraced
tasks.

This fixes the issues identified by Albert Cahalan in thread
http://lkml.org/lkml/2006/12/21/22.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Mike Galbraith <efault@gmx.de>
Cc: Albert Cahalan <acahalan@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Coywolf Qi Hunt <qiyong@fc-cn.com>
Acked-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
[chrisw: fold in 241ceee0b442, Oleg's fix to restore user visible behaviour]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 kernel/exit.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- linux-2.6.19.2.orig/kernel/exit.c
+++ linux-2.6.19.2/kernel/exit.c
@@ -603,10 +603,6 @@ choose_new_parent(struct task_struct *p,
 static void
 reparent_thread(struct task_struct *p, struct task_struct *father, int traced)
 {
-	/* We don't want people slaying init.  */
-	if (p->exit_signal != -1)
-		p->exit_signal = SIGCHLD;
-
 	if (p->pdeath_signal)
 		/* We already hold the tasklist_lock here.  */
 		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
@@ -626,13 +622,7 @@ reparent_thread(struct task_struct *p, s
 		p->parent = p->real_parent;
 		add_parent(p);
 
-		/* If we'd notified the old parent about this child's death,
-		 * also notify the new parent.
-		 */
-		if (p->exit_state == EXIT_ZOMBIE && p->exit_signal != -1 &&
-		    thread_group_empty(p))
-			do_notify_parent(p, p->exit_signal);
-		else if (p->state == TASK_TRACED) {
+		if (p->state == TASK_TRACED) {
 			/*
 			 * If it was at a trace stop, turn it into
 			 * a normal stop since it's no longer being
@@ -642,6 +632,23 @@ reparent_thread(struct task_struct *p, s
 		}
 	}
 
+	/* If this is a threaded reparent there is no need to
+	 * notify anyone anything has happened.
+	 */
+	if (p->real_parent->group_leader == father->group_leader)
+		return;
+
+	/* We don't want people slaying init.  */
+	if (p->exit_signal != -1)
+		p->exit_signal = SIGCHLD;
+
+	/* If we'd notified the old parent about this child's death,
+	 * also notify the new parent.
+	 */
+	if (!traced && p->exit_state == EXIT_ZOMBIE &&
+	    p->exit_signal != -1 && thread_group_empty(p))
+		do_notify_parent(p, p->exit_signal);
+
 	/*
 	 * process group orphan check
 	 * Case ii: Our child is in a different pgrp

--
