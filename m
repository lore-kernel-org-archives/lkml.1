Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbYEDMyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbYEDMyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 08:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbYEDMyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 08:54:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37601 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbYEDMx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 08:53:59 -0400
Date: Sun, 04 May 2008 21:53:16 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [-mm][PATCH 0/5] mm: page reclaim throttle v6
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Against: 2.6.25-mm1

changelog
========================================
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

The end of last year, KAMEZAWA Hiroyuki proposed the patch of page 
reclaim throttle and explain it improve reclaim time.
	http://marc.info/?l=linux-mm&m=119667465917215&w=2

but unfortunately it works only memcgroup reclaim.
Today, I implement it again for support global reclaim and mesure it.


benefit
=====================================
<<1. fix the bug of incorrect OOM killer>>

if do following commanc, sometimes OOM killer happened.
(OOM happend about 10%)

 $ ./hackbench 125 process 1000

because following bad scenario happend.

   1. memory shortage happend.
   2. many task call shrink_zone at the same time.
   3. all page are isolated from LRU at the same time.
   4. the last task can't isolate any page from LRU.
   5. it cause reclaim failure.
   6. it cause OOM killer.

my patch is directly solution for that problem.


<<2. performance improvement>>
I mesure various parameter of hackbench.

result number mean seconds (i.e. smaller is better)

    num_group       vanilla      with throttle   
   --------------------------------------------
      80              26.22           24.97    
      85              27.31           25.94    
      90              29.23           26.77
      95              30.73           28.40
     100              32.02           30.62
     105              33.97           31.93
     110              35.37           33.19
     115              36.96           33.68
     120              74.05           36.25
     125              41.07           39.30
     130              86.92           45.74
     135             234.62           45.99
     140             291.95           57.82
     145             425.35           70.31
     150             766.92          113.28


Why this patch imrove performance?

vanilla kernel get unstable performance at swap happend.
this patch doesn't improvement best case, but be able to prevent worst case.
thus, The average performance of hackbench increase largely.





