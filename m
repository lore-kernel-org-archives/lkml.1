Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbXFNGXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbXFNGXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 02:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXFNGXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 02:23:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:23692 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbXFNGXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 02:23:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=HDwRGw0/vwvNAdqRpOdutTjspFKPPyFTZAoli/fNAgTnOjVozF2SE/xcIg8xupFVHvxOnAww3yI8TfOzwXcvZoNwVSkJ+TZWMWxo1NxU1wHMrgTSQdNaS87a5KtMv4SyCoAUuxxECfv4RtaWOmEtAmDBbWfYguVPc8CNq4gDgIs=
Date: Thu, 14 Jun 2007 14:24:30 +0000
From: Dave Young <hidave.darkstar@gmail.com>
To: Jens Axboe <axboe@image.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] cdrom_sysctl_info fix
Message-ID: <20070614142430.GA2388@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Fix the cdrom_sysctl_info possible buffer overwrite bug. Somd codingstyle fixes are included as well. 

diff based on 2.6.22-rc4

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
drivers/cdrom/cdrom.c | 186 +-
1 files changed, 102 insertions(+), 84 deletions(-)

diff -upr linux/drivers/cdrom/cdrom.c linux.new/drivers/cdrom/cdrom.c
--- linux/drivers/cdrom/cdrom.c	2007-06-14 14:05:04.000000000 +0000
+++ linux.new/drivers/cdrom/cdrom.c	2007-06-14 14:11:58.000000000 +0000
@@ -3290,102 +3290,120 @@ static struct cdrom_sysctl_settings {
 } cdrom_sysctl_settings;
 
 static int cdrom_sysctl_info(ctl_table *ctl, int write, struct file * filp,
-                           void __user *buffer, size_t *lenp, loff_t *ppos)
+				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-        int pos;
+	int pos;
 	struct cdrom_device_info *cdi;
 	char *info = cdrom_sysctl_settings.info;
+	int size = sizeof(cdrom_sysctl_settings.info);
 	
 	if (!*lenp || (*ppos && !write)) {
 		*lenp = 0;
 		return 0;
 	}
 
-	pos = sprintf(info, "CD-ROM information, " VERSION "\n");
+	pos = scnprintf(info, size, "CD-ROM information, " VERSION "\n");
 	
-	pos += sprintf(info+pos, "\ndrive name:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%s", cdi->name);
-
-	pos += sprintf(info+pos, "\ndrive speed:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", cdi->speed);
-
-	pos += sprintf(info+pos, "\ndrive # of slots:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", cdi->capacity);
-
-	pos += sprintf(info+pos, "\nCan close tray:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_CLOSE_TRAY) != 0);
-
-	pos += sprintf(info+pos, "\nCan open tray:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_OPEN_TRAY) != 0);
-
-	pos += sprintf(info+pos, "\nCan lock tray:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_LOCK) != 0);
-
-	pos += sprintf(info+pos, "\nCan change speed:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_SELECT_SPEED) != 0);
-
-	pos += sprintf(info+pos, "\nCan select disk:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_SELECT_DISC) != 0);
-
-	pos += sprintf(info+pos, "\nCan read multisession:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MULTI_SESSION) != 0);
-
-	pos += sprintf(info+pos, "\nCan read MCN:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MCN) != 0);
-
-	pos += sprintf(info+pos, "\nReports media changed:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MEDIA_CHANGED) != 0);
-
-	pos += sprintf(info+pos, "\nCan play audio:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_PLAY_AUDIO) != 0);
-
-	pos += sprintf(info+pos, "\nCan write CD-R:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_CD_R) != 0);
-
-	pos += sprintf(info+pos, "\nCan write CD-RW:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_CD_RW) != 0);
-
-	pos += sprintf(info+pos, "\nCan read DVD:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD) != 0);
-
-	pos += sprintf(info+pos, "\nCan write DVD-R:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_R) != 0);
-
-	pos += sprintf(info+pos, "\nCan write DVD-RAM:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_RAM) != 0);
-
-	pos += sprintf(info+pos, "\nCan read MRW:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MRW) != 0);
-
-	pos += sprintf(info+pos, "\nCan write MRW:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MRW_W) != 0);
-
-	pos += sprintf(info+pos, "\nCan write RAM:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_RAM) != 0);
+	pos += scnprintf(info + pos, size - pos, "\ndrive name:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%s", cdi->name);
+
+	pos += scnprintf(info + pos, size - pos ,"\ndrive speed:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", cdi->speed);
+
+	pos += scnprintf(info + pos, size - pos, "\ndrive # of slots:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", cdi->capacity);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan close tray:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_CLOSE_TRAY) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan open tray:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_OPEN_TRAY) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan lock tray:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_LOCK) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan change speed:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_SELECT_SPEED) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan select disk:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_SELECT_DISC) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan read multisession:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_MULTI_SESSION) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan read MCN:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_MCN) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nReports media changed:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_MEDIA_CHANGED) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan play audio:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_PLAY_AUDIO) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan write CD-R:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_CD_R) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan write CD-RW:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_CD_RW) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan read DVD:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_DVD) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan write DVD-R:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_DVD_R) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan write DVD-RAM:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_DVD_RAM) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan read MRW:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_MRW) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan write MRW:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_MRW_W) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan write RAM:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", 
+					CDROM_CAN(CDC_RAM) != 0);
 
-	strcpy(info+pos,"\n\n");
+	scnprintf(info + pos, size - pos, "\n\n");
 		
-        return proc_dostring(ctl, write, filp, buffer, lenp, ppos);
+	return proc_dostring(ctl, write, filp, buffer, lenp, ppos);
 }
 
 /* Unfortunately, per device settings are not implemented through

Regards
dave
