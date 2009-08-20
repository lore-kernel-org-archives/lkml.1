Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbZHTCwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbZHTCwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZHTCwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:52:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:50097 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbZHTCwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:52:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,412,1246863600"; 
   d="scan'208";a="177989937"
Date: Thu, 20 Aug 2009 10:52:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>
Subject: [PATCH] mm: make nr_scan_try_batch() more safe on races
Message-ID: <20090820025209.GA24387@localhost>
References: <20090820024929.GA19793@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820024929.GA19793@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_scan_try_batch() can be called concurrently on the same zone
and the non-atomic calculations can go wrong. This is not a big
problem as long as the errors are small and won't impact the
balanced zone aging noticeably.

@nr_to_scan could be much larger values than @swap_cluster_max.
So don't store such large values to *nr_saved_scan directly,
which helps reducing possible errors on races.

CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/vmscan.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- linux.orig/mm/vmscan.c	2009-08-20 10:46:30.000000000 +0800
+++ linux/mm/vmscan.c	2009-08-20 10:49:36.000000000 +0800
@@ -1496,15 +1496,14 @@ static unsigned long nr_scan_try_batch(u
 				       unsigned long *nr_saved_scan,
 				       unsigned long swap_cluster_max)
 {
-	unsigned long nr;
-
-	*nr_saved_scan += nr_to_scan;
-	nr = *nr_saved_scan;
+	unsigned long nr = *nr_saved_scan + nr_to_scan;
 
 	if (nr >= swap_cluster_max)
 		*nr_saved_scan = 0;
-	else
+	else {
+		*nr_saved_scan = nr;
 		nr = 0;
+	}
 
 	return nr;
 }
