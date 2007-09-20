Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbXITMPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbXITMPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbXITMPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:15:39 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:52243 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750789AbXITMPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:15:38 -0400
Date: Thu, 20 Sep 2007 14:15:31 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, spamtrap@knobisoft.de
Subject: Re: 2.6.23-rc6-mm1 -- mkfs stuck in 'D'
Message-ID: <20070920141531.534502c1@twins>
In-Reply-To: <Pine.LNX.4.64.0709201210470.13752@blonde.wat.veritas.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<20070919164348.GC2519@shadowen.org>
	<Pine.LNX.4.64.0709192035370.14804@blonde.wat.veritas.com>
	<20070919224409.24baa75b@lappy>
	<Pine.LNX.4.64.0709201210470.13752@blonde.wat.veritas.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 12:31:39 +0100 (BST) Hugh Dickins
<hugh@veritas.com> wrote:


Thanks Hugh!

> [PATCH mm] mm per-device dirty threshold fix
> 
> Fix occasional hang when a task couldn't get out of balance_dirty_pages:
> mm-per-device-dirty-threshold.patch needs to reevaluate bdi_nr_writeback
> across all cpus when bdi_thresh is low, even in the case when there was
> no bdi_nr_reclaimable.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  mm/page-writeback.c |   53 +++++++++++++++++++-----------------------
>  1 file changed, 24 insertions(+), 29 deletions(-)
> 
> --- 2.6.23-rc6-mm1/mm/page-writeback.c	2007-09-18 12:28:25.000000000 +0100
> +++ linux/mm/page-writeback.c	2007-09-19 20:00:46.000000000 +0100
> @@ -379,7 +379,7 @@ static void balance_dirty_pages(struct a
>  		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
>  		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
>  		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
> -				break;
> +			break;
>  
>  		if (!bdi->dirty_exceeded)
>  			bdi->dirty_exceeded = 1;
> @@ -392,39 +392,34 @@ static void balance_dirty_pages(struct a
>  		 */
>  		if (bdi_nr_reclaimable) {
>  			writeback_inodes(&wbc);
> -
> +			pages_written += write_chunk - wbc.nr_to_write;
>  			get_dirty_limits(&background_thresh, &dirty_thresh,
>  				       &bdi_thresh, bdi);
> +		}
>  
> -			/*
> -			 * In order to avoid the stacked BDI deadlock we need
> -			 * to ensure we accurately count the 'dirty' pages when
> -			 * the threshold is low.
> -			 *
> -			 * Otherwise it would be possible to get thresh+n pages
> -			 * reported dirty, even though there are thresh-m pages
> -			 * actually dirty; with m+n sitting in the percpu
> -			 * deltas.
> -			 */
> -			if (bdi_thresh < 2*bdi_stat_error(bdi)) {
> -				bdi_nr_reclaimable =
> -					bdi_stat_sum(bdi, BDI_RECLAIMABLE);
> -				bdi_nr_writeback =
> -					bdi_stat_sum(bdi, BDI_WRITEBACK);
> -			} else {
> -				bdi_nr_reclaimable =
> -					bdi_stat(bdi, BDI_RECLAIMABLE);
> -				bdi_nr_writeback =
> -					bdi_stat(bdi, BDI_WRITEBACK);
> -			}
> +		/*
> +		 * In order to avoid the stacked BDI deadlock we need
> +		 * to ensure we accurately count the 'dirty' pages when
> +		 * the threshold is low.
> +		 *
> +		 * Otherwise it would be possible to get thresh+n pages
> +		 * reported dirty, even though there are thresh-m pages
> +		 * actually dirty; with m+n sitting in the percpu
> +		 * deltas.
> +		 */
> +		if (bdi_thresh < 2*bdi_stat_error(bdi)) {
> +			bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
> +			bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
> +		} else if (bdi_nr_reclaimable) {
> +			bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
> +			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
> +		}
>  
> -			if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
> -				break;
> +		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
> +			break;
> +		if (pages_written >= write_chunk)
> +			break;		/* We've done our duty */
>  
> -			pages_written += write_chunk - wbc.nr_to_write;
> -			if (pages_written >= write_chunk)
> -				break;		/* We've done our duty */
> -		}
>  		congestion_wait(WRITE, HZ/10);
>  	}
>  
