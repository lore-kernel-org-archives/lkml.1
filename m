Return-Path: <linux-kernel-owner+w=401wt.eu-S1758506AbZDEIHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbZDEIHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 04:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757761AbZDEIHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 04:07:30 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:43796 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757676AbZDEIH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 04:07:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RU2+9KBzo44NZT5BjBBGm46rvz/JvI3PrAYxMVOAFd2iT1o8QXqmguTiTTiaFaiOFCyw9Fk/94NswdnTifDJpT3Pn/5lkyS7ePxLjICG9iXiMexVdJBHIwVSqqtLwfZPhIpxGtLOb6Djh2CL3Ag2jvYIvt6yhsNutlrxYEq4US4=  ;
X-YMail-OSG: jrW29b4VM1l4PQJHAsHfJr4CnwpMAmD12EfjSuGkDWhmvY5.p3z7CVOts0N8sbKDv8OuS5WAIHM_efbqQTZ7_XvpypYEnrkR.UkgeEaaeN6oyIlmffRfhSN8acwtpclcGOkNJ2dldGiI7HZJ4lso1M81mkXp76LVM_5CDB9MYBnyg7JoJexh9sGYPNnpAayymFOlgQZmuZvn1QEQHmEhMpIhux8Jn1ndKKKtUAmC6U7GcIU2O4hW6nsmy_5gJvd0TrJhxGJYLY7tSVbojMRT.nQIBKQ.bOGm2EYUnGSnCilU8Rii.pPp..zLCw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.29-git] spi: spi_write_then_read() bugfixes
Date: Sun, 5 Apr 2009 01:07:23 -0700
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>, Maxime Bizon <mbizon@freebox.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904050107.23410.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

The "simplify spi_write_then_read()" patch included two
regressions from the 2.6.27 behaviors:

 - The data it wrote out during the (full duplex) read side
   of the transfer was not zeroed.

 - It fails completely on half duplex hardware, such as
   Microwire and most "3-wire" SPI variants.

So, revert that patch.  A revised version should be submitted
at some point, which can get the speedup on standard hardware
(full duplex) without breaking on less-capable half-duplex stuff.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Fix should go into '28 and '29 stable kernels.

 drivers/spi/spi.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -658,7 +658,7 @@ int spi_write_then_read(struct spi_devic
 
 	int			status;
 	struct spi_message	message;
-	struct spi_transfer	x;
+	struct spi_transfer	x[2];
 	u8			*local_buf;
 
 	/* Use preallocated DMA-safe buffer.  We can't avoid copying here,
@@ -669,9 +669,15 @@ int spi_write_then_read(struct spi_devic
 		return -EINVAL;
 
 	spi_message_init(&message);
-	memset(&x, 0, sizeof x);
-	x.len = n_tx + n_rx;
-	spi_message_add_tail(&x, &message);
+	memset(x, 0, sizeof x);
+	if (n_tx) {
+		x[0].len = n_tx;
+		spi_message_add_tail(&x[0], &message);
+	}
+	if (n_rx) {
+		x[1].len = n_rx;
+		spi_message_add_tail(&x[1], &message);
+	}
 
 	/* ... unless someone else is using the pre-allocated buffer */
 	if (!mutex_trylock(&lock)) {
@@ -682,15 +688,15 @@ int spi_write_then_read(struct spi_devic
 		local_buf = buf;
 
 	memcpy(local_buf, txbuf, n_tx);
-	x.tx_buf = local_buf;
-	x.rx_buf = local_buf;
+	x[0].tx_buf = local_buf;
+	x[1].rx_buf = local_buf + n_tx;
 
 	/* do the i/o */
 	status = spi_sync(spi, &message);
 	if (status == 0)
-		memcpy(rxbuf, x.rx_buf + n_tx, n_rx);
+		memcpy(rxbuf, x[1].rx_buf, n_rx);
 
-	if (x.tx_buf == buf)
+	if (x[0].tx_buf == buf)
 		mutex_unlock(&lock);
 	else
 		kfree(local_buf);
