Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbZCWQlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbZCWQlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbZCWQk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:40:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:39949 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758838AbZCWQk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:40:27 -0400
Date: Mon, 23 Mar 2009 16:39:34 GMT
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       mszeredi@suse.cz, miklos@szeredi.hu, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mszeredi@suse.cz, miklos@szeredi.hu, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1LllkK-0000zF-1h@pomaz-ex.szeredi.hu>
References: <E1LllkK-0000zF-1h@pomaz-ex.szeredi.hu>
Subject: [tip:sched/urgent] sched, ptrace: fix UML and ptrace slowness
Message-ID: <tip-84eef8ca758fa4a68c29f7d752376f6ca6872383@git.kernel.org>
Git-Commit-ID: 84eef8ca758fa4a68c29f7d752376f6ca6872383
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 16:39:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84eef8ca758fa4a68c29f7d752376f6ca6872383
Gitweb:     http://git.kernel.org/tip/84eef8ca758fa4a68c29f7d752376f6ca6872383
Author:     Miklos Szeredi <miklos@szeredi.hu>
AuthorDate: Mon, 23 Mar 2009 16:07:24 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 17:37:38 +0100

sched, ptrace: fix UML and ptrace slowness

This patch fixes bug #12208:

  Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12208
  Subject         : uml is very slow on 2.6.28 host

This turned out to be not a scheduler regression, but an already
existing problem in ptrace being triggered by subtle scheduler
changes.

The problem is this:

 - task A is ptracing task B
 - task B stops on a trace event
 - task A is woken up and preempts task B
 - task A calls ptrace on task B, which does ptrace_check_attach()
 - this calls wait_task_inactive(), which sees that task B is still on the runq
 - task A goes to sleep for a jiffy
 - ...

Since UML does lots of the above sequences, those jiffies quickly add
up to make it slow as hell.

This patch solves this by not rescheduling in read_unlock() after
ptrace_stop() has woken up the tracer.

Thanks to Oleg Nesterov and Ingo Molnar for the feedback.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: oleg@redhat.com
Cc: peterz@infradead.org
Cc: roland@redhat.com
Cc: efault@gmx.de
Cc: rjw@sisk.pl
Cc: jdike@addtoit.com
Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org
Cc: <stable@kernel.org>
LKML-Reference: <E1LllkK-0000zF-1h@pomaz-ex.szeredi.hu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/signal.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 2a74fe8..1c88144 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1575,7 +1575,15 @@ static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
 	read_lock(&tasklist_lock);
 	if (may_ptrace_stop()) {
 		do_notify_parent_cldstop(current, CLD_TRAPPED);
+		/*
+		 * Don't want to allow preemption here, because
+		 * sys_ptrace() needs this task to be inactive.
+		 *
+		 * XXX: implement read_unlock_no_resched().
+		 */
+		preempt_disable();
 		read_unlock(&tasklist_lock);
+		preempt_enable_no_resched();
 		schedule();
 	} else {
 		/*
