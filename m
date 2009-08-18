Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbZHRR0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbZHRR0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbZHRR0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:26:09 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:14383 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbZHRR0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:26:08 -0400
X-Loopcount0: from 10.9.160.253
Message-ID: <4A8AE459.8060102@dell.com>
Date: Tue, 18 Aug 2009 12:26:49 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090804)
MIME-Version: 1.0
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
CC: Marcel Holtmann <marcel@holtmann.org>, cezary.jackiewicz@gmail.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
References: <4A89E768.7010207@dell.com>	 <1250558643.30166.109.camel@localhost.localdomain>	 <9b2b86520908180044l72cb8642j6256e246662f7971@mail.gmail.com> <9b2b86520908180752k66feda09rf9034a96ac6ef470@mail.gmail.com>
In-Reply-To: <9b2b86520908180752k66feda09rf9034a96ac6ef470@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig636105176039FD4839FF816F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig636105176039FD4839FF816F
Content-Type: multipart/mixed;
 boundary="------------000307070207010402050108"

This is a multi-part message in MIME format.
--------------000307070207010402050108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Alan & Marcel:

Alan Jenkins wrote:
> Also, you're missing the calls to rfkill_destroy() here.
>
> Whew, I think that's everything.  I hope you find the feedback useful,
> despite it being a little fragmented.
>
>  =20
Thanks for all the feedback.  I think i've addressed all of the concerns
that were pointed out.  I appreciate the pointer to scripts/cleanpatch,
that does significantly help in finding whitespace problems that the
naked eye just browses over.

I'm attaching the updated patch (sorry, git send-email seems to still
not be very graceful with line breaks when the SMTP implementation is
exchange from what i've seen)
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com

--------------000307070207010402050108
Content-Type: text/x-patch;
 name="02_add_rfkill_support.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="02_add_rfkill_support.diff"

--- compal-laptop.old	2009-08-18 00:17:43.056669380 -0500
+++ compal-laptop.c	2009-08-18 01:23:33.485833067 -0500
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
@@ -89,6 +94,86 @@
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
+	hw_blocked =3D !(result & KILLSWITCH_MASK);
+	sw_blocked =3D (!hw_blocked && !(result & radio));
+
+	rfkill_set_states(rfkill, sw_blocked, hw_blocked);
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
+	if (!wifi_rfkill) {
+		ret =3D -ENOMEM;
+		goto err_wifi;
+	}
+	ret =3D rfkill_register(wifi_rfkill);
+	if (ret) {
+		rfkill_unregister(wifi_rfkill);
+		goto err_wifi;
+	}
+
+	bt_rfkill =3D rfkill_alloc("compal-bluetooth", &compal_device->dev,=20
+				RFKILL_TYPE_BLUETOOTH, &compal_rfkill_ops,=20
+				(void *) BT_MASK);
+	if (!bt_rfkill) {
+		ret =3D -ENOMEM;
+		goto err_bt;
+	}
+	ret =3D rfkill_register(bt_rfkill);
+	if (ret) {
+		rfkill_unregister(bt_rfkill);
+		goto err_bt;
+	}
+
+	return 0;
+
+err_bt:
+	rfkill_destroy(bt_rfkill);
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
@@ -258,8 +343,6 @@
 	}
 };
=20
-static struct platform_device *compal_device;
-
 /* Initialization */
=20
 static int dmi_check_cb(const struct dmi_system_id *id)
@@ -389,6 +472,10 @@
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
@@ -420,6 +507,10 @@
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

--------------000307070207010402050108--

--------------enig636105176039FD4839FF816F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqK5FkACgkQ2CrZjkA73YtPTwCgjrt13H+uT32DfODJfgLKR/x5
t1IAn1QfxJn1goQOTBWEmDGG+Nqug+6Q
=8tVx
-----END PGP SIGNATURE-----

--------------enig636105176039FD4839FF816F--
