Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbZGRKDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbZGRKDi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 06:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZGRKDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 06:03:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36667 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbZGRKDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 06:03:35 -0400
Date: Sat, 18 Jul 2009 12:02:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zhaolei <zhaolei@cn.fujitsu.com>, Ulrich Drepper <drepper@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add function to convert between calendar time and
	broken-down time for universal use
Message-ID: <20090718100050.GB24164@elte.hu>
References: <4A5C3BC0.6020701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5C3BC0.6020701@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhaolei <zhaolei@cn.fujitsu.com> wrote:

> --- /dev/null
> +++ b/kernel/time/timeconv.c
> @@ -0,0 +1,180 @@
> +/*
> + * Copyright (C) 1993, 1994, 1995, 1996, 1997 Free Software Foundation,  
> Inc.
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
> +
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
> +
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
> +
> +    y = 1970;
> +
> +#define DIV(a, b) ((a) / (b) - ((a) % (b) < 0))
> +#define LEAPS_THRU_END_OF(y) (DIV(y, 4) - DIV(y, 100) + DIV(y, 400))
> +
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
> +
> +/**
> + * gmtime - converts the calendar time to UTC broken-down time
> + *
> + * @totalsecs    The number of seconds elapsed since 00:00:00 on  
> January 1, 1970,
> + *        Coordinated Universal Time (UTC).
> + * @year    Store the number of years since 1900.
> + * @mon        Store the number of months since January, in the range 0  
> to 11.
> + * @mday    Store the day of the month, in the range 1 to 31.
> + * @hour    Store the number of hours past midnight, in the range 0 to 23.
> + * @min        Store the number of minutes after the hour,
> + *        in the range 0 to 59.
> + * @sec        Store the number of seconds after the minute, normally  
> in the
> + *        range 0 to 59, but can be up to 60 to allow for leap seconds.
> + * @wday    Store the number of days since Sunday, in the range 0 to 6.
> + * @yday    Store the number of days since January 1, in the range 0 to  
> 365.
> + *
> + * Similar to the gmtime() in glibc, broken-down time is expressed in
> + * Coordinated Universal Time (UTC).
> + */
> +void gmtime(__kernel_time_t totalsecs,
> +         unsigned int *year, unsigned int *mon, unsigned int *mday,
> +         unsigned int *hour, unsigned int *min, unsigned int *sec,
> +         unsigned int *wday, unsigned int *yday)
> +{
> +    __offtime(totalsecs, 0, year, mon, mday, hour, min, sec, wday, yday);
> +}
> +EXPORT_SYMBOL(gmtime);
> +
> +/**
> + * localtime - converts the calendar time to local broken-down time
> + *
> + * @totalsecs    The number of seconds elapsed since 00:00:00 on  
> January 1, 1970,
> + *        Coordinated Universal Time (UTC).
> + * @year    Store the number of years since 1900.
> + * @mon        Store the number of months since January, in the range 0  
> to 11.
> + * @mday    Store the day of the month, in the range 1 to 31.
> + * @hour    Store the number of hours past midnight, in the range 0 to 23.
> + * @min        Store the number of minutes after the hour,
> + *        in the range 0 to 59.
> + * @sec        Store the number of seconds after the minute, normally  
> in the
> + *        range 0 to 59, but can be up to 60 to allow for leap seconds.
> + * @wday    Store the number of days since Sunday, in the range 0 to 6.
> + * @yday    Store the number of days since January 1, in the range 0 to  
> 365.
> + *
> + * Similar to the localtime() in glibc, broken-down time is expressed
> + * relative to sys_tz.
> + */
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

Makes sense - but this code should be converted to the kernel coding 
style. See other code in kernel/time/*.c for examples.

I'm also wondering whether including LGPL glibc code in the kernel 
like this is license-appropriate - there seems to be few precedents 
of it. It _should_ be OK, but i've Cc:-ed involved folks just to 
make sure everyone agrees ...

Since you'll modify it anyway to match up the style, the license 
itself could be restricted to the kernel's GPLv2 subset, that's OK 
as per LGPL.

	Ingo
