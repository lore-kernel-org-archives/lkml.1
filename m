Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbYAVT32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbYAVT32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYAVT3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:29:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbYAVT3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:29:20 -0500
Subject: Re: [PATCH] mmu notifiers #v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Izik Eidus <izike@qumranet.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>,
       clameter@sgi.com, daniel.blueman@quadrics.com, holt@sgi.com,
       steiner@sgi.com, Andrew Morton <akpm@osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20080121125204.GJ6970@v2.random>
References: <20080113162418.GE8736@v2.random>
	 <20080116124256.44033d48@bree.surriel.com> <478E4356.7030303@qumranet.com>
	 <20080117162302.GI7170@v2.random> <478F9C9C.7070500@qumranet.com>
	 <20080117193252.GC24131@v2.random>  <20080121125204.GJ6970@v2.random>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 20:28:47 +0100
Message-Id: <1201030127.6341.39.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-21 at 13:52 +0100, Andrea Arcangeli wrote:

> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> new file mode 100644
> --- /dev/null
> +++ b/include/linux/mmu_notifier.h
> @@ -0,0 +1,79 @@
> +#ifndef _LINUX_MMU_NOTIFIER_H
> +#define _LINUX_MMU_NOTIFIER_H
> +
> +#include <linux/list.h>
> +#include <linux/spinlock.h>
> +
> +#ifdef CONFIG_MMU_NOTIFIER
> +
> +struct mmu_notifier;
> +
> +struct mmu_notifier_ops {
> +	void (*release)(struct mmu_notifier *mn,
> +			struct mm_struct *mm);
> +	void (*age_page)(struct mmu_notifier *mn,
> +			 struct mm_struct *mm,
> +			 unsigned long address);
> +	void (*invalidate_page)(struct mmu_notifier *mn,
> +				struct mm_struct *mm,
> +				unsigned long address);
> +	void (*invalidate_range)(struct mmu_notifier *mn,
> +				 struct mm_struct *mm,
> +				 unsigned long start, unsigned long end);
> +};
> +
> +struct mmu_notifier_head {
> +	struct hlist_head head;
> +	rwlock_t lock;

	spinlock_t lock;

I think we can get rid of this rwlock as I think this will seriously
hurt larger machines.

> +};
> +
> +struct mmu_notifier {
> +	struct hlist_node hlist;
> +	const struct mmu_notifier_ops *ops;
> +};
> +
> +#include <linux/mm_types.h>
> +
> +extern void mmu_notifier_register(struct mmu_notifier *mn,
> +				  struct mm_struct *mm);
> +extern void mmu_notifier_unregister(struct mmu_notifier *mn,
> +				    struct mm_struct *mm);
> +extern void mmu_notifier_release(struct mm_struct *mm);
> +
> +static inline void mmu_notifier_head_init(struct mmu_notifier_head *mnh)
> +{
> +	INIT_HLIST_HEAD(&mnh->head);
> +	rwlock_init(&mnh->lock);
> +}
> +
> +#define mmu_notifier(function, mm, args...)				\
> +	do {								\
> +		struct mmu_notifier *__mn;				\
> +		struct hlist_node *__n;					\
> +									\
> +		if (unlikely(!hlist_empty(&(mm)->mmu_notifier.head))) { \
> +			read_lock(&(mm)->mmu_notifier.lock);		\
			rcu_read_lock();
> +			hlist_for_each_entry(__mn, __n,			\
			hlist_for_each_entry_rcu
> +					     &(mm)->mmu_notifier.head,	\
> +					     hlist)			\
> +				if (__mn->ops->function)		\
> +					__mn->ops->function(__mn,	\
> +							    mm,		\
> +							    args);	\
> +			read_unlock(&(mm)->mmu_notifier.lock);		\
			rcu_read_unlock();
> +		}							\
> +	} while (0)
> +
> +#else /* CONFIG_MMU_NOTIFIER */
> +
> +#define mmu_notifier_register(mn, mm) do {} while(0)
> +#define mmu_notifier_unregister(mn, mm) do {} while (0)
> +#define mmu_notifier_release(mm) do {} while (0)
> +#define mmu_notifier_head_init(mmh) do {} while (0)
> +
> +#define mmu_notifier(function, mm, args...)	\
> +	do { } while (0)
> +
> +#endif /* CONFIG_MMU_NOTIFIER */
> +
> +#endif /* _LINUX_MMU_NOTIFIER_H */


> diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> new file mode 100644
> --- /dev/null
> +++ b/mm/mmu_notifier.c
> @@ -0,0 +1,44 @@
> +/*
> + *  linux/mm/mmu_notifier.c
> + *
> + *  Copyright (C) 2008  Qumranet, Inc.
> + *
> + *  This work is licensed under the terms of the GNU GPL, version 2. See
> + *  the COPYING file in the top-level directory.
> + */
> +
> +#include <linux/mmu_notifier.h>
> +#include <linux/module.h>
> +
> +void mmu_notifier_release(struct mm_struct *mm)
> +{
> +	struct mmu_notifier *mn;
> +	struct hlist_node *n, *tmp;
> +
> +	if (unlikely(!hlist_empty(&mm->mmu_notifier.head))) {
> +		read_lock(&mm->mmu_notifier.lock);
		rcu_read_lock();
> +		hlist_for_each_entry_safe(mn, n, tmp,
		hlist_for_each_entry_safe_rcu
> +					  &mm->mmu_notifier.head, hlist) {
> +			if (mn->ops->release)
> +				mn->ops->release(mn, mm);
> +			hlist_del(&mn->hlist);
			hlist_del_rcu
> +		}
> +		read_unlock(&mm->mmu_notifier.lock);
		rcu_read_unlock();
> +	}
> +}
> +
> +void mmu_notifier_register(struct mmu_notifier *mn, struct mm_struct *mm)
> +{
> +	write_lock(&mm->mmu_notifier.lock);
	spin_lock
> +	hlist_add_head(&mn->hlist, &mm->mmu_notifier.head);
	hlist_add_head_rcu
> +	write_unlock(&mm->mmu_notifier.lock);
	spin_unlock
> +}
> +EXPORT_SYMBOL_GPL(mmu_notifier_register);
> +
> +void mmu_notifier_unregister(struct mmu_notifier *mn, struct mm_struct *mm)
> +{
> +	write_lock(&mm->mmu_notifier.lock);
	spin_lock
> +	hlist_del(&mn->hlist);
	hlist_del_rcu
> +	write_unlock(&mm->mmu_notifier.lock);
	spin_unlock
> +}
> +EXPORT_SYMBOL_GPL(mmu_notifier_unregister);


#define hlist_for_each_entry_safe(tpos, pos, n, head, member) 		 \
	for (pos = (head)->first;					 \
	     rcu_dereference(pos) && ({ n = pos->next; 1; }) && 	 \
		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
	     pos = n)



