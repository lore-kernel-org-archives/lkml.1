Return-Path: <linux-kernel-owner+w=401wt.eu-S932968AbXBWVXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbXBWVXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 16:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933212AbXBWVXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 16:23:24 -0500
Received: from mail.screens.ru ([213.234.233.54]:48166 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932968AbXBWVXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 16:23:23 -0500
Date: Sat, 24 Feb 2007 00:23:03 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Hugh Dickins <hugh@veritas.com>
Cc: dipankar@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: PREEMPT_RCU breaks anon_vma locking ?
Message-ID: <20070223212303.GA423@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If my understanding correct, vmscan can find a page which lives in a already
anon_vma_unlink'ed vma. This is ok, the page is pinned, and page->mapping is
not cleared until free_hot_cold_page().

So page_lock_anon_vma() works correctly due to SLAB_DESTROY_BY_RCU even if
anon_vma_unlink() has already freed anon_vma. In that case we should see
list_empty(&anon_vma->head), we are safe.

However, we are doing spin_unlock(anon_vma->lock) after page_lock_anon_vma(),
and this looks unsafe to me because page_lock_anon_vma() does rcu_read_unlock()
on return.

This worked before because spin_lock() implied rcu_read_lock(), so rcu was
blocked if page_lock_anon_vma() returns !NULL. With CONFIG_PREEMPT_RCU this
is not true (yes?), so it is possible that the slab returns the memory to
the system and it is re-used when we write to anon_vma->lock.

IOW, don't we need something like this

	static struct anon_vma *page_lock_anon_vma(struct page *page)
	{
		struct anon_vma *anon_vma;
		unsigned long anon_mapping;

		rcu_read_lock();
		anon_mapping = (unsigned long) page->mapping;
		if (!(anon_mapping & PAGE_MAPPING_ANON))
			goto out;
		if (!page_mapped(page))
			goto out;

		anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
		spin_lock(&anon_vma->lock);
		return anon_vma;

	out:
		rcu_read_unlock();
		return NULL;
	}

	static inline void page_lock_anon_vma(struct anon_vma *anon_vma)
	{
		spin_unlock(&anon_vma->lock);
		rcu_read_unlock();
	}
?

Oleg.

