Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbZHQC5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbZHQC5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 22:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbZHQC5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 22:57:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37421 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbZHQC5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 22:57:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 17 Aug 2009 11:55:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: ngupta@vflare.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] swap: send callback when swap slot is freed
Message-Id: <20090817115529.59395cea.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200908122007.43522.ngupta@vflare.org>
References: <200908122007.43522.ngupta@vflare.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009 20:07:43 +0530
Nitin Gupta <ngupta@vflare.org> wrote:

> Currently, we have "swap discard" mechanism which sends a discard bio request
> when we find a free cluster during scan_swap_map(). This callback can come a
> long time after swap slots are actually freed.
> 
> This delay in callback is a great problem when (compressed) RAM [1] is used
> as a swap device. So, this change adds a callback which is called as
> soon as a swap slot becomes free. For above mentioned case of swapping
> over compressed RAM device, this is very useful since we can immediately
> free memory allocated for this swap page.
> 
> This callback does not replace swap discard support. It is called with
> swap_lock held, so it is meant to trigger action that finishes quickly.
> However, swap discard is an I/O request and can be used for taking longer
> actions.
> 
> Links:
> [1] http://code.google.com/p/compcache/
> 

Hmm, do you really need notify at *every* swap free ?
No batching is necessary ?

Thanks,
-Kame

> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> ---
> 
>  include/linux/swap.h |    5 +++++
>  mm/swapfile.c        |   16 ++++++++++++++++
>  2 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 7c15334..4cbe3c4 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -8,6 +8,7 @@
>  #include <linux/memcontrol.h>
>  #include <linux/sched.h>
>  #include <linux/node.h>
> +#include <linux/blkdev.h>
>  
>  #include <asm/atomic.h>
>  #include <asm/page.h>
> @@ -20,6 +21,8 @@ struct bio;
>  #define SWAP_FLAG_PRIO_MASK	0x7fff
>  #define SWAP_FLAG_PRIO_SHIFT	0
>  
> +typedef void (swap_free_notify_fn) (struct block_device *, unsigned long);
> +
>  static inline int current_is_kswapd(void)
>  {
>  	return current->flags & PF_KSWAPD;
> @@ -155,6 +158,7 @@ struct swap_info_struct {
>  	unsigned int max;
>  	unsigned int inuse_pages;
>  	unsigned int old_block_size;
> +	swap_free_notify_fn *swap_free_notify_fn;
>  };
>  
>  struct swap_list_t {
> @@ -295,6 +299,7 @@ extern sector_t swapdev_block(int, pgoff_t);
>  extern struct swap_info_struct *get_swap_info_struct(unsigned);
>  extern int reuse_swap_page(struct page *);
>  extern int try_to_free_swap(struct page *);
> +extern void set_swap_free_notify(unsigned, swap_free_notify_fn *);
>  struct backing_dev_info;
>  
>  /* linux/mm/thrash.c */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 8ffdc0d..aa95fc7 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -552,6 +552,20 @@ out:
>  	return NULL;
>  }
>  
> +/*
> + * Sets callback for event when swap_map[offset] == 0
> + * i.e. page at this swap offset is no longer used.
> + */
> +void set_swap_free_notify(unsigned type, swap_free_notify_fn *notify_fn)
> +{
> +	struct swap_info_struct *sis;
> +	sis = get_swap_info_struct(type);
> +	BUG_ON(!sis);
> +	sis->swap_free_notify_fn = notify_fn;
> +	return;
> +}
> +EXPORT_SYMBOL(set_swap_free_notify);
> +
>  static int swap_entry_free(struct swap_info_struct *p,
>  			   swp_entry_t ent, int cache)
>  {
> @@ -583,6 +597,8 @@ static int swap_entry_free(struct swap_info_struct *p,
>  			swap_list.next = p - swap_info;
>  		nr_swap_pages++;
>  		p->inuse_pages--;
> +		if (p->swap_free_notify_fn)
> +			p->swap_free_notify_fn(p->bdev, offset);
>  	}
>  	if (!swap_count(count))
>  		mem_cgroup_uncharge_swap(ent);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

