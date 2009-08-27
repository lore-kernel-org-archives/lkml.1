Return-Path: <linux-kernel-owner+w=401wt.eu-S1751692AbZH0Lfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbZH0Lfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 07:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZH0Lfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 07:35:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:54009 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbZH0Lfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 07:35:30 -0400
Message-ID: <4A966F7D.60707@kernel.org>
Date: Thu, 27 Aug 2009 20:35:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.31-rc5 regression: hd don't show up
References: <h63737$b2a$1@ger.gmane.org> <4A852BC0.1090404@kernel.org> <4A8559D7.6090405@klingt.org> <4A8774E5.4070609@kernel.org> <4A87D9FC.9070408@klingt.org> <4A96460F.3020600@kernel.org> <4A965E3B.3000808@klingt.org>
In-Reply-To: <4A965E3B.3000808@klingt.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------020802050005030801070003"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 27 Aug 2009 11:35:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020802050005030801070003
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Tim Blechmann wrote:
> On 08/27/2009 10:38 AM, Tejun Heo wrote:
>> Tim Blechmann wrote:
>>>>>>> running 2.6.31-rc5 (7cb7beb31aa3d941833b6a6e553687422c31e4b6 to be
>>>>>>> exact), sometimes some hard disks don't show up.
>>>>>>>
>>>>>>> after booting, my root hd (sda) is mounted to /, while two other hds
>>>>>>> (sdb/sdc) are mounted as a user. sda is always present, but the other
>>>>>>> two sometimes don't show up (i.e. they are not listed in /dev/disk/, nor
>>>>>>> to they have a /dev/sdX link). with 2.6.29 and 2.6.30, all three disks
>>>>>>> are reported correctly.
>>>>>> Can you please attach boot logs of a successful and a failed boot?
>>>>> i have two files attached:
>>>>> - dmesg_good - all hds are available
>>>>> - dmesg_bad - on hd is missing
>>>> Can you please apply the attached patch and post the bad boot log?
>>> attached you find boot logs for both a good ad a bad boot
>> Sorry about the long delay.  I somehow marked the message read without
>> actually reading it.
>>
>> I suspected the problem was with getting the wrong classification code
>> or phantom device detection kicking in spuriously.  Looks like the
>> problem happens way before that.  Can you please apply the attached
>> patch and report the result?
> 
> i applied your patch onto of the current linus/master branch and
> currently (after rebooting 5 or 6 times) i cannot reproduce the problem
> any more ...
> however, there is a warning stack trace in the boot log from libata code
> (bootlog attached)

Oops, that was my bad.  This should remove the useless warning.

Thanks.

-- 
tejun

--------------020802050005030801070003
Content-Type: text/x-patch;
 name="nodev-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nodev-debug.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 072ba5e..876ede2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3770,6 +3770,7 @@ int sata_link_resume(struct ata_link *link, const unsigned long *params,
 
 	scontrol = (scontrol & 0x0f0) | 0x300;
 
+	ata_link_printk(link, KERN_INFO, "XXX bringing up link\n");
 	if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
 		return rc;
 
@@ -3778,7 +3779,9 @@ int sata_link_resume(struct ata_link *link, const unsigned long *params,
 	 */
 	msleep(200);
 
-	if ((rc = sata_link_debounce(link, params, deadline)))
+	rc = sata_link_debounce(link, params, deadline);
+	ata_link_printk(link, KERN_INFO, "XXX debounced rc=%d\n", rc);
+	if (rc)
 		return rc;
 
 	/* clear SError, some PHYs require this even for SRST to work */
@@ -3904,8 +3907,10 @@ int sata_link_hardreset(struct ata_link *link, const unsigned long *timing,
 	if (rc)
 		goto out;
 	/* if link is offline nothing more to do */
-	if (ata_phys_link_offline(link))
+	if (ata_phys_link_offline(link)) {
+		ata_link_printk(link, KERN_INFO, "XXX phys link offline\n");
 		goto out;
+	}
 
 	/* Link is online.  From this point, -ENODEV too is an error. */
 	if (online)
@@ -6060,7 +6065,7 @@ static void async_port_probe(void *data, async_cookie_t cookie)
 
 		ehi->probe_mask |= ATA_ALL_DEVICES;
 		ehi->action |= ATA_EH_RESET | ATA_EH_LPM;
-		ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
+		ehi->flags |= ATA_EHI_NO_AUTOPSY/* | ATA_EHI_QUIET*/;
 
 		ap->pflags &= ~ATA_PFLAG_INITIALIZING;
 		ap->pflags |= ATA_PFLAG_LOADING;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index bbbb1fa..c718d12 100644
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

--------------020802050005030801070003--
