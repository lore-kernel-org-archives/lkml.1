Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYH1EMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYH1EMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 00:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbYH1EMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 00:12:33 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:36677 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYH1EMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 00:12:31 -0400
Date: Wed, 27 Aug 2008 23:11:15 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Paul Gortmaker <p_gortmaker@yahoo.com>
Subject: [PATCH] ne.c fix for hibernate and rmmod oops fix
Message-ID: <20080828041110.GA9404@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 27 Aug 2008 23:11:58 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

side notes on the patch and development:

I found it strange that ne_init was being called before ne_probe.
ne_probe is called in drivers/net/Space.c

do_ne_probe uses dev->mem_end special value 0xbad as a flag to deal
specially when some bad, but usable devices.  The io port platform
resource has a start and end, but if start is 0x300 and end is 0xbad,
it will just fail with io ports in use and not probe the device.  Is
using the flag IORESOURCE_DISABLED acceptable?  There doesn't seem to
be any good way to pass some extra driver dependent data through to
the platform probe function.

+	/* Bad, crippled, how about disabled?
+	 * Any other suggestions for passing this through?
+	 */
+	if (dev->mem_end == BAD)
+		r[0].flags |= IORESOURCE_DISABLED;

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)

commit 3e2c3988388583aac009525ec1d2803dceb7cd1b
Author: David Fries <david@fries.net>
Date:   Wed Aug 27 22:49:16 2008 -0500

    [PATCH] ne.c fix for hibernate and rmmod oops fix
    
    Removing the module would cause a kernel oops as platform_driver_probe
    failed to detect a device and unregistered the platform driver on
    module init, and cleanup_module would unregister the already
    unregistered driver.  The suspend and resume functions weren't being
    called and the network card didn't function across a suspend to disk
    followed by a power cycle.
    
    platform_driver support was added earlier, but without any
    platform_device_register* calls I don't think it was being used.  Now
    all devices are registered using platform_device_register_simple and
    pointers are kept to unregister the ones that the probe failed for or
    unregister all devices on module shutdown.  ne_init and ne_exit are no
    longer compiled into the module to reduce confusion (and multiple
    unregister paths that caused the rmmod oops).  With the devices
    now registered they are added to the platform driver and get suspend
    and resume events.  A call to pnp_stop_dev and pnp_start_dev now
    shutsdown and initializes plug and play devices.
    
    mdelay(10) replaced by msleep(10) to give up the CPU.
    
    netif_device_detach(dev) was added before unregister_netdev(dev) when
    removing the region as occationally I would see a race condition where
    the device was still being used in unregister_netdev.
    
    Signed-off-by: David Fries <david@fries.net>
    Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
    Cc: Paul Gortmaker <p_gortmaker@yahoo.com>

diff --git a/drivers/net/ne.c b/drivers/net/ne.c
index 42443d6..e8eaf5c 100644
--- a/drivers/net/ne.c
+++ b/drivers/net/ne.c
@@ -192,8 +192,13 @@ static int __init do_ne_probe(struct net_device *dev)
 #endif
 
 	/* First check any supplied i/o locations. User knows best. <cough> */
-	if (base_addr > 0x1ff)	/* Check a single specified location. */
-		return ne_probe1(dev, base_addr);
+	if (base_addr > 0x1ff) {	/* Check a single specified location. */
+		int ret = ne_probe1(dev, base_addr);
+		if (ret)
+			printk(KERN_WARNING "ne.c: No NE*000 card found at "
+				"i/o = %#lx\n", base_addr);
+		return ret;
+	}
 	else if (base_addr != 0)	/* Don't probe at all. */
 		return -ENXIO;
 
@@ -214,11 +219,47 @@ static int __init do_ne_probe(struct net_device *dev)
 	return -ENODEV;
 }
 
+#define MAX_NE_CARDS	4	/* Max number of NE cards per module */
+static struct platform_device *pdev_ne[MAX_NE_CARDS];
+/* 0xbad = bad sig or no reset ack */
+#define BAD 0xbad
+
+#ifdef MODULE
+static int io[MAX_NE_CARDS];
+static int irq[MAX_NE_CARDS];
+static int bad[MAX_NE_CARDS];
+
+module_param_array(io, int, NULL, 0);
+module_param_array(irq, int, NULL, 0);
+module_param_array(bad, int, NULL, 0);
+MODULE_PARM_DESC(io, "I/O base address(es),required");
+MODULE_PARM_DESC(irq, "IRQ number(s)");
+MODULE_PARM_DESC(bad, "Accept card(s) with bad signatures");
+MODULE_DESCRIPTION("NE1000/NE2000 ISA/PnP Ethernet driver");
+MODULE_LICENSE("GPL");
+#endif /* MODULE */
+
 #ifndef MODULE
 struct net_device * __init ne_probe(int unit)
 {
-	struct net_device *dev = alloc_eip_netdev();
-	int err;
+	struct net_device *dev;
+	struct platform_device *pdev;
+	struct resource r[2] = {
+		{
+			.name = "io_port",
+			.flags = IORESOURCE_IO},
+		{
+			.name = "irq",
+			.flags = IORESOURCE_IRQ} };
+	/* Find an empty slot. */
+	int this_dev = 0;
+	while (pdev_ne[this_dev]) {
+		if (++this_dev == MAX_NE_CARDS)
+			return ERR_PTR(-ENOMEM);
+	}
+
+	/* Get irq, io from kernel command line */
+	dev = alloc_eip_netdev();
 
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
@@ -226,13 +267,31 @@ struct net_device * __init ne_probe(int unit)
 	sprintf(dev->name, "eth%d", unit);
 	netdev_boot_setup_check(dev);
 
-	err = do_ne_probe(dev);
-	if (err)
-		goto out;
-	return dev;
-out:
+	r[0].start = dev->base_addr;
+	r[0].end = r[0].start+NE_IO_EXTENT-1;
+
+	/* Bad, crippled, how about disabled?
+	 * Any other suggestions for passing this through?
+	 */
+	if (dev->mem_end == BAD)
+		r[0].flags |= IORESOURCE_DISABLED;
+
+	r[1].start = dev->irq;
+
 	free_netdev(dev);
-	return ERR_PTR(err);
+
+	pdev = platform_device_register_simple(
+		DRV_NAME, unit, r, ARRAY_SIZE(r));
+	if (IS_ERR(pdev))
+		return ERR_CAST(pdev);
+	pdev_ne[this_dev] = pdev;
+
+	/* Why is ne_probe being called before ne_init? */
+	dev = platform_get_drvdata(pdev);
+	if (!dev)
+		return ERR_PTR(-ENODEV);
+
+	return dev;
 }
 #endif
 
@@ -329,7 +388,7 @@ static int __init ne_probe1(struct net_device *dev, unsigned long ioaddr)
 	   with an otherwise unused dev->mem_end value of "0xBAD" will
 	   cause the driver to skip these parts of the probe. */
 
-	bad_card = ((dev->base_addr != 0) && (dev->mem_end == 0xbad));
+	bad_card = ((dev->base_addr != 0) && (dev->mem_end == BAD));
 
 	/* Reset card. Who knows what dain-bramaged state it was left in. */
 
@@ -472,7 +531,7 @@ static int __init ne_probe1(struct net_device *dev, unsigned long ioaddr)
 		outb_p(0x00, ioaddr + EN0_RCNTLO);
 		outb_p(0x00, ioaddr + EN0_RCNTHI);
 		outb_p(E8390_RREAD+E8390_START, ioaddr); /* Trigger it... */
-		mdelay(10);		/* wait 10ms for interrupt to propagate */
+		msleep(10);	/* wait 10ms for interrupt to propagate */
 		outb_p(0x00, ioaddr + EN0_IMR); 		/* Mask it again. */
 		dev->irq = probe_irq_off(cookie);
 		if (ei_debug > 2)
@@ -807,18 +866,20 @@ static int __init ne_drv_probe(struct platform_device *pdev)
 {
 	struct net_device *dev;
 	struct resource *res;
-	int err, irq;
+	int err, r_irq;
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
-	irq = platform_get_irq(pdev, 0);
-	if (!res || irq < 0)
+	r_irq = platform_get_irq(pdev, 0);
+	if (!res || r_irq < 0)
 		return -ENODEV;
 
 	dev = alloc_eip_netdev();
 	if (!dev)
 		return -ENOMEM;
-	dev->irq = irq;
+	dev->irq = r_irq;
 	dev->base_addr = res->start;
+	if (res->flags & IORESOURCE_DISABLED)
+		dev->mem_end = BAD;
 	err = do_ne_probe(dev);
 	if (err) {
 		free_netdev(dev);
@@ -828,24 +889,56 @@ static int __init ne_drv_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit ne_drv_remove(struct platform_device *pdev)
+static int ne_drv_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 
-	unregister_netdev(dev);
-	free_irq(dev->irq, dev);
-	release_region(dev->base_addr, NE_IO_EXTENT);
-	free_netdev(dev);
+	if (dev) {
+		struct pnp_dev *idev = (struct pnp_dev *)ei_status.priv;
+		netif_device_detach(dev);
+		unregister_netdev(dev);
+		if (idev)
+			pnp_device_detach(idev);
+		/* Careful ne_drv_remove can be called twice, once from
+		 * the platform_driver.remove and again when the
+		 * platform_device is being removed.
+		 */
+		ei_status.priv = 0;
+		free_irq(dev->irq, dev);
+		release_region(dev->base_addr, NE_IO_EXTENT);
+		free_netdev(dev);
+		platform_set_drvdata(pdev, NULL);
+	}
 	return 0;
 }
 
+/* Remove unused devices or all if true. */
+static void ne_loop_rm_unreg(int all)
+{
+	int this_dev;
+	struct platform_device *pdev;
+	for (this_dev = 0; this_dev < MAX_NE_CARDS; this_dev++) {
+		pdev = pdev_ne[this_dev];
+		/* No network device == unused */
+		if (pdev && (!platform_get_drvdata(pdev) || all)) {
+			ne_drv_remove(pdev);
+			platform_device_unregister(pdev);
+			pdev_ne[this_dev] = NULL;
+		}
+	}
+}
+
 #ifdef CONFIG_PM
 static int ne_drv_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 
-	if (netif_running(dev))
+	if (netif_running(dev)) {
+		struct pnp_dev *idev = (struct pnp_dev *)ei_status.priv;
 		netif_device_detach(dev);
+		if (idev)
+			pnp_stop_dev(idev);
+	}
 	return 0;
 }
 
@@ -854,6 +947,9 @@ static int ne_drv_resume(struct platform_device *pdev)
 	struct net_device *dev = platform_get_drvdata(pdev);
 
 	if (netif_running(dev)) {
+		struct pnp_dev *idev = (struct pnp_dev *)ei_status.priv;
+		if (idev)
+			pnp_start_dev(idev);
 		ne_reset_8390(dev);
 		NS8390p_init(dev, 1);
 		netif_device_attach(dev);
@@ -866,7 +962,7 @@ static int ne_drv_resume(struct platform_device *pdev)
 #endif
 
 static struct platform_driver ne_driver = {
-	.remove		= __exit_p(ne_drv_remove),
+	.remove		= ne_drv_remove,
 	.suspend	= ne_drv_suspend,
 	.resume		= ne_drv_resume,
 	.driver		= {
@@ -875,31 +971,7 @@ static struct platform_driver ne_driver = {
 	},
 };
 
-static int __init ne_init(void)
-{
-	return platform_driver_probe(&ne_driver, ne_drv_probe);
-}
-
-static void __exit ne_exit(void)
-{
-	platform_driver_unregister(&ne_driver);
-}
-
 #ifdef MODULE
-#define MAX_NE_CARDS	4	/* Max number of NE cards per module */
-static struct net_device *dev_ne[MAX_NE_CARDS];
-static int io[MAX_NE_CARDS];
-static int irq[MAX_NE_CARDS];
-static int bad[MAX_NE_CARDS];	/* 0xbad = bad sig or no reset ack */
-
-module_param_array(io, int, NULL, 0);
-module_param_array(irq, int, NULL, 0);
-module_param_array(bad, int, NULL, 0);
-MODULE_PARM_DESC(io, "I/O base address(es),required");
-MODULE_PARM_DESC(irq, "IRQ number(s)");
-MODULE_PARM_DESC(bad, "Accept card(s) with bad signatures");
-MODULE_DESCRIPTION("NE1000/NE2000 ISA/PnP Ethernet driver");
-MODULE_LICENSE("GPL");
 
 /* This is set up so that no ISA autoprobe takes place. We can't guarantee
 that the ne2k probe is the last 8390 based probe to take place (as it
@@ -908,58 +980,76 @@ ISA device autoprobes on a running machine are not recommended anyway. */
 
 int __init init_module(void)
 {
-	int this_dev, found = 0;
-	int plat_found = !ne_init();
+	int retval;
+	int this_dev;
+	int probed_zero = 0;
+	struct platform_device *pdev;
 
 	for (this_dev = 0; this_dev < MAX_NE_CARDS; this_dev++) {
-		struct net_device *dev = alloc_eip_netdev();
-		if (!dev)
-			break;
-		dev->irq = irq[this_dev];
-		dev->mem_end = bad[this_dev];
-		dev->base_addr = io[this_dev];
-		if (do_ne_probe(dev) == 0) {
-			dev_ne[found++] = dev;
-			continue;
+		struct resource r[2] = {
+			{
+				.start = io[this_dev],
+				.end = io[this_dev]+NE_IO_EXTENT-1,
+				.name = "io_port",
+				.flags = IORESOURCE_IO},
+			{
+				.start = irq[this_dev],
+				.name = "irq",
+				.flags = IORESOURCE_IRQ} };
+		/* probe zero once */
+		if (io[this_dev] == 0) {
+			if (probed_zero)
+				continue;
+			probed_zero = 1;
 		}
-		free_netdev(dev);
-		if (found || plat_found)
-			break;
-		if (io[this_dev] != 0)
-			printk(KERN_WARNING "ne.c: No NE*000 card found at i/o = %#x\n", io[this_dev]);
-		else
-			printk(KERN_NOTICE "ne.c: You must supply \"io=0xNNN\" value(s) for ISA cards.\n");
-		return -ENXIO;
+		if (bad[this_dev] == BAD)
+			r[0].flags |= IORESOURCE_DISABLED;
+		pdev = platform_device_register_simple(
+			DRV_NAME, this_dev, r, ARRAY_SIZE(r));
+		if (IS_ERR(pdev))
+			continue;
+		pdev_ne[this_dev] = pdev;
 	}
-	if (found || plat_found)
-		return 0;
-	return -ENODEV;
-}
 
-static void cleanup_card(struct net_device *dev)
-{
-	struct pnp_dev *idev = (struct pnp_dev *)ei_status.priv;
-	if (idev)
-		pnp_device_detach(idev);
-	free_irq(dev->irq, dev);
-	release_region(dev->base_addr, NE_IO_EXTENT);
+	/* Need to find out if any devices are found, if not the driver
+	 * has been unregistered, so re-register it for suspend and
+	 * resume notifications and because cleanup_module unregisters it.
+	 */
+	retval = platform_driver_probe(&ne_driver, ne_drv_probe);
+	if (retval) {
+		if (io[this_dev] == 0)
+			printk(KERN_NOTICE "ne.c: You must supply \"io=0xNNN\""
+				" value(s) for ISA cards.\n");
+		ne_loop_rm_unreg(1);
+		return retval;
+	}
+
+	/* Unregister unused platform_devices. */
+	ne_loop_rm_unreg(0);
+
+	return retval;
 }
 
 void __exit cleanup_module(void)
 {
-	int this_dev;
+	platform_driver_unregister(&ne_driver);
 
-	ne_exit();
-	for (this_dev = 0; this_dev < MAX_NE_CARDS; this_dev++) {
-		struct net_device *dev = dev_ne[this_dev];
-		if (dev) {
-			unregister_netdev(dev);
-			cleanup_card(dev);
-			free_netdev(dev);
-		}
-	}
+	ne_loop_rm_unreg(1);
 }
 #else /* MODULE */
+
+static int __init ne_init(void)
+{
+	return platform_driver_probe(&ne_driver, ne_drv_probe);
+}
+
+static void __exit ne_exit(void)
+{
+	platform_driver_unregister(&ne_driver);
+
+	ne_loop_rm_unreg(1);
+}
+
 module_init(ne_init);
 module_exit(ne_exit);
 #endif /* MODULE */
