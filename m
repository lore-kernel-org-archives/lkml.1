Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbZBJJL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbZBJJL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 04:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZBJJLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 04:11:14 -0500
Received: from viefep15-int.chello.at ([62.179.121.35]:61393 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZBJJLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:11:12 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] mm: task dirty accounting fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090210043953.GD28301@wotan.suse.de>
References: <20090210043953.GD28301@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 10:12:51 +0100
Message-Id: <1234257171.23438.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 05:39 +0100, Nick Piggin wrote:
> Hi,
> 
> This is based from an earlier patch from YAMAMOTO-san which I have
> somewhat simplified. What do you think?

Looks nice. Was a bit surprised we never actually merged the previous
one though..

> Thanks,
> Nick
> 
> --
> YAMAMOTO-san noticed that task_dirty_inc doesn't seem to be called properly for
> cases where set_page_dirty is not used to dirty a page (eg. mark_buffer_dirty).
> 
> Additionally, there is some inconsistency about when task_dirty_inc is
> called. It is used for dirty balancing, however it even gets called for
> __set_page_dirty_no_writeback.
> 
> So rather than increment it in a set_page_dirty wrapper, move it down to
> exactly where the dirty page accounting stats are incremented.
> 
> Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  fs/buffer.c         |    1 +
>  include/linux/mm.h  |    1 +
>  mm/page-writeback.c |   13 +++----------
>  3 files changed, 5 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/include/linux/mm.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mm.h
> +++ linux-2.6/include/linux/mm.h
> @@ -1162,6 +1162,7 @@ extern int filemap_fault(struct vm_area_
>  
>  /* mm/page-writeback.c */
>  int write_one_page(struct page *page, int wait);
> +void task_dirty_inc(struct task_struct *tsk);
>  
>  /* readahead.c */
>  #define VM_MAX_READAHEAD	128	/* kbytes */
> Index: linux-2.6/mm/page-writeback.c
> ===================================================================
> --- linux-2.6.orig/mm/page-writeback.c
> +++ linux-2.6/mm/page-writeback.c
> @@ -241,7 +241,7 @@ void bdi_writeout_inc(struct backing_dev
>  }
>  EXPORT_SYMBOL_GPL(bdi_writeout_inc);
>  
> -static inline void task_dirty_inc(struct task_struct *tsk)
> +void task_dirty_inc(struct task_struct *tsk)
>  {
>  	prop_inc_single(&vm_dirties, &tsk->dirties);
>  }
> @@ -1228,6 +1228,7 @@ int __set_page_dirty_nobuffers(struct pa
>  				__inc_zone_page_state(page, NR_FILE_DIRTY);
>  				__inc_bdi_stat(mapping->backing_dev_info,
>  						BDI_RECLAIMABLE);
> +				task_dirty_inc(current);
>  				task_io_account_write(PAGE_CACHE_SIZE);
>  			}
>  			radix_tree_tag_set(&mapping->page_tree,
> @@ -1263,7 +1264,7 @@ EXPORT_SYMBOL(redirty_page_for_writepage
>   * If the mapping doesn't provide a set_page_dirty a_op, then
>   * just fall through and assume that it wants buffer_heads.
>   */
> -static int __set_page_dirty(struct page *page)
> +int set_page_dirty(struct page *page)
>  {
>  	struct address_space *mapping = page_mapping(page);
>  
> @@ -1281,14 +1282,6 @@ static int __set_page_dirty(struct page
>  	}
>  	return 0;
>  }
> -
> -int set_page_dirty(struct page *page)
> -{
> -	int ret = __set_page_dirty(page);
> -	if (ret)
> -		task_dirty_inc(current);
> -	return ret;
> -}
>  EXPORT_SYMBOL(set_page_dirty);
>  
>  /*
> Index: linux-2.6/fs/buffer.c
> ===================================================================
> --- linux-2.6.orig/fs/buffer.c
> +++ linux-2.6/fs/buffer.c
> @@ -628,6 +628,7 @@ static int __set_page_dirty(struct page
>  			__inc_zone_page_state(page, NR_FILE_DIRTY);
>  			__inc_bdi_stat(mapping->backing_dev_info,
>  					BDI_RECLAIMABLE);
> +			task_dirty_inc(current);
>  			task_io_account_write(PAGE_CACHE_SIZE);
>  		}
>  		radix_tree_tag_set(&mapping->page_tree,

