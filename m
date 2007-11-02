Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbXKBGZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbXKBGZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 02:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbXKBGYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 02:24:33 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:23837 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbXKBGYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 02:24:30 -0400
X-IronPort-AV: i="4.21,361,1188792000"; 
   d="scan'208"; a="55433966:sNHT50282001"
From: Bryan Wu <bryan.wu@analog.com>
To: khali@linux-fr.org, i2c@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 2/4] Blackfin I2C/TWI driver: Add platform_resource interface to support multi-port TWI controllers
Date: Fri,  2 Nov 2007 14:24:22 +0800
Message-Id: <1193984664-10609-3-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193984664-10609-1-git-send-email-bryan.wu@analog.com>
References: <1193984664-10609-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 - Dynamic alloc the resource of TWI driver data according to board information
 - TWI register read/write accessor based on dynamic regs_base
 - Support TWI0/TWI1 for BF54x

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c |  269 +++++++++++++++++++++++--------------
 1 files changed, 166 insertions(+), 103 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 6535852..e495454 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -62,43 +62,66 @@ struct bfin_twi_iface {
 	struct i2c_msg 		*pmsg;
 	int			msg_num;
 	int			cur_msg;
+	void __iomem		*regs_base;
 };
 
-static struct bfin_twi_iface twi_iface;
+
+#define DEFINE_TWI_REG(reg, off) \
+static inline u16 read_##reg(struct bfin_twi_iface *iface) \
+	{ return bfin_read16(iface->regs_base + off); } \
+static inline void write_##reg(struct bfin_twi_iface *iface, u16 v) \
+	{bfin_write16(iface->regs_base + off, v); }
+
+DEFINE_TWI_REG(CLKDIV, 0x00)
+DEFINE_TWI_REG(CONTROL, 0x04)
+DEFINE_TWI_REG(SLAVE_CTL, 0x08)
+DEFINE_TWI_REG(SLAVE_STAT, 0x0C)
+DEFINE_TWI_REG(SLAVE_ADDR, 0x10)
+DEFINE_TWI_REG(MASTER_CTL, 0x14)
+DEFINE_TWI_REG(MASTER_STAT, 0x18)
+DEFINE_TWI_REG(MASTER_ADDR, 0x1C)
+DEFINE_TWI_REG(INT_STAT, 0x20)
+DEFINE_TWI_REG(INT_MASK, 0x24)
+DEFINE_TWI_REG(FIFO_CTL, 0x28)
+DEFINE_TWI_REG(FIFO_STAT, 0x2C)
+DEFINE_TWI_REG(XMT_DATA8, 0x80)
+DEFINE_TWI_REG(XMT_DATA16, 0x84)
+DEFINE_TWI_REG(RCV_DATA8, 0x88)
+DEFINE_TWI_REG(RCV_DATA16, 0x8C)
 
 static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 {
-	unsigned short twi_int_status = bfin_read_TWI_INT_STAT();
-	unsigned short mast_stat = bfin_read_TWI_MASTER_STAT();
+	unsigned short twi_int_status = read_INT_STAT(iface);
+	unsigned short mast_stat = read_MASTER_STAT(iface);
 
 	if (twi_int_status & XMTSERV) {
 		/* Transmit next data */
 		if (iface->writeNum > 0) {
-			bfin_write_TWI_XMT_DATA8(*(iface->transPtr++));
+			write_XMT_DATA8(iface, *(iface->transPtr++));
 			iface->writeNum--;
 		}
 		/* start receive immediately after complete sending in
 		 * combine mode.
 		 */
 		else if (iface->cur_mode == TWI_I2C_MODE_COMBINED)
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
-				| MDIR | RSTART);
+			write_MASTER_CTL(iface,
+				read_MASTER_CTL(iface) | MDIR | RSTART);
 		else if (iface->manual_stop)
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
-				| STOP);
+			write_MASTER_CTL(iface,
+				read_MASTER_CTL(iface) | STOP);
 		else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
 				iface->cur_msg+1 < iface->msg_num)
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
-				| RSTART);
+			write_MASTER_CTL(iface,
+				read_MASTER_CTL(iface) | RSTART);
 		SSYNC();
 		/* Clear status */
-		bfin_write_TWI_INT_STAT(XMTSERV);
+		write_INT_STAT(iface, XMTSERV);
 		SSYNC();
 	}
 	if (twi_int_status & RCVSERV) {
 		if (iface->readNum > 0) {
 			/* Receive next data */
-			*(iface->transPtr) = bfin_read_TWI_RCV_DATA8();
+			*(iface->transPtr) = read_RCV_DATA8(iface);
 			if (iface->cur_mode == TWI_I2C_MODE_COMBINED) {
 				/* Change combine mode into sub mode after
 				 * read first data.
@@ -113,33 +136,33 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 			iface->transPtr++;
 			iface->readNum--;
 		} else if (iface->manual_stop) {
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
-				| STOP);
+			write_MASTER_CTL(iface,
+				read_MASTER_CTL(iface) | STOP);
 			SSYNC();
 		} else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
 				iface->cur_msg+1 < iface->msg_num) {
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
-				| RSTART);
+			write_MASTER_CTL(iface,
+				read_MASTER_CTL(iface) | RSTART);
 			SSYNC();
 		}
 		/* Clear interrupt source */
-		bfin_write_TWI_INT_STAT(RCVSERV);
+		write_INT_STAT(iface, RCVSERV);
 		SSYNC();
 	}
 	if (twi_int_status & MERR) {
-		bfin_write_TWI_INT_STAT(MERR);
-		bfin_write_TWI_INT_MASK(0);
-		bfin_write_TWI_MASTER_STAT(0x3e);
-		bfin_write_TWI_MASTER_CTL(0);
+		write_INT_STAT(iface, MERR);
+		write_INT_MASK(iface, 0);
+		write_MASTER_STAT(iface, 0x3e);
+		write_MASTER_CTL(iface, 0);
 		SSYNC();
 		iface->result = -EIO;
 		/* if both err and complete int stats are set, return proper
 		 * results.
 		 */
 		if (twi_int_status & MCOMP) {
-			bfin_write_TWI_INT_STAT(MCOMP);
-			bfin_write_TWI_INT_MASK(0);
-			bfin_write_TWI_MASTER_CTL(0);
+			write_INT_STAT(iface, MCOMP);
+			write_INT_MASK(iface, 0);
+			write_MASTER_CTL(iface, 0);
 			SSYNC();
 			/* If it is a quick transfer, only address bug no data,
 			 * not an err, return 1.
@@ -156,7 +179,7 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 		return;
 	}
 	if (twi_int_status & MCOMP) {
-		bfin_write_TWI_INT_STAT(MCOMP);
+		write_INT_STAT(iface, MCOMP);
 		SSYNC();
 		if (iface->cur_mode == TWI_I2C_MODE_COMBINED) {
 			if (iface->readNum == 0) {
@@ -165,23 +188,22 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 				 */
 				iface->readNum = 1;
 				iface->manual_stop = 1;
-				bfin_write_TWI_MASTER_CTL(
-					bfin_read_TWI_MASTER_CTL()
-					| (0xff << 6));
+				write_MASTER_CTL(iface,
+					read_MASTER_CTL(iface) | (0xff << 6));
 			} else {
 				/* set the readd number in other
 				 * combine mode.
 				 */
-				bfin_write_TWI_MASTER_CTL(
-					(bfin_read_TWI_MASTER_CTL() &
+				write_MASTER_CTL(iface,
+					(read_MASTER_CTL(iface) &
 					(~(0xff << 6))) |
-					( iface->readNum << 6));
+					(iface->readNum << 6));
 			}
 			/* remove restart bit and enable master receive */
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() &
-				~RSTART);
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() |
-				MEN | MDIR);
+			write_MASTER_CTL(iface,
+				read_MASTER_CTL(iface) & ~RSTART);
+			write_MASTER_CTL(iface,
+				read_MASTER_CTL(iface) | MEN | MDIR);
 			SSYNC();
 		} else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
 				iface->cur_msg+1 < iface->msg_num) {
@@ -190,7 +212,7 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 			iface->writeNum = iface->readNum =
 				iface->pmsg[iface->cur_msg].len;
 			/* Set Transmit device address */
-			bfin_write_TWI_MASTER_ADDR(
+			write_MASTER_ADDR(iface,
 				iface->pmsg[iface->cur_msg].addr);
 			if (iface->pmsg[iface->cur_msg].flags & I2C_M_RD)
 				iface->read_write = I2C_SMBUS_READ;
@@ -198,7 +220,7 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 				iface->read_write = I2C_SMBUS_WRITE;
 				/* Transmit first data */
 				if (iface->writeNum > 0) {
-					bfin_write_TWI_XMT_DATA8(
+					write_XMT_DATA8(iface,
 						*(iface->transPtr++));
 					iface->writeNum--;
 					SSYNC();
@@ -206,23 +228,23 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 			}
 
 			if (iface->pmsg[iface->cur_msg].len <= 255)
-				bfin_write_TWI_MASTER_CTL(
+				write_MASTER_CTL(iface,
 				iface->pmsg[iface->cur_msg].len << 6);
 			else if (iface->pmsg[iface->cur_msg].len > 255) {
-				bfin_write_TWI_MASTER_CTL(0xff << 6);
+				write_MASTER_CTL(iface, 0xff << 6);
 				iface->manual_stop = 1;
 			}
 			/* remove restart bit and enable master receive */
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() &
-				~RSTART);
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() |
+			write_MASTER_CTL(iface,
+				read_MASTER_CTL(iface) & ~RSTART);
+			write_MASTER_CTL(iface, read_MASTER_CTL(iface) |
 				MEN | ((iface->read_write == I2C_SMBUS_READ) ?
 				MDIR : 0));
 			SSYNC();
 		} else {
 			iface->result = 1;
-			bfin_write_TWI_INT_MASK(0);
-			bfin_write_TWI_MASTER_CTL(0);
+			write_INT_MASK(iface, 0);
+			write_MASTER_CTL(iface, 0);
 			SSYNC();
 			complete(&iface->complete);
 		}
@@ -272,12 +294,11 @@ static int bfin_twi_master_xfer(struct i2c_adapter *adap,
 	struct i2c_msg *pmsg;
 	int rc = 0;
 
-	if (!(bfin_read_TWI_CONTROL() & TWI_ENA))
+	if (!(read_CONTROL(iface) & TWI_ENA))
 		return -ENXIO;
 
-	while (bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
+	while (read_MASTER_STAT(iface) & BUSBUSY)
 		yield();
-	}
 
 	iface->pmsg = msgs;
 	iface->msg_num = num;
@@ -296,14 +317,14 @@ static int bfin_twi_master_xfer(struct i2c_adapter *adap,
 	iface->result = 0;
 	iface->timeout_count = 10;
 	/* Set Transmit device address */
-	bfin_write_TWI_MASTER_ADDR(pmsg->addr);
+	write_MASTER_ADDR(iface, pmsg->addr);
 
 	/* FIFO Initiation. Data in FIFO should be
 	 *  discarded before start a new operation.
 	 */
-	bfin_write_TWI_FIFO_CTL(0x3);
+	write_FIFO_CTL(iface, 0x3);
 	SSYNC();
-	bfin_write_TWI_FIFO_CTL(0);
+	write_FIFO_CTL(iface, 0);
 	SSYNC();
 
 	if (pmsg->flags & I2C_M_RD)
@@ -312,23 +333,23 @@ static int bfin_twi_master_xfer(struct i2c_adapter *adap,
 		iface->read_write = I2C_SMBUS_WRITE;
 		/* Transmit first data */
 		if (iface->writeNum > 0) {
-			bfin_write_TWI_XMT_DATA8(*(iface->transPtr++));
+			write_XMT_DATA8(iface, *(iface->transPtr++));
 			iface->writeNum--;
 			SSYNC();
 		}
 	}
 
 	/* clear int stat */
-	bfin_write_TWI_INT_STAT(MERR | MCOMP | XMTSERV | RCVSERV);
+	write_INT_STAT(iface, MERR | MCOMP | XMTSERV | RCVSERV);
 
 	/* Interrupt mask . Enable XMT, RCV interrupt */
-	bfin_write_TWI_INT_MASK(MCOMP | MERR | RCVSERV | XMTSERV);
+	write_INT_MASK(iface, MCOMP | MERR | RCVSERV | XMTSERV);
 	SSYNC();
 
 	if (pmsg->len <= 255)
-		bfin_write_TWI_MASTER_CTL(pmsg->len << 6);
+		write_MASTER_CTL(iface, pmsg->len << 6);
 	else if (pmsg->len > 255) {
-		bfin_write_TWI_MASTER_CTL(0xff << 6);
+		write_MASTER_CTL(iface, 0xff << 6);
 		iface->manual_stop = 1;
 	}
 
@@ -336,7 +357,7 @@ static int bfin_twi_master_xfer(struct i2c_adapter *adap,
 	add_timer(&iface->timeout_timer);
 
 	/* Master enable */
-	bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() | MEN |
+	write_MASTER_CTL(iface, read_MASTER_CTL(iface) | MEN |
 		((iface->read_write == I2C_SMBUS_READ) ? MDIR : 0) |
 		((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ > 100) ? FAST : 0));
 	SSYNC();
@@ -362,12 +383,11 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 	struct bfin_twi_iface *iface = adap->algo_data;
 	int rc = 0;
 
-	if (!(bfin_read_TWI_CONTROL() & TWI_ENA))
+	if (!(read_CONTROL(iface) & TWI_ENA))
 		return -ENXIO;
 
-	while (bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
+	while (read_MASTER_STAT(iface) & BUSBUSY)
 		yield();
-	}
 
 	iface->writeNum = 0;
 	iface->readNum = 0;
@@ -439,15 +459,15 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 	/* FIFO Initiation. Data in FIFO should be discarded before
 	 * start a new operation.
 	 */
-	bfin_write_TWI_FIFO_CTL(0x3);
+	write_FIFO_CTL(iface, 0x3);
 	SSYNC();
-	bfin_write_TWI_FIFO_CTL(0);
+	write_FIFO_CTL(iface, 0);
 
 	/* clear int stat */
-	bfin_write_TWI_INT_STAT(MERR|MCOMP|XMTSERV|RCVSERV);
+	write_INT_STAT(iface, MERR | MCOMP | XMTSERV | RCVSERV);
 
 	/* Set Transmit device address */
-	bfin_write_TWI_MASTER_ADDR(addr);
+	write_MASTER_ADDR(iface, addr);
 	SSYNC();
 
 	iface->timeout_timer.expires = jiffies + POLL_TIMEOUT;
@@ -455,60 +475,64 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 
 	switch (iface->cur_mode) {
 	case TWI_I2C_MODE_STANDARDSUB:
-		bfin_write_TWI_XMT_DATA8(iface->command);
-		bfin_write_TWI_INT_MASK(MCOMP | MERR |
+		write_XMT_DATA8(iface, iface->command);
+		write_INT_MASK(iface, MCOMP | MERR |
 			((iface->read_write == I2C_SMBUS_READ) ?
 			RCVSERV : XMTSERV));
 		SSYNC();
 
 		if (iface->writeNum + 1 <= 255)
-			bfin_write_TWI_MASTER_CTL((iface->writeNum + 1) << 6);
+			write_MASTER_CTL(iface, (iface->writeNum + 1) << 6);
 		else {
-			bfin_write_TWI_MASTER_CTL(0xff << 6);
+			write_MASTER_CTL(iface, 0xff << 6);
 			iface->manual_stop = 1;
 		}
 		/* Master enable */
-		bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() | MEN |
+		write_MASTER_CTL(iface, read_MASTER_CTL(iface) | MEN |
 			((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ>100) ? FAST : 0));
 		break;
 	case TWI_I2C_MODE_COMBINED:
-		bfin_write_TWI_XMT_DATA8(iface->command);
-		bfin_write_TWI_INT_MASK(MCOMP | MERR | RCVSERV | XMTSERV);
+		write_XMT_DATA8(iface, iface->command);
+		write_INT_MASK(iface, MCOMP | MERR | RCVSERV | XMTSERV);
 		SSYNC();
 
 		if (iface->writeNum > 0)
-			bfin_write_TWI_MASTER_CTL((iface->writeNum + 1) << 6);
+			write_MASTER_CTL(iface, (iface->writeNum + 1) << 6);
 		else
-			bfin_write_TWI_MASTER_CTL(0x1 << 6);
+			write_MASTER_CTL(iface, 0x1 << 6);
 		/* Master enable */
-		bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() | MEN |
+		write_MASTER_CTL(iface, read_MASTER_CTL(iface) | MEN |
 			((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ>100) ? FAST : 0));
 		break;
 	default:
-		bfin_write_TWI_MASTER_CTL(0);
+		write_MASTER_CTL(iface, 0);
 		if (size != I2C_SMBUS_QUICK) {
 			/* Don't access xmit data register when this is a
 			 * read operation.
 			 */
 			if (iface->read_write != I2C_SMBUS_READ) {
 				if (iface->writeNum > 0) {
-					bfin_write_TWI_XMT_DATA8(*(iface->transPtr++));
+					write_XMT_DATA8(iface,
+						*(iface->transPtr++));
 					if (iface->writeNum <= 255)
-						bfin_write_TWI_MASTER_CTL(iface->writeNum << 6);
+						write_MASTER_CTL(iface,
+							iface->writeNum << 6);
 					else {
-						bfin_write_TWI_MASTER_CTL(0xff << 6);
+						write_MASTER_CTL(iface,
+							0xff << 6);
 						iface->manual_stop = 1;
 					}
 					iface->writeNum--;
 				} else {
-					bfin_write_TWI_XMT_DATA8(iface->command);
-					bfin_write_TWI_MASTER_CTL(1 << 6);
+					write_XMT_DATA8(iface, iface->command);
+					write_MASTER_CTL(iface, 1 << 6);
 				}
 			} else {
 				if (iface->readNum > 0 && iface->readNum <= 255)
-					bfin_write_TWI_MASTER_CTL(iface->readNum << 6);
+					write_MASTER_CTL(iface,
+						iface->readNum << 6);
 				else if (iface->readNum > 255) {
-					bfin_write_TWI_MASTER_CTL(0xff << 6);
+					write_MASTER_CTL(iface, 0xff << 6);
 					iface->manual_stop = 1;
 				} else {
 					del_timer(&iface->timeout_timer);
@@ -516,13 +540,13 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 				}
 			}
 		}
-		bfin_write_TWI_INT_MASK(MCOMP | MERR |
+		write_INT_MASK(iface, MCOMP | MERR |
 			((iface->read_write == I2C_SMBUS_READ) ?
 			RCVSERV : XMTSERV));
 		SSYNC();
 
 		/* Master enable */
-		bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() | MEN |
+		write_MASTER_CTL(iface, read_MASTER_CTL(iface) | MEN |
 			((iface->read_write == I2C_SMBUS_READ) ? MDIR : 0) |
 			((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ > 100) ? FAST : 0));
 		break;
@@ -557,10 +581,10 @@ static struct i2c_algorithm bfin_twi_algorithm = {
 
 static int i2c_bfin_twi_suspend(struct platform_device *dev, pm_message_t state)
 {
-/*	struct bfin_twi_iface *iface = platform_get_drvdata(dev);*/
+	struct bfin_twi_iface *iface = platform_get_drvdata(dev);
 
 	/* Disable TWI */
-	bfin_write_TWI_CONTROL(bfin_read_TWI_CONTROL() & ~TWI_ENA);
+	write_CONTROL(iface, read_CONTROL(iface) & ~TWI_ENA);
 	SSYNC();
 
 	return 0;
@@ -568,24 +592,53 @@ static int i2c_bfin_twi_suspend(struct platform_device *dev, pm_message_t state)
 
 static int i2c_bfin_twi_resume(struct platform_device *dev)
 {
-/*	struct bfin_twi_iface *iface = platform_get_drvdata(dev);*/
+	struct bfin_twi_iface *iface = platform_get_drvdata(dev);
 
 	/* Enable TWI */
-	bfin_write_TWI_CONTROL(bfin_read_TWI_CONTROL() | TWI_ENA);
+	write_CONTROL(iface, read_CONTROL(iface) | TWI_ENA);
 	SSYNC();
 
 	return 0;
 }
 
-static int i2c_bfin_twi_probe(struct platform_device *dev)
+static int i2c_bfin_twi_probe(struct platform_device *pdev)
 {
-	struct bfin_twi_iface *iface = &twi_iface;
+	struct bfin_twi_iface *iface;
 	struct i2c_adapter *p_adap;
+	struct resource *res;
 	int rc;
 
+	iface = kzalloc(sizeof(struct bfin_twi_iface), GFP_KERNEL);
+	if (!iface) {
+		dev_err(&pdev->dev, "Cannot allocate memory\n");
+		rc = -ENOMEM;
+		goto out_error_nomem;
+	}
+
 	spin_lock_init(&(iface->lock));
 	init_completion(&(iface->complete));
-	iface->irq = IRQ_TWI;
+
+	/* Find and map our resources */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "Cannot get IORESOURCE_MEM\n");
+		rc = -ENOENT;
+		goto out_error_get_res;
+	}
+
+	iface->regs_base = ioremap(res->start, (res->end - res->start)+1);
+	if (iface->regs_base == NULL) {
+		dev_err(&pdev->dev, "Cannot map IO\n");
+		rc = -ENXIO;
+		goto out_error_ioremap;
+	}
+
+	iface->irq = platform_get_irq(pdev, 0);
+	if (iface->irq < 0) {
+		dev_err(&pdev->dev, "No IRQ specified\n");
+		rc = -ENOENT;
+		goto out_error_no_irq;
+	}
 
 	init_timer(&(iface->timeout_timer));
 	iface->timeout_timer.function = bfin_twi_timeout;
@@ -593,38 +646,50 @@ static int i2c_bfin_twi_probe(struct platform_device *dev)
 
 	p_adap = &iface->adap;
 	p_adap->id = I2C_HW_BLACKFIN;
-	strlcpy(p_adap->name, dev->name, sizeof(p_adap->name));
+	strlcpy(p_adap->name, pdev->name, sizeof(p_adap->name));
 	p_adap->algo = &bfin_twi_algorithm;
 	p_adap->algo_data = iface;
 	p_adap->class = I2C_CLASS_ALL;
-	p_adap->dev.parent = &dev->dev;
+	p_adap->dev.parent = &pdev->dev;
 
 	rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
-		IRQF_DISABLED, dev->name, iface);
+		IRQF_DISABLED, pdev->name, iface);
 	if (rc) {
-		dev_err(&(p_adap->dev), "i2c-bfin-twi: can't get IRQ %d !\n",
-			iface->irq);
-		return -ENODEV;
+		dev_err(&pdev->dev, "can't get IRQ %d !\n", iface->irq);
+		rc = -ENODEV;
+		goto out_error_req_irq;
 	}
 
 	/* Set TWI internal clock as 10MHz */
-	bfin_write_TWI_CONTROL(((get_sclk() / 1024 / 1024 + 5) / 10) & 0x7F);
+	write_CONTROL(iface, ((get_sclk() / 1024 / 1024 + 5) / 10) & 0x7F);
 
 	/* Set Twi interface clock as specified */
-	bfin_write_TWI_CLKDIV((( 5*1024 / CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ )
-			<< 8) | (( 5*1024 / CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ )
+	write_CLKDIV(iface, ((5*1024 / CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ)
+			<< 8) | ((5*1024 / CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ)
 			& 0xFF));
 
 	/* Enable TWI */
-	bfin_write_TWI_CONTROL(bfin_read_TWI_CONTROL() | TWI_ENA);
+	write_CONTROL(iface, read_CONTROL(iface) | TWI_ENA);
 	SSYNC();
 
 	rc = i2c_add_adapter(p_adap);
 	if (rc < 0)
 		free_irq(iface->irq, iface);
 	else
-		platform_set_drvdata(dev, iface);
+		platform_set_drvdata(pdev, iface);
 
+	dev_info(&pdev->dev, "Blackfin I2C TWI controller, regs_base@%p\n",
+		iface->regs_base);
+
+	return rc;
+
+out_error_req_irq:
+out_error_no_irq:
+	iounmap(iface->regs_base);
+out_error_ioremap:
+out_error_get_res:
+	kfree(iface);
+out_error_nomem:
 	return rc;
 }
 
@@ -653,8 +718,6 @@ static struct platform_driver i2c_bfin_twi_driver = {
 
 static int __init i2c_bfin_twi_init(void)
 {
-	pr_info("I2C: Blackfin I2C TWI driver\n");
-
 	return platform_driver_register(&i2c_bfin_twi_driver);
 }
 
-- 
1.5.3.4
