Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbZBNVMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbZBNVMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbZBNVLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:11:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:46175 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZBNVLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:11:43 -0500
Subject: Re: [patch 2/4] vfs: add set_page_dirty_notag
From: Peter Zijlstra <peterz@infradead.org>
To: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Ryan Hope <rmh3093@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
In-Reply-To: <18838.49922.215481.399653@edward.zelnet.ru>
References: <18837.24581.181196.569183@edward.zelnet.ru>
	 <1234530519.6519.46.camel@twins> <49957C43.7050701@gmail.com>
	 <1234534150.6519.101.camel@twins>
	 <18838.49922.215481.399653@edward.zelnet.ru>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 22:11:33 +0100
Message-Id: <1234645893.4695.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-14 at 16:11 +0300, Edward Shishkin wrote:
> Peter Zijlstra writes:
>  > On Fri, 2009-02-13 at 16:57 +0300, Edward Shishkin wrote:
>  > > >
>  > > > Eew, so reiser4 will totally side-step the regular vm inode
>  > > writeback
>  > > > paths -- or is this fixed by a more elaborate than usual
>  > > > a_ops->writepages() ?
>  > > >   
>  > > The second.
>  > > 
>  > > reiser4_writepages() catches the anonymous  (tagged)
>  > > pages, captures them mandatory, then commits all atoms
>  > > of the file.
>  > 
>  > OK, can you then make it painfully clear in the function comment, esp.
>  > since you export this function?
> 
> Hello.
> Does it look better?
> 
> Thanks,
> Edward.
> 
> This is a fixup for the following "todo":
> akpm wrote:
> > reiser4_set_page_dirty_internal() pokes around in VFS internals.
> > Use __set_page_dirty_no_buffers() or create a new library function
> > in mm/page-writeback.c.
> 
> Problem:
> 
> In accordance with reiser4 transactional model every dirty page
> should be "captured" by some atom. However, outside reiser4 context
> dirty page can not be captured in some cases, as it is accompanied
> with specific work (jnode creation, etc). Reiser4 recognizes such
> "anonymous" pages (i.e. pages that were dirtied outside of reiser4)
> by the tag PAGECACHE_TAG_DIRTY. Pages dirtied inside reiser4 context
> are not tagged at all: we don't need this. Indeed, once page is
> dirtied and captured, it is attached to a jnode (a special header
> to keep a track of transactions).
> 
> reiser4_set_page_dirty_internal() was the internal reiser4 function
> that set dirty bit without tagging the page. Having such internal
> function led to real problems (incorrect task io accounting, etc.
> because of not updating this internal "friend").
> 
> Solution:
> 
> The following patch adds a core library function that sets a dirty
> bit without tagging the page. It should be modified simultaneously
> with its "friends": __set_page_dirty_nobuffers, __set_page_dirty.
> 
> Signed-off-by: Edward Shishkin<edward.shishkin@gmail.com>
> ---
>  include/linux/mm.h  |    1 +
>  mm/page-writeback.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+)
> 
> --- mmotm.orig/include/linux/mm.h
> +++ mmotm/include/linux/mm.h
> @@ -841,6 +841,7 @@ int redirty_page_for_writepage(struct wr
>  				struct page *page);
>  int set_page_dirty(struct page *page);
>  int set_page_dirty_lock(struct page *page);
> +int set_page_dirty_notag(struct page *page);
>  int clear_page_dirty_for_io(struct page *page);
>  
>  extern unsigned long move_page_tables(struct vm_area_struct *vma,
> --- mmotm.orig/mm/page-writeback.c
> +++ mmotm/mm/page-writeback.c
> @@ -1248,6 +1248,46 @@ int __set_page_dirty_nobuffers(struct pa
>  EXPORT_SYMBOL(__set_page_dirty_nobuffers);
>  
>  /*
> + * Some filesystems, which don't use buffers, provide their own
> + * writeback means. And it can happen, that even dirty tag, which
> + * is used by generic methods is not needed. In this case it would
> + * be reasonably to use the following lightweight version of
> + * __set_page_dirty_nobuffers:
> + *
> + * Don't tag page as dirty in its radix tree, just set dirty bit
> + * and update the accounting.
> + * NOTE: This function also doesn't take care of races, i.e. the
> + * caller should guarantee that page can not be truncated.
> + */

Maybe something like

/*
 * set_page_dirty_notag() -- similar to __set_page_dirty_nobuffers()
 * except it doesn't tag the page dirty in the page-cache radix tree.
 * This means that the address space using this cannot use the regular
 * filemap ->writepages() helpers and must provide its own means of
 * tracking and finding dirty pages.
 *
 * NOTE: furthermore, this version also doesn't handle truncate races.
 */

> +int set_page_dirty_notag(struct page *page)
> +{
> +	struct address_space *mapping = page->mapping;
> +
> +	if (!TestSetPageDirty(page)) {
> +		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
> +		if (mapping_cap_account_dirty(mapping)) {
> +		        /*
> +			 * Since we don't tag the page as dirty,
> +			 * acquiring the tree_lock is replaced
> +			 * with disabling preemption to protect
> +			 * per-cpu data used for accounting.
> +			 */

This should be local_irq_save(flags)

> +			preempt_disable();
> +			__inc_zone_page_state(page, NR_FILE_DIRTY);
> +			__inc_bdi_stat(mapping->backing_dev_info,
> +				       BDI_RECLAIMABLE);
> +			task_dirty_inc(current);
> +			task_io_account_write(PAGE_CACHE_SIZE);
> +			preempt_enable();

local_irq_restore()

These accounting functions rely on being atomic wrt interrupts.

> +		}
> +		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> +		return 1;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(set_page_dirty_notag);

How much performance gain do you see by avoiding that radix tree op? 

I take it the only reason you don't use the regular
__set_page_dirty_nobuffers() and just clear the tag when you do the
write-out by whatever alternative means you have to find the page, is
that it gains you some performance.

It would be good to have some numbers to judge this on.

