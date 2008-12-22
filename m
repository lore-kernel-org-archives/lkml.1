Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYLVVC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYLVVC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbYLVVCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:02:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754378AbYLVVCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:02:49 -0500
Date: Mon, 22 Dec 2008 13:01:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Clifford Wolf <clifford@clifford.at>
Cc: linux-kernel@vger.kernel.org, adrian@humboldt.co.uk, i2c@lm-sensors.org
Subject: Re: [PATCH] Fixed i2c-mpc driver for multi-master i2c busses.
Message-Id: <20081222130124.a6eb9e1e.akpm@linux-foundation.org>
In-Reply-To: <20081222135542.GA7317@clifford.at>
References: <20081222135542.GA7317@clifford.at>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc i2c@lm-sensors.org)

On Mon, 22 Dec 2008 14:55:42 +0100
Clifford Wolf <clifford@clifford.at> wrote:

> Fixed i2c-mpc driver for multi-master i2c busses.
> 
> Simply retry on arbitration lost until xfer is successfull,
> a non-arbitration-lost error is triggered or the 1s timeout
> is hit.
> 
> Tested with a freescale MPC8349E host cpu.
> 
> Signed-off-by: Clifford Wolf <clifford@clifford.at>

From: Clifford Wolf <clifford@clifford.at>

Simply retry on arbitration lost until xfer is successfull, a
non-arbitration-lost error is triggered or the 1s timeout is hit.

Tested with a freescale MPC8349E host cpu.

Signed-off-by: Clifford Wolf <clifford@clifford.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-mpc.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN drivers/i2c/busses/i2c-mpc.c~fixed-i2c-mpc-driver-for-multi-master-i2c-busses drivers/i2c/busses/i2c-mpc.c
--- a/drivers/i2c/busses/i2c-mpc.c~fixed-i2c-mpc-driver-for-multi-master-i2c-busses
+++ a/drivers/i2c/busses/i2c-mpc.c
@@ -134,13 +134,13 @@ static int i2c_wait(struct mpc_i2c *i2c,
 	if (result < 0)
 		return result;
 
-	if (!(x & CSR_MCF)) {
-		pr_debug("I2C: unfinished\n");
-		return -EIO;
-	}
-
 	if (x & CSR_MAL) {
 		pr_debug("I2C: MAL\n");
+		return -EAGAIN;
+	}
+
+	if (!(x & CSR_MCF)) {
+		pr_debug("I2C: unfinished\n");
 		return -EIO;
 	}
 
@@ -257,11 +257,11 @@ static int mpc_read(struct mpc_i2c *i2c,
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
@@ -281,7 +281,7 @@ static int mpc_xfer(struct i2c_adapter *
 		schedule();
 	}
 
-	for (i = 0; ret >= 0 && i < num; i++) {
+	for (i = 0, ret = 0; ret >= 0 && i < num; i++) {
 		pmsg = &msgs[i];
 		pr_debug("Doing %s %d bytes to 0x%02x - %d of %d messages\n",
 			 pmsg->flags & I2C_M_RD ? "read" : "write",
@@ -292,7 +292,13 @@ static int mpc_xfer(struct i2c_adapter *
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
_

