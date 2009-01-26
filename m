Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbZAZNSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbZAZNSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZAZNS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:18:26 -0500
Received: from mx1.auerswald.de ([212.185.163.234]:2407 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750738AbZAZNSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:18:25 -0500
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH] Fixes and enhancements for the MMC SPI driver - revised
Date: Mon, 26 Jan 2009 14:18:19 +0100
User-Agent: KMail/1.9.10
References: <20090113015904.606e3548.akpm@linux-foundation.org>
In-Reply-To: <20090113015904.606e3548.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901261418.19681.wolfgang.mues@auerswald.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>, "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, "Mike Frysinger" <vapier.adi@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks to all contributors who have reviewed my patch, especial to 
Andrew Morton for pointing out some problems.

Here is a revised patch incl. changelog. I have though about putting
some warnings in the message log with printk, Pierre. But this is low-level
stuff and will likely flood the logfile.

This patch will change the status of the MMC SPI driver from "works NOT 
for the majority of SD cards" to "works for the majority of SD cards".

changelog:

o  Release CPU time to other tasks in mmc_spi_skip() if busy waiting is longer
   than a scheduling period. Otherwise the whole userspace will lock until the
   SD card is not busy any more (maybe 900ms). ktime converted to jiffies to
   match the scheduling periods.

o  Wait a little bit longer (16 Bytes instead of 8) in mmc_spi_response_get()
   to read the response code from the SD card. Some SD cards are slower than
   the standard allows; especially if the card is internally writing data to
   flash.

o  Rise the write block timeout to a minimum of 1s in mmc_spi_writeblock().
   Some cards - even SDHC! - need longer timeouts if they are pushed to the
   limit (back-to-back write transfers, blocksize < than internal flash block
   size). This may be enforced by the small cluster size of FAT32 volumes.

o  Some SD cards are not able to send the response code after a write data
   block in time if they are internal busy flushing data to NAND. Allow for
   max. 27 bit offset in mmc_spi_writeblock(). (The highest observed delay
   was 12 bits).

o  Omit the CRC check for all non-data-reads (CID and CSD) in 
   mmc_spi_readblock(). Some cards send wrong CRC if len != MMC_SPI_BLOCKSIZE.

o  Allow the platform data to specify SPI_MODE_3, overriding the default
   SPI_MODE_0. This is for SPI hardware which is not able to drive Chip Select
   correctly in SPI mode 0 (Blackfin).

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

This patch is against linux 2.6.28.

=========================snip =======================
--- drivers/mmc/host/mmc_spi.c.trunk	2008-11-24 10:26:06.000000000 +0100
+++ drivers/mmc/host/mmc_spi.c	2009-01-13 17:08:40.000000000 +0100
@@ -25,6 +25,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #include <linux/hrtimer.h>
+#include <linux/sched.h>
+#include <linux/jiffies.h>
 #include <linux/delay.h>
 #include <linux/bio.h>
 #include <linux/dma-mapping.h>
@@ -186,9 +188,10 @@ mmc_spi_readbytes(struct mmc_spi_host *h
 static int
 mmc_spi_skip(struct mmc_spi_host *host, ktime_t timeout, unsigned n, u8 byte)
 {
-	u8		*cp = host->data->status;
-
-	timeout = ktime_add(timeout, ktime_get());
+	u8 *cp = host->data->status;
+	struct timeval tv = ktime_to_timeval(timeout);
+	unsigned long timeout_jiffies = timeval_to_jiffies(&tv);
+	unsigned long starttime = jiffies;
 
 	while (1) {
 		int		status;
@@ -203,11 +206,13 @@ mmc_spi_skip(struct mmc_spi_host *host, 
 				return cp[i];
 		}
 
-		/* REVISIT investigate msleep() to avoid busy-wait I/O
-		 * in at least some cases.
-		 */
-		if (ktime_to_ns(ktime_sub(ktime_get(), timeout)) > 0)
+		if (time_is_before_jiffies(starttime+timeout_jiffies))
 			break;
+		/* If we need long timeouts, we may release the CPU. */
+		/* We use jiffies here because we want to have a relation
+		   between elapsed time and the blocking of the scheduler. */
+		if (time_is_before_jiffies(starttime+1))
+			schedule();
 	}
 	return -ETIMEDOUT;
 }
@@ -280,7 +285,9 @@ static int mmc_spi_response_get(struct m
 		 * It'd probably be better to memcpy() the first chunk and
 		 * avoid extra i/o calls...
 		 */
-		for (i = 2; i < 9; i++) {
+		/* Note we check for more than 8 bytes, because in practice,
+		   some SD cards are slow... */
+		for (i = 2; i < 16; i++) {
 			value = mmc_spi_readbytes(host, 1);
 			if (value < 0)
 				goto done;
@@ -609,6 +616,18 @@ mmc_spi_writeblock(struct mmc_spi_host *
 	struct spi_device	*spi = host->spi;
 	int			status, i;
 	struct scratch		*scratch = host->data;
+	u32			pattern;
+	struct timeval 		tv;
+
+	/*
+	 * The MMC framework does a good job of computing timeouts
+	 * according to the mmc/sd standard. However, we found that in
+	 * SPI mode, there are many cards which need a longer timeout
+	 * of 1s after receiving a long stream of write data.
+	 */
+	tv = ktime_to_timeval(timeout);
+	if (tv.tv_sec == 0)
+		timeout = ktime_set(1, 0);
 
 	if (host->mmc->use_spi_crc)
 		scratch->crc_val = cpu_to_be16(
@@ -636,8 +655,23 @@ mmc_spi_writeblock(struct mmc_spi_host *
 	 * doesn't necessarily tell whether the write operation succeeded;
 	 * it just says if the transmission was ok and whether *earlier*
 	 * writes succeeded; see the standard.
-	 */
-	switch (SPI_MMC_RESPONSE_CODE(scratch->status[0])) {
+	 *
+	 * In practice, there are (even modern SDHC-)Cards which need
+	 * some bits to send the response, so we have to cope with this
+	 * situation and check the response bit-by-bit. Arggh!!!
+	 */
+	pattern  = scratch->status[0] << 24;
+	pattern |= scratch->status[1] << 16;
+	pattern |= scratch->status[2] << 8;
+	pattern |= scratch->status[3];
+
+	/* left-adjust to leading 0 bit */
+	while (pattern & 0x80000000)
+		pattern <<= 1;
+	/* right-adjust for pattern matching. Code is in bit 4..0 now. */
+	pattern >>= 27;
+
+	switch (pattern) {
 	case SPI_RESPONSE_ACCEPTED:
 		status = 0;
 		break;
@@ -668,8 +702,8 @@ mmc_spi_writeblock(struct mmc_spi_host *
 	/* Return when not busy.  If we didn't collect that status yet,
 	 * we'll need some more I/O.
 	 */
-	for (i = 1; i < sizeof(scratch->status); i++) {
-		if (scratch->status[i] != 0)
+	for (i = 4; i < sizeof(scratch->status); i++) {
+		if (scratch->status[i] & 0x01)
 			return 0;
 	}
 	return mmc_spi_wait_unbusy(host, timeout);
@@ -743,7 +777,12 @@ mmc_spi_readblock(struct mmc_spi_host *h
 		return -EIO;
 	}
 
-	if (host->mmc->use_spi_crc) {
+	/*
+	 * Omit the CRC check for CID and CSD reads. There are some SDHC
+	 * cards which don't supply a valid CRC after CID reads.
+	 * Note that the CID has it's own CRC7 value inside the data block.
+	 */
+	if (host->mmc->use_spi_crc && (t->len == MMC_SPI_BLOCKSIZE)) {
 		u16 crc = crc_itu_t(0, t->rx_buf, t->len);
 
 		be16_to_cpus(&scratch->crc_val);
@@ -1206,8 +1245,15 @@ static int mmc_spi_probe(struct spi_devi
 	 * rising edge ... meaning SPI modes 0 or 3.  So either SPI mode
 	 * should be legit.  We'll use mode 0 since it seems to be a
 	 * bit less troublesome on some hardware ... unclear why.
-	 */
-	spi->mode = SPI_MODE_0;
+	 *
+	 * If the platform_data specifies mode 3, trust the platform_data
+	 * and use this one. This allows for platforms which do not support
+	 * mode 0.
+	 */
+	if (spi->mode != SPI_MODE_3)
+		/* set our default */
+		spi->mode = SPI_MODE_0;
+
 	spi->bits_per_word = 8;
 
 	status = spi_setup(spi);
=========================snip =======================

regards

i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
