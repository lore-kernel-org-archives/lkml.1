Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbZEFNK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbZEFNK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 09:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756557AbZEFNKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 09:10:50 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:47487 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbZEFNKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 09:10:49 -0400
Date: Wed, 6 May 2009 12:16:52 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, aarcange@redhat.com, chrisw@redhat.com,
       alan@lxorguk.ukuu.org.uk, device@lanana.org, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 3/6] ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
In-Reply-To: <4A014C7B.9080702@redhat.com>
Message-ID: <Pine.LNX.4.64.0905061110470.3519@blonde.anvils>
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com>
 <1241475935-21162-2-git-send-email-ieidus@redhat.com>
 <1241475935-21162-3-git-send-email-ieidus@redhat.com>
 <1241475935-21162-4-git-send-email-ieidus@redhat.com> <4A00DF9B.1080501@redhat.com>
 <4A014C7B.9080702@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Izik Eidus wrote:
> Rik van Riel wrote:
> >
> > This is different from munmap and madvise, which take both
> > start address and length.
> >
> > Why?
> >
> It work like free, considering the fact that we dont allow memory overlay in
> no way,
> If we have the start of the address it is enough for us to know what memory we
> want to remove.
> 
> Isnt interface for userspace that work like malloc / free is enough?

I'm afraid not.

There's an (addr, length) consistency throughout the mm system calls -
mmap munmap mlock munlock mprotect msync madvise, even mincore and mremap
- that we ought not to depart from lightly.  And those (addr, length)s
are allowed to break into and span the original mmaps (excepting mremap).

Getting an fd from /dev/ksm, using that in an ioctl to get another fd
(eh?), using that in a further ioctl to specify an addr and number of
pages, may well have been a good interface for getting this working out
of tree, as an adjunct of KVM.  But you've done too well at selling KSM
as more generally useful than that: it is good work, I'm liking it, but
if it's going to mainline, then it needs an appropriate user interface.

I'm very much with those who suggested an madvise(), for which Chris
prepared a patch.  I know Andrea felt uneasy with an madvise() going
to a possibly-configured-out-or-never-loaded module, but it is just
advice, so I don't have a problem with that myself, so long as it
is documented in the manpage.

Whereas I do worry just what capability should be required for this:
can't a greedy app simply fork itself, touch all its pages, and thus
lock itself into memory in this way?  And I do worry about the cpu
cost of all the scanning, if it were to get used more generally -
it would be a pity if we just advised complainers to tune it out.

I'm still working my way through ksm.c, and not gone back to look at
Chris's madvise patch, but doubt it will be sufficient.  There's an
interesting difference between what you're doing in ksm.c, and how
madvise usually behaves, regarding unmapped areas: madvice doesn't
usually apply to an unmapped area, and goes away with an area when
it is unmapped; whereas in KSM's case, the advice applies to whatever
happens to get mapped in the area specified, persisting across unmaps.

If KSM is to behave in the usual madvise way, it'll need to be informed
of unmaps.  And I suspect it may need to be informed of them, even if we
let it continue to apply to empty address space.  Because even with your
more limited unsigned int nrpages interface, the caller can specify an
enormous range on 64-bit, and ksm.c be fully occupied just incrementing
from one absent page to the next.  mmap's vma ranges confine the space
to be searched, and instantiated pagetables confine it further: I think
you're either going to need to rely upon those to confine your search
area, or else enhance your own data structures to confine it.

But I do appreciate the separation you've kept so far,
and wouldn't want to tie it all together too closely.

Hugh

p.s.  I wish you'd chosen different name than KSM - the kernel
has supported shared memory for many years - and notice ksm.c itself
says "Memory merging driver".  "Merge" would indeed have been a less
ambiguous term than "Share", but I think too late to change that now
- except possibly in the MADV_ flag names?
