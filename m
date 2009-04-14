Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbZDNKqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbZDNKqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZDNKq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:46:28 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:14543
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750856AbZDNKq1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:46:27 -0400
X-BigFish: VPS-27(zz1432R98dR1805M936fKzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KI3792-02-L0B-01
Date: Tue, 14 Apr 2009 12:47:58 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 1/2] dma-debug: add dma_debug_resize_entries() to
	adjust the number of dma_debug_entries
Message-ID: <20090414104758.GE1141@amd.com>
References: <1239669799-23579-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1239669799-23579-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 14 Apr 2009 10:46:15.0552 (UTC) FILETIME=[3C3B3000:01C9BCEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 09:43:18AM +0900, FUJITA Tomonori wrote:
> We use a static value for the number of dma_debug_entries. It can be
> overwritten by a kernel command line option.
> 
> Some IOMMUs (e.g. GART) can't set an appropriate value by a kernel
> command line option because they can't know such value until they
> finish initializing up their hardware.
> 
> This patch adds dma_debug_resize_entries() enables IOMMUs to adjust
> the number of dma_debug_entries anytime.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Looks good.

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

> ---
>  include/linux/dma-debug.h |    7 +++++
>  lib/dma-debug.c           |   67 +++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 68 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
> index 28d53cb..171ad8a 100644
> --- a/include/linux/dma-debug.h
> +++ b/include/linux/dma-debug.h
> @@ -32,6 +32,8 @@ extern void dma_debug_add_bus(struct bus_type *bus);
>  
>  extern void dma_debug_init(u32 num_entries);
>  
> +extern int dma_debug_resize_entries(u32 num_entries);
> +
>  extern void debug_dma_map_page(struct device *dev, struct page *page,
>  			       size_t offset, size_t size,
>  			       int direction, dma_addr_t dma_addr,
> @@ -91,6 +93,11 @@ static inline void dma_debug_init(u32 num_entries)
>  {
>  }
>  
> +static inline int dma_debug_resize_entries(u32 num_entries)
> +{
> +	return 0;
> +}
> +
>  static inline void debug_dma_map_page(struct device *dev, struct page *page,
>  				      size_t offset, size_t size,
>  				      int direction, dma_addr_t dma_addr,
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index d3da7ed..01439e6 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -85,6 +85,7 @@ static u32 show_num_errors = 1;
>  
>  static u32 num_free_entries;
>  static u32 min_free_entries;
> +static u32 nr_total_entries;
>  
>  /* number of preallocated entries requested by kernel cmdline */
>  static u32 req_entries;
> @@ -257,6 +258,21 @@ static void add_dma_entry(struct dma_debug_entry *entry)
>  	put_hash_bucket(bucket, &flags);
>  }
>  
> +static struct dma_debug_entry *__dma_entry_alloc(void)
> +{
> +	struct dma_debug_entry *entry;
> +
> +	entry = list_entry(free_entries.next, struct dma_debug_entry, list);
> +	list_del(&entry->list);
> +	memset(entry, 0, sizeof(*entry));
> +
> +	num_free_entries -= 1;
> +	if (num_free_entries < min_free_entries)
> +		min_free_entries = num_free_entries;
> +
> +	return entry;
> +}
> +
>  /* struct dma_entry allocator
>   *
>   * The next two functions implement the allocator for
> @@ -276,9 +292,7 @@ static struct dma_debug_entry *dma_entry_alloc(void)
>  		goto out;
>  	}
>  
> -	entry = list_entry(free_entries.next, struct dma_debug_entry, list);
> -	list_del(&entry->list);
> -	memset(entry, 0, sizeof(*entry));
> +	entry = __dma_entry_alloc();
>  
>  #ifdef CONFIG_STACKTRACE
>  	entry->stacktrace.max_entries = DMA_DEBUG_STACKTRACE_ENTRIES;
> @@ -286,9 +300,6 @@ static struct dma_debug_entry *dma_entry_alloc(void)
>  	entry->stacktrace.skip = 2;
>  	save_stack_trace(&entry->stacktrace);
>  #endif
> -	num_free_entries -= 1;
> -	if (num_free_entries < min_free_entries)
> -		min_free_entries = num_free_entries;
>  
>  out:
>  	spin_unlock_irqrestore(&free_entries_lock, flags);
> @@ -310,6 +321,48 @@ static void dma_entry_free(struct dma_debug_entry *entry)
>  	spin_unlock_irqrestore(&free_entries_lock, flags);
>  }
>  
> +int dma_debug_resize_entries(u32 num_entries)
> +{
> +	int i, delta, ret = 0;
> +	unsigned long flags;
> +	struct dma_debug_entry *entry;
> +
> +	spin_lock_irqsave(&free_entries_lock, flags);
> +
> +	if (nr_total_entries < num_entries) {
> +		delta = num_entries - nr_total_entries;
> +
> +		for (i = 0; i < delta; i++) {
> +			entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
> +			if (!entry)
> +				break;
> +
> +			list_add_tail(&entry->list, &free_entries);
> +		}
> +
> +		nr_total_entries += i;
> +		num_free_entries += i;
> +
> +	} else {
> +		delta = nr_total_entries - num_entries;
> +
> +		for (i = 0; i < delta && !list_empty(&free_entries); i++) {
> +			entry = __dma_entry_alloc();
> +			kfree(entry);
> +		}
> +
> +		nr_total_entries -= i;
> +	}
> +
> +	if (nr_total_entries != num_entries)
> +		ret = 1;
> +
> +	spin_unlock_irqrestore(&free_entries_lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(dma_debug_resize_entries);
> +
>  /*
>   * DMA-API debugging init code
>   *
> @@ -490,6 +543,8 @@ void dma_debug_init(u32 num_entries)
>  		return;
>  	}
>  
> +	nr_total_entries = num_free_entries;
> +
>  	printk(KERN_INFO "DMA-API: debugging enabled by kernel config\n");
>  }
>  
> -- 
> 1.6.0.6
> 
> 

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

