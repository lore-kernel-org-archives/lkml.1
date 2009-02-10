Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbZBJO1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbZBJO1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195AbZBJO1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:27:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40693 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbZBJO1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:27:11 -0500
Message-ID: <4b20a06e0fecb87fb8da5f510595573b.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090210133326.GA4023@csn.ul.ie>
References: <200902051729.n15HTsCC000590@imap1.linux-foundation.org>
    <20090206171724.77c4b5ed.kamezawa.hiroyu@jp.fujitsu.com>
    <20090206185514.8355c61b.kamezawa.hiroyu@jp.fujitsu.com>
    <20090210133326.GA4023@csn.ul.ie>
Date: Tue, 10 Feb 2009 23:27:08 +0900 (JST)
Subject: Re: [BUGFIX][PATCH] Aditional fix for memmap initalization
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Mel Gorman" <mel@csn.ul.ie>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, davem@davemloft.net,
       heiko.carstens@de.ibm.com, stable@kernel.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> It feels like we are changing more than we need to.
agreed.

> Could we achieve the same
> fix by just altering early_pfn_in_nid() to return true if the PFN matches
> the NID or is in a hole and ok to initialise.  Something like this patch
> maybe?
>
yes, maybe.
It seems there is no additional bug report and it seems good to write
simpler patch. I'll try a replacement in this week.

Regards,
-Kame

> =====
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 09c14e2..c3140df 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1070,11 +1070,7 @@ void sparse_init(void);
>  #define sparse_index_init(_sec, _nid)  do {} while (0)
>  #endif /* CONFIG_SPARSEMEM */
>
> -#ifdef CONFIG_NODES_SPAN_OTHER_NODES
> -#define early_pfn_in_nid(pfn, nid)	(early_pfn_to_nid(pfn) == (nid))
> -#else
> -#define early_pfn_in_nid(pfn, nid)	(1)
> -#endif
> +int __meminit early_pfn_in_nid(unsigned long pfn, int nid);
>
>  #ifndef early_pfn_valid
>  #define early_pfn_valid(pfn)	(1)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5675b30..708837e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3005,6 +3005,34 @@ int __meminit early_pfn_to_nid(unsigned long pfn)
>  }
>  #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
>
> +#ifdef CONFIG_NODES_SPAN_OTHER_NODES
> +/*
> + * Returns true if the PFN is within the NID or it is within a hole.
> + * If the PFN is in a hole, we still initialise the memmap so that
> + * walkers of the memmap do not get confused
> + */
> +int __meminit early_pfn_in_nid(unsigned long pfn, int nid)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_nodemap_entries; i++) {
> +		unsigned long start_pfn = early_node_map[i].start_pfn;
> +		unsigned long end_pfn = early_node_map[i].end_pfn;
> +
> +		if (start_pfn <= pfn && pfn < end_pfn)
> +			return early_node_map[i].nid == nid;
> +	}
> +
> +	/* The PFN is within a hole so it'll be ok to initialise */
> +	return 1;
> +}
> +#else
> +int __meminit early_pfn_in_nid(unsigned long pfn, int nid)
> +{
> +	return 1;
> +}
> +#endif
> +
>  /* Basic iterator support to walk early_node_map[] */
>  #define for_each_active_range_index_in_nid(i, nid) \
>  	for (i = first_active_region_index_in_nid(nid); i != -1; \
>
> --
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


