Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZBHSum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZBHSum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 13:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZBHSty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 13:49:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36119 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbZBHStx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 13:49:53 -0500
Date: Sun, 8 Feb 2009 19:47:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Roland McGrath <roland@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ptrace_untrace: use wake_up_process() instead of bogus
	signal_wake_up()
Message-ID: <20090208184727.GA27081@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both ptrace_stop() and do_signal_stop() pathes always take ->siglock and
do recalc_sigpending() after wakeup.

This means that if the tracer sees task_is_traced(child) == T (perhaps it
it was actually TASK_STOPPED before ptrace_check_attach) under ->siglock,
it can use the plain wake_up_process() instead of signal_wake_up().

(and note that ptrace_resume() does wake_up_process() too).

We also have sys_clone(CLONE_STOPPED), but a) it must set TIF_SIGPENDING
by hand anyway, and b) it is deprecated.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/ptrace.c~2_KILL_SIGWAKE	2009-02-08 05:11:52.000000000 +0100
+++ 6.29-rc3/kernel/ptrace.c	2009-02-08 06:22:26.000000000 +0100
@@ -60,11 +60,10 @@ static void ptrace_untrace(struct task_s
 {
 	spin_lock(&child->sighand->siglock);
 	if (task_is_traced(child)) {
-		if (child->signal->flags & SIGNAL_STOP_STOPPED) {
+		if (child->signal->flags & SIGNAL_STOP_STOPPED)
 			__set_task_state(child, TASK_STOPPED);
-		} else {
-			signal_wake_up(child, 1);
-		}
+		else
+			wake_up_process(child);
 	}
 	spin_unlock(&child->sighand->siglock);
 }

