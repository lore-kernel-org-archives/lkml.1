Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbYCLNLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbYCLNLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbYCLNLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:11:40 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:21561 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751729AbYCLNLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:11:39 -0400
Message-ID: <47D7D670.40306@panasas.com>
Date: Wed, 12 Mar 2008 15:11:12 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       Sven Schnelle <svens@stackframe.org>, linux-kernel@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] isd200: Allocate sense_buffer for hacked up scsi_cmnd
References: <Pine.LNX.4.44L0.0803111456590.26916-100000@iolanthe.rowland.org> <47D7D580.5060406@panasas.com>
In-Reply-To: <47D7D580.5060406@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2008 13:11:14.0978 (UTC) FILETIME=[8D15C020:01C88442]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since the separation of sense_buffer from scsi_cmnd, Drivers that hack their
own struct scsi_cmnd like here isd200, must also take care of their own
sense_buffer.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/isd200.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 2ae1e86..ac1764b 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -294,6 +294,7 @@ struct isd200_info {
 	unsigned char MaxLUNs;
 	struct scsi_cmnd srb;
 	struct scatterlist sg;
+	u8* sense_buffer;
 };
 
 
@@ -1469,6 +1470,7 @@ static void isd200_free_info_ptrs(void *info_)
 	if (info) {
 		kfree(info->id);
 		kfree(info->RegsBuf);
+		kfree(info->sense_buffer);
 	}
 }
 
@@ -1494,11 +1496,13 @@ static int isd200_init_info(struct us_data *us)
 				kzalloc(sizeof(struct hd_driveid), GFP_KERNEL);
 		info->RegsBuf = (unsigned char *)
 				kmalloc(sizeof(info->ATARegs), GFP_KERNEL);
-		if (!info->id || !info->RegsBuf) {
+		info->sense_buffer = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+		if (!info->id || !info->RegsBuf || !info->sense_buffer) {
 			isd200_free_info_ptrs(info);
 			kfree(info);
 			retStatus = ISD200_ERROR;
-		}
+		} else
+			info->srb.sense_buffer = info->sense_buffer;
 	}
 
 	if (retStatus == ISD200_GOOD) {
-- 
1.5.3.3


