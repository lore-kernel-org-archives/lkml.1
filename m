Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZLBOEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZLBOEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbZLBOEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:04:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbZLBOEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:04:44 -0500
Date: Wed, 2 Dec 2009 14:57:59 +0100
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
Subject: Re: [PATCH 1/4] copy_signal cleanup: use zalloc and remove
	initializations
Message-ID: <20091202135759.GA791@redhat.com>
References: <20091201221036.GA10052@darkmag.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201221036.GA10052@darkmag.usersys.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01, Veaceslav Falico wrote:
>
> Use kmem_cache_zalloc() on signal creation and remove unneeded initialization
> lines.

I like this series very much. Not only it cleanups and lessens the code,
it opens the possibility to do more cleanups. Say, we can simplify
exit_notify() a bit, we can remove ->group_exit_task check since we know
->notify_count < 0 can be false positive.

A couple of nits though,

> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
> ---
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 166b8c4..160477d 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -825,17 +825,6 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
>  	/* Thread group counters. */
>  	thread_group_cputime_init(sig);
>
> -	/* Expiration times and increments. */
> -	sig->it[CPUCLOCK_PROF].expires = cputime_zero;
> -	sig->it[CPUCLOCK_PROF].incr = cputime_zero;
> -	sig->it[CPUCLOCK_VIRT].expires = cputime_zero;
> -	sig->it[CPUCLOCK_VIRT].incr = cputime_zero;
> -
> -	/* Cached expiration times. */
> -	sig->cputime_expires.prof_exp = cputime_zero;
> -	sig->cputime_expires.virt_exp = cputime_zero;
> -	sig->cputime_expires.sched_exp = 0;
> -
>  	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
>  		sig->cputime_expires.prof_exp =
>  			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);

Personally I don't mind, but perhaps it is better to move this change
into 3/4 which changes thread_group_cputime_init().

> @@ -855,7 +844,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>  	if (clone_flags & CLONE_THREAD)
>  		return 0;
>
> -	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
> +	sig = kmem_cache_zalloc(signal_cachep, GFP_KERNEL);
>
> [...snip...]

Imho, very nice change.

Oleg.

