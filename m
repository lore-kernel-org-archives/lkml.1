Return-Path: <linux-kernel-owner+w=401wt.eu-S1759366AbYEALot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbYEALot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 07:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756424AbYEALok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 07:44:40 -0400
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:2405 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbYEALoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 07:44:39 -0400
Message-ID: <4819ACF6.9000403@panasas.com>
Date: Thu, 01 May 2008 14:43:50 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 09/10] misc: fix returning void-valued expression warnings
References: <1209593024.24729.119.camel@brick>
In-Reply-To: <1209593024.24729.119.camel@brick>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01 2008 at 1:03 +0300, Harvey Harrison <harvey.harrison@gmail.com> wrote:
> kernel/sched_fair.c:845:3: warning: returning void-valued expression
> kernel/sched.c:4343:3: warning: returning void-valued expression
> security/security.c:897:2: warning: returning void-valued expression
> security/security.c:1014:2: warning: returning void-valued expression
> security/security.c:1019:2: warning: returning void-valued expression
> sound/sound_core.c:410:2: warning: returning void-valued expression
> sound/sound_core.c:427:2: warning: returning void-valued expression
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Peter, I know you don't like this very much, but it would help reduce the
> trivial noise somewhat in a sparse build.
> 
>  kernel/sched.c      |    6 ++++--
>  kernel/sched_fair.c |    6 ++++--
>  security/security.c |    6 +++---
>  sound/sound_core.c  |    4 ++--
>  4 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index e2f7f5a..864daf8 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4339,8 +4339,10 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
>  	struct rq *rq = this_rq();
>  	cputime64_t tmp;
>  
> -	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0))
> -		return account_guest_time(p, cputime);
> +	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
> +		account_guest_time(p, cputime);
> +		return;
> +	}

I don't know who invented sparse, but I like this form of return.
1 - It saves me the curly brackets and extra return line. But mainly
2 - It is a programing statement that says: "Me here I'm an equivalent 
  to that other call". So if in the future that inner function starts
  to return, say, an error value, with the first style the compiler will
  error. But with the second style the new error return will be silently
  ignored. So these are not equivalent replacements. The former is a much
  stronger bond between the caller and the callie.

>  
>  	p->stime = cputime_add(p->stime, cputime);
>  
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 89fa32b..0bd575e 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -841,8 +841,10 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
>  	 * queued ticks are scheduled to match the slice, so don't bother
>  	 * validating it and just reschedule.
>  	 */
> -	if (queued)
> -		return resched_task(rq_of(cfs_rq)->curr);
> +	if (queued) {
> +		resched_task(rq_of(cfs_rq)->curr);
> +		return;
> +	}
>  	/*
>  	 * don't let the period tick interfere with the hrtick preemption
>  	 */
> diff --git a/security/security.c b/security/security.c
> index 59838a9..8073a1a 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -894,7 +894,7 @@ EXPORT_SYMBOL(security_secctx_to_secid);
>  
>  void security_release_secctx(char *secdata, u32 seclen)
>  {
> -	return security_ops->release_secctx(secdata, seclen);
> +	security_ops->release_secctx(secdata, seclen);
>  }
>  EXPORT_SYMBOL(security_release_secctx);
>  
> @@ -1011,12 +1011,12 @@ int security_sk_alloc(struct sock *sk, int family, gfp_t priority)
>  
>  void security_sk_free(struct sock *sk)
>  {
> -	return security_ops->sk_free_security(sk);
> +	security_ops->sk_free_security(sk);
>  }
>  
>  void security_sk_clone(const struct sock *sk, struct sock *newsk)
>  {
> -	return security_ops->sk_clone_security(sk, newsk);
> +	security_ops->sk_clone_security(sk, newsk);
>  }
>  
>  void security_sk_classify_flow(struct sock *sk, struct flowi *fl)
> diff --git a/sound/sound_core.c b/sound/sound_core.c
> index 46daca1..b2538bf 100644
> --- a/sound/sound_core.c
> +++ b/sound/sound_core.c
> @@ -407,7 +407,7 @@ EXPORT_SYMBOL(unregister_sound_mixer);
>  
>  void unregister_sound_midi(int unit)
>  {
> -	return sound_remove_unit(&chains[2], unit);
> +	sound_remove_unit(&chains[2], unit);
>  }
>  
>  EXPORT_SYMBOL(unregister_sound_midi);
> @@ -424,7 +424,7 @@ EXPORT_SYMBOL(unregister_sound_midi);
>  
>  void unregister_sound_dsp(int unit)
>  {
> -	return sound_remove_unit(&chains[3], unit);
> +	sound_remove_unit(&chains[3], unit);
>  }
>  
> 

Even without the saving in the if case, I would say fix sparse, it is
very very wrong. a return (void)do(); is not equal to do(); return;

Code is not only high level assembly, it is also a low level English.
In English the first form is telling what the future assembly should
be.

big NACK from me (== $0.02)

Boaz

