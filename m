Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbYBWIUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbYBWIUm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764058AbYBWIJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:09:31 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933038AbYBWII7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:08:59 -0500
Date: Sat, 23 Feb 2008 00:06:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 17/28] netvm: hook skb allocation to reserves
Message-Id: <20080223000613.123c57b6.akpm@linux-foundation.org>
In-Reply-To: <20080220150307.507134000@chello.nl>
References: <20080220144610.548202000@chello.nl>
	<20080220150307.507134000@chello.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 15:46:27 +0100 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Change the skb allocation api to indicate RX usage and use this to fall back to
> the reserve when needed. SKBs allocated from the reserve are tagged in
> skb->emergency.
> 
> Teach all other skb ops about emergency skbs and the reserve accounting.
> 
> Use the (new) packet split API to allocate and track fragment pages from the
> emergency reserve. Do this using an atomic counter in page->index. This is
> needed because the fragments have a different sharing semantic than that
> indicated by skb_shinfo()->dataref. 
> 
> Note that the decision to distinguish between regular and emergency SKBs allows
> the accounting overhead to be limited to the later kind.
> 
> ...
>
> +static inline void skb_get_page(struct sk_buff *skb, struct page *page)
> +{
> +	get_page(page);
> +	if (skb_emergency(skb))
> +		atomic_inc(&page->frag_count);
> +}
> +
> +static inline void skb_put_page(struct sk_buff *skb, struct page *page)
> +{
> +	if (skb_emergency(skb) && atomic_dec_and_test(&page->frag_count))
> +		rx_emergency_put(PAGE_SIZE);
> +	put_page(page);
> +}

I'm thinking we should do `#define slowcall inline' then use that in the future.

>  static void skb_release_data(struct sk_buff *skb)
>  {
>  	if (!skb->cloned ||
>  	    !atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
>  			       &skb_shinfo(skb)->dataref)) {
> +		int size;
> +
> +#ifdef NET_SKBUFF_DATA_USES_OFFSET
> +		size = skb->end;
> +#else
> +		size = skb->end - skb->head;
> +#endif

The patch adds rather a lot of ifdefs.


