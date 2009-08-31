Return-Path: <linux-kernel-owner+w=401wt.eu-S1751365AbZHaHjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbZHaHjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 03:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbZHaHjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 03:39:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:48853 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbZHaHjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 03:39:15 -0400
Message-ID: <4A9B7E1E.8060909@kernel.org>
Date: Mon, 31 Aug 2009 16:39:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.31-rc5 regression: hd don't show up
References: <h63737$b2a$1@ger.gmane.org> <4A852BC0.1090404@kernel.org> <4A8559D7.6090405@klingt.org> <4A8774E5.4070609@kernel.org> <4A87D9FC.9070408@klingt.org> <4A96460F.3020600@kernel.org> <4A965E3B.3000808@klingt.org> <4A966F7D.60707@kernel.org> <4A97B9C0.9090003@klingt.org>
In-Reply-To: <4A97B9C0.9090003@klingt.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------010406060106060808090906"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 07:39:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010406060106060808090906
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Tim Blechmann wrote:
> booting the machine today, one hd is missing again ... bootlog attached

Hmmm... strange.  I don't really see how it could be escaping.  Can
you please apply the attached patch?  It still won't change the
behavior but should be able to catch where it's escaping.

Thanks.

-- 
tejun

--------------010406060106060808090906
Content-Type: text/x-patch;
 name="nodev-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nodev-debug.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 98af50f..6edd2c4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3656,12 +3656,19 @@ int ata_wait_ready(struct ata_link *link, unsigned long deadline,
 				 !ata_link_offline(link) &&
 				 time_before(now, nodev_deadline))
 				ready = 0;
+			else
+				ata_link_printk(link, KERN_INFO, "XXX wait_ready ready=%d link_offline=%d\n",
+						ready, ata_link_offline(link));
 		}
 
-		if (ready)
+		if (ready) {
+			ata_link_printk(link, KERN_INFO, "XXX wait_read returning %d\n", ready);
 			return ready;
-		if (time_after(now, deadline))
+		}
+		if (time_after(now, deadline)) {
+			ata_link_printk(link, KERN_INFO, "XXX wait_read returning -EBUSY\n");
 			return -EBUSY;
+		}
 
 		if (!warned && time_after(now, start + 5 * HZ) &&
 		    (deadline - now > 3 * HZ)) {
@@ -3792,6 +3799,7 @@ int sata_link_resume(struct ata_link *link, const unsigned long *params,
 
 	scontrol = (scontrol & 0x0f0) | 0x300;
 
+	ata_link_printk(link, KERN_INFO, "XXX bringing up link\n");
 	if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
 		return rc;
 
@@ -3800,7 +3808,9 @@ int sata_link_resume(struct ata_link *link, const unsigned long *params,
 	 */
 	msleep(200);
 
-	if ((rc = sata_link_debounce(link, params, deadline)))
+	rc = sata_link_debounce(link, params, deadline);
+	ata_link_printk(link, KERN_INFO, "XXX debounced rc=%d\n", rc);
+	if (rc)
 		return rc;
 
 	/* clear SError, some PHYs require this even for SRST to work */
@@ -3926,12 +3936,16 @@ int sata_link_hardreset(struct ata_link *link, const unsigned long *timing,
 	if (rc)
 		goto out;
 	/* if link is offline nothing more to do */
-	if (ata_phys_link_offline(link))
+	if (ata_phys_link_offline(link)) {
+		ata_link_printk(link, KERN_INFO, "XXX phys link offline\n");
 		goto out;
+	}
 
 	/* Link is online.  From this point, -ENODEV too is an error. */
-	if (online)
+	if (online) {
+		ata_link_printk(link, KERN_INFO, "XXX setting online\n");
 		*online = true;
+	}
 
 	if (sata_pmp_supported(link->ap) && ata_is_host_link(link)) {
 		/* If PMP is supported, we have to do follow-up SRST.
@@ -3964,6 +3978,8 @@ int sata_link_hardreset(struct ata_link *link, const unsigned long *timing,
 				"COMRESET failed (errno=%d)\n", rc);
 	}
 	DPRINTK("EXIT, rc=%d\n", rc);
+	ata_link_printk(link, KERN_INFO, "XXX link_hardreset online=%d returning %d\n",
+			online ? *online : -1, rc);
 	return rc;
 }
 
@@ -6082,7 +6098,7 @@ static void async_port_probe(void *data, async_cookie_t cookie)
 
 		ehi->probe_mask |= ATA_ALL_DEVICES;
 		ehi->action |= ATA_EH_RESET | ATA_EH_LPM;
-		ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
+		ehi->flags |= ATA_EHI_NO_AUTOPSY/* | ATA_EHI_QUIET*/;
 
 		ap->pflags &= ~ATA_PFLAG_INITIALIZING;
 		ap->pflags |= ATA_PFLAG_LOADING;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index bbbb1fa..468b5b9 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1998,6 +1998,9 @@ unsigned int ata_sff_dev_classify(struct ata_device *dev, int present,
 	if (r_err)
 		*r_err = err;
 
+	ata_dev_printk(dev, KERN_INFO, "XXX CLASSIFY TF %02x/%02x:%02x:%02x:%02x\n",
+		       tf.command, tf.feature, tf.lbal, tf.lbam, tf.lbah);
+
 	/* see if device passed diags: continue and warn later */
 	if (err == 0)
 		/* diagnostic fail : do nothing _YET_ */
@@ -2006,11 +2009,14 @@ unsigned int ata_sff_dev_classify(struct ata_device *dev, int present,
 		/* do nothing */ ;
 	else if ((dev->devno == 0) && (err == 0x81))
 		/* do nothing */ ;
-	else
+	else {
+		ata_dev_printk(dev, KERN_INFO, "XXX diag nodev\n");
 		return ATA_DEV_NONE;
+	}
 
 	/* determine if device is ATA or ATAPI */
 	class = ata_dev_classify(&tf);
+	ata_dev_printk(dev, KERN_INFO, "XXX ata_dev_classify=%d\n", class);
 
 	if (class == ATA_DEV_UNKNOWN) {
 		/* If the device failed diagnostic, it's likely to
@@ -2019,13 +2025,18 @@ unsigned int ata_sff_dev_classify(struct ata_device *dev, int present,
 		 * device signature is invalid with diagnostic
 		 * failure.
 		 */
-		if (present && (dev->horkage & ATA_HORKAGE_DIAGNOSTIC))
+		if (present && (dev->horkage & ATA_HORKAGE_DIAGNOSTIC)) {
+			ata_dev_printk(dev, KERN_INFO, "XXX UNK && present -> ATA\n");
 			class = ATA_DEV_ATA;
-		else
+		} else {
 			class = ATA_DEV_NONE;
+			ata_dev_printk(dev, KERN_INFO, "XXX UNK && !present -> NONE\n");
+		}
 	} else if ((class == ATA_DEV_ATA) &&
-		   (ap->ops->sff_check_status(ap) == 0))
+		   (ap->ops->sff_check_status(ap) == 0)) {
 		class = ATA_DEV_NONE;
+		ata_dev_printk(dev, KERN_INFO, "XXX stat==0 -> NONE\n");
+	}
 
 	return class;
 }
@@ -2211,6 +2222,8 @@ int sata_sff_hardreset(struct ata_link *link, unsigned int *class,
 		*class = ata_sff_dev_classify(link->device, 1, NULL);
 
 	DPRINTK("EXIT, class=%u\n", *class);
+	ata_link_printk(link, KERN_INFO, "XXX sff_hardreset rc=%d online=%d *class=%d\n",
+			rc, online, *class);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(sata_sff_hardreset);

--------------010406060106060808090906--
