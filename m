Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbZBWJPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbZBWJPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 04:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZBWJPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 04:15:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52358 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbZBWJPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:15:06 -0500
Message-ID: <49A268F1.2020509@cn.fujitsu.com>
Date: Mon, 23 Feb 2009 17:14:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 07/20] Simplify the check on whether cpusets are a factor
 or not
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-8-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1235344649-18265-8-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef CONFIG_CPUSETS
> +	/* Determine in advance if the cpuset checks will be needed */
> +	if ((alloc_flags & ALLOC_CPUSET) && unlikely(number_of_cpusets > 1))
> +		alloc_cpuset = 1;
> +#endif
> +
>  zonelist_scan:
>  	/*
>  	 * Scan zonelist, looking for a zone with enough free.
> @@ -1420,8 +1427,8 @@ zonelist_scan:
>  		if (NUMA_BUILD && zlc_active &&
>  			!zlc_zone_worth_trying(zonelist, z, allowednodes))
>  				continue;
> -		if ((alloc_flags & ALLOC_CPUSET) &&
> -			!cpuset_zone_allowed_softwall(zone, gfp_mask))
> +		if (alloc_cpuset)
> +			if (!cpuset_zone_allowed_softwall(zone, gfp_mask))

I think you can call __cpuset_zone_allowed_softwall() which won't
check number_of_cpusets, and note you should also define an empty
noop __xxx() for !CONFIG_CPUSETS.

>  				goto try_next_zone;
>  
>  		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
