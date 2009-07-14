Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZGNWLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZGNWLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 18:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbZGNWLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 18:11:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756000AbZGNWLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 18:11:10 -0400
Date: Tue, 14 Jul 2009 15:10:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hirofumi@mail.parknet.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add function to convert between calendar time and
 broken-down time for universal use
Message-Id: <20090714151040.b7b3b26d.akpm@linux-foundation.org>
In-Reply-To: <4A5C3BC0.6020701@cn.fujitsu.com>
References: <4A5C3BC0.6020701@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009 16:03:12 +0800
Zhaolei <zhaolei@cn.fujitsu.com> wrote:

> There are many similar code in kernel for one object:
> convert time between calendar time and broken-down time.
> 
> Here is some source I found:
> fs/ncpfs/dir.c
> fs/smbfs/proc.c
> fs/fat/misc.c
> fs/udf/udftime.c
> fs/cifs/netmisc.c
> net/netfilter/xt_time.c
> drivers/scsi/ips.c
> drivers/input/misc/hp_sdc_rtc.c
> drivers/rtc/rtc-lib.c
> arch/ia64/hp/sim/boot/fw-emu.c
> arch/m68k/mac/misc.c
> arch/powerpc/kernel/time.c
> arch/parisc/include/asm/rtc.h
> ...
> 
> We can make a common function for this type of conversion,
> At least we can get following benefit:
> 1: Make kernel simple and unify
> 2: Easy to fix bug in converting code
> 3: Reduce clone of code in future
>    For example, I'm trying to make ftrace display walltime,
>    this patch will make me easy.
> 

The objective is a good one.  Have you verified that these new library
functions can be used by most/all of the above callers?

> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  include/linux/time.h   |    9 +++
>  kernel/time/Makefile   |    2 +-
>  kernel/time/timeconv.c |  180 
> ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 190 insertions(+), 1 deletions(-)
>  create mode 100644 kernel/time/timeconv.c
> 
> diff --git a/include/linux/time.h b/include/linux/time.h
> index ea16c1a..0ae0e6e 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -151,6 +151,15 @@ extern void update_xtime_cache(u64 nsec);
>  struct tms;
>  extern void do_sys_times(struct tms *);
>  
> +extern void gmtime(__kernel_time_t totalsecs,
> +        unsigned int *year, unsigned int *mon, unsigned int *mday,
> +        unsigned int *hour, unsigned int *min, unsigned int *sec,
> +        unsigned int *wday, unsigned int *yday);
> +extern void localtime(__kernel_time_t totalsecs,
> +        unsigned int *year, unsigned int *mon, unsigned int *mday,
> +        unsigned int *hour, unsigned int *min, unsigned int *sec,
> +        unsigned int *wday, unsigned int *yday);

I'd imagine that many callers would at least need some types changed -
replace `int' with `unsigned int', etc.  Not a big problem.

>  /**
>   * timespec_to_ns - Convert timespec to nanoseconds
>   * @ts:        pointer to the timespec variable to be converted
> diff --git a/kernel/time/Makefile b/kernel/time/Makefile
> index 0b0a636..ee26662 100644
> --- a/kernel/time/Makefile
> +++ b/kernel/time/Makefile
> @@ -1,4 +1,4 @@
> -obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o 
> timecompare.o
> +obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o 
> timecompare.o timeconv.o
>  
>  obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)        += clockevents.o
>  obj-$(CONFIG_GENERIC_CLOCKEVENTS)        += tick-common.o
> diff --git a/kernel/time/timeconv.c b/kernel/time/timeconv.c
> new file mode 100644
> index 0000000..c710605
> --- /dev/null
> +++ b/kernel/time/timeconv.c
> @@ -0,0 +1,180 @@
> +/*
> + * Copyright (C) 1993, 1994, 1995, 1996, 1997 Free Software Foundation, 
> Inc.

The patch is significantly wordwrapped by your email client.

The patch has no tabs in it at all - either some serious cleanup is
needed of your email client is performing tab-to-space conversion.

> + * This file is part of the GNU C Library.
> + * Contributed by Paul Eggert (eggert@twinsun.com).
> + *
> + * The GNU C Library is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU Library General Public License as
> + * published by the Free Software Foundation; either version 2 of the
> + * License, or (at your option) any later version.
> + *
> + * The GNU C Library is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * Library General Public License for more details.
> + *
> + * You should have received a copy of the GNU Library General Public
> + * License along with the GNU C Library; see the file COPYING.LIB.  If not,
> + * write to the Free Software Foundation, Inc., 59 Temple Place - Suite 
> 330,
> + * Boston, MA 02111-1307, USA.
> + */
> +
> +/*
> + * Converts the calendar time to broken-down time representation
> + * Based on code from glibc-2.6
> + *
> + * 2009-7-14:
> + *   Moved from glibc-2.6 to kernel by Zhaolei<zhaolei@cn.fujitsu.com>
> + */
> +
> +#include <linux/time.h>
> +#include <linux/module.h>
> +
> +/*
> + * Nonzero if YEAR is a leap year (every 4 years,
> + * except every 100th isn't, and every 400th is).
> + */
> +static inline int __isleap(unsigned int year)
> +{
> +    return (year) % 4 == 0 && ((year) % 100 != 0 || (year) % 400 == 0);
> +}

The explicit `inline' probably isn't beneficial here.

> +/* How many days come before each month (0-12). */
> +static const unsigned short __mon_yday[2][13] =
> +  {
> +    /* Normal years. */
> +    {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365},
> +    /* Leap years. */
> +    {0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366}
> +  };
> +
> +#define SECS_PER_HOUR    (60 * 60)
> +#define SECS_PER_DAY    (SECS_PER_HOUR * 24)

I wonder if these whould be in a header.  I guess not, if there aren't
any sites which can use this.

> +static void __offtime(__kernel_time_t totalsecs, int offset,
> +         unsigned int *year, unsigned int *mon, unsigned int *mday,
> +         unsigned int *hour, unsigned int *min, unsigned int *sec,
> +         unsigned int *wday, unsigned int *yday)
> +{
> +    long days, rem, y;
> +    const unsigned short *ip;
> +
> +    days = totalsecs / SECS_PER_DAY;
> +    rem = totalsecs % SECS_PER_DAY;
> +    rem += offset;
> +    while (rem < 0) {
> +        rem += SECS_PER_DAY;
> +        --days;
> +    }
> +    while (rem >= SECS_PER_DAY) {
> +        rem -= SECS_PER_DAY;
> +        ++days;
> +    }
> +
> +    if (hour)
> +        *hour = rem / SECS_PER_HOUR;
> +    rem %= SECS_PER_HOUR;
> +    if (min)
> +        *min = rem / 60;
> +    if (sec)
> +        *sec = rem % 60;
> +
> +    if (wday) {
> +        /* January 1, 1970 was a Thursday. */
> +        *wday = (4 + days) % 7;
> +        if (*wday < 0)
> +            *wday += 7;
> +    }

The code should all be converted to standard kernel style, please. 
Mainly the use of hard tabs.


> +    y = 1970;
> +
> +#define DIV(a, b) ((a) / (b) - ((a) % (b) < 0))

hm, I wonder what that does.

It would be clearer to convert this into a regular C function, along
with a comment whcih explains what it does.

> +#define LEAPS_THRU_END_OF(y) (DIV(y, 4) - DIV(y, 100) + DIV(y, 400))

Ditto.

> +    while (days < 0 || days >= (__isleap(y) ? 366 : 365)) {
> +        /* Guess a corrected year, assuming 365 days per year. */
> +        long yg = y + days / 365 - (days % 365 < 0);
> +
> +        /* Adjust DAYS and Y to match the guessed year. */
> +        days -= ((yg - y) * 365
> +             + LEAPS_THRU_END_OF(yg - 1)
> +             - LEAPS_THRU_END_OF(y - 1));
> +        y = yg;
> +    }
> +    if (year) {
> +        *year = y - 1900;
> +        if (*year != y - 1900) {
> +            /* The year cannot be represented due to overflow. */
> +            *year = -1;
> +        }
> +    }
> +
> +    if (yday)
> +        *yday = days;
> +
> +    ip = __mon_yday[__isleap(y)];
> +    for (y = 11; days < ip[y]; y--)
> +        continue;
> +    days -= ip[y];
> +    if (mon)
> +        *mon = y;
> +    if (mday)
> +        *mday = days + 1;
> +}

>
> ...
>
> +void gmtime(__kernel_time_t totalsecs,
> +         unsigned int *year, unsigned int *mon, unsigned int *mday,
> +         unsigned int *hour, unsigned int *min, unsigned int *sec,
> +         unsigned int *wday, unsigned int *yday)
> +{
> +    __offtime(totalsecs, 0, year, mon, mday, hour, min, sec, wday, yday);
> +}
> +EXPORT_SYMBOL(gmtime);
>
> ...
>
> +void localtime(__kernel_time_t totalsecs,
> +         unsigned int *year, unsigned int *mon, unsigned int *mday,
> +         unsigned int *hour, unsigned int *min, unsigned int *sec,
> +         unsigned int *wday, unsigned int *yday)
> +{
> +    __offtime(totalsecs, -sys_tz.tz_minuteswest * 60, year, mon, mday, 
> hour,
> +        min, sec, wday, yday);
> +}
> +EXPORT_SYMBOL(localtime);

These are such simple wrappers around __offtime() that it might be
better to make them static inlines in time.h, so callers will end up
directly calling __offtime() rather than having to remarshal ten
function arguments.

