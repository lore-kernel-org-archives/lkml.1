Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbZF1RE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbZF1RE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 13:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbZF1RDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 13:03:16 -0400
Received: from storm.alittletooquiet.net ([67.23.28.199]:60061 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbZF1RDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 13:03:14 -0400
Date: Sun, 28 Jun 2009 13:03:17 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <greg@kroah.com>, Larry Finger <Larry.Finger@lwfinger.net>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Woody Suwalski <woodys@xandros.com>,
       =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/8] vt6656: use net_device_ops for management functions
Message-ID: <20090628170317.GI9143@alittletooquiet.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/FJxnyttrH06HRq2"
Content-Disposition: inline
In-Reply-To: <200906281759.46152.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/FJxnyttrH06HRq2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Greg: This patch series does not differ from that which you already have.]

vt6656: use net_device_ops for management functions

Signed-off-by: Forest Bond <forest@alittletooquiet.net>
---
 drivers/staging/vt6656/hostap.c   |    7 ++++++-
 drivers/staging/vt6656/main_usb.c |   19 +++++++++++++------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hosta=
p.c
index b6ca36a..223604d 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -117,7 +117,12 @@ static int hostap_enable_hostapd(PSDevice pDevice, int=
 rtnl_locked)
     apdev_priv =3D netdev_priv(pDevice->apdev);
     *apdev_priv =3D *pDevice;
 	memcpy(pDevice->apdev->dev_addr, dev->dev_addr, ETH_ALEN);
-	pDevice->apdev->hard_start_xmit =3D pDevice->tx_80211;
+
+	const struct net_device_ops apdev_netdev_ops =3D {
+		.ndo_start_xmit         =3D pDevice->tx_80211,
+	};
+	pDevice->apdev->netdev_ops =3D &apdev_netdev_ops;
+
 	pDevice->apdev->type =3D ARPHRD_IEEE80211;
=20
 	pDevice->apdev->base_addr =3D dev->base_addr;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/mai=
n_usb.c
index 12a9ae0..228b3ec 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -837,6 +837,17 @@ static int vntwusb_resume(struct usb_interface *intf)
 }
 #endif
=20
+
+static const struct net_device_ops device_netdev_ops =3D {
+    .ndo_open               =3D device_open,
+    .ndo_stop               =3D device_close,
+    .ndo_do_ioctl           =3D device_ioctl,
+    .ndo_get_stats          =3D device_get_stats,
+    .ndo_start_xmit         =3D device_xmit,
+    .ndo_set_multicast_list =3D device_set_multi,
+};
+
+
 #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
=20
 static int
@@ -896,12 +907,8 @@ vntwusb_found1(struct usb_device *udev, UINT interface=
, const struct usb_device_
     pDevice->tx_80211 =3D device_dma0_tx_80211;
     pDevice->sMgmtObj.pAdapter =3D (PVOID)pDevice;
=20
-    netdev->open               =3D device_open;
-    netdev->hard_start_xmit    =3D device_xmit;
-    netdev->stop               =3D device_close;
-    netdev->get_stats          =3D device_get_stats;
-    netdev->set_multicast_list =3D device_set_multi;
-    netdev->do_ioctl           =3D device_ioctl;
+    netdev->netdev_ops         =3D &device_netdev_ops;
+
 #ifdef WIRELESS_EXT
=20
 //2007-0508-01<Add>by MikeLiu
--=20
1.5.6.3


--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--/FJxnyttrH06HRq2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKR6JVRO4fQQdv5AwRAohlAJ9xphGUK1H7JHbA5NRTD1ty4Eax8gCgrVgZ
dPlGFm73mO3q+xsJMOYeiXo=
=XPug
-----END PGP SIGNATURE-----

--/FJxnyttrH06HRq2--
