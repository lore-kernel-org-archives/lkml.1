Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbYGTFYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbYGTFYh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 01:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYGTFYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 01:24:30 -0400
Received: from li26-190.members.linode.com ([67.18.89.190]:47101 "EHLO
	notebook.homenet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751401AbYGTFY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 01:24:29 -0400
X-Greylist: delayed 659 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2008 01:24:28 EDT
Date: Sun, 20 Jul 2008 07:13:27 +0200
From: Tomas Styblo <tripie@cpan.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
	152d:2338
Message-ID: <20080720051326.GA5478@notebook.homenet.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zx4FCpZtqtKETZ7O
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



Hello,

this message includes a patch that provides a workaround for
a silent data corruption bug caused by incorrect error handling in
the JMicron JM20337 Hi-Speed USB to SATA & PATA Combo Bridge chipset,
USB device id 152d:2338.


- the problem occurs quite rarely, approx. once for=20
  every 20 GB of transfered data during heavy load

- it seems that only read operations are affected

- the problem is accompanied by these messages in syslog each
  time it occurs:

May 17 15:06:56 kernel: sd 6:0:0:0: [sdb] Sense Key : 0x0 [current]=20
May 17 15:06:56 kernel: sd 6:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0

- the bug is not detected as an error and incorrect data is returned,=20
  causing insidious data corruption

- tested with 3 external disk enclosures (Akasa Integral AK-ENP2SATA-BL)=20
  with different disks on different computers, with kernel 2.6.24 and 2.6.25

- the patch provides a crude workaround by detecting the error condition
  and retrying the faulty transfer


The fix needs a review as I don't know much about USB and SCSI. =20
It's possible that this approach is wrong and that the problem should
be fixed somewhere else.

There are other problems with this chipset that make it necessary=20
to disconnect and power off the enclosure from time to time, but at least
there's no data corruption anymore.


--=20
Tomas Styblo <tripie@cpan.org>
PGP: C97EA4B6 / 817E B8A8 1AFD 3256 3181  A730 85CF 7BEB C97E A4B6

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-kernel-2.6.25.9-usb-storage-jmicron-JM20337-no-sense-bugfix.patch"
Content-Transfer-Encoding: quoted-printable

--- linux-2.6.25.9/drivers/usb/storage/transport.c.orig	2008-06-24 23:09:06=
=2E000000000 +0200
+++ linux-2.6.25.9/drivers/usb/storage/transport.c	2008-07-20 05:14:32.0000=
00000 +0200
@@ -661,6 +661,21 @@ void usb_stor_invoke_transport(struct sc
 			srb->result =3D SAM_STAT_GOOD;
 			srb->sense_buffer[0] =3D 0x0;
 		}
+
+        /* JMicron JM20337 chipset bug workaround - BEGIN */
+		if (us->pusb_dev->descriptor.idVendor =3D=3D 0x152d &&=20
+            us->pusb_dev->descriptor.idProduct =3D=3D 0x2338 &&=20
+            result =3D=3D USB_STOR_TRANSPORT_FAILED &&
+			/* Filemark 0, ignore EOM, ILI 0, no sense */
+				(srb->sense_buffer[2] & 0xaf) =3D=3D 0 &&
+			/* No ASC or ASCQ */
+				srb->sense_buffer[12] =3D=3D 0 &&
+				srb->sense_buffer[13] =3D=3D 0) {
+            printk(KERN_WARNING "USB Storage - Working around the JMicron =
JM20337 chipset bug (idVendor=3D%04x, idProduct=3D%04x, NO_SENSE, ASC=3D0, =
ASCQ=3D0) - retrying the read operation\n", us->pusb_dev->descriptor.idVend=
or, us->pusb_dev->descriptor.idProduct);
+		    srb->result =3D (DID_ERROR << 16) | (SUGGEST_RETRY << 24);
+            return;
+        }
+        /* JMicron JM20337 chipset bug workaround - END */
 	}
=20
 	/* Did we transfer less than the minimum amount required? */

--ew6BAiZeqk4r7MaW--

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFIgsl2hc9768l+pLYRAoXeAJ95WUENQN3NbzCCJc40fEuGu6UDaACgmsMd
7rlyoWW3g8VgNkTXRYVhvUc=
=EkmQ
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
