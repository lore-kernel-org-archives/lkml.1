Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYGEF6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYGEF6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 01:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbYGEF6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 01:58:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41981 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbYGEF6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 01:58:38 -0400
Date: Sat, 5 Jul 2008 15:04:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] fix task dirty balancing
Message-Id: <20080705150401.8bd28b71.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1215030438.28676.20.camel@lappy.programming.kicks-ass.net>
References: <20080702082644.BA45D5A17@siro.lan>
	<1215030438.28676.20.camel@lappy.programming.kicks-ass.net>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2008 22:27:18 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2008-07-02 at 17:26 +0900, YAMAMOTO Takashi wrote:
> > hi,
> > 
> > task_dirty_inc doesn't seem to be called properly for
> > filesystems which don't use set_page_dirty for write(2).
> > eg. ext2 w/o nobh option.
> 
> I'm thinking this is an ext2 bug. So I'd rather it'd just call
> set_page_dirty() like a proper filesystem instead of doing things like
> this.
> 
> And I certainly don't like exporting task_dirty_inc() - filesystems and
> the like should not have to know about things like that.
> 
Hmm, a bit complicated for me.

At first, there are 2 __set_page_dirty() in the kernel.
  - mm/page-writeback.c: __set_page_dirty()
              .... set_page_dirty() calls this.
  - fs/buffer.c : __set_page_dirty()
              .... __set_page_dirty_buffers() and mark_buffer_dirty() calls this.

Why per-task dirty acconitng is done in mm/page-writeback.c::set_page_dirty() ?

It seems other accounting is done in the fs/buffer.c: __set_page_dirty()

The purpose of task-dirty accounting is different from others  ?

= fs/buffer.c
 697 static int __set_page_dirty(struct page *page,
 698                 struct address_space *mapping, int warn)
 699 {
 700         if (unlikely(!mapping))
 701                 return !TestSetPageDirty(page);
 702 
 703         if (TestSetPageDirty(page))
 704                 return 0;
 705 
 706         write_lock_irq(&mapping->tree_lock);
 707         if (page->mapping) {    /* Race with truncate? */
 708                 WARN_ON_ONCE(warn && !PageUptodate(page));
 709 
 710                 if (mapping_cap_account_dirty(mapping)) {
 711                         __inc_zone_page_state(page, NR_FILE_DIRTY);
 712                         __inc_bdi_stat(mapping->backing_dev_info,
 713                                         BDI_RECLAIMABLE);
 714                         task_io_account_write(PAGE_CACHE_SIZE);
 715                 }
 716                 radix_tree_tag_set(&mapping->page_tree,
 717                                 page_index(page), PAGECACHE_TAG_DIRTY);
 718         }
 719         write_unlock_irq(&mapping->tree_lock);
 720         __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 721 
 722         return 1;
==

And task-dirty-limit don't have to take care of following 2 case ?
  - __set_page_dirty_nobuffers(struct page *page) (increment BDI_RECRAIMABLE)
  - test_set_page_writeback() (increment BDI_RECLAIMABLE)

Thanks,
-Kame



> Of course I'm utterly ignorant of filesystems, hence lets include more
> clue-full people.
> 
> > YAMAMOTO Takashi
> > 
> > 
> > Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
> > ---
> > 
> > commit e68f05bf56d0652c107bba1cff3f8491e41a2117
> > Author: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
> > Date:   Wed Jul 2 16:17:33 2008 +0900
> > 
> >     fix dirty balancing for tasks.
> >     
> >     call task_dirty_inc when dirtying a page with mark_buffer_dirty.
> > 
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 4788a9e..2f1c7c6 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -1219,8 +1219,9 @@ void mark_buffer_dirty(struct buffer_head *bh)
> >  			return;
> >  	}
> >  
> > -	if (!test_set_buffer_dirty(bh))
> > -		__set_page_dirty(bh->b_page, page_mapping(bh->b_page), 0);
> > +	if (!test_set_buffer_dirty(bh) &&
> > +	    __set_page_dirty(bh->b_page, page_mapping(bh->b_page), 0))
> > +		task_dirty_inc(current);
> >  }
> >  
> >  /*
> > diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> > index bd91987..61d0aec 100644
> > --- a/include/linux/writeback.h
> > +++ b/include/linux/writeback.h
> > @@ -95,6 +95,7 @@ int wakeup_pdflush(long nr_pages);
> >  void laptop_io_completion(void);
> >  void laptop_sync_completion(void);
> >  void throttle_vm_writeout(gfp_t gfp_mask);
> > +void task_dirty_inc(struct task_struct *);
> >  
> >  /* These are exported to sysctl. */
> >  extern int dirty_background_ratio;
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index 29b1d1e..4dc85d0 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -176,10 +176,11 @@ void bdi_writeout_inc(struct backing_dev_info *bdi)
> >  }
> >  EXPORT_SYMBOL_GPL(bdi_writeout_inc);
> >  
> > -static inline void task_dirty_inc(struct task_struct *tsk)
> > +void task_dirty_inc(struct task_struct *tsk)
> >  {
> >  	prop_inc_single(&vm_dirties, &tsk->dirties);
> >  }
> > +EXPORT_SYMBOL_GPL(task_dirty_inc);
> >  
> >  /*
> >   * Obtain an accurate fraction of the BDI's portion.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

