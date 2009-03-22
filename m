Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbZCVWNN (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sun, 22 Mar 2009 18:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbZCVWLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 18:11:43 -0400
Received: from mx44.mail.ru ([94.100.176.58]:41749 "EHLO mx44.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756862AbZCVWLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 18:11:41 -0400
From: Peter Lojkin <ia6432@inbox.ru>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
   Peter Zijlstra <peterz@infradead.org>, rjw@sisk.pl
Subject: =?koi8-r?Q?Re=3A_2.6.28,_limiting_cpu_time_doesn't_work?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: unknown via proxy [83.167.111.116]
Date: Mon, 23 Mar 2009 01:08:03 +0300
References: <20090322201436.GA12838@redhat.com>
In-Reply-To: <20090322201436.GA12838@redhat.com>
Reply-To: Peter Lojkin <ia6432@inbox.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1LlVpr-0000Rv-00.ia6432-inbox-ru@f62.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:

> Found this message on http://bugzilla.kernel.org/show_bug.cgi?id=12911 ...
> 
> I _think_ posix_cpu_timers_init_group() is not right, it should copy
> cputime_expires->prof_exp.
> 
> Peter, any chance you can test the (uncompiled/untested) patch below?

yes, with this patch 2.6.28.8 works as expected, thank you!

> Also, I assume that something like
> 
> 	$ ulimit -t 3
> 	$ while true; do true; done
> 
> kills the shell correctly, yes?

yes, i've found it after original message and posted it in follow up:
http://marc.info/?l=linux-kernel&m=123770019023095&w=4

> IOW, I suspect that ulimit works, but
> cpuhog never check RLIMIT_CPU because fastpath_timer_check() always
> returns 0 due to task_cputime_zero(&sig->cputime_expires) == T.
> 
> I'm afraid we need the fix fo 2.6.29 as well, but I am looking at rc3.
> 
> Hmm. check_process_timers() updates ->cputime_expires, but it never
> clears (say) cputime_expires.prof_exp, why? Can't we just do
> 
> 	if (cputime_gt(sig->cputime_expires.prof_exp, prof_expires))
> 		sig->cputime_expires.prof_exp = prof_expires;
> at the end?

if you need to test any more patches on the subject i'm ready to do it.
regression test system for our project depends on ability to limit cpu time,
so it's major problem for us...

> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -790,9 +790,7 @@ static void posix_cpu_timers_init_group(
>  	sig->it_prof_incr = cputime_zero;
>  
>  	/* Cached expiration times. */
> -	sig->cputime_expires.prof_exp = cputime_zero;
> -	sig->cputime_expires.virt_exp = cputime_zero;
> -	sig->cputime_expires.sched_exp = 0;
> +	sig->cputime_expires = current->signal->cputime_expires;
>  
>  	/* The timer lists. */
>  	INIT_LIST_HEAD(&sig->cpu_timers[0]);
> 

