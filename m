Return-Path: <linux-kernel-owner+w=401wt.eu-S932528AbXA1KeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbXA1KeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 05:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932526AbXA1KeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 05:34:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:64882 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523AbXA1KeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 05:34:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: jgarzik@pobox.com
Subject: [PATCH] libata: add a dummy set_mode() in pata_pcmcia
Date: Sun, 28 Jan 2007 11:34:01 +0100
User-Agent: KMail/1.9.5
Cc: wkl@informatik.uni-kiel.de, alan@lxorguk.ukuu.org.uk,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701281134.02218.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1+Tyep176GCLE+WjQAVmeKzJlOORRd55/OVlEUGhZG1sp55Tn+Lk0GKfQm9LwDj90AQAhMUSLE02+WJaVY2cFxCCUbu35mB+ErqAXSJg1angA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CompactFlash cards in a passive PCMCIA adapter don't seem
to like the ATA_CMD_SET_FEATURES command, which causes
libata device probing to fail.

Since PCMCIA only allows PIO mode 0 anyway, there is no
point in ever setting a higher speed. Adding the dummy
function seems to do the right thing.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---

This bug was reported earlier in 
http://bugzilla.kernel.org/show_bug.cgi?id=7711 by 
wkl@informatik.uni-kiel.de.

I have not been able to find out _why_ all my CF cards reject
the SETFEATURES_XFER command, but I have verified that the
same happens when trying to use hdparm with ide_cs.

Note that none of my cards are CF-4.0 compliant, so they
also don't do UDMA modes. The highest mode claimed to be
supported by one of my cards is PIO-4, but I can't set
it into any of the modes it likes.

diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 9ed7f58..642753c 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -44,6 +44,30 @@
 #define DRV_NAME "pata_pcmcia"
 #define DRV_VERSION "0.2.11"
 
+/**
+ *	legacy_set_mode		-	mode setting
+ *	@ap: IDE interface
+ *
+ *	Use a non standard set_mode function. We don't want to be tuned.
+ *
+ *	PCMCIA support only PIO0 transfers and cards may return an error
+ *	if you attempt to set that explicitly.
+ */
+
+static void pcmcia_set_mode(struct ata_port *ap)
+{
+	int i;
+
+	for (i = 0; i < ATA_MAX_DEVICES; i++) {
+		struct ata_device *dev = &ap->device[i];
+		if (ata_dev_enabled(dev)) {
+			dev->pio_mode = XFER_PIO_0;
+			dev->xfer_mode = XFER_PIO_0;
+			dev->xfer_shift = ATA_SHIFT_PIO;
+			dev->flags |= ATA_DFLAG_PIO;
+		}
+	}
+}
 /*
  *	Private data structure to glue stuff together
  */
@@ -79,6 +103,7 @@ static struct ata_port_operations pcmcia_port_ops = {
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
+	.set_mode	= pcmcia_set_mode,
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
