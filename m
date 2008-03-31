Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbYCaSHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbYCaSHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 14:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYCaSHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 14:07:32 -0400
Received: from gw.goop.org ([64.81.55.164]:37524 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbYCaSHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 14:07:31 -0400
Message-ID: <47F1282E.3020503@goop.org>
Date: Mon, 31 Mar 2008 11:06:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
 zone growth from page onlining
References: <47ED8685.9040409@goop.org>	 <1206751622.27091.20.camel@nimitz.home.sr71.net>	 <47EDA4B9.6030801@goop.org>	 <1206806774.31896.27.camel@nimitz.home.sr71.net>	 <47EED683.5030200@goop.org> <1206981741.31896.51.camel@nimitz.home.sr71.net>
In-Reply-To: <1206981741.31896.51.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Sat, 2008-03-29 at 16:53 -0700, Jeremy Fitzhardinge wrote:
>   
>> Dave Hansen wrote:
>>     
>>> On Fri, 2008-03-28 at 19:08 -0700, Jeremy Fitzhardinge wrote:
>>>   
>>>       
>>>> My big remaining problem is how to disable the sysfs interface for this 
>>>> memory.  I need to prevent any onlining via /sys/device/system/memory.
>>>>     
>>>>         
>>> I've been thinking about this some more, and I wish that you wouldn't
>>> just throw this interface away or completely disable it.
>>>       
>> I had no intention of globally disabling it.  I just need to disable it 
>> for my use case.
>>     
>
> Right, but by disabling it for your case, you have given up all of the
> testing that others have done on it.  Let's try and see if we can get
> the interface to work for you.
>   

I suppose, but I'm not sure I see the point.  What are the benefits of 
using this interface?  You mentioned that the interface exists so that 
its possible to defer using a newly added piece of memory to avoid 
fragmentation.  I suppose I can see the point of that

But in the xen-balloon case, the memory is added on-demand precisely 
when its about to be used, and then onlined in pieces as needed.  
Extending the usermode interface to allow partial onlining/offlining 
doesn't seem very useful for the case of physical hotplug memory, and 
its not at all clear how to do it in a useful way for the xen-balloon 
case.  Particularly for offlining, since you'd need to guarantee that 
any page chosen for offlining isn't currently in use.

>>> To me, it sounds like the only different thing that you want is to make
>>> sure that only partial sections are onlined.  So, shall we work with the
>>> existing interfaces to online partial sections, or will we just disable
>>> it entirely when we see Xen?
>>>   
>>>       
>> Well, yes and no.
>>
>> For the current balloon driver, it doesn't make much sense.  It would 
>> add a fair amount of complexity without any real gain.  It's currently 
>> based around alloc_page/free_page.  When it wants to shrink the domain 
>> and give memory back to the host, it allocates pages, adds the page 
>> structures to a ballooned pages list, and strips off the backing memory 
>> and gives it to the host.  Growing the domain is the converse: it gets 
>> pages from the host, pulls page structures off the list, binds them 
>> together and frees them back to the kernel.  If it runs out of ballooned 
>> page structures, it hotplugs in some memory to add more.
>>     
>
> How does this deal with things like present_pages in the zones?  Does
> the total ram just grow with each hot-add, or does it grow on a per-page
> basis from the ballooning?
>   

Well, there are two ways of looking at it:

    either hot-plugging memory immediately adds pages, but they're also
    all immediately allocated and therefore unavailable for general use, or

    the pages are notionally physically added as they're populated by
    the host


In principle they're equivalent, but I could imagine the former has the 
potential to make the VM waste time scanning unfreeable pages.

I'm not sure the patches I've posted are doing this stuff correctly 
either way.

>> That said, if (partial-)sections were much smaller - say 2-4 meg - and 
>> page migration/defrag worked reliably, then we could probably do without 
>> the balloon driver and do it all in terms of memory hot plug/unplug.  
>> That would give us a general mechanism which could either be driven from 
>> userspace, and/or have in-kernel Xen/kvm/s390/etc policy modules.  Aside 
>> from small sections, the only additional requirement would be an online 
>> hook which can actually attach backing memory to the pages being 
>> onlined, rather than just assuming an underlying DIMM as current code does.
>>     
>
> Even with 1MB sections

1MB is too small.  It shouldn't be smaller than the size of a large page.

>  and a flat sparsemem map, you're only looking at
> ~500k of overhead for the sparsemem storage.  Less if you use vmemmap.  
>   

At the moment my concern is 32-bit x86, which doesn't support vmemmap or 
sections smaller than 512MB because of the shortage of page flags bits.

    J
