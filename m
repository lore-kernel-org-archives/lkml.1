Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYGEJpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYGEJpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 05:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYGEJpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 05:45:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:52832 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYGEJp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 05:45:29 -0400
Subject: Re: [PATCH] fix task dirty balancing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20080705150401.8bd28b71.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080702082644.BA45D5A17@siro.lan>
	 <1215030438.28676.20.camel@lappy.programming.kicks-ass.net>
	 <20080705150401.8bd28b71.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Sat, 05 Jul 2008 11:30:02 +0200
Message-Id: <1215250202.6320.10.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-05 at 15:04 +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 02 Jul 2008 22:27:18 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Wed, 2008-07-02 at 17:26 +0900, YAMAMOTO Takashi wrote:
> > > hi,
> > > 
> > > task_dirty_inc doesn't seem to be called properly for
> > > filesystems which don't use set_page_dirty for write(2).
> > > eg. ext2 w/o nobh option.
> > 
> > I'm thinking this is an ext2 bug. So I'd rather it'd just call
> > set_page_dirty() like a proper filesystem instead of doing things like
> > this.
> > 
> > And I certainly don't like exporting task_dirty_inc() - filesystems and
> > the like should not have to know about things like that.
> > 
> Hmm, a bit complicated for me.
> 
> At first, there are 2 __set_page_dirty() in the kernel.
>   - mm/page-writeback.c: __set_page_dirty()
>               .... set_page_dirty() calls this.
>   - fs/buffer.c : __set_page_dirty()
>               .... __set_page_dirty_buffers() and mark_buffer_dirty() calls this.
> 
> Why per-task dirty acconitng is done in mm/page-writeback.c::set_page_dirty() ?
> 
> It seems other accounting is done in the fs/buffer.c: __set_page_dirty()
> 
> The purpose of task-dirty accounting is different from others  ?
> 
> = fs/buffer.c
>  697 static int __set_page_dirty(struct page *page,
>  698                 struct address_space *mapping, int warn)
>  699 {
>  700         if (unlikely(!mapping))
>  701                 return !TestSetPageDirty(page);
>  702 
>  703         if (TestSetPageDirty(page))
>  704                 return 0;
>  705 
>  706         write_lock_irq(&mapping->tree_lock);
>  707         if (page->mapping) {    /* Race with truncate? */
>  708                 WARN_ON_ONCE(warn && !PageUptodate(page));
>  709 
>  710                 if (mapping_cap_account_dirty(mapping)) {
>  711                         __inc_zone_page_state(page, NR_FILE_DIRTY);
>  712                         __inc_bdi_stat(mapping->backing_dev_info,
>  713                                         BDI_RECLAIMABLE);
>  714                         task_io_account_write(PAGE_CACHE_SIZE);
>  715                 }
>  716                 radix_tree_tag_set(&mapping->page_tree,
>  717                                 page_index(page), PAGECACHE_TAG_DIRTY);
>  718         }
>  719         write_unlock_irq(&mapping->tree_lock);
>  720         __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>  721 
>  722         return 1;
> ==
> 
> And task-dirty-limit don't have to take care of following 2 case ?
>   - __set_page_dirty_nobuffers(struct page *page) (increment BDI_RECRAIMABLE)
>   - test_set_page_writeback() (increment BDI_RECLAIMABLE)


Gah - what a mess...

It's in set_page_dirty() so it wouldn't have to be in all the
a_ops->set_page_dirty() functions...

But now it turns out people don't use set_page_dirty() to dirty
pages :-(

For the purpose of task_dirty_inc() I guess we might as well pair it
with task_io_account_write() for each PAGE_CACHE_SIZE (and ignore the
DIO bit, since that doesn't care about the dirty limit anyway).

Might be my ignorance, but _why_ do we have __set_page_dirty_nobuffers()
reimplemented in fs/buffers.c:__set_page_dirty() ? - those two functions
look suspiciously similar.

Also, why was the EXPORT added anyway - fs/buffers.o never ends up in
modules?

Please beat me to cleaning up this stuff - otherwise I'll have to look
at it when I get back from holidays.

Peter

