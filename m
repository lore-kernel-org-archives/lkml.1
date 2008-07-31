Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbYGaWYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbYGaWYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbYGaWX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:23:58 -0400
Received: from gw.goop.org ([64.81.55.164]:54930 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094AbYGaWX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:23:57 -0400
Message-ID: <48923B7A.3020805@goop.org>
Date: Thu, 31 Jul 2008 15:23:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: implement multiple queues for smp function	call
 IPIs
References: <488FA8A9.6000005@goop.org> <20080731220825.GD23801@elte.hu>
In-Reply-To: <20080731220825.GD23801@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
> heh, nice :-)
>
> Before going into all the fine details an trying our luck in tip/master 
> QA, i'm a bit worried about hw compatibility in general though. APICs 
> have been flaky since the beginnings of times. We had erratas in the 
> area of local timer IRQs(IPIs) overlapping with IPIs, etc. - so i'd not 
> bet the farm on all APICs being able to handle a _lot_ more overlapped 
> inter-CPU IPIs than we do currently. (which basically was just three of 
> them until now, and now four with the new SMP cross-call IPIs)
>
> So this _has_ to be approached defensively. It _should_ work, and i'm 
> all in favor of utilizing hardware resources more fully, but it's an 
> entirely new mode of operation for the hardware. I think a Kconfig 
> option (which defaults to off), and a boot option to disable it would be 
> nice, so that we can introduce this gently, at least initially. Then 
> when we see that it's 100% trouble-free we can flip around the default.
>   

As Andi pointed out, this is more or less functionally identical to the 
code I ripped out of tlb_64.c, so this mode of operation has had lots of 
exposure on the 64-bit side.  Because the number of queues is a CONFIG 
variable, it would be relatively easy to make it a real config option, 
and/or use different numbers for 32 and 64-bit.  Choosing 1 as the 
number of queues will make it behave exactly as the current code does.

I'm not really familiar with all the ins and outs of apic bugs.  What's 
the issue you're concerned about?

> Plus, would it be possible to shape this a bit more dynamically? I like 
> 8 as a nice round number, but i bet some folks would like to have 16, 
> some would like to have 4 ... Perhaps even making it dynamic (so that we 
> can turn it all off in the case of trouble with certain CPU/APIC 
> versions).
>
> Hm?
>   

Sure, that's possible in a followup patch.  There's a pile of repeated 
boilerplate code which would need to be cleaned up to make it 
configurable and/or runtime changable.  Also, it would need some way to 
allocate a contiguous block of vectors; I'm not sure if the just-posted 
SGI patch allows that...

It also occurred to me that it might be more interesting to parameterise 
the queues - and the mapping of cpus->queues - in a more topology-aware 
way than simply NQUEUES=NCPUS/x, queue=cpuid % NQUEUES.  But I haven't 
given it much thought.

    J
