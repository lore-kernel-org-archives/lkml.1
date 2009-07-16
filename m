Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbZGPOm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbZGPOm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756422AbZGPOm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:42:29 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:12228 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbZGPOm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:42:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WxLcjFxRejsZhDxAqWYGHrl0vDITgyHyqVkT9VaZHVNhNYZbrIkUXwcCgjDuUJed2m
         V2iy/S+Vs7vSCjWW0HqM1H8ghxBSFaZWms3+luHunZ9fOe92dGF3LgODJgMa25LSrGKv
         FlQGJn9Yp5mKqeSfwK3kxLj96SyERoPDgOF7c=
Date: Thu, 16 Jul 2009 10:42:22 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/7] sched: Add a preempt count base offset to
	__might_sleep()
Message-ID: <20090716144220.GA8043@nowhere>
References: <1247725694-6082-1-git-send-email-fweisbec@gmail.com> <1247725694-6082-4-git-send-email-fweisbec@gmail.com> <1247753686.6586.20.camel@laptop> <1247754893.6586.24.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247754893.6586.24.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 04:34:53PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-07-16 at 16:14 +0200, Peter Zijlstra wrote:
> > On Thu, 2009-07-16 at 02:28 -0400, Frederic Weisbecker wrote:
> > > +++ b/include/linux/hardirq.h
> > > @@ -103,6 +103,13 @@
> > >   */
> > >  #define in_atomic()    ((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_INATOMIC_BASE)
> > >  
> > > +static inline int current_preempt_equals(int preempt_offset)
> > > +{
> > > +       int nested = preempt_count() & ~PREEMPT_ACTIVE;
> > > +
> > > +       return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
> > > +}
> > 
> > I'm not sure about it being in hardirq.h, I think we should keep this in
> > sched.c.
> > 
> > Also, I'm not sure about the name, but then I suck at naming too. How
> > about something like: preempt_count_equals() ?
> > 
> > Other than that the series looks nice and I've got it queued.
> 
> I've added this on top:
> 
> ---
> Index: linux-2.6/include/linux/hardirq.h
> ===================================================================
> --- linux-2.6.orig/include/linux/hardirq.h
> +++ linux-2.6/include/linux/hardirq.h
> @@ -103,13 +103,6 @@
>   */
>  #define in_atomic()	((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_INATOMIC_BASE)
>  
> -static inline int current_preempt_equals(int preempt_offset)
> -{
> -	int nested = preempt_count() & ~PREEMPT_ACTIVE;
> -
> -	return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
> -}
> -
>  /*
>   * Check whether we were atomic before we did preempt_disable():
>   * (used by the scheduler, *after* releasing the kernel lock)
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -9444,12 +9444,19 @@ void __init sched_init(void)
>  }
>  
>  #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
> +static inline int preempt_count_equals(int preempt_offset)
> +{
> +	int nested = preempt_count() & ~PREEMPT_ACTIVE;
> +
> +	return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
> +}
> +
>  void __might_sleep(char *file, int line, int preempt_offset)
>  {
>  #ifdef in_atomic
>  	static unsigned long prev_jiffy;	/* ratelimiting */
>  
> -	if ((current_preempt_equals(preempt_offset) && !irqs_disabled()) ||
> +	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
>  	    system_state != SYSTEM_RUNNING || oops_in_progress)
>  		return;
>  	if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)


Ok. Yeah the naming and the place are better there.

Thanks.

