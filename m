Return-Path: <linux-kernel-owner+w=401wt.eu-S1764933AbZD3RLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764933AbZD3RLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764290AbZD3RHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:25 -0400
Received: from kroah.org ([198.145.64.141]:56205 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764141AbZD3RHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:20 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:39 2009
Message-Id: <20090430165739.807374880@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:55:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Boaz Harrosh <bharrosh@panasas.com>,
       Matthieu CASTET <castet.matthieu@free.fr>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 10/88] USB: fix USB_STORAGE_CYPRESS_ATACB
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0009-USB-fix-USB_STORAGE_CYPRESS_ATACB.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

upstream commit: 1f4159c1620f74377e26d8a569d10ca5907ef475

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
Cc: stable <stable@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/storage/cypress_atacb.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -133,19 +133,18 @@ void cypress_atacb_passthrough(struct sc
 
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
@@ -162,8 +161,8 @@ void cypress_atacb_passthrough(struct sc
 
 		/* XXX we should generate sk, asc, ascq from status and error
 		 * regs
-		 * (see 11.1 Error translation ­ ATA device error to SCSI error map)
-		 * and ata_to_sense_error from libata.
+		 * (see 11.1 Error translation ATA device error to SCSI error
+		 *  map, and ata_to_sense_error from libata.)
 		 */
 
 		/* Sense data is current and format is descriptor. */


