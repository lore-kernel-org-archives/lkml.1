Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbZLEQpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbZLEQpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 11:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757174AbZLEQpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 11:45:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757166AbZLEQpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 11:45:36 -0500
Date: Sat, 5 Dec 2009 17:39:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Al Viro <viro@zeniv.linux.org.uk>, Miloslav Trmac <mitr@redhat.com>,
       James Morris <jmorris@namei.org>, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH v2 3/4] copy_signal cleanup: clean
	thread_group_cputime_init()
Message-ID: <20091205163941.GC23152@redhat.com>
References: <20091201221036.GA10052@darkmag.usersys.redhat.com> <20091202135759.GA791@redhat.com> <20091204142951.GJ10052@darkmag.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204142951.GJ10052@darkmag.usersys.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04, Veaceslav Falico wrote:
>
> Remove unneeded initializations in thread_group_cputime_init() and
> in posix_cpu_timers_init_group(). They are useless after
> kmem_cache_zalloc() was used in copy_signal().
>
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
> ---
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 75e6e60..4778ef7 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -825,17 +825,6 @@ static void posix_cpu_timers_init_group(struct
> signal_struct *sig)
>     /* Thread group counters. */
>     thread_group_cputime_init(sig);
>
> -   /* Expiration times and increments. */
> -   sig->it[CPUCLOCK_PROF].expires = cputime_zero;
> -   sig->it[CPUCLOCK_PROF].incr = cputime_zero;
> -   sig->it[CPUCLOCK_VIRT].expires = cputime_zero;
> -   sig->it[CPUCLOCK_VIRT].incr = cputime_zero;
> -
> -   /* Cached expiration times. */
> -   sig->cputime_expires.prof_exp = cputime_zero;
> -   sig->cputime_expires.virt_exp = cputime_zero;
> -   sig->cputime_expires.sched_exp = 0;
> -
>     if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
>         sig->cputime_expires.prof_exp =
>             secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2419,9 +2419,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
>
>  static inline void thread_group_cputime_init(struct signal_struct *sig)
>  {
> -	sig->cputimer.cputime = INIT_CPUTIME;
>  	spin_lock_init(&sig->cputimer.lock);
> -	sig->cputimer.running = 0;
>  }

Perhaps it makes sense to move thread_group_cputimer() into kernel/fork.c,
or even fold it into its single caller, posix_cpu_timers_init_group().

Acked-by: Oleg Nesterov <oleg@redhat.com>

