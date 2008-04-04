Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbYDDFdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbYDDFdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 01:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYDDFd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 01:33:28 -0400
Received: from gw.goop.org ([64.81.55.164]:47108 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbYDDFd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 01:33:27 -0400
Message-ID: <47F5BD6C.30100@goop.org>
Date: Thu, 03 Apr 2008 22:32:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 5 of 6] hotplug-memory: add section_ops
References: <785fe0877fea0f488bc5.1207267545@localhost>	 <1207270272.943.27.camel@nimitz.home.sr71.net>  <47F5809A.7040307@goop.org> <1207273978.943.82.camel@nimitz.home.sr71.net>
In-Reply-To: <1207273978.943.82.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Thu, 2008-04-03 at 18:12 -0700, Jeremy Fitzhardinge wrote:
>   
>> Dave Hansen wrote:
>>     
>>> On Thu, 2008-04-03 at 17:05 -0700, Jeremy Fitzhardinge wrote:
>>> I think it might just be nicer to have a global list of these handlers
>>> somewhere.  The Xen driver can just say "put me on the list of
>>> callbacks" and we'll call them at online_page().  I really don't think
>>> we need to be passing an ops structure around.
>>>   
>>>       
>> Yes, but it seems a bit awkward.  If we assume that:
>>
>>    1. Xen will be the only user of the hook, and
>>    2. Xen-balloon hotplug is exclusive of real memory hotplug
>>
>> then I guess its reasonable (though if that's the case it would be 
>> simpler to just put a direct call under #ifdef CONFIG_XEN_BALLOON in there).
>>     
>
> Yeah, I'm OK with something along those lines, too.  I'd prefer sticking
> some stubs in a header and putting the #ifdef there, if only for
> aesthetic reasons.
>   

Sure.  But I think its a very non-scalable approach; as soon as there's 
a second user who wants to do something like this, its worth going to a 
more ops or function-pointer path.

>> But if we think there can be multiple callbacks, and they all get called 
>> on the online of each page, and there can be multiple kinds of hotplug 
>> memory it gets pretty messy.  Each has to determine "why was I called on 
>> this page?" and you'd to work out which one actually does the job of 
>> onlining.  It just seems cleaner to say "this section needs to be 
>> onlined like this", and there's no ambiguity.
>>     
>
> I really wish we'd stop calling it "page online". :)
>
> Let me think out loud for a sec here.  Here's how memory hotplug works
> in a nutshell:
>
> First step (add_memory() or probe time):
> 1. get more memory made available
> 2. create kva mapping for that memory (for lowmem)
> 3. allocate 'struct pages'
>
> Second step, 'echo 1 > .../memoryXXX/online' time:
> 4. modify zone/pgdat spans (make the VM account for the memory)
> 5. Initialize the 'struct page'
> 6. free the memory into the buddy allocator
>
> You can't do (2) because Xen doesn't allow mappings to be created until
> real backing is there.  You've already done this, right?
>   

Well, it hasn't been an issue so far, because I've only been working 
with x86-32 where all hotplug memory is highmem.  But, yes, on x86-64 
and other architectures it would have to defer creating the mappings 
until it gets the pages (page by page).

> You don't want to do (6) either, because there is no mapping for the
> page and it isn't committed in hardware, yet, so you don't want someone
> grabbing it *out* of the buddy allocator and using it.
>   

Right.  I do that page by page in the balloon driver; each time I get a 
machine page, I bind it to the corresponding page structure and free it 
into the allocator.

And I skip the whole "echo online > /sys..." part, because its 
redundant: the use of hotplug memory is an internal implementation 
detail of the balloon driver, which users needn't know about when they 
deal with the balloon driver.

> Your solution is to take those first 1-5 steps, and had the balloon
> driver call them directly.  The online_page() modifications are because
> 5/6 are a bit intertwined right now.  Are we on the same page so far?
>   

Right.

> Why don't we just free the page back into the balloon driver?  Take the
> existing steps 1-5, use them as they stand today, and just chop of step
> 6 for Xen.  It'd save a bunch of this code churn and also stop us from
> proliferating any kind of per-config section-online behavior like you're
> asking about above.
>   

That's more or less what I've done.  I've grouped it as 1-4 when the 
balloon driver decides it needs more page structures, then 5&6 page by 
page when it actually gets some backing memory.

> That might also be generalizable to anyone else that wants the "fresh
> meat" newly-hotplugged memory.  Large page users might be other
> consumers here.
>   

Sure.  The main problem is that 1-3 also ends up implicitly registering 
the new section with sysfs, so the bulk online interface becomes to 
usermode.  If we make that optional (ie, a separate explicit call the 
memory-adder can choose to take) then everything is rosy.

>> I'm already anticipating using the ops mechanism to support another 
>> class of Xen hotplug memory for managing large pages.
>>     
>
> Do tell. :)
>   

I think I mentioned it before.  If we 1) modify Xen to manage domain 
memory in large pages, 2) have a reasonably small section size, then we 
can reasonably do all memory management directly via the hotplug 
interface.  Bringing each (large) page online would still require some 
explicit action, but it would be a much closer fit to how the hotplug 
machinery currently works.  Then a small user or kernel mode policy 
daemon could use it to replicate the existing balloon driver's 
functionality.

    J
