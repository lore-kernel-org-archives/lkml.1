Return-Path: <linux-kernel-owner+w=401wt.eu-S933642AbZKYIbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642AbZKYIbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZKYIbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:31:23 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:45256 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbZKYIbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:31:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=usCwvhtm4UY7OvmJnLntjEjhKjt0ieXKJElFYeqP0ug1fYiO15WsPAxvLywJAe+EXZ
         8jncwWDjkN8ZZ0cAkKIgOJPiobmVE9XsvIFuOK//Z208ugFaT/7HnJZiEtsYwLVBgpZH
         EvMLvbC64pSUY/zuhNbjgYxpDDD2Dng8fv6sU=
From: Magnus Damm <magnus.damm@gmail.com>
To: spi-devel-general@lists.sourceforge.net
Cc: grant.likely@secretlab.ca, Magnus Damm <magnus.damm@gmail.com>,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Date: Wed, 25 Nov 2009 17:26:03 +0900
Message-Id: <20091125082603.25618.57438.sendpatchset@rxone.opensource.se>
Subject: [PATCH] spi: Allow using spi_bitbang_setup() with custom txrx_bufs()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch modifies the shared spi bitbanging code
to allow using spi_bitbang_setup() even though the
txrx_word[] callbacks are unset. Useful for drivers
that want to make use of spi_bitbang_setup() but
have their own txrx_bufs() callback.

While at it, drop the MSIOF driver workaround.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Depends on the MSIOF driver.

 drivers/spi/spi_bitbang.c  |   25 ++++++++++++++-----------
 drivers/spi/spi_sh_msiof.c |   11 -----------
 2 files changed, 14 insertions(+), 22 deletions(-)

--- 0001/drivers/spi/spi_bitbang.c
+++ work/drivers/spi/spi_bitbang.c	2009-11-25 15:30:45.000000000 +0900
@@ -176,6 +176,14 @@ int spi_bitbang_setup_transfer(struct sp
 }
 EXPORT_SYMBOL_GPL(spi_bitbang_setup_transfer);
 
+static int spi_bitbang_bufs(struct spi_device *spi, struct spi_transfer *t)
+{
+	struct spi_bitbang_cs	*cs = spi->controller_state;
+	unsigned		nsecs = cs->nsecs;
+
+	return cs->txrx_bufs(spi, cs->txrx_word, nsecs, t);
+}
+
 /**
  * spi_bitbang_setup - default setup for per-word I/O loops
  */
@@ -183,6 +191,7 @@ int spi_bitbang_setup(struct spi_device 
 {
 	struct spi_bitbang_cs	*cs = spi->controller_state;
 	struct spi_bitbang	*bitbang;
+	int			mode_mask = SPI_CPOL | SPI_CPHA;
 	int			retval;
 	unsigned long		flags;
 
@@ -196,9 +205,11 @@ int spi_bitbang_setup(struct spi_device 
 	}
 
 	/* per-word shift register access, in hardware or bitbanging */
-	cs->txrx_word = bitbang->txrx_word[spi->mode & (SPI_CPOL|SPI_CPHA)];
-	if (!cs->txrx_word)
-		return -EINVAL;
+	if (bitbang->txrx_bufs == spi_bitbang_bufs) {
+		cs->txrx_word = bitbang->txrx_word[spi->mode & mode_mask];
+		if (!cs->txrx_word)
+			return -EINVAL;
+	}
 
 	retval = bitbang->setup_transfer(spi, NULL);
 	if (retval < 0)
@@ -232,14 +243,6 @@ void spi_bitbang_cleanup(struct spi_devi
 }
 EXPORT_SYMBOL_GPL(spi_bitbang_cleanup);
 
-static int spi_bitbang_bufs(struct spi_device *spi, struct spi_transfer *t)
-{
-	struct spi_bitbang_cs	*cs = spi->controller_state;
-	unsigned		nsecs = cs->nsecs;
-
-	return cs->txrx_bufs(spi, cs->txrx_word, nsecs, t);
-}
-
 /*----------------------------------------------------------------------*/
 
 /*
--- 0002/drivers/spi/spi_sh_msiof.c
+++ work/drivers/spi/spi_sh_msiof.c	2009-11-25 15:25:32.000000000 +0900
@@ -510,13 +510,6 @@ static int sh_msiof_spi_txrx(struct spi_
 	return bytes_done;
 }
 
-static u32 sh_msiof_spi_txrx_word(struct spi_device *spi, unsigned nsecs,
-				  u32 word, u8 bits)
-{
-	BUG_ON(1); /* unused but needed by bitbang code */
-	return 0;
-}
-
 static int sh_msiof_spi_probe(struct platform_device *pdev)
 {
 	struct resource	*r;
@@ -594,10 +587,6 @@ static int sh_msiof_spi_probe(struct pla
 	p->bitbang.chipselect = sh_msiof_spi_chipselect;
 	p->bitbang.setup_transfer = sh_msiof_spi_setup_transfer;
 	p->bitbang.txrx_bufs = sh_msiof_spi_txrx;
-	p->bitbang.txrx_word[SPI_MODE_0] = sh_msiof_spi_txrx_word;
-	p->bitbang.txrx_word[SPI_MODE_1] = sh_msiof_spi_txrx_word;
-	p->bitbang.txrx_word[SPI_MODE_2] = sh_msiof_spi_txrx_word;
-	p->bitbang.txrx_word[SPI_MODE_3] = sh_msiof_spi_txrx_word;
 
 	ret = spi_bitbang_start(&p->bitbang);
 	if (ret == 0)
