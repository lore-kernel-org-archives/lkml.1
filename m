Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbZCWTqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbZCWTqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756734AbZCWTqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:46:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:52932 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383AbZCWTql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:46:41 -0400
Date: Mon, 23 Mar 2009 19:45:57 GMT
From: Oleg Nesterov <oleg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, ia6432@inbox.ru, roland@redhat.com,
       tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ia6432@inbox.ru, peterz@infradead.org, roland@redhat.com,
       tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu
In-Reply-To: <20090323193411.GA17514@redhat.com>
References: <20090323193411.GA17514@redhat.com>
Subject: [tip:timers/urgent] posix timers: fix RLIMIT_CPU && fork()
Message-ID: <tip-37bebc70d7ad4144c571d74500db3bb26ec0c0eb@git.kernel.org>
Git-Commit-ID: 37bebc70d7ad4144c571d74500db3bb26ec0c0eb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 19:45:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37bebc70d7ad4144c571d74500db3bb26ec0c0eb
Gitweb:     http://git.kernel.org/tip/37bebc70d7ad4144c571d74500db3bb26ec0c0eb
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Mon, 23 Mar 2009 20:34:11 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 20:43:35 +0100

posix timers: fix RLIMIT_CPU && fork()

See http://bugzilla.kernel.org/show_bug.cgi?id=12911

copy_signal() copies signal->rlim, but RLIMIT_CPU is "lost". Because
posix_cpu_timers_init_group() sets cputime_expires.prof_exp = 0 and thus
fastpath_timer_check() returns false unless we have other cpu timers.

This is the minimal fix for 2.6.29 (tested) and 2.6.28. The patch is not
optimal, we need further cleanups here. With this patch update_rlimit_cpu()
is not really needed, but I don't think it should be removed.

The proper fix (I think) is:

	- set_process_cpu_timer() should just start the cputimer->running
	  logic (it does), no need to change cputime_expires.xxx_exp

	- posix_cpu_timers_init_group() should set ->running when needed

	- fastpath_timer_check() can check ->running instead of
	  task_cputime_zero(signal->cputime_expires)

Reported-by: Peter Lojkin <ia6432@inbox.ru>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: <stable@kernel.org> [for 2.6.29.x]
LKML-Reference: <20090323193411.GA17514@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/posix-cpu-timers.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index e976e50..8e5d9a6 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1370,7 +1370,8 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
 			return 1;
 	}
-	return 0;
+
+	return sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY;
 }
 
 /*
