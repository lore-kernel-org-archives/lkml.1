Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbYJITWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbYJITWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbYJITWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:22:38 -0400
Received: from flock1.newmail.ru ([82.204.219.207]:49166 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757863AbYJITWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:22:36 -0400
From: Andrey Borzenkov <arvidjaar@newmail.ru>
To: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic loading firmware with PCMCIA adapter
Date: Thu, 9 Oct 2008 23:21:53 +0400
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200810091722.56812.arvidjaar@newmail.ru> <200810091959.54987.arvidjaar@newmail.ru> <1223568410.18104.42.camel@dhcp-100-3-195.bos.redhat.com>
In-Reply-To: <1223568410.18104.42.camel@dhcp-100-3-195.bos.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1718895.v5WrQahxS3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810092321.55033.arvidjaar@newmail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1718895.v5WrQahxS3
Content-Type: multipart/mixed;
  boundary="Boundary-01=_Snl7IyNyxisZ9mm"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_Snl7IyNyxisZ9mm
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 09 October 2008, Dan Williams wrote:
>=20
> On Thu, 2008-10-09 at 19:59 +0400, Andrey Borzenkov wrote:
> > On Thursday 09 October 2008, Matthew Wilcox wrote:
> > >=20
> > > On Thu, Oct 09, 2008 at 05:22:55PM +0400, Andrey Borzenkov wrote:
> > > > After loading orinoco and "inserting" adapter I get either BUG with
> > > > endless loop (attached) or kernel panic on NULL pointer dereference
> > > > (was not able capture). Adapter works fine with wlags49 driver.
> > >=20
> > > It looks like you've fallen off the bottom of the kernel stack.  Do y=
ou
> > > have 4k stacks enabled in your config?
> > >=20
> >=20
> > You are right. Using 8K stacks load and runs fine. Hmm ... not nice
> > from it :p
>=20
> =3D=3D driver bug; the driver should not require large stacks and this
> should get fixed.
>=20

The attached patch fixes 4K stack for me. I have not tested spectrum case.

=2Dandrey

--Boundary-01=_Snl7IyNyxisZ9mm
Content-Type: text/x-diff;
  charset="utf-8";
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

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/net/wireless/orinoco.c |   50 ++++++++++++++++++++++++++----------=
=2D---
 1 files changed, 32 insertions(+), 18 deletions(-)


diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 9a2fcc0..2b87d0b 100644
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
@@ -549,12 +556,16 @@ symbol_dl_image(struct orinoco_private *priv, const s=
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
+	__le16 *pda;
+
+	pda =3D kzalloc(fw->pda_size, GFP_KERNEL);
+	if (!pda)
+		return -ENOMEM;
=20
 	/* Binary block begins after the 0x1A marker */
 	ptr =3D image;
@@ -563,22 +574,22 @@ symbol_dl_image(struct orinoco_private *priv, const s=
truct fw_info *fw,
=20
 	/* Read the PDA from EEPROM */
 	if (secondary) {
=2D		ret =3D hermes_read_pda(hw, pda, fw->pda_addr, sizeof(pda), 1);
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
@@ -586,28 +597,31 @@ symbol_dl_image(struct orinoco_private *priv, const s=
truct fw_info *fw,
 		ptr =3D first_block + len;
 		ret =3D hermes_apply_pda(hw, ptr, pda);
 		if (ret)
=2D			return ret;
+			goto free;
 	}
=20
 	/* Run the firmware */
 	if (priv->stop_fw) {
 		ret =3D priv->stop_fw(priv, 0);
 		if (ret)
=2D			return ret;
+			goto free;
 	}
=20
 	/* Reset hermes chip and make sure it responds */
 	ret =3D hermes_init(hw);
=20
 	/* hermes_reset() should return 0 with the secondary firmware */
=2D	if (secondary && ret !=3D 0)
=2D		return -ENODEV;
+	if (secondary && ret !=3D 0) {
+		ret =3D -ENODEV;
+		goto free;
+	}
=20
 	/* And this should work with any firmware */
 	if (!hermes_present(hw))
=2D		return -ENODEV;
+		ret =3D -ENODEV;
=20
=2D	return 0;
+free:
+	return ret;
 }
=20
=20

--Boundary-01=_Snl7IyNyxisZ9mm--

--nextPart1718895.v5WrQahxS3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjuWdIACgkQR6LMutpd94yoJgCfReCtZb7zuU5ESXEM4O5x9ir2
PfUAn2sI3SS4ih6Fiy71FUOEokBrodEP
=ux6z
-----END PGP SIGNATURE-----

--nextPart1718895.v5WrQahxS3--
