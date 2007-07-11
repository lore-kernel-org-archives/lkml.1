Return-Path: <linux-kernel-owner+w=401wt.eu-S933767AbXGKVCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767AbXGKVCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933710AbXGKVAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:00:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933654AbXGKVAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:00:39 -0400
Date: Wed, 11 Jul 2007 21:59:56 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.23 PATCH 10/18] dm raid1: clear region outside spinlock
Message-ID: <20070711205956.GB24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Jonathan Brassow <jbrassow@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Brassow <jbrassow@redhat.com>

A clear_region function is permitted to block (in practice, rare) but gets
called in rh_update_states() with a spinlock held.

The bits being marked and cleared by the above functions are used
to update the on-disk log, but are never read directly.  We can
perform these operations outside the spinlock since the
bits are only changed within one thread viz.
   - mark_region in rh_inc()
   - clear_region in rh_update_states().

So, we grab the clean_regions list items via list_splice() within the
spinlock and defer clear_region() until we iterate over the list for
deletion - similar to how the recovered_regions list is already handled.
We then move the flush() call down to ensure it encapsulates the changes
which are done by the later calls to clear_region().

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-raid1.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

Index: linux/drivers/md/dm-raid1.c
===================================================================
--- linux.orig/drivers/md/dm-raid1.c	2007-07-11 21:37:42.000000000 +0100
+++ linux/drivers/md/dm-raid1.c	2007-07-11 21:37:46.000000000 +0100
@@ -378,10 +378,8 @@ static void rh_update_states(struct regi
 		list_splice(&rh->clean_regions, &clean);
 		INIT_LIST_HEAD(&rh->clean_regions);
 
-		list_for_each_entry (reg, &clean, list) {
-			rh->log->type->clear_region(rh->log, reg->key);
+		list_for_each_entry(reg, &clean, list)
 			list_del(&reg->hash_list);
-		}
 	}
 
 	if (!list_empty(&rh->recovered_regions)) {
@@ -405,10 +403,12 @@ static void rh_update_states(struct regi
 		mempool_free(reg, rh->region_pool);
 	}
 
-	rh->log->type->flush(rh->log);
-
-	list_for_each_entry_safe (reg, next, &clean, list)
+	list_for_each_entry_safe(reg, next, &clean, list) {
+		rh->log->type->clear_region(rh->log, reg->key);
 		mempool_free(reg, rh->region_pool);
+	}
+
+	rh->log->type->flush(rh->log);
 }
 
 static void rh_inc(struct region_hash *rh, region_t region)
