Return-Path: <linux-kernel-owner+w=401wt.eu-S968165AbXEHTvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968165AbXEHTvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967333AbXEHTud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:50:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967093AbXEHTu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:50:29 -0400
Date: Tue, 8 May 2007 20:49:27 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22 PATCH 26/26] dm log: fix resume failed log device
Message-ID: <20070508194927.GG24114@agk.fab.redhat.com>
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

This patch removes the possibility of having uninitialized
log state if the log device has failed.

When a mirror resumes operation, it calls 'resume' on the
logging module.  If disk based logging is being used, the
log device is read to fill in the log state.  If the log
device has failed, we cannot simply return, because this
would leave the in-memory log state uninitialized.  Instead,
we assume all regions are out-of-sync and reset the log
state.  Failure to do this could result in the logging code
reporting a region as in-sync, even though it isn't; which
could result in a corrupted mirror.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-log.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.21/drivers/md/dm-log.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-log.c	2007-05-01 19:20:13.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-log.c	2007-05-01 19:20:21.000000000 +0100
@@ -478,7 +478,14 @@ static int disk_resume(struct dirty_log 
 		DMWARN("%s: Failed to read header on mirror log device",
 		       lc->log_dev->name);
 		fail_log_device(lc);
-		return r;
+		/*
+		 * If the log device cannot be read, we must assume
+		 * all regions are out-of-sync.  If we simply return
+		 * here, the state will be uninitialized and could
+		 * lead us to return 'in-sync' status for regions
+		 * that are actually 'out-of-sync'.
+		 */
+		lc->header.nr_regions = 0;
 	}
 
 	/* set or clear any new bits -- device has grown */
