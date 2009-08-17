Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbZHQX1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbZHQX1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbZHQX1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:27:16 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:23877 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448AbZHQX0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:26:54 -0400
X-Loopcount0: from 10.9.160.253
Message-ID: <4A89E768.7010207@dell.com>
Date: Mon, 17 Aug 2009 18:27:36 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090804)
MIME-Version: 1.0
To: cezary.jackiewicz@gmail.com
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Add rfkill support to compal-laptop
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig121A5D7D329F1E352EF9C933"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig121A5D7D329F1E352EF9C933
Content-Type: multipart/mixed;
 boundary="------------000504070907030503050604"

This is a multi-part message in MIME format.
--------------000504070907030503050604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

In order to be useful in modern kernels and standard interfaces,
compal-laptop should have rfkill support.  This patch adds it.
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com

--------------000504070907030503050604
Content-Type: text/x-patch;
 name="02_add_rfkill_support.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="02_add_rfkill_support.diff"

--- drivers/platform/x86/compal-laptop.c.old	2009-08-17 07:01:36.24487443=
0 -0500
+++ drivers/platform/x86/compal-laptop.c	2009-08-17 07:02:15.012836625 -0=
500
@@ -52,6 +52,7 @@
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
 #include <linux/autoconf.h>
+#include <linux/rfkill.h>
=20
 #define COMPAL_DRIVER_VERSION "0.2.6"
=20
@@ -64,6 +65,9 @@
 #define WLAN_MASK	0x01
 #define BT_MASK 	0x02
=20
+static struct rfkill *wifi_rfkill;
+static struct rfkill *bluetooth_rfkill;
+
 static int force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
@@ -89,6 +93,87 @@
 	return (int) result;
 }
=20
+static void compal_rfkill_query(struct rfkill *rfkill, void *data)
+{
+	unsigned long radio =3D (unsigned long) data;
+	u8 result;
+	bool blocked;
+
+	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
+
+	if ((result & KILLSWITCH_MASK) =3D=3D 0)
+		blocked =3D 1;
+        else if (radio =3D=3D WLAN_MASK)
+		blocked =3D !(result & WLAN_MASK);
+	else
+		blocked =3D !((result & BT_MASK) >> 1);
+
+	rfkill_set_sw_state(rfkill,blocked);
+	rfkill_set_hw_state(rfkill,0);
+}
+
+static int compal_rfkill_set(void *data, bool blocked)
+{
+	unsigned long radio =3D (unsigned long) data;
+	u8 result, value;
+
+	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
+
+	if ((result & KILLSWITCH_MASK) =3D=3D 0)
+		return -EINVAL;
+	else {
+		if (!blocked)
+			value =3D (u8) (result | radio);
+		else
+			value =3D (u8) (result & ~radio);
+		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
+	}
+
+	return 0;
+}
+
+static const struct rfkill_ops compal_rfkill_ops =3D {
+	.set_block =3D compal_rfkill_set,
+	.query =3D compal_rfkill_query,
+};
+
+static int setup_rfkill(void)
+{
+	int ret;
+
+	wifi_rfkill =3D rfkill_alloc("compal-wifi", NULL, RFKILL_TYPE_WLAN,
+					&compal_rfkill_ops, (void *) WLAN_MASK);
+	if (!wifi_rfkill) {
+		ret =3D -ENOMEM;
+		goto err_wifi;
+	}
+	ret =3D rfkill_register(wifi_rfkill);
+	if (ret)
+		goto err_wifi;
+
+	bluetooth_rfkill =3D rfkill_alloc("compal-bluetooth", NULL, RFKILL_TYPE=
_BLUETOOTH,
+					&compal_rfkill_ops, (void *) BT_MASK);
+	if (!bluetooth_rfkill) {
+		ret =3D -ENOMEM;
+		goto err_bt;
+	}
+	ret =3D rfkill_register(bluetooth_rfkill);
+	if (ret)
+		goto err_bt;
+
+	return 0;
+err_bt:
+	rfkill_destroy(bluetooth_rfkill);
+	if (bluetooth_rfkill)
+		rfkill_unregister(bluetooth_rfkill);
+err_wifi:
+	rfkill_destroy(wifi_rfkill);
+	if (wifi_rfkill)
+		rfkill_unregister(wifi_rfkill);
+
+	return ret;
+}
+
 static int set_wlan_state(int state)
 {
 	u8 result, value;
@@ -357,6 +442,12 @@
 	if (!force && !dmi_check_system(compal_dmi_table))
 		return -ENODEV;
=20
+	ret =3D setup_rfkill();
+	if (ret) {
+		printk(KERN_WARNING "compal-laptop: Unable to setup rfkill\n");
+		goto fail_rfkill;
+	}
+
 	/* Register backlight stuff */
=20
 	if (!acpi_video_backlight_support()) {
@@ -410,6 +501,13 @@
=20
 	backlight_device_unregister(compalbl_device);
=20
+fail_rfkill:
+
+	if (wifi_rfkill)
+		rfkill_unregister(wifi_rfkill);
+	if (bluetooth_rfkill)
+		rfkill_unregister(bluetooth_rfkill);
+
 	return ret;
 }
=20
@@ -420,6 +518,10 @@
 	platform_device_unregister(compal_device);
 	platform_driver_unregister(&compal_driver);
 	backlight_device_unregister(compalbl_device);
+	if (wifi_rfkill)
+		rfkill_unregister(wifi_rfkill);
+	if (bluetooth_rfkill)
+		rfkill_unregister(bluetooth_rfkill);
=20
 	printk(KERN_INFO "compal-laptop: driver unloaded.\n");
 }

--------------000504070907030503050604--

--------------enig121A5D7D329F1E352EF9C933
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqJ52gACgkQ2CrZjkA73Yv9KwCfbRMp1giiFiate4jC4c6ZQmut
9gQAn0i6zcQ5g3AXFCMO5VZXWa0nZ43Y
=Gfvx
-----END PGP SIGNATURE-----

--------------enig121A5D7D329F1E352EF9C933--
