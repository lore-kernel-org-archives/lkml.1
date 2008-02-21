Return-Path: <linux-kernel-owner+w=401wt.eu-S1759081AbYBUJxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081AbYBUJxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762424AbYBUJxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:53:08 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:39087 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762175AbYBUJxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:53:06 -0500
Message-ID: <47BD48F3.3040903@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2008 15:18:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] the proposal of improve page reclaim by throttle
References: <20080219134715.7E90.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080219134715.7E90.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> background
> ========================================
> current VM implementation doesn't has limit of # of parallel reclaim.
> when heavy workload, it bring to 2 bad things
>   - heavy lock contention
>   - unnecessary swap out
> 
> abount 2 month ago, KAMEZA Hiroyuki proposed the patch of page 
> reclaim throttle and explain it improve reclaim time.
> 	http://marc.info/?l=linux-mm&m=119667465917215&w=2
> 
> but unfortunately it works only memcgroup reclaim.
> Today, I implement it again for support global reclaim and mesure it.
> 

Hi, Kosaki,

It's good to keep the main reclaim code and the memory controller reclaim in
sync, so this is a nice effort.

> @@ -1456,7 +1501,7 @@ unsigned long try_to_free_mem_cgroup_pag
>  	int target_zone = gfp_zone(GFP_HIGHUSER_MOVABLE);
> 
>  	zones = NODE_DATA(numa_node_id())->node_zonelists[target_zone].zones;
> -	if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
> +	if (try_to_free_pages_throttled(zones, 0, sc.gfp_mask, &sc))
>  		return 1;
>  	return 0;
>  }
> 

try_to_free_pages_throttled checks for zone_watermark_ok(), that will not work
in the case that we are reclaiming from a cgroup which over it's limit. We need
a different check, to see if the mem_cgroup is still over it's limit or not.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
