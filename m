Return-Path: <linux-kernel-owner+w=401wt.eu-S1752034AbZJWLq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbZJWLq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 07:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZJWLqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 07:46:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50005 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbZJWLqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 07:46:24 -0400
Date: Fri, 23 Oct 2009 13:46:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Cc: akpm@linux-foundation.org, oleg@redhat.com, roland@redhat.com,
       LKML <linux-kernel@vger.kernel.org>, h-shimamoto@ct.jp.nec.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] show message when exceeded rlimit of pending signals
Message-ID: <20091023114600.GG5886@elte.hu>
References: <4AE1804A.2050404@miraclelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE1804A.2050404@miraclelinux.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Naohiro Ooiwa <nooiwa@miraclelinux.com> wrote:

> Hi Andrew,
> 
> I was glad to talk to you in Japan Linux Symposium.
> I'm writing about it.
> 
> 
> I'm working to support kernel.
> Recently, I got a inquiry about unexpected system behavior.
> I analyzed application of our customer includeing kernel.
> 
> Eventually, there was no bug in application or kernel.
> I found the cause was the limit of pending signals.
> I ran following command. and system behaved expectedly.
>    # ulimit -i unlimited
> 
> When system behaved unexpectedly, the timer_create() in application
> had returned -EAGAIN value.
> But we can't imagine the -EAGAIN means that it exceeded limit of
> pending signals at all.
> 
> Then I thought kernel should at least show some message about it.
> And I tried to create a patch.
> 
> I'm sure that system engineeres will not have to have the same experience as I did.
> How do you think about this idea ?
> 
> Thank you
> Naohiro Ooiwa.
> 
> Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
> ---
>  kernel/signal.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 6705320..0bc4934 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -188,6 +188,9 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
>  	return sig;
>  }
> 
> +#define MAX_RLIMIT_CAUTION 5
> +static int rlimit_caution_count = 0;
> +
>  /*
>   * allocate a new signal queue record
>   * - this may be called without locks if and only if t == current, otherwise an
> @@ -211,6 +214,16 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
>  	    atomic_read(&user->sigpending) <=
>  			t->signal->rlim[RLIMIT_SIGPENDING].rlim_cur)
>  		q = kmem_cache_alloc(sigqueue_cachep, flags);
> +	else {
> +		if (rlimit_caution_count <= MAX_RLIMIT_CAUTION ){
> +			printk(KERN_WARNING "reached the limit of pending signalis on pid %d\n", current->pid);
> +			/* Last time, show the advice */
> +			if (rlimit_caution_count == MAX_RLIMIT_CAUTION)
> +				printk(KERN_WARNING "If unexpected your system behavior, you can try ulimit -i unlimited\n");
> +			rlimit_caution_count++;
> +		}
> +	}
> +
>  	if (unlikely(q == NULL)) {
>  		atomic_dec(&user->sigpending);
>  		free_uid(user);

This new warning looks quite useful, i've seen several apps get into 
trouble silently due to that, again and again.

The memory overhead of the signal queue was a problem 15 years ago ... 
not so much today and people (and apps) dont expect to get in trouble 
here. So the limit and its defaults are somewhat arcane, and the 
behavior is catastrophic and hard to debug (because it's a dynamic 
failure).

Regarding the patch, i've got a few (very) small suggestions.

Firstly, please update the if / else sequence from:

	if (...)
		...
	else {
		...
	}

to:

	if (...) {
		...
	} else {
		...
	}

as we strive for curly brace symmetries.

also, a small typo: s/signalis/signals

Plus, instead of using a pre-cooked global limit print_ratelimit() could 
be used as well. That makes it useful for long-lived systems that run 
into this limit occasionally. We wont spam the log - nor will we lose 
(potentially essential) messages in the process.

Thanks,

	Ingo
