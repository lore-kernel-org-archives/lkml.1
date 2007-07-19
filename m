Return-Path: <linux-kernel-owner+w=401wt.eu-S935226AbXGSHU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935226AbXGSHU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 03:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbXGSHUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 03:20:16 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55573 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875AbXGSHUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 03:20:13 -0400
Date: Thu, 19 Jul 2007 00:20:11 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: Containers <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Emelianov <xemul@openvz.org>
Subject: [PATCH 2/5] [V2] Rename child_reaper() function
Message-ID: <20070719072011.GB28216@us.ibm.com>
References: <20070719071206.GE10195@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719071206.GE10195@us.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

Pls ack this if you agree.

Suka
---

Subject: [PATCH 2/5] Rename child_reaper function.

From: Sukadev Bhattiprolu <sukadev@us.ibm.com>


Rename the child_reaper() function to task_child_reaper() to be
similar to other task_* functions and to distinguish the function
from 'struct pid_namspace.child_reaper'.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
---
 fs/exec.c                     |    2 +-
 include/linux/pid_namespace.h |    2 +-
 kernel/exit.c                 |    4 ++--
 kernel/signal.c               |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

Index: lx26-22-rc6-mm1/include/linux/pid_namespace.h
===================================================================
--- lx26-22-rc6-mm1.orig/include/linux/pid_namespace.h	2007-07-13 13:07:48.000000000 -0700
+++ lx26-22-rc6-mm1/include/linux/pid_namespace.h	2007-07-13 13:12:01.000000000 -0700
@@ -44,7 +44,7 @@ static inline struct pid_namespace *task
 	return tsk->nsproxy->pid_ns;
 }
 
-static inline struct task_struct *child_reaper(struct task_struct *tsk)
+static inline struct task_struct *task_child_reaper(struct task_struct *tsk)
 {
 	return init_pid_ns.child_reaper;
 }
Index: lx26-22-rc6-mm1/fs/exec.c
===================================================================
--- lx26-22-rc6-mm1.orig/fs/exec.c	2007-07-13 13:07:48.000000000 -0700
+++ lx26-22-rc6-mm1/fs/exec.c	2007-07-13 13:12:01.000000000 -0700
@@ -826,7 +826,7 @@ static int de_thread(struct task_struct 
 	 * Reparenting needs write_lock on tasklist_lock,
 	 * so it is safe to do it under read_lock.
 	 */
-	if (unlikely(tsk->group_leader == child_reaper(tsk)))
+	if (unlikely(tsk->group_leader == task_child_reaper(tsk)))
 		task_active_pid_ns(tsk)->child_reaper = tsk;
 
 	zap_other_threads(tsk);
Index: lx26-22-rc6-mm1/kernel/exit.c
===================================================================
--- lx26-22-rc6-mm1.orig/kernel/exit.c	2007-07-13 13:07:48.000000000 -0700
+++ lx26-22-rc6-mm1/kernel/exit.c	2007-07-13 13:12:01.000000000 -0700
@@ -695,7 +695,7 @@ forget_original_parent(struct task_struc
 	do {
 		reaper = next_thread(reaper);
 		if (reaper == father) {
-			reaper = child_reaper(father);
+			reaper = task_child_reaper(father);
 			break;
 		}
 	} while (reaper->exit_state);
@@ -908,7 +908,7 @@ fastcall NORET_TYPE void do_exit(long co
 		panic("Aiee, killing interrupt handler!");
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
-	if (unlikely(tsk == child_reaper(tsk))) {
+	if (unlikely(tsk == task_child_reaper(tsk))) {
 		if (task_active_pid_ns(tsk) != &init_pid_ns)
 			task_active_pid_ns(tsk)->child_reaper =
 					init_pid_ns.child_reaper;
Index: lx26-22-rc6-mm1/kernel/signal.c
===================================================================
--- lx26-22-rc6-mm1.orig/kernel/signal.c	2007-07-13 13:06:52.000000000 -0700
+++ lx26-22-rc6-mm1/kernel/signal.c	2007-07-13 13:12:01.000000000 -0700
@@ -1853,7 +1853,7 @@ relock:
 		 * within that pid space. It can of course get signals from
 		 * its parent pid space.
 		 */
-		if (current == child_reaper(current))
+		if (current == task_child_reaper(current))
 			continue;
 
 		if (sig_kernel_stop(signr)) {
