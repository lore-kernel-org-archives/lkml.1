Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbZENWrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbZENWrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbZENWmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:17 -0400
Received: from kroah.org ([198.145.64.141]:51567 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010AbZENWmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:06 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:22 2009
Message-Id: <20090514223522.480625164@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:32:49 -0700
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
       alan@lxorguk.ukuu.org.uk, Enrik Berkhan <Enrik.Berkhan@ge.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 14/51] i2c-algo-pca: Let PCA9564 recover from unacked data byte (state 0x30)
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=i2c-algo-pca-let-pca9564-recover-from-unacked-data-byte.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Enrik Berkhan <Enrik.Berkhan@ge.com>

commit 2196d1cf4afab93fb64c2e5b417096e49b661612 upstream

Currently, the i2c-algo-pca driver does nothing if the chip enters state
0x30 (Data byte in I2CDAT has been transmitted; NOT ACK has been
received).  Thus, the i2c bus connected to the controller gets stuck
afterwards.

I have seen this kind of error on a custom board in certain load
situations most probably caused by interference or noise.

A possible reaction is to let the controller generate a STOP condition.
This is documented in the PCA9564 data sheet (2006-09-01) and the same
is done for other NACK states as well.

Further, state 0x38 isn't handled completely, either. Try to do another
START in this case like the data sheet says. As this couldn't be tested,
I've added a comment to try to reset the chip if the START doesn't help
as suggested by Wolfram Sang.

Signed-off-by: Enrik Berkhan <Enrik.Berkhan@ge.com>
Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/algos/i2c-algo-pca.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/i2c/algos/i2c-algo-pca.c
+++ b/drivers/i2c/algos/i2c-algo-pca.c
@@ -270,10 +270,21 @@ static int pca_xfer(struct i2c_adapter *
 
 		case 0x30: /* Data byte in I2CDAT has been transmitted; NOT ACK has been received */
 			DEB2("NOT ACK received after data byte\n");
+			pca_stop(adap);
 			goto out;
 
 		case 0x38: /* Arbitration lost during SLA+W, SLA+R or data bytes */
 			DEB2("Arbitration lost\n");
+			/*
+			 * The PCA9564 data sheet (2006-09-01) says "A
+			 * START condition will be transmitted when the
+			 * bus becomes free (STOP or SCL and SDA high)"
+			 * when the STA bit is set (p. 11).
+			 *
+			 * In case this won't work, try pca_reset()
+			 * instead.
+			 */
+			pca_start(adap);
 			goto out;
 
 		case 0x58: /* Data byte has been received; NOT ACK has been returned */


