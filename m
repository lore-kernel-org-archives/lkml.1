Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbZAJXoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbZAJXoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbZAJXoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:44:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58765 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbZAJXob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:44:31 -0500
Date: Sun, 11 Jan 2009 00:43:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, dwmw2@infradead.org,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 04/16] dma-debug: add allocator code
Message-ID: <20090110234352.GA20843@elte.hu>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-5-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231517970-20288-5-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> +		printk(KERN_ERR "DMA-API: debugging out of memory "
> +				"- disabling\n");

btw., i'd suggest to not break kernel messages mid-string, but do 
something like this instead:

> +		printk(KERN_ERR
		 "DMA-API: debugging out of memory - disabling\n");

Also, i'd use WARN() - it might be useful to see what callsite depleted 
the pool.

> +	entry = list_entry(free_entries.next, struct dma_debug_entry, list);
> +	list_del(&entry->list);
> +	memset(entry, 0, sizeof(*entry));
> +
> +	num_free_entries -= 1;
> +	if (num_free_entries < min_free_entries)
> +		min_free_entries = num_free_entries;

unlikely() i guess.

Regarding the entry pool locking:

> +static void dma_entry_free(struct dma_debug_entry *entry)
> +{
> +	unsigned long flags;
> +
> +	/*
> +	 * add to beginning of the list - this way the entries are
> +	 * more likely cache hot when they are reallocated.
> +	 */
> +	spin_lock_irqsave(&free_entries_lock, flags);
> +	list_add(&entry->list, &free_entries);
> +	num_free_entries += 1;
> +	spin_unlock_irqrestore(&free_entries_lock, flags);

it might make sense to cache entries in the buckets - hence reuse the 
bucket spinlock. This means a somewhat higher effective pool size, but it 
also avoids a global lock.

	Ingo
