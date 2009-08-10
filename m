Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbZHJP2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbZHJP2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZHJP2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:28:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46766 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbZHJP2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:28:19 -0400
Subject: Re: [PATCH V2] futex: Fix handling of bad requeue syscall pairing
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: "lkml," <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
In-Reply-To: <4A7CA8C0.7010809@us.ibm.com>
References: <4A7CA06E.1090904@us.ibm.com>  <4A7CA8C0.7010809@us.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Aug 2009 17:27:44 +0200
Message-Id: <1249918064.17467.143.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 15:20 -0700, Darren Hart wrote:
> From: Darren Hart <dvhltc@us.ibm.com>
> 
> If futex_requeue(requeue_pi=1) finds a futex_q that was created by a call
> other the futex_wait_requeue_pi(), the q.rt_waiter may be null.  If so,
> this will result in an oops from the following call graph:
> 
> futex_requeue()
>   rt_mutex_start_proxy_lock()
>     task_blocks_on_rt_mutex()
>       waiter->task dereference
>         OOPS
> 
> We currently WARN_ON() if this is detected, clearly this is inadequate.
> If we detect a mispairing in futex_requeue(), bail out, seding -EINVAL to
> user-space.
> 
> V2: Fix parenthesis warnings.
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Peter Zijlstra <peterz@infradead.org>

> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Dinakar Guniguntala <dino@in.ibm.com>
> CC: John Stultz <johnstul@us.ibm.com>
> ---
> 
>  kernel/futex.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index df30983..4705d89 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1306,8 +1306,15 @@ retry_private:
>  		if (!match_futex(&this->key, &key1))
>  			continue;
>  
> -		WARN_ON(!requeue_pi && this->rt_waiter);
> -		WARN_ON(requeue_pi && !this->rt_waiter);
> +		/*
> +		 * FUTEX_WAIT_REQEUE_PI and FUTEX_CMP_REQUEUE_PI should always
> +		 * be paired with each other and no other futex ops.
> +		 */
> +		if ((requeue_pi && !this->rt_waiter) ||
> +		    (!requeue_pi && this->rt_waiter)) {
> +			ret = -EINVAL;
> +			break;
> +		}
>  
>  		/*
>  		 * Wake nr_wake waiters.  For requeue_pi, if we acquired the
