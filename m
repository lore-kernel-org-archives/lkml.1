Return-Path: <linux-kernel-owner+w=401wt.eu-S936205AbXGQVh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936205AbXGQVh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759114AbXGQVhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:37:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:58770 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919AbXGQVhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:37:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=WmN5Ona9UNDRELUn9gWJP4qQPdfTC7gttCA8WnubmEKSaxNsgPsMZc6aw7/1xTYDw
	MO/GBvH+s1HkXs5M2zgdQ==
Message-ID: <469D3670.9020609@google.com>
Date: Tue, 17 Jul 2007 14:36:48 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Ethan Solomita <solo@google.com>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@google.com>, Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 5/6] cpuset write vm writeout
References: <469D3342.3080405@google.com>
In-Reply-To: <469D3342.3080405@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Throttle VM writeout in a cpuset aware way

This bases the vm throttling from the reclaim path on the dirty ratio
of the cpuset. Note that a cpuset is only effective if shrink_zone is called
from direct reclaim.

kswapd has a cpuset context that includes the whole machine. VM throttling
will only work during synchrononous reclaim and not  from kswapd.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Ethan Solomita <solo@google.com>

---

Patch against 2.6.22-rc6-mm1

diff -uprN -X 0/Documentation/dontdiff 4/include/linux/writeback.h 5/include/linux/writeback.h
--- 4/include/linux/writeback.h	2007-07-11 21:16:25.000000000 -0700
+++ 5/include/linux/writeback.h	2007-07-11 21:16:50.000000000 -0700
@@ -95,7 +95,7 @@ static inline void inode_sync_wait(struc
 int wakeup_pdflush(long nr_pages, nodemask_t *nodes);
 void laptop_io_completion(void);
 void laptop_sync_completion(void);
-void throttle_vm_writeout(gfp_t gfp_mask);
+void throttle_vm_writeout(nodemask_t *nodes,gfp_t gfp_mask);
 
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
diff -uprN -X 0/Documentation/dontdiff 4/mm/page-writeback.c 5/mm/page-writeback.c
--- 4/mm/page-writeback.c	2007-07-16 18:31:13.000000000 -0700
+++ 5/mm/page-writeback.c	2007-07-16 18:32:08.000000000 -0700
@@ -384,7 +384,7 @@ void balance_dirty_pages_ratelimited_nr(
 }
 EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
 
-void throttle_vm_writeout(gfp_t gfp_mask)
+void throttle_vm_writeout(nodemask_t *nodes, gfp_t gfp_mask)
 {
 	struct dirty_limits dl;
 
@@ -399,7 +399,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 	}
 
 	for ( ; ; ) {
-		get_dirty_limits(&dl, NULL, &node_online_map);
+		get_dirty_limits(&dl, NULL, nodes);
 
 		/*
 		 * Boost the allowable dirty threshold a bit for page
diff -uprN -X 0/Documentation/dontdiff 4/mm/vmscan.c 5/mm/vmscan.c
--- 4/mm/vmscan.c	2007-07-11 21:16:26.000000000 -0700
+++ 5/mm/vmscan.c	2007-07-11 21:16:50.000000000 -0700
@@ -1064,7 +1064,7 @@ static unsigned long shrink_zone(int pri
 		}
 	}
 
-	throttle_vm_writeout(sc->gfp_mask);
+	throttle_vm_writeout(&cpuset_current_mems_allowed, sc->gfp_mask);
 
 	atomic_dec(&zone->reclaim_in_progress);
 	return nr_reclaimed;

