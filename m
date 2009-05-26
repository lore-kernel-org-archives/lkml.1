Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbZEZP0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbZEZP0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbZEZPZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:25:57 -0400
Received: from co203.xi-lite.net ([149.6.83.203]:53686 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821AbZEZPZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:25:56 -0400
X-Greylist: delayed 1378 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 May 2009 11:25:56 EDT
Message-ID: <4A1C04A2.80404@parrot.com>
Date: Tue, 26 May 2009 17:02:58 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
CC: Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback
 	sched_clock().
References: <20090526061532.GD9188@linux-sh.org> <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>
In-Reply-To: <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij a écrit :
> 2009/5/26 Paul Mundt <lethal@linux-sh.org>:
> 
>>  */
>>  unsigned long long __attribute__((weak)) sched_clock(void)
>>  {
>> +       /*
>> +        * Use the current clocksource when it becomes available later in
>> +        * the boot process, and ensure that it has a high enough rating
>> +        * to make it suitable for general use.
>> +        */
>> +       if (clock && clock->rating >= 100)
>> +               return cyc2ns(clock, clocksource_read(clock));
>> +
>> +       /* Otherwise just fall back on jiffies */
>>        return (unsigned long long)(jiffies - INITIAL_JIFFIES)
>>                                        * (NSEC_PER_SEC / HZ);
>>  }
This is buggy for fast clocksource that wrap often, because sched_clock
is not supposed to wrap.
That why custom implementation use cnt32_to_63 and a smaller shift
(around 8 -10) for conversion for timer unit to ns.

Look for example to arch/arm/mach-pxa/time.c implementation [1]

But we can image you make it generic.

Matthieu

[1]
/*
 * This is PXA's sched_clock implementation. This has a resolution
 * of at least 308 ns and a maximum value of 208 days.
 *
 * The return value is guaranteed to be monotonic in that range as
 * long as there is always less than 582 seconds between successive
 * calls to sched_clock() which should always be the case in practice.
 */
#define OSCR2NS_SCALE_FACTOR 10

static unsigned long oscr2ns_scale;

static void __init set_oscr2ns_scale(unsigned long oscr_rate)
{
    unsigned long long v = 1000000000ULL << OSCR2NS_SCALE_FACTOR;
    do_div(v, oscr_rate);
    oscr2ns_scale = v;
    /*
     * We want an even value to automatically clear the top bit
     * returned by cnt32_to_63() without an additional run time
     * instruction. So if the LSB is 1 then round it up.
     */
    if (oscr2ns_scale & 1)
        oscr2ns_scale++;
}

unsigned long long sched_clock(void)
{
    unsigned long long v = cnt32_to_63(OSCR);
    return (v * oscr2ns_scale) >> OSCR2NS_SCALE_FACTOR;
}
