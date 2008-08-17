Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbYHQTv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbYHQTv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYHQTvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:51:51 -0400
Received: from server.drzeus.cx ([85.8.24.28]:46445 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751084AbYHQTvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:51:50 -0400
Date: Sun, 17 Aug 2008 21:51:41 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC fixes for 2.6.27-rc4
Message-ID: <20080817215141.72e3b676@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-8918-1219002709-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-8918-1219002709-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive the following updates:

 drivers/mmc/host/s3cmci.c     |   17 ++++++++++-------
 drivers/mmc/host/sdricoh_cs.c |    1 -
 2 files changed, 10 insertions(+), 8 deletions(-)

Ben Dooks (2):
      s3cmci: fix sparse errors from non-exported functions
      s3cmci: attach get_cd host ops

Huang Weiyi (1):
      sdricoh_cs: removed unused #include <version.h>

diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index 7c994e1..ae16d84 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -595,8 +595,9 @@ static irqreturn_t s3cmci_irq_cd(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
=20
-void s3cmci_dma_done_callback(struct s3c2410_dma_chan *dma_ch, void *buf_i=
d,
-			      int size, enum s3c2410_dma_buffresult result)
+static void s3cmci_dma_done_callback(struct s3c2410_dma_chan *dma_ch,
+				     void *buf_id, int size,
+				     enum s3c2410_dma_buffresult result)
 {
 	struct s3cmci_host *host =3D buf_id;
 	unsigned long iflags;
@@ -740,8 +741,8 @@ request_done:
 	mmc_request_done(host->mmc, mrq);
 }
=20
-
-void s3cmci_dma_setup(struct s3cmci_host *host, enum s3c2410_dmasrc source)
+static void s3cmci_dma_setup(struct s3cmci_host *host,
+			     enum s3c2410_dmasrc source)
 {
 	static enum s3c2410_dmasrc last_source =3D -1;
 	static int setup_ok;
@@ -1003,8 +1004,9 @@ static void s3cmci_send_request(struct mmc_host *mmc)
 	enable_irq(host->irq);
 }
=20
-static int s3cmci_card_present(struct s3cmci_host *host)
+static int s3cmci_card_present(struct mmc_host *mmc)
 {
+	struct s3cmci_host *host =3D mmc_priv(mmc);
 	struct s3c24xx_mci_pdata *pdata =3D host->pdata;
 	int ret;
=20
@@ -1023,7 +1025,7 @@ static void s3cmci_request(struct mmc_host *mmc, stru=
ct mmc_request *mrq)
 	host->cmd_is_stop =3D 0;
 	host->mrq =3D mrq;
=20
-	if (s3cmci_card_present(host) =3D=3D 0) {
+	if (s3cmci_card_present(mmc) =3D=3D 0) {
 		dbg(host, dbg_err, "%s: no medium present\n", __func__);
 		host->mrq->cmd->error =3D -ENOMEDIUM;
 		mmc_request_done(mmc, mrq);
@@ -1138,6 +1140,7 @@ static struct mmc_host_ops s3cmci_ops =3D {
 	.request	=3D s3cmci_request,
 	.set_ios	=3D s3cmci_set_ios,
 	.get_ro		=3D s3cmci_get_ro,
+	.get_cd		=3D s3cmci_card_present,
 };
=20
 static struct s3c24xx_mci_pdata s3cmci_def_pdata =3D {
@@ -1206,7 +1209,7 @@ static int __devinit s3cmci_probe(struct platform_dev=
ice *pdev, int is2440)
 	}
=20
 	host->base =3D ioremap(host->mem->start, RESSIZE(host->mem));
-	if (host->base =3D=3D 0) {
+	if (!host->base) {
 		dev_err(&pdev->dev, "failed to ioremap() io memory region.\n");
 		ret =3D -EINVAL;
 		goto probe_free_mem_region;
diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index f99e9f7..1df44d9 100644
--- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -29,7 +29,6 @@
 #include <linux/pci.h>
 #include <linux/ioport.h>
 #include <linux/scatterlist.h>
-#include <linux/version.h>
=20
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>



--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-8918-1219002709-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiogVIACgkQ7b8eESbyJLiX9ACg26yjT/8wOPTAuhOalGYfNnGX
Y7kAoI6hxBjsTrqtGviomPq/AqrUvTvX
=1Zyb
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-8918-1219002709-0001-2--
