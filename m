Return-Path: <linux-kernel-owner+w=401wt.eu-S1758371AbZCMOvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbZCMOvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 10:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbZCMOvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 10:51:05 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:47894 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbZCMOvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 10:51:04 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-net@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>,
       Ben Dooks <ben@simtec.co.uk>
Subject: [PATCH] drivers/net/ax88796.c: take IRQ flags from platform_device
Date: Fri, 13 Mar 2009 15:50:51 +0100
Message-Id: <1236955851-14763-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to the ax88796 ethernet driver to take IRQ flags
given by the platform_device definition.

The patch depends on the platform_get_irq_flags() function which I added
in a patch posted here:

	http://lkml.org/lkml/2009/3/13/267

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Ben Dooks <ben@simtec.co.uk>
---
 drivers/net/ax88796.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ax88796.c b/drivers/net/ax88796.c
index a4eb6c4..728e17c 100644
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
 
@@ -856,6 +858,7 @@ static int ax_probe(struct platform_device *pdev)
 		goto exit_mem;
 	}
 	dev->irq = ret;
+	ax->irqflags = platform_get_irq_flags(pdev, 0);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
-- 
1.6.2

