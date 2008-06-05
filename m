Return-Path: <linux-kernel-owner+w=401wt.eu-S1763388AbYFEBWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763388AbYFEBWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 21:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762968AbYFEBV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 21:21:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54035 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762941AbYFEBV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 21:21:28 -0400
Message-Id: <20080605021211.871673550@jp.fujitsu.com>
User-Agent: quilt/0.46-1
Date: Thu, 05 Jun 2008 11:12:11 +0900
From: kosaki.motohiro@jp.fujitsu.com
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH 0/5] page reclaim throttle v7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I post latest version of page reclaim patch series.

This patch is holding up very well under usex stress test
over 24+ hours :)


Against: 2.6.26-rc2-mm1


changelog
========================================
  v6 -> v7
     o rebase to 2.6.26-rc2-mm1
     o get_vm_stat: make cpu-unplug safety.
     o mark vm_max_nr_task_per_zone __read_mostly.
     o add check __GFP_FS, __GFP_IO for avoid deadlock.
     o fixed compile error on x86_64.

  v5 -> v6
     o rebase to 2.6.25-mm1
     o use PGFREE statics instead wall time.
     o separate function type change patch and introduce throttle patch.

  v4 -> v5
     o rebase to 2.6.25-rc8-mm1

  v3 -> v4:
     o fixed recursive shrink_zone problem.
     o add last_checked variable in shrink_zone for 
       prevent corner case regression.

  v2 -> v3:
     o use wake_up() instead wake_up_all()
     o max reclaimers can be changed Kconfig option and sysctl.
     o some cleanups

  v1 -> v2:
     o make per zone throttle 



background
=====================================
current VM implementation doesn't has limit of # of parallel reclaim.
when heavy workload, it bring to 2 bad things
  - heavy lock contention
  - unnecessary swap out

at end of last year, KAMEZAWA Hiroyuki proposed the patch of page 
reclaim throttle and explain it improve reclaim time.
	http://marc.info/?l=linux-mm&m=119667465917215&w=2

but unfortunately it works only memcgroup reclaim.
since, I implement it again for support global reclaim and mesure it.


benefit
=====================================
<<1. fix the bug of incorrect OOM killer>>

if do following commanc, sometimes OOM killer happened.
(OOM happend about 10%)

 $ ./hackbench 125 process 1000

because following bad scenario is happend.

   1. memory shortage happend.
   2. many task call shrink_zone at the same time.
   3. thus, All page are isolated from LRU at the same time.
   4. the last task can't isolate any page from LRU.
   5. it cause reclaim failure.
   6. it cause OOM killer.

my patch is directly solution for that problem.


<<2. performance improvement>>
I mesure RvR Split LRU series + page reclaim throttle series performance by hackbench.

result number mean seconds (i.e. smaller is better)


                                + split_lru   improvement
   num_group   2.6.26-rc2-mm1   + throttle    ratio
   -----------------------------------------------------------------
   100         28.383           28.247
   110         31.237           30.83
   120         33.282           33.473
   130         36.530           37.356
   140        101.041           44.873         >200%  
   150        795.020           96.265         >800%


Why this patch imrove performance?

vanilla kernel get unstable performance at swap happend because
unnecessary swap out happend freqently.
this patch doesn't improvement best case, but be able to prevent worst case.
thus, The average performance of hackbench increase largely.

