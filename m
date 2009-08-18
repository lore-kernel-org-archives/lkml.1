Return-Path: <linux-kernel-owner+w=401wt.eu-S932717AbZHRRsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbZHRRsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932624AbZHRRsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:48:06 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:12951 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581AbZHRRsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:48:04 -0400
Message-ID: <4A8AE97E.9050604@dell.com>
Date: Tue, 18 Aug 2009 12:48:46 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090804)
MIME-Version: 1.0
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
CC: Marcel Holtmann <marcel@holtmann.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, cezary.jackiewicz@gmail.com
Subject: Re: [PATCH 3/3] Drop platform sysfs support
References: <4A89E76B.5070204@dell.com>	 <9b2b86520908180143t4b25c1f7hd78cd4b4333c4ab4@mail.gmail.com>	 <1250589285.5150.1.camel@localhost.localdomain> <9b2b86520908180623i4e7ce5cv9a4cd6b1704a0e5f@mail.gmail.com>
In-Reply-To: <9b2b86520908180623i4e7ce5cv9a4cd6b1704a0e5f@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig876B07C481C61A2029DB961B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig876B07C481C61A2029DB961B
Content-Type: multipart/mixed;
 boundary="------------000904010606010808080406"

This is a multi-part message in MIME format.
--------------000904010606010808080406
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Alan:

Alan Jenkins wrote:
>
> Ok.  I wasn't sure that userspace was allowed to rely on that, but I
> re-read Documentation/ABI/testing/sysfs-devices and I see now that it
> can be allowed.
>
> Some of these issues with the compal-laptop work may come from copying
> dell-laptop.  dell-laptop is the only driver which creates rfkill
> devices without a parent device.  In fact, it doesn't even create a
> platform device :-).
>
> I'll try sending a patch or two to clean up dell-laptop.  I don't have
> the hardware but it should be pretty mechanical, almost a copy+paste
> job from a "good" driver.
>
>  =20
Yeah, a lot of  the source for the design issues here were from copying
bits out of dell-laptop.  I've made adjustments to this third patch to
only drop the sysfs attributes but still create the platform device.
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com

--------------000904010606010808080406
Content-Type: text/x-patch;
 name="03_drop_sysfs_stuff.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="03_drop_sysfs_stuff.diff"

--- a/drivers/platform/x86/compal-laptop.c.old	2009-08-18 01:39:12.864668=
371 -0500
+++ b/drivers/platform/x86/compal-laptop.c	2009-08-18 01:42:41.715047544 =
-0500
@@ -26,17 +26,8 @@
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
- *
- * In addition to these platform device attributes the driver
- * registers itself in the Linux backlight control subsystem and is
- * available to userspace under /sys/class/backlight/compal-laptop/.
+ * The driver registers itself with the rfkill subsystem and
+ * the Linux backlight control subsystem.
  *
  * This driver might work on other laptops produced by Compal. If you
  * want to try it you can pass force=3D1 as argument to the module which=

@@ -174,67 +165,6 @@
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
@@ -255,86 +185,6 @@
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
=20
 static struct platform_driver compal_driver =3D {
 	.driver =3D {
@@ -475,11 +325,6 @@
 	if (ret)
 		goto fail_platform_device1;
=20
-	ret =3D sysfs_create_group(&compal_device->dev.kobj,
-		&compal_attribute_group);
-	if (ret)
-		goto fail_platform_device2;
-
 	ret =3D setup_rfkill();
 	if (ret)
 		printk(KERN_WARNING "compal-laptop: Unable to setup rfkill\n");
@@ -489,10 +334,6 @@
=20
 	return 0;
=20
-fail_platform_device2:
-
-	platform_device_del(compal_device);
-
 fail_platform_device1:
=20
 	platform_device_put(compal_device);
@@ -511,7 +352,6 @@
 static void __exit compal_cleanup(void)
 {
=20
-	sysfs_remove_group(&compal_device->dev.kobj, &compal_attribute_group);
 	platform_device_unregister(compal_device);
 	platform_driver_unregister(&compal_driver);
 	backlight_device_unregister(compalbl_device);

--------------000904010606010808080406--

--------------enig876B07C481C61A2029DB961B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqK6X4ACgkQ2CrZjkA73YvoPACglTsAotD23bobQXRpGaKo/nAn
OLIAnjk4G8LX/7XZK1Z47WRa3+exN4Eu
=xj92
-----END PGP SIGNATURE-----

--------------enig876B07C481C61A2029DB961B--
