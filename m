Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYLaKf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYLaKf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbYLaKfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:35:13 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:19223 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753033AbYLaKfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:35:12 -0500
Message-ID: <495B4ADB.3020904@panasas.com>
Date: Wed, 31 Dec 2008 12:35:07 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: matthieu castet <castet.matthieu@free.fr>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
CC: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
       linux-usb@vger.kernel.org
Subject: [PATCH -stable] fix USB_STORAGE_CYPRESS_ATACB
References: <495913A6.9070007@free.fr> <20081229192431.GZ1469@one-eyed-alien.net> <495A475D.7060608@panasas.com>
In-Reply-To: <495A475D.7060608@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 31 Dec 2008 10:35:06.0073 (UTC) FILETIME=[723ACC90:01C96B33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthieu, Matthew

I fixed lots of "mucking directly" with scsi_cmnd and scsi_eh_save
internal members but the actual set of srb->cmnd{,_len} is needed
still. Though we don't need the copy since we restore the original
command right after. If anyone can test this to verify it could
be grate.

Sorry for the mishap
Boaz
 
---
From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] fix USB_STORAGE_CYPRESS_ATACB

commit 64a87b24: [SCSI] Let scsi_cmnd->cmnd use request->cmd buffer
changed the scsi_eh_prep_cmnd logic by making it clear
the ->cmnd buffer. But the sat to cypress atacb translation supposed
the ->cmnd buffer wasn't modified.

This patch makes it set the ->cmnd buffer after scsi_eh_prep_cmnd call.
The problem and a fix was reported by Matthieu CASTET <castet.matthieu@free.fr>

It also removes all the hackery fiddling of scsi_cmnd and scsi_eh_save by
requesting from scsi_eh_prep_cmnd to prepare a read into ->sense_buffer,
which is much more suitable a buffer for HW transfers, then after the command
execution the regs read is copied into regs buffer before actual preparation
of sense_buffer.

Also fix an alien comment character to my utf-8 editor.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
---
 drivers/usb/storage/cypress_atacb.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index 898e67d..9466a99 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -133,19 +133,18 @@ void cypress_atacb_passthrough(struct scsi_cmnd *srb, struct us_data *us)
 
 		/* build the command for
 		 * reading the ATA registers */
-		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, 0);
-		srb->sdb.length = sizeof(regs);
-		sg_init_one(&ses.sense_sgl, regs, srb->sdb.length);
-		srb->sdb.table.sgl = &ses.sense_sgl;
-		srb->sc_data_direction = DMA_FROM_DEVICE;
-		srb->sdb.table.nents = 1;
+		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, sizeof(regs));
+
 		/* we use the same command as before, but we set
 		 * the read taskfile bit, for not executing atacb command,
 		 * but reading register selected in srb->cmnd[4]
 		 */
+		srb->cmd_len = 16;
+		srb->cmnd = ses.cmnd;
 		srb->cmnd[2] = 1;
 
 		usb_stor_transparent_scsi_command(srb, us);
+		memcpy(regs, srb->sense_buffer, sizeof(regs));
 		tmp_result = srb->result;
 		scsi_eh_restore_cmnd(srb, &ses);
 		/* we fail to get registers, report invalid command */
@@ -162,8 +161,8 @@ void cypress_atacb_passthrough(struct scsi_cmnd *srb, struct us_data *us)
 
 		/* XXX we should generate sk, asc, ascq from status and error
 		 * regs
-		 * (see 11.1 Error translation � ATA device error to SCSI error map)
-		 * and ata_to_sense_error from libata.
+		 * (see 11.1 Error translation ATA device error to SCSI error
+		 *  map, and ata_to_sense_error from libata.)
 		 */
 
 		/* Sense data is current and format is descriptor. */
-- 
1.6.0.1

