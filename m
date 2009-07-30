Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbZG3WPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbZG3WPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 18:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbZG3WPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 18:15:31 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55232 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZG3WPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 18:15:30 -0400
Subject: Re: [RFC][patch 09/12] add xtime_shift and ntp_error_shift to
 struct timekeeper
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>
In-Reply-To: <20090729134231.269077552@de.ibm.com>
References: <20090729134125.313191633@de.ibm.com>
	 <20090729134231.269077552@de.ibm.com>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 15:15:23 -0700
Message-Id: <1248992123.3374.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 15:41 +0200, Martin Schwidefsky wrote:
> plain text document attachment (timekeeper-shift.diff)
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> The xtime_nsec value in the timekeeper structure is shifted by a few
> bits to improve precision. This happens to be the same value as the
> clock->shift. To improve readability add xtime_shift to the timekeeper
> and use it instead of the clock->shift. Likewise add ntp_error_shift
> and replace all (NTP_SCALE_SHIFT - clock->shift) expressions.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: john stultz <johnstul@us.ibm.com>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  kernel/time/timekeeping.c |   33 ++++++++++++++++++---------------
>  1 file changed, 18 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6/kernel/time/timekeeping.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/timekeeping.c
> +++ linux-2.6/kernel/time/timekeeping.c
> @@ -27,6 +27,8 @@ struct timekeeper {
>  	u32	raw_interval;
>  	u64	xtime_nsec;
>  	s64	ntp_error;
> +	int	xtime_shift;
> +	int	ntp_error_shift;
>  };

I suspect ntp_error_shift is one of the lease intuitive values in the
timekeeper structure. They all probably need nice comments explaining
what they store, but especially this one. 

Something like:

struct clocksource *clock; /* current clocksource used for timekeeping*/
cycle_t cycle_interval;	   /* fixed chunk of cycles used in accumulation */
u64     xtime_interval;    /* number clock shifted nsecs accumulated per cycle_interval */
u32	raw_interval;      /* raw nsecs accumulated per cycle_interval */
u64	xtime_nsec;        /* clock shifted nsecs remainder not stored in xtime.tv_nsec */
s64	ntp_error;         /* Difference between accumulated time and NTP time in ntp shifted nsecs */
int	xtime_shift;       /* The shift value of the current clocksource */
int	ntp_error_shift;   /* Shift conversion between clock shifted nsecs and ntp shifted nsecs */


Other then that this patch looks ok, but will need rigorous testing, as
its very complicated and difficult to understand code thats being
changed.

thanks
-john


