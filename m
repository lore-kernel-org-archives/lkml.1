Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbZBEVt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbZBEVt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZBEVtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:49:20 -0500
Received: from ns2.gothnet.se ([82.193.160.251]:9964 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752098AbZBEVtT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:49:19 -0500
X-Greylist: delayed 1016 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Feb 2009 16:49:18 EST
Message-ID: <498B5ADE.3090602@vmware.com>
Date: Thu, 05 Feb 2009 22:32:14 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: 2.6.29 pat issue
References: <498ADFE3.9020907@vmware.com> <1233856988.4286.83.camel@localhost.localdomain>
In-Reply-To: <1233856988.4286.83.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
> On Thu, 2009-02-05 at 04:47 -0800, Thomas Hellström wrote:
>> Hi!
>>
>> The function in include/linux/mm.h:
>> is_linear_pfn_mapping()
>>
>> doesn't seem valid to me.
>>
>> In particular, we have VMAs to graphics devices in which vma->vm_pgoff
>> is non-zero (Points to an offset in the drm device node), and the VMA is
>> sparsely populated with pfns pointing to uncached discontigous RAM pages.
>>
>> This causes the X86 PAT code to hit the optimized path when it
>> shouldn't, and issue a warning.
> 
> Only place where vm_pgoff is getting set for a PFNMAP vma is in
> remap_pfn_range() which maps the entire range. vm_insert_pfn() which may
> have sparsely populated ranges does not set vm_pgoff. What interface are
> you using to map discontig pages, where you are seeing these errors?
> 

Since vm_pgoff can be nonzero upon every call to a device driver's mmap 
method (It corresponds to the @offset parameter, page shifted, given by 
the user's mmap call), _Any_ VM_PFNMAP vma can practically be assumed to 
be linear by is_linear_pfn_mapping(), and that's an invalid assumption.

In this particular case, We set VM_PFNMAP explicitly in the mmap method 
and use fault() and vm_insert_pfn() to populate the vmas with PTEs 
pointing to private memory pages or io-space depending on where the data 
is currently located. The member vma->vm_pgoff is, as mentioned, set by 
the user-space mmap call, indicating what part of the device address 
space needs to be mapped.

So in the end, we're hitting the WARN_ON_ONCE(1) near line 637 in 
arch/x86/mm/pat.c. We should never have ended up in reserve_pfn_range() 
in the first place.


>> Also a question about the philosofy behind this strict checking that all
>> PTEs have the same caching attributes: I guess this is only to catch
>> bugs in kernel drivers that don't get this right. At the same time, now
>> that also user-space VMAs are checked this will probably have a
>> significant performance impact. Shouldn't this checking really live
>> behind a debug define?
> 
> The result of not having the caching attribute right can be really bad
> as to hang/crash the system. So, having this only in debug is not the
> enough, IM0. Kernel has to enforce UC and WC caching types are
> consistent at all times. And we also have to keep the indentity map and
> other mappings that may be present for that address consistent.

Indeed, it's crucial to keep the mappings consistent, but failure to do 
so is a kernel driver bug, it should never be the result of invalid user 
data.

There are other more common kernel bugs that can be even worse and hang 
/ crash the system. For example using uninitialized spinlocks, writing 
to kfreed memory etc. There is code in the kernel to detect these as 
well, but this code is behind debug defines.

IMHO checking each vm_insert_pfn() for caching attribute correctness is 
not something that should be enabled by default, due to the CPU 
overhead. Production drivers should never violate this.

Thanks,
Thomas.

> 
> Thanks,
> Venki
> 
> 



