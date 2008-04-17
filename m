Return-Path: <linux-kernel-owner+w=401wt.eu-S933907AbYDQQYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907AbYDQQYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbYDQQYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:24:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49927 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765556AbYDQQYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:24:36 -0400
Date: Thu, 17 Apr 2008 12:24:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [RFC PATCH] lockdep: update lockdep_recursion on graph_lock
Message-ID: <Pine.LNX.4.58.0804171223250.13261@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With the introduction of ftrace, it is possible to recurse into
the lockdep functions via the mcount call. To prevent possible
lockups, updating the lockdep_recursion counter on grabbing the internal
lockdep_lock should prevent deadlocks.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/lockdep.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-sched-devel.git/kernel/lockdep.c
===================================================================
--- linux-sched-devel.git.orig/kernel/lockdep.c	2008-04-17 11:20:49.000000000 -0400
+++ linux-sched-devel.git/kernel/lockdep.c	2008-04-17 11:36:48.000000000 -0400
@@ -82,6 +82,8 @@ static int graph_lock(void)
 		__raw_spin_unlock(&lockdep_lock);
 		return 0;
 	}
+	/* prevent any recursions within lockdep from causing deadlocks */
+	current->lockdep_recursion++;
 	return 1;
 }

@@ -90,6 +92,7 @@ static inline int graph_unlock(void)
 	if (debug_locks && !__raw_spin_is_locked(&lockdep_lock))
 		return DEBUG_LOCKS_WARN_ON(1);

+	current->lockdep_recursion--;
 	__raw_spin_unlock(&lockdep_lock);
 	return 0;
 }

