Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793Ab0AEAmC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0AEAmC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:42:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634Ab0AEAlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:41:51 -0500
Received: from kroah.org ([198.145.64.141]:42390 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474Ab0AEAf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Stefan Weinhuber <wein@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Stephen Powell <zlinuxman@wowway.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 74/97] S390: dasd: support DIAG access for read-only devices
Date: Mon,  4 Jan 2010 16:33:27 -0800
Message-Id: <1262651630-7354-74-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Weinhuber <wein@de.ibm.com>

commit 22825ab7693fd29769518a0d25ba43c01a50092a upstream.

When a DASD device is used with the DIAG discipline, the DIAG
initialization will indicate success or error with a respective
return code. So far we have interpreted a return code of 4 as error,
but it actually means that the initialization was successful, but
the device is read-only. To allow read-only devices to be used with
DIAG we need to accept a return code of 4 as success.

Re-initialization of the DIAG access is also part of the DIAG error
recovery. If we find that the access mode of a device has been
changed from writable to read-only while the device was in use,
we print an error message.

Signed-off-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Stephen Powell <zlinuxman@wowway.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/s390/block/dasd_diag.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 4e49b4a..8174ec9 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -145,6 +145,15 @@ dasd_diag_erp(struct dasd_device *device)
 
 	mdsk_term_io(device);
 	rc = mdsk_init_io(device, device->block->bp_block, 0, NULL);
+	if (rc == 4) {
+		if (!(device->features & DASD_FEATURE_READONLY)) {
+			dev_warn(&device->cdev->dev,
+				 "The access mode of a DIAG device changed"
+				 " to read-only");
+			device->features |= DASD_FEATURE_READONLY;
+		}
+		rc = 0;
+	}
 	if (rc)
 		dev_warn(&device->cdev->dev, "DIAG ERP failed with "
 			    "rc=%d\n", rc);
@@ -433,16 +442,20 @@ dasd_diag_check_device(struct dasd_device *device)
 	for (sb = 512; sb < bsize; sb = sb << 1)
 		block->s2b_shift++;
 	rc = mdsk_init_io(device, block->bp_block, 0, NULL);
-	if (rc) {
+	if (rc && (rc != 4)) {
 		dev_warn(&device->cdev->dev, "DIAG initialization "
 			"failed with rc=%d\n", rc);
 		rc = -EIO;
 	} else {
+		if (rc == 4)
+			device->features |= DASD_FEATURE_READONLY;
 		dev_info(&device->cdev->dev,
-			 "New DASD with %ld byte/block, total size %ld KB\n",
+			 "New DASD with %ld byte/block, total size %ld KB%s\n",
 			 (unsigned long) block->bp_block,
 			 (unsigned long) (block->blocks <<
-					  block->s2b_shift) >> 1);
+					  block->s2b_shift) >> 1,
+			 (rc == 4) ? ", read-only device" : "");
+		rc = 0;
 	}
 out_label:
 	free_page((long) label);
-- 
1.6.6

