Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbYFILbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbYFILbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 07:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759616AbYFILau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 07:30:50 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:59817 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759596AbYFILat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 07:30:49 -0400
Date: Mon, 9 Jun 2008 13:31:24 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Subject: Re: [patch 2.6.26-rc5-git] at91_nand speedup via
 {read,write}s{b,w}()
Message-ID: <20080609133124.0eb97e25@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200806090313.28515.david-b@pacbell.net>
References: <200806090313.28515.david-b@pacbell.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 09 Jun 2008 11:30:36.0971 (UTC) FILETIME=[3CEABFB0:01C8CA24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> wrote:
> This uses __raw_{read,write}s{b,w}() primitives to access data on NAND
> chips for more efficient I/O.
> 
> On an arm926 with memory clocked at 100 MHz, this reduced the elapsed
> time for a 64 MByte read by 16%.  ("dd" /dev/mtd0 to /dev/null, with
> an 8-bit NAND using hardware ECC and 128KB blocksize.)

Nice. Here are some numbers from my setup (256 MB, 8-bit, software ECC).

Before:
real	2m38.131s
user	0m0.228s
sys	2m37.740s

After:
real	2m27.404s
user	0m0.180s
sys	2m27.068s

which is a 6.8% speedup. I guess hardware ECC helps...though I can't
seem to get it to work properly. Is there anything I need to do besides
flash_eraseall when changing the ECC layout?

Also, I wonder if we can use the DMA engine framework to get rid of all
that "sys" time...?

> Also some minor section tweaks:
> 
>   - Use platform_driver_probe() so no pointer to probe() lingers
>     after that code has been removed at run-time.
> 
>   - Use __exit and __exit_p so the remove() code will normally be
>     removed by the linker.
> 
> Since these buffer read/write calls are new, this increases the runtime
> code footprint (by 88 bytes on my build, after the section tweaks).

Yeah, I spotted a bug in __raw_readsb on avr32, so I guess those
functions haven't actually been used before...

> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> Yeah, this does may you wonder why the *default* nand r/w code isn't
> using these primitives; this speedup shouldn't be platform-specific.
> 
> Posting this now since I think this should either be incorporated into
> the new atmel_nand.c code or into drivers/mtd/nand/nand_base.c ...
> both arm and avr32 support these calls, I'm not sure whether or not
> some platforms don't support them.

I'll leave it up to the MTD people to decide whether or not to update
nand_base.c. Below is your patch rebased onto my patchset. I'll include
it in my next series after I figure out where to send it.

Haavard

>From ad420ea11f9c8aa0fcad2ce1c3af69c02a2dc447 Mon Sep 17 00:00:00 2001
From: David Brownell <david-b@pacbell.net>
Date: Mon, 9 Jun 2008 03:13:28 -0700
Subject: [PATCH] atmel_nand speedup via {read,write}s{b,w}()

This uses __raw_{read,write}s{b,w}() primitives to access data on NAND
chips for more efficient I/O.

On an arm926 with memory clocked at 100 MHz, this reduced the elapsed
time for a 64 MByte read by 16%.  ("dd" /dev/mtd0 to /dev/null, with
an 8-bit NAND using hardware ECC and 128KB blocksize.)

Also some minor section tweaks:

  - Use platform_driver_probe() so no pointer to probe() lingers
    after that code has been removed at run-time.

  - Use __exit and __exit_p so the remove() code will normally be
    removed by the linker.

Since these buffer read/write calls are new, this increases the runtime
code footprint (by 88 bytes on my build, after the section tweaks).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
[haavard.skinnemoen@atmel.com: rebase onto atmel_nand rename]
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mtd/nand/atmel_nand.c |   46 ++++++++++++++++++++++++++++++++++++----
 1 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 325ce29..d9f7a5d 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -142,6 +142,37 @@ static int atmel_nand_device_ready(struct mtd_info *mtd)
 }
 
 /*
+ * Minimal-overhead PIO for data access.
+ */
+static void atmel_read_buf(struct mtd_info *mtd, u8 *buf, int len)
+{
+	struct nand_chip	*nand_chip = mtd->priv;
+
+	__raw_readsb(nand_chip->IO_ADDR_R, buf, len);
+}
+
+static void atmel_read_buf16(struct mtd_info *mtd, u8 *buf, int len)
+{
+	struct nand_chip	*nand_chip = mtd->priv;
+
+	__raw_readsw(nand_chip->IO_ADDR_R, buf, len / 2);
+}
+
+static void atmel_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
+{
+	struct nand_chip	*nand_chip = mtd->priv;
+
+	__raw_writesb(nand_chip->IO_ADDR_W, buf, len);
+}
+
+static void atmel_write_buf16(struct mtd_info *mtd, const u8 *buf, int len)
+{
+	struct nand_chip	*nand_chip = mtd->priv;
+
+	__raw_writesw(nand_chip->IO_ADDR_W, buf, len / 2);
+}
+
+/*
  * write oob for small pages
  */
 static int atmel_nand_write_oob_512(struct mtd_info *mtd,
@@ -436,8 +467,14 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 
 	nand_chip->chip_delay = 20;		/* 20us command delay time */
 
-	if (host->board->bus_width_16)		/* 16-bit bus width */
+	if (host->board->bus_width_16) {	/* 16-bit bus width */
 		nand_chip->options |= NAND_BUSWIDTH_16;
+		nand_chip->read_buf = atmel_read_buf16;
+		nand_chip->write_buf = atmel_write_buf16;
+	} else {
+		nand_chip->read_buf = atmel_read_buf;
+		nand_chip->write_buf = atmel_write_buf;
+	}
 
 	platform_set_drvdata(pdev, host);
 	atmel_nand_enable(host);
@@ -546,7 +583,7 @@ err_nand_ioremap:
 /*
  * Remove a NAND device.
  */
-static int __devexit atmel_nand_remove(struct platform_device *pdev)
+static int __exit atmel_nand_remove(struct platform_device *pdev)
 {
 	struct atmel_nand_host *host = platform_get_drvdata(pdev);
 	struct mtd_info *mtd = &host->mtd;
@@ -564,8 +601,7 @@ static int __devexit atmel_nand_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver atmel_nand_driver = {
-	.probe		= atmel_nand_probe,
-	.remove		= atmel_nand_remove,
+	.remove		= __exit_p(atmel_nand_remove),
 	.driver		= {
 		.name	= "atmel_nand",
 		.owner	= THIS_MODULE,
@@ -574,7 +610,7 @@ static struct platform_driver atmel_nand_driver = {
 
 static int __init atmel_nand_init(void)
 {
-	return platform_driver_register(&atmel_nand_driver);
+	return platform_driver_probe(&atmel_nand_driver, atmel_nand_probe);
 }
 
 
-- 
1.5.5.3

