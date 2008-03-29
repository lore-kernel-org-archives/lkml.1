Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbYC2CJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbYC2CJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 22:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYC2CJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 22:09:28 -0400
Received: from gw.goop.org ([64.81.55.164]:56460 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYC2CJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 22:09:27 -0400
Message-ID: <47EDA4B9.6030801@goop.org>
Date: Fri, 28 Mar 2008 19:08:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
 zone growth from page onlining
References: <47ED8685.9040409@goop.org> <1206751622.27091.20.camel@nimitz.home.sr71.net>
In-Reply-To: <1206751622.27091.20.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Fri, 2008-03-28 at 17:00 -0700, Jeremy Fitzhardinge wrote:
>   
>> The Xen balloon driver needs to separate the process of hot-installing
>> memory into two phases: one to allocate the page structures and
>> configure the zones, and another to actually online the pages of newly
>> installed memory.
>>
>> This patch splits up the innards of online_pages() into two pieces which
>> correspond to these two phases.  The behaviour of online_pages() itself
>> is unchanged.
>>     
> ...
>   
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -180,31 +180,35 @@
>>         return 0;
>>  }
>>
>> -
>> -int online_pages(unsigned long pfn, unsigned long nr_pages)
>> +/* Tell anyone who's interested that we're onlining some memory */
>> +static int notify_going_online(unsigned long pfn, unsigned long nr_pages)
>>  {
>> -       unsigned long flags;
>> -       unsigned long onlined_pages = 0;
>> -       struct zone *zone;
>> -       int need_zonelists_rebuild = 0;
>> +       struct memory_notify arg;
>>         int nid;
>>         int ret;
>> -       struct memory_notify arg;
>>
>>         arg.start_pfn = pfn;
>>         arg.nr_pages = nr_pages;
>>         arg.status_change_nid = -1;
>> -
>> +
>>         nid = page_to_nid(pfn_to_page(pfn));
>>         if (node_present_pages(nid) == 0)
>>                 arg.status_change_nid = nid;
>>     
>
> That's kind a weird line in the patch.  How'd that get there?  Why are
> you moving 'arg'?
>   

arg is the notifier arg.  This function is just wrapping up the 
GOING_ONLINE notifier.  The code is just a copy, so it isn't doing 
anything it wasn't doing before.

The original code also recycles arg for the ONLINE notifier, but that 
seemed unnecessary.

> This look OK, but it does add ~45 lines of code, and I'm not immediately
> sure how you're going to use it.  Could you address that a bit?
>   

Sure.  When the balloon driver wants to increase the domain's size, but 
it finds its run out of page structures to grow into, it hotplug-adds 
some memory.  This code uses the add_memory_resource() function I posted 
the patch for yesterday.  (Error-checking removed for brevity.)

static void balloon_expand(unsigned pages)
{
	struct resource *res;
	int ret;
	u64 size = (u64)pages * PAGE_SIZE;
	unsigned pfn;
	unsigned start_pfn, end_pfn;

	res = kzalloc(sizeof(*res), GFP_KERNEL);

	res->name = "Xen Balloon";
	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;

	ret = allocate_resource(&iomem_resource, res, size, 0, -1,
				1ul << SECTION_SIZE_BITS, NULL, NULL);

	start_pfn = res->start >> PAGE_SHIFT;
	end_pfn = (res->end + 1) >> PAGE_SHIFT;

	ret = add_memory_resource(0, res);
	ret = prepare_online_pages(start_pfn, pages);

	for(pfn = start_pfn; pfn < end_pfn; pfn++) {
		struct page *page = pfn_to_page(pfn);

		SetPageReserved(page);
		set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
		balloon_append(page);		/* add to a list of balloon pages */
	}
}


So this just gives us some page structures, but there's no underlying 
memory yet.  Later, the balloon driver starts populating the pages with 
real memory behind them:

	for (i = 0; i < nr_pages; i++) {
		page = balloon_retrieve();

		pfn = page_to_pfn(page);

		/* frame_list is set of real memory pages */
		set_phys_to_machine(pfn, frame_list[i]);

		/* Relinquish the page back to the allocator. */
		mark_pages_onlined(pfn, 1);

		/* Link back into the page tables if not highmem. */
		if (!PageHighMem(page)) {
			int ret;
			ret = HYPERVISOR_update_va_mapping(
				(unsigned long)__va(pfn << PAGE_SHIFT),
				mfn_pte(frame_list[i], PAGE_KERNEL),
				0);

		}
	}


> I do kinda wish you'd take a real hard look at what the new functions
> are doing now.  I'm not sure their current names are very good.
>   

You're right.  This is very much a first pass.

>> +/* Grow the zone to fit the expected amount of memory being added */
>> +static struct zone *online_pages_zone(unsigned long pfn, unsigned long nr_pages)
>>     
>
> The comment is good, but the function name is not. :)  How about
> grow_zone_span() or something?
>   

Sure.  I'm not really sure what the bookkeeping its doing really means 
though.

>> +/* Mark a set of pages as online */
>> +unsigned long mark_pages_onlined(unsigned long pfn, unsigned long nr_pages)
>>     
>
> Isn't the comment on this one a bit redundant? :)
>
> This looks to me to have become the real online_pages() now.  This
> function is what goes and individually onlines pages.  If someone was
> trying to figure out whether to call online_pages() or
> mark_pages_onlined(), which one would they know to call?
>   

Yep.  My goal in this was to extract he behaviours I need without 
affecting any other users.  online_pages() is definitely a trivial 
helper function now, and it could be removed without causing much damage 
to its couple of callers.

>> -       if (onlined_pages)
>> +       if (onlined_pages) {
>> +               struct memory_notify arg;
>> +
>> +               arg.start_pfn = pfn;  /* ? */
>> +               arg.nr_pages = onlined_pages;
>> +               arg.status_change_nid = -1;  /* ? */
>> +
>>                 memory_notify(MEM_ONLINE, &arg);
>> +       }
>>     
>
> We should really wrap up memory notify:
>
> static void memory_notify(int state, unsigned long start_pfn,
> 			  unsigned long nr_pages, int status_change_nid)
> {
> 	struct memory_notify arg;
> 	arg.start_pfn = start_pfn;
> 	arg.nr_pages = nr_pages;
> 	arg.status_change_nid = status_change_nid;
> 	return the_current_memory_notify(state, &arg);
> }
>
> We can use that in a couple of spots, right?
>   

Perhaps.  Or we could get rid of it altogether.  There's only a single 
user of the notifier (mm/slub.c), and given that it doesn't even use the 
MEM_ONLINE notifier, we could just drop this part.   Seems like it would 
be simpler to just have the hotplug code call directly into slub if 
that's what it needs...

My big remaining problem is how to disable the sysfs interface for this 
memory.  I need to prevent any onlining via /sys/device/system/memory.

Looks like I need to modify register_new_memory() to pass a "don't 
change state" flag, and stash it in struct memory_block so that 
store_mem_state() knows to ignore any state changes.  But it's not clear 
how I can get that information down into __add_section()...  I guess I 
just need to propagate it down from add_memory().

    J
