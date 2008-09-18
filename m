Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbYIROqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbYIROqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 10:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbYIROqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 10:46:19 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:34741 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755998AbYIROqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 10:46:18 -0400
Date: Thu, 18 Sep 2008 16:46:15 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: hjk@linutronix.de, gregkh@suse.de
Subject: [PATCH] [UIO] Add alignment warnings for uio-mem
Message-ID: <20080918144615.GD4226@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zS7rBR6csb6tI2e1"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 10.1.0.71
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zS7rBR6csb6tI2e1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


mmap works page aligned. If uio-mem areas were set up unaligned, mmap
would silently align it and the corresponding attributes in sysfs would
not reflect it. This patch fixes such values during init to what the
kernel will do anyway and adds a warning.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/uio/uio.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: drivers/uio/uio.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- drivers/uio/uio.c.orig
+++ drivers/uio/uio.c
@@ -656,6 +656,8 @@
 			  struct uio_info *info)
 {
 	struct uio_device *idev;
+	struct uio_mem *mem;
+	unsigned int offset;
 	int ret =3D 0;
=20
 	if (!parent || !info || !info->name || !info->version)
@@ -691,6 +693,16 @@
 		goto err_device_create;
 	}
=20
+	for (mem =3D info->mem; mem->size; mem++) {
+		offset =3D mem->addr & ~PAGE_MASK;
+		if (offset) {
+			mem->addr -=3D offset;
+			mem->size +=3D offset;
+			dev_warn(idev->dev, "mem[%d] not page aligned!"
+				"Fixing values.\n", mem - info->mem);
+		}
+	}
+
 	ret =3D uio_dev_add_attributes(idev);
 	if (ret)
 		goto err_uio_dev_add_attributes;
--=20
  Dipl.-Ing. Wolfram Sang | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry

--zS7rBR6csb6tI2e1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFI0mm3D27XaX1/VRsRAhgIAJ47LCV8BBHen2KKwaNgLzy1GitrOQCfXRi/
IWLSXhV9e0oZGnNkO3q9SeQ=
=BiqO
-----END PGP SIGNATURE-----

--zS7rBR6csb6tI2e1--
