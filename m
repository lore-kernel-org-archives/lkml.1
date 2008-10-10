Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbYJJHm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbYJJHm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 03:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYJJHmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 03:42:14 -0400
Received: from flock1.newmail.ru ([82.204.219.207]:42259 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752110AbYJJHmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 03:42:13 -0400
From: Andrey Borzenkov <arvidjaar@newmail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic loading firmware with PCMCIA adapter
Date: Fri, 10 Oct 2008 11:41:37 +0400
User-Agent: KMail/1.9.10
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200810091722.56812.arvidjaar@newmail.ru> <200810092321.55033.arvidjaar@newmail.ru> <48EE89ED.3050309@gmail.com>
In-Reply-To: <48EE89ED.3050309@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1858793.2UlJZDQuiS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810101141.38929.arvidjaar@newmail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1858793.2UlJZDQuiS
Content-Type: multipart/mixed;
  boundary="Boundary-01=_ycw7Io7cC/CHOhG"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_ycw7Io7cC/CHOhG
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 10 October 2008, Dave wrote:
> Thanks for identifying the problem. The Agere case looks good - a few sug=
gestions for the Symbol case though:

Updated patch attached

> =20
> But you absolutely have to kfree(pda) here.

Yes, I forgot; sorry.

> Dan Williams wrote:
> > maybe you should not use priv->pda_size but
> > #define SYMBOL_PDA_SIZE 256 and use that for the hermes_read_pda()
> > length just to ensure the patched code is functionally the same as
> > before the patch.
>=20
> Using fw->pda_size should be fine. The value comes from a const static, s=
et to 0x100 for Symbol.
>=20

Actually it allocated 512 byte before. Should it probably be set to 0x200?

--Boundary-01=_ycw7Io7cC/CHOhG
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="orinoco-reduce-stack-usage"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="orinoco-reduce-stack-usage"

Subject: [PATCH] orinoco: reduce stack usage in firmware download path
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

orinoco_dl_firmware and symbol_dl_mage allocate large local
variables (1K); at least orinoco fails with panic or hung
kernel if 4K stacks is enabled.

Allocate large buffers dynamically at run time.

Tested-By: Andrey Borzenkov <arvidjaar@mail.ru> for Agere case
Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/net/wireless/orinoco.c |   40 ++++++++++++++++++++++++++++--------=
=2D---
 1 files changed, 28 insertions(+), 12 deletions(-)


diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 9a2fcc0..e225fec 100644
=2D-- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -458,7 +458,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 		    int ap)
 {
 	/* Plug Data Area (PDA) */
=2D	__le16 pda[512] =3D { 0 };
+	__le16 *pda;
=20
 	hermes_t *hw =3D &priv->hw;
 	const struct firmware *fw_entry;
@@ -467,7 +467,11 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	const unsigned char *end;
 	const char *firmware;
 	struct net_device *dev =3D priv->ndev;
=2D	int err;
+	int err =3D 0;
+
+	pda =3D kzalloc(fw->pda_size, GFP_KERNEL);
+	if (!pda)
+		return -ENOMEM;
=20
 	if (ap)
 		firmware =3D fw->ap_fw;
@@ -478,17 +482,17 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	       dev->name, firmware);
=20
 	/* Read current plug data */
=2D	err =3D hermes_read_pda(hw, pda, fw->pda_addr,
=2D			      min_t(u16, fw->pda_size, sizeof(pda)), 0);
+	err =3D hermes_read_pda(hw, pda, fw->pda_addr, fw->pda_size, 0);
 	printk(KERN_DEBUG "%s: Read PDA returned %d\n", dev->name, err);
 	if (err)
=2D		return err;
+		goto free;
=20
 	err =3D request_firmware(&fw_entry, firmware, priv->dev);
 	if (err) {
 		printk(KERN_ERR "%s: Cannot find firmware %s\n",
 		       dev->name, firmware);
=2D		return -ENOENT;
+		err =3D -ENOENT;
+		goto free;
 	}
=20
 	hdr =3D (const struct orinoco_fw_header *) fw_entry->data;
@@ -532,6 +536,9 @@ orinoco_dl_firmware(struct orinoco_private *priv,
=20
 abort:
 	release_firmware(fw_entry);
+
+free:
+	kfree(pda);
 	return err;
 }
=20
@@ -549,12 +556,12 @@ symbol_dl_image(struct orinoco_private *priv, const s=
truct fw_info *fw,
 		int secondary)
 {
 	hermes_t *hw =3D &priv->hw;
=2D	int ret;
+	int ret =3D 0;
 	const unsigned char *ptr;
 	const unsigned char *first_block;
=20
 	/* Plug Data Area (PDA) */
=2D	__le16 pda[256];
+	__le16 *pda =3D NULL;
=20
 	/* Binary block begins after the 0x1A marker */
 	ptr =3D image;
@@ -563,28 +570,33 @@ symbol_dl_image(struct orinoco_private *priv, const s=
truct fw_info *fw,
=20
 	/* Read the PDA from EEPROM */
 	if (secondary) {
=2D		ret =3D hermes_read_pda(hw, pda, fw->pda_addr, sizeof(pda), 1);
+		pda =3D kzalloc(fw->pda_size, GFP_KERNEL);
+		if (!pda)
+			return -ENOMEM;
+
+		ret =3D hermes_read_pda(hw, pda, fw->pda_addr, fw->pda_size, 1);
 		if (ret)
=2D			return ret;
+			goto free;
 	}
=20
 	/* Stop the firmware, so that it can be safely rewritten */
 	if (priv->stop_fw) {
 		ret =3D priv->stop_fw(priv, 1);
 		if (ret)
=2D			return ret;
+			goto free;
 	}
=20
 	/* Program the adapter with new firmware */
 	ret =3D hermes_program(hw, first_block, end);
 	if (ret)
=2D		return ret;
+		goto free;
=20
 	/* Write the PDA to the adapter */
 	if (secondary) {
 		size_t len =3D hermes_blocks_length(first_block);
 		ptr =3D first_block + len;
 		ret =3D hermes_apply_pda(hw, ptr, pda);
+		kfree(pda);
 		if (ret)
 			return ret;
 	}
@@ -608,6 +620,10 @@ symbol_dl_image(struct orinoco_private *priv, const st=
ruct fw_info *fw,
 		return -ENODEV;
=20
 	return 0;
+
+free:
+	kfree(pda);
+	return ret;
 }
=20
=20

--Boundary-01=_ycw7Io7cC/CHOhG--

--nextPart1858793.2UlJZDQuiS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjvBzIACgkQR6LMutpd94zw9ACguVeROiv9a39E3HrE0N88DkPP
/osAn0O/9FXZ9fxS/9Z1JuBaUA58h3ZL
=nTQc
-----END PGP SIGNATURE-----

--nextPart1858793.2UlJZDQuiS--
