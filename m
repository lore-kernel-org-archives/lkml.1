Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbYHZTMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbYHZTMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759592AbYHZTLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:11:49 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:51291 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759000AbYHZTLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:11:48 -0400
Date: Tue, 26 Aug 2008 21:11:44 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: magnus.damm@gmail.com, hjk@linutronix.de
Subject: [PATCH] UIO: Add of_platform_driver to uio_pdrv_genirq
Message-ID: <20080826191144.GA10349@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 10.1.1.3
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Make the uio-driver with generic irq handling also accessible for of_device=
s.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---

I hope the compatible-tag "generic-uio" is apropriate. Please CC me when
replying.

 drivers/uio/uio_pdrv_genirq.c |  178 ++++++++++++++++++++++++++++++++++++-=
-----
 1 file changed, 154 insertions(+), 24 deletions(-)

Index: playground/drivers/uio/uio_pdrv_genirq.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- playground.orig/drivers/uio/uio_pdrv_genirq.c
+++ playground/drivers/uio/uio_pdrv_genirq.c
@@ -1,13 +1,15 @@
 /*
  * drivers/uio/uio_pdrv_genirq.c
  *
- * Userspace I/O platform driver with generic IRQ handling code.
+ * Userspace I/O platform & of driver with generic IRQ handling code.
  *
  * Copyright (C) 2008 Magnus Damm
+ * Copyright (C) 2008 Wolfram Sang, Pengutronix
  *
  * Based on uio_pdrv.c by Uwe Kleine-Koenig,
  * Copyright (C) 2008 by Digi International Inc.
  * All rights reserved.
+ * Adding of_platform_driver based on xilinxfb.c by Grant Likely.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as publishe=
d by
@@ -20,6 +22,10 @@
 #include <linux/bitops.h>
 #include <linux/interrupt.h>
 #include <linux/stringify.h>
+#if defined(CONFIG_OF)
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#endif
=20
 #define DRIVER_NAME "uio_pdrv_genirq"
=20
@@ -68,28 +74,18 @@
 	return 0;
 }
=20
-static int uio_pdrv_genirq_probe(struct platform_device *pdev)
+static int uio_pdrv_genirq_setup(struct device *dev, struct uio_info *uioi=
nfo,
+		struct resource *resources, unsigned int num_resources)
 {
-	struct uio_info *uioinfo =3D pdev->dev.platform_data;
 	struct uio_pdrv_genirq_platdata *priv;
 	struct uio_mem *uiomem;
-	int ret =3D -EINVAL;
-	int i;
-
-	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
-		dev_err(&pdev->dev, "missing platform_data\n");
-		goto bad0;
-	}
-
-	if (uioinfo->handler || uioinfo->irqcontrol || uioinfo->irq_flags) {
-		dev_err(&pdev->dev, "interrupt configuration error\n");
-		goto bad0;
-	}
+	unsigned int i;
+	int ret;
=20
 	priv =3D kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
 		ret =3D -ENOMEM;
-		dev_err(&pdev->dev, "unable to kmalloc\n");
+		dev_err(dev, "unable to kmalloc\n");
 		goto bad0;
 	}
=20
@@ -99,14 +95,15 @@
=20
 	uiomem =3D &uioinfo->mem[0];
=20
-	for (i =3D 0; i < pdev->num_resources; ++i) {
-		struct resource *r =3D &pdev->resource[i];
+	for (i =3D 0; i < num_resources; ++i) {
+
+		struct resource *r =3D resources + i;
=20
 		if (r->flags !=3D IORESOURCE_MEM)
 			continue;
=20
 		if (uiomem >=3D &uioinfo->mem[MAX_UIO_MAPS]) {
-			dev_warn(&pdev->dev, "device has more than "
+			dev_warn(dev, "device has more than "
 					__stringify(MAX_UIO_MAPS)
 					" I/O memory resources.\n");
 			break;
@@ -137,13 +134,13 @@
 	uioinfo->irqcontrol =3D uio_pdrv_genirq_irqcontrol;
 	uioinfo->priv =3D priv;
=20
-	ret =3D uio_register_device(&pdev->dev, priv->uioinfo);
+	ret =3D uio_register_device(dev, priv->uioinfo);
 	if (ret) {
-		dev_err(&pdev->dev, "unable to register uio device\n");
+		dev_err(dev, "unable to register uio device\n");
 		goto bad1;
 	}
=20
-	platform_set_drvdata(pdev, priv);
+	dev_set_drvdata(dev, priv);
 	return 0;
  bad1:
 	kfree(priv);
@@ -151,6 +148,24 @@
 	return ret;
 }
=20
+static int uio_pdrv_genirq_probe(struct platform_device *pdev)
+{
+	struct uio_info *uioinfo =3D pdev->dev.platform_data;
+
+	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
+		dev_err(&pdev->dev, "missing platform_data\n");
+		return -EINVAL;
+	}
+
+	if (uioinfo->handler || uioinfo->irqcontrol || uioinfo->irq_flags) {
+		dev_err(&pdev->dev, "interrupt configuration error\n");
+		return -EINVAL;
+	}
+
+	return uio_pdrv_genirq_setup(&pdev->dev, uioinfo, pdev->resource,
+			pdev->num_resources);
+}
+
 static int uio_pdrv_genirq_remove(struct platform_device *pdev)
 {
 	struct uio_pdrv_genirq_platdata *priv =3D platform_get_drvdata(pdev);
@@ -169,20 +184,135 @@
 	},
 };
=20
+/* ---------------------------------------------------------------------
+ * OF bus binding
+ */
+
+#if defined(CONFIG_OF)
+
+#define OF_DRIVER_NAME "uio_of_genirq"
+#define OF_DRIVER_VERSION "1"
+
+static int uio_of_genirq_probe(struct of_device *op,
+		const struct of_device_id *match)
+{
+	struct uio_info *uioinfo;
+	struct resource *resources;
+	int i, ret =3D -ENOMEM;
+
+	uioinfo =3D kzalloc(sizeof(*uioinfo), GFP_KERNEL);
+	if (!uioinfo)
+		goto bad0;
+
+	uioinfo->name =3D (char *)of_get_property(op->node, "name", NULL);
+	if (!uioinfo->name) {
+		ret =3D -ENODEV;
+		dev_err(&op->dev, "could not get node name\n");
+		goto bad1;
+	}
+
+	uioinfo->version =3D OF_DRIVER_VERSION;
+	uioinfo->irq =3D irq_of_parse_and_map(op->node, 0);
+	if (!uioinfo->irq)
+		uioinfo->irq =3D UIO_IRQ_NONE;
+
+	resources =3D kzalloc(MAX_UIO_MAPS * sizeof(struct resource), GFP_KERNEL);
+	if (!resources)
+		goto bad2;
+
+	for (i =3D 0; i < MAX_UIO_MAPS; ++i)
+		if (of_address_to_resource(op->node, i, resources + i))
+			break;
+
+	ret =3D uio_pdrv_genirq_setup(&op->dev, uioinfo, resources, i);
+	kfree(resources);
+	if (ret)
+		goto bad2;
+
+	return 0;
+
+ bad2:
+	if (uioinfo->irq !=3D UIO_IRQ_NONE)
+		irq_dispose_mapping(uioinfo->irq);
+ bad1:
+	kfree(uioinfo);
+ bad0:
+	return ret;
+}
+
+static int  uio_of_genirq_remove(struct of_device *op)
+{
+	struct uio_pdrv_genirq_platdata *priv =3D dev_get_drvdata(&op->dev);
+
+	uio_unregister_device(priv->uioinfo);
+
+	if (priv->uioinfo->irq !=3D UIO_IRQ_NONE)
+		irq_dispose_mapping(priv->uioinfo->irq);
+
+	kfree(priv->uioinfo);
+	kfree(priv);
+	return 0;
+}
+
+/* Match table for of_platform binding */
+static struct of_device_id uio_of_genirq_match[] =3D {
+	{ .compatible =3D "generic-uio", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
+
+static struct of_platform_driver uio_of_genirq_driver =3D {
+	.owner =3D THIS_MODULE,
+	.name =3D OF_DRIVER_NAME,
+	.match_table =3D uio_of_genirq_match,
+	.probe =3D uio_of_genirq_probe,
+	.remove =3D uio_of_genirq_remove,
+};
+
+/* Registration helpers to keep the number of #ifdefs to a minimum */
+static inline int __init uio_of_genirq_register(void)
+{
+	return of_register_platform_driver(&uio_of_genirq_driver);
+}
+
+static inline void __exit uio_of_genirq_unregister(void)
+{
+	of_unregister_platform_driver(&uio_of_genirq_driver);
+}
+#else /* CONFIG_OF */
+/* CONFIG_OF not enabled; do nothing helpers */
+static inline int __init uio_of_genirq_register(void) { return 0; }
+static inline void __exit uio_of_genirq_unregister(void) { }
+#endif /* CONFIG_OF */
+
+/* --------------------------------------------------------------------- */
+
 static int __init uio_pdrv_genirq_init(void)
 {
-	return platform_driver_register(&uio_pdrv_genirq);
+	int retval;
+
+	retval =3D uio_of_genirq_register();
+	if (retval)
+		return retval;
+
+	retval =3D platform_driver_register(&uio_pdrv_genirq);
+	if (retval)
+		uio_of_genirq_unregister();
+
+	return retval;
 }
=20
 static void __exit uio_pdrv_genirq_exit(void)
 {
 	platform_driver_unregister(&uio_pdrv_genirq);
+	uio_of_genirq_unregister();
 }
=20
 module_init(uio_pdrv_genirq_init);
 module_exit(uio_pdrv_genirq_exit);
=20
 MODULE_AUTHOR("Magnus Damm");
-MODULE_DESCRIPTION("Userspace I/O platform driver with generic IRQ handlin=
g");
+MODULE_DESCRIPTION("Userspace I/O platform & of driver with generic"
+		   "IRQ handling");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:" DRIVER_NAME);
--=20
  Dipl.-Ing. Wolfram Sang | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFItFVwD27XaX1/VRsRAv8pAJ9uWfSTHb9ENSqZe6/jC7KZrCk8KgCgnz/1
jBy3Of+1gx8WLpvVuUF30G4=
=iPQz
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
