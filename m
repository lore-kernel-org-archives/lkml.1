Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXHYMeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXHYMeh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 08:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbXHYMe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 08:34:27 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3495 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbXHYMe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 08:34:26 -0400
Message-ID: <46D00DDD.1070101@shadowen.org>
Date: Sat, 25 Aug 2007 12:09:17 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Mel Gorman <mel@skynet.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 Boot NUMA kernels on non-NUMA hardware with DISCONTIG
 memory model
References: <20070824162814.GD26374@skynet.ie> <20070824163521.GA16227@bingen.suse.de> <46CF0CCF.7010702@shadowen.org> <20070824170744.GB16227@bingen.suse.de> <20070824172626.GE26374@skynet.ie> <20070824173816.GC16227@bingen.suse.de> <20070824174438.GG26374@skynet.ie> <20070824175339.GD16227@bingen.suse.de>
In-Reply-To: <20070824175339.GD16227@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Fri, Aug 24, 2007 at 06:44:38PM +0100, Mel Gorman wrote:
>> On (24/08/07 19:38), Andi Kleen didst pronounce:
>>>> Other than the fact that the memmap must be PMD aligned to use hugepage
>>>> entries for the memmap. 
>>> Why is that so?  mem_map should be just part of lowmem anyways.
>>>
>> Not in this case. memmap is allocated node local and mapped in the virtual
>> memory area normally occupied by the end of low memory. The objective was
>> to have memmap for the struct pages node-local. Hence, portions of
>> memmap are really in highmem.
> 
> Ok, but that still doesn't mean it has to be PMD aligned, 
> as long as illegal virtual aliases are prevent in the overlap
> (which is not very hard) 
> 
>>>> It could be mapped with small pages in corner cases
>>>> but the complexity worth it?
>>> You don't need to map it with small pages in the normal case,
>>> the only requirement is that c_p_a() is aware of it so it can
>>> split it if needed.
>>>
>>>> I can't see this type of lifting being done any time soon. As SPARSEMEM works
>>>> and there is hope with the vmemmap work that DISCONTIG will finally go away,
>>>> it may not be the best investment of time.
>>> It's a trivial change, probably less code than your original patch.
>>>
>> I'll have to take your word for it because I haven't looked closely
>> enough. I'll try and find time to look at it but the earliest I'll get around
>> to it is post kernel-summit. In the meantime, SPARSEMEM works.
> 
> Ok, so we disable DISCONTIG i386 NUMA because there's nobody willing
> to maintain it?
>
> I'll take your word SPARSEMEM works, although I was told DISCONTIG NUMA
> works too and then my testing told a quite different story.

That sounds like over kill to me.  The code unfixed works for all actual
NUMA systems I am aware of, else we would have had reports of this
problem before in the years that this code has been in the kernel.  The
fix Mel sent up fixes the code so that it works on systems with
unaligned node ends (which is what triggers the issue).  It does mean
that a little memory is wasted when this kernel is used on a non-NUMA
systems with unaligned node ends (only), but it works as designed at
that point.  To be honest it looks very much that only a very small
memory systems is going to trip this, and we have traditionally used
non-NUMA kernels on non-NUMA systems so there is almost zero exposure in
our install base.

Does this sudden interest in this combination, indicate a distro driven
change to using NUMA kernels on non-NUMA systems??

Having been involved in the development of the code originally, I think
Mel's fix is a good compromise to fix the immediate problem.  Clearly
there are bigger problems in this code that need clearing up if we are
to use this code as it is on small memory non-NUMA systems.  For one the
change merged to fix the "memmap overlapping initrd allocation" severely
wastes memory by pushing the memmap into ZONE_NORMAL even when there is
spare Kernel Virtual Address space available, and also looses the memory
under it where it used to shift to HIGHMEM.

I think that most of this can become moot if we simply pull node-0 out
of this remap scheme, as node-0's memory is already local and the
problem only occurs on node-0.  I have a todo item to look over this,
but as Mel has indicated its probabally not going to be immediate.

I think it makes sense to take Mel's fix as the smallest repair and
we'll spend some time sorting it out cleanly soon.

-apw
