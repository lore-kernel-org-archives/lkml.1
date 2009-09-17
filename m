Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbZIQSrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbZIQSrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760160AbZIQSro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:47:44 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:33346 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759215AbZIQSrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:47:39 -0400
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 12/20] cciss: Fix excessive gendisk freeing bug on driver
	unload.
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       andrew.patterson@hp.com, mikem@beardog.cce.hp.com,
       scameron@beardog.cce.hp.com
Date: Thu, 17 Sep 2009 13:47:50 -0500
Message-ID: <20090917184750.15105.13447.stgit@beardog.cce.hp.com>
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bug that free_hba was calling put_disk for all gendisk[]
pointers -- all 1024 of them -- regardless of whether the were
used or not (NULL).  This bug could cause rmmod to oops if logical
drives had been deleted during the driver's lifetime.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 14d4cd6..a4cb041 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3892,15 +3892,16 @@ Enomem:
 	return -1;
 }
 
-static void free_hba(int i)
+static void free_hba(int n)
 {
-	ctlr_info_t *p = hba[i];
-	int n;
+	ctlr_info_t *h = hba[n];
+	int i;
 
-	hba[i] = NULL;
-	for (n = 0; n < CISS_MAX_LUN; n++)
-		put_disk(p->gendisk[n]);
-	kfree(p);
+	hba[n] = NULL;
+	for (i = 0; i < h->highest_lun + 1; i++)
+		if (h->gendisk[i] != NULL)
+			put_disk(h->gendisk[i]);
+	kfree(h);
 }
 
 /* Send a message CDB to the firmware. */

