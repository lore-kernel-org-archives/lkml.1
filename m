Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZBCXUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZBCXUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbZBCXUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:20:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50802 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbZBCXUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:20:36 -0500
Date: Wed, 4 Feb 2009 00:17:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] posix-cpu-timers: use ->sighand instead of ->signal to
	check the task is alive
Message-ID: <20090203231717.GA5028@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

It doesn't matter which pointer to check under tasklist to ensure the task
was not released, ->signal or ->sighand. But we are going to make ->signal
refcountable, change the code to use ->sighand.

Sadly, it is not trivial to audit kernel/posix-cpu-timers.c, but it really
abuses tasklist_lock. I believe it doesn't need this lock at all, but the
changes are not easy to test.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/posix-cpu-timers.c~2_CPU_TIMERS	2009-01-29 01:13:55.000000000 +0100
+++ 6.29-rc3/kernel/posix-cpu-timers.c	2009-02-04 00:09:23.000000000 +0100
@@ -297,7 +297,7 @@ int posix_cpu_clock_get(const clockid_t 
 				}
 			} else {
 				read_lock(&tasklist_lock);
-				if (thread_group_leader(p) && p->signal) {
+				if (thread_group_leader(p) && p->sighand) {
 					error =
 					    cpu_clock_sample_group(which_clock,
 							           p, &rtn);
@@ -374,7 +374,7 @@ int posix_cpu_timer_del(struct k_itimer 
 
 	if (likely(p != NULL)) {
 		read_lock(&tasklist_lock);
-		if (unlikely(p->signal == NULL)) {
+		if (unlikely(p->sighand == NULL)) {
 			/*
 			 * We raced with the reaping of the task.
 			 * The deletion should have cleared us off the list.
@@ -640,10 +640,10 @@ int posix_cpu_timer_set(struct k_itimer 
 	read_lock(&tasklist_lock);
 	/*
 	 * We need the tasklist_lock to protect against reaping that
-	 * clears p->signal.  If p has just been reaped, we can no
+	 * clears p->sighand.  If p has just been reaped, we can no
 	 * longer get any information about it at all.
 	 */
-	if (unlikely(p->signal == NULL)) {
+	if (unlikely(p->sighand == NULL)) {
 		read_unlock(&tasklist_lock);
 		put_task_struct(p);
 		timer->it.cpu.task = NULL;
@@ -812,7 +812,7 @@ void posix_cpu_timer_get(struct k_itimer
 		clear_dead = p->exit_state;
 	} else {
 		read_lock(&tasklist_lock);
-		if (unlikely(p->signal == NULL)) {
+		if (unlikely(p->sighand == NULL)) {
 			/*
 			 * The process has been reaped.
 			 * We can't even collect a sample any more.
@@ -1146,7 +1146,7 @@ void posix_cpu_timer_schedule(struct k_i
 		read_lock(&tasklist_lock); /* arm_timer needs it.  */
 	} else {
 		read_lock(&tasklist_lock);
-		if (unlikely(p->signal == NULL)) {
+		if (unlikely(p->sighand == NULL)) {
 			/*
 			 * The process has been reaped.
 			 * We can't even collect a sample any more.

