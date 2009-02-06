Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbZBFJnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbZBFJnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757300AbZBFJnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:43:21 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:37069 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756776AbZBFJnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:43:19 -0500
Message-ID: <498C062C.201@vmware.com>
Date: Fri, 06 Feb 2009 10:43:08 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thellstrom@vmware.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: 2.6.29 pat issue
References: <498ADFE3.9020907@vmware.com>	<1233856988.4286.83.camel@localhost.localdomain>	<498B5ADE.3090602@vmware.com> <m1tz78pdwy.fsf@fess.ebiederm.org>
In-Reply-To: <m1tz78pdwy.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Thomas Hellstrom <thellstrom@vmware.com> writes:
>
>
>   
>> Indeed, it's crucial to keep the mappings consistent, but failure to do so is a
>> kernel driver bug, it should never be the result of invalid user data.
>>     
>
> It easily can be.  Think of an X server mmaping frame buffers. Or other
> device bars.
>
>   
Hmm, Yes  you're right, although I'm still a bit doubtful about RAM pages.

Wait. Now I see what's causing the problems. The code is  assuming that  
VM_PFNMAP vmas never map RAM pages. That's also an invalid assumption. 
See comments in mm/memory.c

So probably the attribute check should be done for the insert_pfn path 
of VM_MIXEDMAP as well. That's not done today.

So there are three distinct bugs at this point:

1) VMAs with VM_PFNMAP are incorrectly assumed to be linear if 
vma->vm_pgoff non-null.
2) VM_PFNMAP VMA PTEs are incorrectly assumed to never point to physical 
RAM.
3) There is no check for the insert_pfn  path of vm_insert_mixed().

>   
>> IMHO checking each vm_insert_pfn() for caching attribute correctness is not
>> something that should be enabled by default, due to the CPU overhead. Production
>> drivers should never violate this.
>>     
>
> If it is a problem the implementation should become more efficient.  Userspace
> as well as drivers can generate these mappings so even with a perfect driver
> you cannot guarantee that someone else does not have that area of memory
> mapped differently.
>   
OK, So there seems to be a couple of things that can be done for 
performance here:

1) A fastpath for single pages.
2) RAM pages are tracked with a page bit today.
Why not say "all memory backed by a struct page" should be tracked with 
a page bit. Then pfn_valid() could be used instead of page_is_ram(). 
This, combined with 1) should make tracking struct page backed pages 
extremely fast.
3) If vm_insert_pfn() happens to be used on a linear VMA, it looks like 
the whole VMA is being validated for each vm_insert_pfn(), which seems 
extremely inefficient, considering the extensive tests in pagerame_is_ram().

/Thomas

> Eric
>   


