Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYH0JYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYH0JYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYH0JYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:24:39 -0400
Received: from www.tglx.de ([62.245.132.106]:39175 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbYH0JYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:24:38 -0400
Date: Wed, 27 Aug 2008 11:24:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kevin Hao <haokexin@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Re: [x86] apic timer tick interval is not so accurate in periodic
 mode
In-Reply-To: <8dd980de0808200236g1c77f4e6n1e97339fb3c27e6@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808271103180.3243@apollo.tec.linutronix.de>
References: <8dd980de0808200236g1c77f4e6n1e97339fb3c27e6@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008, Kevin Hao wrote:
> Hi all,
> 
> I found the apic timer tick interval is not so accurate when it works
> in periodic mode(CONFIG_HIGH_RES_TIMERS=N).
> But in one-shot mode(CONFIG_HIGH_RES_TIMERS=Y)  it works well.
> I tested it on a Dell390 pc. HZ is 250. Kernel version is 2.6.27-rc3.
> The following is the result:
> 
> In periodic mode:
> tick = 1, apic tick timer interval is 4020211
> tick = 1, apic tick timer interval is 4020233
> tick = 1, apic tick timer interval is 4020233
> tick = 1, apic tick timer interval is 4020199
> tick = 1, apic tick timer interval is 4020267
> tick = 1, apic tick timer interval is 4020218
> tick = 1, apic tick timer interval is 4020278
> tick = 1, apic tick timer interval is 4020173
> 
> 
> In one-shot mode:
> tick = 1, apic tick timer interval is 3999930
> tick = 1, apic tick timer interval is 4000035
> tick = 1, apic tick timer interval is 3999998
> tick = 1, apic tick timer interval is 4000005
> tick = 1, apic tick timer interval is 4000001
> tick = 1, apic tick timer interval is 4000009
> tick = 1, apic tick timer interval is 3999945
> tick = 1, apic tick timer interval is 4000024
> tick = 1, apic tick timer interval is 4000005
> 
> Why is there so big difference between these two mode?
> The attachment is my test program and config file.
> Any comments is appreciated .

The periodic mode uses a reload value which is calculated during
system startup and never touched again. At this point we do not have
the full timekeeping infrastructure working and your test code uses
the working infrastructure as reference.

In high resolution timer mode we reprogramm the local apic timer for
the next hrtimer instance which is enqueued. We calculate the delta
against the system time and then convert it to the local apic counter
value. 

But yes, it's surprising that the obvious calibration deviation of the
local apic timer, which results in longer times is not showing up in
one shot mode. It would be interesting to see the absolute time line
in terms of ktime_get() of those events versus the expiry value of the
hrtimer which drives the tick emulation in tick_sched_timer().

Thanks,

	tglx
