Return-Path: <linux-kernel-owner+w=401wt.eu-S1761592AbYENQWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761592AbYENQWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 12:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYENQWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 12:22:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48845 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751152AbYENQW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 12:22:29 -0400
Date: Wed, 14 May 2008 11:22:24 -0500
From: Robin Holt <holt@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrea Arcangeli <andrea@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
Message-ID: <20080514162223.GZ9878@sgi.com>
References: <6b384bb988786aa78ef0.1210170958@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080508003838.GA9878@sgi.com> <200805132206.47655.nickpiggin@yahoo.com.au> <20080513153238.GL19717@sgi.com> <20080514041122.GE24516@wotan.suse.de> <20080514112625.GY9878@sgi.com> <alpine.LFD.1.10.0805140807400.3019@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805140807400.3019@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 08:18:21AM -0700, Linus Torvalds wrote:
>
>
> On Wed, 14 May 2008, Robin Holt wrote:
> >
> > Are you suggesting the sending side would not need to sleep or the
> > receiving side?
>
> One thing to realize is that most of the time (read: pretty much *always*)
> when we have the problem of wanting to sleep inside a spinlock, the
> solution is actually to just move the sleeping to outside the lock, and
> then have something else that serializes things.
>
> That way, the core code (protected by the spinlock, and in all the hot
> paths) doesn't sleep, but the special case code (that wants to sleep) can
> have some other model of serialization that allows sleeping, and that
> includes as a small part the spinlocked region.
>
> I do not know how XPMEM actually works, or how you use it, but it
> seriously sounds like that is how things *should* work. And yes, that
> probably means that the mmu-notifiers as they are now are simply not
> workable: they'd need to be moved up so that they are inside the mmap
> semaphore but not the spinlocks.

We are in the process of attempting this now.  Unfortunately for SGI,
Christoph is on vacation right now so we have been trying to work it
internally.

We are looking through two possible methods, one we add a callout to the
tlb flush paths for both the mmu_gather and flush_tlb_page locations.
The other we place a specific callout seperate from the gather callouts
in the paths we are concerned with.  We will look at both more carefully
before posting.


In either implementation, not all call paths would require the stall
to ensure data integrity.  Would it be acceptable to always put a
sleepable stall in even if the code path did not require the pages be
unwritable prior to continuing?  If we did that, I would be freed from
having a pool of invalidate threads ready for XPMEM to use for that work.
Maybe there is a better way, but the sleeping requirement we would have
on the threads make most options seem unworkable.


Thanks,
Robin
