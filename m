Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbZFIDOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbZFIDOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 23:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbZFIDNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 23:13:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:53223 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZFIDNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 23:13:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,328,1241420400"; 
   d="scan'208";a="152085972"
Date: Tue, 9 Jun 2009 11:11:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "linuxram@us.ibm.com" <linuxram@us.ibm.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Do not unconditionally treat zones that fail
	zone_reclaim() as full
Message-ID: <20090609031119.GB7875@localhost>
References: <1244466090-10711-1-git-send-email-mel@csn.ul.ie> <1244466090-10711-4-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244466090-10711-4-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 09:01:30PM +0800, Mel Gorman wrote:
> On NUMA machines, the administrator can configure zone_reclaim_mode that
> is a more targetted form of direct reclaim. On machines with large NUMA
> distances for example, a zone_reclaim_mode defaults to 1 meaning that clean
> unmapped pages will be reclaimed if the zone watermarks are not being
> met. The problem is that zone_reclaim() failing at all means the zone
> gets marked full.
> 
> This can cause situations where a zone is usable, but is being skipped
> because it has been considered full. Take a situation where a large tmpfs
> mount is occuping a large percentage of memory overall. The pages do not
> get cleaned or reclaimed by zone_reclaim(), but the zone gets marked full
> and the zonelist cache considers them not worth trying in the future.
> 
> This patch makes zone_reclaim() return more fine-grained information about
> what occured when zone_reclaim() failued. The zone only gets marked full if
> it really is unreclaimable. If it's a case that the scan did not occur or
> if enough pages were not reclaimed with the limited reclaim_mode, then the
> zone is simply skipped.
> 
> There is a side-effect to this patch. Currently, if zone_reclaim()
> successfully reclaimed SWAP_CLUSTER_MAX, an allocation attempt would
> go ahead. With this patch applied, zone watermarks are rechecked after
> zone_reclaim() does some work.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Thanks for making the code a lot more readable :)

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

>  	/*
>  	 * Do not scan if the allocation should not be delayed.
>  	 */
>  	if (!(gfp_mask & __GFP_WAIT) || (current->flags & PF_MEMALLOC))
> -			return 0;
> +			return ZONE_RECLAIM_NOSCAN;

Why not kill the extra tab?

