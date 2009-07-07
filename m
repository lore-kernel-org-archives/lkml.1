Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbZGGACy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbZGGACy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbZGGABb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:01:31 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:54172 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbZGGAB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:01:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=KnC7ZhgtGh9uXg7Vc9Fq1M1rKcQE98ZzVy9QDznSsYYs0+/iXmo3lKHPSREexSAXKM
         o846XvlJmVt1hmFuYWABsOToDAi88J/dyU2SHIVcj3tXX1mnGuPHAc1Mrc1Bt09XY3yL
         1+YVsvUHgt89WaAOgXGdNexdN6zFC4tQvQWyc=
Date: Tue, 7 Jul 2009 09:01:20 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
Message-Id: <20090707090120.1e71a060.minchan.kim@barrios-desktop>
In-Reply-To: <20090706204412.0C5D.A69D9226@jp.fujitsu.com>
References: <28c262360907050751t1fccbf4t4ace572b4e003a13@mail.gmail.com>
	<20090706182750.0C54.A69D9226@jp.fujitsu.com>
	<20090706204412.0C5D.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> ============ CUT HERE ===============
> Subject: [PATCH] add isolate pages vmstat
> 
> If the system have plenty threads or processes, concurrent reclaim can
> isolate very much pages.
> Unfortunately, current /proc/meminfo and OOM log can't show it.
> 
> This patch provide the way of showing this information.
> 
> 
> reproduce way
> -----------------------
> % ./hackbench 140 process 1000
>    => couse OOM
> 
> Active_anon:146 active_file:41 inactive_anon:0
>  inactive_file:0 unevictable:0
>  isolated_anon:49245 isolated_file:113
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  dirty:0 writeback:0 buffer:49 unstable:0
>  free:184 slab_reclaimable:276 slab_unreclaimable:5492
>  mapped:87 pagetables:28239 bounce:0
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  drivers/base/node.c    |    4 ++++
>  fs/proc/meminfo.c      |    4 ++++
>  include/linux/mmzone.h |    2 ++
>  mm/page_alloc.c        |   10 ++++++++--
>  mm/vmscan.c            |    5 +++++
>  mm/vmstat.c            |    3 ++-
>  6 files changed, 25 insertions(+), 3 deletions(-)
> 
> Index: b/fs/proc/meminfo.c
> ===================================================================
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -65,6 +65,8 @@ static int meminfo_proc_show(struct seq_
>  		"Active(file):   %8lu kB\n"
>  		"Inactive(file): %8lu kB\n"
>  		"Unevictable:    %8lu kB\n"
> +		"Isolated(anon): %8lu kB\n"
> +		"Isolated(file): %8lu kB\n"
>  		"Mlocked:        %8lu kB\n"
>  #ifdef CONFIG_HIGHMEM
>  		"HighTotal:      %8lu kB\n"
> @@ -109,6 +111,8 @@ static int meminfo_proc_show(struct seq_
>  		K(pages[LRU_ACTIVE_FILE]),
>  		K(pages[LRU_INACTIVE_FILE]),
>  		K(pages[LRU_UNEVICTABLE]),
> +		K(global_page_state(NR_ISOLATED_ANON)),
> +		K(global_page_state(NR_ISOLATED_FILE)),
>  		K(global_page_state(NR_MLOCK)),
>  #ifdef CONFIG_HIGHMEM
>  		K(i.totalhigh),
> Index: b/include/linux/mmzone.h
> ===================================================================
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -100,6 +100,8 @@ enum zone_stat_item {
>  	NR_BOUNCE,
>  	NR_VMSCAN_WRITE,
>  	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
> +	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
> +	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
>  #ifdef CONFIG_NUMA
>  	NUMA_HIT,		/* allocated in intended node */
>  	NUMA_MISS,		/* allocated in non intended node */
> Index: b/mm/page_alloc.c
> ===================================================================
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2116,8 +2116,8 @@ void show_free_areas(void)
>  	}
>  
>  	printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
> -		" inactive_file:%lu"
> -		" unevictable:%lu"
> +		" inactive_file:%lu unevictable:%lu\n"
> +		" isolated_anon:%lu isolated_file:%lu\n"
>  		" dirty:%lu writeback:%lu buffer:%lu unstable:%lu\n"
>  		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
>  		" mapped:%lu pagetables:%lu bounce:%lu\n",
> @@ -2126,6 +2126,8 @@ void show_free_areas(void)
>  		global_page_state(NR_INACTIVE_ANON),
>  		global_page_state(NR_INACTIVE_FILE),
>  		global_page_state(NR_UNEVICTABLE),
> +		global_page_state(NR_ISOLATED_ANON),
> +		global_page_state(NR_ISOLATED_FILE),
>  		global_page_state(NR_FILE_DIRTY),
>  		global_page_state(NR_WRITEBACK),
>  		nr_blockdev_pages(),
> @@ -2151,6 +2153,8 @@ void show_free_areas(void)
>  			" active_file:%lukB"
>  			" inactive_file:%lukB"
>  			" unevictable:%lukB"
> +			" isolated(anon):%lukB"
> +			" isolated(file):%lukB"
>  			" present:%lukB"
>  			" mlocked:%lukB"
>  			" dirty:%lukB"
> @@ -2176,6 +2180,8 @@ void show_free_areas(void)
>  			K(zone_page_state(zone, NR_ACTIVE_FILE)),
>  			K(zone_page_state(zone, NR_INACTIVE_FILE)),
>  			K(zone_page_state(zone, NR_UNEVICTABLE)),
> +			K(zone_page_state(zone, NR_ISOLATED_ANON)),
> +			K(zone_page_state(zone, NR_ISOLATED_FILE)),
>  			K(zone->present_pages),
>  			K(zone_page_state(zone, NR_MLOCK)),
>  			K(zone_page_state(zone, NR_FILE_DIRTY)),
> Index: b/mm/vmscan.c
> ===================================================================
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1082,6 +1082,7 @@ static unsigned long shrink_inactive_lis
>  						-count[LRU_ACTIVE_ANON]);
>  		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
>  						-count[LRU_INACTIVE_ANON]);
> +		__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, nr_taken);

Lumpy can reclaim file + anon anywhere.  
How about using count[NR_LRU_LISTS]?
-- 
Kind regards,
Minchan Kim
