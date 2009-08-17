Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbZHQHkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbZHQHkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 03:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757062AbZHQHko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 03:40:44 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:39978 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039AbZHQHko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 03:40:44 -0400
Date: Mon, 17 Aug 2009 09:40:42 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/15] clocksource / timekeeping rework V4 (resend V3 +
 bug fix)
Message-ID: <20090817094042.03fe5d38@skybase>
In-Reply-To: <alpine.LFD.2.00.0908151207000.1283@localhost.localdomain>
References: <20090814134717.859098725@de.ibm.com>
	<1250300765.8269.29.camel@localhost.localdomain>
	<alpine.LFD.2.00.0908151057500.1283@localhost.localdomain>
	<20090815095221.GA15831@elte.hu>
	<alpine.LFD.2.00.0908151207000.1283@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Aug 2009 12:08:35 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> Yeah, we need to call clocksource_change_rating() outside of watchdog
> lock. Spotted a missing _irqrestore as well.
> 
> Thanks,
> 
> 	tglx
> ---
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index a1657b5..02dc22d 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -307,16 +307,23 @@ static void clocksource_watchdog_work(struct work_struct *work)
>  {
>  	struct clocksource *cs, *tmp;
>  	unsigned long flags;
> +	LIST_HEAD(unstable);
> 
>  	spin_lock_irqsave(&watchdog_lock, flags);
>  	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list)
>  		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
>  			list_del_init(&cs->wd_list);
> -			clocksource_change_rating(cs, 0);
> +			list_add(&cs->wd_list, &unstable);
>  		}
>  	/* Check if the watchdog timer needs to be stopped. */
>  	clocksource_stop_watchdog();
> -	spin_unlock(&watchdog_lock);
> +	spin_unlock_irqrestore(&watchdog_lock, flags);
> +
> +	/* Needs to be done outside of watchdog lock */
> +	list_for_each_entry_safe(cs, tmp, &unstable, wd_list) {
> +		list_del_init(&cs->wd_list);
> +		clocksource_change_rating(cs, 0);
> +	}
>  }
> 
>  #else /* CONFIG_CLOCKSOURCE_WATCHDOG */

Autsch, the s/spin_unlock/spin_unlock_irqrestore/ is rather obvious, no?
In theory we now have a reference count problem. The call to 
clocksource_change_rating are no done outside of the clocksource mutex
and outside of the watchdog lock. A concurrent clocksource_unregister
could remove the clock.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

