Return-Path: <linux-kernel-owner+w=401wt.eu-S1762233AbXGXGWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762233AbXGXGWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 02:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759036AbXGXGV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 02:21:58 -0400
Received: from il.qumranet.com ([82.166.9.18]:36464 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760079AbXGXGV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 02:21:57 -0400
Message-ID: <46A59A75.8050501@qumranet.com>
Date: Tue, 24 Jul 2007 09:21:41 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Shaohua Li <shaohua.li@intel.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [RFC 0/8]KVM: swap out guest pages
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com>	 <46A4829C.9080104@qumranet.com>	 <1185232218.1803.36.camel@localhost.localdomain>	 <46A58E8B.8050507@qumranet.com> <1185257474.1803.216.camel@localhost.localdomain>
In-Reply-To: <1185257474.1803.216.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Tue, 24 Jul 2007 09:21:41 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tue, 2007-07-24 at 08:30 +0300, Avi Kivity wrote:
>   
>> Rusty Russell wrote:
>>     
>>> On Mon, 2007-07-23 at 13:27 +0300, Avi Kivity wrote:
>>>   
>>>       
>>>> Having an address_space (like your patch does) is remarkably simple, and 
>>>> requires few hooks from the current vm.  However using existing vmas 
>>>> mapped by the user has many advantages:
>>>>
>>>> - compatible with s390 requirements
>>>> - allows the user to use hugetlbfs pages, which have a performance 
>>>> advantage using ept/npt (but which are unswappable)
>>>> - allows the user to map a file (which can be regarded as way to specify 
>>>> the swap device)
>>>> - better ingration with the rest of the vm
>>>>     
>>>>         
>>> You don't need to expose the vmas.  You just have userspace point out
>>> the start+len of each region of memory it wants the guest to be able to
>>> access, and the address it wants it to appear in the guest.
>>>
>>> This is a slight superset of what lguest does in two ways:
>>>
>>> 1) my guest address == user address, but I'm looking at adding an offset
>>> so I don't have to link the launcher binary specially.
>>> 2) I have only one contiguous region of guest-physical memory, since I
>>> can place device memory immediately above "normal" mem.
>>>
>>>   
>>>       
>> My intent was to allow userspace to establish assign a virtual address
>> range into a memory slot.
>>
>> So long as you don't do swapping, all is simple, since you can do a
>> get_user_pages() on initialization or when installing a shadow pte.  But
>> if you want to swap, you need:
>>
>> - a way to transfer the dirty bit from the shadow ptes to the struct page
>>     
>
> Actually, get_user_pages() does that for you.  You have to make R/O any
> writable pte where the guest doesn't set the dirty bit (so you can trap
> it later) but last I put a printk in there, Linux doesn't do that.
>
>   

Don't understand.  You mean Linux always sets the dirty bit when it
makes a page writable?  Surely some mistake.

It probably does do so on demand write faults, but I'm sure the dirty
bit can get cleaned out by the swapper.

>> - a way to let the vm rmap know that there are shadow ptes that point to
>> the page in addition to Linux ptes.  These shadow ptes may be in a
>> different format than Linux ptes.
>> - a different tlb invalidation method with ASIDs
>>     
>
> Well first I was just going to see how well hooking into the shrinker
> works.  That might be sufficient: just throw out shadow refs to pages
> when there's pressure.
>   

Ah, interesting.  Yes, you trim the shadow page table cache which unrefs
pages for you.

Maybe that's a good way to get things started.

> If not, it does get harder.  A callback in the mm struct to say "I want
> to swap your page out" is required if we don't take a reference to the
> page.  Dirty bit handling would be an interesting issue (maybe the
> callback can say "No!" and dirty the page again?).
>   

Since we have rmap, I don't see that as an issue.  Given a page, we can
easily drop all refs.  Though lguest doesn't do that, right?

I'm also concerned with picking the correct page, but there's no good
solution here.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

