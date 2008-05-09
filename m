Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYEIUQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYEIUQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 16:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYEIUPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 16:15:50 -0400
Received: from eazy.amigager.de ([213.239.192.238]:45968 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbYEIUPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 16:15:49 -0400
Date: Fri, 9 May 2008 22:16:36 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Clean patch to fix not working spindown over Firewire
Message-ID: <20080509201635.GA20189@dose.home.local>
Mail-Followup-To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20080429232606.GA14261@dose.home.local> <481874BD.5010807@s5r6.in-berlin.de> <481875E4.6040606@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <481875E4.6040606@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 30, 2008 at 15:36:36 +0200, Stefan Richter wrote:

[...]

> PS:
> If it works for all RBC devices (it should according to the spec...) &&
> your ICY Box exposes itself as RBC device (it should do so), then we
> don't need any changes to struct scsi_device and to sbp2/ firewire-sbp2.

Do you mean something like in the attached (untested) patch?

Regards,
Tino

--+QahgC5+KEYLbs62
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="start_stop_unit_set_power_condition_v3.diff"

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 01cefbb..6b927f6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1787,8 +1787,13 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	struct scsi_device *sdp = sdkp->device;
 	int res;
 
-	if (start)
+	if (start) {
 		cmd[4] |= 1;	/* START */
+		/* active power condition */
+		cmd[4] |= (sdp->type == TYPE_RBC) ? (1 << 4) : 0; 
+	} else
+		/* standby power condition */
+		cmd[4] |= (sdp->type == TYPE_RBC) ? (3 << 4) : 0 ; 
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;

--+QahgC5+KEYLbs62--
