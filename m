Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbZGUWHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbZGUWHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbZGUWHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:07:51 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55131 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbZGUWHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:07:51 -0400
Subject: Re: [RFC][patch 2/5] cleanup clocksource selection
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090721192058.392819645@de.ibm.com>
References: <20090721191745.788551122@de.ibm.com>
	 <20090721192058.392819645@de.ibm.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 15:07:49 -0700
Message-Id: <1248214069.3298.115.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 21:17 +0200, Martin Schwidefsky wrote:
> plain text document attachment (clocksource-queue.diff)
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Introduce clocksource_dequeue & clocksource_update and move spinlock
> calls. clocksource_update does nothing for GENERIC_TIME=n since
> change_clocksource does nothing as well.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: john stultz <johnstul@us.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  kernel/time/clocksource.c |  123 ++++++++++++++++++++++++++--------------------
>  1 file changed, 70 insertions(+), 53 deletions(-)


>From a very quick skim, this patch looks structurally ok to me.

thanks
-john


> Index: linux-2.6/kernel/time/clocksource.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/clocksource.c
> +++ linux-2.6/kernel/time/clocksource.c
> @@ -341,46 +341,25 @@ struct clocksource *clocksource_get_next
>  	return curr_clocksource;
>  }
> 
> -/**
> - * select_clocksource - Selects the best registered clocksource.
> - *
> - * Private function. Must hold clocksource_lock when called.
> - *
> - * Select the clocksource with the best rating, or the clocksource,
> - * which is selected by userspace override.
> - */
> -static struct clocksource *select_clocksource(void)
> -{
> -	struct clocksource *next;
> -
> -	if (list_empty(&clocksource_list))
> -		return NULL;
> -
> -	if (clocksource_override)
> -		next = clocksource_override;
> -	else
> -		next = list_entry(clocksource_list.next, struct clocksource,
> -				  list);
> -
> -	if (next == curr_clocksource)
> -		return NULL;
> -
> -	return next;
> -}
> -
>  /*
>   * Enqueue the clocksource sorted by rating
>   */
>  static int clocksource_enqueue(struct clocksource *c)
>  {
>  	struct list_head *tmp, *entry = &clocksource_list;
> +	unsigned long flags;
> +	int rc;
> 
> +	spin_lock_irqsave(&clocksource_lock, flags);
> +	rc = 0;
>  	list_for_each(tmp, &clocksource_list) {
>  		struct clocksource *cs;
> 
>  		cs = list_entry(tmp, struct clocksource, list);
> -		if (cs == c)
> -			return -EBUSY;
> +		if (cs == c) {
> +			rc = -EBUSY;
> +			goto out;
> +		}
>  		/* Keep track of the place, where to insert */
>  		if (cs->rating >= c->rating)
>  			entry = tmp;
> @@ -390,8 +369,23 @@ static int clocksource_enqueue(struct cl
>  	if (strlen(c->name) == strlen(override_name) &&
>  	    !strcmp(c->name, override_name))
>  		clocksource_override = c;
> +out:
> +	spin_unlock_irqrestore(&clocksource_lock, flags);
> +	return rc;
> +}
> +
> +/*
> + * Dequeue a clocksource
> + */
> +static void clocksource_dequeue(struct clocksource *cs)
> +{
> +	unsigned long flags;
> 
> -	return 0;
> +	spin_lock_irqsave(&clocksource_lock, flags);
> +	list_del(&cs->list);
> +	if (clocksource_override == cs)
> +		clocksource_override = NULL;
> +	spin_unlock_irqrestore(&clocksource_lock, flags);
>  }
> 
>  /**
> @@ -539,6 +533,25 @@ void clocksource_forward_now(void)
>  }
> 
>  /**
> + * select_clocksource - Selects the best registered clocksource.
> + *
> + * Private function. Must hold clocksource_lock when called.
> + *
> + * Select the clocksource with the best rating, or the clocksource,
> + * which is selected by userspace override.
> + */
> +static struct clocksource *select_clocksource(void)
> +{
> +	if (list_empty(&clocksource_list))
> +		return NULL;
> +
> +	if (clocksource_override)
> +		return clocksource_override;
> +
> +	return list_entry(clocksource_list.next, struct clocksource, list);
> +}
> +
> +/**
>   * change_clocksource - Swaps clocksources if a new one is available
>   *
>   * Accumulates current time interval and initializes new clocksource
> @@ -577,6 +590,23 @@ void change_clocksource(void)
>  	       clock->name);
>  	 */
>  }
> +
> +/**
> + * clocksource_update - Check if a better clocksource is available
> + */
> +static void clocksource_update(void)
> +{
> +	struct clocksource *new;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&clocksource_lock, flags);
> +	new = select_clocksource();
> +	if (new)
> +		next_clocksource = new;
> +	spin_unlock_irqrestore(&clocksource_lock, flags);
> +}
> +#else /* CONFIG_GENERIC_TIME */
> +static inline void clocksource_update(void) { }
>  #endif
> 
>  /**
> @@ -587,16 +617,13 @@ void change_clocksource(void)
>   */
>  int clocksource_register(struct clocksource *c)
>  {
> -	unsigned long flags;
>  	int ret;
> 
> -	spin_lock_irqsave(&clocksource_lock, flags);
>  	ret = clocksource_enqueue(c);
> -	if (!ret)
> -		next_clocksource = select_clocksource();
> -	spin_unlock_irqrestore(&clocksource_lock, flags);
> -	if (!ret)
> +	if (!ret) {
> +		clocksource_update();
>  		clocksource_check_watchdog(c);
> +	}
>  	return ret;
>  }
>  EXPORT_SYMBOL(clocksource_register);
> @@ -607,14 +634,10 @@ EXPORT_SYMBOL(clocksource_register);
>   */
>  void clocksource_change_rating(struct clocksource *cs, int rating)
>  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&clocksource_lock, flags);
> -	list_del(&cs->list);
> +	clocksource_dequeue(cs);
>  	cs->rating = rating;
>  	clocksource_enqueue(cs);
> -	next_clocksource = select_clocksource();
> -	spin_unlock_irqrestore(&clocksource_lock, flags);
> +	clocksource_update();
>  }
> 
>  /**
> @@ -622,14 +645,8 @@ void clocksource_change_rating(struct cl
>   */
>  void clocksource_unregister(struct clocksource *cs)
>  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&clocksource_lock, flags);
> -	list_del(&cs->list);
> -	if (clocksource_override == cs)
> -		clocksource_override = NULL;
> -	next_clocksource = select_clocksource();
> -	spin_unlock_irqrestore(&clocksource_lock, flags);
> +	clocksource_dequeue(cs);
> +	clocksource_update();
>  }
> 
>  /**
> @@ -721,13 +738,13 @@ static ssize_t sysfs_override_clocksourc
>  	}
> 
>  	/* Reselect, when the override name has changed */
> -	if (ovr != clocksource_override) {
> +	if (ovr != clocksource_override)
>  		clocksource_override = ovr;
> -		next_clocksource = select_clocksource();
> -	}
> 
>  	spin_unlock_irq(&clocksource_lock);
> 
> +	clocksource_update();
> +
>  	return ret;
>  }
> 
> 

