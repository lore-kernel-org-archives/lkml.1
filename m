Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbZCFXsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbZCFXsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 18:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZCFXsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 18:48:10 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:53998 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752983AbZCFXsI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 18:48:08 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>
Date: Fri, 6 Mar 2009 15:44:07 -0800
Subject: RE: 2.6.29 pat issue
Thread-Topic: 2.6.29 pat issue
Thread-Index: AcmerGpJ4TpT4I/hSf+Px8CdBCY5zAACQYfh
Message-ID: <130CA3A191875048A0624FB523A55EC7075DA7CA@PA-EXMBX51.vmware.com>
References: <498ADFE3.9020907@vmware.com>
	 <1233856988.4286.83.camel@localhost.localdomain>
	 <498B5ADE.3090602@vmware.com> <m1tz78pdwy.fsf@fess.ebiederm.org>
	 <498C062C.201@vmware.com> <20090304060857.GA18318@linux-os.sc.intel.com>
	 <49AE5039.5050105@vmware.com>,<1236379100.4529.9.camel@localhost.localdomain>
In-Reply-To: <1236379100.4529.9.camel@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
From: Pallipadi, Venkatesh [venkatesh.pallipadi@intel.com]
Sent: Friday, March 06, 2009 23:38
To: Thomas Hellstrom
Cc: Eric W. Biederman; Linux kernel mailing list; Siddha, Suresh B; Nick Piggin
Subject: Re: 2.6.29 pat issue

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

OK.


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


No. 
We get the warning when we insert RAM pages using vm_insert_pfn().
Having normal RAM pages backing a PFN papping is a valid thing.

Thanks,
/Thomas

Thanks,
Venki

