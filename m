Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZCFNvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZCFNvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZCFNu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:50:58 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:38700 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbZCFNu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:50:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kVs2ElMY6S7ZaxTNvdCy3VtP+lnuwNitOSwuBzbuk1TRoIHJjAL/LpK7Ds1fKYnsfn
         GfxlDl5fp4KiDwXwbuy7qvJD+DrFS+XKixMDcLkqeggrYgsgf7T2lADhV83rqQj0WB7N
         CzEp9gEwJF/TYCwYTG6sAgoCZCrIe9g/Hglzc=
Date: Fri, 6 Mar 2009 14:50:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/18] dma-debug: add hash functions for
	dma_debug_entries
Message-ID: <20090306135052.GE5988@nowhere>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com> <1236346229-6618-4-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236346229-6618-4-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 02:30:14PM +0100, Joerg Roedel wrote:
> Impact: implement necessary functions for the core hash
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  lib/dma-debug.c |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 101 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 3109971..5ff7d2e 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -18,9 +18,14 @@
>   */
>  
>  #include <linux/dma-debug.h>
> +#include <linux/spinlock.h>
>  #include <linux/types.h>
>  #include <linux/list.h>
>  
> +#define HASH_SIZE       1024ULL
> +#define HASH_FN_SHIFT   13
> +#define HASH_FN_MASK    (HASH_SIZE - 1)
> +
>  enum {
>  	dma_debug_single,
>  	dma_debug_page,
> @@ -40,3 +45,99 @@ struct dma_debug_entry {
>  	int		 sg_mapped_ents;
>  };
>  
> +struct hash_bucket {
> +	struct list_head list;
> +	spinlock_t lock;
> +} __cacheline_aligned_in_smp;
> +
> +/* Hash list to save the allocated dma addresses */
> +static struct hash_bucket dma_entry_hash[HASH_SIZE];
> +
> +/*
> + * Hash related functions
> + *
> + * Every DMA-API request is saved into a struct dma_debug_entry. To
> + * have quick access to these structs they are stored into a hash.
> + */
> +static int hash_fn(struct dma_debug_entry *entry)
> +{
> +	/*
> +	 * Hash function is based on the dma address.
> +	 * We use bits 20-27 here as the index into the hash
> +	 */
> +	return (entry->dev_addr >> HASH_FN_SHIFT) & HASH_FN_MASK;
> +}
> +
> +/*
> + * Request exclusive access to a hash bucket for a given dma_debug_entry.
> + */
> +static struct hash_bucket *get_hash_bucket(struct dma_debug_entry *entry,
> +					   unsigned long *flags)
> +{
> +	int idx = hash_fn(entry);
> +	unsigned long __flags;
> +
> +	spin_lock_irqsave(&dma_entry_hash[idx].lock, __flags);
> +	*flags = __flags;
> +	return &dma_entry_hash[idx];
> +}
> +
> +/*
> + * Give up exclusive access to the hash bucket
> + */
> +static void put_hash_bucket(struct hash_bucket *bucket,
> +			    unsigned long *flags)
> +{
> +	unsigned long __flags = *flags;
> +
> +	spin_unlock_irqrestore(&bucket->lock, __flags);
> +}
> +
> +/*
> + * Search a given entry in the hash bucket list
> + */
> +static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
> +						struct dma_debug_entry *ref)
> +{
> +	struct dma_debug_entry *entry;
> +
> +	list_for_each_entry(entry, &bucket->list, list) {
> +		if ((entry->dev_addr == ref->dev_addr) &&
> +		    (entry->dev == ref->dev))
> +			return entry;
> +	}
> +
> +	return NULL;
> +}
> +
> +/*
> + * Add an entry to a hash bucket
> + */
> +static void hash_bucket_add(struct hash_bucket *bucket,
> +			    struct dma_debug_entry *entry)
> +{
> +	list_add_tail(&entry->list, &bucket->list);
> +}
> +
> +/*
> + * Remove entry from a hash bucket list
> + */
> +static void hash_bucket_del(struct dma_debug_entry *entry)
> +{
> +	list_del(&entry->list);
> +}


Perhaps the two wrappers above are unnecessary, since they are actually
used once and only wrap a single list operation. No?

Frederic.

> +/*
> + * Wrapper function for adding an entry to the hash.
> + * This function takes care of locking itself.
> + */
> +static void add_dma_entry(struct dma_debug_entry *entry)
> +{
> +	struct hash_bucket *bucket;
> +	unsigned long flags;
> +
> +	bucket = get_hash_bucket(entry, &flags);
> +	hash_bucket_add(bucket, entry);
> +	put_hash_bucket(bucket, &flags);
> +}
> +
> -- 
> 1.5.6.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

