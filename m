Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbYDBWgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbYDBWgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbYDBWgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:36:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39261 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754912AbYDBWgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:36:36 -0400
Date: Wed, 2 Apr 2008 15:34:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: akpm@linux-foundation.org, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1 of 8] Core of mmu notifiers
In-Reply-To: <a406c0cc686d0ca94a4d.1207171802@duo.random>
Message-ID: <Pine.LNX.4.64.0804021527370.31603@schroedinger.engr.sgi.com>
References: <a406c0cc686d0ca94a4d.1207171802@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Andrea Arcangeli wrote:

> +	void (*invalidate_page)(struct mmu_notifier *mn,
> +				struct mm_struct *mm,
> +				unsigned long address);
> +
> +	void (*invalidate_range_start)(struct mmu_notifier *mn,
> +				       struct mm_struct *mm,
> +				       unsigned long start, unsigned long end);
> +	void (*invalidate_range_end)(struct mmu_notifier *mn,
> +				     struct mm_struct *mm,
> +				     unsigned long start, unsigned long end);

Still two methods ...

> +void __mmu_notifier_release(struct mm_struct *mm)
> +{
> +	struct mmu_notifier *mn;
> +	unsigned seq;
> +
> +	seq = read_seqbegin(&mm->mmu_notifier_lock);
> +	while (unlikely(!hlist_empty(&mm->mmu_notifier_list))) {
> +		mn = hlist_entry(mm->mmu_notifier_list.first,
> +				 struct mmu_notifier,
> +				 hlist);
> +		hlist_del(&mn->hlist);
> +		if (mn->ops->release)
> +			mn->ops->release(mn, mm);
> +		BUG_ON(read_seqretry(&mm->mmu_notifier_lock, seq));
> +	}
> +}

seqlock just taken for checking if everything is ok?

> +
> +/*
> + * If no young bitflag is supported by the hardware, ->clear_flush_young can
> + * unmap the address and return 1 or 0 depending if the mapping previously
> + * existed or not.
> + */
> +int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
> +					unsigned long address)
> +{
> +	struct mmu_notifier *mn;
> +	struct hlist_node *n;
> +	int young = 0;
> +	unsigned seq;
> +
> +	seq = read_seqbegin(&mm->mmu_notifier_lock);
> +	do {
> +		hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_list, hlist) {
> +			if (mn->ops->clear_flush_young)
> +				young |= mn->ops->clear_flush_young(mn, mm,
> +								    address);
> +		}
> +	} while (read_seqretry(&mm->mmu_notifier_lock, seq));
> +

The critical section could be run multiple times for one callback which 
could result in multiple callbacks to clear the young bit. Guess not that 
big of an issue?

> +void __mmu_notifier_invalidate_page(struct mm_struct *mm,
> +					  unsigned long address)
> +{
> +	struct mmu_notifier *mn;
> +	struct hlist_node *n;
> +	unsigned seq;
> +
> +	seq = read_seqbegin(&mm->mmu_notifier_lock);
> +	do {
> +		hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_list, hlist) {
> +			if (mn->ops->invalidate_page)
> +				mn->ops->invalidate_page(mn, mm, address);
> +		}
> +	} while (read_seqretry(&mm->mmu_notifier_lock, seq));
> +}

Ok. Retry would try to invalidate the page a second time which is not a 
problem unless you would drop the refcount or make other state changes 
that require correspondence with mapping. I guess this is the reason 
that you stopped adding a refcount?

> +void __mmu_notifier_invalidate_range_start(struct mm_struct *mm,
> +				  unsigned long start, unsigned long end)
> +{
> +	struct mmu_notifier *mn;
> +	struct hlist_node *n;
> +	unsigned seq;
> +
> +	seq = read_seqbegin(&mm->mmu_notifier_lock);
> +	do {
> +		hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_list, hlist) {
> +			if (mn->ops->invalidate_range_start)
> +				mn->ops->invalidate_range_start(mn, mm,
> +								start, end);
> +		}
> +	} while (read_seqretry(&mm->mmu_notifier_lock, seq));
> +}

Multiple invalidate_range_starts on the same range? This means the driver 
needs to be able to deal with the situation and ignore the repeated 
call?

> +void __mmu_notifier_invalidate_range_end(struct mm_struct *mm,
> +				  unsigned long start, unsigned long end)
> +{
> +	struct mmu_notifier *mn;
> +	struct hlist_node *n;
> +	unsigned seq;
> +
> +	seq = read_seqbegin(&mm->mmu_notifier_lock);
> +	do {
> +		hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_list, hlist) {
> +			if (mn->ops->invalidate_range_end)
> +				mn->ops->invalidate_range_end(mn, mm,
> +							      start, end);
> +		}
> +	} while (read_seqretry(&mm->mmu_notifier_lock, seq));
> +}

Retry can lead to multiple invalidate_range callbacks with the same 
parameters? Driver needs to ignore if the range is already clear?
