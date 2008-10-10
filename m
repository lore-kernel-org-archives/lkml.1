Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbYJJKdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbYJJKdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbYJJKdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:33:18 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:47558 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753309AbYJJKdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:33:16 -0400
Message-Id: <20081010103315.018685149@fluff.org.uk>
References: <20081010103221.551485781@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Fri, 10 Oct 2008 11:32:25 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org,
       linux-arm-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>
Subject: [patch 4/5] s3cmci: fix continual accesses to host->pio_ptr
Content-Disposition: inline; filename=simtec/s3c24xx-mmc-faster-transfer-core.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The s3cmci driver uses the host->pio_ptr field to
point to the current position into the buffer for data
transfer. During the transfers it does the following:

	while (fifo_words--)
		*(host->pio_ptr++) = readl(from_ptr);

This is inefficent, as host->pio_ptr is not used in any
other part of the transfer but the compiler emits code
which does the following:

	while (fifo_words--) {
		u32 *ptr = host->pio_ptr;
		*ptr = readl(from_ptr);
		ptr++;
		host->pio_ptr = ptr;
	}

This is obviously a waste of a load and store each time
around the loop, which could be up to 16 times depending
on how much needs to be transfered.

Move the ptr accesses to outside the while loop so that
we do not end up reloading/re-writing the pointer.

Note, this seems to make the code 16 bytes larger.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Index: linux-2.6.27-rc5-quilt1/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.27-rc5-quilt1.orig/drivers/mmc/host/s3cmci.c	2008-09-08 16:50:27.000000000 +0100
+++ linux-2.6.27-rc5-quilt1/drivers/mmc/host/s3cmci.c	2008-09-08 16:52:21.000000000 +0100
@@ -238,6 +238,7 @@ static void do_pio_read(struct s3cmci_ho
 {
 	int res;
 	u32 fifo;
+	u32 *ptr;
 	u32 fifo_words;
 	void __iomem *from_ptr;
 
@@ -283,8 +284,10 @@ static void do_pio_read(struct s3cmci_ho
 		host->pio_count += fifo;
 
 		fifo_words = fifo >> 2;
+		ptr = host->pio_ptr;
 		while (fifo_words--)
-			*(host->pio_ptr++) = readl(from_ptr);
+			*ptr++ = readl(from_ptr);
+		host->pio_ptr = ptr;
 
 		if (fifo & 3) {
 			u32 n = fifo & 3;
@@ -319,6 +322,7 @@ static void do_pio_write(struct s3cmci_h
 	void __iomem *to_ptr;
 	int res;
 	u32 fifo;
+	u32 *ptr;
 
 	to_ptr = host->base + host->sdidata;
 
@@ -353,8 +357,10 @@ static void do_pio_write(struct s3cmci_h
 		host->pio_count += fifo;
 
 		fifo = (fifo + 3) >> 2;
+		ptr = host->pio_ptr;
 		while (fifo--)
-			writel(*(host->pio_ptr++), to_ptr);
+			writel(*ptr++, to_ptr);
+		host->pio_ptr = ptr;
 	}
 
 	enable_imask(host, S3C2410_SDIIMSK_TXFIFOHALF);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
