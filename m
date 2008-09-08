Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYIHNAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYIHNAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbYIHM7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:59:10 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:39429 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYIHM7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:59:06 -0400
Message-Id: <20080908124909.040168156@zoo.weinigel.se>
References: <20080908124848.541807034@zoo.weinigel.se>
User-Agent: quilt/0.46-1
Date: Mon, 08 Sep 2008 14:48:49 +0200
From: Christer Weinigel <christer@weinigel.se>
To: ben-linux@fluff.org
Cc: linux-kernel@vger.kernel.org, christer@weinigel.se
Subject: [patch 1/3] s3cmci -- support odd block transfers
Content-Disposition: inline; filename=s3c_mci-odd-sizes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be able to do SDIO the s3cmci driver has to support non-word-sized
transfers.  Change pio_words into pio_bytes and fix up all the places
where it is used.  

This variant of the patch will not overrun the buffer when reading an
odd number of bytes.  When writing, this variant will still read past
the end of the buffer, but since the driver can't support non-word-
aligned transfers anyway, this should not be a problem, since a
word-aligned transfer will never cross a page boundary.

This has been tested with a CSR SDIO Bluetooth Type A device on a
Samsung S3C24A0 processor.

Signed-off-by: Christer Weinigel <christer@weinigel.se>

Index: linux-2.6.26.2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26.2.orig/drivers/mmc/host/s3cmci.c
+++ linux-2.6.26.2/drivers/mmc/host/s3cmci.c
@@ -191,7 +191,7 @@ static inline void clear_imask(struct s3
 }
 
 static inline int get_data_buffer(struct s3cmci_host *host,
-				  u32 *words, u32 **pointer)
+				  u32 *bytes, u32 **pointer)
 {
 	struct scatterlist *sg;
 
@@ -208,7 +208,7 @@ static inline int get_data_buffer(struct
 	}
 	sg = &host->mrq->data->sg[host->pio_sgptr];
 
-	*words = sg->length >> 2;
+	*bytes = sg->length;
 	*pointer = sg_virt(sg);
 
 	host->pio_sgptr++;
@@ -224,7 +224,7 @@ static inline u32 fifo_count(struct s3cm
 	u32 fifostat = readl(host->base + S3C2410_SDIFSTA);
 
 	fifostat &= S3C2410_SDIFSTA_COUNTMASK;
-	return fifostat >> 2;
+	return fifostat;
 }
 
 static inline u32 fifo_free(struct s3cmci_host *host)
@@ -232,13 +232,14 @@ static inline u32 fifo_free(struct s3cmc
 	u32 fifostat = readl(host->base + S3C2410_SDIFSTA);
 
 	fifostat &= S3C2410_SDIFSTA_COUNTMASK;
-	return (63 - fifostat) >> 2;
+	return 63 - fifostat;
 }
 
 static void do_pio_read(struct s3cmci_host *host)
 {
 	int res;
 	u32 fifo;
+	u32 fifo_words;
 	void __iomem *from_ptr;
 
 	/* write real prescaler to host, it might be set slow to fix */
@@ -247,8 +248,8 @@ static void do_pio_read(struct s3cmci_ho
 	from_ptr = host->base + host->sdidata;
 
 	while ((fifo = fifo_count(host))) {
-		if (!host->pio_words) {
-			res = get_data_buffer(host, &host->pio_words,
+		if (!host->pio_bytes) {
+			res = get_data_buffer(host, &host->pio_bytes,
 					      &host->pio_ptr);
 			if (res) {
 				host->pio_active = XFER_NONE;
@@ -261,26 +262,45 @@ static void do_pio_read(struct s3cmci_ho
 
 			dbg(host, dbg_pio,
 			    "pio_read(): new target: [%i]@[%p]\n",
-			    host->pio_words, host->pio_ptr);
+			    host->pio_bytes, host->pio_ptr);
 		}
 
 		dbg(host, dbg_pio,
 		    "pio_read(): fifo:[%02i] buffer:[%03i] dcnt:[%08X]\n",
-		    fifo, host->pio_words,
+		    fifo, host->pio_bytes,
 		    readl(host->base + S3C2410_SDIDCNT));
 
-		if (fifo > host->pio_words)
-			fifo = host->pio_words;
+		/* If we have reached the end of the block, we can
+		 * read a word and get 1 to 3 bytes.  If we in the
+		 * middle of the block, we have to read full words,
+		 * otherwise we will write garbage, so round down to
+		 * an even multiple of 4. */
+		if (fifo >= host->pio_bytes)
+			fifo = host->pio_bytes;
+		else
+			fifo -= fifo & 3;
 
-		host->pio_words -= fifo;
+		host->pio_bytes -= fifo;
 		host->pio_count += fifo;
 
-		while (fifo--)
+		fifo_words = fifo >> 2;
+		while (fifo_words--)
 			*(host->pio_ptr++) = readl(from_ptr);
+
+		if (fifo & 3) {
+			u32 n = fifo & 3;
+			u32 data = readl(from_ptr);
+			u8 *p = (u8 *)host->pio_ptr;
+
+			while (n--) {
+				*p++ = data;
+				data >>= 8;
+			}
+		}
 	}
 
-	if (!host->pio_words) {
-		res = get_data_buffer(host, &host->pio_words, &host->pio_ptr);
+	if (!host->pio_bytes) {
+		res = get_data_buffer(host, &host->pio_bytes, &host->pio_ptr);
 		if (res) {
 			dbg(host, dbg_pio,
 			    "pio_read(): complete (no more buffers).\n");
@@ -304,8 +324,8 @@ static void do_pio_write(struct s3cmci_h
 	to_ptr = host->base + host->sdidata;
 
 	while ((fifo = fifo_free(host))) {
-		if (!host->pio_words) {
-			res = get_data_buffer(host, &host->pio_words,
+		if (!host->pio_bytes) {
+			res = get_data_buffer(host, &host->pio_bytes,
 							&host->pio_ptr);
 			if (res) {
 				dbg(host, dbg_pio,
@@ -317,16 +337,23 @@ static void do_pio_write(struct s3cmci_h
 
 			dbg(host, dbg_pio,
 			    "pio_write(): new source: [%i]@[%p]\n",
-			    host->pio_words, host->pio_ptr);
+			    host->pio_bytes, host->pio_ptr);
 
 		}
 
-		if (fifo > host->pio_words)
-			fifo = host->pio_words;
+		/* If we have reached the end of the block, we have to
+		 * write exactly the remaining number of bytes.  If we
+		 * in the middle of the block, we have to write full
+		 * words, so round down to an even multiple of 4. */
+		if (fifo >= host->pio_bytes)
+			fifo = host->pio_bytes;
+		else
+			fifo -= fifo & 3;
 
-		host->pio_words -= fifo;
+		host->pio_bytes -= fifo;
 		host->pio_count += fifo;
 
+		fifo = (fifo + 3) >> 2;
 		while (fifo--)
 			writel(*(host->pio_ptr++), to_ptr);
 	}
@@ -351,9 +378,9 @@ static void pio_tasklet(unsigned long da
 		clear_imask(host);
 		if (host->pio_active != XFER_NONE) {
 			dbg(host, dbg_err, "unfinished %s "
-			    "- pio_count:[%u] pio_words:[%u]\n",
+			    "- pio_count:[%u] pio_bytes:[%u]\n",
 			    (host->pio_active == XFER_READ) ? "read" : "write",
-			    host->pio_count, host->pio_words);
+			    host->pio_count, host->pio_bytes);
 
 			if (host->mrq->data)
 				host->mrq->data->error = -EINVAL;
@@ -813,11 +840,10 @@ static int s3cmci_setup_data(struct s3cm
 		/* We cannot deal with unaligned blocks with more than
 		 * one block being transfered. */
 
-		if (data->blocks > 1)
+		if (data->blocks > 1) {
+			pr_warning("%s: can't do non-word sized block transfers (blksz %d)\n", __func__, data->blksz);
 			return -EINVAL;
-
-		/* No support yet for non-word block transfers. */
-		return -EINVAL;
+		}
 	}
 
 	while (readl(host->base + S3C2410_SDIDSTA) &
@@ -897,7 +923,7 @@ static int s3cmci_prepare_pio(struct s3c
 	BUG_ON((data->flags & BOTH_DIR) == BOTH_DIR);
 
 	host->pio_sgptr = 0;
-	host->pio_words = 0;
+	host->pio_bytes = 0;
 	host->pio_count = 0;
 	host->pio_active = rw ? XFER_WRITE : XFER_READ;
 
Index: linux-2.6.26.2/drivers/mmc/host/s3cmci.h
===================================================================
--- linux-2.6.26.2.orig/drivers/mmc/host/s3cmci.h
+++ linux-2.6.26.2/drivers/mmc/host/s3cmci.h
@@ -51,7 +51,7 @@ struct s3cmci_host {
 	int			dma_complete;
 
 	u32			pio_sgptr;
-	u32			pio_words;
+	u32			pio_bytes;
 	u32			pio_count;
 	u32			*pio_ptr;
 #define XFER_NONE 0

-- 
"Just how much can I get away with and still go to heaven?"

Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
