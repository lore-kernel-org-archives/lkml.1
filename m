Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbYE0Qy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbYE0Qy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758691AbYE0QyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:54:16 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:16811 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534AbYE0QyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:54:15 -0400
Subject: Re: [PATCH -mm 02/16] Use an indexed array for LRU variables
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20080523195534.918991067@redhat.com>
References: <20080523195506.084894989@redhat.com>
	 <20080523195534.918991067@redhat.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 27 May 2008 12:54:22 -0400
Message-Id: <1211907262.7283.30.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 15:55 -0400, Rik van Riel wrote:
> plain text document attachment
> (cl-use-indexed-array-of-lru-lists.patch)
> From: Christoph Lameter <clameter@sgi.com>
> 
> Currently we are defining explicit variables for the inactive
> and active list. An indexed array can be more generic and avoid
> repeating similar code in several places in the reclaim code.
> 
> We are saving a few bytes in terms of code size:
> 
> Before:
> 
>    text    data     bss     dec     hex filename
> 4097753  573120 4092484 8763357  85b7dd vmlinux
> 
> After:
> 
>    text    data     bss     dec     hex filename
> 4097729  573120 4092484 8763333  85b7c5 vmlinux
> 
> Having an easy way to add new lru lists may ease future work on
> the reclaim code.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
> V3 [riel]: memcontrol LRU arrayification
> 
> V1 -> V2 [lts]:
> + Remove extraneous  __dec_zone_state(zone, NR_ACTIVE) pointed
>   out by Mel G.
> 
> 
>  include/linux/memcontrol.h |   17 +-----
>  include/linux/mm_inline.h  |   33 ++++++++----
>  include/linux/mmzone.h     |   17 ++++--
>  mm/memcontrol.c            |  115 ++++++++++++++++---------------------------
>  mm/page_alloc.c            |    9 +--
>  mm/swap.c                  |    2 
>  mm/vmscan.c                |  120 +++++++++++++++++++++------------------------
>  mm/vmstat.c                |    3 -
>  8 files changed, 146 insertions(+), 170 deletions(-)
> 
> Index: linux-2.6.26-rc2-mm1/include/linux/mmzone.h
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/include/linux/mmzone.h	2008-05-23 14:21:21.000000000 -0400
> +++ linux-2.6.26-rc2-mm1/include/linux/mmzone.h	2008-05-23 14:21:33.000000000 -0400
> @@ -81,8 +81,8 @@ struct zone_padding {
>  enum zone_stat_item {
>  	/* First 128 byte cacheline (assuming 64 bit words) */
>  	NR_FREE_PAGES,
> -	NR_INACTIVE,
> -	NR_ACTIVE,
> +	NR_INACTIVE,	/* must match order of LRU_[IN]ACTIVE */
> +	NR_ACTIVE,	/*  "     "     "   "       "         */
>  	NR_ANON_PAGES,	/* Mapped anonymous pages */
>  	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
>  			   only modified from process context */
> @@ -107,6 +107,13 @@ enum zone_stat_item {
>  #endif
>  	NR_VM_ZONE_STAT_ITEMS };
>  
> +enum lru_list {
> +	LRU_INACTIVE,	/* must match order of NR_[IN]ACTIVE */
> +	LRU_ACTIVE,	/*  "     "     "   "       "        */
> +	NR_LRU_LISTS };
> +
> +#define for_each_lru(l) for (l = 0; l < NR_LRU_LISTS; l++)
> +
>  struct per_cpu_pages {
>  	int count;		/* number of pages in the list */
>  	int high;		/* high watermark, emptying needed */
> @@ -251,10 +258,8 @@ struct zone {
>  
>  	/* Fields commonly accessed by the page reclaim scanner */
>  	spinlock_t		lru_lock;	
> -	struct list_head	active_list;
> -	struct list_head	inactive_list;
> -	unsigned long		nr_scan_active;
> -	unsigned long		nr_scan_inactive;
> +	struct list_head	list[NR_LRU_LISTS];
> +	unsigned long		nr_scan[NR_LRU_LISTS];
>  	unsigned long		pages_scanned;	   /* since last reclaim */
>  	unsigned long		flags;		   /* zone flags, see below */
>  
> Index: linux-2.6.26-rc2-mm1/include/linux/mm_inline.h
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/include/linux/mm_inline.h	2008-05-23 14:21:21.000000000 -0400
> +++ linux-2.6.26-rc2-mm1/include/linux/mm_inline.h	2008-05-23 14:21:33
> 

Rik:  looks like this patch got truncated somewhere along the way.

Lee

