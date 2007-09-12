Return-Path: <linux-kernel-owner+w=401wt.eu-S1764078AbXILBmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764078AbXILBmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 21:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760236AbXILBlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 21:41:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:27503 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760202AbXILBlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 21:41:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=aXt0RePIxN3TDFtadS7jd7HbTRHmP1FNxmfG2QJaSA7R034XKuN39B0p8tBDPpsWH
	pNBhesSjFnnQGI44bxLdA==
Message-ID: <46E743B0.6070308@google.com>
Date: Tue, 11 Sep 2007 18:41:04 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 5/6] cpuset write vm writeout
References: <469D3342.3080405@google.com> <46E741B1.4030100@google.com>
In-Reply-To: <46E741B1.4030100@google.com>
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

Patch against 2.6.23-rc4-mm1

diff -uprN -X 0/Documentation/dontdiff 4/include/linux/writeback.h 5/include/linux/writeback.h
--- 4/include/linux/writeback.h	2007-09-11 14:49:47.000000000 -0700
+++ 5/include/linux/writeback.h	2007-09-11 14:50:52.000000000 -0700
@@ -94,7 +94,7 @@ static inline void inode_sync_wait(struc
 int wakeup_pdflush(long nr_pages, nodemask_t *nodes);
 void laptop_io_completion(void);
 void laptop_sync_completion(void);
-void throttle_vm_writeout(gfp_t gfp_mask);
+void throttle_vm_writeout(nodemask_t *nodes,gfp_t gfp_mask);
 
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
diff -uprN -X 0/Documentation/dontdiff 4/mm/page-writeback.c 5/mm/page-writeback.c
--- 4/mm/page-writeback.c	2007-09-11 14:49:47.000000000 -0700
+++ 5/mm/page-writeback.c	2007-09-11 14:50:52.000000000 -0700
@@ -386,7 +386,7 @@ void balance_dirty_pages_ratelimited_nr(
 }
 EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
 
-void throttle_vm_writeout(gfp_t gfp_mask)
+void throttle_vm_writeout(nodemask_t *nodes, gfp_t gfp_mask)
 {
 	struct dirty_limits dl;
 
@@ -401,7 +401,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 	}
 
 	for ( ; ; ) {
-		get_dirty_limits(&dl, NULL, &node_online_map);
+		get_dirty_limits(&dl, NULL, nodes);
 
 		/*
 		 * Boost the allowable dirty threshold a bit for page
diff -uprN -X 0/Documentation/dontdiff 4/mm/vmscan.c 5/mm/vmscan.c
--- 4/mm/vmscan.c	2007-09-11 14:50:41.000000000 -0700
+++ 5/mm/vmscan.c	2007-09-11 14:50:52.000000000 -0700
@@ -1185,7 +1185,7 @@ static unsigned long shrink_zone(int pri
 		}
 	}
 
-	throttle_vm_writeout(sc->gfp_mask);
+	throttle_vm_writeout(&cpuset_current_mems_allowed, sc->gfp_mask);
 
 	atomic_dec(&zone->reclaim_in_progress);
 	return nr_reclaimed;

