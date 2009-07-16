Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbZGPO0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbZGPO0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbZGPO0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:26:32 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:52563 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757225AbZGPO0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:26:32 -0400
Date: Thu, 16 Jul 2009 10:26:25 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/3] add isolate pages vmstat
In-Reply-To: <20090716095344.9D10.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0907161024120.32382@gentwo.org>
References: <20090716094619.9D07.A69D9226@jp.fujitsu.com> <20090716095344.9D10.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, KOSAKI Motohiro wrote:

> Index: b/mm/migrate.c
> ===================================================================
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -67,6 +67,8 @@ int putback_lru_pages(struct list_head *
>
>  	list_for_each_entry_safe(page, page2, l, lru) {
>  		list_del(&page->lru);
> +		dec_zone_page_state(page, NR_ISOLATED_ANON +
> +				    !!page_is_file_cache(page));
>  		putback_lru_page(page);
>  		count++;
>  	}

ok.

> @@ -696,6 +698,8 @@ unlock:
>   		 * restored.
>   		 */
>   		list_del(&page->lru);
> +		dec_zone_page_state(page, NR_ISOLATED_ANON +
> +				    !!page_is_file_cache(page));
>  		putback_lru_page(page);
>  	}
>

ok.

> @@ -740,6 +744,13 @@ int migrate_pages(struct list_head *from
>  	struct page *page2;
>  	int swapwrite = current->flags & PF_SWAPWRITE;
>  	int rc;
> +	int flags;
> +
> +	local_irq_save(flags);
> +	list_for_each_entry(page, from, lru)
> +		__inc_zone_page_state(page, NR_ISOLATED_ANON +
> +				      !!page_is_file_cache(page));
> +	local_irq_restore(flags);
>

Why do a separate pass over all the migrates pages? Can you add the
_inc_xx  somewhere after the page was isolated from the lru by calling
try_to_unmap()?
