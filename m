Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0CFWkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 17:40:36 -0500
Received: from mail.gmx.net ([213.165.64.20]:56519 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751723Ab0CFWkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 17:40:35 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX184oJdyP7M4UIi6g3mII80yAJjnTAqKa83HfmIhN8
	OxuXhg0TNgvPM0
Message-ID: <4B92D9DE.7030705@gmx.de>
Date: Sat, 06 Mar 2010 23:40:30 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 04/14] parisc: Convert parisc to use read/update_persistent_clock
References: <1267675049-12337-1-git-send-email-johnstul@us.ibm.com> <1267675049-12337-2-git-send-email-johnstul@us.ibm.com> <1267675049-12337-3-git-send-email-johnstul@us.ibm.com> <1267675049-12337-4-git-send-email-johnstul@us.ibm.com> <1267675049-12337-5-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1267675049-12337-5-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 04:57 AM, John Stultz wrote:
> This patch converts the parisc architecture to use the generic read_persistent_clock and update_persistent_clock interfaces, reducing the amount of arch specific code we have to maintain, and allowing for further cleanups in the future.
>
> I have not built or tested this patch, so help from arch maintainers would be appreciated.

Works nicely.

Thanks, John.

Acked-by: Helge Deller <deller@gmx.de>

>
> Cc: Kyle McMartin<kyle@mcmartin.ca>
> Cc: Helge Deller<deller@gmx.de>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: Andrew Morton<akpm@linux-foundation.org>
>
> Signed-off-by: John Stultz<johnstul@us.ibm.com>
> ---
>   arch/parisc/kernel/time.c |   29 +++++++++++++----------------
>   1 files changed, 13 insertions(+), 16 deletions(-)
>
> diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
> index a79c6f9..05511cc 100644
> --- a/arch/parisc/kernel/time.c
> +++ b/arch/parisc/kernel/time.c
> @@ -250,9 +250,21 @@ static int __init rtc_init(void)
>   }
>   module_init(rtc_init);
>
> -void __init time_init(void)
> +void read_persistent_clock(struct timespec *ts)
>   {
>   	static struct pdc_tod tod_data;
> +	if (pdc_tod_read(&tod_data) == 0) {
> +		ts->tv_sec = tod_data.tod_sec;
> +		ts->tv_nsec = tod_data.tod_usec * 1000;
> +	} else {
> +		printk(KERN_ERR "Error reading tod clock\n");
> +	        ts->tv_sec = 0;
> +		ts->tv_nsec = 0;
> +	}
> +}
> +
> +void __init time_init(void)
> +{
>   	unsigned long current_cr16_khz;
>
>   	clocktick = (100 * PAGE0->mem_10msec) / HZ;
> @@ -264,19 +276,4 @@ void __init time_init(void)
>   	clocksource_cr16.mult = clocksource_khz2mult(current_cr16_khz,
>   						clocksource_cr16.shift);
>   	clocksource_register(&clocksource_cr16);
> -
> -	if (pdc_tod_read(&tod_data) == 0) {
> -		unsigned long flags;
> -
> -		write_seqlock_irqsave(&xtime_lock, flags);
> -		xtime.tv_sec = tod_data.tod_sec;
> -		xtime.tv_nsec = tod_data.tod_usec * 1000;
> -		set_normalized_timespec(&wall_to_monotonic,
> -		                        -xtime.tv_sec, -xtime.tv_nsec);
> -		write_sequnlock_irqrestore(&xtime_lock, flags);
> -	} else {
> -		printk(KERN_ERR "Error reading tod clock\n");
> -	        xtime.tv_sec = 0;
> -		xtime.tv_nsec = 0;
> -	}
>   }

