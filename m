Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbYJGBN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbYJGBN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbYJGBNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:13:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:46039 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbYJGBNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:13:18 -0400
Subject: Re: [PATCH v2] properly reserve in bootmem the lmb reserved
	regions that cross NUMA nodes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@ozlabs.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adam Litke <agl@us.ibm.com>, Kumar Gala <galak@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <48EA86B8.7010405@linux.vnet.ibm.com>
References: <48EA86B8.7010405@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 12:03:51 +1100
Message-Id: <1223341431.8157.33.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor nits ...

One is, you add this helper to mm/page_alloc.c, which means that I'll
need some ack from Hugh or Andrew before I can merge that via the
powerpc tree... Unless there's another user, I'd rather keep the
helper function in powerpc code for now, it can be moved to common
code later if somebody needs something similar.

> +	/* Mark reserved regions */
> +	for (i = 0; i < lmb.reserved.cnt; i++) {
> +		unsigned long physbase = lmb.reserved.region[i].base;
> +		unsigned long size = lmb.reserved.region[i].size;
> +		unsigned long start_pfn = physbase >> PAGE_SHIFT;
> +		unsigned long end_pfn = ((physbase + size - 1) >> PAGE_SHIFT);
> +		struct node_active_region *node_ar;

I'm not too happy wit the fact that something called "end_pfn" is
sometimes inclusive and sometime exclusive.

IE. From your implementation of get_node_active_region() it looks like
early_node_map[i].end_pfn isn't part of the range (exclusive) while
in your loop, the way you define end_pfn to be base + size - 1 means
it's part of the range (inclusive). That subtle distinction makes it
harder to understand the logic and is bug prone.

> +		node_ar = get_node_active_region(start_pfn);
> +		while (start_pfn < end_pfn && node_ar != NULL) {
> +			/*
> +			 * if reserved region extends past active region
> +			 * then trim size to active region
> +			 */
> +			if (end_pfn >= node_ar->end_pfn)

So the above test is correct, but it took me two more brain cells to
figure it out than necessary :-)

> +				size = (node_ar->end_pfn << PAGE_SHIFT)
> +					- (start_pfn << PAGE_SHIFT);
> +			dbg("reserve_bootmem %lx %lx nid=%d\n", physbase, size,
> +				node_ar->nid);
> +			reserve_bootmem_node(NODE_DATA(node_ar->nid), physbase,
> +						size, BOOTMEM_DEFAULT);
> +			/*
> +			 * if reserved region extends past the active region
> +			 * then get next active region that contains
> +			 *        this reserved region
> +			 */
> +			if (end_pfn >= node_ar->end_pfn) {
> +				start_pfn = node_ar->end_pfn;
> +				physbase = start_pfn << PAGE_SHIFT;
> +				node_ar = get_node_active_region(start_pfn);
> +			} else
> +				break;
>  		}
Minor nit but the above would look nicer if you wrote instead

			if (end_pfn < node_ar->end_pfn)
				break;
			start_pfn = ...
 
> +	}
> +
> +	for_each_online_node(nid) {
>  		sparse_memory_present_with_active_regions(nid);
>  	}
>  }

And you can remove the { and } above.

Cheers,
Ben.


