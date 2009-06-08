Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbZFHNyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbZFHNyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbZFHNye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:54:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42187 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbZFHNyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:54:33 -0400
Date: Mon, 8 Jun 2009 14:54:33 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Reintroduce zone_reclaim_interval for when
	zone_reclaim() scans and fails to avoid CPU spinning at 100% on NUMA
Message-ID: <20090608135433.GD15070@csn.ul.ie>
References: <1244466090-10711-1-git-send-email-mel@csn.ul.ie> <1244466090-10711-2-git-send-email-mel@csn.ul.ie> <4A2D129D.3020309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4A2D129D.3020309@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 09:31:09AM -0400, Rik van Riel wrote:
> Mel Gorman wrote:
>
>> The scanning occurs because zone_reclaim() cannot tell
>> in advance the scan is pointless because the counters do not distinguish
>> between pagecache pages backed by disk and by RAM. 
>
> Yes it can.  Since 2.6.27, filesystem backed and swap/ram backed
> pages have been living on separate LRU lists. 

Yes, they're on separate LRU lists but they are not the only pages on those
lists. The tmpfs pages are mixed in together with anonymous pages so we
cannot use NR_*_ANON.

Look at patch 2 and where I introduced;

       /*
        * Work out how many page cache pages we can reclaim in this mode.
        *
        * NOTE: Ideally, tmpfs pages would be accounted as if they were
        *       NR_FILE_MAPPED as swap is required to discard those
        *       pages even when they are clean. However, there is no
        *       way of quickly identifying the number of tmpfs pages
        */
       pagecache_reclaimable = zone_page_state(zone, NR_FILE_PAGES);
       if (!(zone_reclaim_mode & RECLAIM_WRITE))
               pagecache_reclaimable -= zone_page_state(zone, NR_FILE_DIRTY);
       if (!(zone_reclaim_mode & RECLAIM_SWAP))
               pagecache_reclaimable -= zone_page_state(zone, NR_FILE_MAPPED);

If the tmpfs pages can be accounted for there, then chances are that patch
1 goes away - at least until some other situation is encountered where
we scan erroneously.

> This allows you to
> fix the underlying problem, instead of having to add a retry
> interval.
>

Which is obviously my preference but after looking around for a bit, I
didn't spot an obvious answer.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
