Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZBEXHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZBEXHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZBEXH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:07:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:22514 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbZBEXH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:07:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,388,1231142400"; 
   d="scan'208";a="487577854"
Subject: Re: 2.6.29 pat issue
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
In-Reply-To: <498B5ADE.3090602@vmware.com>
References: <498ADFE3.9020907@vmware.com>
	 <1233856988.4286.83.camel@localhost.localdomain>
	 <498B5ADE.3090602@vmware.com>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 15:08:31 -0800
Message-Id: <1233875311.4286.127.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-05 at 13:32 -0800, Thomas Hellstrom wrote:
> Pallipadi, Venkatesh wrote:
> > 
> > Only place where vm_pgoff is getting set for a PFNMAP vma is in
> > remap_pfn_range() which maps the entire range. vm_insert_pfn() which may
> > have sparsely populated ranges does not set vm_pgoff. What interface are
> > you using to map discontig pages, where you are seeing these errors?
> > 
> 
> Since vm_pgoff can be nonzero upon every call to a device driver's mmap 
> method (It corresponds to the @offset parameter, page shifted, given by 
> the user's mmap call), _Any_ VM_PFNMAP vma can practically be assumed to 
> be linear by is_linear_pfn_mapping(), and that's an invalid assumption.
> 
> In this particular case, We set VM_PFNMAP explicitly in the mmap method 
> and use fault() and vm_insert_pfn() to populate the vmas with PTEs 
> pointing to private memory pages or io-space depending on where the data 
> is currently located. The member vma->vm_pgoff is, as mentioned, set by 
> the user-space mmap call, indicating what part of the device address 
> space needs to be mapped.
> 
> So in the end, we're hitting the WARN_ON_ONCE(1) near line 637 in 
> arch/x86/mm/pat.c. We should never have ended up in reserve_pfn_range() 
> in the first place.
> 

OK. Now I understand how you are seeing that warning. I am not what is
the simple way around this. There are no bits available in vm_flags that
we can use to identify linear_pfn_mapping. I don't think you have any
way around in the driver other than using pgoff, in order to do
vm_insert_pfn.
One possible way is to overload some existing flag + PFNMAP to mean
linear pfn map. Will send a patch for this as an RFC soon.

> > 
> > The result of not having the caching attribute right can be really bad
> > as to hang/crash the system. So, having this only in debug is not the
> > enough, IM0. Kernel has to enforce UC and WC caching types are
> > consistent at all times. And we also have to keep the indentity map and
> > other mappings that may be present for that address consistent.
> 
> Indeed, it's crucial to keep the mappings consistent, but failure to do 
> so is a kernel driver bug, it should never be the result of invalid user 
> data.
> 
> There are other more common kernel bugs that can be even worse and hang 
> / crash the system. For example using uninitialized spinlocks, writing 
> to kfreed memory etc. There is code in the kernel to detect these as 
> well, but this code is behind debug defines.
> 
> IMHO checking each vm_insert_pfn() for caching attribute correctness is 
> not something that should be enabled by default, due to the CPU 
> overhead. Production drivers should never violate this.
> 

It is not a question of single production driver. There are many
variables here. Different drivers can be mapping the same region. There
can be mapping from /dev/mem. There are also kernel identity and text
mappings. So, any change of cacheability by one driver has to make sure
it is not stepping over some other users of that pte. Kernel has to make
sure different things co-exist in a sane way.

There is an alternative to checking this in each vm_insert_pfn, as long
as mappings are going to be contiguous (even though they may be inserted
individually). As in include/linux/io-mapping.h, we can have a
create_mapping which reserves the entire space, and individual map and
unmap, which doesn't have to check. May be we need a new API for your
use case though...

Thanks,
Venki

