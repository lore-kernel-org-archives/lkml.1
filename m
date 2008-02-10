Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbYBJTz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbYBJTz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYBJTzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:55:13 -0500
Received: from ns.suse.de ([195.135.220.2]:35988 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbYBJTzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:55:11 -0500
Date: Sun, 10 Feb 2008 20:55:56 +0100
From: Holger Macht <hmacht@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, htejun@gmail.com, alan@redhat.com,
       jeff@garzik.org
Subject: [PATCH] libata: Forcing PIO0 mode on reset must not freeze system
Message-ID: <20080210195556.GA5261@homac>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, htejun@gmail.com, alan@redhat.com,
	jeff@garzik.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling ap->ops->set_piomode(ap, dev) on a device/controller which got
already removed, locks the system hard. Reproducibly on an X60 attached to
a dock station containing a cdrom device with doing

  $ echo 1 > /sys/devices/platform/dock.0/undock && echo 123 > /dev/sr0

This calls ata_eh_reset(...) which in turn tries to force PIO mode 0. But
the device is already gone.

Bisecting revealed the following commit as culprit:

  commit cdeab1140799f09c5f728a5ff85e0bdfa5679cd2
  Author: Tejun Heo <htejun@gmail.com>
  Date:   Mon Oct 29 16:41:09 2007 +0900
  
      libata: relocate forcing PIO0 on reset
      
      Forcing PIO0 on reset was done inside ata_bus_softreset(), which is a
      bit out of place as it should be applied to all resets - hard, soft
      and implementation which don't use ata_bus_softreset().  Relocate it
      such that...
      
      * For new EH, it's done in ata_eh_reset() before calling prereset.
      
      * For old EH, it's done before calling ap->ops->phy_reset() in
        ata_bus_probe().
      
      This makes PIO0 forced after all resets.  Another difference is that
      reset itself is done after PIO0 is forced.
      
      Signed-off-by: Tejun Heo <htejun@gmail.com>
      Acked-by: Alan Cox <alan@redhat.com>
      Signed-off-by: Jeff Garzik <jeff@garzik.org>


ATTENTION! The following patch solves the problem on my system, but please
be aware that I don't really know what I'm doing because I don't have the
big picture. There's surely a better way to check if the device/controller
is still functional than calling ata_link_{online,offline}.


Signed-off-by: Holger Macht <hmacht@suse.de>
---

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 4e31071..d6a7c57 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2131,23 +2131,25 @@ int ata_eh_reset(struct ata_link *link, int classify,
 
 	ata_eh_about_to_do(link, NULL, ehc->i.action & ATA_EH_RESET_MASK);
 
-	ata_link_for_each_dev(dev, link) {
-		/* If we issue an SRST then an ATA drive (not ATAPI)
-		 * may change configuration and be in PIO0 timing. If
-		 * we do a hard reset (or are coming from power on)
-		 * this is true for ATA or ATAPI. Until we've set a
-		 * suitable controller mode we should not touch the
-		 * bus as we may be talking too fast.
-		 */
-		dev->pio_mode = XFER_PIO_0;
+	if (ata_link_online(link) != ata_link_offline(link)) {
+		ata_link_for_each_dev(dev, link) {
+			/* If we issue an SRST then an ATA drive (not ATAPI)
+			 * may change configuration and be in PIO0 timing. If
+			 * we do a hard reset (or are coming from power on)
+			 * this is true for ATA or ATAPI. Until we've set a
+			 * suitable controller mode we should not touch the
+			 * bus as we may be talking too fast.
+			 */
+			dev->pio_mode = XFER_PIO_0;
 
-		/* If the controller has a pio mode setup function
-		 * then use it to set the chipset to rights. Don't
-		 * touch the DMA setup as that will be dealt with when
-		 * configuring devices.
-		 */
-		if (ap->ops->set_piomode)
-			ap->ops->set_piomode(ap, dev);
+			/* If the controller has a pio mode setup function
+			 * then use it to set the chipset to rights. Don't
+			 * touch the DMA setup as that will be dealt with when
+			 * configuring devices.
+			 */
+			if (ap->ops->set_piomode)
+				ap->ops->set_piomode(ap, dev);
+		}
 	}
 
 	/* Determine which reset to use and record in ehc->i.action.

