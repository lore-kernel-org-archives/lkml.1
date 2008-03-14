Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbYCNUzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbYCNUzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYCNUzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:55:09 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43267 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbYCNUzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:55:09 -0400
Subject: Re: [PATCH 5/8] support for TAI
From: john stultz <johnstul@us.ibm.com>
To: zippel@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080314195737.035249969@linux-m68k.org>
References: <20080314184001.695807682@linux-m68k.org>
	 <20080314195737.035249969@linux-m68k.org>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 13:55:05 -0700
Message-Id: <1205528105.6122.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-14 at 19:40 +0100, zippel@linux-m68k.org wrote:
> plain text document attachment (time_tai)
> This adds support for setting the TAI value (International Atomic Time).
> The value is reported back to userspace via timex (as we don't have a
> ntp_gettime() syscall).
> 
> Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
> 

Very cool. I just was talking with someone who was looking for a TAI
interface. 

Minor nit below.

-john


> Index: linux-2.6-mm/kernel/time/ntp.c
> ===================================================================
> --- linux-2.6-mm.orig/kernel/time/ntp.c
> +++ linux-2.6-mm/kernel/time/ntp.c
> @@ -35,6 +35,7 @@ static u64 tick_length, tick_length_base
>  /* TIME_ERROR prevents overwriting the CMOS clock */
>  static int time_state = TIME_OK;	/* clock synchronization status	*/
>  int time_status = STA_UNSYNC;		/* clock status bits		*/
> +static long time_tai;			/* TAI offset (s)		*/

I think timekeeping.c would be the better place for time_tai, keeping it
closer to xtime and wall_to_monotonic's definitions.


>  static s64 time_offset;			/* time adjustment (ns)		*/
>  static long time_constant = 2;		/* pll time constant		*/
>  long time_maxerror = NTP_PHASE_LIMIT;	/* maximum error (us)		*/
> @@ -162,6 +163,7 @@ void second_overflow(void)
>  	case TIME_DEL:
>  		if ((xtime.tv_sec + 1) % 86400 == 0) {
>  			xtime.tv_sec++;
> +			time_tai--;
>  			wall_to_monotonic.tv_sec--;
>  			time_state = TIME_WAIT;
>  			printk(KERN_NOTICE "Clock: deleting leap second "
> @@ -169,6 +171,7 @@ void second_overflow(void)
>  		}
>  		break;
>  	case TIME_OOP:
> +		time_tai++;
>  		time_state = TIME_WAIT;
>  		break;
>  	case TIME_WAIT:


These manipulations could also be done in the
timekeeping_insert/remove_second interface I suggested earlier.


> @@ -340,6 +343,9 @@ int do_adjtimex(struct timex *txc)
>  			time_constant = max(time_constant, 0l);
>  		}
> 
> +		if (txc->modes & ADJ_TAI && txc->constant > 0)
> +			time_tai = txc->constant;
> +
>  		if (txc->modes & ADJ_OFFSET) {
>  			if (txc->modes == ADJ_OFFSET_SINGLESHOT)
>  				/* adjtime() is independent from ntp_adjtime() */
> @@ -375,6 +381,7 @@ int do_adjtimex(struct timex *txc)
>  	txc->precision	   = 1;
>  	txc->tolerance	   = MAXFREQ_SCALED / PPM_SCALE;
>  	txc->tick	   = tick_usec;
> +	txc->tai	   = time_tai;
> 
>  	/* PPS is not implemented, so these are zero */
>  	txc->ppsfreq	   = 0;
> 

