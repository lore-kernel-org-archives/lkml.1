Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYKQNkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYKQNkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbYKQNjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:39:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46134 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbYKQNjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:39:46 -0500
Date: Mon, 17 Nov 2008 15:40:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>
Cc: Doug Chapman <doug.chapman@hp.com>, Frank Mayhar <fmayhar@google.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/3] thread_group_cputime: move a couple of callsites
	outside of ->siglock
Message-ID: <20081117144008.GA5386@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->siglock buys nothing for thread_group_cputime() in do_sys_times() and
wait_task_zombie() (which btw takes the unrelated parent's ->siglock).
Actually I think do_sys_times() doesn't need ->siglock at all.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- K-28/kernel/exit.c~SYS_TIMES_NO_SIGLOCK	2008-11-10 15:07:22.000000000 +0100
+++ K-28/kernel/exit.c	2008-11-17 02:02:12.000000000 +0100
@@ -1330,10 +1330,10 @@ static int wait_task_zombie(struct task_
 		 * group, which consolidates times for all threads in the
 		 * group including the group leader.
 		 */
+		thread_group_cputime(p, &cputime);
 		spin_lock_irq(&p->parent->sighand->siglock);
 		psig = p->parent->signal;
 		sig = p->signal;
-		thread_group_cputime(p, &cputime);
 		psig->cutime =
 			cputime_add(psig->cutime,
 			cputime_add(cputime.utime,
--- K-28/kernel/sys.c~SYS_TIMES_NO_SIGLOCK	2008-11-06 19:11:02.000000000 +0100
+++ K-28/kernel/sys.c	2008-11-17 01:56:17.000000000 +0100
@@ -858,8 +858,8 @@ void do_sys_times(struct tms *tms)
 	struct task_cputime cputime;
 	cputime_t cutime, cstime;
 
-	spin_lock_irq(&current->sighand->siglock);
 	thread_group_cputime(current, &cputime);
+	spin_lock_irq(&current->sighand->siglock);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
 	spin_unlock_irq(&current->sighand->siglock);

