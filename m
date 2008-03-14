Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbYCNUYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbYCNUYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbYCNUYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:24:11 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54256 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbYCNUYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:24:09 -0400
Subject: Re: [PATCH 8/8] handle leap second via timer
From: john stultz <johnstul@us.ibm.com>
To: zippel@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080314195737.212526899@linux-m68k.org>
References: <20080314184001.695807682@linux-m68k.org>
	 <20080314195737.212526899@linux-m68k.org>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 13:24:04 -0700
Message-Id: <1205526244.6122.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-14 at 19:40 +0100, zippel@linux-m68k.org wrote:
> plain text document attachment (leap_sec)
> Remove the leap second handling from second_overflow(), which doesn't
> has to check for it every second anymore. With CONFIG_NO_HZ this also
> makes sure the leap second is handled close to the full second.
> Additionally this makes it possible to abort a leap second properly
> by resetting the STA_INS/STA_DEL status bits.
> 
> Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

Looks interesting. Small comment below.


> -void second_overflow(void)
> +static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
>  {
> -	s64 time_adj;
> +	enum hrtimer_restart res = HRTIMER_NORESTART;
> 
> -	/* Bump the maxerror field */
> -	time_maxerror += MAXFREQ / NSEC_PER_USEC;
> -	if (time_maxerror > NTP_PHASE_LIMIT) {
> -		time_maxerror = NTP_PHASE_LIMIT;
> -		time_status |= STA_UNSYNC;
> -	}
> +	write_seqlock_irq(&xtime_lock);
> 
> -	/*
> -	 * Leap second processing. If in leap-insert state at the end of the
> -	 * day, the system clock is set back one second; if in leap-delete
> -	 * state, the system clock is set ahead one second. The microtime()
> -	 * routine or external clock driver will insure that reported time is
> -	 * always monotonic. The ugly divides should be replaced.
> -	 */
>  	switch (time_state) {
>  	case TIME_OK:
> -		if (time_status & STA_INS)
> -			time_state = TIME_INS;
> -		else if (time_status & STA_DEL)
> -			time_state = TIME_DEL;
>  		break;
>  	case TIME_INS:
> -		if (xtime.tv_sec % 86400 == 0) {
> -			xtime.tv_sec--;
> -			wall_to_monotonic.tv_sec++;
> -			time_state = TIME_OOP;
> -			printk(KERN_NOTICE "Clock: inserting leap second "
> -					"23:59:60 UTC\n");
> -		}
> +		xtime.tv_sec--;
> +		wall_to_monotonic.tv_sec++;
> +		time_state = TIME_OOP;
> +		printk(KERN_NOTICE "Clock: "
> +		       "inserting leap second 23:59:60 UTC\n");
> +		leap_timer.expires = ktime_add_ns(leap_timer.expires,
> +						  NSEC_PER_SEC);
> +		res = HRTIMER_RESTART;
>  		break;
>  	case TIME_DEL:
> -		if ((xtime.tv_sec + 1) % 86400 == 0) {
> -			xtime.tv_sec++;
> -			time_tai--;
> -			wall_to_monotonic.tv_sec--;
> -			time_state = TIME_WAIT;
> -			printk(KERN_NOTICE "Clock: deleting leap second "
> -					"23:59:59 UTC\n");
> -		}
> +		xtime.tv_sec++;
> +		time_tai--;
> +		wall_to_monotonic.tv_sec--;
> +		time_state = TIME_WAIT;
> +		printk(KERN_NOTICE "Clock: "
> +		       "deleting leap second 23:59:59 UTC\n");
>  		break;
>  	case TIME_OOP:
>  		time_tai++;
>  		time_state = TIME_WAIT;
> -		break;
> +		/* fall through */
>  	case TIME_WAIT:
>  		if (!(time_status & (STA_INS | STA_DEL)))
>  			time_state = TIME_OK;
> +		break;
> +	}
> +	update_vsyscall(&xtime, clock);
> +

<snip>

> Index: linux-2.6/include/linux/clocksource.h
> ===================================================================
> --- linux-2.6.orig/include/linux/clocksource.h	2008-03-10 19:50:33.000000000 +0100
> +++ linux-2.6/include/linux/clocksource.h	2008-03-13 10:33:24.000000000 +0100
> @@ -93,6 +93,8 @@ struct clocksource {
>  #endif
>  };
> 
> +extern struct clocksource *clock;	/* current clocksource */
> +
>  /*
>   * Clock source flags bits::
>   */

Instead of exporting the clocksource making it global, could you use a
timekeeping_insert/remove_second() style interface?

That would help remove the xtime/wall_to_monotonic references in ntp.c
as well, cleaning up things nicely.

thanks
-john


