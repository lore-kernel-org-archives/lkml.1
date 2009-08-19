Return-Path: <linux-kernel-owner+w=401wt.eu-S1752942AbZHSQp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbZHSQp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZHSQp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:45:57 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:12291 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbZHSQpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:45:55 -0400
Message-ID: <4A8C2C6C.2020007@dell.com>
Date: Wed, 19 Aug 2009 11:46:36 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090804)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Marcel Holtmann <marcel@holtmann.org>, cezary.jackiewicz@gmail.com,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
References: <4A89E768.7010207@dell.com>	 <1250558643.30166.109.camel@localhost.localdomain>	 <9b2b86520908180044l72cb8642j6256e246662f7971@mail.gmail.com>	 <9b2b86520908180752k66feda09rf9034a96ac6ef470@mail.gmail.com>	 <4A8AE459.8060102@dell.com>	 <9b2b86520908181408v5f7875b6sea31d8d95cc08c0b@mail.gmail.com>	 <1250631063.16393.14.camel@johannes.local>  <4A8B246D.7050004@dell.com> <1250672475.25419.7.camel@johannes.local>
In-Reply-To: <1250672475.25419.7.camel@johannes.local>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2575055CE8844968B0CA0188"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2575055CE8844968B0CA0188
Content-Type: multipart/mixed;
 boundary="------------000501090302000407000407"

This is a multi-part message in MIME format.
--------------000501090302000407000407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Johannes:

Thanks for looking.

Johannes Berg wrote:
> Ah, heh, thanks Alan for pointing out there was a patch here :)
>
>  =20
>
> I don't quite understand the "| radio" bit since that seems to be the
> soft kill bit according to rfkill_set()?
>  =20
Yeah you're right, this bit was unnecessary.  I pulled it out.
> Anyhow, here you reject the request to set the soft bit. I suspect you
> could let it go through but it would only change the soft bit in the
> BIOS, nothing else really.
>
> Two options:
> 1) You can let it go though, in that case do that, and remove the sw
>    block stuff from poll() completely.
>
> 2) You can't let it go through. In this case, you need to leave set as
>    it is, but implement poll like this:
>
> 	sw_block =3D rfkill_set_hw_state(rfkill, hw_blocked);
> 	compal_rfkill_set(data, sw_block);
>
> so that when the user soft-blocks the device while hard-blocked, the
> soft block is still honoured after pushing the button on the laptop.
>
>  =20
OK, the second option sounds more desirable, so I've implemented that.

--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com

--------------000501090302000407000407
Content-Type: text/x-patch;
 name="02_add_rfkill_support.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="02_add_rfkill_support.diff"

=46rom 5f5dc9c1adf041418c6dd273cd4ee83d5ae96e74 Mon Sep 17 00:00:00 2001
From: Mario Limonciello <Mario_Limonciello@Dell.com>
Date: Wed, 19 Aug 2009 11:41:27 -0500
Subject: [PATCH 2/3] Add rfkill support to compal-laptop

Signed-off-by: Mario Limonciello <Mario_Limonciello@Dell.com>
Reviewed-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/platform/x86/compal-laptop.c |   91 ++++++++++++++++++++++++++++=
+++++-
 1 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/=
compal-laptop.c
index 11003bb..d997de5 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
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
@@ -89,6 +94,82 @@ static int get_lcd_level(void)
 	return (int) result;
 }
=20
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
+static void compal_rfkill_poll(struct rfkill *rfkill, void *data)
+{
+	u8 result;
+	bool hw_blocked;
+	bool sw_blocked;
+
+	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
+
+	hw_blocked =3D !(result & KILLSWITCH_MASK);
+	sw_blocked =3D rfkill_set_hw_state(rfkill, hw_blocked);
+	compal_rfkill_set(data,sw_blocked);
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
+	wifi_rfkill =3D rfkill_alloc("compal-wifi", &compal_device->dev,
+				RFKILL_TYPE_WLAN, &compal_rfkill_ops,
+				(void *) WLAN_MASK);
+	if (!wifi_rfkill)
+		return -ENOMEM;
+
+	ret =3D rfkill_register(wifi_rfkill);
+	if (ret)
+		goto err_wifi;
+
+	bt_rfkill =3D rfkill_alloc("compal-bluetooth", &compal_device->dev,
+				RFKILL_TYPE_BLUETOOTH, &compal_rfkill_ops,
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
@@ -258,8 +339,6 @@ static struct platform_driver compal_driver =3D {
 	}
 };
=20
-static struct platform_device *compal_device;
-
 /* Initialization */
=20
 static int dmi_check_cb(const struct dmi_system_id *id)
@@ -356,6 +435,10 @@ static int __init compal_init(void)
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
@@ -387,6 +470,10 @@ static void __exit compal_cleanup(void)
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
--=20
1.6.3.3


--------------000501090302000407000407--

--------------enig2575055CE8844968B0CA0188
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqMLGwACgkQ2CrZjkA73Yu0gACeMgUrMOa31WzD/2PwR2PArWII
dacAnRS/uB4amCL2Z8pjP0nsAbwG9Cjf
=Ckqe
-----END PGP SIGNATURE-----

--------------enig2575055CE8844968B0CA0188--
