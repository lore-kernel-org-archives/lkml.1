Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbZIPMAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbZIPMAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbZIPMAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:00:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:35854 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbZIPMAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:00:14 -0400
Message-ID: <4AB0D34A.2010502@kernel.org>
Date: Wed, 16 Sep 2009 21:00:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.31-rc5 regression: hd don't show up
References: <h63737$b2a$1@ger.gmane.org> <4A852BC0.1090404@kernel.org> <4A8559D7.6090405@klingt.org> <4A8774E5.4070609@kernel.org> <4A87D9FC.9070408@klingt.org> <4A96460F.3020600@kernel.org> <4A965E3B.3000808@klingt.org> <4A966F7D.60707@kernel.org> <4A97B9C0.9090003@klingt.org> <4A9B7E1E.8060909@kernel.org> <4A9DAF78.4070703@klingt.org> <4A9DD6D9.50407@kernel.org> <4A9E371A.5040208@klingt.org> <4A9FCD8C.6010107@kernel.org> <4AA18F57.8030107@klingt.org> <4AA1ACF8.7030101@kernel.org> <4AA6C569.9090901@klingt.org> <4AB04B39.7030907@kernel.org> <4AB079FC.6000906@kernel.org> <4AB09562.3010501@klingt.org>
In-Reply-To: <4AB09562.3010501@klingt.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------090500010605060402010303"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 12:00:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090500010605060402010303
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Tim Blechmann wrote:
>> Can you please try the attached patch and report the result?  The bug
>> shouldn't happen now and for cases where it would have happened,
>> libata will report "link online but device misclassified" and retry.
> 
> this patch cannot be applied onto stable-2.6.31/master ... e.g. the
> first chunk is already in there ....

Eh... the first chunk was for the current devel branch.  Here's a
version without that one.

Thanks.

-- 
tejun

--------------090500010605060402010303
Content-Type: text/x-patch;
 name="fix-link-onoffline-handling.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-link-onoffline-handling.patch"

---
 drivers/ata/libata-eh.c |   50 ++++++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 18 deletions(-)

Index: tree0/drivers/ata/libata-eh.c
===================================================================
--- tree0.orig/drivers/ata/libata-eh.c
+++ tree0/drivers/ata/libata-eh.c
@@ -2541,14 +2541,14 @@ int ata_eh_reset(struct ata_link *link,
 		dev->pio_mode = XFER_PIO_0;
 		dev->flags &= ~ATA_DFLAG_SLEEPING;
 
-		if (!ata_phys_link_offline(ata_dev_phys_link(dev))) {
-			/* apply class override */
-			if (lflags & ATA_LFLAG_ASSUME_ATA)
-				classes[dev->devno] = ATA_DEV_ATA;
-			else if (lflags & ATA_LFLAG_ASSUME_SEMB)
-				classes[dev->devno] = ATA_DEV_SEMB_UNSUP;
-		} else
-			classes[dev->devno] = ATA_DEV_NONE;
+		if (ata_phys_link_offline(ata_dev_phys_link(dev)))
+			continue;
+
+		/* apply class override */
+		if (lflags & ATA_LFLAG_ASSUME_ATA)
+			classes[dev->devno] = ATA_DEV_ATA;
+		else if (lflags & ATA_LFLAG_ASSUME_SEMB)
+			classes[dev->devno] = ATA_DEV_SEMB_UNSUP;
 	}
 
 	/* record current link speed */
@@ -2581,34 +2581,48 @@ int ata_eh_reset(struct ata_link *link,
 		slave->eh_info.serror = 0;
 	spin_unlock_irqrestore(link->ap->lock, flags);
 
-	/* Make sure onlineness and classification result correspond.
+	/*
+	 * Make sure onlineness and classification result correspond.
 	 * Hotplug could have happened during reset and some
 	 * controllers fail to wait while a drive is spinning up after
 	 * being hotplugged causing misdetection.  By cross checking
-	 * link onlineness and classification result, those conditions
-	 * can be reliably detected and retried.
+	 * link on/offlineness and classification result, those
+	 * conditions can be reliably detected and retried.
 	 */
 	nr_unknown = 0;
 	ata_for_each_dev(dev, link, ALL) {
-		/* convert all ATA_DEV_UNKNOWN to ATA_DEV_NONE */
-		if (classes[dev->devno] == ATA_DEV_UNKNOWN) {
-			classes[dev->devno] = ATA_DEV_NONE;
-			if (ata_phys_link_online(ata_dev_phys_link(dev)))
+		if (ata_phys_link_online(ata_dev_phys_link(dev))) {
+			if (classes[dev->devno] == ATA_DEV_UNKNOWN) {
+				ata_dev_printk(dev, KERN_DEBUG, "link online "
+					       "but device misclassifed\n");
+				classes[dev->devno] = ATA_DEV_NONE;
 				nr_unknown++;
+			}
+		} else if (ata_phys_link_offline(ata_dev_phys_link(dev))) {
+			if (ata_class_enabled(classes[dev->devno]))
+				ata_dev_printk(dev, KERN_DEBUG, "link offline, "
+					       "clearing class %d to NONE\n",
+					       classes[dev->devno]);
+			classes[dev->devno] = ATA_DEV_NONE;
+		} else if (classes[dev->devno] == ATA_DEV_UNKNOWN) {
+			ata_dev_printk(dev, KERN_DEBUG, "link status unknown, "
+				       "clearing UNKNOWN to NONE\n");
+			classes[dev->devno] = ATA_DEV_NONE;
 		}
 	}
 
 	if (classify && nr_unknown) {
 		if (try < max_tries) {
 			ata_link_printk(link, KERN_WARNING, "link online but "
-				       "device misclassified, retrying\n");
+					"%d devices misclassified, retrying\n",
+					nr_unknown);
 			failed_link = link;
 			rc = -EAGAIN;
 			goto fail;
 		}
 		ata_link_printk(link, KERN_WARNING,
-			       "link online but device misclassified, "
-			       "device detection might fail\n");
+				"link online but %d devices misclassified, "
+				"device detection might fail\n", nr_unknown);
 	}
 
 	/* reset successful, schedule revalidation */

--------------090500010605060402010303--
