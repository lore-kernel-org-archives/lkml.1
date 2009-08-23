Return-Path: <linux-kernel-owner+w=401wt.eu-S933672AbZHWSYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672AbZHWSYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 14:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933514AbZHWSYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 14:24:23 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43354 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933441AbZHWSYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 14:24:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=n5R9x7cj6br5QoVLE5Cc8uwbHMZLOAb3kbt0gJMmtEkSyvrGY4VJNOrNG82DkZS8jI
         WvqJlpuemIn0+jbPMhMTjGZNyBh74DEthegjYMP366cPsCnP/iMLk5nyJl9MViio2kvO
         xIuoNeX/81Xh+UO6hMN2ZFcMZ2MrPfD9/FUh8=
Message-ID: <4A918955.5070205@gmail.com>
Date: Sun, 23 Aug 2009 20:24:21 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <axboe@kernel.dk>, Tim Waugh <tim@cyberelk.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH resend] block: use printk_once
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tim Waugh <tim@cyberelk.net>
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 911dfd9..9f3518c 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -219,8 +219,6 @@ static int pcd_sector;		/* address of next requested sector */
 static int pcd_count;		/* number of blocks still to do */
 static char *pcd_buf;		/* buffer for request in progress */
 
-static int pcd_warned;		/* Have we logged a phase warning ? */
-
 /* kernel glue structures */
 
 static int pcd_block_open(struct block_device *bdev, fmode_t mode)
@@ -417,12 +415,10 @@ static int pcd_completion(struct pcd_unit *cd, char *buf, char *fun)
 					printk
 					    ("%s: %s: Unexpected phase %d, d=%d, k=%d\n",
 					     cd->name, fun, p, d, k);
-				if ((verbose < 2) && !pcd_warned) {
-					pcd_warned = 1;
-					printk
-					    ("%s: WARNING: ATAPI phase errors\n",
-					     cd->name);
-				}
+				if (verbose < 2)
+					printk_once(
+					    "%s: WARNING: ATAPI phase errors\n",
+					    cd->name);
 				mdelay(1);
 			}
 			if (k++ > PCD_TMO) {
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index da403b6..f5cd2e8 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -1564,15 +1564,13 @@ static int carm_init_shm(struct carm_host *host)
 
 static int carm_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static unsigned int printed_version;
 	struct carm_host *host;
 	unsigned int pci_dac;
 	int rc;
 	struct request_queue *q;
 	unsigned int i;
 
-	if (!printed_version++)
-		printk(KERN_DEBUG DRV_NAME " version " DRV_VERSION "\n");
+	printk_once(KERN_DEBUG DRV_NAME " version " DRV_VERSION "\n");
 
 	rc = pci_enable_device(pdev);
 	if (rc)
diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
index 390d69b..b441ce3 100644
--- a/drivers/block/viodasd.c
+++ b/drivers/block/viodasd.c
@@ -416,15 +416,9 @@ retry:
 		goto retry;
 	}
 	if (we.max_disk > (MAX_DISKNO - 1)) {
-		static int warned;
-
-		if (warned == 0) {
-			warned++;
-			printk(VIOD_KERN_INFO
-				"Only examining the first %d "
-				"of %d disks connected\n",
-				MAX_DISKNO, we.max_disk + 1);
-		}
+		printk_once(VIOD_KERN_INFO
+			"Only examining the first %d of %d disks connected\n",
+			MAX_DISKNO, we.max_disk + 1);
 	}
 
 	/* Send the close event to OS/400.  We DON'T expect a response */
