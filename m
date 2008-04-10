Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYDJJO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYDJJO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 05:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYDJJOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 05:14:22 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:4593 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753032AbYDJJOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:14:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AscFAIN2/UfCTsYx/2dsb2JhbACBXakk
From: Laurent Pinchart <laurentp@cse-semaphore.com>
Organization: CSE Semaphore
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 19 5/5] Convert pfc8563 i2c driver from old style to new style
Date: Thu, 10 Apr 2008 11:14:15 +0200
User-Agent: KMail/1.9.5
Cc: Jon Smirl <jonsmirl@gmail.com>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
References: <20080112024737.7023.61680.stgit@terra.home> <20080112024748.7023.90680.stgit@terra.home>
In-Reply-To: <20080112024748.7023.90680.stgit@terra.home>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1317648.bgjo6COaZL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804101114.18325.laurentp@cse-semaphore.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1317648.bgjo6COaZL
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Jon,

On Saturday 12 January 2008 03:47, Jon Smirl wrote:
> Convert pfc8563 i2c driver from old style to new style. The
> driver is also modified to support device tree names via the
> i2c mod alias mechanism.

The patch breaks the pfc8563 driver.

The old style driver allocated memory for a pcf8563 structure that
encapsulated an i2c_client instance. Various functions use container_of
on an i2c_client instance to get a pointer to the pcf8563 structure.

The new style driver gets rid of the pcf8563 structure allocation, as the
i2c_client structure is now allocated by I2C code.

Here is an incremental patch that fixes the issue.

=46rom 1eac5a8e10e085c3a77c6ba7ed9dac9a39024915 Mon Sep 17 00:00:00 2001
=46rom: Laurent Pinchart <laurentp@cse-semaphore.com>
Date: Thu, 10 Apr 2008 11:12:25 +0200
Subject: [PATCH] Fix pcf8563 breakage introduced by the conversion from old=
 style to new style

The old style I2C driver used to allocate a pcf8563 instance that encapsula=
ted
an i2c_client instance. The i2c_client instance is now allocated by I2C cor=
e.

This patch fixes the driver by storing the pcf8563 instance in the I2C clie=
nt
data field.

Signed-off-by: Laurent Pinchart <laurentp@cse-semaphore.com>
=2D--
 drivers/rtc/rtc-pcf8563.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index e1ea2a0..7aab24e 100644
=2D-- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -50,7 +50,7 @@
 #define PCF8563_MO_C		0x80 /* century */
=20
 struct pcf8563 {
=2D	struct i2c_client client;
+	struct rtc_device *rtc;
 	/*
 	 * The meaning of MO_C bit varies by the chip type.
 	 * From PCF8563 datasheet: this bit is toggled when the years
@@ -74,7 +74,7 @@ struct pcf8563 {
  */
 static int pcf8563_get_datetime(struct i2c_client *client, struct rtc_time=
 *tm)
 {
=2D	struct pcf8563 *pcf8563 =3D container_of(client, struct pcf8563, client=
);
+	struct pcf8563 *pcf8563 =3D i2c_get_clientdata(client);
 	unsigned char buf[13] =3D { PCF8563_REG_ST1 };
=20
 	struct i2c_msg msgs[] =3D {
@@ -131,7 +131,7 @@ static int pcf8563_get_datetime(struct i2c_client *clie=
nt, struct rtc_time *tm)
=20
 static int pcf8563_set_datetime(struct i2c_client *client, struct rtc_time=
 *tm)
 {
=2D	struct pcf8563 *pcf8563 =3D container_of(client, struct pcf8563, client=
);
+	struct pcf8563 *pcf8563 =3D i2c_get_clientdata(client);
 	int i, err;
 	unsigned char buf[9];
=20
@@ -252,10 +252,10 @@ static const struct rtc_class_ops pcf8563_rtc_ops =3D=
 {
=20
 static int pcf8563_remove(struct i2c_client *client)
 {
=2D	struct rtc_device *rtc =3D i2c_get_clientdata(client);
+	struct pcf8563 *pcf8563 =3D i2c_get_clientdata(client);
=20
=2D	if (rtc)
=2D		rtc_device_unregister(rtc);
+	if (pcf8563->rtc)
+		rtc_device_unregister(pcf8563->rtc);
=20
 	return 0;
 }
@@ -274,26 +274,33 @@ static struct i2c_driver pcf8563_driver =3D {
 		.name	=3D "rtc-pcf8563",
 	},
 	.id		=3D I2C_DRIVERID_PCF8563,
=2D	.probe =3D &pcf8563_probe,
=2D	.remove =3D &pcf8563_remove,
+	.probe		=3D &pcf8563_probe,
+	.remove		=3D &pcf8563_remove,
 	.id_table	=3D pcf8563_id,
 };
=20
 static int pcf8563_probe(struct i2c_client *client, const struct i2c_devic=
e_id *id)
 {
=2D	int result;
+	struct pcf8563 *pcf8563;
 	struct rtc_device *rtc;
+	int result;
=20
 	result =3D pcf8563_validate_client(client);
 	if (result)
 		return result;
=20
+	if ((pcf8563 =3D kzalloc(sizeof(*pcf8563), GFP_KERNEL)) =3D=3D NULL)
+		return -ENOMEM;
+
 	rtc =3D rtc_device_register(pcf8563_driver.driver.name, &client->dev,
 				&pcf8563_rtc_ops, THIS_MODULE);
=2D	if (IS_ERR(rtc))
+	if (IS_ERR(rtc)) {
+		kfree(pcf8563);
 		return PTR_ERR(rtc);
+	}
=20
=2D	i2c_set_clientdata(client, rtc);
+	pcf8563->rtc =3D rtc;
+	i2c_set_clientdata(client, pcf8563);
=20
 	return 0;
 }
=2D-=20
1.5.0

=2D-=20
Laurent Pinchart
CSE Semaphore Belgium

Chaussee de Bruxelles, 732A
B-1410 Waterloo
Belgium

T +32 (2) 387 42 59
=46 +32 (2) 387 42 75

--nextPart1317648.bgjo6COaZL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBH/dpq8y9gWxC9vpcRAmsjAJ4g3CJ/+8xY/kocuw2EWrHYen902gCgti3Y
EtYl7MvLc8nWqd8PskVQlTw=
=7XiV
-----END PGP SIGNATURE-----

--nextPart1317648.bgjo6COaZL--
