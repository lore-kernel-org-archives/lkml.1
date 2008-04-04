Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbYDDOWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbYDDOWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYDDOWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:22:32 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41967 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbYDDOWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:22:31 -0400
Subject: Re: [PATCH 5 of 6] hotplug-memory: add section_ops
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <47F5BD6C.30100@goop.org>
References: <785fe0877fea0f488bc5.1207267545@localhost>
	 <1207270272.943.27.camel@nimitz.home.sr71.net> <47F5809A.7040307@goop.org>
	 <1207273978.943.82.camel@nimitz.home.sr71.net> <47F5BD6C.30100@goop.org>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 07:22:26 -0700
Message-Id: <1207318946.943.107.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-03 at 22:32 -0700, Jeremy Fitzhardinge wrote:
> Dave Hansen wrote:
> > First step (add_memory() or probe time):
> > 1. get more memory made available
> > 2. create kva mapping for that memory (for lowmem)
> > 3. allocate 'struct pages'
> >
> > Second step, 'echo 1 > .../memoryXXX/online' time:
> > 4. modify zone/pgdat spans (make the VM account for the memory)
> > 5. Initialize the 'struct page'
> > 6. free the memory into the buddy allocator
> >
> > You can't do (2) because Xen doesn't allow mappings to be created until
> > real backing is there.  You've already done this, right?
...
> > You don't want to do (6) either, because there is no mapping for the
> > page and it isn't committed in hardware, yet, so you don't want someone
> > grabbing it *out* of the buddy allocator and using it.
> >   
> 
> Right.  I do that page by page in the balloon driver; each time I get a 
> machine page, I bind it to the corresponding page structure and free it 
> into the allocator.
> 
> And I skip the whole "echo online > /sys..." part, because its 
> redundant: the use of hotplug memory is an internal implementation 
> detail of the balloon driver, which users needn't know about when they 
> deal with the balloon driver.

I disagree that it is redundant.  There is actually a lot of power
there, and it was done for some very specific reasons.  They're actually
especially important to your particular use, which I'll try to explain.

Say that you have a very fragmented lowmem-only machine and you want to
add a section of new mem_map[].  That's 512MB/PAGE_SIZE*sizeof(struct
page), which is between 4 and 8MB.  So, you need 8MB of contiguous pages
for that mem_map[].  The way we designed it, you could always have that
extra section sitting there, unused.  You have that overhead of 8MB
sitting there, but the benefit is that you can *ALWAYS* add memory.

I worry that the current patches as posted don't allow this kind of
behavior.  If there was ever a need to preallocate the space, it would
need to do it inside the balloon driver itself and a way found to pass
that into the hotplug code.

It is especially important for Xen because all of the other
architectures, when getting a new section, magically have a large new
contiguous area out of which to get a new mem_map[] or other structures.
Xen doesn't actually have any contiguous memory at all since it will be
adding a page at a time.  Could you add some new functionality to the
Xen driver and make sure to allocate the new section's mem_map[] inside
the section?  That would get around the problem.

> > That might also be generalizable to anyone else that wants the "fresh
> > meat" newly-hotplugged memory.  Large page users might be other
> > consumers here.
> 
> Sure.  The main problem is that 1-3 also ends up implicitly registering 
> the new section with sysfs, so the bulk online interface becomes to 
> usermode.  If we make that optional (ie, a separate explicit call the 
> memory-adder can choose to take) then everything is rosy.

OK, but the registering isn't a bad thing, either.  You just don't want
all of the pages to be stuck back into the allocator.  You want to suck
them into the balloon driver.  Right?

Let's put a hook in online_page() to divert the new pages into your
driver instead of into the allocator.  Problem solved, right?

We might do this with a free_hotplugged_page() function.  It can, in the
initial introduction patch, just call free_page().  You can modify it
later to do your bidding.  

> >> I'm already anticipating using the ops mechanism to support another 
> >> class of Xen hotplug memory for managing large pages.
> >>     
> >
> > Do tell. :)
> >   
> 
> I think I mentioned it before.  If we 1) modify Xen to manage domain 
> memory in large pages, 2) have a reasonably small section size, then we 
> can reasonably do all memory management directly via the hotplug 
> interface.  Bringing each (large) page online would still require some 
> explicit action, but it would be a much closer fit to how the hotplug 
> machinery currently works.  Then a small user or kernel mode policy 
> daemon could use it to replicate the existing balloon driver's 
> functionality.

This sounds like a tall order considering Xen's current tight coupling
between memory mapping and allocation, but I trust you and your
colleagues to get it done. :)

-- Dave

