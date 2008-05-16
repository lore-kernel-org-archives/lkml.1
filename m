Return-Path: <linux-kernel-owner+w=401wt.eu-S1762201AbYEPSuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762201AbYEPSuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760811AbYEPSrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:47:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760791AbYEPSrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:47:51 -0400
Message-Id: <20080516183207.361608893@redhat.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 May 2008 14:32:07 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [patch 00/14] VM pageout scalability improvements (V7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On large memory systems, the VM can spend way too much time scanning
through pages that it cannot (or should not) evict from memory. Not
only does it use up CPU time, but it also provokes lock contention
and can leave large systems under memory presure in a catatonic state.

Against 2.6.25-rc2-mm1

This patch series improves VM scalability by:

1) putting filesystem backed, swap backed and non-reclaimable pages
   onto their own LRUs, so the system only scans the pages that it
   can/should evict from memory

2) switching to SEQ replacement for the anonymous LRUs, so the
   number of pages that need to be scanned when the system
   starts swapping is bound to a reasonable number

3) keeping non-reclaimable pages off the LRU completely, so the
   VM does not waste CPU time scanning them.  Currently only
   ramfs and SHM_LOCKED pages are kept on the noreclaim list,
   mlock()ed VMAs will be added later

More info on the overall design can be found at:

	http://linux-mm.org/PageReplacementDesign

An all-in-one patch can be found at:

	http://people.redhat.com/riel/splitvm/

Changelog:
- improve swap space freeing to deal with COW shared space
  (Lee Schermerhorn, Daisuke Nishimura & Minchan Kim)
- clean up PG_swapbacked setting in swapin path (Minchan Kim)
- properly invoke shrink_active_list for background aging (Minchan Kim)
- add authorship info to all patches (Rik van Riel)
- clean up (or move below ---) the comments for the commit logs (Rik van Riel)
- after some tests, reduce default swappiness to 20 for now (Rik van Riel)

- several code cleanups (minchan Kim)
- noreclaim patch refactoring and improvements (Lee Schermerhorn)
- several PROT_NONE and vma merging fixes (KOSAKI Motohiro)
- SMP bugfixes and efficiency improvements (Rik van Riel, Lee Schermerhorn)
- fix NUMA node stats printing (Lee Schermerhorn)
- remove the mlocked-VMA-noreclaim code for now, it still has
  bugs on IA64 and is holding up the merge (Rik van Riel)

- make page_alloc.c compile without CONFIG_NORECLAIM_MLOCK (minchan Kim)
- BUG() does not take an argument (minchan Kim) 
- clean up is_active_lru and is_file_lru (Andy Whitcroft)
- clean up shrink_active_list temp list names (KOSAKI Motohiro)
- add total active & inactive memory totals for vmstat -a (KOSAKI Motohiro)
- only try global anon page aging on global lru scans (KOSAKI Motohiro)
- make function descriptions follow the kernel-doc format (Rik van Riel)
- simplify mlock_vma_pages_range and munlock_vma_pages_range (Lee Schermerhorn)
- remove some more arguments, rename to mlock_vma_pages_all (Lee Schermerhorn)
- many code cleanups (Lee Schermerhorn)
- pass correct vma arg to mlock_vma_pages_range from do_brk (Rik van Riel)
- port to 2.6.25-rc3-mm1

- pull the memcontrol lru arrayification earlier into the patch series
- use a pagevec array similar to the lru array
- clean up the code in various places
- improved pageout balancing and reduced pageout cpu use

- fix compilation on PPC and without memcontrol
- make page_is_pagecache more readable
- replace get_scan_ratio with correct version

- merge memcontroller split LRU code into the main split LRU patch,
  since it is not functionally different (it was split up only to help
  people who had seen the last version of the patch series review it)
- drop the page_file_cache debugging patch, since it never triggered
- reintroduce code to not scan anon list if swap is full
- add code to scan anon list if page cache is very small already
- use lumpy reclaim more aggressively for smaller order > 1 allocations

-- 
All Rights Reversed

