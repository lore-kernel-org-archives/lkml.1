Return-Path: <linux-kernel-owner+w=401wt.eu-S1751723AbYC3A03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbYC3A03 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 20:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbYC3A0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 20:26:20 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:46325 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbYC3A0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 20:26:19 -0400
Message-ID: <47EEDE27.2020809@codemonkey.ws>
Date: Sat, 29 Mar 2008 19:26:15 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
 zone growth from page onlining
References: <47ED8685.9040409@goop.org>	 <1206751622.27091.20.camel@nimitz.home.sr71.net>	 <47EDA4B9.6030801@goop.org> <1206806774.31896.27.camel@nimitz.home.sr71.net> <47EED683.5030200@goop.org>
In-Reply-To: <47EED683.5030200@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Dave Hansen wrote:
>>
>> To me, it sounds like the only different thing that you want is to make
>> sure that only partial sections are onlined.  So, shall we work with the
>> existing interfaces to online partial sections, or will we just disable
>> it entirely when we see Xen?
>>   
>
> Well, yes and no.
>
> For the current balloon driver, it doesn't make much sense.  It would 
> add a fair amount of complexity without any real gain.  It's currently 
> based around alloc_page/free_page.  When it wants to shrink the domain 
> and give memory back to the host, it allocates pages, adds the page 
> structures to a ballooned pages list, and strips off the backing 
> memory and gives it to the host.  Growing the domain is the converse: 
> it gets pages from the host, pulls page structures off the list, binds 
> them together and frees them back to the kernel.  If it runs out of 
> ballooned page structures, it hotplugs in some memory to add more.
>
> That said, if (partial-)sections were much smaller - say 2-4 meg - and 
> page migration/defrag worked reliably, then we could probably do 
> without the balloon driver and do it all in terms of memory hot 
> plug/unplug.  That would give us a general mechanism which could 
> either be driven from userspace, and/or have in-kernel 
> Xen/kvm/s390/etc policy modules.  Aside from small sections, the only 
> additional requirement would be an online hook which can actually 
> attach backing memory to the pages being onlined, rather than just 
> assuming an underlying DIMM as current code does.

Ballooning on KVM (and s390) is very much a different beast from Xen.  
With Xen, ballooning is very similar to hotplug in that you're adding 
and removing physical memory from the guest.  The use of alloc_page() to 
implement it instead of hotplug is for the reasons Jeremy's outlined 
above.  Logically though, it's hotplug.

For KVM and s390, ballooning is really a primitive form of guest page 
hinting.  The host asks the guest to allocate some memory and the guest 
allocates what it can, and then tells the host which pages they were.  
It's basically saying the pages are Unused and then the host may move 
those pages from Up=>Uz which reduces the resident size of the guest.  
The virtual size stays the same though.  We can enforce limits on the 
resident size of the guest via the new cgroup memory controller.

The guest is free to reclaim those pages at any time it wants without 
informing the host.  In fact, we plan to utilize this by implementing a 
shrinker and OOM handler in the virtio balloon driver.

Hotplug is still useful for us as it's more efficient to hot-add 1gb of 
memory instead of starting out with an extra 1gb and ballooning down.  
We wouldn't want to hotplug away every page we balloon though as we want 
to be able to reclaim them if necessary without the hosts intervention 
(like on an OOM condition).

>> For Xen and KVM, how does it get decided that the guest needs more
>> memory?  Is this guest or host driven?  Both?  How is the guest
>> notified?  Is guest userspace involved at all?
>
> In Xen, either the host or the guest can set the target size for the 
> domain, which is capped by the host-set limit.  Aside from possibly 
> setting the target size, there's no usermode involvement in managing 
> ballooning.  The virtio balloon driver is similar, though from a quick 
> look it seems to be entirely driven by the host side.

The host support for KVM ballooning is entirely in userspace, but that's 
orthogonal to the discussion at hand really.

Regards,

Anthony Liguori

>    J

