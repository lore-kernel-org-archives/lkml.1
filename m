Return-Path: <linux-kernel-owner+w=401wt.eu-S1761311AbYB1VxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311AbYB1VxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbYB1VxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:53:04 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:60905
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbYB1VxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:53:02 -0500
Date: Thu, 28 Feb 2008 22:52:57 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>, Nick Piggin <npiggin@suse.de>,
       akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] mmu notifiers #v7
Message-ID: <20080228215257.GJ8091@v2.random>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random> <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random> <20080220103942.GU7128@v2.random> <20080221045430.GC15215@wotan.suse.de> <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com> <20080227192610.GF28483@v2.random> <Pine.LNX.4.64.0802281139250.30865@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802281139250.30865@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 11:48:10AM -0800, Christoph Lameter wrote:
> > make it work after the VM locking will be altered (for example the
    	    	       	      	      	      	       ^^^^^^^^^^^^^^^
> > CONFIG_XPMEM should also switch the mmu_register/unregister locking
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > from RCU to mutex as well). XPMEM then will only compile if
    ^^^^^^^^^^^^^^^^^^^^^^^^^
> > CONFIG_XPMEM=y and in turn the invalidate_range_* will support
> > scheduling inside.
> 
> This is not going to work even if the mutex would work as easily as you 
> think since the patch here still does an rcu_lock/unlock around a callback.

See underlined.

> > +struct mmu_notifier_ops {
> > +	/*
> > +	 * Called when nobody can register any more notifier in the mm
> > +	 * and after the "mn" notifier has been disarmed already.
> > +	 */
> > +	void (*release)(struct mmu_notifier *mn,
> > +			struct mm_struct *mm);
> 
> Who disarms the notifier? Why is the method not called to disarm the 
> notifier on exit?

The notifier is auto-disarmed by mmu_notifier_release, your patch
works the same way. ->release is further called just in case anybody
wants to know the notifier was disarmed.

> > @@ -2048,6 +2050,7 @@ void exit_mmap(struct mm_struct *mm)
> >  	vm_unacct_memory(nr_accounted);
> >  	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, 0);
> >  	tlb_finish_mmu(tlb, 0, end);
> > +	mmu_notifier_release(mm);
> 
> The release should be called much earlier to allow the driver to release 
> all resources in one go. This way each vma must be processed individually. 
> For our gobs of memory this method may create a scaling problem on exit().

Good point, it has to be called earlier for GRU, but it's not a
performance issue. GRU doesn't pin the pages so it should make the
global invalidate in ->release _before_ unmap_vmas. Linux can't fault
in the ptes anymore because mm_users is zero so there's no need of a
->release_begin/end, the _begin is enough.

In #v6 I was invalidating inside unmap_vmas so it was ok. The
performance issues you're talking about refers to #v6 I guess, for #v7
there's a single call.

Thanks!

diff --git a/mm/mmap.c b/mm/mmap.c
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2039,6 +2039,7 @@ void exit_mmap(struct mm_struct *mm)
 	unsigned long end;
 
 	/* mm's last user has gone, and its about to be pulled down */
+	mmu_notifier_release(mm);
 	arch_exit_mmap(mm);
 
 	lru_add_drain();
@@ -2050,7 +2051,6 @@ void exit_mmap(struct mm_struct *mm)
 	vm_unacct_memory(nr_accounted);
 	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, 0);
 	tlb_finish_mmu(tlb, 0, end);
-	mmu_notifier_release(mm);
 
 	/*
 	 * Walk the list again, actually closing and freeing it,
