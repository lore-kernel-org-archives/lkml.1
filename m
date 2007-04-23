Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbXDWN7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbXDWN7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbXDWN7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:59:49 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58432 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753689AbXDWN7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:59:48 -0400
Date: Mon, 23 Apr 2007 15:03:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] plan-b: Switch to refcounting PCI API
Message-ID: <20070423150319.5b685e7e@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/drivers/media/video/planb.c linux-2.6.21-rc6-mm1/drivers/media/video/planb.c
--- linux.vanilla-2.6.21-rc6-mm1/drivers/media/video/planb.c	2007-04-12 13:40:33.000000000 +0100
+++ linux-2.6.21-rc6-mm1/drivers/media/video/planb.c	2007-04-23 12:00:54.286385088 +0100
@@ -2207,7 +2207,7 @@
 		"membase 0x%x (base reg. 0x%x)\n",
 		bus, PCI_SLOT(dev_fn), PCI_FUNC(dev_fn), old_base, confreg);
 
-	pdev = pci_find_slot (bus, dev_fn);
+	pdev = pci_get_bus_and_slot(bus, dev_fn);
 	if (!pdev) {
 		printk(KERN_ERR "planb: cannot find slot\n");
 		goto err_out;
@@ -2237,6 +2237,7 @@
 	pb->planb_base = planb_regs;
 	pb->planb_base_phys = (struct planb_registers *)new_base;
 	pb->irq	= irq;
+	pb->dev = pdev;
 
 	return planb_num;
 
@@ -2244,6 +2245,7 @@
 	pci_disable_device(pdev);
 err_out:
 	/* FIXME handle error */   /* comment moved from pci_find_slot, above */
+	pci_dev_put(pdev);
 	return 0;
 }
 
@@ -2270,6 +2272,8 @@
 
 		printk(KERN_INFO "PlanB: unregistering with v4l\n");
 		video_unregister_device(&pb->video_dev);
+		
+		pci_dev_put(pb->dev);
 
 		/* note that iounmap() does nothing on the PPC right now */
 		iounmap ((void *)pb->planb_base);
