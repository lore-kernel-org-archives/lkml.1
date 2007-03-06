Return-Path: <linux-kernel-owner+w=401wt.eu-S1030573AbXCFNZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030573AbXCFNZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030567AbXCFNZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:25:12 -0500
Received: from mail22.syd.optusnet.com.au ([211.29.133.160]:35797 "EHLO
	mail22.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030573AbXCFNZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:25:10 -0500
From: Con Kolivas <kernel@kolivas.org>
To: tglx@linutronix.de
Subject: Re: 2.6.21-rc2-mm2
Date: Wed, 7 Mar 2007 00:24:51 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org> <200703062258.19940.kernel@kolivas.org> <1173185537.24738.323.camel@localhost.localdomain>
In-Reply-To: <1173185537.24738.323.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703070024.51273.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2007 23:52, Thomas Gleixner wrote:
> On Tue, 2007-03-06 at 22:58 +1100, Con Kolivas wrote:
> > (tglx cc'ed as he may know something about this - sorry if it's
> > inappropriate)
>
> John cc'ed as well :)

Thanks.

> >  [<ffffffff8018401c>] do_timer+0x301/0x419

> > ---
> >
> > list *do_timer+0x301
> > 0xffffffff8018401c is in do_timer
> > (/home/con/kernel/linux-2.6.21-rc2-mm2/include/linux/clocksource.h:186).
> > 181             u64 tmp;
> > 182
> > 183             /* XXX - All of this could use a whole lot of
> > optimization */ 184             tmp = length_nsec;
> > 185             tmp <<= c->shift;
> > 186             tmp += c->mult/2;
> > 187             do_div(tmp, c->mult);
> > 188
> > 189             c->cycle_interval = (cycle_t)tmp;
> > 190             if (c->cycle_interval == 0)
>
> That's extremly strange. This is inside of
> clocksource_calculate_interval() in:
>
> static void change_clocksource(void)
> {
>         struct clocksource *new;
>         cycle_t now;
>         u64 nsec;
>
>         new = clocksource_get_next();
>
>         if (clock == new)
>                 return;
>
>         now = clocksource_read(new);
>         nsec =  __get_nsec_offset();
>         timespec_add_ns(&xtime, nsec);
>
>         clock = new;
>         clock->cycle_last = now;
>
>         clock->error = 0;
>         clock->xtime_nsec = 0;
> 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
>
>         tick_clock_notify();
>
>         printk(KERN_INFO "Time: %s clocksource has been installed.\n",
>                clock->name);
> }
>
> So clock seems to be NULL, but was accessed before
> clocksource_calculate_interval() as well.

It seems to be specifically tripping at c->mult after reading c->shift if I'm 
reading it correctly.

Note again, this is qemu, not real hardware and it will likely be giving very 
unrealistic values for timer calibrations.

-- 
-ck
