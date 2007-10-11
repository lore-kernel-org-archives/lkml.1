Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbXJKKQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbXJKKQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757828AbXJKKQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:16:22 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:29388 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775AbXJKKQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:16:18 -0400
X-IronPort-AV: i="4.21,259,1188792000"; 
   d="scan'208"; a="53762827:sNHT42894348"
From: Bryan Wu <bryan.wu@analog.com>
To: khali@linux-fr.org, i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 2/2] Blackifn I2C/TWI driver: add platform_resource interface to support multi-port TWI controllers and remove old I2C BF54x porting
Date: Thu, 11 Oct 2007 18:16:11 +0800
Message-Id: <1192097771-25417-3-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192097771-25417-1-git-send-email-bryan.wu@analog.com>
References: <1192097771-25417-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/i2c/busses/Kconfig                       |    6 +-
 drivers/i2c/busses/i2c-bfin-twi.c                |  246 ++++++++++++++--------
 include/asm-blackfin/mach-bf548/cdefBF54x_base.h |   33 ---
 3 files changed, 160 insertions(+), 125 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 9f3a4cd..dc14449 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -92,10 +92,10 @@ config I2C_AU1550
 
 config I2C_BLACKFIN_TWI
 	tristate "Blackfin TWI I2C support"
-	depends on BF534 || BF536 || BF537 || BF54x
+	depends on I2C && (BF534 || BF536 || BF537 || BF54x)
 	help
 	  This is the TWI I2C device driver for Blackfin 534/536/537/54x.
-	  This driver can also be built as a module.  If so, the module
+	  This driver can also be built as a module. If so, the module
 	  will be called i2c-bfin-twi.
 
 config I2C_BLACKFIN_TWI_CLK_KHZ
@@ -104,7 +104,7 @@ config I2C_BLACKFIN_TWI_CLK_KHZ
 	range 10 400
 	default 50
 	help
-	  The unit of the TWI clock is kHz.
+	  The unit of the TWI clock is kilo HZ.
 
 config I2C_ELEKTOR
 	tristate "Elektor ISA card"
diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index d636a84..394b1f4 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -7,6 +7,10 @@
  *
  * Copyright (c) 2005-2007 Analog Devices, Inc.
  *
+ * Modified:
+ *	Aug 01, 2007 add platform_resource interface to support multi-port
+ *		     TWI controllers. (Bryan Wu <bryan.wu@analog.com>)
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -65,41 +69,64 @@ struct bfin_twi_iface {
 	int			cur_msg;
 };
 
-static struct bfin_twi_iface twi_iface;
+static u32 twi_regs_base;
+
+#define DEFINE_TWI_REG(reg, off) \
+static inline u16 read_##reg(void) \
+	{ return bfin_read16(twi_regs_base + off); } \
+static inline void write_##reg(u16 v) \
+	{bfin_write16(twi_regs_base + off, v); }
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
+	unsigned short twi_int_status = read_INT_STAT();
+	unsigned short mast_stat = read_MASTER_STAT();
 
 	if (twi_int_status & XMTSERV) {
 		/* Transmit next data */
 		if (iface->writeNum > 0) {
-			bfin_write_TWI_XMT_DATA8(*(iface->transPtr++));
+			write_XMT_DATA8(*(iface->transPtr++));
 			iface->writeNum--;
 		}
 		/* start receive immediately after complete sending in
 		 * combine mode.
 		 */
 		else if (iface->cur_mode == TWI_I2C_MODE_COMBINED)
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
+			write_MASTER_CTL(read_MASTER_CTL()
 				| MDIR | RSTART);
 		else if (iface->manual_stop)
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
+			write_MASTER_CTL(read_MASTER_CTL()
 				| STOP);
 		else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
 				iface->cur_msg+1 < iface->msg_num)
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
+			write_MASTER_CTL(read_MASTER_CTL()
 				| RSTART);
 		SSYNC();
 		/* Clear status */
-		bfin_write_TWI_INT_STAT(XMTSERV);
+		write_INT_STAT(XMTSERV);
 		SSYNC();
 	}
 	if (twi_int_status & RCVSERV) {
 		if (iface->readNum > 0) {
 			/* Receive next data */
-			*(iface->transPtr) = bfin_read_TWI_RCV_DATA8();
+			*(iface->transPtr) = read_RCV_DATA8();
 			if (iface->cur_mode == TWI_I2C_MODE_COMBINED) {
 				/* Change combine mode into sub mode after
 				 * read first data.
@@ -114,33 +141,33 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 			iface->transPtr++;
 			iface->readNum--;
 		} else if (iface->manual_stop) {
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
+			write_MASTER_CTL(read_MASTER_CTL()
 				| STOP);
 			SSYNC();
 		} else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
 				iface->cur_msg+1 < iface->msg_num) {
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
+			write_MASTER_CTL(read_MASTER_CTL()
 				| RSTART);
 			SSYNC();
 		}
 		/* Clear interrupt source */
-		bfin_write_TWI_INT_STAT(RCVSERV);
+		write_INT_STAT(RCVSERV);
 		SSYNC();
 	}
 	if (twi_int_status & MERR) {
-		bfin_write_TWI_INT_STAT(MERR);
-		bfin_write_TWI_INT_MASK(0);
-		bfin_write_TWI_MASTER_STAT(0x3e);
-		bfin_write_TWI_MASTER_CTL(0);
+		write_INT_STAT(MERR);
+		write_INT_MASK(0);
+		write_MASTER_STAT(0x3e);
+		write_MASTER_CTL(0);
 		SSYNC();
 		iface->result = -EIO;
 		/* if both err and complete int stats are set, return proper
 		 * results.
 		 */
 		if (twi_int_status & MCOMP) {
-			bfin_write_TWI_INT_STAT(MCOMP);
-			bfin_write_TWI_INT_MASK(0);
-			bfin_write_TWI_MASTER_CTL(0);
+			write_INT_STAT(MCOMP);
+			write_INT_MASK(0);
+			write_MASTER_CTL(0);
 			SSYNC();
 			/* If it is a quick transfer, only address bug no data,
 			 * not an err, return 1.
@@ -157,7 +184,7 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 		return;
 	}
 	if (twi_int_status & MCOMP) {
-		bfin_write_TWI_INT_STAT(MCOMP);
+		write_INT_STAT(MCOMP);
 		SSYNC();
 		if (iface->cur_mode == TWI_I2C_MODE_COMBINED) {
 			if (iface->readNum == 0) {
@@ -166,22 +193,22 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 				 */
 				iface->readNum = 1;
 				iface->manual_stop = 1;
-				bfin_write_TWI_MASTER_CTL(
-					bfin_read_TWI_MASTER_CTL()
+				write_MASTER_CTL(
+					read_MASTER_CTL()
 					| (0xff << 6));
 			} else {
 				/* set the readd number in other
 				 * combine mode.
 				 */
-				bfin_write_TWI_MASTER_CTL(
-					(bfin_read_TWI_MASTER_CTL() &
+				write_MASTER_CTL(
+					(read_MASTER_CTL() &
 					(~(0xff << 6))) |
 					( iface->readNum << 6));
 			}
 			/* remove restart bit and enable master receive */
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() &
+			write_MASTER_CTL(read_MASTER_CTL() &
 				~RSTART);
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() |
+			write_MASTER_CTL(read_MASTER_CTL() |
 				MEN | MDIR);
 			SSYNC();
 		} else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
@@ -191,7 +218,7 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 			iface->writeNum = iface->readNum =
 				iface->pmsg[iface->cur_msg].len;
 			/* Set Transmit device address */
-			bfin_write_TWI_MASTER_ADDR(
+			write_MASTER_ADDR(
 				iface->pmsg[iface->cur_msg].addr);
 			if (iface->pmsg[iface->cur_msg].flags & I2C_M_RD)
 				iface->read_write = I2C_SMBUS_READ;
@@ -199,7 +226,7 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 				iface->read_write = I2C_SMBUS_WRITE;
 				/* Transmit first data */
 				if (iface->writeNum > 0) {
-					bfin_write_TWI_XMT_DATA8(
+					write_XMT_DATA8(
 						*(iface->transPtr++));
 					iface->writeNum--;
 					SSYNC();
@@ -207,23 +234,23 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 			}
 
 			if (iface->pmsg[iface->cur_msg].len <= 255)
-				bfin_write_TWI_MASTER_CTL(
+				write_MASTER_CTL(
 				iface->pmsg[iface->cur_msg].len << 6);
 			else if (iface->pmsg[iface->cur_msg].len > 255) {
-				bfin_write_TWI_MASTER_CTL(0xff << 6);
+				write_MASTER_CTL(0xff << 6);
 				iface->manual_stop = 1;
 			}
 			/* remove restart bit and enable master receive */
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() &
+			write_MASTER_CTL(read_MASTER_CTL() &
 				~RSTART);
-			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() |
+			write_MASTER_CTL(read_MASTER_CTL() |
 				MEN | ((iface->read_write == I2C_SMBUS_READ) ?
 				MDIR : 0));
 			SSYNC();
 		} else {
 			iface->result = 1;
-			bfin_write_TWI_INT_MASK(0);
-			bfin_write_TWI_MASTER_CTL(0);
+			write_INT_MASK(0);
+			write_MASTER_CTL(0);
 			SSYNC();
 			complete(&iface->complete);
 		}
@@ -273,12 +300,12 @@ static int bfin_twi_master_xfer(struct i2c_adapter *adap,
 	struct i2c_msg *pmsg;
 	int rc = 0;
 
-	if (!(bfin_read_TWI_CONTROL() & TWI_ENA))
+	if (!(read_CONTROL() & TWI_ENA))
 		return -ENXIO;
 
 	mutex_lock(&iface->twi_lock);
 
-	while (bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
+	while (read_MASTER_STAT() & BUSBUSY) {
 		mutex_unlock(&iface->twi_lock);
 		yield();
 		mutex_lock(&iface->twi_lock);
@@ -302,14 +329,14 @@ static int bfin_twi_master_xfer(struct i2c_adapter *adap,
 	iface->result = 0;
 	iface->timeout_count = 10;
 	/* Set Transmit device address */
-	bfin_write_TWI_MASTER_ADDR(pmsg->addr);
+	write_MASTER_ADDR(pmsg->addr);
 
 	/* FIFO Initiation. Data in FIFO should be
 	 *  discarded before start a new operation.
 	 */
-	bfin_write_TWI_FIFO_CTL(0x3);
+	write_FIFO_CTL(0x3);
 	SSYNC();
-	bfin_write_TWI_FIFO_CTL(0);
+	write_FIFO_CTL(0);
 	SSYNC();
 
 	if (pmsg->flags & I2C_M_RD)
@@ -318,23 +345,23 @@ static int bfin_twi_master_xfer(struct i2c_adapter *adap,
 		iface->read_write = I2C_SMBUS_WRITE;
 		/* Transmit first data */
 		if (iface->writeNum > 0) {
-			bfin_write_TWI_XMT_DATA8(*(iface->transPtr++));
+			write_XMT_DATA8(*(iface->transPtr++));
 			iface->writeNum--;
 			SSYNC();
 		}
 	}
 
 	/* clear int stat */
-	bfin_write_TWI_INT_STAT(MERR | MCOMP | XMTSERV | RCVSERV);
+	write_INT_STAT(MERR | MCOMP | XMTSERV | RCVSERV);
 
 	/* Interrupt mask . Enable XMT, RCV interrupt */
-	bfin_write_TWI_INT_MASK(MCOMP | MERR | RCVSERV | XMTSERV);
+	write_INT_MASK(MCOMP | MERR | RCVSERV | XMTSERV);
 	SSYNC();
 
 	if (pmsg->len <= 255)
-		bfin_write_TWI_MASTER_CTL(pmsg->len << 6);
+		write_MASTER_CTL(pmsg->len << 6);
 	else if (pmsg->len > 255) {
-		bfin_write_TWI_MASTER_CTL(0xff << 6);
+		write_MASTER_CTL(0xff << 6);
 		iface->manual_stop = 1;
 	}
 
@@ -342,7 +369,7 @@ static int bfin_twi_master_xfer(struct i2c_adapter *adap,
 	add_timer(&iface->timeout_timer);
 
 	/* Master enable */
-	bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() | MEN |
+	write_MASTER_CTL(read_MASTER_CTL() | MEN |
 		((iface->read_write == I2C_SMBUS_READ) ? MDIR : 0) |
 		((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ > 100) ? FAST : 0));
 	SSYNC();
@@ -371,12 +398,12 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 	struct bfin_twi_iface *iface = adap->algo_data;
 	int rc = 0;
 
-	if (!(bfin_read_TWI_CONTROL() & TWI_ENA))
+	if (!(read_CONTROL() & TWI_ENA))
 		return -ENXIO;
 
 	mutex_lock(&iface->twi_lock);
 
-	while (bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
+	while (read_MASTER_STAT() & BUSBUSY) {
 		mutex_unlock(&iface->twi_lock);
 		yield();
 		mutex_lock(&iface->twi_lock);
@@ -452,15 +479,15 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 	/* FIFO Initiation. Data in FIFO should be discarded before
 	 * start a new operation.
 	 */
-	bfin_write_TWI_FIFO_CTL(0x3);
+	write_FIFO_CTL(0x3);
 	SSYNC();
-	bfin_write_TWI_FIFO_CTL(0);
+	write_FIFO_CTL(0);
 
 	/* clear int stat */
-	bfin_write_TWI_INT_STAT(MERR|MCOMP|XMTSERV|RCVSERV);
+	write_INT_STAT(MERR|MCOMP|XMTSERV|RCVSERV);
 
 	/* Set Transmit device address */
-	bfin_write_TWI_MASTER_ADDR(addr);
+	write_MASTER_ADDR(addr);
 	SSYNC();
 
 	iface->timeout_timer.expires = jiffies + POLL_TIMEOUT;
@@ -468,60 +495,61 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 
 	switch (iface->cur_mode) {
 	case TWI_I2C_MODE_STANDARDSUB:
-		bfin_write_TWI_XMT_DATA8(iface->command);
-		bfin_write_TWI_INT_MASK(MCOMP | MERR |
+		write_XMT_DATA8(iface->command);
+		write_INT_MASK(MCOMP | MERR |
 			((iface->read_write == I2C_SMBUS_READ) ?
 			RCVSERV : XMTSERV));
 		SSYNC();
 
 		if (iface->writeNum + 1 <= 255)
-			bfin_write_TWI_MASTER_CTL((iface->writeNum + 1) << 6);
+			write_MASTER_CTL((iface->writeNum + 1) << 6);
 		else {
-			bfin_write_TWI_MASTER_CTL(0xff << 6);
+			write_MASTER_CTL(0xff << 6);
 			iface->manual_stop = 1;
 		}
 		/* Master enable */
-		bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() | MEN |
+		write_MASTER_CTL(read_MASTER_CTL() | MEN |
 			((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ>100) ? FAST : 0));
 		break;
 	case TWI_I2C_MODE_COMBINED:
-		bfin_write_TWI_XMT_DATA8(iface->command);
-		bfin_write_TWI_INT_MASK(MCOMP | MERR | RCVSERV | XMTSERV);
+		write_XMT_DATA8(iface->command);
+		write_INT_MASK(MCOMP | MERR | RCVSERV | XMTSERV);
 		SSYNC();
 
 		if (iface->writeNum > 0)
-			bfin_write_TWI_MASTER_CTL((iface->writeNum + 1) << 6);
+			write_MASTER_CTL((iface->writeNum + 1) << 6);
 		else
-			bfin_write_TWI_MASTER_CTL(0x1 << 6);
+			write_MASTER_CTL(0x1 << 6);
 		/* Master enable */
-		bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() | MEN |
+		write_MASTER_CTL(read_MASTER_CTL() | MEN |
 			((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ>100) ? FAST : 0));
 		break;
 	default:
-		bfin_write_TWI_MASTER_CTL(0);
+		write_MASTER_CTL(0);
 		if (size != I2C_SMBUS_QUICK) {
 			/* Don't access xmit data register when this is a
 			 * read operation.
 			 */
 			if (iface->read_write != I2C_SMBUS_READ) {
 				if (iface->writeNum > 0) {
-					bfin_write_TWI_XMT_DATA8(*(iface->transPtr++));
+					write_XMT_DATA8(*(iface->transPtr++));
 					if (iface->writeNum <= 255)
-						bfin_write_TWI_MASTER_CTL(iface->writeNum << 6);
+						write_MASTER_CTL(iface->writeNum
+								<< 6);
 					else {
-						bfin_write_TWI_MASTER_CTL(0xff << 6);
+						write_MASTER_CTL(0xff << 6);
 						iface->manual_stop = 1;
 					}
 					iface->writeNum--;
 				} else {
-					bfin_write_TWI_XMT_DATA8(iface->command);
-					bfin_write_TWI_MASTER_CTL(1 << 6);
+					write_XMT_DATA8(iface->command);
+					write_MASTER_CTL(1 << 6);
 				}
 			} else {
 				if (iface->readNum > 0 && iface->readNum <= 255)
-					bfin_write_TWI_MASTER_CTL(iface->readNum << 6);
+					write_MASTER_CTL(iface->readNum << 6);
 				else if (iface->readNum > 255) {
-					bfin_write_TWI_MASTER_CTL(0xff << 6);
+					write_MASTER_CTL(0xff << 6);
 					iface->manual_stop = 1;
 				} else {
 					del_timer(&iface->timeout_timer);
@@ -529,13 +557,13 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 				}
 			}
 		}
-		bfin_write_TWI_INT_MASK(MCOMP | MERR |
+		write_INT_MASK(MCOMP | MERR |
 			((iface->read_write == I2C_SMBUS_READ) ?
 			RCVSERV : XMTSERV));
 		SSYNC();
 
 		/* Master enable */
-		bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() | MEN |
+		write_MASTER_CTL(read_MASTER_CTL() | MEN |
 			((iface->read_write == I2C_SMBUS_READ) ? MDIR : 0) |
 			((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ > 100) ? FAST : 0));
 		break;
@@ -576,7 +604,7 @@ static int i2c_bfin_twi_suspend(struct platform_device *dev, pm_message_t state)
 /*	struct bfin_twi_iface *iface = platform_get_drvdata(dev);*/
 
 	/* Disable TWI */
-	bfin_write_TWI_CONTROL(bfin_read_TWI_CONTROL() & ~TWI_ENA);
+	write_CONTROL(read_CONTROL() & ~TWI_ENA);
 	SSYNC();
 
 	return 0;
@@ -587,62 +615,104 @@ static int i2c_bfin_twi_resume(struct platform_device *dev)
 /*	struct bfin_twi_iface *iface = platform_get_drvdata(dev);*/
 
 	/* Enable TWI */
-	bfin_write_TWI_CONTROL(bfin_read_TWI_CONTROL() | TWI_ENA);
+	write_CONTROL(read_CONTROL() | TWI_ENA);
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
+		dev_err(&(pdev->dev), "Cannot allocate memory\n");
+		rc = -ENOMEM;
+		goto out_error_nomem;
+	}
+
 	mutex_init(&(iface->twi_lock));
 	spin_lock_init(&(iface->lock));
 	init_completion(&(iface->complete));
-	iface->irq = IRQ_TWI;
+
+	/* Find and map our resources */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&(pdev->dev), "Cannot get IORESOURCE_MEM\n");
+		rc = -ENOENT;
+		goto out_error_get_res;
+	}
+
+	twi_regs_base = (u32) ioremap(res->start, (res->end - res->start)+1);
+	if (!twi_regs_base) {
+		dev_err(&(pdev->dev), "Cannot map IO\n");
+		rc = -ENXIO;
+		goto out_error_ioremap;
+	}
+
+	iface->irq = platform_get_irq(pdev, 0);
+	if (iface->irq < 0) {
+		dev_err(&(pdev->dev), "No DMA channel specified\n");
+		rc = -ENOENT;
+		goto out_error_no_irq;
+	}
 
 	init_timer(&(iface->timeout_timer));
 	iface->timeout_timer.function = bfin_twi_timeout;
 	iface->timeout_timer.data = (unsigned long)iface;
 
-	p_adap = &iface->adap;
-	p_adap->id = I2C_HW_BLACKFIN;
-	strlcpy(p_adap->name, dev->name, sizeof(p_adap->name));
+	p_adap = &(iface->adap);
+	p_adap->id = I2C_HW_B_BLACKFIN;
+	strlcpy(p_adap->name, pdev->name, sizeof(p_adap->name));
 	p_adap->algo = &bfin_twi_algorithm;
 	p_adap->algo_data = iface;
 	p_adap->class = I2C_CLASS_ALL;
-	p_adap->dev.parent = &dev->dev;
+	p_adap->dev.parent = &pdev->dev;
 
 	rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
-		IRQF_DISABLED, dev->name, iface);
+		SA_INTERRUPT, pdev->name, iface);
 	if (rc) {
-		dev_err(&(p_adap->dev), "i2c-bfin-twi: can't get IRQ %d !\n",
+		dev_err(&(pdev->dev), "i2c-bfin-twi: can't get IRQ %d !\n",
 			iface->irq);
-		return -ENODEV;
+		rc = -ENODEV;
+		goto out_error_req_irq;
 	}
 
 	/* Set TWI internal clock as 10MHz */
-	bfin_write_TWI_CONTROL(((get_sclk() / 1024 / 1024 + 5) / 10) & 0x7F);
+	write_CONTROL(((get_sclk() / 1024 / 1024 + 5) / 10) & 0x7F);
 
 	/* Set Twi interface clock as specified */
-	bfin_write_TWI_CLKDIV((( 5*1024 / CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ )
+	write_CLKDIV((( 5*1024 / CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ )
 			<< 8) | (( 5*1024 / CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ )
 			& 0xFF));
 
 	/* Enable TWI */
-	bfin_write_TWI_CONTROL(bfin_read_TWI_CONTROL() | TWI_ENA);
+	write_CONTROL(read_CONTROL() | TWI_ENA);
 	SSYNC();
 
 	rc = i2c_add_adapter(p_adap);
 	if (rc < 0)
 		free_irq(iface->irq, iface);
 	else
-		platform_set_drvdata(dev, iface);
+		platform_set_drvdata(pdev, iface);
+
+	dev_info(&(pdev->dev), "Blackfin I2C TWI driver, regs_base @ 0x%08x\n",
+		twi_regs_base);
 
 	return rc;
+
+out_error_req_irq:
+out_error_no_irq:
+	iounmap((void *)twi_regs_base);
+out_error_ioremap:
+out_error_get_res:
+	kfree(iface);
+out_error_nomem:
+	return rc;
 }
 
 static int i2c_bfin_twi_remove(struct platform_device *pdev)
@@ -670,8 +740,6 @@ static struct platform_driver i2c_bfin_twi_driver = {
 
 static int __init i2c_bfin_twi_init(void)
 {
-	pr_info("I2C: Blackfin I2C TWI driver\n");
-
 	return platform_driver_register(&i2c_bfin_twi_driver);
 }
 
diff --git a/include/asm-blackfin/mach-bf548/cdefBF54x_base.h b/include/asm-blackfin/mach-bf548/cdefBF54x_base.h
index aefab3f..19ddcd8 100644
--- a/include/asm-blackfin/mach-bf548/cdefBF54x_base.h
+++ b/include/asm-blackfin/mach-bf548/cdefBF54x_base.h
@@ -244,39 +244,6 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 #define bfin_read_TWI0_RCV_DATA16()		bfin_read16(TWI0_RCV_DATA16)
 #define bfin_write_TWI0_RCV_DATA16(val)		bfin_write16(TWI0_RCV_DATA16, val)
 
-#define bfin_read_TWI_CLKDIV()			bfin_read16(TWI0_CLKDIV)
-#define bfin_write_TWI_CLKDIV(val)		bfin_write16(TWI0_CLKDIV, val)
-#define bfin_read_TWI_CONTROL()			bfin_read16(TWI0_CONTROL)
-#define bfin_write_TWI_CONTROL(val)		bfin_write16(TWI0_CONTROL, val)
-#define bfin_read_TWI_SLAVE_CTRL()		bfin_read16(TWI0_SLAVE_CTRL)
-#define bfin_write_TWI_SLAVE_CTRL(val)		bfin_write16(TWI0_SLAVE_CTRL, val)
-#define bfin_read_TWI_SLAVE_STAT()		bfin_read16(TWI0_SLAVE_STAT)
-#define bfin_write_TWI_SLAVE_STAT(val)		bfin_write16(TWI0_SLAVE_STAT, val)
-#define bfin_read_TWI_SLAVE_ADDR()		bfin_read16(TWI0_SLAVE_ADDR)
-#define bfin_write_TWI_SLAVE_ADDR(val)		bfin_write16(TWI0_SLAVE_ADDR, val)
-#define bfin_read_TWI_MASTER_CTL()		bfin_read16(TWI0_MASTER_CTRL)
-#define bfin_write_TWI_MASTER_CTL(val)		bfin_write16(TWI0_MASTER_CTRL, val)
-#define bfin_read_TWI_MASTER_STAT()		bfin_read16(TWI0_MASTER_STAT)
-#define bfin_write_TWI_MASTER_STAT(val)		bfin_write16(TWI0_MASTER_STAT, val)
-#define bfin_read_TWI_MASTER_ADDR()		bfin_read16(TWI0_MASTER_ADDR)
-#define bfin_write_TWI_MASTER_ADDR(val)		bfin_write16(TWI0_MASTER_ADDR, val)
-#define bfin_read_TWI_INT_STAT()		bfin_read16(TWI0_INT_STAT)
-#define bfin_write_TWI_INT_STAT(val)		bfin_write16(TWI0_INT_STAT, val)
-#define bfin_read_TWI_INT_MASK()		bfin_read16(TWI0_INT_MASK)
-#define bfin_write_TWI_INT_MASK(val)		bfin_write16(TWI0_INT_MASK, val)
-#define bfin_read_TWI_FIFO_CTL()		bfin_read16(TWI0_FIFO_CTRL)
-#define bfin_write_TWI_FIFO_CTL(val)		bfin_write16(TWI0_FIFO_CTRL, val)
-#define bfin_read_TWI_FIFO_STAT()		bfin_read16(TWI0_FIFO_STAT)
-#define bfin_write_TWI_FIFO_STAT(val)		bfin_write16(TWI0_FIFO_STAT, val)
-#define bfin_read_TWI_XMT_DATA8()		bfin_read16(TWI0_XMT_DATA8)
-#define bfin_write_TWI_XMT_DATA8(val)		bfin_write16(TWI0_XMT_DATA8, val)
-#define bfin_read_TWI_XMT_DATA16()		bfin_read16(TWI0_XMT_DATA16)
-#define bfin_write_TWI_XMT_DATA16(val)		bfin_write16(TWI0_XMT_DATA16, val)
-#define bfin_read_TWI_RCV_DATA8()		bfin_read16(TWI0_RCV_DATA8)
-#define bfin_write_TWI_RCV_DATA8(val)		bfin_write16(TWI0_RCV_DATA8, val)
-#define bfin_read_TWI_RCV_DATA16()		bfin_read16(TWI0_RCV_DATA16)
-#define bfin_write_TWI_RCV_DATA16(val)		bfin_write16(TWI0_RCV_DATA16, val)
-
 /* SPORT0 is not defined in the shared file because it is not available on the ADSP-BF542 and ADSP-BF544 bfin_read_()rocessors */
 
 /* SPORT1 Registers */
-- 
1.5.3.4
