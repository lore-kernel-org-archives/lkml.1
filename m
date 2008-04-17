Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbYDQPlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbYDQPlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761815AbYDQPl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:41:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39634 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760565AbYDQPl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:41:26 -0400
Date: Thu, 17 Apr 2008 11:41:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@goodmis.org
Subject: [PATCH] lockdep: comment hidden releases of graph_lock 
Message-ID: <Pine.LNX.4.58.0804171139170.12839@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While reviewing the lockdep.c code, it looked to me that I found a bug where
the release of the graph_lock was not done on failure. This turns out not
to be the case, because the graph_unlock is performed within the internal
functions of lockdep when a failure occurs.

To help out others when visually reviewing this code, I've added comments
to the places where it looks like it may be a bug not to call graph_unlock.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/lockdep.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-sched-devel.git/kernel/lockdep.c
===================================================================
--- linux-sched-devel.git.orig/kernel/lockdep.c	2008-04-17 10:52:40.000000000 -0400
+++ linux-sched-devel.git/kernel/lockdep.c	2008-04-17 11:20:49.000000000 -0400
@@ -1566,6 +1566,7 @@ static int validate_chain(struct task_st
 		/*
 		 * Add dependency only if this lock is not the head
 		 * of the chain, and if it's not a secondary read-lock:
+		 * (will do graph_unlock on failure)
 		 */
 		if (!chain_head && ret != 2)
 			if (!check_prevs_add(curr, hlock))
@@ -2284,6 +2285,7 @@ static int mark_lock(struct task_struct

 	this->class->usage_mask |= new_mask;

+	/* save_trace does graph_unlock on failure */
 	if (!save_trace(this->class->usage_traces + new_bit))
 		return 0;

@@ -2296,6 +2298,7 @@ static int mark_lock(struct task_struct
 	case LOCK_ENABLED_SOFTIRQS:
 	case LOCK_ENABLED_HARDIRQS_READ:
 	case LOCK_ENABLED_SOFTIRQS_READ:
+		/* mark_lock_irq does graph_unlock on failure */
 		ret = mark_lock_irq(curr, this, new_bit);
 		if (!ret)
 			return 0;

