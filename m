Return-Path: <linux-kernel-owner+w=401wt.eu-S1761984AbYJJQW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761984AbYJJQW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759177AbYJJQWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:22:51 -0400
Received: from mx6.mail.ru ([194.67.23.26]:30947 "EHLO mx6.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbYJJQWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:22:50 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: [PATCH] orinoco: fix unsafe locking in orinoco_cs_resume
Date: Fri, 10 Oct 2008 20:22:38 +0400
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1268004.vNcsZMcn5o";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810102022.40027.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1268004.vNcsZMcn5o
Content-Type: multipart/mixed;
  boundary="Boundary-01=_PF47IvCmp1+bR/4"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_PF47IvCmp1+bR/4
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Attached patch should fixe lockdep warning. Unfortunately it is rather
hard to trigger on purpose.

--Boundary-01=_PF47IvCmp1+bR/4
Content-Type: text/x-diff;
  charset="us-ascii";
  name="orinoco-fix-unafe-locking-in-orinoco_cs_resume"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="orinoco-fix-unafe-locking-in-orinoco_cs_resume"

Subject: [PATCH] orinoco: fix unsafe locking in orinoco_cs_resume
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

[ 6972.562035] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 6972.562040] [ INFO: inconsistent lock state ]
[ 6972.562048] 2.6.27-1avb #17
[ 6972.562053] ---------------------------------
[ 6972.562060] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
[ 6972.562068] pm-suspend/17062 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 6972.562076]  (&priv->lock){++..}, at: [<dfd4f05b>] orinoco_cs_resume+0x5=
b/0xd0 [orinoco_cs]
[ 6972.562122] {in-hardirq-W} state was registered at:
[ 6972.562128]   [<c013ea6b>] __lock_acquire+0x6cb/0x1640
[ 6972.562171]   [<c013fa3c>] lock_acquire+0x5c/0x80
[ 6972.562181]   [<c02f6e39>] _spin_lock_irqsave+0x49/0x80
[ 6972.562210]   [<dfd6425d>] orinoco_interrupt+0x4d/0x16d0 [orinoco]
[ 6972.562257]   [<c015a2b1>] handle_IRQ_event+0x31/0x60
[ 6972.562278]   [<c015b73e>] handle_level_irq+0x6e/0xe0
[ 6972.562291]   [<c0104b20>] do_IRQ+0xb0/0x130
[ 6972.562313]   [<ffffffff>] 0xffffffff

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/net/wireless/orinoco_cs.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/drivers/net/wireless/orinoco_cs.c b/drivers/net/wireless/orino=
co_cs.c
index 1ccf5a4..6fc2209 100644
=2D-- a/drivers/net/wireless/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco_cs.c
@@ -403,6 +403,7 @@ static int orinoco_cs_resume(struct pcmcia_device *link)
 	struct orinoco_private *priv =3D netdev_priv(dev);
 	struct orinoco_pccard *card =3D priv->card;
 	int err =3D 0;
+	unsigned long flags;
=20
 	if (! test_bit(0, &card->hard_reset_in_progress)) {
 		err =3D orinoco_reinit_firmware(dev);
@@ -412,7 +413,7 @@ static int orinoco_cs_resume(struct pcmcia_device *link)
 			return -EIO;
 		}
=20
=2D		spin_lock(&priv->lock);
+		spin_lock_irqsave(&priv->lock, flags);
=20
 		netif_device_attach(dev);
 		priv->hw_unavailable--;
@@ -424,7 +425,7 @@ static int orinoco_cs_resume(struct pcmcia_device *link)
 				       dev->name, err);
 		}
=20
=2D		spin_unlock(&priv->lock);
+		spin_unlock_irqrestore(&priv->lock, flags);
 	}
=20
 	return err;

--Boundary-01=_PF47IvCmp1+bR/4--

--nextPart1268004.vNcsZMcn5o
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjvgU8ACgkQR6LMutpd94z5PgCgyfvbpQGNoL38PX26uOOstfhj
UQ0An1q2z2nSjbb59EGPuViuHPOR8h4A
=Iett
-----END PGP SIGNATURE-----

--nextPart1268004.vNcsZMcn5o--
