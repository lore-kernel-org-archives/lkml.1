Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbYBPT1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbYBPT1A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbYBPT0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:26:53 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57606 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755079AbYBPT0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:26:52 -0500
Date: Sat, 16 Feb 2008 11:26:51 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <20080215193730.709c67ea.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802161122350.25573@schroedinger.engr.sgi.com>
References: <20080215064859.384203497@sgi.com> <20080215064932.620773824@sgi.com>
 <20080215193730.709c67ea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008, Andrew Morton wrote:

> On Thu, 14 Feb 2008 22:49:01 -0800 Christoph Lameter <clameter@sgi.com> wrote:
> 
> > The invalidation of address ranges in a mm_struct needs to be
> > performed when pages are removed or permissions etc change.
> 
> hm.  Do they?  Why?  If I'm in the process of zero-copy writing a hunk of
> memory out to hardware then do I care if someone write-protects the ptes?
> 
> Spose so, but some fleshing-out of the various scenarios here would clarify
> things.

You care f.e. if the VM needs to writeprotect a memory range and a write 
occurs. In that case the VM needs to be proper write processing and write 
through an external pte would cause memory corruption.

> > If invalidate_range_begin() is called with locks held then we
> > pass a flag into invalidate_range() to indicate that no sleeping is
> > possible. Locks are only held for truncate and huge pages.
> 
> This is so bad.

Ok so I can twidlle around with the inode_mmap_lock to drop it while this 
is called?

> > In two cases we use invalidate_range_begin/end to invalidate
> > single pages because the pair allows holding off new references
> > (idea by Robin Holt).
> 
> Assuming that there is a missing "within the range" in this description, I
> assume that all clients will just throw up theior hands in horror and will
> disallow all references to all parts of the mm.

Right. Missing within the range. We only need to disallow creating new 
ptes right? Why disallow references?
 

> > xip_unmap: We are not taking the PageLock so we cannot
> > use the invalidate_page mmu_rmap_notifier. invalidate_range_begin/end
> > stands in.
> 
> What does "stands in" mean?

Use a range begin / end to invalidate a page.

> > +	mmu_notifier(invalidate_range_begin, mm, start, start + size, 0);
> >  	err = populate_range(mm, vma, start, size, pgoff);
> > +	mmu_notifier(invalidate_range_end, mm, start, start + size, 0);
> 
> To avoid off-by-one confusion the changelogs, documentation and comments
> should be very careful to tell the reader whether the range includes the
> byte at start+size.  I don't thik that was done?

No it was not. I assumed that the convention is always start - (end - 1) 
and the byte at end is not affected by the operation.

