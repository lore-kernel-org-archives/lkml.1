Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbXETLcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbXETLcJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbXETLb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:31:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:22352 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbXETLb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:31:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=tfuAvdjzIaaaoBiIZM2hS+H0ghVzFW6u4WMPOEuCxySgMWi/GK1lhePRbEh+NlBqdnpuwxEprWxKwgF1DvoeYdoNTvw7iEHWQsDjYe0wsbUuq7oUjbkGaYprH5rTuCf4YPhJgDcPm1at72kSmJHXwgmkIFqcoIdq14j6okB785w=
Message-ID: <46503192.1040300@gmail.com>
Date: Sun, 20 May 2007 13:31:30 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Robert de Rooy <robert.de.rooy@gmail.com>
CC: linux-kernel@vger.kernel.org, alan@redhat.com, bzolnier@gmail.com,
       jgarzik@pobox.com
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com> <464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com>
In-Reply-To: <464CB7C9.2080807@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------060903090108070107000403"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060903090108070107000403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

1. Please apply timing-debug.patch on 2.6.22rc1-git5 or later and report
the log with timestamp as before.  Let's see why the timeout has doubled.

2. Does the attached disable-dev_init_params.patch fix your problem?

-- 
tejun

--------------060903090108070107000403
Content-Type: text/x-patch;
 name="timing-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="timing-debug.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d5939e6..6e98c85 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1695,8 +1695,10 @@ int ata_dev_read_id(struct ata_device *d
 	 */
 	tf.flags |= ATA_TFLAG_POLLING;
 
+	ata_dev_printk(dev, KERN_INFO, "issuing IDENTIFY\n");
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_FROM_DEVICE,
 				     id, sizeof(id[0]) * ATA_ID_WORDS);
+	ata_dev_printk(dev, KERN_INFO, "IDENTIFY complete\n");
 	if (err_mask) {
 		if (err_mask & AC_ERR_NODEV_HINT) {
 			DPRINTK("ata%u.%d: NODEV after polling detection\n",
@@ -1779,7 +1781,9 @@ int ata_dev_read_id(struct ata_device *d
 		 * Some drives were very specific about that exact sequence.
 		 */
 		if (ata_id_major_version(id) < 4 || !ata_id_has_lba(id)) {
+			ata_dev_printk(dev, KERN_INFO, "issuing DEV_INIT_PARAMS\n");
 			err_mask = ata_dev_init_params(dev, id[3], id[6]);
+			ata_dev_printk(dev, KERN_INFO, "DEV_INIT_PARAMS complete\n");
 			if (err_mask) {
 				rc = -EIO;
 				reason = "INIT_DEV_PARAMS failed";
@@ -6369,7 +6373,7 @@ int ata_host_register(struct ata_host *h
 
 			ehi->probe_mask = (1 << ATA_MAX_DEVICES) - 1;
 			ehi->action |= ATA_EH_SOFTRESET;
-			ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
+			ehi->flags |= ATA_EHI_NO_AUTOPSY/* | ATA_EHI_QUIET*/;
 
 			ap->pflags &= ~ATA_PFLAG_INITIALIZING;
 			ap->pflags |= ATA_PFLAG_LOADING;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 5309c31..99b573e 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1980,6 +1980,7 @@ static int ata_eh_recover(struct ata_por
 					"reset failed, giving up\n");
 			goto out;
 		}
+		ata_port_printk(ap, KERN_INFO, "reset complete\n");
 
 		ata_eh_thaw_port(ap);
 	}

--------------060903090108070107000403
Content-Type: text/x-patch;
 name="disable-dev_init_params.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="disable-dev_init_params.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d5939e6..25677f4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1769,6 +1769,7 @@ int ata_dev_read_id(struct ata_device *d
 			goto retry;
 	}
 
+#if 0
 	if ((flags & ATA_READID_POSTRESET) && class == ATA_DEV_ATA) {
 		/*
 		 * The exact sequence expected by certain pre-ATA4 drives is:
@@ -1793,6 +1794,7 @@ int ata_dev_read_id(struct ata_device *d
 			goto retry;
 		}
 	}
+#endif
 
 	*p_class = class;
 

--------------060903090108070107000403--
