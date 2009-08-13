Return-Path: <linux-kernel-owner+w=401wt.eu-S932266AbZHMUG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbZHMUG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbZHMUG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:06:56 -0400
Received: from kroah.org ([198.145.64.141]:41837 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189AbZHMT7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:49 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:31 2009
Message-Id: <20090813195131.095567787@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 44/74] ide: fix handling of unexpected IRQs vs request_irq()
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=ide-fix-handling-of-unexpected-irqs-vs-request_irq.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit ffc36c7610731115c77700dcc53901920361c235 upstream.

Add ide_host_enable_irqs() helper and use it in ide_host_register()
before registering ports.  Then remove no longer needed IRQ unmasking
from in init_irq().

This should fix the problem with "screaming" shared IRQ on the first
port (after request_irq() call while we have the unexpected IRQ pending
on the second port) which was uncovered by my rework of the serialized
interfaces support.

Reported-by: Frans Pop <elendil@planet.nl>
Tested-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-probe.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -830,6 +830,24 @@ static int ide_port_setup_devices(ide_hw
 	return j;
 }
 
+static void ide_host_enable_irqs(struct ide_host *host)
+{
+	ide_hwif_t *hwif;
+	int i;
+
+	ide_host_for_each_port(i, hwif, host) {
+		if (hwif == NULL)
+			continue;
+
+		/* clear any pending IRQs */
+		hwif->tp_ops->read_status(hwif);
+
+		/* unmask IRQs */
+		if (hwif->io_ports.ctl_addr)
+			hwif->tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
+	}
+}
+
 /*
  * This routine sets up the IRQ for an IDE interface.
  */
@@ -843,9 +861,6 @@ static int init_irq (ide_hwif_t *hwif)
 	if (irq_handler == NULL)
 		irq_handler = ide_intr;
 
-	if (io_ports->ctl_addr)
-		hwif->tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
-
 	if (request_irq(hwif->irq, irq_handler, sa, hwif->name, hwif))
 		goto out_up;
 
@@ -1389,6 +1404,8 @@ int ide_host_register(struct ide_host *h
 			ide_port_tune_devices(hwif);
 	}
 
+	ide_host_enable_irqs(host);
+
 	ide_host_for_each_port(i, hwif, host) {
 		if (hwif == NULL)
 			continue;


