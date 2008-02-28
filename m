Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbYB1Tnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbYB1Tnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763293AbYB1TmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:42:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762016AbYB1Tl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:41:57 -0500
Message-Id: <20080228192908.126720629@redhat.com>
User-Agent: quilt/0.46-1
Date: Thu, 28 Feb 2008 14:29:08 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org
Subject: [patch 00/21] VM pageout scalability improvements
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On large memory systems, the VM can spend way too much time scanning
through pages that it cannot (or should not) evict from memory. Not
only does it use up CPU time, but it also provokes lock contention
and can leave large systems under memory presure in a catatonic state.

Against 2.6.24-rc6-mm1

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


Changelog:
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

