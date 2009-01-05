Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbZAENVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbZAENVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZAENVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:21:08 -0500
Received: from phoenix.clifford.at ([88.198.7.52]:39114 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZAENVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:21:07 -0500
Date: Mon, 5 Jan 2009 14:21:02 +0100
From: Clifford Wolf <clifford@clifford.at>
To: linux-kernel@vger.kernel.org, i2c@lm-sensors.org,
       akpm@linux-foundation.org, khali@linux-fr.org, adrian@humboldt.co.uk
Subject: [PATCH] Incremental i2c-mpc driver fix for multi-master i2c busses.
Message-ID: <20090105132102.GA27855@clifford.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Incremental i2c-mpc driver fix for multi-master i2c busses.

This is an incremental bugfix for the i2c-mpc driver. It is based
on the bugfix I've sent on 2008-12-22:

	http://lkml.org/lkml/2008/12/22/99

There still was a remaining problem with multi-master i2c busses
when an i2c bus access is interrupted by a unix signal while
waiting for bus arbitration.

This is an extreamly rare case but I managed to stumble over it in
multi master i2c performance tests.

Tested with a freescale MPC8349E host cpu.

Signed-off-by: Clifford Wolf <clifford@clifford.at>

--- drivers/i2c/busses/i2c-mpc.c	(revision 2216)
+++ drivers/i2c/busses/i2c-mpc.c	(working copy)
@@ -105,7 +105,7 @@
 			schedule();
 			if (time_after(jiffies, orig_jiffies + timeout)) {
 				pr_debug("I2C: timeout\n");
-				writeccr(i2c, 0);
+				writeccr(i2c, CCR_MEN);
 				result = -EIO;
 				break;
 			}
@@ -119,10 +119,10 @@
 
 		if (unlikely(result < 0)) {
 			pr_debug("I2C: wait interrupted\n");
-			writeccr(i2c, 0);
+			writeccr(i2c, CCR_MEN);
 		} else if (unlikely(!(i2c->interrupt & CSR_MIF))) {
 			pr_debug("I2C: wait timeout\n");
-			writeccr(i2c, 0);
+			writeccr(i2c, CCR_MEN);
 			result = -ETIMEDOUT;
 		}
 
@@ -267,7 +267,7 @@
 	while (readb(i2c->base + MPC_I2C_SR) & CSR_MBB) {
 		if (signal_pending(current)) {
 			pr_debug("I2C: Interrupted\n");
-			writeccr(i2c, 0);
+			writeccr(i2c, CCR_MEN);
 			return -EINTR;
 		}
 		if (time_after(jiffies, orig_jiffies + HZ)) {
@@ -369,6 +369,15 @@
 		goto fail_add;
 	}
 
+	/* Make sure the adapter is already in master mode some time before
+	 * the first xfer to make sure arbitration control had enough time
+	 * to monitor the bus. The CCR_MEN flag should never be cleared without
+	 * makeing sure there is some delay between setting it again and
+	 * starting the first transfer..
+	 */
+	writeccr(i2c, CCR_MEN);
+	udelay(100);
+
 	return result;
 
       fail_add:

-- 
The great thing about Object Oriented code is that it can make small,
simple problems look like large, complex ones.
