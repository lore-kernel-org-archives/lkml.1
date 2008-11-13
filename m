Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbYKMECj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbYKMECj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 23:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYKMEC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 23:02:27 -0500
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:43949 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751006AbYKMEC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 23:02:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=e2ZF5xTYhpUyvRRLSIQL1I9zyyPmimudfDVQ05Xz2GE+SNyOpnVwgMBeH5r9i7hfx3fq499lKcJIAf5PS+txCcRDypBZT7h4PPCg87mSY8UoVxnzTlJN8Y56sr+WaYEkGuw6/0yeAZhrExArEx++6ofJeBdI9cHRVGOOshk1ey8=  ;
X-YMail-OSG: KU9RSN4VM1ndO5_bdveoywQKlxcAf5AMGFliwEJbLHdi4gF.GNSqfXjprhoSgFsPFH1FSJwewDWfJ3jJWASQcmrA0mEujckgyw2u.GkI5jAHN2YXFzTiDEPabImKhFx78df4wPoXCJ6GFTTRChlp7MStJpFZc.K8zFOxDMI2
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 2/4] Add replace_page(), change the mapping of pte from one page into another
Date: Thu, 13 Nov 2008 15:02:19 +1100
User-Agent: KMail/1.9.5
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, chrisw@redhat.com,
       avi@redhat.com, izike@qumranet.com
References: <20081111221753.GK10818@random.random> <20081113020059.GC10818@random.random> <20081113023135.GD10818@random.random>
In-Reply-To: <20081113023135.GD10818@random.random>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811131502.20102.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2008 13:31, Andrea Arcangeli wrote:
> On Thu, Nov 13, 2008 at 03:00:59AM +0100, Andrea Arcangeli wrote:
> > CPU0 migrate.c			CPU1 filemap.c
> > -------				----------
> > 				find_get_page
> > 				radix_tree_lookup_slot returns the oldpage
> > page_count still = expected_count
> > freeze_ref (oldpage->count = 0)
> > radix_tree_replace (too late, other side already got the oldpage)
> > unfreeze_ref (oldpage->count = 2)
> > 				page_cache_get_speculative(old_page)
> > 				set count to 3 and succeeds
>
> After reading more of this lockless radix tree code, I realized this
> below check is the one that was intended to restart find_get_page and
> prevent it to return the oldpage:
>
> 				    if (unlikely(page != *pagep)) {
>
> But there's no barrier there, atomic_add_unless would need to provide
> an atomic smp_mb() _after_ atomic_add_unless executed. In the old days
> the atomic_* routines had no implied memory barriers, you had to use
> smp_mb__after_atomic_add_unless if you wanted to avoid the race. I
> don't see much in the ppc implementation of atomic_add_unless that
> would provide an implicit smb_mb after the page_cache_get_speculative
> returns, so I can't see why the pagep can't be by find_get_page read
> before the other cpu executes radix_tree_replace in the above
> timeline.

All atomic functions that both return a value and modify their memory
are defined to provide full barriers before and after the operation.

powerpc should be OK

        __asm__ __volatile__ (
        LWSYNC_ON_SMP
"1:     lwarx   %0,0,%1         # atomic_add_unless\n\
        cmpw    0,%0,%3 \n\
        beq-    2f \n\
        add     %0,%2,%0 \n"
        PPC405_ERR77(0,%2)
"       stwcx.  %0,0,%1 \n\
        bne-    1b \n"
        ISYNC_ON_SMP
"       subf    %0,%2,%0 \n\
2:"
        : "=&r" (t)
        : "r" (&v->counter), "r" (a), "r" (u)
        : "cc", "memory");

lwsync instruction prevents all reorderings except allows loads to
pass stores. But because it is followed by a LL/SC sequence, the
store part of that sequence is prevented from passing stores, so
therefore it will fail if the load had executed earlier and the
value has changed.

isync prevents speculative execution, so the branch has to be
resolved before any subsequent instructions start. The branch
depends on the result of the LL/SC, so that has to be complete.

So that prevents loads from passing the LL/SC.

For the SC to complete, I think by definition the store has to be
visible, because it has to check the value has not changed (so it
would have to own the cacheline).

I think that's how it works. I'm not an expert at powerpc's weird
barriers, but I'm pretty sure they work.


> I guess you intended to put an smp_mb() in between the
> page_cache_get_speculative and the *pagep to make the code safe on ppc
> too, but there isn't, and I think it must be fixed, either that or I
> don't understand ppc assembly right. The other side has a smp_wmb
> implicit inside radix_tree_replace_slot so it should be ok already to
> ensure we see the refcount going to 0 before we see the pagep changed
> (the fact the other side has a memory barrier, further confirms this
> side needs it too).

I think it is OK. It should have a comment there however to say it
relies on a barrier in get_page_unless_zero (I thought I had one..)
