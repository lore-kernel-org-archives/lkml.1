Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab0CCABA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:01:00 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45210 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab0CCAA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:00:57 -0500
From: imunsie@au1.ibm.com
To: linux-kernel@vger.kernel.org
Cc: Ian Munsie <imunsie@au1.ibm.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net
Subject: [PATCH] Remove large struct from the stack in USB storage isd200 driver
Date: Wed,  3 Mar 2010 11:00:37 +1100
Message-Id: <1267574438-6784-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au.ibm.com>

The compiler throws the following warning when compiling for a PowerPC 64
bit machine:

drivers/usb/storage/isd200.c:580: warning: the frame size of 2208 bytes is larger than 2048 bytes

There is a struct scsi_device which is placed on the stack and is
largely responsible for such wastage. The struct is just a dummy struct
filled with NULLs and set as the scsi_cmnd->device to make the
usb_stor_Bulk_transport function happy.

This patch makes the struct static, so that it is never placed onto the
stack and silences the compiler warning.

Signed-off-by: Ian Munsie <imunsie@au.ibm.com>
---
 drivers/usb/storage/isd200.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index fdba2f6..e9cbc14 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -490,13 +490,13 @@ static int isd200_action( struct us_data *us, int action,
 			  void* pointer, int value )
 {
 	union ata_cdb ata;
-	struct scsi_device srb_dev;
+	/* static to prevent this large struct being placed on the valuable stack */
+	static struct scsi_device srb_dev;
 	struct isd200_info *info = (struct isd200_info *)us->extra;
 	struct scsi_cmnd *srb = &info->srb;
 	int status;
 
 	memset(&ata, 0, sizeof(ata));
-	memset(&srb_dev, 0, sizeof(srb_dev));
 	srb->cmnd = info->cmnd;
 	srb->device = &srb_dev;
 	++srb->serial_number;
-- 
1.6.6.1

