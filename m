Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbXK0QaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbXK0QaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 11:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758998AbXK0Q30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 11:29:26 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:17988 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758420AbXK0Q3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:29:22 -0500
Message-Id: <20071127162920.101880329@de.ibm.com>
References: <20071127162210.262064983@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 27 Nov 2007 17:22:13 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 3/4] dcssblk: prevent early access without own make_request function
Content-Disposition: inline; filename=003-dcss-ioerror.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

When loading a dcss segment with the dcssblk driver, sometimes the
following kind of message appears:

bio too big device dcssblk0 (8 > 0)
Buffer I/O error on device dcssblk0, logical block 172016
..

The fix is to move the disk registration after setting the
make_request function, to avoid calls into generic_make_request
for dcssblock without having the make_request function set up
properly.

Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dcssblk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: quilt-2.6/drivers/s390/block/dcssblk.c
===================================================================
--- quilt-2.6.orig/drivers/s390/block/dcssblk.c
+++ quilt-2.6/drivers/s390/block/dcssblk.c
@@ -472,11 +472,11 @@ dcssblk_add_store(struct device *dev, st
 	if (rc)
 		goto unregister_dev;
 
-	add_disk(dev_info->gd);
-
 	blk_queue_make_request(dev_info->dcssblk_queue, dcssblk_make_request);
 	blk_queue_hardsect_size(dev_info->dcssblk_queue, 4096);
 
+	add_disk(dev_info->gd);
+
 	switch (dev_info->segment_type) {
 		case SEG_TYPE_SR:
 		case SEG_TYPE_ER:

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

