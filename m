Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbZFJBw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbZFJBw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 21:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbZFJBwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 21:52:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60556 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZFJBwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:52:21 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/4] Do not unconditionally treat zones that fail zone_reclaim() as full
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1244566904-31470-3-git-send-email-mel@csn.ul.ie>
References: <1244566904-31470-1-git-send-email-mel@csn.ul.ie> <1244566904-31470-3-git-send-email-mel@csn.ul.ie>
Message-Id: <20090610104935.DDA9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 10 Jun 2009 10:52:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  			mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
> -			if (!zone_watermark_ok(zone, order, mark,
> -				    classzone_idx, alloc_flags)) {
> -				if (!zone_reclaim_mode ||
> -				    !zone_reclaim(zone, gfp_mask, order))
> +			if (zone_watermark_ok(zone, order, mark,
> +				    classzone_idx, alloc_flags))
> +				goto try_this_zone;
> +
> +			if (zone_reclaim_mode == 0)
> +				goto this_zone_full;
> +
> +			ret = zone_reclaim(zone, gfp_mask, order);
> +			switch (ret) {
> +			case ZONE_RECLAIM_NOSCAN:
> +				/* did not scan */
> +				goto try_next_zone;
> +			case ZONE_RECLAIM_FULL:
> +				/* scanned but unreclaimable */
> +				goto this_zone_full;
> +			default:
> +				/* did we reclaim enough */
> +				if (!zone_watermark_ok(zone, order, mark,
> +						classzone_idx, alloc_flags))
>  					goto this_zone_full;

ok, this version's change are minimal than previous.
I'm not afraid this patch now. thanks.


	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



