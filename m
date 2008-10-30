Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYJ3TYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYJ3TYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYJ3TX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:23:56 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38413 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYJ3TXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:23:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=lsT/H4BozpEYwgkpwlk1qyRJu2YnKhTNbyLCZ0PhvcrusdHiSXPwUQ2mDmXntvlbL
	SwrExHNMAhgBBD/NxREow==
Date: Thu, 30 Oct 2008 12:23:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch 5/7] mm: throttle writeout with cpuset awareness
In-Reply-To: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0810300311270.18283@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux-foundation.org>

This bases the VM throttling from the reclaim path on the dirty ratio of
the cpuset.  Note that a cpuset is only effective if shrink_zone is called
from direct reclaim.

kswapd has a cpuset context that includes the whole machine.  VM
throttling will only work during synchrononous reclaim and not from
kswapd.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Menage <menage@google.com>
Cc: Derek Fults <dfults@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/writeback.h |    2 +-
 mm/page-writeback.c       |    4 ++--
 mm/vmscan.c               |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -114,7 +114,7 @@ static inline void inode_sync_wait(struct inode *inode)
 int wakeup_pdflush(long nr_pages, nodemask_t *nodes);
 void laptop_io_completion(void);
 void laptop_sync_completion(void);
-void throttle_vm_writeout(gfp_t gfp_mask);
+void throttle_vm_writeout(nodemask_t *nodes, gfp_t gfp_mask);
 
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -638,12 +638,12 @@ void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 }
 EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
 
-void throttle_vm_writeout(gfp_t gfp_mask)
+void throttle_vm_writeout(nodemask_t *nodes, gfp_t gfp_mask)
 {
 	struct dirty_limits dl;
 
         for ( ; ; ) {
-		get_dirty_limits(&dl, NULL, &node_states[N_HIGH_MEMORY]);
+		get_dirty_limits(&dl, NULL, nodes);
 
 		/*
 		 * Boost the allowable dirty threshold a bit for page
diff --git a/mm/vmscan.c b/mm/vmscan.c
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1466,7 +1466,7 @@ static unsigned long shrink_zone(int priority, struct zone *zone,
 	else if (!scan_global_lru(sc))
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
 
-	throttle_vm_writeout(sc->gfp_mask);
+	throttle_vm_writeout(&cpuset_current_mems_allowed, sc->gfp_mask);
 	return nr_reclaimed;
 }
 
