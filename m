Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbYGBUcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbYGBUcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 16:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbYGBUcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 16:32:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45386 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbYGBUcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:32:14 -0400
Subject: Re: [PATCH] fix task dirty balancing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20080702082644.BA45D5A17@siro.lan>
References: <20080702082644.BA45D5A17@siro.lan>
Content-Type: text/plain
Date: Wed, 02 Jul 2008 22:27:18 +0200
Message-Id: <1215030438.28676.20.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 17:26 +0900, YAMAMOTO Takashi wrote:
> hi,
> 
> task_dirty_inc doesn't seem to be called properly for
> filesystems which don't use set_page_dirty for write(2).
> eg. ext2 w/o nobh option.

I'm thinking this is an ext2 bug. So I'd rather it'd just call
set_page_dirty() like a proper filesystem instead of doing things like
this.

And I certainly don't like exporting task_dirty_inc() - filesystems and
the like should not have to know about things like that.

Of course I'm utterly ignorant of filesystems, hence lets include more
clue-full people.

> YAMAMOTO Takashi
> 
> 
> Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
> ---
> 
> commit e68f05bf56d0652c107bba1cff3f8491e41a2117
> Author: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
> Date:   Wed Jul 2 16:17:33 2008 +0900
> 
>     fix dirty balancing for tasks.
>     
>     call task_dirty_inc when dirtying a page with mark_buffer_dirty.
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 4788a9e..2f1c7c6 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1219,8 +1219,9 @@ void mark_buffer_dirty(struct buffer_head *bh)
>  			return;
>  	}
>  
> -	if (!test_set_buffer_dirty(bh))
> -		__set_page_dirty(bh->b_page, page_mapping(bh->b_page), 0);
> +	if (!test_set_buffer_dirty(bh) &&
> +	    __set_page_dirty(bh->b_page, page_mapping(bh->b_page), 0))
> +		task_dirty_inc(current);
>  }
>  
>  /*
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index bd91987..61d0aec 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -95,6 +95,7 @@ int wakeup_pdflush(long nr_pages);
>  void laptop_io_completion(void);
>  void laptop_sync_completion(void);
>  void throttle_vm_writeout(gfp_t gfp_mask);
> +void task_dirty_inc(struct task_struct *);
>  
>  /* These are exported to sysctl. */
>  extern int dirty_background_ratio;
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 29b1d1e..4dc85d0 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -176,10 +176,11 @@ void bdi_writeout_inc(struct backing_dev_info *bdi)
>  }
>  EXPORT_SYMBOL_GPL(bdi_writeout_inc);
>  
> -static inline void task_dirty_inc(struct task_struct *tsk)
> +void task_dirty_inc(struct task_struct *tsk)
>  {
>  	prop_inc_single(&vm_dirties, &tsk->dirties);
>  }
> +EXPORT_SYMBOL_GPL(task_dirty_inc);
>  
>  /*
>   * Obtain an accurate fraction of the BDI's portion.

