Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab0CAMYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 07:24:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36593 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab0CAMYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 07:24:48 -0500
From: Luotao Fu <l.fu@pengutronix.de>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
       Kevin Wells <kevin.wells@nxp.com>, Julia Lawall <julia@diku.dk>,
       Russell King <rmk+kernel@arm.linux.org.uk>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH] i2c-pnx: fix setting start/stop condition
Date: Mon,  1 Mar 2010 13:24:24 +0100
Message-Id: <1267446264-8446-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.7.0
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The start/stop condtions are set in different places repetedly in the i2c-pnx
driver.  Beside in i2c_pnx_start and i2c_pnx_stop the start/stop bit are also
set during the transfer of a i2c message in the master_xmit/rcv calls. This is
wrong since we can't set the start/stop condition during the transaction of a
single message any way. As a matter of fact, the driver will sometimes set both
the start and the stop bits at one time. This can be easily reproduced by
sending a simple read request like e.g
struct i2c_msg msgs[] = {
{ addr, 0, 1, buf },
{ addr, I2C_M_RD, offset, buf }
};
While processing the first message the i2c_pnx_master_xmit will set both the
start_bit and the stop_bit, which will eventually confuse the slave.

Fixed by remove setting start/stop condition from the transmit routines.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/i2c/busses/i2c-pnx.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pnx.c b/drivers/i2c/busses/i2c-pnx.c
index 5d1c260..92c0e46 100644
--- a/drivers/i2c/busses/i2c-pnx.c
+++ b/drivers/i2c/busses/i2c-pnx.c
@@ -175,12 +175,6 @@ static int i2c_pnx_master_xmit(struct i2c_adapter *adap)
 		/* We still have something to talk about... */
 		val = *alg_data->mif.buf++;
 
-		if (alg_data->mif.len == 1) {
-			val |= stop_bit;
-			if (!alg_data->last)
-				val |= start_bit;
-		}
-
 		alg_data->mif.len--;
 		iowrite32(val, I2C_REG_TX(alg_data));
 
@@ -252,11 +246,6 @@ static int i2c_pnx_master_rcv(struct i2c_adapter *adap)
 			"Rx-fifo...\n", __func__);
 
 		if (alg_data->mif.len == 1) {
-			/* Last byte, do not acknowledge next rcv. */
-			val |= stop_bit;
-			if (!alg_data->last)
-				val |= start_bit;
-
 			/*
 			 * Enable interrupt RFDAIE (data in Rx fifo),
 			 * and disable DRMIE (need data for Tx)
-- 
1.7.0

