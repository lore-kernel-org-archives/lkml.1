Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYEaKmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYEaKmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 06:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYEaKly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 06:41:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:38327 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbYEaKlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 06:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=ERts1IpzKcWVnE+/IGRYSFJXgYGsB8/BoMyIVhXGvAY2X6Z7zGn80uTNCSitMJvqyGiFfWyyZL9vZj6HWNTLRasg3tLHaevjkn/zfYv26wWopHOU8RIs/VHRQjssCQuEwiB8MmHOGHVc2cBq/PXJOFj+PachWrySgjk5l/IVNFs=
From: Bryan Wu <cooloney@kernel.org>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] PCMCIA : add support the CF PCMCIA driver for Blackfin fixing (-mm)
Date: Sat, 31 May 2008 18:41:47 +0800
Message-Id: <1212230507-22833-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

 - Use MODULE_AUTHOR
 - Use __devinit
 - Fix printk message
 - Use device prints

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/pcmcia/bfin_cf_pcmcia.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/pcmcia/bfin_cf_pcmcia.c b/drivers/pcmcia/bfin_cf_pcmcia.c
index de517cb..b836e1f 100644
--- a/drivers/pcmcia/bfin_cf_pcmcia.c
+++ b/drivers/pcmcia/bfin_cf_pcmcia.c
@@ -1,6 +1,5 @@
 /*
  * file: drivers/pcmcia/bfin_cf.c
- * author: Michael Hennerich (hennerich@blackfin.uclinux.org)
  *
  * based on: drivers/pcmcia/omap_cf.c
  * omap_cf.c -- OMAP 16xx CompactFlash controller driver
@@ -93,7 +92,7 @@ static void bfin_cf_timer(unsigned long _cf)
 
 	if (present != cf->present) {
 		cf->present = present;
-		pr_debug("%s: card %s\n", driver_name,
+		dev_dbg(&cf->pdev->dev, ": card %s\n",
 			 present ? "present" : "gone");
 		pcmcia_parse_events(&cf->socket, SS_DETECT);
 	}
@@ -144,15 +143,14 @@ bfin_cf_set_socket(struct pcmcia_socket *sock, struct socket_state_t *s)
 		enable_irq(cf->irq);
 	}
 
-	pr_debug("%s: Vcc %d, io_irq %d, flags %04x csc %04x\n",
-		 driver_name, s->Vcc, s->io_irq, s->flags, s->csc_mask);
+	dev_dbg(&cf->pdev->dev, ": Vcc %d, io_irq %d, flags %04x csc %04x\n",
+		 s->Vcc, s->io_irq, s->flags, s->csc_mask);
 
 	return 0;
 }
 
 static int bfin_cf_ss_suspend(struct pcmcia_socket *s)
 {
-	pr_debug("%s: %s\n", driver_name, __func__);
 	return bfin_cf_set_socket(s, &dead_socket);
 }
 
@@ -196,7 +194,7 @@ static struct pccard_operations bfin_cf_ops = {
 
 /*--------------------------------------------------------------------------*/
 
-static int __init bfin_cf_probe(struct platform_device *pdev)
+static int __devinit bfin_cf_probe(struct platform_device *pdev)
 {
 	struct bfin_cf_socket *cf;
 	struct resource *io_mem, *attr_mem;
@@ -204,27 +202,27 @@ static int __init bfin_cf_probe(struct platform_device *pdev)
 	unsigned short cd_pfx;
 	int status = 0;
 
-	printk(KERN_INFO "Blackfin CompactFlash/PCMCIA Socket Driver\n");
+	dev_info(&pdev->dev, "Blackfin CompactFlash/PCMCIA Socket Driver\n");
 
 	irq = platform_get_irq(pdev, 0);
 	if (!irq)
 		return -EINVAL;
 
 	cd_pfx = platform_get_irq(pdev, 1);	/*Card Detect GPIO PIN */
-	if (cd_pfx > MAX_BLACKFIN_GPIOS)
-		return -EINVAL;
 
 	if (gpio_request(cd_pfx, "pcmcia: CD")) {
-		printk(KERN_ERR
-		       "BF5xx flash: Failed ro request Card Detect GPIO_%d\n",
+		dev_err(&pdev->dev, 
+		       "Failed ro request Card Detect GPIO_%d\n",
 		       cd_pfx);
 		return -EBUSY;
 	}
 	gpio_direction_input(cd_pfx);
 
 	cf = kzalloc(sizeof *cf, GFP_KERNEL);
-	if (!cf)
+	if (!cf) {
+		gpio_free(cd_pfx);
 		return -ENOMEM;
+	}
 
 	cf->cd_pfx = cd_pfx;
 
@@ -254,9 +252,9 @@ static int __init bfin_cf_probe(struct platform_device *pdev)
 	if (!cf->socket.io_offset)
 		goto fail0;
 
-	pr_info("%s: on irq %d\n", driver_name, irq);
+	dev_err(&pdev->dev, ": on irq %d\n", irq);
 
-	pr_debug("%s: %s\n", driver_name,
+	dev_dbg(&pdev->dev, ": %s\n",
 		 bfin_cf_present(cf->cd_pfx) ? "present" : "(not present)");
 
 	cf->socket.owner = THIS_MODULE;
@@ -280,6 +278,7 @@ fail2:
 	release_mem_region(cf->phys_cf_io, SZ_8K);
 
 fail0:
+	gpio_free(cf->cd_pfx);
 	kfree(cf);
 	platform_set_drvdata(pdev, NULL);
 
@@ -335,5 +334,6 @@ static void __exit bfin_cf_exit(void)
 module_init(bfin_cf_init);
 module_exit(bfin_cf_exit);
 
+MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>")
 MODULE_DESCRIPTION("BFIN CF/PCMCIA Driver");
 MODULE_LICENSE("GPL");
-- 
1.5.5

