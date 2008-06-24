Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYFXN2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYFXN2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 09:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYFXN2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 09:28:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYFXN2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 09:28:44 -0400
Date: Tue, 24 Jun 2008 09:28:24 -0400
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH] prevent incorrect oom under split_lru
Message-ID: <20080624092824.4f0440ca@bree.surriel.com>
In-Reply-To: <20080624171816.D835.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080624171816.D835.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 17:31:54 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> if zone->recent_scanned parameter become inbalanceing anon and file,
> OOM killer can happened although swappable page exist.
> 
> So, if priority==0, We should try to reclaim all page for prevent OOM.

You are absolutely right.  Good catch.

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

> ---
>  mm/vmscan.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Index: b/mm/vmscan.c
> ===================================================================
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1464,8 +1464,10 @@ static unsigned long shrink_zone(int pri
>  			 * kernel will slowly sift through each list.
>  			 */
>  			scan = zone_page_state(zone, NR_LRU_BASE + l);
> -			scan >>= priority;
> -			scan = (scan * percent[file]) / 100;
> +			if (priority) {
> +				scan >>= priority;
> +				scan = (scan * percent[file]) / 100;
> +			}
>  			zone->lru[l].nr_scan += scan + 1;
>  			nr[l] = zone->lru[l].nr_scan;
>  			if (nr[l] >= sc->swap_cluster_max)
> 


-- 
All rights reversed.
