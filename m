Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbZA3QjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbZA3QjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 11:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbZA3Qi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 11:38:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217AbZA3Qi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 11:38:58 -0500
Date: Fri, 30 Jan 2009 08:36:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <gregkh@suse.de>
cc: Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <20090130055639.GA30950@suse.de>
Message-ID: <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com> <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain> <1233259410.2315.75.camel@lts-notebook> <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain> <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com> <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain> <20090130055639.GA30950@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Jan 2009, Greg KH wrote:
> 
> Which version was the "non-cleanup" version that should be added to the
> stable trees?

There were two different versions:

	From: Andrew Morton <akpm@linux-foundation.org>
	Subject: Re: possible bug in mmap_region() in linux-2.6.28 kernel
	Message-Id: <20090128134350.034ac6a7.akpm@linux-foundation.org>

	From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
	Subject: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED file segments
	Message-Id: <1233259410.2315.75.camel@lts-notebook>

and I'm actually not at all sure which one should go into stable (or if we 
should just pick the same one that went into mainline). 

> The commit you did make, de33c8db5910cda599899dd431cc30d7c1018cbf,
> seemed pretty "tiny" to me.

Oh, yes, in m any ways it's smaller than the trivial patches, since it's 
really just removing code (well, it adds "file" as a parameter to the 
first vma_merge, it used to always be NULL since we only did that for the 
"!file" case).

The downside with that commit is simply that there is a (pretty damn 
small, imho) possibility that somebody will report a regression with it, 
and we'll have to add some appropriate

	vma->vm_flags |= VM_IO | VM_DONTEXPAND;

to some odd special device driver, to make sure that it cannot trigger the 
"merge early" case because it needs its ->mmap() function called, rather 
than just expand the mapping quietly.

The reason(s) I don't think it's very likely is that

 (a) hopefully drivers already explicitly mark their mappings with one of 
     the VM_SPECIAL bits already. 

     Most such drivers would likely want to use "vm_insert_pfn()" (to 
     insert random IO pages into the mapping), and in order to do that 
     they have to add the VM_PFNMAP to vm_flags - we check. That would 
     disable any merging, because that flag won't be set in the new vma 
     before calling ->mmap.

 (b) even if the drivers don't do that explicit VM_PFNMAP, a driver that 
     does special things at mmap() time - even if it just uses regular 
     pages - probably prepopulates its mmap area with vm_insert_page().

     That in turn, will implicitly set VM_INSERTPAGE, and again: the 
     merge logic that verifies that the old vma->vm_flags == vm_flags (in 
     is_mergeable_vma) would disable merging.

 (c) finally - even if a merge really would be possible (ie vm_flags 
     didn't really get changed by the special ->mmap() function, but the 
     driver still depended on ->mmap() being called for some other 
     reason), I suspect it is really really unlikely that any application 
     would actually request two magic consecutive mmap's to the same 
     special device, with the same permissions and with just the right 
     pgoff values etc. IOW, even if a merge could happen in theory with a 
     flaky driver that doesn't like it, I don't think we'd hit it in 
     practice.

So I feel I had pretty good reasons to say "f*ck it, I'm going to fix this 
properly in mainline with a much prettier patch". 

But none of the above really changes the fact that the patch I committed 
to mainline was really quite fundamentally more invasive than either of 
the "simple" patches. All three patches are small, with mine arguably the 
smallest of the lot, but mine actually changed semantics, while Andrew's 
and Lee's patch literally only fix the invalid pointer use.

I'll leave it to others to decide which one goes into -stable. I 
personally don't really think it matters. I argue above that mine is 
pretty safe and thus perfectly fine even for -stable, but reality has a 
habit of sometimes disagreeing with me. Dang.

				Linus
