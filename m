Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYHBW25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYHBW25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 18:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYHBW2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 18:28:50 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:44827 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbYHBW2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 18:28:49 -0400
Date: Sun, 3 Aug 2008 00:27:39 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Oliver Pinter <pinter.oliver.villany@gmail.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org, w@1wt.eu,
       Roland McGrath <roland@redhat.com>, john stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>,
       Oliver Pinter <oliver.pntr@gmail.com>
Subject: Re: [RFC, 2.6.26.2-rc1] posix timers: release_posix_timer: kill the
 bogus put_task_struct(->it_process)
In-Reply-To: <200808022345.20963.oliver.pntr@gmail.com>
Message-ID: <alpine.LNX.1.10.0808030006040.2294@titan.stealer.net>
References: <200808022345.20963.oliver.pntr@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
X-Spam-Bar: --
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sat, 02 Aug 2008 22:27:51 +0000
	Bayes: 0.0000 Tokens: new, 319; hammy, 9; neutral, 5; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
X-Spam-Signature: 72295b34047a3320802020d79064578f0ec5015c
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Aug 2008, Oliver Pinter wrote:

> It is an RFC for sending this patch for stable, when this patch needed, then send ACK and CC stable,
> if not then send NAK.

I'd say big NAK. Have you ever looked at the full commit message and patch 
at all? It says "release_posix_timer() can't be called with ->it_process 
!= NULL.". Point. The rest is the explanation why this can't happen. And 
looking at the patch, we see that it just removes code that actually never 
gets executed under the mentioned preconditions. It's a pure cleanup patch 
and doesn't qualify for -stable. Same goes for the other posix timer patch 
you mailed out.

> ---
> From 96347e7759e2e433c427defa0fa1adfc8cce6226 Mon Sep 17 00:00:00 2001
> From: Oleg Nesterov <oleg@tv-sign.ru>
> Date: Fri, 25 Jul 2008 01:47:27 -0700
> Subject: [PATCH] posix timers: release_posix_timer: kill the bogus put_task_struct(->it_process);
> 
> [ Upstream commit 96347e7759e2e433c427defa0fa1adfc8cce6226 ]
> 
> release_posix_timer() can't be called with ->it_process != NULL.  Once
> sys_timer_create() sets ->it_process it must not call
> release_posix_timer(), otherwise we can race with another thread doing
> sys_timer_delete(), this timer is visible to idr_find() and unlocked.
> 
> The same is true for two other callers (actually, for any possible
> caller), sys_timer_delete() and itimer_delete().  They must clear
> ->it_process before unlock_timer() + release_posix_timer().
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> Acked-by: Roland McGrath <roland@redhat.com>
> Cc: john stultz <johnstul@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Roland McGrath <roland@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Oliver Pinter <oliver.pntr@gmail.com>
> 
> diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
> index 17f5326..9a21681 100644
> --- a/kernel/posix-timers.c
> +++ b/kernel/posix-timers.c
> @@ -449,9 +449,6 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
>  		spin_unlock_irqrestore(&idr_lock, flags);
>  	}
>  	sigqueue_free(tmr->sigq);
> -	if (unlikely(tmr->it_process) &&
> -	    tmr->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
> -		put_task_struct(tmr->it_process);
>  	kmem_cache_free(posix_timers_cache, tmr);
>  }
>  
