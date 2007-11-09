Return-Path: <linux-kernel-owner+w=401wt.eu-S932172AbXKIXXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbXKIXXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759480AbXKIXTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:19:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759423AbXKIXTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:19:37 -0500
Date: Fri, 9 Nov 2007 15:19:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: mikael.starvik@axis.com, jesper.nilsson@axis.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRISv10 improve and bugfix fasttimer
Message-Id: <20071109151932.610bca4c.akpm@linux-foundation.org>
In-Reply-To: <20071108085430.GB6347@axis.com>
References: <20071108085430.GB6347@axis.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007 09:54:30 +0100
Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> Improve and bugfix CRIS v10 fast timers.

I'm trying to work out what's going on with all this cris activity.  Is the
current code really that busted, or are you adding new chip support, or are
you resyncing mainline with some external tree or what?

It _seems_ that pretty much everything you've sent over is a bugfix of some
form.  Should we push it all into 2.6.24?

> -void __INLINE__ do_gettimeofday_fast(struct timeval *tv)
> +void __INLINE__ do_gettimeofday_fast(struct fasttime_t *tv)

You might like to dispose of __INLINE__ sometime.  I doubt if there's
really any need for it, and using plain old inline everywhere would be
nicer.

> -timer1_handler(int irq, void *dev_id, struct pt_regs *regs)
> +timer1_handler(int irq, void *dev_id)
>  {
>    struct fast_timer *t;
>    unsigned long flags;
>  
> +	/* We keep interrupts disabled not only when we modify the
> +	 * fast timer list, but any time we hold a reference to a
> +	 * timer in the list, since del_fast_timer may be called
> +	 * from (another) interrupt context.  Thus, the only time
> +	 * when interrupts are enabled is when calling the timer
> +	 * callback function.
> +	 */
>    local_irq_save(flags);
>  
>    /* Clear timer1 irq */
> @@ -466,16 +370,17 @@ timer1_handler(int irq, void *dev_id, struct pt_regs *regs)
>    fast_timer_running = 0;
>    fast_timer_ints++;
>  
> -  local_irq_restore(flags);
> -
>    t = fast_timer_list;
>    while (t)
>    {
> -    struct timeval tv;
> +		struct fasttime_t tv;
> +		fast_timer_function_type *f;
> +		unsigned long d;
>  
>      /* Has it really expired? */

heh, so the old code used a bizarre random-number-of-spaces for indenting
and the edits use tabs.


>      do_gettimeofday_fast(&tv);
> -    D1(printk("t: %is %06ius\n", tv.tv_sec, tv.tv_usec));
> +		D1(printk(KERN_DEBUG "t: %is %06ius\n",
> +			tv.tv_jiff, tv.tv_usec));

Like that.

Suggest that you consider a large-scale cleaup during some quiet time. 
Often people will feed the file wholesale through scripts/Lindent and will
then fix up Lindent mistakes by hand.  If you go this way, please do it as
two separate patches.  That way if the huge cleanup patch breaks due to
other changes I can rerun Lindent and the manual fix-Lindents-mistakes
patch usually applies easily on top of the newly-generated
run-it-through-Lindent patch.

>      if (timeval_cmp(&t->tv_expires, &tv) <= 0)

You have a private timeval_cmp().  Please take a look at utilising
include/linux/time.h:timeval_compare() instead.  If that doesn't suit then
we'd entertain extensions of that interface.  Adding private code to do
something as common as this is not a good thing.


