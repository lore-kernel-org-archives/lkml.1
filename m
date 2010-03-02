Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab0CBS3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:29:48 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:38731 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754240Ab0CBS3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:29:36 -0500
Date: Tue, 2 Mar 2010 21:29:35 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@redhat.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] ahci: Get rid of pci_dev argument in ahci_port_init()
Message-ID: <20100302182935.GF3445@oksana.dev.rtsoft.ru>
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make the function bus-independand we have to get rid of
"struct pci_dev *", so let's pass just "struct devce *".

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/ata/ahci.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index c46a064..1afb35e 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1613,7 +1613,7 @@ static ssize_t ahci_activity_show(struct ata_device *dev, char *buf)
 	return sprintf(buf, "%d\n", emp->blink_policy);
 }
 
-static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
+static void ahci_port_init(struct device *dev, struct ata_port *ap,
 			   int port_no, void __iomem *mmio,
 			   void __iomem *port_mmio)
 {
@@ -1624,8 +1624,7 @@ static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
 	/* make sure port is not active */
 	rc = ahci_deinit_port(ap, &emsg);
 	if (rc)
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "%s (%d)\n", emsg, rc);
+		dev_warn(dev, "%s (%d)\n", emsg, rc);
 
 	/* clear SError */
 	tmp = readl(port_mmio + PORT_SCR_ERR);
@@ -1674,7 +1673,7 @@ static void ahci_init_controller(struct ata_host *host)
 		if (ata_port_is_dummy(ap))
 			continue;
 
-		ahci_port_init(pdev, ap, i, mmio, port_mmio);
+		ahci_port_init(host->dev, ap, i, mmio, port_mmio);
 	}
 
 	tmp = readl(mmio + HOST_CTL);
-- 
1.7.0

