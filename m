Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbYC1Cvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbYC1Cvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbYC1Cvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:51:46 -0400
Received: from gw.goop.org ([64.81.55.164]:58240 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225AbYC1Cvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:51:45 -0400
Message-ID: <47EC5D2E.8060001@goop.org>
Date: Thu, 27 Mar 2008 19:51:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] hotplug-memory: adding non-section-aligned memory
 is bad
References: <e0b16cc8349b38a5f3f9.1206664118@localhost>	<20080328102719.3ab9162b.kamezawa.hiroyu@jp.fujitsu.com>	<20080328102342.B0BF.E1E9C6FF@jp.fujitsu.com>	<20080328105406.5dc61c6c.kamezawa.hiroyu@jp.fujitsu.com>	<47EC5440.5020107@goop.org> <20080328113312.65cca8b5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080328113312.65cca8b5.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 27 Mar 2008 19:13:20 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>>>> Because, firmware may occupy some area in the section.
>>>> Firmware must exclude those area to notify kernel. So, E820, EFI,
>>>> or _CRS of ACPI may return not aligned address and size.
>>>> register_memory_resource() and walk_memory_resource() are to skip
>>>> them silently. This is intended.
>>>>
>>>>     
>>>>         
>>> Ah, ok. sorry.
>>>
>>> Jeremy, I think you can check whether you have 'struct page' or not by
>>> pfn_valid(). 
>>>
>>> If pfn_valid() == false, you should call add_memory() and create
>>> a section/mem_map. If pfn_valid() == true, you should just remove
>>> PG_reserved bit in mem_map by online_page().
>>>       
>> OK.  Would that ever be necessary if I explicitly align my start and size?
>>
>>     
> Maybe no. but be carefull not to register resource in overlapped manner.
>   

Yes.  That's why I added add_memory_resource(), so I could use 
allocate_resource() to find a non-overlapping range to put the new memory.

> (I wrote online_page() in above, but online_pages() is maybe better.
>  It does all what you want.)
>   

No, for my use-case the pages must be onlined one by one as they get 
some physical memory assigned to them.  At the time I do add_memory(), 
I'm just allocating page structures, but there's no memory backing that 
range.

That's why I need to disable the sysfs onlining interface, because it 
bulk onlines the pages before there's anything behind them.

> Start/Size are automatically alined to section in __add_pages().
>
> See below.
> ==
> 110 int __add_pages(struct zone *zone, unsigned long phys_start_pfn,
>  111                  unsigned long nr_pages)
>  112 {
>  113         unsigned long i;
>  114         int err = 0;
>  115         int start_sec, end_sec;
>  116         /* during initialize mem_map, align hot-added range to section */
>  117         start_sec = pfn_to_section_nr(phys_start_pfn);
>  118         end_sec = pfn_to_section_nr(phys_start_pfn + nr_pages - 1);
> ==
>
> And online_pages(), which onlines pages in [pfn, pfn + size), will see
> registerred resources within [pfn, pfn + size).
> ==
> 184 int online_pages(unsigned long pfn, unsigned long nr_pages)
> <snip>
> 227         walk_memory_resource(pfn, nr_pages, &onlined_pages,
> 228                 online_pages_range);
> ==
>
> One of my concern is how-to-handle sysfs status in this case.
>
> Another concerns is, currently, I think no one tried to online a section twice
> to online reserved pages in a section. so, you may see bug.
> For example, mem_notify() in online_pages() will be called several times against
> a section.
>   

I'd really rather prevent online_pages from happening at all, since it 
can only cause havoc.

Thanks,
    J
