Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab0BRPYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:24:11 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:47819 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab0BRPYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:24:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ei0sPc1so5V1UJsabMdtQB9ZoJLBBKjY5uPsVzWdknaLZFeRC/GOL09YKdjttKz8Z7
         RVaxl44tGhDXza4LOIt1tRJtah2F83/A7E0l2ITGMZMHF1dlzco4YO5r2DIEl5AQFO9P
         DIit63YBPgjwFBPM4/bH0pTJOv0VAAlVKpmlE=
Subject: Re: [PATCH 03/12] Export unusable free space index via
 /proc/pagetypeinfo
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1265976059-7459-4-git-send-email-mel@csn.ul.ie>
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie>
	 <1265976059-7459-4-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 00:23:59 +0900
Message-ID: <1266506639.1709.216.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-12 at 12:00 +0000, Mel Gorman wrote:
> Unusuable free space index is a measure of external fragmentation that
> takes the allocation size into account. For the most part, the huge page
> size will be the size of interest but not necessarily so it is exported
> on a per-order and per-zone basis via /proc/pagetypeinfo.
> 
> The index is normally calculated as a value between 0 and 1 which is
> obviously unsuitable within the kernel. Instead, the first three decimal
> places are used as a value between 0 and 1000 for an integer approximation.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

There are comments at below. 
It's very trivial so I don't care. 

> ---
>  Documentation/filesystems/proc.txt |   10 ++++
>  mm/vmstat.c                        |   99 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 109 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index 1829dfb..0968a81 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -614,6 +614,10 @@ Node    0, zone    DMA32, type      Movable    169    152    113     91     77
>  Node    0, zone    DMA32, type      Reserve      1      2      2      2      2      0      1      1      1      1      0
>  Node    0, zone    DMA32, type      Isolate      0      0      0      0      0      0      0      0      0      0      0
>  
> +Unusable free space index at order
> +Node    0, zone      DMA                         0      0      0      2      6     18     34     67     99    227    485
> +Node    0, zone    DMA32                         0      0      1      2      4      7     10     17     23     31     34
> +
>  Number of blocks type     Unmovable  Reclaimable      Movable      Reserve      Isolate
>  Node 0, zone      DMA            2            0            5            1            0
>  Node 0, zone    DMA32           41            6          967            2            0
> @@ -629,6 +633,12 @@ then gives the same type of information as buddyinfo except broken down
>  by migrate-type and finishes with details on how many page blocks of each
>  type exist.
>  
> +The unusable free space index measures how much of the available free
> +memory cannot be used to satisfy an allocation of a given size and is a
> +value between 0 and 1000. The higher the value, the more of free memory is
> +unusable and by implication, the worse the external fragmentation is. The
> +percentage of unusable free memory can be found by dividing this value by 10.
> +
>  If min_free_kbytes has been tuned correctly (recommendations made by hugeadm
>  from libhugetlbfs http://sourceforge.net/projects/libhugetlbfs/), one can
>  make an estimate of the likely number of huge pages that can be allocated
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 6051fba..d05d610 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -451,6 +451,104 @@ static int frag_show(struct seq_file *m, void *arg)
>  	return 0;
>  }
>  
> +
> +struct contig_page_info {
> +	unsigned long free_pages;
> +	unsigned long free_blocks_total;
> +	unsigned long free_blocks_suitable;
> +};
> +
> +/*
> + * Calculate the number of free pages in a zone, how many contiguous
> + * pages are free and how many are large enough to satisfy an allocation of
> + * the target size. Note that this function makes to attempt to estimate
> + * how many suitable free blocks there *might* be if MOVABLE pages were
> + * migrated. Calculating that is possible, but expensive and can be
> + * figured out from userspace
> + */
> +static void fill_contig_page_info(struct zone *zone,
> +				unsigned int suitable_order,
> +				struct contig_page_info *info)
> +{
> +	unsigned int order;
> +
> +	info->free_pages = 0;
> +	info->free_blocks_total = 0;
> +	info->free_blocks_suitable = 0;
> +
> +	for (order = 0; order < MAX_ORDER; order++) {
> +		unsigned long blocks;
> +
> +		/* Count number of free blocks */
> +		blocks = zone->free_area[order].nr_free;
> +		info->free_blocks_total += blocks;
> +
> +		/* Count free base pages */
> +		info->free_pages += blocks << order;
> +
> +		/* Count the suitable free blocks */
> +		if (order >= suitable_order)
> +			info->free_blocks_suitable += blocks <<
> +						(order - suitable_order);
> +	}
> +}
> +
> +/*
> + * Return an index indicating how much of the available free memory is
> + * unusable for an allocation of the requested size.
> + */
> +static int unusable_free_index(struct zone *zone,

Did you remain "zone" argument for later?
Anyway, It's trivial.

> +				unsigned int order,
> +				struct contig_page_info *info)
> +{
> +	/* No free memory is interpreted as all free memory is unusable */
> +	if (info->free_pages == 0)
> +		return 1000;
> +
> +	/*
> +	 * Index should be a value between 0 and 1. Return a value to 3
> +	 * decimal places.
> +	 *
> +	 * 0 => no fragmentation
> +	 * 1 => high fragmentation
> +	 */
> +	return ((info->free_pages - (info->free_blocks_suitable << order)) * 1000) / info->free_pages;
> +
> +}
> +
> +static void pagetypeinfo_showunusable_print(struct seq_file *m,
> +					pg_data_t *pgdat, struct zone *zone)
> +{
> +	unsigned int order;
> +
> +	/* Alloc on stack as interrupts are disabled for zone walk */

contig_page_info would be larger than now?
I think it's small data now. I don't know why you comment it.
It's just out of curiosity. :)


> +	struct contig_page_info info;
> +
> +	seq_printf(m, "Node %4d, zone %8s %19s",
> +				pgdat->node_id,
> +				zone->name, " ");
> +	for (order = 0; order < MAX_ORDER; ++order) {
> +		fill_contig_page_info(zone, order, &info);
> +		seq_printf(m, "%6d ", unusable_free_index(zone, order, &info));
> +	}
> +
> +	seq_putc(m, '\n');
> +}
> +
> +/*
> + * Display unusable free space index
> + * XXX: Could be a lot more efficient, but it's not a critical path
> + */
> +static int pagetypeinfo_showunusable(struct seq_file *m, void *arg)
> +{
> +	pg_data_t *pgdat = (pg_data_t *)arg;
> +
> +	seq_printf(m, "\nUnusable free space index at order\n");
> +	walk_zones_in_node(m, pgdat, pagetypeinfo_showunusable_print);
> +
> +	return 0;
> +}
> +
>  static void pagetypeinfo_showfree_print(struct seq_file *m,
>  					pg_data_t *pgdat, struct zone *zone)
>  {
> @@ -558,6 +656,7 @@ static int pagetypeinfo_show(struct seq_file *m, void *arg)
>  	seq_printf(m, "Pages per block:  %lu\n", pageblock_nr_pages);
>  	seq_putc(m, '\n');
>  	pagetypeinfo_showfree(m, pgdat);
> +	pagetypeinfo_showunusable(m, pgdat);
>  	pagetypeinfo_showblockcount(m, pgdat);
>  
>  	return 0;


-- 
Kind regards,
Minchan Kim


