Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbYDDSW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbYDDSW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 14:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYDDSWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 14:22:19 -0400
Received: from gw.goop.org ([64.81.55.164]:46784 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067AbYDDSWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 14:22:18 -0400
Message-ID: <47F6719E.9010807@goop.org>
Date: Fri, 04 Apr 2008 11:21:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 5 of 6] hotplug-memory: add section_ops
References: <785fe0877fea0f488bc5.1207267545@localhost>	 <1207270272.943.27.camel@nimitz.home.sr71.net> <47F5809A.7040307@goop.org>	 <1207273978.943.82.camel@nimitz.home.sr71.net> <47F5BD6C.30100@goop.org> <1207318946.943.107.camel@nimitz.home.sr71.net>
In-Reply-To: <1207318946.943.107.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> I disagree that it is redundant.  There is actually a lot of power
> there, and it was done for some very specific reasons.  They're actually
> especially important to your particular use, which I'll try to explain.
>
> Say that you have a very fragmented lowmem-only machine and you want to
> add a section of new mem_map[].  That's 512MB/PAGE_SIZE*sizeof(struct
> page), which is between 4 and 8MB.  So, you need 8MB of contiguous pages
> for that mem_map[].  The way we designed it, you could always have that
> extra section sitting there, unused.  You have that overhead of 8MB
> sitting there, but the benefit is that you can *ALWAYS* add memory.
>
> I worry that the current patches as posted don't allow this kind of
> behavior.  If there was ever a need to preallocate the space, it would
> need to do it inside the balloon driver itself and a way found to pass
> that into the hotplug code.
>   

Yes, there's a chicken-egg problem if you want to use the new memory to 
describe itself.  But in the x86-32 case, hotplug memory is always 
highmem, and so can't be used for page structures, right?

> It is especially important for Xen because all of the other
> architectures, when getting a new section, magically have a large new
> contiguous area out of which to get a new mem_map[] or other structures.
> Xen doesn't actually have any contiguous memory at all since it will be
> adding a page at a time.  Could you add some new functionality to the
> Xen driver and make sure to allocate the new section's mem_map[] inside
> the section?  That would get around the problem.
>   

At the time the balloon driver decides it needs some new page 
structures, it has some new pages in hand.  If it knew where to put 
them, it could map those new pages as the seed of a new section.   The 
problem is guaranteeing enough pages to be able to populate the 
section's memmap - its a bit of a catch-22 if you can't hotplug new 
memory unless you can allocate at least 4-8MB.

>>> That might also be generalizable to anyone else that wants the "fresh
>>> meat" newly-hotplugged memory.  Large page users might be other
>>> consumers here.
>>>       
>> Sure.  The main problem is that 1-3 also ends up implicitly registering 
>> the new section with sysfs, so the bulk online interface becomes to 
>> usermode.  If we make that optional (ie, a separate explicit call the 
>> memory-adder can choose to take) then everything is rosy.
>>     
>
> OK, but the registering isn't a bad thing, either.  You just don't want
> all of the pages to be stuck back into the allocator.  You want to suck
> them into the balloon driver.  Right?
>   

Yeah.  And I have no objection to things appearing in /sys, or even 
making the "state" files do something sensible if you write to them.  I 
just don't want to make it too easy to shoot yourself in the foot.

> Let's put a hook in online_page() to divert the new pages into your
> driver instead of into the allocator.  Problem solved, right?
>
> We might do this with a free_hotplugged_page() function.  It can, in the
> initial introduction patch, just call free_page().  You can modify it
> later to do your bidding.  
>   

Sure.  That's more or less what the ops patch lets me do.  The question 
is whether the right answer is:

   1. add an ops structure to struct mem_section
   2. pass an "online_page" function pointer into online_pages, or
   3. have a special-case Xen hook in online_page

1 I've already implemented, Kame suggested 2, and we also mentioned 3 in 
passing.

I think 2 is looking like a nice tradeoff between complexity and 
flexibility.

> This sounds like a tall order considering Xen's current tight coupling
> between memory mapping and allocation, but I trust you and your
> colleagues to get it done. :)
>   

The combination of needing to map pagetables RO and grant tables for IO 
makes it unlikely that we'll be able to map the kernel space with large 
pages in the short term.  But it does allow usermode to use large pages, 
and maybe it would be worth trying to work out how to reconfigure the 
kernel address space to separate kernel code/data from pagetable and IO 
mappings...

    J
