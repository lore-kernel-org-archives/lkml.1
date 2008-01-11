Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbYAKKmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbYAKKmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 05:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbYAKKmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 05:42:07 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39339 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740AbYAKKmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 05:42:03 -0500
Date: Fri, 11 Jan 2008 16:11:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 00/19] VM pageout scalability improvements
Message-ID: <20080111104115.GA19814@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Rik van Riel <riel@redhat.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20080108205939.323955454@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080108205939.323955454@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel <riel@redhat.com> [2008-01-08 15:59:39]:

> On large memory systems, the VM can spend way too much time scanning
> through pages that it cannot (or should not) evict from memory. Not
> only does it use up CPU time, but it also provokes lock contention
> and can leave large systems under memory presure in a catatonic state.
> 
> Against 2.6.24-rc6-mm1
> 
> This patch series improves VM scalability by:
> 
> 1) making the locking a little more scalable
> 
> 2) putting filesystem backed, swap backed and non-reclaimable pages
>    onto their own LRUs, so the system only scans the pages that it
>    can/should evict from memory
> 
> 3) switching to SEQ replacement for the anonymous LRUs, so the
>    number of pages that need to be scanned when the system
>    starts swapping is bound to a reasonable number
> 
> More info on the overall design can be found at:
> 
> 	http://linux-mm.org/PageReplacementDesign
> 
> 
> Changelog:
> - merge memcontroller split LRU code into the main split LRU patch,
>   since it is not functionally different (it was split up only to help
>   people who had seen the last version of the patch series review it)
> - drop the page_file_cache debugging patch, since it never triggered
> - reintroduce code to not scan anon list if swap is full
> - add code to scan anon list if page cache is very small already
> - use lumpy reclaim more aggressively for smaller order > 1 allocations
>

Hi, Rik,

I've just started the patch series, the compile fails for me on a
powerpc box. global_lru_pages() is defined under CONFIG_PM, but used
else where in mm/page-writeback.c. None of the global_lru_pages()
parameters depend on CONFIG_PM. Here's a simple patch to fix it.

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b14e188..39e6aef 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1920,6 +1920,14 @@ void wakeup_kswapd(struct zone *zone, int order)
 	wake_up_interruptible(&pgdat->kswapd_wait);
 }
 
+unsigned long global_lru_pages(void)
+{
+	return global_page_state(NR_ACTIVE_ANON)
+		+ global_page_state(NR_ACTIVE_FILE)
+		+ global_page_state(NR_INACTIVE_ANON)
+		+ global_page_state(NR_INACTIVE_FILE);
+}
+
 #ifdef CONFIG_PM
 /*
  * Helper function for shrink_all_memory().  Tries to reclaim 'nr_pages' pages
@@ -1968,14 +1976,6 @@ static unsigned long shrink_all_zones(unsigned long nr_pages, int prio,
 	return ret;
 }
 
-unsigned long global_lru_pages(void)
-{
-	return global_page_state(NR_ACTIVE_ANON)
-		+ global_page_state(NR_ACTIVE_FILE)
-		+ global_page_state(NR_INACTIVE_ANON)
-		+ global_page_state(NR_INACTIVE_FILE);
-}
-
 /*
  * Try to free `nr_pages' of memory, system-wide, and return the number of
  * freed pages.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
