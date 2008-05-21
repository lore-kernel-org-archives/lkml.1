Return-Path: <linux-kernel-owner+w=401wt.eu-S936441AbYEUSHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936441AbYEUSHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbYEUSHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:07:35 -0400
Received: from deliver.hol.gr ([62.38.3.175]:36891 "EHLO deliver.hol.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbYEUSHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:07:34 -0400
X-Greylist: delayed 619 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2008 14:07:34 EDT
From: "P. Christeas" <p_christ@hol.gr>
To: Oliver Neukum <oliver@neukum.org>
Subject: Patch: usblp quirk for zebra printers
Date: Wed, 21 May 2008 20:57:49 +0300
User-Agent: KMail/1.9.9
Cc: Pete Zaitcev <zaitcev@redhat.com>, lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_fKGNIxRbmD9uRLV"
Message-Id: <200805212057.52050.p_christ@hol.gr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_fKGNIxRbmD9uRLV
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
I guess such a quirk may be a little odd, but it has been a blocking point in 
my system not being able to support more than one printer.

Please comment. (and cc. me)


--Boundary-00=_fKGNIxRbmD9uRLV
Content-Type: text/x-diff;
  charset="us-ascii";
  name="0001-USB-Quirk-for-Zebra-printers-not-reporting-their-S.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-USB-Quirk-for-Zebra-printers-not-reporting-their-S.patch"

=46rom 2c87e2cbc8d33b49b6e7a20b9b85570840bb0e12 Mon Sep 17 00:00:00 2001
=46rom: P.Christeas <p_christ@hol.gr>
Date: Wed, 21 May 2008 20:47:52 +0300
Subject: [PATCH] USB: Quirk for Zebra printers not reporting their S/N.

Those printers (and maybe others) don't report their Serial
Number as a part of their IEEE1284 device id string. Thus,
printing backends like CUPS cannot select among multiple
devices at the same host.
Workaround this situation by appending the SN in usblp.c .
=2D--
 drivers/usb/class/usblp.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index 0647164..a4d324b 100644
=2D-- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -210,6 +210,7 @@ struct quirk_printer_struct {
 #define USBLP_QUIRK_BIDIR	0x1	/* reports bidir but requires unidirectional=
 mode (no INs/reads) */
 #define USBLP_QUIRK_USB_INIT	0x2	/* needs vendor USB init string */
 #define USBLP_QUIRK_BAD_CLASS	0x4	/* descriptor uses vendor-specific Class=
 or SubClass */
+#define USBLP_QUIRK_ID_NO_SERIAL 0x8	/* Printer does not report its serial=
 no. in GET_ID request */
=20
 static const struct quirk_printer_struct quirk_printers[] =3D {
 	{ 0x03f0, 0x0004, USBLP_QUIRK_BIDIR }, /* HP DeskJet 895C */
@@ -227,6 +228,7 @@ static const struct quirk_printer_struct quirk_printers=
[] =3D {
 	{ 0x0409, 0xf1be, USBLP_QUIRK_BIDIR }, /* NEC Picty800 (HP OEM) */
 	{ 0x0482, 0x0010, USBLP_QUIRK_BIDIR }, /* Kyocera Mita FS 820, by zut <ke=
rnel@zut.de> */
 	{ 0x04b8, 0x0202, USBLP_QUIRK_BAD_CLASS }, /* Seiko Epson Receipt Printer=
 M129C */
+	{ 0x0a5f, 0x000a, USBLP_QUIRK_ID_NO_SERIAL }, /* Zebra printers don't rep=
ort their serial */
 	{ 0, 0 }
 };
=20
@@ -1330,6 +1332,23 @@ static int usblp_cache_device_id_string(struct usblp=
 *usblp)
 		length =3D 2;
 	else if (length >=3D USBLP_DEVICE_ID_SIZE)
 		length =3D USBLP_DEVICE_ID_SIZE - 1;
+=09
+	/* If printer doesn't report its serial, we append it */
+	if ((usblp->quirks & USBLP_QUIRK_ID_NO_SERIAL) && (usblp->dev->serial) &&
+		(length + strlen(usblp->dev->serial) + 5 <USBLP_DEVICE_ID_SIZE) ) {
+	=09
+		if (usblp->device_id_string[length-1] !=3D ';')
+			usblp->device_id_string[length++]=3D ';';
+
+		strcpy(&usblp->device_id_string[length],"SN:");
+		length+=3D3;
+		strcat(&usblp->device_id_string[length],usblp->dev->serial);
+		length +=3D strlen(usblp->dev->serial);
+		usblp->device_id_string[length++]=3D ';';
+
+		*((__be16 *)usblp->device_id_string) =3D cpu_to_be16(length);
+	}
+=09
 	usblp->device_id_string[length] =3D '\0';
=20
 	dbg("usblp%d Device ID string [len=3D%d]=3D\"%s\"",
=2D-=20
1.5.4.3


--Boundary-00=_fKGNIxRbmD9uRLV--
