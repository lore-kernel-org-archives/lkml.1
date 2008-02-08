Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbYBHVxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbYBHVxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYBHVxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:53:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59374 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbYBHVxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:53:07 -0500
Date: Fri, 8 Feb 2008 13:51:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] fix sparse warning from include/linux/mmzone.h
Message-Id: <20080208135154.ccdac0c1.akpm@linux-foundation.org>
In-Reply-To: <1202417543.31361.5.camel@brick>
References: <1202417543.31361.5.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2008 12:52:23 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> include/linux/mmzone.h:640:22: warning: potentially expensive pointer subtraction
> 
> The code in question was doing a pointer subtraction to find the index of
> the zone argument in the node_zones array.  This essentially boils down to:
> 
> ((unsigned long)zone - (unsigned long)zone->zone_pgdat->node_zones)/sizeof(struct zone)
> 
> Which can be expensive if struct zone is not a power of two.  Instead, just
> calculate the offsets rather than the index in the array.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> This shows up > 30 times in an x86 allyesconfig, would be nice to get
> rid of it and makes the code a little more efficient.  I believe this
> is correct, unless there is a subtlety I have missed.
> 
>  include/linux/mmzone.h |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 8d8d197..cb07758 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -637,9 +637,12 @@ static inline int is_normal_idx(enum zone_type idx)
>  static inline int is_highmem(struct zone *zone)
>  {
>  #ifdef CONFIG_HIGHMEM
> -	int zone_idx = zone - zone->zone_pgdat->node_zones;
> -	return zone_idx == ZONE_HIGHMEM ||
> -		(zone_idx == ZONE_MOVABLE && zone_movable_is_highmem());
> +	const int highmem_off = ZONE_HIGHMEM * sizeof(*zone);
> +	const int movable_off = ZONE_MOVABLE * sizeof(*zone);
> +
> +	int zone_off = (unsigned long)zone - (unsigned long)zone->zone_pgdat->node_zones;
> +	return zone_off == highmem_off ||
> +		(zone_off == movable_off && zone_movable_is_highmem());
>  #else
>  	return 0;
>  #endif
> -- 

hrm.  For my i386 build (and that's where CONFIG_HIGHMEM really matters)
this patch makes mm/page_alloc.o six bytes larger, and I don't think the
change did much for readability.

