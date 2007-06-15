Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbXFOGdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbXFOGdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 02:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbXFOGcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 02:32:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:65196 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbXFOGcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 02:32:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bLvcvB64Q41MZkyq9fqIvrOh9jc5If8qPVh39G2p7NdyK1knQpGHARpwKfddG56IRXSSv/M2S6rNbian+Cr+3I6eGlMSDlPH+7H5Fs9bRcVmFpbOxIIhNiNybsZClIrWHKgo8LhC3Dt6fwVo5P4MhRQ5vANF+RnkHTL9oQgeorg=
Date: Fri, 15 Jun 2007 14:33:59 +0000
From: Dave Young <hidave.darkstar@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cdrom_sysctl_info fix
Message-ID: <20070615143359.GA3111@darkstar.te-china.tietoenator.com>
References: <20070614142430.GA2388@darkstar.te-china.tietoenator.com> <a8e1da0706132340o6c00234fwdf223d9972d5937c@mail.gmail.com> <20070614084336.166b9db4.randy.dunlap@oracle.com> <a8e1da0706141711o1dea5235q53f3b9f38a80cfe8@mail.gmail.com> <20070615055845.GJ6149@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615055845.GJ6149@kernel.dk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
>On Fri, Jun 15, 2007 at 07:58:47AM +0200, Jens Axboe wrote:
> Hey, no point in CC'ing me twice! axboe@kernel.dk works just fine as
> well.
> 
I'm sorry for it , jens. Now I resend the patch after remove some checkpatch.pl warnings(line breaking trailing space). 

If user have many cdrom drives, then the buffer is not enough, so I write this patch along with a little coding style fixing. Do you think I need to rewrite to two patches?

Regards
dave
----------------------

From: Dave Young <hidave.darkstar@gmail.com>

cdrom_sysctl_info may cause buffer overwrite.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
diff -upr linux/drivers/cdrom/cdrom.c linux.new/drivers/cdrom/cdrom.c
--- linux/drivers/cdrom/cdrom.c	2007-06-14 14:05:04.000000000 +0000
+++ linux.new/drivers/cdrom/cdrom.c	2007-06-15 13:24:10.000000000 +0000
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
+	pos += scnprintf(info + pos, size - pos, "\ndrive speed:\t");
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
