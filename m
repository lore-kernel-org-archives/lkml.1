Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab0CCRT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:19:29 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:37338 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753926Ab0CCRRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:17:42 -0500
Date: Wed, 3 Mar 2010 20:17:40 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] ahci: Get rid of pci_dev argument in ahci_port_init()
Message-ID: <20100303171740.GE12362@oksana.dev.rtsoft.ru>
References: <20100303171713.GA6322@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100303171713.GA6322@oksana.dev.rtsoft.ru>
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
index 830a6fe..b646364 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1638,7 +1638,7 @@ static ssize_t ahci_activity_show(struct ata_device *dev, char *buf)
 	return sprintf(buf, "%d\n", emp->blink_policy);
 }
 
-static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
+static void ahci_port_init(struct device *dev, struct ata_port *ap,
 			   int port_no, void __iomem *mmio,
 			   void __iomem *port_mmio)
 {
@@ -1649,8 +1649,7 @@ static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
 	/* make sure port is not active */
 	rc = ahci_deinit_port(ap, &emsg);
 	if (rc)
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "%s (%d)\n", emsg, rc);
+		dev_warn(dev, "%s (%d)\n", emsg, rc);
 
 	/* clear SError */
 	tmp = readl(port_mmio + PORT_SCR_ERR);
@@ -1699,7 +1698,7 @@ static void ahci_init_controller(struct ata_host *host)
 		if (ata_port_is_dummy(ap))
 			continue;
 
-		ahci_port_init(pdev, ap, i, mmio, port_mmio);
+		ahci_port_init(host->dev, ap, i, mmio, port_mmio);
 	}
 
 	tmp = readl(mmio + HOST_CTL);
-- 
1.7.0

