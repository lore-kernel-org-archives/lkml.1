Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbXCZQkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbXCZQkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 12:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXCZQkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 12:40:20 -0400
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:34000 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752957AbXCZQkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 12:40:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0wuSET1qRKcS/ZE8vczLlG32+Mw6ZYOk2FdBv5XtRJ853umPuabHA3gJhZdJ4wnfIZF2SDk1c0PCkEHOd/Ey9qXZIe3b0h+G7Z9mqSy9HGtncCN+ATiLK6KIvsUBawJJpF1WO0DrHVOYmp2UCb73cC6SEnSVhK7NjMIe0AnMMzw=  ;
X-YMail-OSG: EwW6XAAVM1mtUXfpQU9QNbuhT0zkUe_hzib0NBDfpm_HzDGE57PaBSpCMcbfO3uO2U3WICvf.CmEbjqc_3HtXqgaRMUK65X7SEG_OAWt28IHJyptxWoI07E0bqLiRf8sQgOd0jU4rwn3TMny_T1sCcuMqQ--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.21-rc5 2/3] legacy PC parports support parport->dev
Date: Mon, 26 Mar 2007 09:08:54 -0700
User-Agent: KMail/1.7.1
Cc: akpm@linux-foundation.org, Jean Delvare <khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703260908.55241.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

Give legacy parallel ports a platform device in the device tree.

This is a quick and dirty implementation; it doesn't actually convert
the legacy parport code to the device driver model (by splitting out
probing from device creation).  But at least parallel port device
drivers will finally have a device to work with.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/parport/parport_pc.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- linux-2.6.21-pre.orig/drivers/parport/parport_pc.c	2007-02-19 12:03:44.000000000 +0100
+++ linux-2.6.21-pre/drivers/parport/parport_pc.c	2007-02-19 18:15:41.000000000 +0100
@@ -53,6 +53,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/pnp.h>
+#include <linux/platform_device.h>
 #include <linux/sysctl.h>
 
 #include <asm/io.h>
@@ -2156,6 +2157,17 @@ struct parport *parport_pc_probe_port (u
 	struct resource *base_res;
 	struct resource	*ECR_res = NULL;
 	struct resource	*EPP_res = NULL;
+	struct platform_device *pdev = NULL;
+
+	if (!dev) {
+		/* We need a physical device to attach to, but none was
+		 * provided. Create our own. */
+		pdev = platform_device_register_simple("parport_pc",
+						       base, NULL, 0);
+		if (IS_ERR(pdev))
+			return NULL;
+		dev = &pdev->dev;
+	}
 
 	ops = kmalloc(sizeof (struct parport_operations), GFP_KERNEL);
 	if (!ops)
@@ -2359,6 +2371,8 @@ out3:
 out2:
 	kfree (ops);
 out1:
+	if (pdev)
+		platform_device_unregister(pdev);
 	return NULL;
 }
 
@@ -3106,6 +3120,21 @@ static struct pnp_driver parport_pc_pnp_
 };
 
 
+static int __devinit parport_pc_platform_probe(struct platform_device *pdev)
+{
+	/* Always succeed, the actual probing is done in
+	 * parport_pc_probe_port(). */
+	return 0;
+}
+
+static struct platform_driver parport_pc_platform_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "parport_pc",
+	},
+	.probe		= parport_pc_platform_probe,
+};
+
 /* This is called by parport_pc_find_nonpci_ports (in asm/parport.h) */
 static int __devinit __attribute__((unused))
 parport_pc_find_isa_ports (int autoirq, int autodma)
@@ -3381,9 +3410,15 @@ __setup("parport_init_mode=",parport_ini
 
 static int __init parport_pc_init(void)
 {
+	int err;
+
 	if (parse_parport_params())
 		return -EINVAL;
 
+	err = platform_driver_register(&parport_pc_platform_driver);
+	if (err)
+		return err;
+
 	if (io[0]) {
 		int i;
 		/* Only probe the ports we were given. */
@@ -3408,6 +3443,7 @@ static void __exit parport_pc_exit(void)
 		pci_unregister_driver (&parport_pc_pci_driver);
 	if (pnp_registered_parport)
 		pnp_unregister_driver (&parport_pc_pnp_driver);
+	platform_driver_unregister(&parport_pc_platform_driver);
 
 	spin_lock(&ports_lock);
 	while (!list_empty(&ports_list)) {
@@ -3416,6 +3452,9 @@ static void __exit parport_pc_exit(void)
 		priv = list_entry(ports_list.next,
 				  struct parport_pc_private, list);
 		port = priv->port;
+		if (port->dev && port->dev->bus == &platform_bus_type)
+			platform_device_unregister(
+				to_platform_device(port->dev));
 		spin_unlock(&ports_lock);
 		parport_pc_unregister_port(port);
 		spin_lock(&ports_lock);

