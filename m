Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbYGBIHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbYGBIHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYGBIHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:07:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35251 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbYGBIH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:07:28 -0400
Date: Wed, 02 Jul 2008 17:06:25 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 2/4] pull out zone cpuset and watermark checks for reuse
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <1214935122-20828-3-git-send-email-apw@shadowen.org>
References: <1214935122-20828-1-git-send-email-apw@shadowen.org> <1214935122-20828-3-git-send-email-apw@shadowen.org>
Message-Id: <20080702165941.3817.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

this is nit.


> +/*
> + * Return 1 if this zone is an acceptable source given the cpuset
> + * constraints.
> + */
> +static inline int zone_cpuset_ok(struct zone *zone,
> +					int alloc_flags, gfp_t gfp_mask)
> +{
> +	if ((alloc_flags & ALLOC_CPUSET) &&
> +	    !cpuset_zone_allowed_softwall(zone, gfp_mask))
> +		return 0;
> +	return 1;
> +}

zone_cpuset_ok() seems cpuset sanity check.
but it is "allocatable?" check.

in addition, "ok" is slightly vague name, IMHO.


> +/*
> + * Return 1 if this zone is within the watermarks specified by the
> + * allocation flags.
> + */
> +static inline int zone_alloc_ok(struct zone *zone, int order,
> +			int classzone_idx, int alloc_flags, gfp_t gfp_mask)
> +{
> +	if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
> +		unsigned long mark;
> +		if (alloc_flags & ALLOC_WMARK_MIN)
> +			mark = zone->pages_min;
> +		else if (alloc_flags & ALLOC_WMARK_LOW)
> +			mark = zone->pages_low;
> +		else
> +			mark = zone->pages_high;
> +		if (!zone_watermark_ok(zone, order, mark,
> +			    classzone_idx, alloc_flags)) {
> +			if (!zone_reclaim_mode ||
> +					!zone_reclaim(zone, gfp_mask, order))
> +				return 0;
> +		}
> +	}
> +	return 1;
> +}

zone_alloc_ok() seems check "allocatable? or not".
So, I like zone_reclaim() go away from its function.



