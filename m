Return-Path: <linux-kernel-owner+w=401wt.eu-S1758892AbYEJWfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbYEJWfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 18:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbYEJWfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 18:35:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44144 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbYEJWfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 18:35:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 11 May 2008 00:34:07 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/5] scsi: sd: optionally set power condition in START STOP
 UNIT
To: linux1394-devel@lists.sourceforge.net,
       James Bottomley <James.Bottomley@HansenPartnership.com>
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Tino Keitel <tino.keitel@gmx.de>
In-Reply-To: <tkrat.5cf7605228f0006a@s5r6.in-berlin.de>
Message-ID: <tkrat.939c665f57d83cd4@s5r6.in-berlin.de>
References: <20080429232606.GA14261@dose.home.local>
 <481874BD.5010807@s5r6.in-berlin.de>
 <20080507180042.GA32629@dose.home.local>
 <tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
 <tkrat.635f52f7035be2bc@s5r6.in-berlin.de>
 <tkrat.5cf7605228f0006a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a new scsi_device flag, start_stop_pwr_cond:  If enabled, the sd
driver will not send plain START STOP UNIT commands but ones with the
power condition field set to 3 (standby) or 1 (active) respectively.

Some FireWire disk firmwares do not stop the motor if power condition is
zero.  Or worse, the become unresponsive after a START STOP UNIT with
power condition = 0 and start = 0.

http://lkml.org/lkml/2008/4/29/704

This patch only adds the necessary code to sd_mod but doesn't activate
it.  Follow-up patches to the FireWire drivers will add detection of
affected devices and enable the code for them.

I did not add power condition values to scsi_error.c::scsi_eh_try_stu()
for now.  The three firmwares which suffer from above mentioned problems
do not need START STOP UNIT in the error handler, and they are not
adversely affected by START STOP UNIT with power condition = 0 and start
= 1 (like scsi_eh_try_stu() sends it if scsi_device.allow_restart is
enabled).

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/scsi/sd.c          |    5 +++++
 include/scsi/scsi_device.h |    1 +
 2 files changed, 6 insertions(+)

Index: linux/drivers/scsi/sd.c
===================================================================
--- linux.orig/drivers/scsi/sd.c
+++ linux/drivers/scsi/sd.c
@@ -1115,6 +1115,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				cmd[1] = 1;	/* Return immediately */
 				memset((void *) &cmd[2], 0, 8);
 				cmd[4] = 1;	/* Start spin cycle */
+				if (sdkp->device->start_stop_pwr_cond)
+					cmd[4] |= 1 << 4;
 				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
 						 NULL, 0, &sshdr,
 						 SD_TIMEOUT, SD_MAX_RETRIES);
@@ -1781,6 +1783,9 @@ static int sd_start_stop_device(struct s
 	if (start)
 		cmd[4] |= 1;	/* START */
 
+	if (sdp->start_stop_pwr_cond)
+		cmd[4] |= start ? 1 << 4 : 3 << 4;
+
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
Index: linux/include/scsi/scsi_device.h
===================================================================
--- linux.orig/include/scsi/scsi_device.h
+++ linux/include/scsi/scsi_device.h
@@ -134,6 +134,7 @@ struct scsi_device {
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
 	unsigned manage_start_stop:1;	/* Let HLD (sd) manage start/stop */
+	unsigned start_stop_pwr_cond:1;	/* Set power cond. in START_STOP_UNIT */
 	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
 	unsigned select_no_atn:1;
 	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */

-- 
Stefan Richter
-=====-==--- -=-= -=-==
http://arcgraph.de/sr/

