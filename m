Return-Path: <linux-kernel-owner+w=401wt.eu-S936833AbYEUTfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936833AbYEUTfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936018AbYEUTf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:35:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53691 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936948AbYEUTf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:35:27 -0400
Date: Wed, 21 May 2008 15:35:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH RT] rwlocks fix for non PREEMPT_RT
Message-ID: <Pine.LNX.4.58.0805211534170.19141@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Seems that the addition of RT_RW_READER broke the non PREEMPT_RT case.
This patch fixes it.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/rtmutex.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

Index: linux-2.6.24.7-rt9/kernel/rtmutex.c
===================================================================
--- linux-2.6.24.7-rt9.orig/kernel/rtmutex.c	2008-05-20 23:38:08.000000000 -0400
+++ linux-2.6.24.7-rt9/kernel/rtmutex.c	2008-05-21 15:16:18.000000000 -0400
@@ -123,6 +123,12 @@ static inline void mark_rt_rwlock_check(
 #endif /* CONFIG_PREEMPT_RT */
 #endif

+#ifdef CONFIG_PREEMPT_RT
+#define task_is_reader(task) ((task) == RT_RW_READER)
+#else
+#define task_is_reader(task) (0)
+#endif
+
 int pi_initialized;

 /*
@@ -315,7 +321,7 @@ static int rt_mutex_adjust_prio_chain(st
 	/*
 	 * Readers are special. We may need to boost more than one owner.
 	 */
-	if (task == RT_RW_READER) {
+	if (task_is_reader(task)) {
 		ret = rt_mutex_adjust_readers(orig_lock, orig_waiter,
 					      top_task, lock,
 					      recursion_depth);
@@ -376,7 +382,7 @@ static inline int try_to_steal_lock(stru
 	if (pendowner == current)
 		return 1;

-	WARN_ON(rt_mutex_owner(lock) == RT_RW_READER);
+	WARN_ON(task_is_reader(rt_mutex_owner(lock)));

 	spin_lock(&pendowner->pi_lock);
 	if (!lock_is_stealable(pendowner, mode)) {
@@ -506,7 +512,7 @@ static int task_blocks_on_rt_mutex(struc

 	if (waiter == rt_mutex_top_waiter(lock)) {
 		/* readers are handled differently */
-		if (owner == RT_RW_READER) {
+		if (task_is_reader(owner)) {
 			res = rt_mutex_adjust_readers(lock, waiter,
 						      current, lock, 0);
 			return res;
@@ -524,7 +530,7 @@ static int task_blocks_on_rt_mutex(struc
 	else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock))
 		chain_walk = 1;

-	if (!chain_walk || owner == RT_RW_READER)
+	if (!chain_walk || task_is_reader(owner))
 		return 0;

 	/*
@@ -624,7 +630,7 @@ static void remove_waiter(struct rt_mute
 	current->pi_blocked_on = NULL;
 	spin_unlock(&current->pi_lock);

-	if (first && owner != current && owner != RT_RW_READER) {
+	if (first && owner != current && !task_is_reader(owner)) {

 		spin_lock(&owner->pi_lock);


