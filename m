Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbYG3IKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbYG3IKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYG3IKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:10:10 -0400
Received: from styx.suse.cz ([82.119.242.94]:59844 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751502AbYG3IKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:10:07 -0400
Subject: [PATCH] ide-cd: fix endianity for the error message in
	cdrom_read_capacity
From: Petr Tesarik <ptesarik@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jan Kara <jack@suse.cz>
Content-Type: text/plain
Organization: SUSE LINUX
Date: Wed, 30 Jul 2008 10:10:06 +0200
Message-Id: <1217405406.11834.11.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resent because of a typo in the LKML address. :(


Aesthetic regards aside, commit e8e7b9eb11c34ee18bde8b7011af41938d1ad667
still leaves a bug in the error message, because it uses the unconverted
big-endian value for printk.

Fix this by using a local variable in machine byte order. The result is
correct, more readable, and also produces slightly shorter code on i386.

Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---

 ide-cd.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1305,6 +1305,7 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 	int stat;
 	unsigned char cmd[BLK_MAX_CDB];
 	unsigned len = sizeof(capbuf);
+	__u32 blocklen;
 
 	memset(cmd, 0, BLK_MAX_CDB);
 	cmd[0] = GPCMD_READ_CDVD_CAPACITY;
@@ -1317,23 +1318,24 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 	/*
 	 * Sanity check the given block size
 	 */
-	switch (capbuf.blocklen) {
-	case __constant_cpu_to_be32(512):
-	case __constant_cpu_to_be32(1024):
-	case __constant_cpu_to_be32(2048):
-	case __constant_cpu_to_be32(4096):
+	blocklen = be32_to_cpu(capbuf.blocklen);
+	switch (blocklen) {
+	case 512:
+	case 1024:
+	case 2048:
+	case 4096:
 		break;
 	default:
 		printk(KERN_ERR "%s: weird block size %u\n",
-			drive->name, capbuf.blocklen);
+			drive->name, blocklen);
 		printk(KERN_ERR "%s: default to 2kb block size\n",
 			drive->name);
-		capbuf.blocklen = __constant_cpu_to_be32(2048);
+		blocklen = 2048;
 		break;
 	}
 
 	*capacity = 1 + be32_to_cpu(capbuf.lba);
-	*sectors_per_frame = be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
+	*sectors_per_frame = blocklen >> SECTOR_BITS;
 	return 0;
 }
 


