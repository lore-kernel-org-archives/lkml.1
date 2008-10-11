Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbYJKHDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbYJKHDx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764854AbYJKHBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:01:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60170 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764281AbYJKHBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:01:53 -0400
Date: Sat, 11 Oct 2008 03:01:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: fair scheduler should not resched rt tasks
Message-ID: <alpine.DEB.1.10.0810110258310.12625@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Using ftrace, I noticed latencies in real-time tasks where they were
needlessly calling schedule due to sched_fair sending out time slices.

This patch prevents a call to resched_task by the sched fair class if
the task it wants to reschedule is an rt task.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-compile.git/kernel/sched_fair.c
===================================================================
--- linux-compile.git.orig/kernel/sched_fair.c	2008-10-11 02:54:01.000000000 -0400
+++ linux-compile.git/kernel/sched_fair.c	2008-10-11 02:55:52.000000000 -0400
@@ -889,7 +889,7 @@ static void hrtick_start_fair(struct rq 
 		s64 delta = slice - ran;
 
 		if (delta < 0) {
-			if (rq->curr == p)
+			if (rq->curr == p && !rt_task(p))
 				resched_task(p);
 			return;
 		}
