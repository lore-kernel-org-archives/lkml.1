Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658AbZHRV7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbZHRV7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbZHRV7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:59:33 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:5673 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZHRV7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:59:31 -0400
X-Loopcount0: from 10.9.160.253
Message-ID: <4A8B246D.7050004@dell.com>
Date: Tue, 18 Aug 2009 17:00:13 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090804)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>
CC: Marcel Holtmann <marcel@holtmann.org>, cezary.jackiewicz@gmail.com,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
References: <4A89E768.7010207@dell.com>	 <1250558643.30166.109.camel@localhost.localdomain>	 <9b2b86520908180044l72cb8642j6256e246662f7971@mail.gmail.com>	 <9b2b86520908180752k66feda09rf9034a96ac6ef470@mail.gmail.com>	 <4A8AE459.8060102@dell.com>	 <9b2b86520908181408v5f7875b6sea31d8d95cc08c0b@mail.gmail.com> <1250631063.16393.14.camel@johannes.local>
In-Reply-To: <1250631063.16393.14.camel@johannes.local>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig437FC89B86322BCC59133E83"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig437FC89B86322BCC59133E83
Content-Type: multipart/mixed;
 boundary="------------030208070404050209000705"

This is a multi-part message in MIME format.
--------------030208070404050209000705
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Guys:

Johannes Berg wrote:
> Hi everyone,
>
> That's a bit strange indeed, but I haven't seen the rest of the code.
>
> Does the 'soft block' bit change based on user input, like pressing a
> button?
>
> If not, you shouldn't poll that bit at all, but just set it based on
> what rfkill gives you as the return value of set_hw_state().
>
>  =20
No it doesn't, so i've followed your advice in an updated patch, Thanks.


Alan Jenkins wrote:

> ... but you *do* need to unregister wifi_rfkill here, before you go on
> to destroy it.
>
> +err_wifi:
> +	rfkill_destroy(wifi_rfkill);
> +
> +	return ret;
> +}
>
> Regards
> Alan
>  =20
I think I've addressed this properly now and only go through each of the =
error handlers as necessary.

--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com

--------------030208070404050209000705
Content-Type: text/x-patch;
 name="02_add_rfkill_support.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="02_add_rfkill_support.diff"

--- compal-laptop.c.old	2009-08-18 05:23:39.668669312 -0500
+++ compal-laptop.c	2009-08-18 05:49:00.098015155 -0500
@@ -52,6 +52,7 @@
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
 #include <linux/autoconf.h>
+#include <linux/rfkill.h>
=20
 #define COMPAL_DRIVER_VERSION "0.2.6"
=20
@@ -64,6 +65,10 @@
 #define WLAN_MASK	0x01
 #define BT_MASK 	0x02
=20
+static struct rfkill *wifi_rfkill;
+static struct rfkill *bt_rfkill;
+static struct platform_device *compal_device;
+
 static int force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
@@ -89,6 +94,84 @@
 	return (int) result;
 }
=20
+static void compal_rfkill_poll(struct rfkill *rfkill, void *data)
+{
+	unsigned long radio =3D (unsigned long) data;
+	u8 result;
+	bool hw_blocked;
+	bool sw_blocked;
+
+	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
+
+	hw_blocked =3D !(result & (KILLSWITCH_MASK | radio));
+	sw_blocked =3D rfkill_set_hw_state(rfkill, hw_blocked);
+
+	rfkill_set_sw_state(rfkill, sw_blocked);
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
+
+	if (!blocked)
+		value =3D (u8) (result | radio);
+	else
+		value =3D (u8) (result & ~radio);
+	ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
+
+	return 0;
+}
+
+static const struct rfkill_ops compal_rfkill_ops =3D {
+	.poll =3D compal_rfkill_poll,
+	.set_block =3D compal_rfkill_set,
+};
+
+static int setup_rfkill(void)
+{
+	int ret;
+
+	wifi_rfkill =3D rfkill_alloc("compal-wifi", &compal_device->dev,=20
+				RFKILL_TYPE_WLAN, &compal_rfkill_ops,=20
+				(void *) WLAN_MASK);
+	if (!wifi_rfkill)
+		return -ENOMEM;
+
+	ret =3D rfkill_register(wifi_rfkill);
+	if (ret)
+		goto err_wifi;
+
+	bt_rfkill =3D rfkill_alloc("compal-bluetooth", &compal_device->dev,=20
+				RFKILL_TYPE_BLUETOOTH, &compal_rfkill_ops,=20
+				(void *) BT_MASK);
+	if (!bt_rfkill) {
+		ret =3D -ENOMEM;
+		goto err_allocate_bt;
+	}
+	ret =3D rfkill_register(bt_rfkill);
+	if (ret)
+		goto err_register_bt;
+
+	return 0;
+
+err_register_bt:
+	rfkill_destroy(bt_rfkill);
+
+err_allocate_bt:
+	rfkill_unregister(wifi_rfkill);
+
+err_wifi:
+	rfkill_destroy(wifi_rfkill);
+
+	return ret;
+}
+
 static int set_wlan_state(int state)
 {
 	u8 result, value;
@@ -258,8 +341,6 @@
 	}
 };
=20
-static struct platform_device *compal_device;
-
 /* Initialization */
=20
 static int dmi_check_cb(const struct dmi_system_id *id)
@@ -397,6 +478,10 @@
 	if (ret)
 		goto fail_platform_device2;
=20
+	ret =3D setup_rfkill();
+	if (ret)
+		printk(KERN_WARNING "compal-laptop: Unable to setup rfkill\n");
+
 	printk(KERN_INFO "compal-laptop: driver "COMPAL_DRIVER_VERSION
 		" successfully loaded.\n");
=20
@@ -428,6 +513,10 @@
 	platform_device_unregister(compal_device);
 	platform_driver_unregister(&compal_driver);
 	backlight_device_unregister(compalbl_device);
+	rfkill_unregister(wifi_rfkill);
+	rfkill_destroy(wifi_rfkill);
+	rfkill_unregister(bt_rfkill);
+	rfkill_destroy(bt_rfkill);
=20
 	printk(KERN_INFO "compal-laptop: driver unloaded.\n");
 }

--------------030208070404050209000705--

--------------enig437FC89B86322BCC59133E83
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqLJG0ACgkQ2CrZjkA73YumIwCeIkDC2Uc3YyxTGd4icVOLFuXR
MIsAnRfG0qnWnU7a8gXhjVKhihjhpxmP
=XAFV
-----END PGP SIGNATURE-----

--------------enig437FC89B86322BCC59133E83--
