Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbYC1M5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbYC1M5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758472AbYC1Mzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:55:33 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34541 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758446AbYC1Mza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:55:30 -0400
Date: Fri, 28 Mar 2008 07:27:34 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 29/35] W1: ds2490.c ds_dump_status rework
Message-ID: <20080328122734.GD3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h+CsNYkJBPxpZ+B/"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:27:34 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h+CsNYkJBPxpZ+B/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

add result register #defines
rename ds_dump_status to ds_print_msg
rename ds_recv_status to ds_dump_status
ds_dump_status prints the requested status and no longer reads the
status

ds_2490.c 1.16
rename ds_dump_status to ds_print_msg
ds_print_msg is more appropriate, it is only a wrapper around printk
rename ds_recv_status to ds_dump_status

ds_recv_status would first read a new status message, then print it.
The problem is ds_recv_status was only being called if there was an
error, so it could print the error status.  If the error was cleared,
then the good status message was dumped instead of the one in error.
ds_dump_status now is passed a status value to print.

ds_dump_status now will print the result register in addition to the
status buffer.  For now that will be limited to detecting new devices.
It could include detecting a short and other status indicators, but
the reset command would need to enable generating the result
information and more logic to only print the useful bits.  Printing
the extended result register also required being passed the status, as
a second status read would loose these bytes.

Resetting ST_EPOF was moved to ds_wait_status so it could be cleared
sooner as under normal operation there is never so many commands as to
fill up the command buffer.

ds_wait_status will not treat extra data in the status request as an
error, it will call ds_dump_status when there is extra data though.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/masters/ds2490.c |  129 +++++++++++++++++++++++++++------------=
----
 1 files changed, 81 insertions(+), 48 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 45e7f10..1e04ee4 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -107,6 +107,17 @@
 #define ST_IDLE				0x20  /* DS2490 is currently idle */
 #define ST_EPOF				0x80
=20
+/* Result Register flags */
+#define RR_DETECT			0xA5 /* New device detected */
+#define RR_NRS				0x01 /* Reset no presence or ... */
+#define RR_SH				0x02 /* short on reset or set path */
+#define RR_APP				0x04 /* alarming presence on reset */
+#define RR_VPP				0x08 /* 12V expected not seen */
+#define RR_CMP				0x10 /* compare error */
+#define RR_CRC				0x20 /* CRC error detected */
+#define RR_RDP				0x40 /* redirected page */
+#define RR_EOS				0x80 /* end of search error */
+
 #define SPEED_NORMAL			0x00
 #define SPEED_FLEXIBLE			0x01
 #define SPEED_OVERDRIVE			0x02
@@ -164,7 +175,6 @@ MODULE_DEVICE_TABLE(usb, ds_id_table);
 static int ds_probe(struct usb_interface *, const struct usb_device_id *);
 static void ds_disconnect(struct usb_interface *);
=20
-static inline void ds_dump_status(unsigned char *, unsigned char *, int);
 static int ds_send_control(struct ds_device *, u16, u16);
 static int ds_send_control_cmd(struct ds_device *, u16, u16);
=20
@@ -223,11 +233,6 @@ static int ds_send_control(struct ds_device *dev, u16 =
value, u16 index)
 	return err;
 }
=20
-static inline void ds_dump_status(unsigned char *buf, unsigned char *str, =
int off)
-{
-	printk("%45s: %8x\n", str, buf[off]);
-}
-
 static int ds_recv_status_nodump(struct ds_device *dev, struct ds_status *=
st,
 				 unsigned char *buf, int size)
 {
@@ -248,16 +253,14 @@ static int ds_recv_status_nodump(struct ds_device *de=
v, struct ds_status *st,
 	return count;
 }
=20
-static int ds_recv_status(struct ds_device *dev, struct ds_status *st)
+static inline void ds_print_msg(unsigned char *buf, unsigned char *str, in=
t off)
 {
-	unsigned char buf[64];
-	int count, err =3D 0, i;
-
-	memcpy(st, buf, sizeof(*st));
+	printk("%45s: %8x\n", str, buf[off]);
+}
=20
-	count =3D ds_recv_status_nodump(dev, st, buf, sizeof(buf));
-	if (count < 0)
-		return err;
+static void ds_dump_status(struct ds_device *dev, unsigned char *buf, int =
count)
+{
+	int i;
=20
 	printk("0x%x: count=3D%d, status: ", dev->ep[EP_STATUS], count);
 	for (i=3D0; i<count; ++i)
@@ -265,37 +268,46 @@ static int ds_recv_status(struct ds_device *dev, stru=
ct ds_status *st)
 	printk("\n");
=20
 	if (count >=3D 16) {
-		ds_dump_status(buf, "enable flag", 0);
-		ds_dump_status(buf, "1-wire speed", 1);
-		ds_dump_status(buf, "strong pullup duration", 2);
-		ds_dump_status(buf, "programming pulse duration", 3);
-		ds_dump_status(buf, "pulldown slew rate control", 4);
-		ds_dump_status(buf, "write-1 low time", 5);
-		ds_dump_status(buf, "data sample offset/write-0 recovery time", 6);
-		ds_dump_status(buf, "reserved (test register)", 7);
-		ds_dump_status(buf, "device status flags", 8);
-		ds_dump_status(buf, "communication command byte 1", 9);
-		ds_dump_status(buf, "communication command byte 2", 10);
-		ds_dump_status(buf, "communication command buffer status", 11);
-		ds_dump_status(buf, "1-wire data output buffer status", 12);
-		ds_dump_status(buf, "1-wire data input buffer status", 13);
-		ds_dump_status(buf, "reserved", 14);
-		ds_dump_status(buf, "reserved", 15);
+		ds_print_msg(buf, "enable flag", 0);
+		ds_print_msg(buf, "1-wire speed", 1);
+		ds_print_msg(buf, "strong pullup duration", 2);
+		ds_print_msg(buf, "programming pulse duration", 3);
+		ds_print_msg(buf, "pulldown slew rate control", 4);
+		ds_print_msg(buf, "write-1 low time", 5);
+		ds_print_msg(buf, "data sample offset/write-0 recovery time", 6);
+		ds_print_msg(buf, "reserved (test register)", 7);
+		ds_print_msg(buf, "device status flags", 8);
+		ds_print_msg(buf, "communication command byte 1", 9);
+		ds_print_msg(buf, "communication command byte 2", 10);
+		ds_print_msg(buf, "communication command buffer status", 11);
+		ds_print_msg(buf, "1-wire data output buffer status", 12);
+		ds_print_msg(buf, "1-wire data input buffer status", 13);
+		ds_print_msg(buf, "reserved", 14);
+		ds_print_msg(buf, "reserved", 15);
 	}
-
-	memcpy(st, buf, sizeof(*st));
-
-	if (st->status & ST_EPOF) {
-		printk(KERN_INFO "Resetting device after ST_EPOF.\n");
-		err =3D ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
-		if (err)
-			return err;
-		count =3D ds_recv_status_nodump(dev, st, buf, sizeof(buf));
-		if (count < 0)
-			return err;
+	for(i=3D16; i<count; ++i) {
+		if(buf[i]=3D=3DRR_DETECT) {
+			ds_print_msg(buf, "new device detect", i);
+			continue;
+		}
+		ds_print_msg(buf, "Result Register Value: ", i);
+		if(buf[i] & RR_NRS)
+			printk("NRS: Reset no presence or ...\n");
+		if(buf[i] & RR_SH)
+			printk("SH: short on reset or set path\n");
+		if(buf[i] & RR_APP)
+			printk("APP: alarming presence on reset\n");
+		if(buf[i] & RR_VPP)
+			printk("VPP: 12V expected not seen\n");
+		if(buf[i] & RR_CMP)
+			printk("CMP: compare error\n");
+		if(buf[i] & RR_CRC)
+			printk("CRC: CRC error detected\n");
+		if(buf[i] & RR_RDP)
+			printk("RDP: redirected page\n");
+		if(buf[i] & RR_EOS)
+			printk("EOS: end of search error\n");
 	}
-
-	return err;
 }
=20
 static int ds_recv_data(struct ds_device *dev, unsigned char *buf, int siz=
e)
@@ -307,9 +319,14 @@ static int ds_recv_data(struct ds_device *dev, unsigne=
d char *buf, int size)
 	err =3D usb_bulk_msg(dev->udev, usb_rcvbulkpipe(dev->udev, dev->ep[EP_DAT=
A_IN]),
 				buf, size, &count, 1000);
 	if (err < 0) {
+		u8 buf[0x20];
+		int count;
+
 		printk(KERN_INFO "Clearing ep0x%x.\n", dev->ep[EP_DATA_IN]);
 		usb_clear_halt(dev->udev, usb_rcvbulkpipe(dev->udev, dev->ep[EP_DATA_IN]=
));
-		ds_recv_status(dev, &st);
+
+		count=3Dds_recv_status_nodump(dev, &st, buf, sizeof(buf));
+		ds_dump_status(dev, buf, count);
 		return err;
 	}
=20
@@ -390,7 +407,7 @@ int ds_detect(struct ds_device *dev, struct ds_status *=
st)
 	if (err)
 		return err;
=20
-	err =3D ds_recv_status(dev, st);
+	err =3D ds_dump_status(dev, st);
=20
 	return err;
 }
@@ -415,11 +432,27 @@ static int ds_wait_status(struct ds_device *dev, stru=
ct ds_status *st)
 #endif
 	} while(!(buf[0x08] & 0x20) && !(err < 0) && ++count < 100);
=20
+	if(err>=3D16 && st->status & ST_EPOF) {
+		printk(KERN_INFO "Resetting device after ST_EPOF.\n");
+		ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+		/* Always dump the device status. */
+		count=3D101;
+	}
+
+	/* Dump the status for errors or if there is extended return data.
+	 * The extended status includes new device detection (maybe someone
+	 * can do something with it).
+	 */
+	if(err > 16 || count >=3D 100 || err < 0)
+		ds_dump_status(dev, buf, err);
=20
-	if (((err > 16) && (buf[0x10] & 0x01)) || count >=3D 100 || err < 0) {
-		ds_recv_status(dev, st);
+	/* Extended data isn't an error.  Well, a short is, but the dump
+	 * would have already told the user that and we can't do anything
+	 * about it in software anyway.
+	 */
+	if(count >=3D 100 || err < 0)
 		return -1;
-	} else
+	else
 		return 0;
 }
=20
--=20
1.4.4.4

--h+CsNYkJBPxpZ+B/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OQ2AI852cse6PARAjG9AJ9+0sziSq0iDI6+01MnWtoOeMBdfwCfaedc
IXSvcjaeE6SuVFIMubFT8Ao=
=3a9D
-----END PGP SIGNATURE-----

--h+CsNYkJBPxpZ+B/--
