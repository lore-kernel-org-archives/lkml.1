Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbZGPFa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbZGPFa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 01:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbZGPFaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 01:30:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51727 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422AbZGPFaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 01:30:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Jul 2009 14:29:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       fengguang.wu@intel.com, minchan.kim@gmail.com, riel@redhat.com
Subject: Re: + mm-vmstat-add-isolate-pages.patch added to -mm tree
Message-Id: <20090716142903.0c7f8a92.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200907160321.n6G3LaFZ028244@imap1.linux-foundation.org>
References: <200907160321.n6G3LaFZ028244@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 20:21:36 -0700
akpm@linux-foundation.org wrote:
> ------------------------------------------------------
> Subject: mm: vmstat: add isolate pages
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 

Hi, Kosaki,

> If the system is running a heavy load of processes then concurrent reclaim
> can isolate a large number of pages from the LRU. /proc/meminfo and the
> output generated for an OOM do not show how many pages were isolated.
> 
<snip>
 
> @@ -742,6 +746,13 @@ int migrate_pages(struct list_head *from
>  	struct page *page2;
>  	int swapwrite = current->flags & PF_SWAPWRITE;
>  	int rc;
> +	int flags;

unsigned long.

> +
> +	local_irq_save(flags);
> +	list_for_each_entry(page, from, lru)
> +		__inc_zone_page_state(page, NR_ISOLATED_ANON +
> +				      !!page_is_file_cache(page));
> +	local_irq_restore(flags);
>  

-Kame

>  	if (!swapwrite)
>  		current->flags |= PF_SWAPWRITE;
> diff -puN mm/page_alloc.c~mm-vmstat-add-isolate-pages mm/page_alloc.c
> --- a/mm/page_alloc.c~mm-vmstat-add-isolate-pages
> +++ a/mm/page_alloc.c
> @@ -2144,16 +2144,18 @@ void show_free_areas(void)
>  		}
>  	}
>  
> -	printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
> -		" inactive_file:%lu"
> +	printk("active_anon:%lu inactive_anon:%lu isolated_anon:%lu\n"
> +		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
>  		" unevictable:%lu"
>  		" dirty:%lu writeback:%lu unstable:%lu buffer:%lu\n"
>  		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
>  		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n",
>  		global_page_state(NR_ACTIVE_ANON),
> -		global_page_state(NR_ACTIVE_FILE),
>  		global_page_state(NR_INACTIVE_ANON),
> +		global_page_state(NR_ISOLATED_ANON),
> +		global_page_state(NR_ACTIVE_FILE),
>  		global_page_state(NR_INACTIVE_FILE),
> +		global_page_state(NR_ISOLATED_FILE),
>  		global_page_state(NR_UNEVICTABLE),
>  		global_page_state(NR_FILE_DIRTY),
>  		global_page_state(NR_WRITEBACK),
> @@ -2181,6 +2183,8 @@ void show_free_areas(void)
>  			" active_file:%lukB"
>  			" inactive_file:%lukB"
>  			" unevictable:%lukB"
> +			" isolated(anon):%lukB"
> +			" isolated(file):%lukB"
>  			" present:%lukB"
>  			" mlocked:%lukB"
>  			" dirty:%lukB"
> @@ -2207,6 +2211,8 @@ void show_free_areas(void)
>  			K(zone_page_state(zone, NR_ACTIVE_FILE)),
>  			K(zone_page_state(zone, NR_INACTIVE_FILE)),
>  			K(zone_page_state(zone, NR_UNEVICTABLE)),
> +			K(zone_page_state(zone, NR_ISOLATED_ANON)),
> +			K(zone_page_state(zone, NR_ISOLATED_FILE)),
>  			K(zone->present_pages),
>  			K(zone_page_state(zone, NR_MLOCK)),
>  			K(zone_page_state(zone, NR_FILE_DIRTY)),
> diff -puN mm/vmscan.c~mm-vmstat-add-isolate-pages mm/vmscan.c
> --- a/mm/vmscan.c~mm-vmstat-add-isolate-pages
> +++ a/mm/vmscan.c
> @@ -1067,6 +1067,8 @@ static unsigned long shrink_inactive_lis
>  		unsigned long nr_active;
>  		unsigned int count[NR_LRU_LISTS] = { 0, };
>  		int mode = lumpy_reclaim ? ISOLATE_BOTH : ISOLATE_INACTIVE;
> +		unsigned long nr_anon;
> +		unsigned long nr_file;
>  
>  		nr_taken = sc->isolate_pages(sc->swap_cluster_max,
>  			     &page_list, &nr_scan, sc->order, mode,
> @@ -1097,6 +1099,10 @@ static unsigned long shrink_inactive_lis
>  		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
>  						-count[LRU_INACTIVE_ANON]);
>  
> +		nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
> +		nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
> +		__mod_zone_page_state(zone, NR_ISOLATED_ANON, nr_anon);
> +		__mod_zone_page_state(zone, NR_ISOLATED_FILE, nr_file);
>  
>  		reclaim_stat->recent_scanned[0] += count[LRU_INACTIVE_ANON];
>  		reclaim_stat->recent_scanned[0] += count[LRU_ACTIVE_ANON];
> @@ -1164,6 +1170,9 @@ static unsigned long shrink_inactive_lis
>  				spin_lock_irq(&zone->lru_lock);
>  			}
>  		}
> +		__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
> +		__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
> +
>    	} while (nr_scanned < max_scan);
>  
>  done:
> @@ -1274,6 +1283,7 @@ static void shrink_active_list(unsigned 
>  		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -nr_taken);
>  	else
>  		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -nr_taken);
> +	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, nr_taken);
>  	spin_unlock_irq(&zone->lru_lock);
>  
>  	while (!list_empty(&l_hold)) {
> @@ -1324,7 +1334,7 @@ static void shrink_active_list(unsigned 
>  						LRU_ACTIVE + file * LRU_FILE);
>  	move_active_pages_to_lru(zone, &l_inactive,
>  						LRU_BASE   + file * LRU_FILE);
> -
> +	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
>  	spin_unlock_irq(&zone->lru_lock);
>  }
>  
> diff -puN mm/vmstat.c~mm-vmstat-add-isolate-pages mm/vmstat.c
> --- a/mm/vmstat.c~mm-vmstat-add-isolate-pages
> +++ a/mm/vmstat.c
> @@ -644,6 +644,8 @@ static const char * const vmstat_text[] 
>  	"nr_bounce",
>  	"nr_vmscan_write",
>  	"nr_writeback_temp",
> +	"nr_isolated_anon",
> +	"nr_isolated_file",
>  	"nr_shmem",
>  #ifdef CONFIG_NUMA
>  	"numa_hit",
> _
> 
> Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are
> 
> linux-next.patch
> mm-copy-over-oom_adj-value-at-fork-time.patch
> readahead-add-blk_run_backing_dev.patch
> readahead-add-blk_run_backing_dev-fix.patch
> readahead-add-blk_run_backing_dev-fix-fix-2.patch
> mm-clean-up-page_remove_rmap.patch
> mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch
> mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
> mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
> mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
> mm-oom-analysis-add-shmem-vmstat.patch
> mm-rename-pgmoved-variable-in-shrink_active_list.patch
> mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
> mm-vmstat-add-isolate-pages.patch
> getrusage-fill-ru_maxrss-value.patch
> getrusage-fill-ru_maxrss-value-update.patch
> fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch
> 
> --
> To unsubscribe from this list: send the line "unsubscribe mm-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

