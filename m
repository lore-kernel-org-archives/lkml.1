Return-Path: <linux-kernel-owner+w=401wt.eu-S932704AbZHQX1C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbZHQX1C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:27:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932685AbZHQX1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:27:00 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:49227 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510AbZHQX05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:26:57 -0400
Message-ID: <4A89E76B.5070204@dell.com>
Date: Mon, 17 Aug 2009 18:27:39 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090804)
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       cezary.jackiewicz@gmail.com
Subject: [PATCH 3/3] Drop platform sysfs support
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig59DB6BB6599E5577D383709D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig59DB6BB6599E5577D383709D
Content-Type: multipart/mixed;
 boundary="------------020003080702070007000703"

This is a multi-part message in MIME format.
--------------020003080702070007000703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

With rfkill support being added, the platform support is no longer
necessary.  Standard rfkill interfaces can be used to administer the box
now.
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com

--------------020003080702070007000703
Content-Type: text/x-patch;
 name="03_drop_platform_stuff.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="03_drop_platform_stuff.diff"

--- drivers/platform/x86/compal-laptop.c.old	2009-08-17 07:02:15.01283662=
5 -0500
+++ drivers/platform/x86/compal-laptop.c	2009-08-17 07:03:03.925633380 -0=
500
@@ -26,13 +26,6 @@
 /*
  * comapl-laptop.c - Compal laptop support.
  *
- * This driver exports a few files in /sys/devices/platform/compal-lapto=
p/:
- *
- *   wlan - wlan subsystem state: contains 0 or 1 (rw)
- *
- *   bluetooth - Bluetooth subsystem state: contains 0 or 1 (rw)
- *
- *   raw - raw value taken from embedded controller register (ro)
  *
  * In addition to these platform device attributes the driver
  * registers itself in the Linux backlight control subsystem and is
@@ -174,67 +167,6 @@
 	return ret;
 }
=20
-static int set_wlan_state(int state)
-{
-	u8 result, value;
-
-	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
-
-	if ((result & KILLSWITCH_MASK) =3D=3D 0)
-		return -EINVAL;
-	else {
-		if (state)
-			value =3D (u8) (result | WLAN_MASK);
-		else
-			value =3D (u8) (result & ~WLAN_MASK);
-		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
-	}
-
-	return 0;
-}
-
-static int set_bluetooth_state(int state)
-{
-	u8 result, value;
-
-	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
-
-	if ((result & KILLSWITCH_MASK) =3D=3D 0)
-		return -EINVAL;
-	else {
-		if (state)
-			value =3D (u8) (result | BT_MASK);
-		else
-			value =3D (u8) (result & ~BT_MASK);
-		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
-	}
-
-	return 0;
-}
-
-static int get_wireless_state(int *wlan, int *bluetooth)
-{
-	u8 result;
-
-	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
-
-	if (wlan) {
-		if ((result & KILLSWITCH_MASK) =3D=3D 0)
-			*wlan =3D 0;
-		else
-			*wlan =3D result & WLAN_MASK;
-	}
-
-	if (bluetooth) {
-		if ((result & KILLSWITCH_MASK) =3D=3D 0)
-			*bluetooth =3D 0;
-		else
-			*bluetooth =3D (result & BT_MASK) >> 1;
-	}
-
-	return 0;
-}
-
 /* Backlight device stuff */
=20
 static int bl_get_brightness(struct backlight_device *b)
@@ -255,96 +187,6 @@
=20
 static struct backlight_device *compalbl_device;
=20
-/* Platform device */
-
-static ssize_t show_wlan(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	int ret, enabled;
-
-	ret =3D get_wireless_state(&enabled, NULL);
-	if (ret < 0)
-		return ret;
-
-	return sprintf(buf, "%i\n", enabled);
-}
-
-static ssize_t show_raw(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	u8 result;
-
-	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
-
-	return sprintf(buf, "%i\n", result);
-}
-
-static ssize_t show_bluetooth(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	int ret, enabled;
-
-	ret =3D get_wireless_state(NULL, &enabled);
-	if (ret < 0)
-		return ret;
-
-	return sprintf(buf, "%i\n", enabled);
-}
-
-static ssize_t store_wlan_state(struct device *dev,
-	struct device_attribute *attr, const char *buf, size_t count)
-{
-	int state, ret;
-
-	if (sscanf(buf, "%i", &state) !=3D 1 || (state < 0 || state > 1))
-		return -EINVAL;
-
-	ret =3D set_wlan_state(state);
-	if (ret < 0)
-		return ret;
-
-	return count;
-}
-
-static ssize_t store_bluetooth_state(struct device *dev,
-	struct device_attribute *attr, const char *buf, size_t count)
-{
-	int state, ret;
-
-	if (sscanf(buf, "%i", &state) !=3D 1 || (state < 0 || state > 1))
-		return -EINVAL;
-
-	ret =3D set_bluetooth_state(state);
-	if (ret < 0)
-		return ret;
-
-	return count;
-}
-
-static DEVICE_ATTR(bluetooth, 0644, show_bluetooth, store_bluetooth_stat=
e);
-static DEVICE_ATTR(wlan, 0644, show_wlan, store_wlan_state);
-static DEVICE_ATTR(raw, 0444, show_raw, NULL);
-
-static struct attribute *compal_attributes[] =3D {
-	&dev_attr_bluetooth.attr,
-	&dev_attr_wlan.attr,
-	&dev_attr_raw.attr,
-	NULL
-};
-
-static struct attribute_group compal_attribute_group =3D {
-	.attrs =3D compal_attributes
-};
-
-static struct platform_driver compal_driver =3D {
-	.driver =3D {
-		.name =3D "compal-laptop",
-		.owner =3D THIS_MODULE,
-	}
-};
-
-static struct platform_device *compal_device;
-
 /* Initialization */
=20
 static int dmi_check_cb(const struct dmi_system_id *id)
@@ -454,49 +296,16 @@
 		compalbl_device =3D backlight_device_register("compal-laptop", NULL, N=
ULL,
 							    &compalbl_ops);
 		if (IS_ERR(compalbl_device))
-			return PTR_ERR(compalbl_device);
+			goto fail_backlight;
=20
 		compalbl_device->props.max_brightness =3D COMPAL_LCD_LEVEL_MAX-1;
 	}
=20
-	ret =3D platform_driver_register(&compal_driver);
-	if (ret)
-		goto fail_backlight;
-
-	/* Register platform stuff */
-
-	compal_device =3D platform_device_alloc("compal-laptop", -1);
-	if (!compal_device) {
-		ret =3D -ENOMEM;
-		goto fail_platform_driver;
-	}
-
-	ret =3D platform_device_add(compal_device);
-	if (ret)
-		goto fail_platform_device1;
-
-	ret =3D sysfs_create_group(&compal_device->dev.kobj,
-		&compal_attribute_group);
-	if (ret)
-		goto fail_platform_device2;
-
 	printk(KERN_INFO "compal-laptop: driver "COMPAL_DRIVER_VERSION
 		" successfully loaded.\n");
=20
 	return 0;
=20
-fail_platform_device2:
-
-	platform_device_del(compal_device);
-
-fail_platform_device1:
-
-	platform_device_put(compal_device);
-
-fail_platform_driver:
-
-	platform_driver_unregister(&compal_driver);
-
 fail_backlight:
=20
 	backlight_device_unregister(compalbl_device);
@@ -514,9 +323,6 @@
 static void __exit compal_cleanup(void)
 {
=20
-	sysfs_remove_group(&compal_device->dev.kobj, &compal_attribute_group);
-	platform_device_unregister(compal_device);
-	platform_driver_unregister(&compal_driver);
 	backlight_device_unregister(compalbl_device);
 	if (wifi_rfkill)
 		rfkill_unregister(wifi_rfkill);

--------------020003080702070007000703--

--------------enig59DB6BB6599E5577D383709D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqJ52sACgkQ2CrZjkA73YsGjgCfUgdkzKrQzY4xToRyhbVU309H
yaAAnj4IZSKGYOhV9juORk1xq5wG+vzA
=wKgk
-----END PGP SIGNATURE-----

--------------enig59DB6BB6599E5577D383709D--
