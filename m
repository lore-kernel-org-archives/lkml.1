Return-Path: <linux-kernel-owner+w=401wt.eu-S1161039AbXCVLSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161039AbXCVLSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 07:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161023AbXCVLSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 07:18:52 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50244 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161039AbXCVLSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 07:18:51 -0400
Date: Thu, 22 Mar 2007 03:18:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
       tglx@linutronix.de
Subject: Re: [PATCH 1/2] Add support for deferrable timers
Message-Id: <20070322031826.55d483e4.akpm@linux-foundation.org>
In-Reply-To: <20070321202217.GA29367@linux-os.sc.intel.com>
References: <20070321202217.GA29367@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 13:22:17 -0700 Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> 
> Introduce a new flag for timers - 'deferrable timer'
> Timers that work normally when system is busy. But, will not cause CPU to
> come out of idle (just to service this timer), when CPU is idle. Instead,
> this timer will be serviced when CPU eventually wakes up with a subsequent
> non-deferrable timer or any other event.
> 
> The main advantage of this is to avoid unnecessary timer interrupts when
> CPU is idle. If the routine currently called by a timer can wait until next
> event without any issues, this new timer can be used while setting up timer
> for that routine. This, with dynticks, allows CPUs to be lazy, allowing them
> to stay in idle for extended period of time by reducing unnecesary wakeup and
> thereby reducing the power consumption.
> 
> This patch:
> Builds this new timer on top of existing timer infrastructure. It uses
> last bit in 'base' pointer of timer_list structure to store this
> deferrable timer flag. __next_timer_interrupt() function
> skips over these deferrable timers when CPU looks for
> next timer event for which it has to wake up.
> 
> This is exported by a new interface init_timer_deferrable() that can
> be called in place of regular init_timer().
> 

These patches cause a lockup during execuion of `halt -p'.  See phuzzy foto
at http://userweb.kernel.org/~akpm/s5000486.jpg

It's fairly obvious why, when one looks at lock_timer_base().


Also,

>  
> @@ -82,6 +82,46 @@
>  EXPORT_SYMBOL(boot_tvec_bases);
>  static DEFINE_PER_CPU(tvec_base_t *, tvec_bases) = &boot_tvec_bases;
>  
> +/*
> + * The lowest bit of base ptr in timer is used as a flag to indicate
> + * 'deferrable' nature of the timer. Functions below help us manage that flag.
> + */
> +static inline struct tvec_t_base_s *tbase_get_base_ptr(
> +	struct tvec_t_base_s *base)
> +{
> +	return ((struct tvec_t_base_s *)
> +			((unsigned long)base & (~TBASE_DEFERRABLE_FLAG)));
> +}
> +
> +static inline unsigned long tbase_get_deferrable_flag(
> +	struct tvec_t_base_s *base)
> +{
> +	return ((unsigned long)base & TBASE_DEFERRABLE_FLAG);
> +}
> +
> +static inline struct tvec_t_base_s *tbase_set_deferrable_flag(
> +	struct tvec_t_base_s *base)
> +{
> +	return ((struct tvec_t_base_s *)
> +			((unsigned long)base | TBASE_DEFERRABLE_FLAG));
> +}
> +
> +static inline struct tvec_t_base_s *tbase_clear_deferrable_flag(
> +	struct tvec_t_base_s *base)
> +{
> +	return ((struct tvec_t_base_s *)
> +			((unsigned long)base & (~TBASE_DEFERRABLE_FLAG)));
> +}
> +
> +static inline struct tvec_t_base_s *tbase_merge_deferrable_flag(
> +	struct tvec_t_base_s *base, unsigned long flag)
> +{
> +	if (flag & TBASE_DEFERRABLE_FLAG)
> +		return tbase_set_deferrable_flag(base);
> +	else
> +		return tbase_clear_deferrable_flag(base);
> +}

The above helpers seem rather verbose and cumbersome.  Looking at the
callsites:


>  /**
>   * __round_jiffies - function to round jiffies to a full second
>   * @j: the time in (absolute) jiffies that should be rounded
> @@ -295,6 +335,13 @@
>  }
>  EXPORT_SYMBOL(init_timer);
>  
> +void fastcall init_timer_deferrable(struct timer_list *timer)
> +{
> +	init_timer(timer);
> +	timer->base = tbase_set_deferrable_flag(timer->base);
> +}
> +EXPORT_SYMBOL(init_timer_deferrable);
> +
>  static inline void detach_timer(struct timer_list *timer,
>  				int clear_pending)
>  {
> @@ -325,7 +372,7 @@
>  	tvec_base_t *base;
>  
>  	for (;;) {
> -		base = timer->base;
> +		base = tbase_get_base_ptr(timer->base);
>  		if (likely(base != NULL)) {
>  			spin_lock_irqsave(&base->lock, *flags);
>  			if (likely(base == timer->base))
> @@ -364,12 +411,15 @@
>  		 * the timer is serialized wrt itself.
>  		 */
>  		if (likely(base->running_timer != timer)) {
> +			unsigned long tflag;
> +			tflag = tbase_get_deferrable_flag(timer->base);
>  			/* See the comment in lock_timer_base() */
>  			timer->base = NULL;
>  			spin_unlock(&base->lock);
>  			base = new_base;
>  			spin_lock(&base->lock);
> -			timer->base = base;
> +			timer->base =
> +				tbase_merge_deferrable_flag(new_base, tflag);
>  		}
>  	}

I expect you'll find that the generated code could be improved by
tightening those functions up a bit.

For example,

static inline void timer_set_deferrable(struct timer *timer)
{
	timer->base = (struct timer_list *)((unsigned long)timer->base |
			TBASE_DEFERRABLE_FLAG);
}

And I don't think we need the _flag in the names: timer_set_deferrable(),
timer_deferrable(), etc.

And the patch uses `unsigned long' everywhere to represent a flag which
can be 0 or 1.  It would be better to use unsigned int.

