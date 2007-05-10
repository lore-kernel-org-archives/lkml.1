Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbXEJPfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbXEJPfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbXEJPfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:35:39 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:54185 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbXEJPfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:35:39 -0400
Date: Thu, 10 May 2007 16:35:37 +0100 (IST)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@osdl.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [RFC] memory hotremove patch take 2 [03/10] (drain all pages)
In-Reply-To: <20070509120337.B90A.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0705101634350.3786@skynet.skynet.ie>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
 <20070509120337.B90A.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Yasunori Goto wrote:

> This patch add function drain_all_pages(void) to drain all
> pages on per-cpu-freelist.
> Page isolation will catch them in free_one_page.
>

Is this significantly different to what drain_all_local_pages() currently 
does?

> Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
>
> include/linux/page_isolation.h |    1 +
> mm/page_alloc.c                |   13 +++++++++++++
> 2 files changed, 14 insertions(+)
>
> Index: current_test/mm/page_alloc.c
> ===================================================================
> --- current_test.orig/mm/page_alloc.c	2007-05-08 15:08:03.000000000 +0900
> +++ current_test/mm/page_alloc.c	2007-05-08 15:08:33.000000000 +0900
> @@ -1070,6 +1070,19 @@ void drain_all_local_pages(void)
> 	smp_call_function(smp_drain_local_pages, NULL, 0, 1);
> }
>
> +#ifdef CONFIG_PAGE_ISOLATION
> +static void drain_local_zone_pages(struct work_struct *work)
> +{
> +	drain_local_pages();
> +}
> +
> +void drain_all_pages(void)
> +{
> +	schedule_on_each_cpu(drain_local_zone_pages);
> +}
> +
> +#endif /* CONFIG_PAGE_ISOLATION */
> +
> /*
>  * Free a 0-order page
>  */
> Index: current_test/include/linux/page_isolation.h
> ===================================================================
> --- current_test.orig/include/linux/page_isolation.h	2007-05-08 15:08:03.000000000 +0900
> +++ current_test/include/linux/page_isolation.h	2007-05-08 15:08:33.000000000 +0900
> @@ -39,6 +39,7 @@ extern void detach_isolation_info_zone(s
> extern void free_isolation_info(struct isolation_info *info);
> extern void unuse_all_isolated_pages(struct isolation_info *info);
> extern void free_all_isolated_pages(struct isolation_info *info);
> +extern void drain_all_pages(void);
>
> #else
>
>
> -- 
> Yasunori Goto
>
>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
