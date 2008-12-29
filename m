Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbYL2SPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbYL2SPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 13:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYL2SPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 13:15:21 -0500
Received: from smtp7-g19.free.fr ([212.27.42.64]:52005 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbYL2SPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 13:15:19 -0500
Message-ID: <495913A6.9070007@free.fr>
Date: Mon, 29 Dec 2008 19:15:02 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081204 Iceape/1.1.14 (Debian-1.1.14-1)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
       linux-usb@vger.kernel.org
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH -stable] fix USB_STORAGE_CYPRESS_ATACB
Content-Type: multipart/mixed;
 boundary="------------020205060409000804060008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020205060409000804060008
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

64a87b244b9297667ca80264aab849a36f494884 broke USB_STORAGE_CYPRESS_ATACB 
translation.

Could it be applied to kernel-stable ?

Matthieu

--------------020205060409000804060008
Content-Type: text/x-patch;
 name="cypress_atacb_fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cypress_atacb_fix.diff"


64a87b244b9297667ca80264aab849a36f494884 commit change the scsi_eh_prep_cmnd logic by making it clear the ->cmnd buffer.

But the sat to cypress atacb translation supposed the ->cmnd buffer wasn't modified.

This patch makes it set the ->cmnd buffer after scsi_eh_prep_cmnd call.


Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index 898e67d..526c9aa 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -143,6 +143,8 @@ void cypress_atacb_passthrough(struct scsi_cmnd *srb, struct us_data *us)
 		 * the read taskfile bit, for not executing atacb command,
 		 * but reading register selected in srb->cmnd[4]
 		 */
+		srb->cmd_len = 16;
+		memcpy(srb->cmnd, ses.cmnd, srb->cmd_len);
 		srb->cmnd[2] = 1;
 
 		usb_stor_transparent_scsi_command(srb, us);

--------------020205060409000804060008--
