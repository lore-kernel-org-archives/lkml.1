Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbXBZQKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbXBZQKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbXBZQKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:10:09 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:34706 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbXBZQKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:10:07 -0500
To: linux-kernel@vger.kernel.org
CC: linux-pcmcia@lists.infradead.org, devel@openvz.org
From: Monakhov Dmitriy <dmonakhov@openvz.org>
Subject: [PATCH 2/3] pcmcia:  Handle request_irq() failure while opening device
Date: Mon, 26 Feb 2007 19:09:17 +0300
Message-ID: <87zm70q4sy.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [194.85.82.65]); Mon, 26 Feb 2007 19:08:57 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
---
 drivers/net/pcmcia/axnet_cs.c |    8 +++++++-
 drivers/net/pcmcia/pcnet_cs.c |    8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcmcia/axnet_cs.c b/drivers/net/pcmcia/axnet_cs.c
index 6139048..9b57bab 100644
--- a/drivers/net/pcmcia/axnet_cs.c
+++ b/drivers/net/pcmcia/axnet_cs.c
@@ -523,6 +523,7 @@ static int axnet_open(struct net_device *dev)
 {
     axnet_dev_t *info = PRIV(dev);
     struct pcmcia_device *link = info->p_dev;
+    int err = 0;
     
     DEBUG(2, "axnet_open('%s')\n", dev->name);
 
@@ -531,7 +532,12 @@ static int axnet_open(struct net_device *dev)
 
     link->open++;
 
-    request_irq(dev->irq, ei_irq_wrapper, IRQF_SHARED, "axnet_cs", dev);
+    err = request_irq(dev->irq, ei_irq_wrapper, IRQF_SHARED, "axnet_cs", dev);
+    if (err) {
+		printk("axnet_cs: request_irq() failed  %s\n", dev->name);
+		link->open--;
+		return -EBUSY;
+    }
 
     info->link_status = 0x00;
     init_timer(&info->watchdog);
diff --git a/drivers/net/pcmcia/pcnet_cs.c b/drivers/net/pcmcia/pcnet_cs.c
index d88e9b2..13923ea 100644
--- a/drivers/net/pcmcia/pcnet_cs.c
+++ b/drivers/net/pcmcia/pcnet_cs.c
@@ -962,6 +962,7 @@ static int pcnet_open(struct net_device *dev)
 {
     pcnet_dev_t *info = PRIV(dev);
     struct pcmcia_device *link = info->p_dev;
+    int err = 0;
 
     DEBUG(2, "pcnet_open('%s')\n", dev->name);
 
@@ -971,7 +972,12 @@ static int pcnet_open(struct net_device *dev)
     link->open++;
 
     set_misc_reg(dev);
-    request_irq(dev->irq, ei_irq_wrapper, IRQF_SHARED, dev_info, dev);
+    err = request_irq(dev->irq, ei_irq_wrapper, IRQF_SHARED, dev_info, dev);
+    if (err) {
+		printk("pcnet_open: request_irq() failed  %s\n", dev->name);
+		link->open--;
+		return -EBUSY;
+    }
 
     info->phy_id = info->eth_phy;
     info->link_status = 0x00;
-- 
1.5.0.1


