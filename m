Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbZFZXIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbZFZXIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 19:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZFZXIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 19:08:04 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:40713 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZFZXID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 19:08:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer;
        b=S72pgV9X2GwVFoBEFE5SuJ/Xu1VCY656C9cGlfWaOhbI1CR0TZYYiDc46OIt6d/645
         GVjOwQpyiScDG/K8hpahr+6T0LRh/HrbrP4zoXbG7/AlvVXSbn5jkptIoID4ZaV75bZJ
         BkeMKnS/HLnaIpAiZuztrrdJ3NPI3PbKRdJzY=
Subject: [PATCH 1/2] MMC/pxamci: workaround regulator framework bugs
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, Mark Brown <broonie@sirena.org.uk>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pGeWg9I6cNiE+MAme8uW"
Date: Fri, 26 Jun 2009 20:07:48 -0300
Message-Id: <1246057668.10360.316.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pGeWg9I6cNiE+MAme8uW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The voltage regulator framework can't sanely deal with voltage
regulators which are left enabled by the bootloader. We workaround this
by forcing an enable()/disable() pair so it has a sane use_count.

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>

---
 drivers/mmc/host/pxamci.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index d7d7109..20fb3da 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -80,6 +80,18 @@ static inline void pxamci_init_ocr(struct pxamci_host *h=
ost)
 	if (IS_ERR(host->vcc))
 		host->vcc =3D NULL;
 	else {
+		/*
+		 * When the bootloader leaves a supply active, it's
+		 * initialized with zero usecount ... and we can't
+		 * disable it without first enabling it.  Until the
+		 * framework is fixed, we need a workaround like this
+		 * (which is safe for MMC, but not in general).
+		 */
+		if (regulator_is_enabled(host->vcc) > 0) {
+			regulator_enable(host->vcc);
+			regulator_disable(host->vcc);
+		}
+
 		host->mmc->ocr_avail =3D mmc_regulator_get_ocrmask(host->vcc);
 		if (host->pdata && host->pdata->ocr_mask)
 			dev_warn(mmc_dev(host->mmc),
--=20
tg: (87da0bf..) mmc/workaround-regulator-bugs (depends on: mmc/pxamci-regul=
ator-support)

--=20
Daniel Ribeiro

--=-pGeWg9I6cNiE+MAme8uW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpFVMQACgkQw3OYl0G0liQELwCeKphmbXGS7elHjcHtK3cKN2/e
sRUAnjs7xatJ2oJQQjJgogq8qXSrgggf
=LFCB
-----END PGP SIGNATURE-----

--=-pGeWg9I6cNiE+MAme8uW--

