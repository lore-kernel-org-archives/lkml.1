Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZCISGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZCISGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZCISGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:06:45 -0400
Received: from gw.goop.org ([64.81.55.164]:35221 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbZCISGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:06:45 -0400
Message-ID: <49B55AB0.1070605@goop.org>
Date: Mon, 09 Mar 2009 11:06:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <20090228084254.GA29342@elte.hu> <49A907DD.6010408@goop.org> <20090302120859.GB29015@elte.hu> <49B23907.8030103@goop.org> <20090308110150.GA19151@elte.hu> <49B43F1D.2000400@zytor.com> <20090308220609.GA23447@elte.hu> <49B441D9.4010004@zytor.com> <20090308221208.GA24079@elte.hu>
In-Reply-To: <20090308221208.GA24079@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
>
>   
>> Ingo Molnar wrote:
>>     
>>> Since it's the same kernel image i think the only truly reliable 
>>> method would be to reboot between _different_ kernel images: 
>>> same instructions but randomly re-align variables both in terms 
>>> of absolute address and in terms of relative position to each 
>>> other. Plus randomize bootmem allocs and never-gets-freed-really 
>>> boot-time allocations.
>>>
>>> Really hard to do i think ...
>>>
>>>       
>> Ouch, yeah.
>>
>> On the other hand, the numbers made sense to me, so I don't 
>> see why there is any reason to distrust them.  They show a 5% 
>> overhead with pv_ops enabled, reduced to a 2% overhead with 
>> the changed.  That is more or less what would match my 
>> intuition from seeing the code.
>>     
>
> Yeah - it was Jeremy expressed doubt in the numbers, not me.
>   

Mainly because I was seeing the instruction and cycle counts completely 
unchanged from run to run, which is implausible.  They're not zero, so 
they're clearly measurements of *something*, but not cycles and 
instructions, since we know that they're changing.  So what are they 
measurements of?  And if they're not what they claim, are the other 
numbers more meaningful?

It's easy to read the numbers as confirmations of preconceived 
expectations of the outcomes, but that's - as I said - unsatisfying.

> And we need to eliminate that 2% as well - 2% is still an awful 
> lot of native kernel overhead from a kernel feature that 95%+ of 
> users do not make any use of.
>   

Well, I think there's a few points here:

   1. the test in question is a bit vague about kernel and user
      measurements.  I assume the stuff coming from perfcounters is
      kernel-only state, but the elapsed time includes the usermode
      component, and so will be affected by the usermode page placement
      and cache effects.  If I change the test to copy the test
      executable (statically linked, to avoid libraries), then that
      should at least fuzz out user page placement.
   2. Its true that the cache effects could be due to the precise layout
      of the kernel executable; but if those effects are swamping
      effects of the changes to improve pvops then its unclear what the
      point of the exercise is.  Especially since:
   3. It is a config option, so if someone is sensitive to the
      performance hit and it gives them no useful functionality to
      offset it, then it can be disabled.  Distros tend to enable it
      because they tend to value function and flexibility over raw
      performance; they tend to enable things like audit, selinux,
      modules which all have performance hits of a similar scale (of
      course, you could argue that more people get benefit from those
      features to offset their costs).  But,
   4. I think you're underestimating the number of people who get
      benefit from pvops; the Xen userbase is actually pretty large, and
      KVM will use pvops hooks when available to improve Linux-as-guest.
   5. Also, we're looking at a single benchmark with no obvious
      relevance to a real workload.  Perhaps there are workloads which
      continuously mash mmap/munmap/mremap(!), but I think they're
      fairly rare.  Such a benchmark is useful for tuning specific
      areas, but if we're going to evaluate pvops overhead, it would be
      nice to use something a bit broader to base our measurements on. 
      Also, what weighting are we going to put on 32 vs 64 bit?  Equally
      important?  One more than the other?

All that said, I would like to get the pvops overhead down to 
unmeasureable - the ideal would be to be able to justify removing the 
config option altogether and leave it always enabled.

The tradeoff, as always, is how much other complexity are we willing to 
stand to get there?  The addition of a new calling convention is already 
fairly esoteric, but so far it has got us a 60% reduction in overhead 
(in this test).  But going further is going to get more complex.

For example, the next step would be to attack set_pte (including 
set_pte_*, pte_clear, etc), to make them use the new calling convention, 
and possibly make them inlineable (ie, to get it as close as possible to 
the non-pvops case).  But that will require them to be implemented in 
asm (to guarantee that they only use the registers they're allowed to 
use), and we already have 3 variants of each for the different pagetable 
modes.  All completely doable, and not even very hard, but it will be 
just one more thing to maintain - we just need to be sure the payoff is 
worth it.

    J
