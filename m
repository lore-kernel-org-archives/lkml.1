Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab0CAIT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:19:58 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:45179 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab0CAIT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:19:56 -0500
Date: Mon, 1 Mar 2010 09:19:48 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Message-ID: <20100301081948.GI3671@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
	john stultz <johnstul@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
 <0f803a7b9dfbe3dc5024afab7c2c4ca2c839b98e.1267008049.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f803a7b9dfbe3dc5024afab7c2c4ca2c839b98e.1267008049.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv2 3/6] pps: capture MONOTONIC_RAW timestamps as well
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 03:28:14PM +0300, Alexander Gordeev wrote:
> MONOTONIC_RAW clock timestamps are ideally suited for frequency
> calculation and also fit well into the original NTP hardpps design. Now
> phase and frequency can be adjusted separately: the former based on
> REALTIME clock and the latter based on MONOTONIC_RAW clock.
> A new function getnstime_raw_and_real is added to timekeeping subsystem
> to capture both timestamps at the same time and atomically.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Acked-by: Rodolfo Giometti <giometti@linux.it>

> ---
>  include/linux/pps_kernel.h |    3 ++-
>  include/linux/time.h       |    2 ++
>  kernel/time/timekeeping.c  |   34 ++++++++++++++++++++++++++++++++++
>  3 files changed, 38 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
> index a2804c1..9bda892 100644
> --- a/include/linux/pps_kernel.h
> +++ b/include/linux/pps_kernel.h
> @@ -41,6 +41,7 @@ struct pps_source_info {
>  };
>  
>  struct pps_event_time {
> +	struct timespec ts_raw;
>  	struct pps_ktime ts_real;
>  };
>  
> @@ -104,7 +105,7 @@ static inline void pps_get_ts(struct pps_event_time *ts)
>  {
>  	struct timespec ts_real;
>  
> -	getnstimeofday(&ts_real);
> +	getnstime_raw_and_real(&ts->ts_raw, &ts_real);
>  	timespec_to_pps_ktime(&ts->ts_real, ts_real);
>  }
>  
> diff --git a/include/linux/time.h b/include/linux/time.h
> index 6e026e4..edf7eb7 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -143,6 +143,8 @@ extern unsigned int alarm_setitimer(unsigned int seconds);
>  extern int do_getitimer(int which, struct itimerval *value);
>  extern void getnstimeofday(struct timespec *tv);
>  extern void getrawmonotonic(struct timespec *ts);
> +extern void getnstime_raw_and_real(struct timespec *ts_raw,
> +		struct timespec *ts_real);
>  extern void getboottime(struct timespec *ts);
>  extern void monotonic_to_bootbased(struct timespec *ts);
>  
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 8b709de..0ca8336 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -293,6 +293,40 @@ void ktime_get_ts(struct timespec *ts)
>  EXPORT_SYMBOL_GPL(ktime_get_ts);
>  
>  /**
> + * getnstime_raw_and_real - Returns both the time of day an raw
> + * monotonic time in a timespec format
> + * @ts_mono_raw:	pointer to the timespec to be set to raw
> + * 			monotonic time
> + * @ts_real:		pointer to the timespec to be set to the time
> + * 			of day
> + */
> +void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
> +{
> +	unsigned long seq;
> +	s64 nsecs_raw, nsecs_real;
> +
> +	WARN_ON(timekeeping_suspended);
> +
> +	do {
> +		seq = read_seqbegin(&xtime_lock);
> +
> +		*ts_raw = raw_time;
> +		*ts_real = xtime;
> +
> +		nsecs_raw = timekeeping_get_ns_raw();
> +		nsecs_real = timekeeping_get_ns();
> +
> +		/* If arch requires, add in gettimeoffset() */
> +		nsecs_real += arch_gettimeoffset();
> +
> +	} while (read_seqretry(&xtime_lock, seq));
> +
> +	timespec_add_ns(ts_raw, nsecs_raw);
> +	timespec_add_ns(ts_real, nsecs_real);
> +}
> +EXPORT_SYMBOL(getnstime_raw_and_real);
> +
> +/**
>   * do_gettimeofday - Returns the time of day in a timeval
>   * @tv:		pointer to the timeval to be set
>   *
> -- 
> 1.6.6.1
> 

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
