Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbYGWSiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbYGWSiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbYGWSgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:36:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:28905 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbYGWSgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=DuRq2AU0mb6NeOZfVYZ8xmhHQb35BT0LDF+2Bx/PVeQEJdqS8WPfA48Ji/q+NDFN5Q
         5/b2ZHTChGiGhJWVf13S5kIXsz9a2nE/S0f0It34Ip+i8KSyTbPLCyaVXFUTIoxSty/j
         ShkjPnqUtL0/groum1UUMXmruQvfxTiDez8Jg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ubd_kern: make it 'struct hd_driveid'-free
Date: Wed, 23 Jul 2008 20:32:31 +0200
User-Agent: KMail/1.9.9
Cc: Jeff Dike <jdike@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807232032.31212.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Change ubd_id in ubd_ioctl() from 'struct hd_driveid *id'
  to 'u16 *id' and update driver accordingly.

* Include <linux/ata.h> directly instead of through <linux/hdreg.h>.

There should be no functional changes caused by this patch.

Cc: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
depends on 'ata: add missing ATA_ID_* defines (take 2)' patch
posted earlier (http://lkml.org/lkml/2008/7/22/469)

 arch/um/drivers/ubd_kern.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: b/arch/um/drivers/ubd_kern.c
===================================================================
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -23,6 +23,7 @@
 #include "linux/kernel.h"
 #include "linux/module.h"
 #include "linux/blkdev.h"
+#include "linux/ata.h"
 #include "linux/hdreg.h"
 #include "linux/init.h"
 #include "linux/cdrom.h"
@@ -1310,16 +1311,15 @@ static int ubd_ioctl(struct inode * inod
 		     unsigned int cmd, unsigned long arg)
 {
 	struct ubd *ubd_dev = inode->i_bdev->bd_disk->private_data;
-	struct hd_driveid ubd_id = {
-		.cyls		= 0,
-		.heads		= 128,
-		.sectors	= 32,
-	};
+	u16 ubd_id[ATA_ID_WORDS];
 
 	switch (cmd) {
 		struct cdrom_volctrl volume;
 	case HDIO_GET_IDENTITY:
-		ubd_id.cyls = ubd_dev->size / (128 * 32 * 512);
+		memset(&ubd_id, 0, ATA_ID_WORDS * 2);
+		ubd_id[ATA_ID_CYLS]	= ubd_dev->size / (128 * 32 * 512);
+		ubd_id[ATA_ID_HEADS]	= 128;
+		ubd_id[ATA_ID_SECTORS]	= 32;
 		if(copy_to_user((char __user *) arg, (char *) &ubd_id,
 				 sizeof(ubd_id)))
 			return -EFAULT;
