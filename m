Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYKWTg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYKWTg5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbYKWTgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:36:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56091 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYKWTgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:36:44 -0500
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/10] x86: add initialization code for DMA-API debugging
From: Andi Kleen <andi@firstfloor.org>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com>
	<1227284770-19215-4-git-send-email-joerg.roedel@amd.com>
Date: Sun, 23 Nov 2008 20:36:45 +0100
In-Reply-To: <1227284770-19215-4-git-send-email-joerg.roedel@amd.com> (Joerg Roedel's message of "Fri, 21 Nov 2008 17:26:03 +0100")
Message-ID: <87r652i69e.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel <joerg.roedel@amd.com> writes:
> +/* Hash list to save the allocated dma addresses */
> +static struct list_head dma_entry_hash[HASH_SIZE];

Hash tables should use hlists.

> +static int hash_fn(struct dma_debug_entry *entry)
> +{
> +	/*
> +	 * Hash function is based on the dma address.
> +	 * We use bits 20-27 here as the index into the hash
> +	 */
> +	BUG_ON(entry->dev_addr == bad_dma_address);
> +
> +	return (entry->dev_addr >> HASH_FN_SHIFT) & HASH_FN_MASK;

It would be probably safer to use a stronger hash like FNV
There are a couple to reuse in include/

> +}
> +
> +static struct dma_debug_entry *dma_entry_alloc(void)
> +{
> +	gfp_t gfp = GFP_KERNEL | __GFP_ZERO;
> +
> +	if (in_atomic())
> +		gfp |= GFP_ATOMIC;
> +
> +	return kmem_cache_alloc(dma_entry_cache, gfp);
> +}

While the basic idea is reasonable this function is unfortunately
broken. It's not always safe to allocate memory (e.g. in the block
write out path which uses map_sg). You would need to use
a mempool or something.

Besides the other problem of using GFP_ATOMIC is that it can 
fail under high load and you don't handle this case very well
(would report a bug incorrectly). And stress tests tend to 
trigger that, reporting false positives in such a case is a very very
bad thing, it leads to QA people putting these messages
on their blacklists.

-Andi

-- 
ak@linux.intel.com
