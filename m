Return-Path: <linux-kernel-owner+w=401wt.eu-S967386AbXEHTuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967386AbXEHTuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968049AbXEHTuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:50:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968024AbXEHTuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:50:14 -0400
Date: Tue, 8 May 2007 20:49:09 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22 PATCH 24/26] dm raid1: fix to commit pending clear region requests
Message-ID: <20070508194909.GE24114@agk.fab.redhat.com>
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

With the code as it is, it is possible for oustanding clear region
requests never to get flushed when a mirror is deactivated or suspended.
This means there will always be some resync work required when a mirror
is activated, even though it may very well be in-sync.

Always requesting the flush doesn't hurt us.  This is because the log
tracks whether any changes occurred and, if not, no flush is performed.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-raid1.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.21/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-raid1.c	2007-05-01 19:20:13.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-raid1.c	2007-05-01 19:20:17.000000000 +0100
@@ -405,8 +405,7 @@ static void rh_update_states(struct regi
 		mempool_free(reg, rh->region_pool);
 	}
 
-	if (!list_empty(&recovered))
-		rh->log->type->flush(rh->log);
+	rh->log->type->flush(rh->log);
 
 	list_for_each_entry_safe (reg, next, &clean, list)
 		mempool_free(reg, rh->region_pool);
