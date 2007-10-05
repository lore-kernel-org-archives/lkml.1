Return-Path: <linux-kernel-owner+w=401wt.eu-S1763313AbXJEPeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763313AbXJEPeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbXJEPeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:34:09 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:61419 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983AbXJEPeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:34:08 -0400
Date: Fri, 5 Oct 2007 16:33:16 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Keir Fraser <keir@xensource.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
In-Reply-To: <C32BBF27.166CA%keir@xensource.com>
Message-ID: <Pine.LNX.4.64.0710051601430.14565@blonde.wat.veritas.com>
References: <C32BBF27.166CA%keir@xensource.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, Keir Fraser wrote:
> On 5/10/07 10:05, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:
> > Andi says:
> >> Do I misread that patch or does it really walk the complete address
> >> space and try to take all possible locks? Isn't that very slow?
> > 
> > That's pretty much what it has to do.  Pinning/unpinning walks the whole
> > pagetable anyway, so it shouldn't be much more expensive.  And they're
> > relatively rare operations (fork, exec, exit).
> 
> It is a shame to do 3x walks per pin or unpin, rather than 1x, though.
> 
> One way to improve this, possibly, is to pin the pte tables individually as
> you go, rather than doing one big pin/unpin just at the root pgd. Then you
> can lock/unlock the pte's as you go. I'd suggest that as a possible post
> 2.6.23 improvement, however. Jan's patch has actually had some testing.

A few points come to mind looking at Jan's patch:

The comment about nested pagetable locks is wrong: mm/mremap.c does
nest pagetable locks; but you wouldn't (as I understand it) be doing
this pinning/unpinning anywhere which could race with an mremap() on
the same mm, so that's a niggle about a comment, not a real issue.

Yes, it would be greatly preferable to take the locks one by one
as needed.  As it stands, I think you're in danger of overflowing
the PREEMPT_BITS 8 area of preempt_count(), venturing into the
SOFTIRQ area: I don't know the real-life consequence of that.

I don't see any protection against hugetlb areas, where the pmd
entry may indicate a hugetlb page rather than a pagetable page.
I guess you'll be needing to test pte_huge().  I don't know if
you want to lock those or skip them: locking is usually just
with page_table_lock, but beware there's also sharing of huge
page pmds between mms - Ken Chen should be able to help on that.

If a 2.6.23 fix is needed, I suggest simply excluding split ptlocks
in the Xen case, as shown by the mm/Kconfig - line in Jan's patch.

Hugh
