Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZCVUSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZCVUSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 16:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbZCVUSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 16:18:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33273 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705AbZCVUSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 16:18:41 -0400
Date: Sun, 22 Mar 2009 21:14:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Lojkin <ia6432@inbox.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, rjw@sisk.pl
Subject: Re: 2.6.28, limiting cpu time doesn't work
Message-ID: <20090322201436.GA12838@redhat.com>
References: <E1LkN4B-0002yU-00.ia6432-inbox-ru@f205.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LkN4B-0002yU-00.ia6432-inbox-ru@f205.mail.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19, Peter Lojkin wrote:
>
> after upgrade to 2.6.28 ulimit -t doesn't work. for example:
>
> bash# ulimit -t 3; cpuhog
>
> (where cpuhog is any program that continuously use cpu)
> with 2.6.27.20 cpuhog gets killed after 3sec as expected.
> with 2.6.28, 2.6.28.8, 2.6.29-rc8-git4 it's keep running indefinitely.
> ulimit -a and /proc/<pid>/limits show that cputime limit was set correctly.

Found this message on http://bugzilla.kernel.org/show_bug.cgi?id=12911 ...

I _think_ posix_cpu_timers_init_group() is not right, it should copy
cputime_expires->prof_exp.

Peter, any chance you can test the (uncompiled/untested) patch below?

Also, I assume that something like

	$ ulimit -t 3
	$ while true; do true; done

kills the shell correctly, yes? IOW, I suspect that ulimit works, but
cpuhog never check RLIMIT_CPU because fastpath_timer_check() always
returns 0 due to task_cputime_zero(&sig->cputime_expires) == T.

I'm afraid we need the fix fo 2.6.29 as well, but I am looking at rc3.

Hmm. check_process_timers() updates ->cputime_expires, but it never
clears (say) cputime_expires.prof_exp, why? Can't we just do

	if (cputime_gt(sig->cputime_expires.prof_exp, prof_expires))
		sig->cputime_expires.prof_exp = prof_expires;
at the end?

Oleg.

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -790,9 +790,7 @@ static void posix_cpu_timers_init_group(
 	sig->it_prof_incr = cputime_zero;
 
 	/* Cached expiration times. */
-	sig->cputime_expires.prof_exp = cputime_zero;
-	sig->cputime_expires.virt_exp = cputime_zero;
-	sig->cputime_expires.sched_exp = 0;
+	sig->cputime_expires = current->signal->cputime_expires;
 
 	/* The timer lists. */
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);

