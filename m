Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbZBKHyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbZBKHyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 02:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZBKHyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 02:54:40 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:39916 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbZBKHyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 02:54:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qyoR3kweJNv+Y5rn5b/CiiUxpUb0hw3ISmIgsZIimD0OI5x40HKR422LMQ9FmwKK2F
         OO13sBV7gHKCGVW4QosmhvaPKQ+u6bisudDbN+tmoqC70SEh83+GDU3eOxJiaWR2+eq6
         haICrX3mJJOFFEuk0RWkmimokMF95nYbpfv8A=
Message-ID: <49928437.6020807@panasas.com>
Date: Wed, 11 Feb 2009 09:54:31 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       matthieu castet <castet.matthieu@free.fr>
CC: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
       linux-usb@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: [PATCH -stable resend] fix USB_STORAGE_CYPRESS_ATACB
References: <495913A6.9070007@free.fr> <20081229192431.GZ1469@one-eyed-alien.net> <495A475D.7060608@panasas.com>
In-Reply-To: <495A475D.7060608@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James hi.

I'm resending a forgotten patch. See here:
http://lkml.indiana.edu/hypermail/linux/kernel/0812.3/01127.html

I'll need Matthew Dharm ACK or who ever maintains cypress_atacb

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
CC: stable@kernel.org
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

