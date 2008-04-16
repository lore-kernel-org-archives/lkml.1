Return-Path: <linux-kernel-owner+w=401wt.eu-S1759132AbYDPB1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132AbYDPB1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 21:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbYDPB1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 21:27:44 -0400
Received: from rv-out-0708.google.com ([209.85.198.242]:21747 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752818AbYDPB1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 21:27:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=K6P7kIi1fiOj0GpDZhy5FI1o8KYWuAor1IQ6fLY/+5FPspOohSDH9RrubIdqaxQD2FAFSxX0ju6ynW46CIYPOjQAUJ/Jomsj0oKBZewaUP1yQwnP10H39+6iyLcHrmwUx42hRtXk9q0kFMKtNC8ZCW/bU3nstbXK97psv9iOLtc=
Message-ID: <48055609.3020403@gmail.com>
Date: Wed, 16 Apr 2008 10:27:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Collins <paul@burly.ondioline.org>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: [PATCH #upstream-fixes] libata: force hardreset if the link is in
 powersave mode
References: <87od8cxg45.fsf@burly.wgtn.ondioline.org>	<48040AB5.6050300@gmail.com> <87hce3yhmi.fsf@burly.wgtn.ondioline.org>	<480419B6.1050309@gmail.com> <87d4oryf4u.fsf@burly.wgtn.ondioline.org>	<4804288D.5090504@gmail.com> <87y77ex1oh.fsf@burly.wgtn.ondioline.org>	<48052BB3.2090509@gmail.com> <87od8awxh5.fsf@burly.wgtn.ondioline.org>	<48054515.4020202@gmail.com> <4805496E.7000306@gmail.com> <87k5iywquy.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <87k5iywquy.fsf@burly.wgtn.ondioline.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, libata doesn't support link powersave modes and always
disables link PS modes.  However, if the link is already in powersave
mode when libata begis probing, inhibiting powersave modes by setting
IPM isn't enough.  Link should be manually transited into active mode
using SPM or hardreset.

As SPM isn't avalable on all controllers and we're gonna prefer
hardreset in future anyway, force hardreset if link is in powersave
mode.

Reported-by: Paul Collins <paul@burly.ondioline.org>
Signed-off-by: Tejun Heo <htejun@gmail.com>
---
Jeff, this isn't necessary for #upstream.

 drivers/ata/libata-core.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

index be95fdb..e3ddefd 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3966,11 +3966,26 @@ int ata_std_prereset(struct ata_link *link, unsigned long deadline)
 
 	/* if SATA, resume link */
 	if (ap->flags & ATA_FLAG_SATA) {
+		u32 sstatus;
+
 		rc = sata_link_resume(link, timing, deadline);
 		/* whine about phy resume failure but proceed */
 		if (rc && rc != -EOPNOTSUPP)
 			ata_link_printk(link, KERN_WARNING, "failed to resume "
 					"link for reset (errno=%d)\n", rc);
+
+		/* force hardreset if the link is sleeping */
+		if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0) {
+			u8 ipm = sstatus >> 8;
+
+			if (ipm == 2 || ipm == 6) {
+				ata_link_printk(link, KERN_INFO,
+					"link in %s mode, forcing hardreset\n",
+					ipm == 2 ? "partial" : "slumber");
+				ehc->i.action |= ATA_EH_HARDRESET;
+				return 0;
+			}
+		}
 	}
 
 	/* Wait for !BSY if the controller can wait for the first D2H
