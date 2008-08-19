Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYHSWyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYHSWyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbYHSWxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:53:31 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:39761 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbYHSWx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:53:29 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 3/8] PNP: convert the last few pnp_info() uses to printk()
To: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>, Adam M Belay <abelay@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Ben Collins <bcollins@ubuntu.com>, Dann Frazier <dannf@debian.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2008 16:53:26 -0600
Message-ID: <20080819225326.28206.96184.stgit@tigger.helgaas>
In-Reply-To: <20080819225310.28206.1011.stgit@tigger.helgaas>
References: <20080819225310.28206.1011.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are only a few remaining uses of pnp_info(), so I just
converted them to printk and removed the pnp_err(), pnp_info(),
pnp_warn(), and pnp_dbg() wrappers.

I also removed a couple debug messages that don't seem useful any
more ("driver registered", "driver unregistered", "driver attached").

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pnp/driver.c       |    4 ----
 drivers/pnp/pnpacpi/core.c |    6 +++---
 include/linux/pnp.h        |   10 ----------
 3 files changed, 3 insertions(+), 17 deletions(-)


diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
index d3f869e..54673a4 100644
--- a/drivers/pnp/driver.c
+++ b/drivers/pnp/driver.c
@@ -114,7 +114,6 @@ static int pnp_device_probe(struct device *dev)
 	} else
 		goto fail;
 
-	dev_dbg(dev, "driver attached\n");
 	return error;
 
 fail:
@@ -210,8 +209,6 @@ struct bus_type pnp_bus_type = {
 
 int pnp_register_driver(struct pnp_driver *drv)
 {
-	pnp_dbg("the driver '%s' has been registered", drv->name);
-
 	drv->driver.name = drv->name;
 	drv->driver.bus = &pnp_bus_type;
 
@@ -221,7 +218,6 @@ int pnp_register_driver(struct pnp_driver *drv)
 void pnp_unregister_driver(struct pnp_driver *drv)
 {
 	driver_unregister(&drv->driver);
-	pnp_dbg("the driver '%s' has been unregistered", drv->name);
 }
 
 /**
diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index c1b9ea3..67c651b 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -255,14 +255,14 @@ int pnpacpi_disabled __initdata;
 static int __init pnpacpi_init(void)
 {
 	if (acpi_disabled || pnpacpi_disabled) {
-		pnp_info("PnP ACPI: disabled");
+		printk(KERN_INFO "pnp: PnP ACPI: disabled\n");
 		return 0;
 	}
-	pnp_info("PnP ACPI init");
+	printk(KERN_INFO "pnp: PnP ACPI init\n");
 	pnp_register_protocol(&pnpacpi_protocol);
 	register_acpi_bus_type(&acpi_pnp_bus);
 	acpi_get_devices(NULL, pnpacpi_add_device_handler, NULL, NULL);
-	pnp_info("PnP ACPI: found %d devices", num);
+	printk(KERN_INFO "pnp: PnP ACPI: found %d devices\n", num);
 	unregister_acpi_bus_type(&acpi_pnp_bus);
 	pnp_platform_devices = 1;
 	return 0;
diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index 1ce54b6..8d1c5ce 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -476,14 +476,4 @@ static inline void pnp_unregister_driver(struct pnp_driver *drv) { }
 
 #endif /* CONFIG_PNP */
 
-#define pnp_err(format, arg...) printk(KERN_ERR "pnp: " format "\n" , ## arg)
-#define pnp_info(format, arg...) printk(KERN_INFO "pnp: " format "\n" , ## arg)
-#define pnp_warn(format, arg...) printk(KERN_WARNING "pnp: " format "\n" , ## arg)
-
-#ifdef CONFIG_PNP_DEBUG
-#define pnp_dbg(format, arg...) printk(KERN_DEBUG "pnp: " format "\n" , ## arg)
-#else
-#define pnp_dbg(format, arg...) do {} while (0)
-#endif
-
 #endif /* _LINUX_PNP_H */

