Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYKGQVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYKGQVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYKGQVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:21:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56416 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYKGQVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:21:15 -0500
Date: Fri, 7 Nov 2008 17:21:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, adobriyan@gmail.com,
       Doug Chapman <doug.chapman@hp.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] account_group_exec_runtime: fix the racy usage of
	->signal
Message-ID: <20081107162101.GA2178@elte.hu>
References: <20081107165238.GA23055@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107165238.GA23055@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Compile tested.
> 
> Unlike other similar routines, account_group_exec_runtime() could be
> called "implicitly" after exit_notify(). This means we can race with
> the parent doing release_task(), we can't just check ->signal != NULL.
> 
> Take ->siglock to make sure ->signal can't go away.
> 
> This is the minimal fix, with this patch we don't need need get/put cpu,
> and I think we should uninline this function.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

> 
> --- K-28/kernel/sched_stats.h~A_G_E_R_FIX	2008-11-07 17:32:02.000000000 +0100
> +++ K-28/kernel/sched_stats.h	2008-11-07 17:44:39.000000000 +0100
> @@ -351,10 +351,12 @@ static inline void account_group_exec_ru
>  					      unsigned long long ns)
>  {
>  	struct signal_struct *sig;
> +	unsigned long flags;
>  
> -	sig = tsk->signal;
> -	if (unlikely(!sig))
> +	if (unlikely(!lock_task_sighand(tsk, &flags)))
>  		return;

i think this will lock up: the signal lock must not nest inside the rq 
lock, and these accounting functions are called from within the 
scheduler.

	Ingo
