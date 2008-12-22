Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbYLVOjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbYLVOjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 09:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYLVOi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 09:38:56 -0500
Received: from phoenix.clifford.at ([88.198.7.52]:34373 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbYLVOiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 09:38:55 -0500
X-Greylist: delayed 1470 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Dec 2008 09:38:55 EST
Date: Mon, 22 Dec 2008 14:55:42 +0100
From: Clifford Wolf <clifford@clifford.at>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Cox <adrian@humboldt.co.uk>
Subject: [PATCH] Fixed i2c-mpc driver for multi-master i2c busses.
Message-ID: <20081222135542.GA7317@clifford.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed i2c-mpc driver for multi-master i2c busses.

Simply retry on arbitration lost until xfer is successfull,
a non-arbitration-lost error is triggered or the 1s timeout
is hit.

Tested with a freescale MPC8349E host cpu.

Signed-off-by: Clifford Wolf <clifford@clifford.at>

--- ./drivers/i2c/busses/i2c-mpc.c	(revision 2186)
+++ ./drivers/i2c/busses/i2c-mpc.c	(revision 2187)
@@ -133,16 +133,16 @@
 	if (result < 0)
 		return result;
 
+	if (x & CSR_MAL) {
+		pr_debug("I2C: MAL\n");
+		return -EAGAIN;
+	}
+
 	if (!(x & CSR_MCF)) {
 		pr_debug("I2C: unfinished\n");
 		return -EIO;
 	}
 
-	if (x & CSR_MAL) {
-		pr_debug("I2C: MAL\n");
-		return -EIO;
-	}
-
 	if (writing && (x & CSR_RXAK)) {
 		pr_debug("I2C: No RXAK\n");
 		/* generate stop */
@@ -256,11 +256,11 @@
 static int mpc_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 {
 	struct i2c_msg *pmsg;
-	int i;
-	int ret = 0;
+	int i, ret;
 	unsigned long orig_jiffies = jiffies;
 	struct mpc_i2c *i2c = i2c_get_adapdata(adap);
 
+restart:
 	mpc_i2c_start(i2c);
 
 	/* Allow bus up to 1s to become not busy */
@@ -280,7 +280,7 @@
 		schedule();
 	}
 
-	for (i = 0; ret >= 0 && i < num; i++) {
+	for (i = 0, ret = 0; ret >= 0 && i < num; i++) {
 		pmsg = &msgs[i];
 		pr_debug("Doing %s %d bytes to 0x%02x - %d of %d messages\n",
 			 pmsg->flags & I2C_M_RD ? "read" : "write",
@@ -291,7 +291,13 @@
 		else
 			ret =
 			    mpc_write(i2c, pmsg->addr, pmsg->buf, pmsg->len, i);
+		if (ret == -EAGAIN) {
+			pr_debug("Lost i2c arbitration -> retry.\n");
+			mpc_i2c_stop(i2c);
+			goto restart;
+		}
 	}
+
 	mpc_i2c_stop(i2c);
 	return (ret < 0) ? ret : num;
 }
