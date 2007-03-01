Return-Path: <linux-kernel-owner+w=401wt.eu-S965337AbXCAQdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965337AbXCAQdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965341AbXCAQdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:33:14 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53459 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965337AbXCAQdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:33:12 -0500
Date: Thu, 1 Mar 2007 17:36:46 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@osdl.org,
       torvalds@osdl.org, jgarzik@pobox.com
Subject: [PATCH] libata-core: Fix simplex handling
Message-ID: <20070301173646.4138981b@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The initial simplex handling code is fooled if you suspend and resume.
This also causes problems with some single channel controllers which
claim to be simplex.

The fix is fairly simple, instead of keeping a flag to remember if we
gave away the simplex channel we remember the actual owner. As the owner
is always part of the host_set we don't even need a refcount.

Knowing the owner also means we can reassign simplex DMA channels in
future hotplug code etc if we need to

Signed-off-by: Alan Cox <alan@redhat.com>
(and a signed-off for the patch I sent before while I remember)

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/libata-core.c linux-2.6.21-rc2/drivers/ata/libata-core.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/libata-core.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/libata-core.c	2007-03-01 15:49:21.853448880 +0000
@@ -2556,12 +2622,11 @@
 	 * host channels are not permitted to do so.
 	 */
 	if (used_dma && (ap->host->flags & ATA_HOST_SIMPLEX))
-		ap->host->simplex_claimed = 1;
+		ap->host->simplex_claimed = ap;
 
 	/* step5: chip specific finalisation */
 	if (ap->ops->post_set_mode)
 		ap->ops->post_set_mode(ap);
-
  out:
 	if (rc)
 		*r_failed_dev = dev;
@@ -3442,7 +3507,7 @@
 			       "device is on DMA blacklist, disabling DMA\n");
 	}
 
-	if ((host->flags & ATA_HOST_SIMPLEX) && host->simplex_claimed) {
+	if ((host->flags & ATA_HOST_SIMPLEX) && host->simplex_claimed != ap) {
 		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
 		ata_dev_printk(dev, KERN_WARNING, "simplex DMA is claimed by "
 			       "other device, disabling DMA\n");
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/include/linux/libata.h linux-2.6.21-rc2/include/linux/libata.h
--- linux.vanilla-2.6.21-rc2/include/linux/libata.h	2007-03-01 13:36:13.000000000 +0000
+++ linux-2.6.21-rc2/include/linux/libata.h	2007-03-01 14:27:53.363612296 +0000
@@ -403,8 +403,7 @@
 	void			*private_data;
 	const struct ata_port_operations *ops;
 	unsigned long		flags;
-	int			simplex_claimed;	/* Keep seperate in case we
-							   ever need to do this locked */
+	struct ata_port		*simplex_claimed;	/* channel owning the DMA */
 	struct ata_port		*ports[0];
 };
 
