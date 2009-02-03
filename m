Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZBCXVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZBCXVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbZBCXUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:20:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50808 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbZBCXUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:20:46 -0500
Date: Wed, 4 Feb 2009 00:17:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ia64: ptrace_attach_sync_user_rbs: use ->sighand
	instead of ->signal to check the task is alive
Message-ID: <20090203231711.GA5020@redhat.com>
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

Actually, this code doesn't need tasklist_lock and this check at all, it
should be converted to use lock_task_sighand().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/arch/ia64/kernel/ptrace.c~1_IA64_PTRACE	2008-12-02 17:12:35.000000000 +0100
+++ 6.29-rc3/arch/ia64/kernel/ptrace.c	2009-02-03 23:55:41.000000000 +0100
@@ -640,7 +640,7 @@ ptrace_attach_sync_user_rbs (struct task
 	 */
 
 	read_lock(&tasklist_lock);
-	if (child->signal) {
+	if (child->sighand) {
 		spin_lock_irq(&child->sighand->siglock);
 		if (child->state == TASK_STOPPED &&
 		    !test_and_set_tsk_thread_flag(child, TIF_RESTORE_RSE)) {
@@ -664,7 +664,7 @@ ptrace_attach_sync_user_rbs (struct task
 	 * job control stop, so that SIGCONT can be used to wake it up.
 	 */
 	read_lock(&tasklist_lock);
-	if (child->signal) {
+	if (child->sighand) {
 		spin_lock_irq(&child->sighand->siglock);
 		if (child->state == TASK_TRACED &&
 		    (child->signal->flags & SIGNAL_STOP_STOPPED)) {

