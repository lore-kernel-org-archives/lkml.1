Return-Path: <linux-kernel-owner+w=401wt.eu-S932868AbXBXWEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbXBXWEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 17:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932870AbXBXWEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 17:04:23 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:41415 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868AbXBXWEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 17:04:21 -0500
X-AuditID: d80ac287-9d799bb000002978-36-45e0b6501064 
Date: Sat, 24 Feb 2007 22:04:04 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, dipankar@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: PREEMPT_RCU breaks anon_vma locking ?
In-Reply-To: <20070223212303.GA423@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0702242203080.4370@blonde.wat.veritas.com>
References: <20070223212303.GA423@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 24 Feb 2007 22:03:59.0888 (UTC) FILETIME=[AFDB7100:01C7585F]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007, Oleg Nesterov wrote:

> If my understanding correct, vmscan can find a page which lives in a already
> anon_vma_unlink'ed vma. This is ok, the page is pinned, and page->mapping is
> not cleared until free_hot_cold_page().

That's about right.  The page_mapped checks, at several levels, make
it very hard to hit this case in practice; but it is possible for the
page to be unmapped and the anon_vma unlinked and kmem_cache_freed
while vmscan is racing through page_lock_anon_vma.

> 
> So page_lock_anon_vma() works correctly due to SLAB_DESTROY_BY_RCU even if
> anon_vma_unlink() has already freed anon_vma. In that case we should see
> list_empty(&anon_vma->head), we are safe.

(It doesn't affect your argument, but we won't necessarily see list_empty
there: the anon_vma slot may already have got reused for a different
bundle of vmas completely; but its lock remains a lock and its list
remains a list of vmas, and the worst that happens is that
page_referenced_anon or try_to_unmap_anon wanders through an irrelevant
bundle of vmas, looking for a page that cannot be found there.)

> 
> However, we are doing spin_unlock(anon_vma->lock) after page_lock_anon_vma(),
> and this looks unsafe to me because page_lock_anon_vma() does rcu_read_unlock()
> on return.
> 
> This worked before because spin_lock() implied rcu_read_lock(), so rcu was
> blocked if page_lock_anon_vma() returns !NULL. With CONFIG_PREEMPT_RCU this
> is not true (yes?), so it is possible that the slab returns the memory to
> the system and it is re-used when we write to anon_vma->lock.

I had been meaning to take a fresh look at page_lock_anon_vma, to see
whether recent RCU developments in -mm affected it.  Thanks for saving
me the trouble.

You and Paul know infinitely more about CONFIG_PREEMPT_RCU than I do,
so if you believe that the change below is enough, that's great, it's
much simpler than I'd feared might be needed.  CONFIG_PREEMPT_RCU
rather scares me, but perhaps it's less worrying than I'd imagined.

Have you checked through the SLAB_DESTROY_BY_RCU end in slab.c?
Is what that's doing still valid?

> 
> IOW, don't we need something like this
> 
> 	static struct anon_vma *page_lock_anon_vma(struct page *page)
> 	{
> 		struct anon_vma *anon_vma;
> 		unsigned long anon_mapping;
> 
> 		rcu_read_lock();
> 		anon_mapping = (unsigned long) page->mapping;
> 		if (!(anon_mapping & PAGE_MAPPING_ANON))
> 			goto out;
> 		if (!page_mapped(page))
> 			goto out;
> 
> 		anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
> 		spin_lock(&anon_vma->lock);
> 		return anon_vma;
> 
> 	out:
> 		rcu_read_unlock();
> 		return NULL;
> 	}
> 
> 	static inline void page_lock_anon_vma(struct anon_vma *anon_vma)

It might be wiser to call that one page_unlock_anon_vma ;)

(I'm slightly disgruntled that page_lock_anon_vma takes a struct page *,
but page_unlock_anon_vma no struct page *.  But it would be silly to do
it differently, or mess with the naming: besides, it's a static function
and the prototype guards against error anyway.)

> 	{
> 		spin_unlock(&anon_vma->lock);
> 		rcu_read_unlock();
> 	}
> ?

Looks fine to me: please go ahead a make a patch for -mm, Oleg: thanks.

I've CC'ed Christoph for several reasons.

One, I think he was trying to persuade me a year ago to change
page_lock_anon_vma as you're now proposing; but I resisted, preferring
to keep the RCU stuff self-contained within page_lock_anon_vma: let's
credit him for prescience, and admit you've proved me wrong.

Two, in his SLUB thread it sounds like he's toying with mixing up kmem
caches of similar sizes: that seems a really bad idea to me (for reasons
Andi and others have made) and I expect it'll get dropped; but in case
not, let's note that the anon_vma cache is one which would fare very
badly from getting mixed in with others (lock would no longer remain
a lock, list would no longer remain a list, across that race).

Three, he has a recurring interest in this unusual page_lock_anon_vma,
mainly for page migration reasons, so let's keep him informed.

Hugh
