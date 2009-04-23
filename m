Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbZDWWyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbZDWWyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZDWWyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:54:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbZDWWyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:54:31 -0400
Date: Thu, 23 Apr 2009 15:48:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: mel@csn.ul.ie, linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
       cl@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       ming.m.lin@intel.com, yanmin_zhang@linux.intel.com,
       peterz@infradead.org, penberg@cs.helsinki.fi
Subject: Re: [PATCH 07/22] Calculate the preferred zone for allocation only
 once
Message-Id: <20090423154834.bde33a72.akpm@linux-foundation.org>
In-Reply-To: <1240408407-21848-8-git-send-email-mel@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
	<1240408407-21848-8-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 14:53:12 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> get_page_from_freelist() can be called multiple times for an allocation.
> Part of this calculates the preferred_zone which is the first usable zone
> in the zonelist but the zone depends on the GFP flags specified at the
> beginning of the allocation call. This patch calculates preferred_zone
> once. It's safe to do this because if preferred_zone is NULL at the start
> of the call, no amount of direct reclaim or other actions will change the
> fact the allocation will fail.
> 
>
> ...
>
> -	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
> -
>							&preferred_zone);
> ...  
>
> +	/* The preferred zone is used for statistics later */
> +	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,

Let's quietly zap that dopey cast.

--- a/mm/page_alloc.c~page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix
+++ a/mm/page_alloc.c
@@ -1775,8 +1775,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 		return NULL;
 
 	/* The preferred zone is used for statistics later */
-	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
-							&preferred_zone);
+	first_zones_zonelist(zonelist, high_zoneidx, nodemask, &preferred_zone);
 	if (!preferred_zone)
 		return NULL;
 
_

