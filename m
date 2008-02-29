Return-Path: <linux-kernel-owner+w=401wt.eu-S1762234AbYB2AkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762234AbYB2AkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbYB2AkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:40:08 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:52222
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbYB2AkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:40:07 -0500
Date: Fri, 29 Feb 2008 01:40:01 +0100
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
Message-ID: <20080229004001.GN8091@v2.random>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random> <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random> <20080220103942.GU7128@v2.random> <20080221045430.GC15215@wotan.suse.de> <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com> <20080227192610.GF28483@v2.random> <Pine.LNX.4.64.0802281456200.1152@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802281456200.1152@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 03:05:30PM -0800, Christoph Lameter wrote:
> Still think that the lock here is not of too much use and can be easily 
> replaced by mmap_sem.

I can use the mmap_sem.

> > +#define mmu_notifier(function, mm, args...)				\
> > +	do {								\
> > +		struct mmu_notifier *__mn;				\
> > +		struct hlist_node *__n;					\
> > +									\
> > +		if (unlikely(!hlist_empty(&(mm)->mmu_notifier.head))) { \
> > +			rcu_read_lock();				\
> > +			hlist_for_each_entry_rcu(__mn, __n,		\
> > +						 &(mm)->mmu_notifier.head, \
> > +						 hlist)			\
> > +				if (__mn->ops->function)		\
> > +					__mn->ops->function(__mn,	\
> > +							    mm,		\
> > +							    args);	\
> > +			rcu_read_unlock();				\
> > +		}							\
> > +	} while (0)
> 
> Andrew recomended local variables for parameters used multile times. This 
> means the mm parameter here.

I don't exactly see what "buggy macro" meant? I already use
parenthesis as needed to avoid the need of local variables to be
safe. Not really sure what's buggy, sorry!

> Note also Andrew's comments on the use of 0x00ff...

I thought I tried the (void) but it didn't work and your solution
worked, but perhaps I did something wrong, I'll try again with (void)
nevertheless.

> > +/*
> > + * No synchronization. This function can only be called when only a single
> > + * process remains that performs teardown.
> > + */
> > +void mmu_notifier_release(struct mm_struct *mm)
> > +{
> > +	struct mmu_notifier *mn;
> > +	struct hlist_node *n, *tmp;
> > +
> > +	if (unlikely(!hlist_empty(&mm->mmu_notifier.head))) {
> > +		hlist_for_each_entry_safe(mn, n, tmp,
> > +					  &mm->mmu_notifier.head, hlist) {
> > +			hlist_del(&mn->hlist);
> > +			if (mn->ops->release)
> > +				mn->ops->release(mn, mm);
> > +		}
> > +	}
> > +}
> 
> One could avoid a hlist_for_each_entry_safe here by simply always deleting 
> the first object. 

Agreed, the current construct come from the fact we previously didn't
assume nobody could ever call mmu_notifier_unregister by the time
mm_users is 0.

> Also re the _notify variants: The binding to pte_clear_flush_young etc 
> will become a problem for notifiers that want to sleep because 
> pte_clear_flush is usually called with the pte lock held. See f.e. 
> try_to_unmap_one, page_mkclean_one etc.

Calling __free_page out of the PT lock is much bigger
change. do_wp_page will require changes anyway when the sleepable
notifiers are merged.

> It would be better if the notifier calls could be moved outside of the 
> pte lock.

The point is that it can't make a difference right now, and my
objective was to avoid unnecessary source code duplication (later it
will be necessary, right now it isn't). By the time you rework
do_wp_page, removing _notify will be a very minor detail compared to
the rest of the changes to do_wp_page IMHO. Expanding it now won't
provide a real advantage later.
