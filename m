Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbZCFWlC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbZCFWlC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:41:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbZCFWj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:39:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:47527 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757381AbZCFWj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:39:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,316,1233561600"; 
   d="scan'208";a="392402878"
Subject: Re: 2.6.29 pat issue
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <49AE5039.5050105@vmware.com>
References: <498ADFE3.9020907@vmware.com>
	 <1233856988.4286.83.camel@localhost.localdomain>
	 <498B5ADE.3090602@vmware.com> <m1tz78pdwy.fsf@fess.ebiederm.org>
	 <498C062C.201@vmware.com> <20090304060857.GA18318@linux-os.sc.intel.com>
	 <49AE5039.5050105@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Mar 2009 14:38:20 -0800
Message-Id: <1236379100.4529.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 01:56 -0800, Thomas Hellstrom wrote:
> Hi!
> 
> Pallipadi, Venkatesh wrote:
> > On Fri, Feb 06, 2009 at 01:43:08AM -0800, Thomas Hellström wrote:
> >   
> >> Eric W. Biederman wrote:
> >>     
> >>> Thomas Hellstrom <thellstrom@vmware.com> writes:
> >>>
> >>>
> >>>
> >>>       
> >>>> Indeed, it's crucial to keep the mappings consistent, but failure to do so is a
> >>>> kernel driver bug, it should never be the result of invalid user data.
> >>>>
> >>>>         
> >>> It easily can be.  Think of an X server mmaping frame buffers. Or other
> >>> device bars.
> >>>
> >>>
> >>>       
> >> Hmm, Yes  you're right, although I'm still a bit doubtful about RAM pages.
> >>
> >> Wait. Now I see what's causing the problems. The code is  assuming that
> >> VM_PFNMAP vmas never map RAM pages. That's also an invalid assumption.
> >> See comments in mm/memory.c
> >>
> >> So probably the attribute check should be done for the insert_pfn path
> >> of VM_MIXEDMAP as well. That's not done today.
> >>
> >> So there are three distinct bugs at this point:
> >>
> >> 1) VMAs with VM_PFNMAP are incorrectly assumed to be linear if
> >> vma->vm_pgoff non-null.
> >> 2) VM_PFNMAP VMA PTEs are incorrectly assumed to never point to physical
> >> RAM.
> >> 3) There is no check for the insert_pfn  path of vm_insert_mixed().
> >>
> >>     
> >
> > Patch below will solve (1) above.
> >   
> 
> Yes, hmm, but how about remap_pfn_range() having an optimized function 
> to call into directly, instead of
> track_pfn_vma_new?

No. The idea was to have this flag set, only when full vma is mapped
using remap_pfn_range. In all other cases, insert_pfn or partial region
mapped in remap_pfn_range, we will use the slow path. Having said that,
the patch I had sent here missed one of the conditions. Refreshing the
patch.

> 
> > About (2), Yes. we can optimize the PAT code if we use struct page to track
> > PFNMAP as long at memory is backed by a struct page. It has some complications
> > with refcounting the number of mappings and related things. We are actively
> > looking at it. 
> 
> Cool. Still, there needs to be a check for non-io pages in vm_insert_pfn 
> to avoid hitting the WARN_ON_ONCE:
> + if (!pfn_valid(pfn)) //Pfn pointing to a non-ram page.
>     track_pfn_vma_new()

About the WARN_ON. I am not completely clear aboue how/why you are
getting the warning. You will only get WARN_ON, if driver is trying to
map actual RAM pages using remap_pfn_range or vm_insert_pfn. That is a
valid warning, I think. If RAM is intended to be mapped, then driver
should be using insert_page or insert_mixed. No? Are you getting the
warning even when you use vm_insert_page or vm_insert_mixed?

Thanks,
Venki

