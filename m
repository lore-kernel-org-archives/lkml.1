Return-Path: <linux-kernel-owner+w=401wt.eu-S1761859AbZJIXUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761859AbZJIXUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761641AbZJIXUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:20:17 -0400
Received: from kroah.org ([198.145.64.141]:36854 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761640AbZJIXR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:01 2009
Message-Id: <20091009231001.785034123@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 13/26] libata: fix incorrect link online check during probe
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=libata-fix-incorrect-link-online-check-during-probe.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <tj@kernel.org>

commit 3b761d3d437cffcaf160a5d37eb6b3b186e491d5 upstream.

While trying to work around spurious detection retries for
non-existent devices on slave links, commit
816ab89782ac139a8b65147cca990822bb7e8675 incorrectly added link
offline check logic before ata_eh_thaw() was called.  This means that
if an occupied link goes down briefly at the time that offline check
was performed, device class will be cleared to ATA_DEV_NONE and libata
wouldn't retry thus failing detection of the device.

The offline check should be done after the port is thawed together
with online check so that such link glitches can be detected by the
interrupt handler and handled properly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Tim Blechmann <tim@klingt.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |   50 ++++++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 18 deletions(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
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


