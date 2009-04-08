Return-Path: <linux-kernel-owner+w=401wt.eu-S1762695AbZDHQKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695AbZDHQKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766006AbZDHQKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:10:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:55402 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763992AbZDHQKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:10:24 -0400
Date: Wed, 8 Apr 2009 16:09:40 GMT
From: Oleg Nesterov <oleg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, ia6432@inbox.ru, roland@redhat.com,
       tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ia6432@inbox.ru, peterz@infradead.org, roland@redhat.com,
       tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu
In-Reply-To: <20090327000607.GA10104@redhat.com>
References: <20090327000607.GA10104@redhat.com>
Subject: [tip:timers/urgent] posix-timers: fix RLIMIT_CPU && fork()
Message-ID: <tip-6279a751fe096a21dc7704e918d570d3ff06e769@git.kernel.org>
Git-Commit-ID: 6279a751fe096a21dc7704e918d570d3ff06e769
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 16:09:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6279a751fe096a21dc7704e918d570d3ff06e769
Gitweb:     http://git.kernel.org/tip/6279a751fe096a21dc7704e918d570d3ff06e769
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 27 Mar 2009 01:06:07 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 17:51:38 +0200

posix-timers: fix RLIMIT_CPU && fork()

See http://bugzilla.kernel.org/show_bug.cgi?id=12911

copy_signal() copies signal->rlim, but RLIMIT_CPU is "lost". Because
posix_cpu_timers_init_group() sets cputime_expires.prof_exp = 0 and thus
fastpath_timer_check() returns false unless we have other expired cpu timers.

Change copy_signal() to set cputime_expires.prof_exp if we have RLIMIT_CPU.
Also, set cputimer.running = 1 in that case. This is not strictly necessary,
but imho makes sense.

Reported-by: Peter Lojkin <ia6432@inbox.ru>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Peter Lojkin <ia6432@inbox.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: stable@kernel.org
LKML-Reference: <20090327000607.GA10104@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/fork.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 4854c2c..9b51a1b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -808,6 +808,12 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
 	sig->cputime_expires.virt_exp = cputime_zero;
 	sig->cputime_expires.sched_exp = 0;
 
+	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
+		sig->cputime_expires.prof_exp =
+			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
+		sig->cputimer.running = 1;
+	}
+
 	/* The timer lists. */
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
@@ -823,11 +829,8 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 		atomic_inc(&current->signal->live);
 		return 0;
 	}
-	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
-
-	if (sig)
-		posix_cpu_timers_init_group(sig);
 
+	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
 	tsk->signal = sig;
 	if (!sig)
 		return -ENOMEM;
@@ -865,6 +868,8 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	memcpy(sig->rlim, current->signal->rlim, sizeof sig->rlim);
 	task_unlock(current->group_leader);
 
+	posix_cpu_timers_init_group(sig);
+
 	acct_init_pacct(&sig->pacct);
 
 	tty_audit_fork(sig);
