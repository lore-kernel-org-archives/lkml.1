Return-Path: <linux-kernel-owner+w=401wt.eu-S935585AbZFOVbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935585AbZFOVbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934528AbZFOVb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:31:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44784 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbZFOVb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:31:26 -0400
Date: Mon, 15 Jun 2009 23:26:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] wait_task_zombie: do not use thread_group_cputime()
Message-ID: <20090615212651.GA22759@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason for thread_group_cputime() in wait_task_zombie(),
there must be no other threads.

This call was previously needed to collect the per-cpu data which
we do not have any longer.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/kernel/exit.c~2_WAIT_NO_TG	2009-06-15 22:26:02.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-06-15 23:06:45.000000000 +0200
@@ -1192,7 +1192,6 @@ static int wait_task_zombie(struct wait_
 	if (likely(!traced) && likely(!task_detached(p))) {
 		struct signal_struct *psig;
 		struct signal_struct *sig;
-		struct task_cputime cputime;
 
 		/*
 		 * The resource counters for the group leader are in its
@@ -1208,23 +1207,20 @@ static int wait_task_zombie(struct wait_
 		 * need to protect the access to parent->signal fields,
 		 * as other threads in the parent group can be right
 		 * here reaping other children at the same time.
-		 *
-		 * We use thread_group_cputime() to get times for the thread
-		 * group, which consolidates times for all threads in the
-		 * group including the group leader.
 		 */
-		thread_group_cputime(p, &cputime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
 		psig->cutime =
 			cputime_add(psig->cutime,
-			cputime_add(cputime.utime,
-				    sig->cutime));
+			cputime_add(p->utime,
+			cputime_add(sig->utime,
+				    sig->cutime)));
 		psig->cstime =
 			cputime_add(psig->cstime,
-			cputime_add(cputime.stime,
-				    sig->cstime));
+			cputime_add(p->stime,
+			cputime_add(sig->stime,
+				    sig->cstime)));
 		psig->cgtime =
 			cputime_add(psig->cgtime,
 			cputime_add(p->gtime,

