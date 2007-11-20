Return-Path: <linux-kernel-owner+w=401wt.eu-S1763248AbXKTSnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763248AbXKTSnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759415AbXKTSml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:42:41 -0500
Received: from rtr.ca ([76.10.145.34]:4137 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757224AbXKTSmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:42:40 -0500
Message-ID: <47432A9E.6030608@rtr.ca>
Date: Tue, 20 Nov 2007 13:42:38 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
References: <47425EA5.7000607@rtr.ca>	<200711201517.16171.nickpiggin@yahoo.com.au>	<20071119213727.16d5917b@laptopd505.fenrus.org>	<200711201837.39664.nickpiggin@yahoo.com.au>	<20071120064747.2a8036cd@laptopd505.fenrus.org>	<4743018C.1000307@rtr.ca>	<474302D0.9000509@rtr.ca> <20071120080243.22725fb3@laptopd505.fenrus.org>
In-Reply-To: <20071120080243.22725fb3@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(resending this one to the list).

Arjan van de Ven wrote:
> On Tue, 20 Nov 2007 10:47:24 -0500
> Mark Lord <lkml@rtr.ca> wrote:
..
>> After reading some of the replies, I installed it on my
>> malfunctioning 64-bit system, but discovered it does not perform
>> nearly as well as the kernel solution in the 32-bit system does.
>
> can you send me the output you get from running irqbalance with the
> --debug option? That'll show me what decisions it made and why
..

The next time I'm using that system for large I/O I will try and do so.
But the shortcomings seem rather obvious already (more below).

>> Much of this could be due to a slow response curve in the userspace
>> balancer (?), but I have not yet examined it for such bugs.
>> Hopefully it also is clever enough to mlock() itself, and to run at a
>> low RT priority ? 
>
> there's no need for either of those two.
..

But there is!  If it is not in-memory, then it needs IRQs to be paged-in
before it can redistribute any IRQs.  And when the situation is bad,
the page-in device is one that can be suffering from poor response.
Which just makes the system stutter even more.

>> It really does need to respond *quickly* to changes in IRQ load,
>> as otherwise I see dropouts on sound playback (let along video..) and
>> the like.
>
> the problem is, you cannot respond quickly like that without
> sacrificing huge heaps of performance, especially on networking.
..

You are more expert on that aspect than I am.
But surely networking can be taken into account when
distributing other IRQs dynamically ?

>> The vast majority of Linux machines are "single package", and this
>> software appears to be designed more for multi package, 
>
> it's not. It just right now makes the assumption that on single package
> it can do a good enough job with a static balancing.
> Maybe you've found a case that proves that assumption wrong.
..

I think perhaps the existing algorithm makes the assumptions of
a static configuration of IRQ generating devices, and an unchanging
IRQ average frequency among them.

Neither assumption is valid in a hotplug environment, and the second
assumption is certainly not true on most of my machines.

The lone 64-bit desktop configuration I have here is the only one without
in-kernel IRQ distribution, and it has the fastest (2.5GHz) clock speed,
the largest number (4) of CPU cores, and the most memory (4GB)
of any of the machines here.

And yet it really felt "jerky" in use when copying data around last night,
even after installing/running the userspace irqbalance daemon.

I eventually just moved the work over to a slower machine with a 32-bit
kernel (notebook, 2.1GHz, two cores, 3GB), and things finished more rapidly
and with no noticeable mal effects on the GUI at the time.

The workload in all cases here was plugging in 2GB USB sticks,
and copying a 2GB image to them, and the unplugging/replugging them
and running md5sum to verify correct data transfers.

I had a lot of them (14) to do, and so generally two or three sticks
were plugged in and in use at any given time.

A last note on the quad-core, is that irqbalance *never* used
more than two cores.  Dunno why not.

Cheers


