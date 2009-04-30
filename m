Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbZD3RXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbZD3RXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764619AbZD3RHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:54 -0400
Received: from kroah.org ([198.145.64.141]:56384 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764590AbZD3RHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:43 2009
Message-Id: <20090430165743.827494475@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       David Brownell <dbrownell@users.sourceforge.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 37/88] spi: spi_write_then_read() bugfixes
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0064-spi-spi_write_then_read-bugfixes.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Brownell <dbrownell@users.sourceforge.net>

upstream commit: bdff549ebeff92b1a6952e5501caf16a6f8898c8

The "simplify spi_write_then_read()" patch included two regressions from
the 2.6.27 behaviors:

 - The data it wrote out during the (full duplex) read side
   of the transfer was not zeroed.

 - It fails completely on half duplex hardware, such as
   Microwire and most "3-wire" SPI variants.

So, revert that patch.  A revised version should be submitted at some
point, which can get the speedup on standard hardware (full duplex)
without breaking on less-capable half-duplex stuff.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/spi/spi.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -660,7 +660,7 @@ int spi_write_then_read(struct spi_devic
 
 	int			status;
 	struct spi_message	message;
-	struct spi_transfer	x;
+	struct spi_transfer	x[2];
 	u8			*local_buf;
 
 	/* Use preallocated DMA-safe buffer.  We can't avoid copying here,
@@ -671,9 +671,15 @@ int spi_write_then_read(struct spi_devic
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
@@ -684,15 +690,15 @@ int spi_write_then_read(struct spi_devic
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


