Return-Path: <linux-kernel-owner+w=401wt.eu-S932242Ab0AETyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab0AETyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932158Ab0AETxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:53:55 -0500
Received: from kroah.org ([198.145.64.141]:46031 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159Ab0AETw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:52:57 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 11:49:15 2010
Message-Id: <20100105194914.976056797@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 11:47:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Stefan Weinhuber <wein@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Stephen Powell <zlinuxman@wowway.com>
Subject: [06/10] S390: dasd: support DIAG access for read-only devices
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
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
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -143,6 +143,15 @@ dasd_diag_erp(struct dasd_device *device
 
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
 		DEV_MESSAGE(KERN_WARNING, device, "DIAG ERP unsuccessful, "
 			    "rc=%d", rc);
@@ -432,16 +441,20 @@ dasd_diag_check_device(struct dasd_devic
 	for (sb = 512; sb < bsize; sb = sb << 1)
 		block->s2b_shift++;
 	rc = mdsk_init_io(device, block->bp_block, 0, NULL);
-	if (rc) {
+	if (rc && (rc != 4)) {
 		DEV_MESSAGE(KERN_WARNING, device, "DIAG initialization "
 			"failed (rc=%d)", rc);
 		rc = -EIO;
 	} else {
+		if (rc == 4)
+			device->features |= DASD_FEATURE_READONLY;
 		DEV_MESSAGE(KERN_INFO, device,
-			    "(%ld B/blk): %ldkB",
+			    "(%ld B/blk): %ldkB%s",
 			    (unsigned long) block->bp_block,
 			    (unsigned long) (block->blocks <<
-				block->s2b_shift) >> 1);
+				block->s2b_shift) >> 1,
+				(rc == 4) ? ", read-only device" : "");
+		rc = 0;
 	}
 out_label:
 	free_page((long) label);


