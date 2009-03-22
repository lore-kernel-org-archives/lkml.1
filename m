Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZCVQNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZCVQNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 12:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbZCVQNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 12:13:11 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:36453 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbZCVQNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 12:13:08 -0400
From: Daniel Mack <daniel@caiaq.de>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>,
       Ben Dooks <ben@simtec.co.uk>, David Miller <davem@davemloft.net>
Subject: [PATCH 1/2] drivers/net/ax88796.c: take IRQ flags from platform_device
Date: Sun, 22 Mar 2009 17:12:40 +0100
Message-Id: <1237738361-10184-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to the ax88796 ethernet driver to take IRQ flags
given by the platform_device definition.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: David Miller <davem@davemloft.net>
---
 drivers/net/ax88796.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ax88796.c b/drivers/net/ax88796.c
index a4eb6c4..e7c9748 100644
--- a/drivers/net/ax88796.c
+++ b/drivers/net/ax88796.c
@@ -93,6 +93,7 @@ struct ax_device {
 
 	unsigned char		 running;
 	unsigned char		 resume_open;
+	unsigned int		 irqflags;
 
 	u32			 reg_offsets[0x20];
 };
@@ -474,7 +475,8 @@ static int ax_open(struct net_device *dev)
 
 	dev_dbg(&ax->dev->dev, "%s: open\n", dev->name);
 
-	ret = request_irq(dev->irq, ax_ei_interrupt, 0, dev->name, dev);
+	ret = request_irq(dev->irq, ax_ei_interrupt, ax->irqflags,
+			  dev->name, dev);
 	if (ret)
 		return ret;
 
@@ -829,7 +831,7 @@ static int ax_probe(struct platform_device *pdev)
 	struct ax_device  *ax;
 	struct resource   *res;
 	size_t size;
-	int ret;
+	int ret = 0;
 
 	dev = ax__alloc_ei_netdev(sizeof(struct ax_device));
 	if (dev == NULL)
@@ -850,12 +852,14 @@ static int ax_probe(struct platform_device *pdev)
 
 	/* find the platform resources */
 
-	ret  = platform_get_irq(pdev, 0);
-	if (ret < 0) {
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
 		dev_err(&pdev->dev, "no IRQ specified\n");
 		goto exit_mem;
 	}
-	dev->irq = ret;
+
+	dev->irq = res->start;
+	ax->irqflags = res->flags & IRQF_TRIGGER_MASK;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
-- 
1.6.2

