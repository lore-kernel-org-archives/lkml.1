Return-Path: <linux-kernel-owner+w=401wt.eu-S965645AbXDVKf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965645AbXDVKf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 06:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030181AbXDVKf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 06:35:29 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:44185 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965646AbXDVKf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 06:35:28 -0400
Date: Sun, 22 Apr 2007 12:35:24 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] do not truncate irq number for icom adapter
Message-ID: <20070422103524.GA20513@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


irq values are u32, not u8. Large irq numbers will be truncated,
free_irq may free a different irq.
Remove incorrectly sized struct member and use the one from pci_dev.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 drivers/serial/icom.c |    5 ++---
 drivers/serial/icom.h |    1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -1473,7 +1473,7 @@ static void icom_remove_adapter(struct i
 		}
 	}
 
-	free_irq(icom_adapter->irq_number, (void *) icom_adapter);
+	free_irq(icom_adapter->pci_dev->irq, (void *) icom_adapter);
 	iounmap(icom_adapter->base_addr);
 	icom_free_adapter(icom_adapter);
 	pci_release_regions(icom_adapter->pci_dev);
@@ -1539,7 +1539,6 @@ static int __devinit icom_probe(struct p
 	}
 
 	 icom_adapter->base_addr_pci = pci_resource_start(dev, 0);
-	 icom_adapter->irq_number = dev->irq;
 	 icom_adapter->pci_dev = dev;
 	 icom_adapter->version = ent->driver_data;
 	 icom_adapter->subsystem_id = ent->subdevice;
@@ -1570,7 +1569,7 @@ static int __devinit icom_probe(struct p
 		icom_port = &icom_adapter->port_info[index];
 
 		if (icom_port->status == ICOM_PORT_ACTIVE) {
-			icom_port->uart_port.irq = icom_port->adapter->irq_number;
+			icom_port->uart_port.irq = icom_port->adapter->pci_dev->irq;
 			icom_port->uart_port.type = PORT_ICOM;
 			icom_port->uart_port.iotype = UPIO_MEM;
 			icom_port->uart_port.membase =
--- a/drivers/serial/icom.h
+++ b/drivers/serial/icom.h
@@ -258,7 +258,6 @@ struct icom_port {
 struct icom_adapter {
 	void __iomem * base_addr;
 	unsigned long base_addr_pci;
-	unsigned char irq_number;
 	struct pci_dev *pci_dev;
 	struct icom_port port_info[4];
 	int index;
