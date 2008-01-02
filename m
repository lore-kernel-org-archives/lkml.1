Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbYABTvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbYABTvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYABTvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:51:35 -0500
Received: from mail0.scram.de ([78.47.204.202]:40564 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbYABTvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:51:33 -0500
X-Spam-Score: -4.015
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.4 AWL AWL: From: address is in the auto white-list
Message-ID: <477BEB60.4070703@scram.de>
Date: Wed, 02 Jan 2008 20:52:00 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Jean Delvare <khali@linux-fr.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>
Subject: [PATCHv2] i2c: adds support for i2c bus on Frescale CPM1/CPM2 controllers
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the port of 2.4 code from Vitaly Bordug <vitb@kernel.crashing.org>
and the actual algorithm used by the i2c driver of the DBox code on
cvs.tuxboc.org from Tmbinc, Gillem (htoa@gmx.net). Renamed i2c-rpx.c and
i2c-algo-8xx.c to i2c-cpm.c and converted the driver to an
of_platform_driver.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/powerpc/boot/dts/mpc8272ads.dts         |   10 +
 arch/powerpc/boot/dts/mpc866ads.dts          |   10 +
 arch/powerpc/boot/dts/mpc885ads.dts          |   10 +
 arch/powerpc/platforms/8xx/mpc885ads_setup.c |    5 +
 drivers/i2c/busses/Kconfig                   |   10 +
 drivers/i2c/busses/Makefile                  |    1 +
 drivers/i2c/busses/i2c-cpm.c                 |  786 ++++++++++++++++++++++++++
 7 files changed, 832 insertions(+), 0 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-cpm.c

diff --git a/arch/powerpc/boot/dts/mpc8272ads.dts b/arch/powerpc/boot/dts/mpc8272ads.dts
index 7285ca1..7273996 100644
--- a/arch/powerpc/boot/dts/mpc8272ads.dts
+++ b/arch/powerpc/boot/dts/mpc8272ads.dts
@@ -215,6 +215,16 @@
 				linux,network-index = <1>;
 				fsl,cpm-command = <16200300>;
 			};
+
+			i2c@11860 {
+				compatible = "fsl,mpc8248-i2c",
+					     "fsl,cpm2-i2c",
+					     "fsl,cpm-i2c";
+				reg = <11860 20 8afc 2>;
+				interrupts = <1 8>;
+				interrupt-parent = <&PIC>;
+				fsl,cpm-command = <29600000>;
+			};
 		};
 
 		PIC: interrupt-controller@10c00 {
diff --git a/arch/powerpc/boot/dts/mpc866ads.dts b/arch/powerpc/boot/dts/mpc866ads.dts
index daf9433..80c08bf 100644
--- a/arch/powerpc/boot/dts/mpc866ads.dts
+++ b/arch/powerpc/boot/dts/mpc866ads.dts
@@ -169,6 +169,16 @@
 				fsl,cpm-command = <0000>;
 				linux,network-index = <1>;
 			};
+
+			i2c@860 {
+				compatible = "fsl,mpc866-i2c",
+					     "fsl,cpm1-i2c",
+					     "fsl,cpm-i2c";
+				reg = <860 20 3c80 30>;
+				interrupts = <10 3>;
+				interrupt-parent = <&Cpm_pic>;
+				fsl,cpm-command = <0010>;
+			};
 		};
 	};
 
diff --git a/arch/powerpc/boot/dts/mpc885ads.dts b/arch/powerpc/boot/dts/mpc885ads.dts
index 8848e63..fd9c9d7 100644
--- a/arch/powerpc/boot/dts/mpc885ads.dts
+++ b/arch/powerpc/boot/dts/mpc885ads.dts
@@ -213,6 +213,16 @@
 				fsl,cpm-command = <0080>;
 				linux,network-index = <2>;
 			};
+
+			i2c@860 {
+				compatible = "fsl,mpc885-i2c",
+					     "fsl,cpm1-i2c",
+					     "fsl,cpm-i2c";
+				reg = <860 20 3c80 30>;
+				interrupts = <10>;
+				interrupt-parent = <&CPM_PIC>;
+				fsl,cpm-command = <0010>;
+			};
 		};
 	};
 
diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index 2cf1b6a..4377521 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -157,6 +157,11 @@ static struct cpm_pin mpc885ads_pins[] = {
 	{CPM_PORTE, 28, CPM_PIN_OUTPUT},
 	{CPM_PORTE, 29, CPM_PIN_OUTPUT},
 #endif
+	/* I2C */
+#ifdef CONFIG_I2C_8XX
+	{CPM_PORTB, 26, CPM_PIN_INPUT | CPM_PIN_OPENDRAIN},
+	{CPM_PORTB, 27, CPM_PIN_INPUT | CPM_PIN_OPENDRAIN},
+#endif
 };
 
 static void __init init_ioports(void)
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index c466c6c..5950172 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -114,6 +114,16 @@ config I2C_BLACKFIN_TWI_CLK_KHZ
 	help
 	  The unit of the TWI clock is kHz.
 
+config I2C_CPM
+	tristate "Freescale CPM1 or CPM2 (MPC8xx/826x)"
+	depends on (CPM1 || CPM2) && I2C && PPC_OF
+	help
+	  This supports the use of the I2C interface on Freescale
+	  processors with CPM1 or CPM2.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-cpm.
+
 config I2C_DAVINCI
 	tristate "DaVinci I2C driver"
 	depends on ARCH_DAVINCI
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 81d43c2..a395555 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_I2C_AMD8111)	+= i2c-amd8111.o
 obj-$(CONFIG_I2C_AT91)		+= i2c-at91.o
 obj-$(CONFIG_I2C_AU1550)	+= i2c-au1550.o
 obj-$(CONFIG_I2C_BLACKFIN_TWI)	+= i2c-bfin-twi.o
+obj-$(CONFIG_I2C_CPM)		+= i2c-cpm.o
 obj-$(CONFIG_I2C_DAVINCI)	+= i2c-davinci.o
 obj-$(CONFIG_I2C_ELEKTOR)	+= i2c-elektor.o
 obj-$(CONFIG_I2C_GPIO)		+= i2c-gpio.o
diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
new file mode 100644
index 0000000..f5371c6
--- /dev/null
+++ b/drivers/i2c/busses/i2c-cpm.c
@@ -0,0 +1,786 @@
+/*
+ * Freescale CPM1/CPM2 I2C interface.
+ * Copyright (c) 1999 Dan Malek (dmalek@jlc.net).
+ *
+ * moved into proper i2c interface;
+ * Brad Parker (brad@heeltoe.com)
+ *
+ * (C) 2007 Montavista Software, Inc.
+ * Vitaly Bordug <vitb@kernel.crashing.org>
+ *
+ * RPX lite specific parts of the i2c interface
+ * Update:  There actually isn't anything RPXLite-specific about this module.
+ * This should work for most any CPM board.  The console messages have been
+ * changed to eliminate RPXLite references.
+ *
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * moved into proper i2c interface; separated out platform specific
+ * parts into i2c-8xx.c
+ * Brad Parker (brad@heeltoe.com)
+ *
+ * Parts from dbox2_i2c.c (cvs.tuxbox.org)
+ * (C) 2000-2001 Tmbinc, Gillem (htoa@gmx.net)
+ *
+ * (C) 2007 Montavista Software, Inc.
+ * Vitaly Bordug <vitb@kernel.crashing.org>
+ *
+ * Converted to of_platform_device. Renamed to i2c-cpm.c.
+ * (C) 2007 Jochen Friedrich <jochen@scram.de>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/stddef.h>
+#include <linux/i2c.h>
+#include <linux/io.h>
+#include <linux/time.h>
+#include <linux/dma-mapping.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <sysdev/fsl_soc.h>
+#include <asm/cpm.h>
+
+/* Try to define this if you have an older CPU (earlier than rev D4) */
+/* However, better use a GPIO based bitbang driver in this case :/   */
+#undef	I2C_CHIP_ERRATA
+
+#define CPM_MAX_READ    513
+#define CPM_MAXBD       4
+
+#define CPM_CR_INIT_TRX		(0x00)
+#define CPM_CR_CLOSE_RXBD	(0x07)
+
+#define I2C_EB			(0x10) /* Big endian mode */
+
+/* I2C parameter RAM. */
+struct i2c_ram {
+	ushort  rbase;		/* Rx Buffer descriptor base address */
+	ushort  tbase;		/* Tx Buffer descriptor base address */
+	u_char  rfcr;		/* Rx function code */
+	u_char  tfcr;		/* Tx function code */
+	ushort  mrblr;		/* Max receive buffer length */
+	uint    rstate;		/* Internal */
+	uint    rdp;		/* Internal */
+	ushort  rbptr;		/* Rx Buffer descriptor pointer */
+	ushort  rbc;		/* Internal */
+	uint    rxtmp;		/* Internal */
+	uint    tstate;		/* Internal */
+	uint    tdp;		/* Internal */
+	ushort  tbptr;		/* Tx Buffer descriptor pointer */
+	ushort  tbc;		/* Internal */
+	uint    txtmp;		/* Internal */
+	char    res1[4];	/* Reserved */
+	ushort  rpbase;		/* Relocation pointer */
+	char    res2[2];	/* Reserved */
+};
+
+/* I2C Registers */
+struct i2c_reg {
+	u8	i2mod;
+	u8	res1[3];
+	u8	i2add;
+	u8	res2[3];
+	u8	i2brg;
+	u8	res3[3];
+	u8	i2com;
+	u8	res4[3];
+	u8	i2cer;
+	u8	res5[3];
+	u8	i2cmr;
+};
+
+struct cpm_i2c {
+	char *base;
+	struct of_device *ofdev;
+	struct i2c_adapter adap;
+	uint dp_addr;
+	int version; /* CPM1=1, CPM2=2 */
+	int irq;
+	int cp_command;
+	struct i2c_reg __iomem *i2c_reg;
+	struct i2c_ram __iomem *i2c_ram;
+	u16 i2c_addr;
+	wait_queue_head_t i2c_wait;
+	struct mutex i2c_mutex; /* Protects I2C CPM */
+	u_char *txbuf[CPM_MAXBD];
+	u_char *rxbuf[CPM_MAXBD];
+	u32 txdma[CPM_MAXBD];
+	u32 rxdma[CPM_MAXBD];
+};
+
+static irqreturn_t cpm_i2c_interrupt(int irq, void *dev_id)
+{
+	struct i2c_adapter *adap;
+	struct cpm_i2c *cpm;
+	struct i2c_reg __iomem *i2c_reg;
+	int i;
+
+	adap = (struct i2c_adapter *) dev_id;
+	cpm = i2c_get_adapdata(adap);
+	i2c_reg = cpm->i2c_reg;
+
+	/* Clear interrupt.
+	 */
+	i = in_8(&i2c_reg->i2cer);
+	out_8(&i2c_reg->i2cer, i);
+
+	dev_dbg(&adap->dev, "Interrupt: %x\n", i);
+
+	/* Get 'me going again.
+	 */
+	wake_up_interruptible(&cpm->i2c_wait);
+
+	return i ? IRQ_HANDLED : IRQ_NONE;
+}
+
+static void cpm_reset_i2c_params(struct cpm_i2c *cpm)
+{
+	struct i2c_ram __iomem *i2c_ram = cpm->i2c_ram;
+
+	/* Set up the IIC parameters in the parameter ram.
+	 */
+	out_be16(&i2c_ram->tbase, cpm->dp_addr);
+	out_be16(&i2c_ram->rbase, cpm->dp_addr + sizeof(cbd_t) * CPM_MAXBD);
+
+	out_8(&i2c_ram->tfcr, I2C_EB);
+	out_8(&i2c_ram->rfcr, I2C_EB);
+
+	out_be16(&i2c_ram->mrblr, CPM_MAX_READ);
+
+	out_be32(&i2c_ram->rstate, 0);
+	out_be32(&i2c_ram->rdp, 0);
+	out_be16(&i2c_ram->rbptr, in_be16(&i2c_ram->rbase));
+	out_be16(&i2c_ram->rbc, 0);
+	out_be32(&i2c_ram->rxtmp, 0);
+	out_be32(&i2c_ram->tstate, 0);
+	out_be32(&i2c_ram->tdp, 0);
+	out_be16(&i2c_ram->tbptr, in_be16(&i2c_ram->tbase));
+	out_be16(&i2c_ram->tbc, 0);
+	out_be32(&i2c_ram->txtmp, 0);
+}
+
+static void cpm_i2c_force_close(struct i2c_adapter *adap)
+{
+	struct cpm_i2c *cpm = i2c_get_adapdata(adap);
+	struct i2c_reg __iomem *i2c_reg = cpm->i2c_reg;
+
+	dev_dbg(&adap->dev, "cpm_i2c_force_close()\n");
+
+	cpm_command(cpm->cp_command, CPM_CR_CLOSE_RXBD);
+
+	out_8(&i2c_reg->i2cmr, 0x00);	/* Disable all interrupts */
+	out_8(&i2c_reg->i2cer, 0xff);
+}
+
+static void cpm_i2c_parse_message(struct i2c_adapter *adap,
+	struct i2c_msg *pmsg, int num, int tx, int rx)
+{
+	cbd_t *tbdf, *rbdf;
+	u_char addr;
+	u_char *tb;
+	u_char *rb;
+	struct cpm_i2c *cpm = i2c_get_adapdata(adap);
+	struct i2c_ram __iomem *i2c_ram = cpm->i2c_ram;
+	int i, dscan;
+
+	tbdf = (cbd_t *) cpm_muram_addr(in_be16(&i2c_ram->tbase));
+	rbdf = (cbd_t *) cpm_muram_addr(in_be16(&i2c_ram->rbase));
+
+	/* This chip can't do zero length writes. However, the i2c core uses
+	   them to scan for devices. The best we can do is to convert them
+	   into 1 byte reads */
+
+	dscan = ((pmsg->len == 0) && (num == 1));
+
+	addr = pmsg->addr << 1;
+	if ((pmsg->flags & I2C_M_RD) || dscan)
+		addr |= 1;
+
+	tb = cpm->txbuf[tx];
+	rb = cpm->rxbuf[rx];
+
+	/* Align read buffer */
+	rb = (u_char *) (((ulong) rb + 1) & ~1);
+
+	if ((pmsg->flags & I2C_M_RD) || dscan) {
+		/* To read, we need an empty buffer of the proper length.
+		 * All that is used is the first byte for address, the remainder
+		 * is just used for timing (and doesn't really have to exist).
+		 */
+		tb[0] = addr;		/* Device address byte w/rw flag */
+
+		dev_dbg(&adap->dev, "cpm_i2c_read(abyte=0x%x)\n", addr);
+
+		if (dscan)
+			tbdf[tx].cbd_datlen = 2;
+		else
+			tbdf[tx].cbd_datlen = pmsg->len + 1;
+
+		tbdf[tx].cbd_sc = 0;
+
+		if (!(pmsg->flags & I2C_M_NOSTART))
+			tbdf[tx].cbd_sc |= BD_I2C_START;
+		if (tx + 1 == num)
+			tbdf[tx].cbd_sc |= BD_SC_LAST | BD_SC_WRAP;
+
+		rbdf[rx].cbd_datlen = 0;
+		rbdf[rx].cbd_sc = BD_SC_EMPTY | BD_SC_INTRPT;
+
+		if (rx + 1 == CPM_MAXBD)
+			tbdf[rx].cbd_sc |= BD_SC_WRAP;
+
+		eieio();
+		tbdf[tx].cbd_sc |= BD_SC_READY;
+	} else {
+		tb[0] = addr;		/* Device address byte w/rw flag */
+		for (i = 0; i < pmsg->len; i++)
+			tb[i+1] = pmsg->buf[i];
+
+		dev_dbg(&adap->dev, "cpm_iic_write(abyte=0x%x)\n", addr);
+
+		tbdf[tx].cbd_datlen = pmsg->len + 1;
+		tbdf[tx].cbd_sc = 0;
+
+		if (!(pmsg->flags & I2C_M_NOSTART))
+			tbdf[tx].cbd_sc |= BD_I2C_START;
+
+		if (tx + 1 == num)
+			tbdf[tx].cbd_sc |= BD_SC_LAST | BD_SC_WRAP;
+
+		eieio();
+		tbdf[tx].cbd_sc |= BD_SC_READY | BD_SC_INTRPT;
+
+		dev_dbg(&adap->dev, "tx sc %d %04x\n",
+			tx, tbdf[tx].cbd_sc);
+	}
+}
+
+static int cpm_i2c_check_message(struct i2c_adapter *adap,
+	struct i2c_msg *pmsg, int tx, int rx)
+{
+	cbd_t *tbdf, *rbdf;
+	u_char *tb;
+	u_char *rb;
+	struct cpm_i2c *cpm = i2c_get_adapdata(adap);
+	struct i2c_ram __iomem *i2c_ram = cpm->i2c_ram;
+	int i;
+
+	tbdf = (cbd_t *) cpm_muram_addr(in_be16(&i2c_ram->tbase));
+	rbdf = (cbd_t *) cpm_muram_addr(in_be16(&i2c_ram->rbase));
+
+	tb = cpm->txbuf[tx];
+	rb = cpm->rxbuf[rx];
+
+	/* Align read buffer */
+	rb = (u_char *) (((uint) rb + 1) & ~1);
+
+	if (pmsg->flags & I2C_M_RD) {
+		dev_dbg(&adap->dev, "rx sc %04x, rx sc %04x\n",
+			tbdf[tx].cbd_sc, rbdf[rx].cbd_sc);
+
+		if (tbdf[tx].cbd_sc & BD_SC_NAK) {
+			dev_dbg(&adap->dev, "IIC read; No ack\n");
+
+			if (pmsg->flags & I2C_M_IGNORE_NAK)
+				return 0;
+			else
+				return -EIO;
+		}
+		if (rbdf[rx].cbd_sc & BD_SC_EMPTY) {
+			dev_dbg(&adap->dev,
+				"IIC read; complete but rbuf empty\n");
+			return -EREMOTEIO;
+		}
+		if (rbdf[rx].cbd_sc & BD_SC_OV) {
+			dev_dbg(&adap->dev, "IIC read; Overrun\n");
+			return -EREMOTEIO;
+		}
+		for (i = 0; i < pmsg->len; i++)
+			pmsg->buf[i] = rb[i];
+	} else {
+		dev_dbg(&adap->dev, "tx sc %d %04x\n", tx, tbdf[tx].cbd_sc);
+
+		if (tbdf[tx].cbd_sc & BD_SC_NAK) {
+			dev_dbg(&adap->dev, "IIC write; No ack\n");
+
+			if (pmsg->flags & I2C_M_IGNORE_NAK)
+				return 0;
+			else
+				return -EIO;
+		}
+		if (tbdf[tx].cbd_sc & BD_SC_UN) {
+			dev_dbg(&adap->dev, "IIC write; Underrun\n");
+			return -EIO;
+		}
+		if (tbdf[tx].cbd_sc & BD_SC_CL) {
+			dev_dbg(&adap->dev, "IIC write; Collision\n");
+			return -EIO;
+		}
+	}
+	return 0;
+}
+
+static int cpm_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
+{
+	struct cpm_i2c *cpm = i2c_get_adapdata(adap);
+	struct i2c_reg __iomem *i2c_reg = cpm->i2c_reg;
+	struct i2c_ram __iomem *i2c_ram = cpm->i2c_ram;
+	struct i2c_msg *pmsg, *rmsg;
+	int ret, i;
+	int tptr;
+	int rptr;
+	cbd_t *tbdf, *rbdf;
+
+	if (num > CPM_MAXBD)
+		return -EINVAL;
+
+	/* Check if we have any oversized READ requests */
+	for (i = 0; i < num; i++) {
+		pmsg = &msgs[i];
+		if (pmsg->len >= CPM_MAX_READ)
+			return -EINVAL;
+	}
+
+	mutex_lock(&cpm->i2c_mutex);
+
+	/* Reset to use first buffer */
+	out_be16(&i2c_ram->rbptr, in_be16(&i2c_ram->rbase));
+	out_be16(&i2c_ram->tbptr, in_be16(&i2c_ram->tbase));
+
+	tbdf = (cbd_t *) cpm_muram_addr(in_be16(&i2c_ram->tbase));
+	rbdf = (cbd_t *) cpm_muram_addr(in_be16(&i2c_ram->rbase));
+
+	tptr = 0;
+	rptr = 0;
+
+	while (tptr < num) {
+		pmsg = &msgs[tptr];
+		dev_dbg(&adap->dev, "i2c-algo-cpm.o: " "R: %d T: %d\n",
+			rptr, tptr);
+
+		cpm_i2c_parse_message(adap, pmsg, num, tptr, rptr);
+		if (pmsg->flags & I2C_M_RD)
+			rptr++;
+		tptr++;
+	}
+	/* Start transfer now */
+	/* Chip bug, set enable here */
+	out_8(&i2c_reg->i2cmr, 0x13);	/* Enable RX/TX/Error interupts */
+	out_8(&i2c_reg->i2cer, 0xff);	/* Clear interrupt status */
+	out_8(&i2c_reg->i2mod, in_8(&i2c_reg->i2mod) | 1);	/* Enable */
+	/* Begin transmission */
+	out_8(&i2c_reg->i2com, in_8(&i2c_reg->i2com) | 0x80);
+
+	tptr = 0;
+	rptr = 0;
+
+	while (tptr < num) {
+		/* Check for outstanding messages */
+		dev_dbg(&adap->dev, "test ready.\n");
+		if (!(tbdf[tptr].cbd_sc & BD_SC_READY)) {
+			dev_dbg(&adap->dev, "ready.\n");
+			rmsg = &msgs[tptr];
+			ret = cpm_i2c_check_message(adap, rmsg, tptr, rptr);
+			tptr++;
+			if (rmsg->flags & I2C_M_RD)
+				rptr++;
+			if (ret) {
+				cpm_i2c_force_close(adap);
+				mutex_unlock(&cpm->i2c_mutex);
+				return ret;
+			}
+		} else {
+			dev_dbg(&adap->dev, "not ready.\n");
+			ret = wait_event_interruptible_timeout(cpm->i2c_wait,
+				!(tbdf[tptr].cbd_sc & BD_SC_READY), 1 * HZ);
+			if (ret == 0) {
+				cpm_i2c_force_close(adap);
+				dev_dbg(&adap->dev, "I2C read: timeout!\n");
+				mutex_unlock(&cpm->i2c_mutex);
+				return -EREMOTEIO;
+			}
+		}
+	}
+#ifdef I2C_CHIP_ERRATA
+	/* Chip errata, clear enable. This is not needed on rev D4 CPUs.
+	   Disabling I2C too early may cause too short stop condition */
+	udelay(4);
+	out_8(&i2c_reg->i2mod, in_8(&i2c_reg->i2mod) | ~1);
+#endif
+	mutex_unlock(&cpm->i2c_mutex);
+	return (num);
+}
+
+static u32 cpm_i2c_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+/* -----exported algorithm data: -------------------------------------	*/
+
+static struct i2c_algorithm cpm_i2c_algo = {
+	.master_xfer = cpm_i2c_xfer,
+	.functionality = cpm_i2c_func,
+};
+
+static const struct i2c_adapter cpm_ops = {
+	.owner		= THIS_MODULE,
+	.name		= "i2c-cpm",
+	.id		= I2C_HW_MPC8XX_EPON,
+	.algo		= &cpm_i2c_algo,
+	.class		= I2C_CLASS_HWMON,
+};
+
+static int cpm_i2c_setup(struct cpm_i2c *cpm)
+{
+	struct of_device *ofdev = cpm->ofdev;
+	const u32 *data;
+	int len, ret, i;
+	void __iomem *i2c_base;
+	cbd_t *tbdf, *rbdf;
+	unsigned char brg;
+
+	pr_debug("i2c-cpm: cpm_i2c_setup()\n");
+
+	init_waitqueue_head(&cpm->i2c_wait);
+	mutex_init(&cpm->i2c_mutex);
+
+	cpm->irq = of_irq_to_resource(ofdev->node, 0, NULL);
+	if (cpm->irq == NO_IRQ)
+		return -EINVAL;
+
+	/* Install interrupt handler.
+	 */
+	ret = request_irq(cpm->irq, cpm_i2c_interrupt, 0, "cpm_i2c",
+			  &cpm->adap);
+	if (ret)
+		goto out_irq;
+
+	/* IIC parameter RAM */
+	i2c_base = of_iomap(ofdev->node, 1);
+	if (i2c_base == NULL) {
+		ret = -EINVAL;
+		goto out_irq;
+	}
+
+	if (of_device_is_compatible(ofdev->node, "fsl,cpm1-i2c")) {
+
+		/* Check for and use a microcode relocation patch. */
+		cpm->i2c_ram = i2c_base;
+		cpm->i2c_addr = in_be16(&cpm->i2c_ram->rpbase);
+
+		/* Maybe should use cpm_muram_alloc instead of hardcoding
+		 * this in micropatch.c */
+		if (cpm->i2c_addr) {
+			cpm->i2c_ram = cpm_muram_addr(cpm->i2c_addr);
+			iounmap(i2c_base);
+		}
+
+		cpm->version = 1;
+
+	} else if (of_device_is_compatible(ofdev->node, "fsl,cpm2-i2c")) {
+		cpm->i2c_addr = cpm_muram_alloc(sizeof(struct i2c_ram), 64);
+		cpm->i2c_ram = cpm_muram_addr(cpm->i2c_addr);
+		out_be16(i2c_base, cpm->i2c_addr);
+		iounmap(i2c_base);
+
+		cpm->version = 2;
+
+	} else {
+		iounmap(i2c_base);
+		ret = -EINVAL;
+		goto out_irq;
+	}
+
+	/* I2C control/status registers */
+	cpm->i2c_reg = of_iomap(ofdev->node, 0);
+	if (cpm->i2c_reg == NULL) {
+		ret = -EINVAL;
+		goto out_ram;
+	}
+
+	data = of_get_property(ofdev->node, "fsl,cpm-command", &len);
+	if (!data || len != 4) {
+		ret = -EINVAL;
+		goto out_reg;
+	}
+	cpm->cp_command = *data;
+
+	/* Allocate space for CPM_MAXBD transmit and receive buffer
+	 * descriptors in the DP ram.
+	 */
+	cpm->dp_addr = cpm_muram_alloc(sizeof(cbd_t) * 2 * CPM_MAXBD, 8);
+	if (!cpm->dp_addr) {
+		ret = -ENOMEM;
+		goto out_reg;
+	}
+
+	/* Initialize Tx/Rx parameters. */
+
+	cpm_reset_i2c_params(cpm);
+
+	pr_debug("i2c-cpm: i2c_ram %x, dp_addr 0x%x\n", (uint) cpm->i2c_ram,
+		cpm->dp_addr);
+	pr_debug("i2c-cpm: tbase %d, rbase %d\n",
+		in_be16(&cpm->i2c_ram->tbase), in_be16(&cpm->i2c_ram->rbase));
+
+	tbdf = (cbd_t *) cpm_muram_addr(in_be16(&cpm->i2c_ram->tbase));
+	rbdf = (cbd_t *) cpm_muram_addr(in_be16(&cpm->i2c_ram->rbase));
+
+	/* Allocate TX and RX buffers */
+
+	for (i = 0; i < CPM_MAXBD; i++) {
+		cpm->rxbuf[i] = dma_alloc_coherent(
+			NULL, CPM_MAX_READ + 1, &cpm->rxdma[i], GFP_KERNEL);
+		if (!cpm->rxbuf[i]) {
+			ret = -ENOMEM;
+			goto out_muram;
+		}
+		rbdf[i].cbd_bufaddr = ((cpm->rxdma[i] + 1) & ~1);
+		cpm->txbuf[i] = (unsigned char *)dma_alloc_coherent(
+			NULL, CPM_MAX_READ + 1, &cpm->txdma[i], GFP_KERNEL);
+		if (!cpm->txbuf[i]) {
+			ret = -ENOMEM;
+			goto out_muram;
+		}
+		tbdf[i].cbd_bufaddr = cpm->txdma[i];
+	}
+
+	cpm_command(cpm->cp_command, CPM_CR_INIT_TRX);
+
+	/* Select an invalid address. Just make sure we don't use loopback mode
+	 */
+	out_8(&cpm->i2c_reg->i2add, 0xfe);
+
+	/* Make clock run at 60 kHz. */
+
+	brg = get_brgfreq() / (32 * 2 * 60000) - 3;
+	out_8(&cpm->i2c_reg->i2brg, brg);
+
+	out_8(&cpm->i2c_reg->i2mod, 0x00);
+	out_8(&cpm->i2c_reg->i2com, 0x01);	/* Master mode */
+
+	/* Disable interrupts. */
+	out_8(&cpm->i2c_reg->i2cmr, 0);
+	out_8(&cpm->i2c_reg->i2cer, 0xff);
+
+	return 0;
+
+out_muram:
+	for (i = 0; i < CPM_MAXBD; i++) {
+		if (cpm->rxbuf[i])
+			dma_free_coherent(NULL, CPM_MAX_READ + 1,
+				cpm->rxbuf[i], cpm->rxdma[i]);
+		if (cpm->txbuf[i])
+			dma_free_coherent(NULL, CPM_MAX_READ + 1,
+				cpm->txbuf[i], cpm->txdma[i]);
+	}
+	cpm_muram_free(cpm->dp_addr);
+out_reg:
+	iounmap(cpm->i2c_reg);
+out_ram:
+	if ((cpm->version == 1) && (!cpm->i2c_addr))
+		iounmap(cpm->i2c_ram);
+	if (cpm->version == 2)
+		cpm_muram_free(cpm->i2c_addr);
+out_irq:
+	free_irq(cpm->irq, &cpm->adap);
+	return ret;
+}
+
+static void cpm_i2c_shutdown(struct cpm_i2c *cpm)
+{
+	int i;
+
+	/* Shut down I2C. */
+	out_8(&cpm->i2c_reg->i2mod, in_8(&cpm->i2c_reg->i2mod) | ~1);
+
+	/* Disable interrupts */
+	out_8(&cpm->i2c_reg->i2cmr, 0);
+	out_8(&cpm->i2c_reg->i2cer, 0xff);
+
+	free_irq(cpm->irq, &cpm->adap);
+
+	/* Free all memory */
+	for (i = 0; i < CPM_MAXBD; i++) {
+		dma_free_coherent(NULL, CPM_MAX_READ + 1,
+			cpm->rxbuf[i], cpm->rxdma[i]);
+		dma_free_coherent(NULL, CPM_MAX_READ + 1,
+			cpm->txbuf[i], cpm->txdma[i]);
+	}
+
+	cpm_muram_free(cpm->dp_addr);
+	iounmap(cpm->i2c_reg);
+
+	if ((cpm->version == 1) && (!cpm->i2c_addr))
+		iounmap(cpm->i2c_ram);
+	if (cpm->version == 2)
+		cpm_muram_free(cpm->i2c_addr);
+
+	return;
+}
+
+static void of_register_i2c_devices(struct i2c_adapter *adap,
+				    struct device_node *adap_node)
+{
+	struct device_node *node = NULL;
+
+	while ((node = of_get_next_child(adap_node, node))) {
+		struct i2c_board_info info;
+		const u32 *addr;
+		const char *compatible;
+		int len;
+
+		addr = of_get_property(node, "reg", &len);
+		if (!addr || len < sizeof(int) || *addr > (1 << 10) - 1) {
+			printk(KERN_ERR "i2c-cpm.c: invalid entry, "
+			       "missing reg attribute\n");
+			continue;
+		}
+
+		info.irq = irq_of_parse_and_map(node, 0);
+		if (info.irq == NO_IRQ)
+			info.irq = -1;
+
+		compatible = of_get_property(node, "compatible", &len);
+		if (!compatible) {
+			printk(KERN_ERR "i2c-cpm.c: invalid entry, "
+			       "missing compatible attribute\n");
+			continue;
+		}
+
+		/* need full alias i2c:NOF,vendor,device */
+		strcpy(info.driver_name, I2C_OF_MODULE_PREFIX);
+		strncat(info.driver_name, compatible, sizeof(info.driver_name));
+		request_module(info.driver_name);
+
+		/* need module alias OF,vendor,device */
+		strcpy(info.driver_name, OF_I2C_PREFIX);
+		strncat(info.driver_name, compatible, sizeof(info.driver_name));
+
+		info.type[0] = '\0';
+		info.platform_data = NULL;
+		info.addr = *addr;
+
+		if (!i2c_new_device(adap, &info)) {
+			printk(KERN_ERR "i2c-cpm.c: Failed to load driver for "
+			       "%s\n", info.driver_name);
+			continue;
+		}
+	}
+}
+
+static int cpm_i2c_probe(struct of_device *ofdev,
+			 const struct of_device_id *match)
+{
+	int result;
+	struct cpm_i2c *cpm;
+
+	cpm = kzalloc(sizeof(struct cpm_i2c), GFP_KERNEL);
+	if (!cpm)
+		return -ENOMEM;
+
+	cpm->ofdev = ofdev;
+
+	dev_set_drvdata(&ofdev->dev, cpm);
+
+	cpm->adap = cpm_ops;
+	i2c_set_adapdata(&cpm->adap, cpm);
+	cpm->adap.dev.parent = &ofdev->dev;
+
+	result = cpm_i2c_setup(cpm);
+	if (result) {
+		printk(KERN_ERR "i2c-cpm: Unable to init hardware\n");
+		goto out;
+	}
+
+	/* register new adapter to i2c module... */
+
+	result = i2c_add_adapter(&cpm->adap);
+	if (result < 0) {
+		printk(KERN_ERR "i2c-cpm: Unable to register with I2C\n");
+		goto out2;
+	}
+
+	pr_debug("i2c-cpm: hw routines for %s registered.\n", cpm->adap.name);
+
+	of_register_i2c_devices(&cpm->adap, ofdev->node);
+
+	return 0;
+out2:
+	cpm_i2c_shutdown(cpm);
+out:
+	dev_set_drvdata(&ofdev->dev, NULL);
+	kfree(cpm);
+
+	return result;
+}
+
+static int cpm_i2c_remove(struct of_device *ofdev)
+{
+	struct cpm_i2c *cpm = dev_get_drvdata(&ofdev->dev);
+
+	i2c_del_adapter(&cpm->adap);
+
+	cpm_i2c_shutdown(cpm);
+
+	dev_set_drvdata(&ofdev->dev, NULL);
+	kfree(cpm);
+
+	return 0;
+}
+
+static struct of_device_id cpm_i2c_match[] = {
+	{
+		.compatible = "fsl,cpm-i2c",
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, cpm_i2c_match);
+
+static struct of_platform_driver cpm_i2c_driver = {
+	.match_table	= cpm_i2c_match,
+	.probe		= cpm_i2c_probe,
+	.remove		= __devexit_p(cpm_i2c_remove),
+	.driver		= {
+		.name	= "fsl-i2c-cpm",
+		.owner	= THIS_MODULE,
+	}
+};
+
+static int __init cpm_i2c_init(void)
+{
+	return of_register_platform_driver(&cpm_i2c_driver);
+}
+
+static void __exit cpm_i2c_exit(void)
+{
+	of_unregister_platform_driver(&cpm_i2c_driver);
+}
+
+module_init(cpm_i2c_init);
+module_exit(cpm_i2c_exit);
+
+MODULE_AUTHOR("Dan Malek <dmalek@jlc.net>");
+MODULE_DESCRIPTION("I2C-Bus adapter routines for CPM boards");
+MODULE_LICENSE("GPL");
-- 
1.5.3.7

