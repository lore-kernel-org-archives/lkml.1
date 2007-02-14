Return-Path: <linux-kernel-owner+w=401wt.eu-S932528AbXBNUEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbXBNUEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932529AbXBNUEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:04:05 -0500
Received: from mta11.adelphia.net ([68.168.78.205]:37916 "EHLO
	mta11.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528AbXBNUED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:04:03 -0500
Date: Wed, 14 Feb 2007 14:03:54 -0600
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: Christian Krafft <krafft@de.ibm.com>, Heiko J Schick <schihei@de.ibm.com>,
       Arnd Bergmann <arnd.bergmann@de.ibm.com>
Subject: [patch 1/4] ipmi: add powerpc openfirmware sensing
Message-ID: <20070214200141.GA5364@localdomain>
Reply-To: minyard@acm.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds support for of_platform_driver to the ipmi_si module.
When loading the module, the driver will be registered to of_platform.
The driver will be probed for all devices with the type ipmi. It's supporting
devices with compatible settings ipmi-kcs, ipmi-smic and ipmi-bt.
Only ipmi-kcs could be tested.

Signed-off-by: Christian Krafft <krafft@de.ibm.com>
Acked-by: Heiko J Schick <schihei@de.ibm.com>
Signed-off-by: Corey Minyard <minyard@acm.org>
Acked-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>

Index: linux/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux/drivers/char/ipmi/ipmi_si_intf.c
@@ -9,6 +9,7 @@
  *         source@mvista.com
  *
  * Copyright 2002 MontaVista Software Inc.
+ * Copyright 2006 IBM Corp., Christian Krafft <krafft@de.ibm.com>
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under the terms of the GNU General Public License as published by the
@@ -64,6 +65,11 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 
+#ifdef CONFIG_PPC_OF
+#include <asm/of_device.h>
+#include <asm/of_platform.h>
+#endif
+
 #define PFX "ipmi_si: "
 
 /* Measure times between events in the driver. */
@@ -1006,6 +1012,7 @@ static DEFINE_MUTEX(smi_infos_lock);
 static int smi_num; /* Used to sequence the SMIs */
 
 #define DEFAULT_REGSPACING	1
+#define DEFAULT_REGSIZE		1
 
 static int           si_trydefaults = 1;
 static char          *si_type[SI_MAX_PARMS];
@@ -2174,6 +2181,99 @@ static struct pci_driver ipmi_pci_driver
 #endif /* CONFIG_PCI */
 
 
+#ifdef CONFIG_PPC_OF
+static int __devinit ipmi_of_probe(struct of_device *dev,
+			 const struct of_device_id *match)
+{
+	struct smi_info *info;
+	struct resource resource;
+	const int *regsize, *regspacing, *regshift;
+	struct device_node *np = dev->node;
+	int ret;
+	int proplen;
+
+	dev_info(&dev->dev, PFX "probing via device tree\n");
+
+	ret = of_address_to_resource(np, 0, &resource);
+	if (ret) {
+		dev_warn(&dev->dev, PFX "invalid address from OF\n");
+		return ret;
+	}
+
+	regsize = get_property(np, "reg-size", &proplen);
+	if (regsize && proplen != 4) {
+		dev_warn(&dev->dev, PFX "invalid regsize from OF\n");
+		return -EINVAL;
+	}
+
+	regspacing = get_property(np, "reg-spacing", &proplen);
+	if (regspacing && proplen != 4) {
+		dev_warn(&dev->dev, PFX "invalid regspacing from OF\n");
+		return -EINVAL;
+	}
+
+	regshift = get_property(np, "reg-shift", &proplen);
+	if (regshift && proplen != 4) {
+		dev_warn(&dev->dev, PFX "invalid regshift from OF\n");
+		return -EINVAL;
+	}
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+
+	if (!info) {
+		dev_err(&dev->dev,
+			PFX "could not allocate memory for OF probe\n");
+		return -ENOMEM;
+	}
+
+	info->si_type		= (enum si_type) match->data;
+	info->addr_source	= "device-tree";
+	info->io_setup		= mem_setup;
+	info->irq_setup		= std_irq_setup;
+
+	info->io.addr_type	= IPMI_MEM_ADDR_SPACE;
+	info->io.addr_data	= resource.start;
+
+	info->io.regsize	= regsize ? *regsize : DEFAULT_REGSIZE;
+	info->io.regspacing	= regspacing ? *regspacing : DEFAULT_REGSPACING;
+	info->io.regshift	= regshift ? *regshift : 0;
+
+	info->irq		= irq_of_parse_and_map(dev->node, 0);
+	info->dev		= &dev->dev;
+
+	dev_dbg(&dev->dev, "addr 0x%lx regsize %ld spacing %ld irq %x\n",
+		info->io.addr_data, info->io.regsize, info->io.regspacing,
+		info->irq);
+
+	dev->dev.driver_data = (void*) info;
+
+	return try_smi_init(info);
+}
+
+static int __devexit ipmi_of_remove(struct of_device *dev)
+{
+	cleanup_one_si(dev->dev.driver_data);
+	return 0;
+}
+
+static struct of_device_id ipmi_match[] =
+{
+	{ .type = "ipmi", .compatible = "ipmi-kcs",  .data = (void *)(unsigned long) SI_KCS },
+	{ .type = "ipmi", .compatible = "ipmi-smic", .data = (void *)(unsigned long) SI_SMIC },
+	{ .type = "ipmi", .compatible = "ipmi-bt",   .data = (void *)(unsigned long) SI_BT },
+	{},
+};
+
+static struct of_platform_driver ipmi_of_platform_driver =
+{
+	.name		= "ipmi",
+	.match_table	= ipmi_match,
+	.probe		= ipmi_of_probe,
+	.remove		= __devexit_p(ipmi_of_remove),
+};
+#endif /* CONFIG_PPC_OF */
+
+
 static int try_get_dev_id(struct smi_info *smi_info)
 {
 	unsigned char         msg[2];
@@ -2798,6 +2898,10 @@ static __devinit int init_ipmi_si(void)
 	}
 #endif
 
+#ifdef CONFIG_PPC_OF
+	of_register_platform_driver(&ipmi_of_platform_driver);
+#endif
+
 	if (si_trydefaults) {
 		mutex_lock(&smi_infos_lock);
 		if (list_empty(&smi_infos)) {
@@ -2895,6 +2999,10 @@ static __exit void cleanup_ipmi_si(void)
 	pci_unregister_driver(&ipmi_pci_driver);
 #endif
 
+#ifdef CONFIG_PPC_OF
+	of_unregister_platform_driver(&ipmi_of_platform_driver);
+#endif
+
 	mutex_lock(&smi_infos_lock);
 	list_for_each_entry_safe(e, tmp_e, &smi_infos, link)
 		cleanup_one_si(e);

