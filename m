Return-Path: <linux-kernel-owner+w=401wt.eu-S934680AbXLPQoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934680AbXLPQoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 11:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbXLPQoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 11:44:04 -0500
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:40625 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436AbXLPQoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 11:44:01 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DCbjuCcicOkgj0ArjrLc"
Date: Sun, 16 Dec 2007 16:35:28 +0000
Message-Id: <1197822928.16584.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH] Implement getgeo for Xen virtual block device.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DCbjuCcicOkgj0ArjrLc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Jeremy,

The below implements the getgeo hook for Xen block devices. Extracted
from the xen-unstable tree where it has been used for ages.

It is useful to have because it allows things like grub2 (used by the
Debian installer images) to work in a guest domain without having to
sprinkle Xen specific hacks around the place.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2bdebcb..b0a2e69 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -37,6 +37,7 @@
=20
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
+#include <linux/hdreg.h>
 #include <linux/module.h>
=20
 #include <xen/xenbus.h>
@@ -135,6 +136,22 @@ static void blkif_restart_queue_callback(void *arg)
 	schedule_work(&info->work);
 }
=20
+int blkif_getgeo(struct block_device *bd, struct hd_geometry *hg)
+{
+	/* We don't have real geometry info, but let's at least return
+	   values consistent with the size of the device */
+	sector_t nsect =3D get_capacity(bd->bd_disk);
+	sector_t cylinders =3D nsect;
+
+	hg->heads =3D 0xff;
+	hg->sectors =3D 0x3f;
+	sector_div(cylinders, hg->heads * hg->sectors);
+	hg->cylinders =3D cylinders;
+	if ((sector_t)(hg->cylinders + 1) * hg->heads * hg->sectors < nsect)
+		hg->cylinders =3D 0xffff;
+	return 0;
+}
+
 /*
  * blkif_queue_request
  *
@@ -939,6 +956,7 @@ static struct block_device_operations xlvbd_block_fops =
=3D
 	.owner =3D THIS_MODULE,
 	.open =3D blkif_open,
 	.release =3D blkif_release,
+	.getgeo =3D blkif_getgeo,
 };
=20



--=20
Ian Campbell

'Martyrdom' is the only way a person can become famous without ability.
		-- George Bernard Shaw

--=-DCbjuCcicOkgj0ArjrLc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHZVPQM0+0qS9rzVkRApNAAKCv9Eb60CmCie2uDI0GbmToocG4NQCfcpEi
+VA2U+3GS5mbaomJejeAYaM=
=H7a/
-----END PGP SIGNATURE-----

--=-DCbjuCcicOkgj0ArjrLc--

