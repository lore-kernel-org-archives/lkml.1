Return-Path: <linux-kernel-owner+w=401wt.eu-S1760660AbZENMCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660AbZENMCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760721AbZENMCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:02:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50127 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761145AbZENMCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:02:34 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Robin Holt <holt@sgi.com>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090514114827.GN7601@sgi.com>
References: <20090514170721.9B75.A69D9226@jp.fujitsu.com> <20090514114827.GN7601@sgi.com>
Message-Id: <20090514205654.9B8A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 May 2009 21:02:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Unfortunately no.
> > zone reclaim has two weakness by design.
> > 
> > 1.
> > zone reclaim don't works well when workingset size > local node size.
> > but it can happen easily on small machine.
> > if it happen, zone reclaim drop own process's memory.
> > 
> > Plus, zone reclaim also doesn't fit DB server. its process has large
> > workingset.
> 
> Large DB server is not your typical desktop application either.

ack.


> > 2.
> > zone reclaim have inter zone balancing issue.
> > 
> > example: x86_64 2node 8G machine has following zone assignment
> > 
> >    zone 0 (DMA32):  3GB
> >    zone 0 (Normal): 1GB
> >    zone 1 (Normal): 4GB
> > 
> > if the page is allocated from DMA32, you are lucky. DMA32 isn't reclaimed
> > so freqently. but if from zone0 Normal, you are unlucky.
> > it is very frequent reclaimed although it is small than other zone.
> 
> I have seen that behavior on some of our mismatched large systems as well,
> although never had one so imbalanced because ia64 only has Normal.

not true.
some ia64 server has about 2GB DMA zone. SGI ia64 is special one.


> > I know my patch change large server default. but I believe linux
> > default kernel parameter adapt to desktop and entry machine.
> 
> If this imbalance is an x86_64 only problem, then we could do something
> simple like the following untested patch.  This leaves the default
> for everyone except x86_64.

not x86_64 only.
many 64bit architecture have 2 or 4GB DMA zone.

even though, your patch seems interesting. at least it solve
desktop user issue and we don't need to care another area user.

embedded and high-end server user is typically skillfull. they can
change kernel parameter by themself.


> 
> Robin
> 
> ------------------------------------------------------------------------
> 
> Even if there is a great node distance on x86_64, disable zone reclaim
> by default.  This was done to handle the imbalanced zone sizes where a
> majority of the memory in zone 0 is DMA32 with a small remaining Normal
> which will be aggressively reclaimed.
> 
> For other architectures, we leave the default behavior.
> 
> Signed-off-by: Robin Holt <holt@sgi.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Rik van Riel <riel@redhat.com>
> 
> ---
>  arch/x86/include/asm/topology.h |    2 ++
>  include/linux/topology.h        |    5 +++++
>  mm/page_alloc.c                 |    2 +-
>  3 files changed, 8 insertions(+), 1 deletion(-)
> Index: page_reclaim_mode/arch/x86/include/asm/topology.h
> ===================================================================
> --- page_reclaim_mode.orig/arch/x86/include/asm/topology.h	2009-05-14 06:44:20.118925713 -0500
> +++ page_reclaim_mode/arch/x86/include/asm/topology.h	2009-05-14 06:44:21.251067716 -0500
> @@ -128,6 +128,8 @@ extern unsigned long node_remap_size[];
>  
>  #endif
>  
> +#define DEFAULT_ZONE_RECLAIM_MODE	0
> +
>  /* sched_domains SD_NODE_INIT for NUMA machines */
>  #define SD_NODE_INIT (struct sched_domain) {		\
>  	.min_interval		= 8,			\
> Index: page_reclaim_mode/include/linux/topology.h
> ===================================================================
> --- page_reclaim_mode.orig/include/linux/topology.h	2009-05-14 06:44:20.070919619 -0500
> +++ page_reclaim_mode/include/linux/topology.h	2009-05-14 06:44:21.279071382 -0500
> @@ -61,6 +61,11 @@ int arch_update_cpu_topology(void);
>   */
>  #define RECLAIM_DISTANCE 20
>  #endif
> +
> +#ifndef DEFAULT_ZONE_RECLAIM_MODE
> +#define DEFAULT_ZONE_RECLAIM_MODE	1
> +#endif
> +
>  #ifndef PENALTY_FOR_NODE_WITH_CPUS
>  #define PENALTY_FOR_NODE_WITH_CPUS	(1)
>  #endif
> Index: page_reclaim_mode/mm/page_alloc.c
> ===================================================================
> --- page_reclaim_mode.orig/mm/page_alloc.c	2009-05-14 06:44:20.138928363 -0500
> +++ page_reclaim_mode/mm/page_alloc.c	2009-05-14 06:44:21.311075244 -0500
> @@ -2331,7 +2331,7 @@ static void build_zonelists(pg_data_t *p
>  		 * to reclaim pages in a zone before going off node.
>  		 */
>  		if (distance > RECLAIM_DISTANCE)
> -			zone_reclaim_mode = 1;
> +			zone_reclaim_mode = DEFAULT_ZONE_RECLAIM_MODE;
>  
>  		/*
>  		 * We don't want to pressure a particular node.



