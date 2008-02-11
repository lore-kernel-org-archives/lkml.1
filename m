Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYBKWaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYBKWaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYBKWaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:30:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33764 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753194AbYBKWaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:30:21 -0500
Date: Mon, 11 Feb 2008 14:29:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mgross@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Greg KH <greg@kroah.com>
Subject: Re: iova RB tree setup tweak.
Message-Id: <20080211142946.379455af.akpm@linux-foundation.org>
In-Reply-To: <20080211215651.GA24412@linux.intel.com>
References: <20080211215651.GA24412@linux.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 13:56:51 -0800
mark gross <mgross@linux.intel.com> wrote:

> The following patch merges two functions into one allowing for a 3%
> reduction in overhead in locating, allocating and inserting pages for
> use in IOMMU operations.
> 
> Its a bit of a eye-crosser so I welcome any RB-tree / MM experts to take
> a look.  It works by re-using some of the information gathered in the
> search for the pages to use in setting up the IOTLB's in the insertion
> of the iova structure into the RB tree.
> 

I guess this is a PCI patch hence I'd be tagging is as
to-be-merged-via-greg's-pci-tree.

> 
> Singed-off-by: <mgross@linux.intel.com>
> 

ow, that musta hurt.

> 
> Index: linux-2.6.24-mm1/drivers/pci/iova.c
> ===================================================================
> --- linux-2.6.24-mm1.orig/drivers/pci/iova.c	2008-02-07 11:05:44.000000000 -0800
> +++ linux-2.6.24-mm1/drivers/pci/iova.c	2008-02-07 13:05:03.000000000 -0800
> @@ -72,20 +72,25 @@
>  	return pad_size;
>  }
>  
> -static int __alloc_iova_range(struct iova_domain *iovad, unsigned long size,
> -		unsigned long limit_pfn, struct iova *new, bool size_aligned)
> +static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
> +		unsigned long size, unsigned long limit_pfn,
> +			struct iova *new, bool size_aligned)
>  {
> -	struct rb_node *curr = NULL;
> +	struct rb_node *prev, *curr = NULL;
>  	unsigned long flags;
>  	unsigned long saved_pfn;
>  	unsigned int pad_size = 0;
>  
>  	/* Walk the tree backwards */
>  	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
>  	saved_pfn = limit_pfn;
>  	curr = __get_cached_rbnode(iovad, &limit_pfn);
> +	prev = curr;
>  	while (curr) {
>  		struct iova *curr_iova = container_of(curr, struct iova, node);
> +
>  		if (limit_pfn < curr_iova->pfn_lo)
>  			goto move_left;
>  		else if (limit_pfn < curr_iova->pfn_hi)
> @@ -99,6 +104,7 @@

For some reason patch(1) claims that the patch is corrupted at this line.

