Return-Path: <linux-kernel-owner+w=401wt.eu-S932164AbYGUElX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbYGUElX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 00:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYGUElP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 00:41:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:55253 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbYGUElO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 00:41:14 -0400
Message-ID: <48841331.60008@kernel.org>
Date: Mon, 21 Jul 2008 13:40:17 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: chunbo.luo@windriver.com
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]: libata-scsi: Don't start hotplug work queue if	hotplug
 is	disabled
References: <1214533246.6284.10.camel@pek-cluo>	 <48809BA0.8060500@kernel.org> <1216609385.6358.14.camel@pek-cluo>
In-Reply-To: <1216609385.6358.14.camel@pek-cluo>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------060400030200040000090803"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 21 Jul 2008 04:40:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060400030200040000090803
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Chunbo Luo wrote:
>> And this message has nothing to do with SCSI.  It's printed by libata
>> proper for several drivers which don't support ATAPI.  Did the patch
>> really kill the warning messages?  Can you please post full boot log
>> from 2.6.26 w/o the patch?
> 
> If the drivers don't support ATAPI, the hotplug task cannot find linked device,
> and it will start the hotplug task again. Which will print messages continously 
> like this.
> 
> ----------
> ﻿ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.
> ﻿ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.
> ﻿ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.
> ﻿ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.
> ...
> ------------
> 
> We should find a way to avoid this kind of noisy warning messages.
> 
> This patch cannot kill the warning messages, but it can avoid the
> duplicate warning messages.

Hmmm... yeah, indeed.  That check is located at rather strange place.
Can you please test the attached patch?

Thanks.

-- 
tejun

--------------060400030200040000090803
Content-Type: text/x-patch;
 name="update-atapi-disable.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="update-atapi-disable.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9bef1a8..9cd04f6 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -120,7 +120,7 @@ static char ata_force_param_buf[PAGE_SIZE] __initdata;
 module_param_string(force, ata_force_param_buf, sizeof(ata_force_param_buf), 0);
 MODULE_PARM_DESC(force, "Force ATA configurations including cable type, link speed and transfer mode (see Documentation/kernel-parameters.txt for details)");
 
-int atapi_enabled = 1;
+static int atapi_enabled = 1;
 module_param(atapi_enabled, int, 0444);
 MODULE_PARM_DESC(atapi_enabled, "Enable discovery of ATAPI devices (0=off, 1=on)");
 
@@ -2142,6 +2142,16 @@ int ata_dev_configure(struct ata_device *dev)
 		return 0;
 	}
 
+	if ((!atapi_enabled || (ap->flags & ATA_FLAG_NO_ATAPI)) &&
+	    dev->class == ATA_DEV_ATAPI) {
+		ata_dev_printk(dev, KERN_WARNING,
+			"WARNING: ATAPI is %s, device ignored.\n",
+			atapi_enabled ? "not supported with this driver"
+				      : "disabled");
+		ata_dev_disable(dev);
+		return 0;
+	}
+
 	/* let ACPI work its magic */
 	rc = ata_acpi_on_devcfg(dev);
 	if (rc)
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 479c29e..4627774 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2550,36 +2550,6 @@ static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
 }
 
 /**
- *	ata_scsi_dev_enabled - determine if device is enabled
- *	@dev: ATA device
- *
- *	Determine if commands should be sent to the specified device.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- *
- *	RETURNS:
- *	0 if commands are not allowed / 1 if commands are allowed
- */
-
-static int ata_scsi_dev_enabled(struct ata_device *dev)
-{
-	if (unlikely(!ata_dev_enabled(dev)))
-		return 0;
-
-	if (!atapi_enabled || (dev->link->ap->flags & ATA_FLAG_NO_ATAPI)) {
-		if (unlikely(dev->class == ATA_DEV_ATAPI)) {
-			ata_dev_printk(dev, KERN_WARNING,
-				       "WARNING: ATAPI is %s, device ignored.\n",
-				       atapi_enabled ? "not supported with this driver" : "disabled");
-			return 0;
-		}
-	}
-
-	return 1;
-}
-
-/**
  *	ata_scsi_find_dev - lookup ata_device from scsi_cmnd
  *	@ap: ATA port to which the device is attached
  *	@scsidev: SCSI device from which we derive the ATA device
@@ -2600,7 +2570,7 @@ ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev)
 {
 	struct ata_device *dev = __ata_scsi_find_dev(ap, scsidev);
 
-	if (unlikely(!dev || !ata_scsi_dev_enabled(dev)))
+	if (unlikely(!dev || !ata_dev_enabled(dev)))
 		return NULL;
 
 	return dev;
@@ -3621,7 +3591,7 @@ int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
 
 	ata_scsi_dump_cdb(ap, cmd);
 
-	if (likely(ata_scsi_dev_enabled(ap->link.device)))
+	if (likely(ata_dev_enabled(ap->link.device)))
 		rc = __ata_scsi_queuecmd(cmd, done, ap->link.device);
 	else {
 		cmd->result = (DID_BAD_TARGET << 16);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index f6f9c28..ade5c75 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -66,7 +66,6 @@ enum {
 
 extern unsigned int ata_print_id;
 extern struct workqueue_struct *ata_aux_wq;
-extern int atapi_enabled;
 extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;

--------------060400030200040000090803--
