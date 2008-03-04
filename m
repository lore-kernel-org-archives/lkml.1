Return-Path: <linux-kernel-owner+w=401wt.eu-S934144AbYCDXDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144AbYCDXDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934133AbYCDXCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:02:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934118AbYCDXC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:02:26 -0500
Message-Id: <20080304225157.573336066@redhat.com>
User-Agent: quilt/0.46-1
Date: Tue, 04 Mar 2008 17:51:57 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [patch 00/20] VM pageout scalability improvements (V5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On large memory systems, the VM can spend way too much time scanning
through pages that it cannot (or should not) evict from memory. Not
only does it use up CPU time, but it also provokes lock contention
and can leave large systems under memory presure in a catatonic state.

Against 2.6.25-rc3-mm1

This patch series improves VM scalability by:

1) making the locking a little more scalable

2) putting filesystem backed, swap backed and non-reclaimable pages
   onto their own LRUs, so the system only scans the pages that it
   can/should evict from memory

3) switching to SEQ replacement for the anonymous LRUs, so the
   number of pages that need to be scanned when the system
   starts swapping is bound to a reasonable number

More info on the overall design can be found at:

	http://linux-mm.org/PageReplacementDesign

An all-in-one patch can be found at:

	http://people.redhat.com/riel/splitvm/

Changelog:
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

