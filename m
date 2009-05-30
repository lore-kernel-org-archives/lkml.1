Return-Path: <linux-kernel-owner+w=401wt.eu-S1759651AbZE3WoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651AbZE3WoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759346AbZE3WnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:43:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48871 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759330AbZE3WnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:43:10 -0400
Date: Sun, 31 May 2009 00:38:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 02/12 v3] ptrace: tracehooks: do not use task->ptrace
	directly
Message-ID: <20090530223826.GA30485@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/->ptrace/task_ptrace()/ in tracehook.h as a preparation for the future
changes.

Also, microoptimize tracehook_prepare_clone() for the common non-ptraced
case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/tracehook.h |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- PTRACE/include/linux/tracehook.h~02_TRACEHOOK	2009-05-30 21:18:39.000000000 +0200
+++ PTRACE/include/linux/tracehook.h	2009-05-30 22:41:45.000000000 +0200
@@ -225,16 +225,18 @@ static inline void tracehook_report_exit
  */
 static inline int tracehook_prepare_clone(unsigned clone_flags)
 {
-	if (clone_flags & CLONE_UNTRACED)
+	unsigned int ptrace = task_ptrace(current);
+
+	if (likely(!ptrace) || (clone_flags & CLONE_UNTRACED))
 		return 0;
 
 	if (clone_flags & CLONE_VFORK) {
-		if (current->ptrace & PT_TRACE_VFORK)
+		if (ptrace & PT_TRACE_VFORK)
 			return PTRACE_EVENT_VFORK;
 	} else if ((clone_flags & CSIGNAL) != SIGCHLD) {
-		if (current->ptrace & PT_TRACE_CLONE)
+		if (ptrace & PT_TRACE_CLONE)
 			return PTRACE_EVENT_CLONE;
-	} else if (current->ptrace & PT_TRACE_FORK)
+	} else if (ptrace & PT_TRACE_FORK)
 		return PTRACE_EVENT_FORK;
 
 	return 0;
@@ -479,7 +481,7 @@ static inline int tracehook_get_signal(s
  */
 static inline int tracehook_notify_jctl(int notify, int why)
 {
-	return notify || (current->ptrace & PT_PTRACED);
+	return notify || task_ptrace(current);
 }
 
 #define DEATH_REAP			-1
@@ -503,7 +505,7 @@ static inline int tracehook_notify_death
 					 void **death_cookie, int group_dead)
 {
 	if (task_detached(task))
-		return task->ptrace ? SIGCHLD : DEATH_REAP;
+		return task_ptrace(task) ? SIGCHLD : DEATH_REAP;
 
 	/*
 	 * If something other than our normal parent is ptracing us, then
@@ -513,7 +515,7 @@ static inline int tracehook_notify_death
 	if (thread_group_empty(task) && !ptrace_reparented(task))
 		return task->exit_signal;
 
-	return task->ptrace ? SIGCHLD : DEATH_DELAYED_GROUP_LEADER;
+	return task_ptrace(task) ? SIGCHLD : DEATH_DELAYED_GROUP_LEADER;
 }
 
 /**

