Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbYGEXPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbYGEXPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 19:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYGEXPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 19:15:42 -0400
Received: from server.drzeus.cx ([85.8.24.28]:46490 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752460AbYGEXPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 19:15:42 -0400
Date: Sun, 6 Jul 2008 01:15:34 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Stable branch <stable@kernel.org>
Subject: [PATCH] pxamci: fix byte aligned DMA transfers
Message-ID: <20080706011534.6dc71f5a@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-15806-1215299739-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-15806-1215299739-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

From: Philipp Zabel <philipp.zabel@gmail.com>

The pxa27x DMA controller defaults to 64-bit alignment. This caused
the SCR reads to fail (and, depending on card type, error out) when
card->raw_scr was not aligned on a 8-byte boundary.

For performance reasons all scatter-gather addresses passed to
pxamci_request should be aligned on 8-byte boundaries, but if
this can't be guaranteed, byte aligned DMA transfers in the
have to be enabled in the controller to get correct behaviour.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
---
 drivers/mmc/host/pxamci.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 65210fc..d89475d 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -114,6 +114,7 @@ static void pxamci_setup_data(struct pxamci_host *host,=
 struct mmc_data *data)
 	unsigned int nob =3D data->blocks;
 	unsigned long long clks;
 	unsigned int timeout;
+	bool dalgn =3D 0;
 	u32 dcmd;
 	int i;
=20
@@ -152,6 +153,9 @@ static void pxamci_setup_data(struct pxamci_host *host,=
 struct mmc_data *data)
 		host->sg_cpu[i].dcmd =3D dcmd | length;
 		if (length & 31 && !(data->flags & MMC_DATA_READ))
 			host->sg_cpu[i].dcmd |=3D DCMD_ENDIRQEN;
+		/* Not aligned to 8-byte boundary? */
+		if (sg_dma_address(&data->sg[i]) & 0x7)
+			dalgn =3D 1;
 		if (data->flags & MMC_DATA_READ) {
 			host->sg_cpu[i].dsadr =3D host->res->start + MMC_RXFIFO;
 			host->sg_cpu[i].dtadr =3D sg_dma_address(&data->sg[i]);
@@ -165,6 +169,15 @@ static void pxamci_setup_data(struct pxamci_host *host=
, struct mmc_data *data)
 	host->sg_cpu[host->dma_len - 1].ddadr =3D DDADR_STOP;
 	wmb();
=20
+	/*
+	 * The PXA27x DMA controller encounters overhead when working with
+	 * unaligned (to 8-byte boundaries) data, so switch on byte alignment
+	 * mode only if we have unaligned data.
+	 */
+	if (dalgn)
+		DALGN |=3D (1 << host->dma);
+	else
+		DALGN &=3D (1 << host->dma);
 	DDADR(host->dma) =3D host->sg_dma;
 	DCSR(host->dma) =3D DCSR_RUN;
 }


--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-15806-1215299739-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhwAJsACgkQ7b8eESbyJLjDpwCgyde8Uz/u6iHD5/JwFyH6r8hA
dvQAoMH38ZvMg355D4R0jXmUXYfJzJds
=YuR1
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-15806-1215299739-0001-2--
