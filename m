Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbZF0RKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbZF0RKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 13:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZF0RKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 13:10:12 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:47585 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbZF0RKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 13:10:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer;
        b=HNJWNMY+HXFkG5tjI2aaofTIg3RbIRS9PmomcVJlBfKrpIckvxx64abeY3k1zfEPqU
         TFbtXx3utdTnyMH4sEVeePOLbqS0SGjIWSHJPiK07ro0GuU0NJftDbA3eYEME4nHxG3X
         NwBO0GDS8lkj7LSUZkzkr0a1TISPefYo9XWwk=
Subject: [PATCH] PCAP misc input driver (for 2.6.32)
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Cc: inux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Ilya Petrov <ilya.muromec@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ggtxgUtnlns3J6H7qiNa"
Date: Sat, 27 Jun 2009 14:09:52 -0300
Message-Id: <1246122592.3727.20.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ggtxgUtnlns3J6H7qiNa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This is a driver for misc input events for the PCAP2 PMIC, it handles
the power button, headphone insertion/removal and the headphone button.

Signed-off-by: Ilya Petrov <ilya.muromec@gmail.com>
Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>

---
 drivers/input/keyboard/Kconfig     |    7 ++
 drivers/input/keyboard/Makefile    |    1 +
 drivers/input/keyboard/pcap_keys.c |  152 ++++++++++++++++++++++++++++++++=
++++
 3 files changed, 160 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfi=
g
index 9d8f796..ea512b0 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -353,4 +353,11 @@ config KEYBOARD_EP93XX
 	  To compile this driver as a module, choose M here: the
 	  module will be called ep93xx_keypad.
=20
+config KEYBOARD_PCAP
+        tristate "Motorola EZX PCAP events"
+        depends on EZX_PCAP
+        help
+          Say Y here if you want to use power key and jack events
+          on Motorola EZX 2nd generation phones
+
 endif
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makef=
ile
index 156b647..06b77dd 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_KEYBOARD_MAPLE)		+=3D maple_keyb.o
 obj-$(CONFIG_KEYBOARD_BFIN)		+=3D bf54x-keys.o
 obj-$(CONFIG_KEYBOARD_SH_KEYSC)		+=3D sh_keysc.o
 obj-$(CONFIG_KEYBOARD_EP93XX)		+=3D ep93xx_keypad.o
+obj-$(CONFIG_KEYBOARD_PCAP)		+=3D pcap_keys.o
diff --git a/drivers/input/keyboard/pcap_keys.c b/drivers/input/keyboard/pc=
ap_keys.c
new file mode 100644
index 0000000..8a9b533
--- /dev/null
+++ b/drivers/input/keyboard/pcap_keys.c
@@ -0,0 +1,152 @@
+/*
+ *  Input driver for PCAP events:
+ *   * Power key
+ *   * Jack plug/unplug
+ *   * Headphone button
+ *
+ *  Copyright (c) 2008,2009 Ilya Petrov <ilya.muromec@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/mfd/ezx-pcap.h>
+
+struct pcap_keys {
+	struct pcap_chip *pcap;
+	struct input_dev *input;
+};
+
+/* PCAP2 interrupts us on keypress */
+static irqreturn_t pcap_keys_handler(int irq, void *_pcap_keys)
+{
+	struct pcap_keys *pcap_keys =3D _pcap_keys;
+	int pirq =3D irq_to_pcap(pcap_keys->pcap, irq);
+	u32 pstat;
+
+	ezx_pcap_read(pcap_keys->pcap, PCAP_REG_PSTAT, &pstat);
+	pstat &=3D 1 << pirq;
+
+	switch (pirq) {
+	case PCAP_IRQ_ONOFF:
+		input_report_key(pcap_keys->input, KEY_POWER, !pstat);
+		break;
+	case PCAP_IRQ_HS:
+		input_report_switch(pcap_keys->input,
+				SW_HEADPHONE_INSERT, !pstat);
+		break;
+	case PCAP_IRQ_MIC:
+		input_report_key(pcap_keys->input, KEY_HP, !pstat);
+		break;
+	}
+
+	input_sync(pcap_keys->input);
+
+	return IRQ_HANDLED;
+}
+
+static int __init pcap_keys_probe(struct platform_device *pdev)
+{
+	int err =3D -ENOMEM;
+	struct pcap_keys *pcap_keys;
+
+	pcap_keys =3D kmalloc(sizeof(struct pcap_keys), GFP_KERNEL);
+	if (!pcap_keys)
+		return err;
+
+	pcap_keys->pcap =3D platform_get_drvdata(pdev);
+
+	pcap_keys->input =3D input_allocate_device();
+	if (!pcap_keys->input)
+		goto fail;
+
+	platform_set_drvdata(pdev, pcap_keys);
+	pcap_keys->input->name =3D pdev->name;
+	pcap_keys->input->phys =3D "pcap-keys/input0";
+	pcap_keys->input->dev.parent =3D &pdev->dev;
+
+	pcap_keys->input->evbit[0] =3D BIT_MASK(EV_KEY) | BIT_MASK(EV_SW);
+	set_bit(KEY_POWER, pcap_keys->input->keybit);
+	set_bit(SW_HEADPHONE_INSERT, pcap_keys->input->swbit);
+	set_bit(KEY_HP, pcap_keys->input->keybit);
+
+	err =3D request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF),
+			pcap_keys_handler, 0, "Power key", pcap_keys);
+	if (err)
+		goto fail_dev;
+
+	err =3D request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_HS),
+			pcap_keys_handler, 0, "Headphone jack", pcap_keys);
+	if (err)
+		goto fail_pwrkey;
+
+	err =3D request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC),
+			pcap_keys_handler, 0, "MIC jack/button", pcap_keys);
+	if (err)
+		goto fail_jack;
+
+	err =3D input_register_device(pcap_keys->input);
+	if (err)
+		goto fail_mic;
+
+	return 0;
+
+fail_mic:
+	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC), pcap_keys);
+fail_jack:
+	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_HS), pcap_keys);
+fail_pwrkey:
+	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF), pcap_keys);
+fail_dev:
+	input_free_device(pcap_keys->input);
+fail:
+	kfree(pcap_keys);
+	return err;
+}
+
+static int pcap_keys_remove(struct platform_device *pdev)
+{
+	struct pcap_keys *pcap_keys =3D platform_get_drvdata(pdev);
+
+	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF), pcap_keys);
+	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_HS), pcap_keys);
+	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC), pcap_keys);
+
+	input_unregister_device(pcap_keys->input);
+	kfree(pcap_keys);
+
+	return 0;
+}
+
+static struct platform_driver pcap_keys_device_driver =3D {
+	.probe		=3D pcap_keys_probe,
+	.remove		=3D pcap_keys_remove,
+	.driver		=3D {
+		.name	=3D "pcap-keys",
+		.owner	=3D THIS_MODULE,
+	}
+};
+
+static int __init pcap_keys_init(void)
+{
+	return platform_driver_register(&pcap_keys_device_driver);
+};
+
+static void __exit pcap_keys_exit(void)
+{
+	platform_driver_unregister(&pcap_keys_device_driver);
+};
+
+module_init(pcap_keys_init);
+module_exit(pcap_keys_exit);
+
+MODULE_DESCRIPTION("Motorola PCAP2 input events driver");
+MODULE_AUTHOR("Ilya Petrov <ilya.muromec@gmail.com>");
+MODULE_LICENSE("GPL");
--=20
tg: (22f99ae..) ezx/pcap_keys (depends on: ezx/local/pcap)

--=20
Daniel Ribeiro

--=-ggtxgUtnlns3J6H7qiNa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpGUmAACgkQw3OYl0G0liSIjQCfTKItSPbuzLfyBzjHuk24w7vt
byoAoJYg7aM+ro0cjyg3AZeIoC5qqMgo
=hDwB
-----END PGP SIGNATURE-----

--=-ggtxgUtnlns3J6H7qiNa--

