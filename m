Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbZDHItW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbZDHItW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbZDHItM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:49:12 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:3001 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753423AbZDHItK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:49:10 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH 7/7 revised] mmc_spi: support for non-byte-aligned cards
Date: Wed, 8 Apr 2009 09:48:58 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904081048.58264.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

o A very large subset of SD cards in the market send their
  responses and data non-byte-aligned. So add logic to the
  mmc spi driver to handle this mess.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---

diff -uprN 2_6_29_rc7_patch125346/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch1253467/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_patch125346/drivers/mmc/host/mmc_spi.c	2009-04-07 15:59:54.000000000 +0200
+++ 2_6_29_rc7_patch1253467/drivers/mmc/host/mmc_spi.c	2009-04-07 17:19:21.000000000 +0200
@@ -254,6 +254,10 @@ static int mmc_spi_response_get(struct m
 	u8	*cp = host->data->status;
 	u8	*end = cp + host->t.len;
 	int	value = 0;
+	int	bitshift;
+	u8 	leftover = 0;
+	unsigned short rotator;
+	int 	i;
 	char	tag[32];
 
 	snprintf(tag, sizeof(tag), "  ... CMD%d response SPI_%s",
@@ -271,9 +275,8 @@ static int mmc_spi_response_get(struct m
 
 	/* Data block reads (R1 response types) may need more data... */
 	if (cp == end) {
-		unsigned	i;
-
 		cp = host->data->status;
+		end = cp+1;
 
 		/* Card sends N(CR) (== 1..8) bytes of all-ones then one
 		 * status byte ... and we already scanned 2 bytes.
@@ -298,20 +301,34 @@ static int mmc_spi_response_get(struct m
 	}
 
 checkstatus:
-	if (*cp & 0x80) {
-		dev_dbg(&host->spi->dev, "%s: INVALID RESPONSE, %02x\n",
-					tag, *cp);
-		value = -EBADR;
-		goto done;
+	bitshift = 0;
+	if (*cp & 0x80)	{
+		/* Houston, we have an ugly card with a bit-shifted response */
+		rotator = *cp++ << 8;
+		/* read the next byte */
+		if (cp == end) {
+			value = mmc_spi_readbytes(host, 1);
+			if (value < 0)
+				goto done;
+			cp = host->data->status;
+			end = cp+1;
+		}
+		rotator |= *cp++;
+		while (rotator & 0x8000) {
+			bitshift++;
+			rotator <<= 1;
+		}
+		cmd->resp[0] = rotator >> 8;
+		leftover = rotator;
+	} else {
+		cmd->resp[0] = *cp++;
 	}
-
-	cmd->resp[0] = *cp++;
 	cmd->error = 0;
 
 	/* Status byte: the entire seven-bit R1 response.  */
 	if (cmd->resp[0] != 0) {
 		if ((R1_SPI_PARAMETER | R1_SPI_ADDRESS
-					| R1_SPI_ILLEGAL_COMMAND)
+				      | R1_SPI_ILLEGAL_COMMAND)
 				& cmd->resp[0])
 			value = -EINVAL;
 		else if (R1_SPI_COM_CRC & cmd->resp[0])
@@ -339,12 +356,45 @@ checkstatus:
 	 * SPI R5 == R1 + data byte; IO_RW_DIRECT
 	 */
 	case MMC_RSP_SPI_R2:
-		cmd->resp[0] |= *cp << 8;
+		/* read the next byte */
+		if (cp == end) {
+			value = mmc_spi_readbytes(host, 1);
+			if (value < 0)
+				goto done;
+			cp = host->data->status;
+			end = cp+1;
+		}
+		if (bitshift) {
+			rotator = leftover << 8;
+			rotator |= *cp << bitshift;
+			cmd->resp[0] |= (rotator & 0xFF00);
+		} else {
+			cmd->resp[0] |= *cp << 8;
+		}
 		break;
 
 	/* SPI R3, R4, or R7 == R1 + 4 bytes */
 	case MMC_RSP_SPI_R3:
-		cmd->resp[1] = get_unaligned_be32(cp);
+		rotator = leftover << 8;
+		cmd->resp[1] = 0;
+		for (i = 0; i < 4; i++) {
+			cmd->resp[1] <<= 8;
+			/* read the next byte */
+			if (cp == end) {
+				value = mmc_spi_readbytes(host, 1);
+				if (value < 0)
+					goto done;
+				cp = host->data->status;
+				end = cp+1;
+			}
+			if (bitshift) {
+				rotator |= *cp++ << bitshift;
+				cmd->resp[1] |= (rotator >> 8);
+				rotator <<= 8;
+			} else {
+				cmd->resp[1] |= *cp++;
+			}
+		}
 		break;
 
 	/* SPI R1 == just one status byte */
@@ -725,6 +775,8 @@ mmc_spi_readblock(struct mmc_spi_host *h
 	struct spi_device	*spi = host->spi;
 	int			status;
 	struct scratch		*scratch = host->data;
+	unsigned int 		bitshift;
+	u8			leftover;
 
 	/* At least one SD card sends an all-zeroes byte when N(CX)
 	 * applies, before the all-ones bytes ... just cope with that.
@@ -736,38 +788,60 @@ mmc_spi_readblock(struct mmc_spi_host *h
 	if (status == 0xff || status == 0)
 		status = mmc_spi_readtoken(host, timeout);
 
-	if (status == SPI_TOKEN_SINGLE) {
-		if (host->dma_dev) {
-			dma_sync_single_for_device(host->dma_dev,
-					host->data_dma, sizeof(*scratch),
-					DMA_BIDIRECTIONAL);
-			dma_sync_single_for_device(host->dma_dev,
-					t->rx_dma, t->len,
-					DMA_FROM_DEVICE);
-		}
-
-		status = spi_sync(spi, &host->m);
-
-		if (host->dma_dev) {
-			dma_sync_single_for_cpu(host->dma_dev,
-					host->data_dma, sizeof(*scratch),
-					DMA_BIDIRECTIONAL);
-			dma_sync_single_for_cpu(host->dma_dev,
-					t->rx_dma, t->len,
-					DMA_FROM_DEVICE);
-		}
-
-	} else {
+	if (status < 0) {
 		dev_dbg(&spi->dev, "read error %02x (%d)\n", status, status);
+		return status;
+	}
 
-		/* we've read extra garbage, timed out, etc */
-		if (status < 0)
-			return status;
+	/* The token may be bit-shifted...
+	 * the first 0-bit precedes the data stream.
+	 */
+	bitshift = 7;
+	while (status & 0x80) {
+		status <<= 1;
+		bitshift--;
+	}
+	leftover = status << 1;
+ 
+	if (host->dma_dev) {
+		dma_sync_single_for_device(host->dma_dev,
+				host->data_dma, sizeof(*scratch),
+				DMA_BIDIRECTIONAL);
+		dma_sync_single_for_device(host->dma_dev,
+				t->rx_dma, t->len,
+				DMA_FROM_DEVICE);
+	}
 
-		/* low four bits are an R2 subset, fifth seems to be
-		 * vendor specific ... map them all to generic error..
+	status = spi_sync(spi, &host->m);
+
+	if (host->dma_dev) {
+		dma_sync_single_for_cpu(host->dma_dev,
+				host->data_dma, sizeof(*scratch),
+				DMA_BIDIRECTIONAL);
+		dma_sync_single_for_cpu(host->dma_dev,
+				t->rx_dma, t->len,
+				DMA_FROM_DEVICE);
+	}
+ 
+	if (bitshift) {
+		/* Walk through the data and the crc and do
+		 * all the magic to get byte-aligned data.
 		 */
-		return -EIO;
+		u8 *cp = t->rx_buf;
+		unsigned int len;
+		unsigned int bitright = 8 - bitshift;
+		u8 temp;
+		for (len = t->len; len; len--) {
+			temp = *cp;
+			*cp++ = leftover | (temp >> bitshift);
+			leftover = temp << bitright;
+		}
+		cp = (u8 *) &scratch->crc_val;
+		temp = *cp;
+		*cp++ = leftover | (temp >> bitshift);
+		leftover = temp << bitright;
+		temp = *cp;
+		*cp = leftover | (temp >> bitshift);
 	}
 
 	if (host->mmc->use_spi_crc) {

---
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
