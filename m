Return-Path: <linux-kernel-owner+w=401wt.eu-S934086AbXCTXiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086AbXCTXiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 19:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934090AbXCTXiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 19:38:11 -0400
Received: from xyzzy.farnsworth.org ([65.39.95.219]:3940 "HELO farnsworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934089AbXCTXiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 19:38:09 -0400
From: "Dale Farnsworth" <dale@farnsworth.org>
Date: Tue, 20 Mar 2007 16:38:04 -0700
To: Jeff Garzik <jgarzik@pobox.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mv643xx_eth: add mv643xx_eth_shutdown function
Message-ID: <20070320233801.GA24374@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dale Farnsworth <dale@farnsworth.org>

mv643xx_eth_shutdown is needed for kexec.

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>

---
 drivers/net/mv643xx_eth.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6-powerpc-df/drivers/net/mv643xx_eth.c
===================================================================
--- linux-2.6-powerpc-df.orig/drivers/net/mv643xx_eth.c
+++ linux-2.6-powerpc-df/drivers/net/mv643xx_eth.c
@@ -1516,9 +1516,23 @@ static int mv643xx_eth_shared_remove(str
 	return 0;
 }
 
+static void mv643xx_eth_shutdown(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+	struct mv643xx_private *mp = netdev_priv(dev);
+	unsigned int port_num = mp->port_num;
+
+	/* Mask all interrupts on ethernet port */
+	mv_write(MV643XX_ETH_INTERRUPT_MASK_REG(port_num), 0);
+	mv_read (MV643XX_ETH_INTERRUPT_MASK_REG(port_num));
+
+	eth_port_reset(port_num);
+}
+
 static struct platform_driver mv643xx_eth_driver = {
 	.probe = mv643xx_eth_probe,
 	.remove = mv643xx_eth_remove,
+	.shutdown = mv643xx_eth_shutdown,
 	.driver = {
 		.name = MV643XX_ETH_NAME,
 	},
