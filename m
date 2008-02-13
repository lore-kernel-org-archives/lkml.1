Return-Path: <linux-kernel-owner+w=401wt.eu-S1765346AbYBMGH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765346AbYBMGH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 01:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYBMGHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 01:07:14 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:47863 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbYBMGHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 01:07:12 -0500
Message-ID: <47B288E4.2080403@qualcomm.com>
Date: Tue, 12 Feb 2008 22:06:28 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, pj@sgi.com, a.p.zijlstra@chello.nl, gregkh@suse.de,
       rusty@rustcorp.com.au
Subject: Re: [git pull for -mm] CPU isolation extensions (updated2)
References: <47B11C45.6060408@qualcomm.com> <20080211.224436.174153780.davem@davemloft.net> <47B264E3.4090605@qualcomm.com> <200802131511.28643.nickpiggin@yahoo.com.au>
In-Reply-To: <200802131511.28643.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Wednesday 13 February 2008 14:32, Max Krasnyansky wrote:
>> David Miller wrote:
>>> From: Nick Piggin <nickpiggin@yahoo.com.au>
>>> Date: Tue, 12 Feb 2008 17:41:21 +1100
>>>
>>>> stop machine is used for more than just module loading and unloading.
>>>> I don't think you can just disable it.
>>> Right, in particular it is used for CPU hotplug.
>> Ooops. Totally missed that. And a bunch of other places.
>>
>> [maxk@duo2 cpuisol-2.6.git]$ git grep -l stop_machine_run
>> Documentation/cpu-hotplug.txt
>> arch/s390/kernel/kprobes.c
>> drivers/char/hw_random/intel-rng.c
>> include/linux/stop_machine.h
>> kernel/cpu.c
>> kernel/module.c
>> kernel/stop_machine.c
>> mm/page_alloc.c
>>
>> I wonder why I did not see any issues when I disabled stop machine
>> completely. I mentioned in the other thread that I commented out the part
>> that actually halts the machine and ran it for several hours on my dual
>> core laptop and on the quad core server. Tried all kinds of workloads,
>> which include constant module removal and insertion, and cpu hotplug as
>> well. It cannot be just luck :).
> 
> It really is. With subtle races, it can take a lot more than a few
> hours. Consider that we have subtle races still in the kernel now,
> which are almost never or rarely hit in maybe 10,000 hours * every
> single person who has been using the current kernel for the past
> year.
> 
> For a less theoretical example -- when I was writing the RCU radix
> tree code, I tried to run directed stress tests on a 64 CPU Altix
> machine (which found no bugs). Then I ran it on a dedicated test
> harness that could actually do a lot more than the existing kernel
> users are able to, and promptly found a couple more bugs (on a 2
> CPU system).
> 
> But your primary defence against concurrency bugs _has_ to be
> knowing the code and all its interactions.
100% agree. 
btw For modules though it does not seem like luck (ie that it worked fine for me). 
I mean subsystems are supposed to cleanly register/unregister anyway. But I can of
course be wrong. We'll see what Rusty says.    

>> Clearly though, you guys are right. It cannot be simply disabled. Based on
>> the above grep it's needed for CPU hotplug, mem hotplug, kprobes on s390
>> and intel rng driver. Hopefully we can avoid it at least in module
>> insertion/removal.
> 
> Yes, reducing the number of users by going through their code and
> showing that it is safe, is the right way to do this. Also, you
> could avoid module insertion/removal?
I could. But it'd be nice if I did not have to :)

> FWIW, I think the idea of trying to turn Linux into giving hard
> realtime guarantees is just insane. If that is what you want, you
> would IMO be much better off to spend effort with something like
> improving adeos and communicatoin/administration between Linux and
> the hard-rt kernel.
> 
> But don't let me dissuade you from making these good improvements
> to Linux as well :) Just that it isn't really going to be hard-rt
> in general.
Actually that's the cool thing about CPU isolation. Get rid of all latency sources
from the CPU(s) and you get youself as hard-RT as it gets. 
I mean I _already_ have multi-core hard-RT systems that show ~1.2 usec worst case and 
~200nsec average latency. I do not even need Adeos/Xenomai or Preemp-RT just a few
very small patches. And it can be used for non RT stuff too.
 
Max



