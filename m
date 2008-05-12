Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbYELXZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbYELXZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 19:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbYELXZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 19:25:16 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:34090 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756139AbYELXZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 19:25:15 -0400
Subject: Re: Linux 2.6.26-rc2
From: Kasper Sandberg <lkml@metanurb.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0805121247080.3019@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org>
	 <e2e108260805121232t4cbd8eb0k219fd6a7d06c7650@mail.gmail.com>
	 <alpine.LFD.1.10.0805121247080.3019@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 May 2008 01:22:27 +0200
Message-Id: <1210634547.1093.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-12 at 12:55 -0700, Linus Torvalds wrote:
> 
> On Mon, 12 May 2008, Bart Van Assche wrote:
> > 
> > Sorry if it's my fault that I do not understand the above message
> > completely. But from the above it's not completely clear to me which
> > kernel versions (2.6.2?.? releases) are affected and which are not
> > affected by the performance and correctness issues due to the
> > interaction between the semaphore implementation and the preemptable
> > BKL.
> 
> No released kernels are affected. It's purely a matter that has happened 
> after 2.6.25. The semaphore simplifcation in -rc1 caused a huge 
> performance regression on some benchmarks, and the fix to that in turn 
> caused a semaphore correctness issue, so I just rolled back to the 
> original BKL code that doesn't have any of those interactions.
> 
> In a historical context, the issues involved would only have happened with 
> CONFIG_PREEMPT_BKL. That config option was made the only one in January, 
> and as a result of these issues, we effectively switched it off.
> 
> So you can *think* of the effect of the changes as having gone from 
> CONFIG_PREEMPT_BKL=y to CONFIG_PREEMPT_BKL=n, even though technically we 
> had removed the actual config option to let people choose (so the config 
> option has basically become a static code change).

uhm.. but .25 doesent have PREEMPT_BKL either.. does that mean its on or
off?

> 
> We may end up having to re-instate the config option due to this. 
> Personally, I hope not. It would be nicer if we could just avoid 
> PREEMPT_BKL entirely. 

you mean avoid preempting the bkl, or avoid having the option to choose
to preempt it, and just always do it?

> 
> (To make things somewhat more confusing, some non-PREEMPT_BKL code has 
> then bitrotted since, so if can actually see latency issues, you might 
> want to try the patch here at the end of this email to see if it fixes 
> the worst of them. "cond_resched()" has regressed since the PREEMPT_BKL 
> config option went away).
> 
> 			Linus
> ---
>  include/linux/sched.h |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 5a63f2d..75c284f 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2038,17 +2038,10 @@ static inline int need_resched(void)
>   * cond_resched_softirq() will enable bhs before scheduling.
>   */
>  extern int _cond_resched(void);
> -#ifdef CONFIG_PREEMPT
> -static inline int cond_resched(void)
> -{
> -	return 0;
> -}
> -#else
>  static inline int cond_resched(void)
>  {
>  	return _cond_resched();
>  }
> -#endif
>  extern int cond_resched_lock(spinlock_t * lock);
>  extern int cond_resched_softirq(void);
>  static inline int cond_resched_bkl(void)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

