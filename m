Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbZDNK6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbZDNK6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbZDNK6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:58:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45806 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbZDNK6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:58:45 -0400
Date: Tue, 14 Apr 2009 12:58:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, joerg.roedel@amd.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] dma-debug: add dma_debug_resize_entries() to
	adjust the number of dma_debug_entries
Message-ID: <20090414105823.GL3558@elte.hu>
References: <1239669799-23579-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239669799-23579-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

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

hm, using GFP_ATOMIC within a spinlock is not a very nice thing to 
do in general. While this is boot-only and the GFP_ATOMIC will 
likely succeed, this could become non-boot functionality and then 
it's exposed to the momentary VM pressure situation that might make 
GFP_ATOMIC fail.

Please fix this to be GFP_KERNEL.

a small detail:

> +		delta = nr_total_entries - num_entries;
> +
> +		for (i = 0; i < delta && !list_empty(&free_entries); i++) {
> +			entry = __dma_entry_alloc();
> +			kfree(entry);
> +		}
> +
> +		nr_total_entries -= i;
> +	}

Can i != delta ever happen? It would suggest the list length being 
out of sync with the nr_total_entries counter.

	Ingo
