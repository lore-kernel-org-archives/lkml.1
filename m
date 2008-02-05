Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbYBEPmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbYBEPmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754913AbYBEPjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:39:32 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:25399 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbYBEPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:39:17 -0500
Message-Id: <20080205153915.270174246@de.ibm.com>
References: <20080205153835.337897404@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 05 Feb 2008 16:38:50 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Stefan Weinhuber <wein@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 15/18] dasd: fix panic caused by alias device offline
Content-Disposition: inline; filename=015-dasd-panic.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Weinhuber <wein@de.ibm.com>

When an alias device is set offline while it is in use this may
result in a panic in the cleanup part of the dasd_block_tasklet.
The problem here is that there may exist some ccw requests that were
originally created for the alias device and transferred to the base
device when the alias was set offline. When these request are
cleaned up later, the discipline pointer in the alias device may not
be valid anymore. To fix this use the base device discipline to find
the cleanup function.

Signed-off-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dasd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/block/dasd.c
===================================================================
--- quilt-2.6.orig/drivers/s390/block/dasd.c
+++ quilt-2.6/drivers/s390/block/dasd.c
@@ -1706,7 +1706,7 @@ static void __dasd_cleanup_cqr(struct da
 
 	req = (struct request *) cqr->callback_data;
 	dasd_profile_end(cqr->block, cqr, req);
-	status = cqr->memdev->discipline->free_cp(cqr, req);
+	status = cqr->block->base->discipline->free_cp(cqr, req);
 	if (status <= 0)
 		error = status ? status : -EIO;
 	dasd_end_request(req, error);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

