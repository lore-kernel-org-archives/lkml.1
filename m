Return-Path: <linux-kernel-owner+w=401wt.eu-S1751763AbZHSLZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbZHSLZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 07:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZHSLZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 07:25:54 -0400
Received: from brick.kernel.dk ([93.163.65.50]:32860 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbZHSLZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 07:25:53 -0400
Date: Wed, 19 Aug 2009 13:25:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, htejun@gmail.com
Subject: [PATCH] libata: use single threaded work queue
Message-ID: <20090819112554.GY12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On boxes with lots of CPUs, we have so many kernel threads it's not
funny. The basic problem is that create_workqueue() creates a per-cpu
thread, where we could easily get by with a single thread for a lot of
cases.

One such case appears to be ata_wq. You want at most one per pio drive,
not one per CPU. I'd suggest just dropping it to a single threaded wq.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 072ba5e..0d78628 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6580,7 +6580,7 @@ static int __init ata_init(void)
 {
 	ata_parse_force_param();
 
-	ata_wq = create_workqueue("ata");
+	ata_wq = create_singlethread_workqueue("ata");
 	if (!ata_wq)
 		goto free_force_tbl;
 

-- 
Jens Axboe

