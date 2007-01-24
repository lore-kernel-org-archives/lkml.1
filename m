Return-Path: <linux-kernel-owner+w=401wt.eu-S965609AbXAXCAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965609AbXAXCAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 21:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965611AbXAXCAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 21:00:51 -0500
Received: from av2.karneval.cz ([81.27.192.122]:13730 "EHLO av2.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965609AbXAXCAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 21:00:51 -0500
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH query] arm: i.MX/MX1 clock event source
Date: Wed, 24 Jan 2007 03:00:26 +0100
User-Agent: KMail/1.9.4
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Sascha Hauer <s.hauer@pengutronix.de>
References: <200701210101.27345.pisa@cmp.felk.cvut.cz> <20070122195924.GD21277@elte.hu> <200701230352.57380.pisa@cmp.felk.cvut.cz>
In-Reply-To: <200701230352.57380.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701240300.27497.pisa@cmp.felk.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 January 2007 03:52, Pavel Pisa wrote:
> > i've added your patch to -rt, but note that there's a new, slightly
> > incompatible clockevents code in -rt now so you'll need to do some more
> > (hopefully trivial) fixups for this to build and work.
> >
> > 	Ingo
>
> Hello Ingo,
>
> Unfortunately, even with these corrections boot stuck at
>
> Memory: 18972KB available (2488K code, 358K data, 92K init)
>
> I have not time now to start JTAG debugging session, so I look at that
> tomorrow or on Friday.
>
> It seems, that the interrupts are not coming from device.
>
> Best wishes
>
>             Pavel
>

Hello Ingo,

I have found some time and tried to debugg problem with
help of JTAG debugger. But I have found, that IRQs
are processed right. The plain rc5 runs flawlessly.
The rt8 doesnot start. The problem is, that handler
stays NULL after clock event registration. Interrupts
runs, but my code doesnot call any function. The notification
chain and clock events list seems to be filled correctly.
I have added 

        clockevent_imx.cpumask = cpumask_of_cpu(0);

to ensure that clock are not used for affinity
mask reasons. I have tried even exchange clock 
event forcibly at the end of clockevent_imx initialization.
But it only resulted in asking timer to switch off
into unused mode.

I have added next hack into IRQ
                                write_seqlock(&xtime_lock);
                                timer_tick();
                                write_sequnlock(&xtime_lock);
which stays enabled until imx_set_mode() is called first time,
The system boots after this modification, but imx_set_mode()
is never called and there is no switch to high resolution mode.

CONFIG_ARM=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CLOCKEVENTS=y
??? CONFIG_TICK_ONESHOT=y ???
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_PREEMPT_RT=y
CONFIG_PREEMPT=y
CONFIG_PREEMPT_SOFTIRQS=y
CONFIG_PREEMPT_HARDIRQS=y
CONFIG_PREEMPT_BKL=y

Could I preset some handler directly during timer initialization?
Can I declare somehow, that I want to use that clock event device
as source of tick from beginning? Should I try to rebuild with CONFIG_NO_HZ=n?
I would like to keep up with changes, because I have tested
RTs for ARM already over more "stable" releases and over many rc-s.
And high resolution timers support has worked well over for me last
three months (up to 2.6.20-rc4). So I want to learn what is required
to be compatible with latest code.

Thanks for any hints to the problem

                     Pavel


