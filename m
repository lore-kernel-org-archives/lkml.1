Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbYJFSKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbYJFSKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 14:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbYJFSKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 14:10:11 -0400
Received: from server.drzeus.cx ([85.8.24.28]:44888 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751244AbYJFSKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 14:10:10 -0400
Date: Mon, 6 Oct 2008 20:09:53 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel@avr32linux.org, Hein_Tibosch <hein_tibosch@yahoo.es>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] atmel-mci: Initialize BLKR before sending data transfer
 command
Message-ID: <20081006200953.7a0a5a51@mjolnir.drzeus.cx>
In-Reply-To: <alpine.LFD.2.00.0810061049030.3208@nehalem.linux-foundation.org>
References: <1223046458-10851-1-git-send-email-haavard.skinnemoen@atmel.com>
	<20081006194459.74ba0c84@mjolnir.drzeus.cx>
	<alpine.LFD.2.00.0810061049030.3208@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-1416-1223316607-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-1416-1223316607-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

The atmel-mci driver sometimes fails data transfers like this:

   mmcblk0: error -5 transferring data
   end_request: I/O error, dev mmcblk0, sector 2749769
   end_request: I/O error, dev mmcblk0, sector 2749777

It turns out that this might be caused by the BLKR register (which
contains the block size and the number of blocks being transfered) being
initialized too late. This patch moves the initialization of BLKR so
that it contains the correct value before the block transfer command is
sent.

This error is difficult to reproduce, but if you insert a long delay
(mdelay(10) or thereabouts) between the calls to atmci_start_command()
and atmci_submit_data(), all transfers seem to fail without this patch,
while I haven't seen any failures with this patch.

Reported-by: Hein_Tibosch <hein_tibosch@yahoo.es>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
---
 drivers/mmc/host/atmel-mci.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 917035e..0000896 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -426,8 +426,6 @@ static u32 atmci_submit_data(struct mmc_host *mmc, stru=
ct mmc_data *data)
 	host->sg =3D NULL;
 	host->data =3D data;
=20
-	mci_writel(host, BLKR, MCI_BCNT(data->blocks)
-			| MCI_BLKLEN(data->blksz));
 	dev_vdbg(&mmc->class_dev, "BLKR=3D0x%08x\n",
 			MCI_BCNT(data->blocks) | MCI_BLKLEN(data->blksz));
=20
@@ -483,6 +481,10 @@ static void atmci_request(struct mmc_host *mmc, struct=
 mmc_request *mrq)
 		if (data->blocks > 1 && data->blksz & 3)
 			goto fail;
 		atmci_set_timeout(host, data);
+
+		/* Must set block count/size before sending command */
+		mci_writel(host, BLKR, MCI_BCNT(data->blocks)
+				| MCI_BLKLEN(data->blksz));
 	}
=20
 	iflags =3D MCI_CMDRDY;


--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-1416-1223316607-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjqVHwACgkQ7b8eESbyJLgWrwCfadURlrv4r/RCfvNEE4L2jRHx
QVkAoLTU3/fUoES6UDLrNYk2QrbO9WeK
=SdJ9
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-1416-1223316607-0001-2--
