Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbXLCISA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbXLCISA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 03:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXLCIRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 03:17:51 -0500
Received: from www.tglx.de ([62.245.132.106]:55306 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbXLCIRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 03:17:50 -0500
From: Thomas Gleixner <tglx@www.tglx.de>
Message-ID: <23803.203.197.163.97.1196669842.squirrel@www.tglx.de>
In-Reply-To: <20071201212054.2377c8be@poseidon.drzeus.cx>
References: <20071201154223.1b052d39@poseidon.drzeus.cx>
    <20071201184752.33536d09@poseidon.drzeus.cx>
    <20071201212054.2377c8be@poseidon.drzeus.cx>
Date: Mon, 3 Dec 2007 09:17:22 +0100 (CET)
Subject: Re: Fedora's latest gcc produces unbootable kernels
To: "Pierre Ossman" <drzeus-list@drzeus.cx>
Cc: "Pierre Ossman" <drzeus-list@drzeus.cx>,
       "LKML" <linux-kernel@vger.kernel.org>, jakub@redhat.com,
       "Thomas Gleixner" <tglx@linutronix.de>
User-Agent: SquirrelMail/1.4.8-4.0.1..el5.centos.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 1 Dec 2007 18:47:52 +0100
> Pierre Ossman <drzeus-list@drzeus.cx> wrote:
>> > The latest GCC in Fedora rawhide contains some serious bug (or
>> provokes a latent one in the kernel) that makes every kernel built
>> unbootable. It just locks up halfway through the init. Kernels that
>> previously worked fine all now experience the same symptom. Even RH's
>> own kernels exhibit this. The kernel built Nov 24th works, Nov 26th
>> doesn't. gcc was updated 26th, 14 hours earlier.
>> >
>>
>> Digging a bit further, it is indeed the high-res stuff (the first
>> missing message) that hangs. If I hard code the kernel to just be
>> non-high-res capable, it boots, but time keeping is horribly broken.
>>
>> Anyway, hopefully this means I'll soon have the object file that gets
>> miscompiled. Jakub also pointed me to an older gcc RPM so that I can
>> produce an object file with that as well and see what differs.
>>
>
> I've now pinpointed where it hangs. And it doesn't hang in fact. It gets
> stuck in an infinite loop in tick_setup_sched_timer():
>
> 	for (;;) {
> 		hrtimer_forward(&ts->sched_timer, now, tick_period);
> 		hrtimer_start(&ts->sched_timer, ts->sched_timer.expires,
> 			      HRTIMER_MODE_ABS);
> 		/* Check, if the timer was already in the past */
> 		if (hrtimer_active(&ts->sched_timer))
> 			break;
> 		now = ktime_get();
> 	}
>
> I've added Thomas as cc as this is his domain, so perhaps he has some idea
> what the compiler does wrong here. I've also included the two object files
> (one good, one bad). HEAD is v2.6.24-rc3.

I looked at the disassembly but I can not spot the problem.

I think the real problem is somewhere else. Likely candidates are
hrtimer_forward() or hrtimer_start() - in that order.

Thanks,

      tglx

P.S.: I have restricted network access today, so I can not reproduce my self.

