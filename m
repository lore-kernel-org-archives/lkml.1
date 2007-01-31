Return-Path: <linux-kernel-owner+w=401wt.eu-S1752177AbXAaBMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbXAaBMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbXAaBMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:12:15 -0500
Received: from rtr.ca ([64.26.128.89]:3800 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbXAaBMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:12:13 -0500
From: Mark Lord <liml@rtr.ca>
To: linux-kernel@vger.kernel.org,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org
Subject: [PATCH] RESEND scsi_lib.c: continue after MEDIUM_ERROR
Date: Tue, 30 Jan 2007 20:12:11 -0500
User-Agent: KMail/1.9.4
References: <200701301947.08478.liml@rtr.ca>
In-Reply-To: <200701301947.08478.liml@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701302012.11891.liml@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed for 80-columns, and copying linux-scsi this time.

In ancient kernels, the SCSI disk code used to continue after
encountering a MEDIUM_ERROR.  It would "complete" the good
sectors before the error, fail the bad sector/block, and then
continue with the rest of the request.

Kernels since about 2.6.16 or so have been broken in this regard.
They "complete" the good sectors before the error,
and then fail the entire remaining portions of the request.

This is very risky behaviour, as a request is often a merge
of several bios, and just because one application hits a bad sector
is no reason to pretend that (for example) an adjacent directly lookup also failed.

This patch fixes the behaviour to be similar to what we had originally.

When a bad sector is encounted, SCSI will now work around it again,
failing *only* the bad sector itself.

Signed-off-by:  Mark Lord <mlord@pobox.com>
---
--- old/drivers/scsi/scsi_lib.c	2007-01-30 20:06:15.000000000 -0500
+++ linux/drivers/scsi/scsi_lib.c	2007-01-30 20:06:59.000000000 -0500
@@ -865,6 +865,13 @@
 	 */
 	if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
+		case MEDIUM_ERROR:
+			/* Bad sector. Fail it, and continue on with the rest */
+			if (scsi_end_request(cmd, 0,
+					cmd->device->sector_size, 1) == NULL) {
+				cmd->retries = 0;	/* go around again.. */
+				return;
+			}
 		case UNIT_ATTENTION:
 			if (cmd->device->removable) {
 				/* Detected disc change.  Set a bit
