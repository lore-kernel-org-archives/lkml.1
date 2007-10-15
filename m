Return-Path: <linux-kernel-owner+w=401wt.eu-S1764061AbXJOLK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764061AbXJOLK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759839AbXJOLKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:10:15 -0400
Received: from mail0.scram.de ([78.47.204.202]:51809 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759764AbXJOLKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:10:10 -0400
X-Spam-Score: -3.87
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <47134A94.60606@scram.de>
Date: Mon, 15 Oct 2007 13:10:12 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>,
       linux-kernel@vger.kernel.org, i2c@lm-sensors.org
CC: Carsten Juttner <carjay@gmx.net>
Subject: [PATCH take2] [POWERPC] i2c: adds support for i2c bus on 8xx
Content-Type: multipart/mixed;
 boundary="------------000601030707050808070208"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000601030707050808070208
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


Using the port of 2.4 code from Vitaly Bordug <vitb@kernel.crashing.org>
and the actual algorithm used by the i2c driver of the DBox code on
cvs.tuxboc.org from Tmbinc, Gillem (htoa@gmx.net). Renamed
i2c-algo-8xx.c to i2c-algo-cpm.c and i2c-rpx.c to i2c-8xx.c. Added
original i2c-rpx.c as i2c-8xx-ppc.c for pre-OF (arch ppc) devices.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---

This can be pulled from git://git.bocc.de/dbox2.git i2c

 arch/powerpc/boot/dts/mpc885ads.dts          |    9 +
 arch/powerpc/platforms/8xx/mpc885ads_setup.c |    6 +
 arch/powerpc/sysdev/fsl_soc.c                |   61 +++-
 drivers/i2c/algos/Kconfig                    |   12 +
 drivers/i2c/algos/Makefile                   |    1 +
 drivers/i2c/algos/i2c-algo-cpm.c             |  563 ++++++++++++++++++++++++++
 drivers/i2c/busses/Kconfig                   |   22 +
 drivers/i2c/busses/Makefile                  |    2 +
 drivers/i2c/busses/i2c-8xx-ppc.c             |  105 +++++
 drivers/i2c/busses/i2c-8xx.c                 |  170 ++++++++
 include/linux/i2c-algo-cpm.h                 |   34 ++
 11 files changed, 984 insertions(+), 1 deletions(-)
 create mode 100644 drivers/i2c/algos/i2c-algo-cpm.c
 create mode 100644 drivers/i2c/busses/i2c-8xx-ppc.c
 create mode 100644 drivers/i2c/busses/i2c-8xx.c
 create mode 100644 include/linux/i2c-algo-cpm.h

--------------000601030707050808070208
Content-Type: text/x-patch;
 name="dbf0ac27a4f43181eb26453562bb701c7dbc2aa0.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dbf0ac27a4f43181eb26453562bb701c7dbc2aa0.diff"

diff --git a/arch/powerpc/boot/dts/mpc885ads.dts b/arch/powerpc/boot/dts/mpc885ads.dts
index 8848e63..a526c02 100644
--- a/arch/powerpc/boot/dts/mpc885ads.dts
+++ b/arch/powerpc/boot/dts/mpc885ads.dts
@@ -213,6 +213,15 @@
 				fsl,cpm-command = <0080>;
 				linux,network-index = <2>;
 			};
+
+			i2c@860 {
+				device_type = "i2c";
+				compatible = "fsl-i2c-cpm";
+				reg = <860 20 3c80 30>;
+				interrupts = <10>;
+				interrupt-parent = <&CPM_PIC>;
+				fsl,cpm-command = <0010>;
+			};
 		};
 	};
 
diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index 2cf1b6a..350018b 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -175,6 +175,12 @@ static void __init init_ioports(void)
 
 	/* Set FEC1 and FEC2 to MII mode */
 	clrbits32(&mpc8xx_immr->im_cpm.cp_cptr, 0x00000180);
+
+#ifdef CONFIG_I2C_8XX
+	setbits32(&mpc8xx_immr->im_cpm.cp_pbpar, 0x00000030);
+	setbits32(&mpc8xx_immr->im_cpm.cp_pbdir, 0x00000030);
+	setbits16(&mpc8xx_immr->im_cpm.cp_pbodr, 0x0030);
+#endif
 }
 
 static void __init mpc885ads_setup_arch(void)
diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index 3ace747..e2c8bf8 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -28,6 +28,7 @@
 #include <linux/fsl_devices.h>
 #include <linux/fs_enet_pd.h>
 #include <linux/fs_uart_pd.h>
+#include <linux/of_platform.h>
 
 #include <asm/system.h>
 #include <asm/atomic.h>
@@ -397,7 +398,7 @@ static int __init fsl_i2c_of_init(void)
 	for (np = NULL, i = 0;
 	     (np = of_find_compatible_node(np, "i2c", "fsl-i2c")) != NULL;
 	     i++) {
-		struct resource r[2];
+		struct resource r[3];
 		struct fsl_i2c_platform_data i2c_data;
 		const unsigned char *flags = NULL;
 
@@ -1210,6 +1211,64 @@ err:
 
 arch_initcall(cpm_smc_uart_of_init);
 
+static const char *i2c_regs = "regs";
+static const char *i2c_pram = "pram";
+static const char *i2c_irq = "interrupt";
+
+static int __init fsl_i2c_cpm_of_init(void)
+{
+	struct device_node *np;
+	unsigned int i;
+	struct platform_device *i2c_dev;
+	int ret;
+
+	for (np = NULL, i = 0;
+	     (np = of_find_compatible_node(np, "i2c", "fsl-i2c-cpm")) != NULL;
+	     i++) {
+		struct resource r[3];
+		struct fsl_i2c_platform_data i2c_data;
+
+		memset(&r, 0, sizeof(r));
+		memset(&i2c_data, 0, sizeof(i2c_data));
+
+		ret = of_address_to_resource(np, 0, &r[0]);
+		if (ret)
+			goto err;
+		r[0].name = i2c_regs;
+
+		ret = of_address_to_resource(np, 1, &r[1]);
+		if (ret)
+			goto err;
+		r[1].name = i2c_pram;
+
+		r[2].start = r[2].end = irq_of_parse_and_map(np, 0);
+		r[2].flags = IORESOURCE_IRQ;
+		r[2].name = i2c_irq;
+
+		i2c_dev = platform_device_register_simple("fsl-i2c-cpm", i, &r[0], 3);
+		if (IS_ERR(i2c_dev)) {
+			ret = PTR_ERR(i2c_dev);
+			goto err;
+		}
+
+		ret =
+		    platform_device_add_data(i2c_dev, &i2c_data,
+					     sizeof(struct
+						    fsl_i2c_platform_data));
+		if (ret)
+			goto unreg;
+	}
+
+	return 0;
+
+unreg:
+	platform_device_unregister(i2c_dev);
+err:
+	return ret;
+}
+
+arch_initcall(fsl_i2c_cpm_of_init);
+
 #endif /* CONFIG_8xx */
 #endif /* CONFIG_PPC_CPM_NEW_BINDING */
 
diff --git a/drivers/i2c/algos/Kconfig b/drivers/i2c/algos/Kconfig
index 014dfa5..7a8200e 100644
--- a/drivers/i2c/algos/Kconfig
+++ b/drivers/i2c/algos/Kconfig
@@ -14,6 +14,18 @@ config I2C_ALGOBIT
 	  This support is also available as a module.  If so, the module 
 	  will be called i2c-algo-bit.
 
+config I2C_ALGOCPM
+	tristate "I2C MPC8xx CPM and MPC8260 CPM2 interfaces"
+	depends on ( 8xx || 8260 ) && I2C
+	help
+	  CPM I2C Algorithm, supports the CPM I2C interface for mpc8xx
+	  and mpc8260 CPUs. Say Y if you own a CPU of this class and wish
+	  to use the I2C interface and say Y to the specific driver for the
+	  particular CPU.
+
+	  This support is also available as a module.  If so, the module
+	  will be called i2c-algo-cpm.
+
 config I2C_ALGOPCF
 	tristate "I2C PCF 8584 interfaces"
 	help
diff --git a/drivers/i2c/algos/Makefile b/drivers/i2c/algos/Makefile
index cac1051..b5fe28c 100644
--- a/drivers/i2c/algos/Makefile
+++ b/drivers/i2c/algos/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_I2C_ALGOBIT)	+= i2c-algo-bit.o
 obj-$(CONFIG_I2C_ALGOPCF)	+= i2c-algo-pcf.o
 obj-$(CONFIG_I2C_ALGOPCA)	+= i2c-algo-pca.o
 obj-$(CONFIG_I2C_ALGO_SGI)	+= i2c-algo-sgi.o
+obj-$(CONFIG_I2C_ALGOCPM)	+= i2c-algo-cpm.o
 
 ifeq ($(CONFIG_I2C_DEBUG_ALGO),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/drivers/i2c/algos/i2c-algo-cpm.c b/drivers/i2c/algos/i2c-algo-cpm.c
new file mode 100644
index 0000000..08552cb
--- /dev/null
+++ b/drivers/i2c/algos/i2c-algo-cpm.c
@@ -0,0 +1,563 @@
+/*
+ * i2c-algo-cpm.c i2x driver algorithms for MPC8XX CPM and MPC8260 CPM2
+ * Copyright (c) 1999 Dan Malek (dmalek@jlc.net).
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
+#include <linux/i2c.h>
+#include <linux/i2c-algo-cpm.h>
+#include <linux/io.h>
+#include <linux/time.h>
+#include <linux/dma-mapping.h>
+#include <asm/mpc8xx.h>
+
+/* Try to define this if you have an older CPU (earlier than rev D4) */
+#undef	I2C_CHIP_ERRATA
+
+static int cpm_debug = 1;
+#ifdef DEBUG
+module_param(cpm_debug, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(cpm_debug, "debug level - 0 off; 1 normal");
+#endif
+
+static irqreturn_t cpm_iic_interrupt(int irq, void *dev_id)
+{
+	struct i2c_adapter *adap;
+	struct i2c_algo_cpm_data *cpm;
+	i2c8xx_t *i2c;
+	int i;
+
+	adap = (struct i2c_adapter *) dev_id;
+	cpm = adap->algo_data;
+	i2c = cpm->i2c;
+
+	/* Clear interrupt.
+	 */
+	i = in_8(&i2c->i2c_i2cer);
+	out_8(&i2c->i2c_i2cer, i);
+
+	if (cpm_debug)
+		dev_dbg(&adap->dev, "Interrupt: %x\n", i);
+
+	/* Get 'me going again.
+	 */
+	wake_up_interruptible(&cpm->iic_wait);
+
+	return IRQ_HANDLED;
+}
+
+static int cpm_iic_init(struct i2c_adapter *adap)
+{
+	struct i2c_algo_cpm_data *cpm = adap->algo_data;
+	iic_t *iip = cpm->iip;
+	i2c8xx_t *i2c = cpm->i2c;
+	unsigned char brg;
+	int ret, i;
+
+	if (cpm_debug)
+		dev_dbg(&adap->dev, "cpm_iic_init()\n");
+
+	ret = 0;
+	init_waitqueue_head(&cpm->iic_wait);
+	mutex_init(&cpm->iic_mutex);
+	/* Initialize the parameter ram.
+	 * We need to make sure many things are initialized to zero,
+	 * especially in the case of a microcode patch.
+	 */
+	out_be32(&iip->iic_rstate, 0);
+	out_be32(&iip->iic_rdp, 0);
+	out_be16(&iip->iic_rbptr, 0);
+	out_be16(&iip->iic_rbc, 0);
+	out_be32(&iip->iic_rxtmp, 0);
+	out_be32(&iip->iic_tstate, 0);
+	out_be32(&iip->iic_tdp, 0);
+	out_be16(&iip->iic_tbptr, 0);
+	out_be16(&iip->iic_tbc, 0);
+	out_be32(&iip->iic_txtmp, 0);
+
+	/* Set up the IIC parameters in the parameter ram.
+	 */
+	out_be16(&iip->iic_tbase, cpm->dp_addr);
+	out_be16(&iip->iic_rbase, cpm->dp_addr + sizeof(cbd_t) * CPM_MAXBD);
+
+	if (cpm_debug) {
+		dev_dbg(&adap->dev, "iip %p, dp_addr 0x%x\n", cpm->iip,
+			cpm->dp_addr);
+		dev_dbg(&adap->dev, "iic_tbase %d, iic_rbase %d\n",
+			in_be16(&iip->iic_tbase), in_be16(&iip->iic_rbase));
+	}
+
+	out_8(&iip->iic_tfcr, SMC_EB);
+	out_8(&iip->iic_rfcr, SMC_EB);
+
+	/* Set maximum receive size.
+	 */
+	out_be16(&iip->iic_mrblr, CPM_MAX_READ);
+
+	/* Initialize Tx/Rx parameters.
+	 */
+	if (cpm->reloc == 0) {
+		cpm8xx_t *cp = cpm->cp;
+		int res;
+
+		u16 v = mk_cr_cmd(CPM_CR_CH_I2C, CPM_CR_INIT_TRX) | CPM_CR_FLG;
+
+		out_be16(&cp->cp_cpcr, v);
+		res = wait_event_timeout(cpm->iic_wait,
+					 !(in_be16(&cp->cp_cpcr) & CPM_CR_FLG),
+					 HZ * 10);
+		if (!res)
+			return -EIO;
+
+	} else {
+		iip->iic_rbptr = iip->iic_rbase;
+		iip->iic_tbptr = iip->iic_tbase;
+		iip->iic_rstate = 0;
+		iip->iic_tstate = 0;
+	}
+
+	/* Select an arbitrary address.  Just make sure it is unique.
+	 */
+	out_8(&i2c->i2c_i2add, 0xfe);
+
+	/* Make clock run at 60 kHz.
+	 */
+	/* brg = ppc_proc_freq / (32 * 2 * 60000) - 3; */
+	brg = 7;
+	out_8(&i2c->i2c_i2brg, brg);
+
+	out_8(&i2c->i2c_i2mod, 0x00);
+	out_8(&i2c->i2c_i2com, 0x01);	/* Master mode */
+
+	/* Disable interrupts.
+	 */
+	out_8(&i2c->i2c_i2cmr, 0);
+	out_8(&i2c->i2c_i2cer, 0xff);
+
+	/* Allocate TX and RX buffers */
+	for (i = 0; i < CPM_MAXBD; i++) {
+		cpm->rxbuf[i] = (unsigned char *)dma_alloc_coherent(
+			NULL, CPM_MAX_READ + 1, &cpm->rxdma[i], GFP_KERNEL);
+		if (!cpm->rxbuf[i]) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		cpm->txbuf[i] = (unsigned char *)dma_alloc_coherent(
+			NULL, CPM_MAX_READ + 1, &cpm->txdma[i], GFP_KERNEL);
+		if (!cpm->txbuf[i]) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+
+	/* Install interrupt handler.
+	 */
+	if (request_irq(cpm->irq, cpm_iic_interrupt, 0, "8xx_i2c", adap)) {
+		ret = -EIO;
+		goto out;
+	}
+
+	return 0;
+out:
+	for (i = 0; i < CPM_MAXBD; i++) {
+		if (cpm->rxbuf[i]) dma_free_coherent(NULL, CPM_MAX_READ + 1,
+			cpm->rxbuf[i], cpm->rxdma[i]);
+		if (cpm->txbuf[i]) dma_free_coherent(NULL, CPM_MAX_READ + 1,
+			cpm->txbuf[i], cpm->txdma[i]);
+	}
+	return ret;
+}
+
+static int cpm_iic_shutdown(struct i2c_adapter *adap)
+{
+	struct i2c_algo_cpm_data *cpm = adap->algo_data;
+	int i;
+
+	i2c8xx_t *i2c = cpm->i2c;
+
+	/* Shut down IIC.
+	 */
+	out_8(&i2c->i2c_i2mod, in_8(&i2c->i2c_i2mod) | ~1);
+	out_8(&i2c->i2c_i2cmr, 0);
+	out_8(&i2c->i2c_i2cer, 0xff);
+
+	for (i = 0; i < CPM_MAXBD; i++) {
+		if (cpm->rxbuf[i]) dma_free_coherent(NULL, CPM_MAX_READ + 1,
+			cpm->rxbuf[i], cpm->rxdma[i]);
+		if (cpm->txbuf[i]) dma_free_coherent(NULL, CPM_MAX_READ + 1,
+			cpm->txbuf[i], cpm->txdma[i]);
+	}
+
+	free_irq(cpm->irq, adap);
+
+	return (0);
+}
+
+static void cpm_reset_iic_params(struct i2c_algo_cpm_data *cpm)
+{
+	iic_t *iip = cpm->iip;
+
+	out_be16(&iip->iic_tbase, cpm->dp_addr);
+	out_be16(&iip->iic_rbase, cpm->dp_addr + sizeof(cbd_t) * CPM_MAXBD);
+
+	out_8(&iip->iic_tfcr, SMC_EB);
+	out_8(&iip->iic_rfcr, SMC_EB);
+
+	out_be16(&iip->iic_mrblr, CPM_MAX_READ);
+
+	out_be32(&iip->iic_rstate, 0);
+	out_be32(&iip->iic_rdp, 0);
+	out_be16(&iip->iic_rbptr, in_be16(&iip->iic_rbase));
+	out_be16(&iip->iic_rbc, 0);
+	out_be32(&iip->iic_rxtmp, 0);
+	out_be32(&iip->iic_tstate, 0);
+	out_be32(&iip->iic_tdp, 0);
+	out_be16(&iip->iic_tbptr, in_be16(&iip->iic_tbase));
+	out_be16(&iip->iic_tbc, 0);
+	out_be32(&iip->iic_txtmp, 0);
+}
+
+#define BD_SC_NAK		((ushort)0x0004) /* NAK - did not respond */
+#define BD_SC_OV		((ushort)0x0002) /* OV - receive overrun */
+#define CPM_CR_CLOSE_RXBD	((ushort)0x0007)
+
+static void force_close(struct i2c_adapter *adap)
+{
+	struct i2c_algo_cpm_data *cpm = adap->algo_data;
+	i2c8xx_t *i2c = cpm->i2c;
+	if (cpm->reloc == 0) {	/* micro code disabled */
+		cpm8xx_t *cp = cpm->cp;
+		u16 v =
+		    mk_cr_cmd(CPM_CR_CH_I2C, CPM_CR_CLOSE_RXBD) | CPM_CR_FLG;
+
+		if (cpm_debug)
+			printk(KERN_INFO "force_close()\n");
+
+		out_be16(&cp->cp_cpcr, v);
+		wait_event_timeout(cpm->iic_wait,
+				   !(in_be16(&cp->cp_cpcr) & CPM_CR_FLG),
+				   HZ * 5);
+	}
+	out_8(&i2c->i2c_i2cmr, 0x00);	/* Disable all interrupts */
+	out_8(&i2c->i2c_i2cer, 0xff);
+}
+
+static void cpm_parse_message(struct i2c_adapter *adap, struct i2c_msg *pmsg,
+	int num, int tx, int rx)
+{
+	cbd_t *tbdf, *rbdf;
+	u_char addr;
+	u_char *tb;
+	u_char *rb;
+	struct i2c_algo_cpm_data *cpm = adap->algo_data;
+	iic_t *iip = cpm->iip;
+	int i, dscan;
+
+	tbdf = (cbd_t *) cpm_dpram_addr(in_be16(&iip->iic_tbase));
+	rbdf = (cbd_t *) cpm_dpram_addr(in_be16(&iip->iic_rbase));
+
+	/* This chip can't do zero lenth writes. However, the i2c core uses
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
+	rb = (u_char *) (((uint) rb + 1) & ~1);
+
+	if ((pmsg->flags & I2C_M_RD) || dscan) {
+		/* To read, we need an empty buffer of the proper length.
+		 * All that is used is the first byte for address, the remainder
+		 * is just used for timing (and doesn't really have to exist).
+		 */
+		tb[0] = addr;		/* Device address byte w/rw flag */
+
+		if (cpm_debug)
+			dev_dbg(&adap->dev, "cpm_iic_read(abyte=0x%x)\n", addr);
+		tbdf[tx].cbd_bufaddr = cpm->txdma[tx];
+		if (dscan)
+			tbdf[tx].cbd_datlen = 2;
+		else
+			tbdf[tx].cbd_datlen = pmsg->len + 1;
+		tbdf[tx].cbd_sc = 0;
+		if (!(pmsg->flags & I2C_M_NOSTART))
+			tbdf[tx].cbd_sc |= BD_IIC_START;
+		if (tx + 1 == num)
+			tbdf[tx].cbd_sc |= BD_SC_LAST | BD_SC_WRAP;
+
+		rbdf[rx].cbd_datlen = 0;
+		rbdf[rx].cbd_bufaddr = ((cpm->rxdma[rx] + 1) & ~1);
+		rbdf[rx].cbd_sc = BD_SC_EMPTY | BD_SC_INTRPT;
+		if (rx + 1 == CPM_MAXBD)
+			tbdf[rx].cbd_sc |= BD_SC_WRAP;
+
+		tbdf[tx].cbd_sc |= BD_SC_READY;
+	} else {
+		tb[0] = addr;		/* Device address byte w/rw flag */
+		for (i = 0; i < pmsg->len; i++)
+			tb[i+1] = pmsg->buf[i];
+
+		if (cpm_debug)
+			dev_dbg(&adap->dev, "cpm_iic_write(abyte=0x%x)\n",
+				addr);
+		tbdf[tx].cbd_bufaddr = cpm->txdma[tx];
+		tbdf[tx].cbd_datlen = pmsg->len + 1;
+		tbdf[tx].cbd_sc = 0;
+		if (!(pmsg->flags & I2C_M_NOSTART))
+			tbdf[tx].cbd_sc |= BD_IIC_START;
+		if (tx + 1 == num)
+			tbdf[tx].cbd_sc |= BD_SC_LAST | BD_SC_WRAP;
+		tbdf[tx].cbd_sc |= BD_SC_READY | BD_SC_INTRPT;
+		dev_dbg(&adap->dev, "tx sc %d %04x\n",
+			tx, tbdf[tx].cbd_sc);
+	}
+}
+
+static int cpm_check_message(struct i2c_adapter *adap, struct i2c_msg *pmsg,
+	int tx, int rx)
+{
+	cbd_t *tbdf, *rbdf;
+	u_char *tb;
+	u_char *rb;
+	struct i2c_algo_cpm_data *cpm = adap->algo_data;
+	iic_t *iip = cpm->iip;
+	int i;
+
+	tbdf = (cbd_t *) cpm_dpram_addr(in_be16(&iip->iic_tbase));
+	rbdf = (cbd_t *) cpm_dpram_addr(in_be16(&iip->iic_rbase));
+
+	tb = cpm->txbuf[tx];
+	rb = cpm->rxbuf[rx];
+
+	/* Align read buffer */
+	rb = (u_char *) (((uint) rb + 1) & ~1);
+
+	if (pmsg->flags & I2C_M_RD) {
+		if (cpm_debug)
+			dev_dbg(&adap->dev, "rx sc %04x, rx sc %04x\n",
+				tbdf[tx].cbd_sc, rbdf[rx].cbd_sc);
+		if (tbdf[tx].cbd_sc & BD_SC_NAK) {
+			if (cpm_debug)
+				dev_dbg(&adap->dev, "IIC read; no ack\n");
+			if (pmsg->flags & I2C_M_IGNORE_NAK)
+				return 0;
+			else
+				return -EREMOTEIO;
+		}
+		if (rbdf[rx].cbd_sc & BD_SC_EMPTY) {
+			if (cpm_debug) {
+				dev_dbg(&adap->dev,
+					"IIC read; complete but rbuf empty\n");
+			}
+			return -EREMOTEIO;
+		}
+		if (rbdf[rx].cbd_sc & BD_SC_OV) {
+			if (cpm_debug)
+				dev_dbg(&adap->dev, "IIC read; Overrun\n");
+			return -EREMOTEIO;
+		}
+		for (i = 0; i < pmsg->len; i++)
+			pmsg->buf[i] = rb[i];
+	} else {
+		if (cpm_debug)
+			dev_dbg(&adap->dev, "tx sc %d %04x\n",
+				tx, tbdf[tx].cbd_sc);
+		if (tbdf[tx].cbd_sc & BD_SC_NAK) {
+			if (cpm_debug)
+				dev_dbg(&adap->dev, "IIC write; no ack\n");
+			if (pmsg->flags & I2C_M_IGNORE_NAK)
+				return 0;
+			else
+				return -EIO;
+		}
+	}
+	return 0;
+}
+
+static int cpm_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
+{
+	struct i2c_algo_cpm_data *cpm = adap->algo_data;
+	i2c8xx_t *i2c = cpm->i2c;
+	iic_t *iip = cpm->iip;
+	struct i2c_msg *pmsg, *rmsg;
+	int ret, i;
+	int tptr;
+	int rptr;
+	cbd_t *tbdf, *rbdf;
+
+	if (num > CPM_MAXBD)
+		return -EREMOTEIO;
+
+	/* Check if we have any oversized READ requests */
+	for (i = 0; i < num; i++) {
+		pmsg = &msgs[i];
+		if (pmsg->len >= CPM_MAX_READ)
+			return -EREMOTEIO;
+	}
+
+	mutex_lock(&cpm->iic_mutex);
+
+	/* check for and use a microcode relocation patch */
+	if (cpm->reloc)
+		cpm_reset_iic_params(cpm);
+
+	/* Reset to use first buffer */
+	out_be16(&iip->iic_rbptr, in_be16(&iip->iic_rbase));
+	out_be16(&iip->iic_tbptr, in_be16(&iip->iic_tbase));
+
+	tbdf = (cbd_t *) cpm_dpram_addr(in_be16(&iip->iic_tbase));
+	rbdf = (cbd_t *) cpm_dpram_addr(in_be16(&iip->iic_rbase));
+
+	tptr = 0;
+	rptr = 0;
+
+	while (tptr < num) {
+		pmsg = &msgs[tptr];
+		if (cpm_debug)
+			dev_dbg(&adap->dev, "i2c-algo-cpm.o: "
+				"R: %d T: %d\n",
+				rptr, tptr);
+
+		cpm_parse_message(adap, pmsg, num, tptr, rptr);
+		if (pmsg->flags & I2C_M_RD)
+			rptr++;
+		tptr++;
+	}
+	/* Start transfer now */
+	/* Chip bug, set enable here */
+	out_8(&i2c->i2c_i2cmr, 0x13);	/* Enable some interupts */
+	out_8(&i2c->i2c_i2cer, 0xff);
+	out_8(&i2c->i2c_i2mod, in_8(&i2c->i2c_i2mod) | 1);	/* Enable */
+	/* Begin transmission */
+	out_8(&i2c->i2c_i2com, in_8(&i2c->i2c_i2com) | 0x80);
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
+			ret = cpm_check_message(adap, rmsg, tptr, rptr);
+			tptr++;
+			if (rmsg->flags & I2C_M_RD)
+				rptr++;
+			if (ret) {
+				force_close(adap);
+				mutex_unlock(&cpm->iic_mutex);
+				return -EREMOTEIO;
+			}
+		} else {
+			dev_dbg(&adap->dev, "not ready.\n");
+			ret = wait_event_interruptible_timeout(cpm->iic_wait,
+				!(tbdf[tptr].cbd_sc & BD_SC_READY), 1 * HZ);
+			if (ret == 0) {
+				force_close(adap);
+				if (cpm_debug)
+					dev_dbg(&adap->dev,
+						"IIC read: timeout!\n");
+				mutex_unlock(&cpm->iic_mutex);
+				return -EREMOTEIO;
+			}
+		}
+	}
+#ifdef I2C_CHIP_ERRATA
+	/* Chip errata, clear enable. This is not needed on rev D4 CPUs.
+	   Disabling I2C too early may cause too short stop condition */
+	udelay(4);
+	out_8(&i2c->i2c_i2mod, in_8(&i2c->i2c_i2mod) | ~1);
+#endif
+	mutex_unlock(&cpm->iic_mutex);
+	return (num);
+}
+
+static u32 cpm_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+/* -----exported algorithm data: -------------------------------------	*/
+
+static struct i2c_algorithm cpm_algo = {
+	.master_xfer = cpm_xfer,
+	.functionality = cpm_func,
+};
+
+/*
+ * registering functions to load algorithms at runtime
+ */
+int i2c_cpm_add_bus(struct i2c_adapter *adap)
+{
+	int res;
+
+	if (cpm_debug)
+		dev_dbg(&adap->dev,
+			"i2c-algo-cpm.o: hw routines for %s registered.\n",
+			adap->name);
+
+	/* register new adapter to i2c module... */
+
+	adap->algo = &cpm_algo;
+
+	res = cpm_iic_init(adap);
+
+	if (res)
+		return res;
+
+	return i2c_add_adapter(adap);
+}
+EXPORT_SYMBOL(i2c_cpm_add_bus);
+
+int i2c_cpm_del_bus(struct i2c_adapter *adap)
+{
+	i2c_del_adapter(adap);
+
+	return cpm_iic_shutdown(adap);
+}
+EXPORT_SYMBOL(i2c_cpm_del_bus);
+
+MODULE_AUTHOR("Brad Parker <brad@heeltoe.com>");
+MODULE_DESCRIPTION("I2C-Bus CPM algorithm");
+MODULE_LICENSE("GPL");
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index de95c75..705997b 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -4,6 +4,28 @@
 
 menu "I2C Hardware Bus support"
 
+config I2C_8XX_PPC
+	tristate "MPC8xx CPM oldstyle (no OF)"
+	depends on 8xx && I2C && !OF
+	select I2C_ALGOCPM
+	help
+	  This supports the use of the I2C interface on Freescale MPC8xx
+	  processors.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-8xx-ppc.
+
+config I2C_8XX
+	tristate "MPC8xx CPM with Open Firmware"
+	depends on 8xx && I2C && OF
+	select I2C_ALGOCPM
+	help
+	  This supports the use of the I2C interface on Freescale MPC8xx
+	  processors.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-8xx.
+
 config I2C_ALI1535
 	tristate "ALI 1535"
 	depends on PCI
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 81d43c2..f2feb4b 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the i2c bus drivers.
 #
 
+obj-$(CONFIG_I2C_8XX_PPC)	+= i2c-8xx-ppc.o
+obj-$(CONFIG_I2C_8XX)		+= i2c-8xx.o
 obj-$(CONFIG_I2C_ALI1535)	+= i2c-ali1535.o
 obj-$(CONFIG_I2C_ALI1563)	+= i2c-ali1563.o
 obj-$(CONFIG_I2C_ALI15X3)	+= i2c-ali15x3.o
diff --git a/drivers/i2c/busses/i2c-8xx-ppc.c b/drivers/i2c/busses/i2c-8xx-ppc.c
new file mode 100644
index 0000000..88b1642
--- /dev/null
+++ b/drivers/i2c/busses/i2c-8xx-ppc.c
@@ -0,0 +1,105 @@
+/*
+ * Embedded Planet RPX Lite MPC8xx CPM I2C interface.
+ * Copyright (c) 1999 Dan Malek (dmalek@jlc.net).
+ *
+ * moved into proper i2c interface;
+ * Brad Parker (brad@heeltoe.com)
+ *
+ * RPX lite specific parts of the i2c interface
+ * Update:  There actually isn't anything RPXLite-specific about this module.
+ * This should work for most any 8xx board.  The console messages have been
+ * changed to eliminate RPXLite references.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/stddef.h>
+#include <linux/i2c.h>
+#include <linux/i2c-algo-cpm.h>
+#include <linux/platform_device.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+#include <asm/mpc8xx.h>
+#include <asm/commproc.h>
+
+static int
+m8xx_iic_init(struct i2c_algo_cpm_data *data)
+{
+	cpm8xx_t *cp;
+	immap_t *immap;
+
+	immap = (immap_t *)IMAP_ADDR;	/* and to internal registers */
+	/* Get pointer to Communication Processor */
+	cp = (cpm8xx_t *)&immap->im_cpm;
+
+	data->iip = (iic_t *)&cp->cp_dparam[PROFF_IIC];
+
+	/* Check for and use a microcode relocation patch.
+	*/
+	data->reloc = in_be16(&data->iip->iic_rpbase);
+	if (data->reloc)
+		data->iip = (iic_t *)&cp->cp_dpmem[data->reloc];
+
+	data->i2c = (i2c8xx_t *)&(immap->im_i2c);
+	data->cp = cp;
+
+	/* Initialize Port B IIC pins.
+	*/
+	setbits32(&cp->cp_pbpar, 0x00000030);
+	setbits32(&cp->cp_pbdir, 0x00000030);
+	setbits16(&cp->cp_pbodr, 0x0030);
+
+	/* Allocate space for transmit and receive buffer
+	 * descriptors in the DP ram.
+	 */
+	data->dp_addr = cpm_dpalloc(sizeof(cbd_t) * 2 * CPM_MAXBD, 8);
+	if (!data->dp_addr)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static struct i2c_algo_cpm_data m8xx_data = {
+	.irq = CPM_IRQ_OFFSET + CPMVEC_I2C,
+};
+
+static struct i2c_adapter m8xx_ops = {
+	.owner		= THIS_MODULE,
+	.name		= "i2c-8xx-ppc",
+	.id		= I2C_HW_MPC8XX_EPON,
+	.algo_data	= &m8xx_data,
+	.dev.parent	= &platform_bus,
+	.class		= I2C_CLASS_HWMON,
+};
+
+int __init i2c_8xx_init(void)
+{
+	int ret;
+
+	printk(KERN_INFO "i2c-8xx-ppc: i2c MPC8xx driver\n");
+
+	/* reset hardware to sane state */
+	ret = m8xx_iic_init(&m8xx_data);
+	if (ret)
+		return ret;
+
+	if (i2c_cpm_add_bus(&m8xx_ops) < 0) {
+		printk(KERN_ERR "i2c-8xx-ppc: Unable to register with I2C\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+void __exit i2c_8xx_exit(void)
+{
+	i2c_cpm_del_bus(&m8xx_ops);
+}
+
+module_init(i2c_8xx_init);
+module_exit(i2c_8xx_exit);
+
+MODULE_AUTHOR("Dan Malek <dmalek@jlc.net>");
+MODULE_DESCRIPTION("I2C-Bus adapter routines for MPC8xx boards");
+MODULE_LICENSE("GPL");
diff --git a/drivers/i2c/busses/i2c-8xx.c b/drivers/i2c/busses/i2c-8xx.c
new file mode 100644
index 0000000..c38b52e
--- /dev/null
+++ b/drivers/i2c/busses/i2c-8xx.c
@@ -0,0 +1,170 @@
+/*
+ * Embedded Planet RPX Lite MPC8xx CPM I2C interface.
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
+ * This should work for most any 8xx board.  The console messages have been
+ * changed to eliminate RPXLite references.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/stddef.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+#include <linux/i2c-algo-cpm.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <asm/mpc8xx.h>
+#include <asm/commproc.h>
+#include <asm/fs_pd.h>
+
+
+struct m8xx_i2c {
+	char *base;
+	struct of_device *ofdev;
+	struct i2c_adapter adap;
+	struct i2c_algo_cpm_data *algo_8xx;
+};
+
+static struct i2c_algo_cpm_data m8xx_data;
+
+static const struct i2c_adapter m8xx_ops = {
+	.owner		= THIS_MODULE,
+	.name		= "i2c-8xx",
+	.id		= I2C_HW_MPC8XX_EPON,
+	.algo_data	= &m8xx_data,
+	.dev.parent	= &platform_bus,
+	.class		= I2C_CLASS_HWMON,
+};
+
+static int m8xx_iic_init(struct m8xx_i2c *i2c)
+{
+	cpm8xx_t *cp;
+	struct resource r;
+	struct i2c_algo_cpm_data *data = i2c->algo_8xx;
+	struct of_device *ofdev = i2c->ofdev;
+	struct device_node *np = ofdev->node;
+
+	/* Pointer to Communication Processor
+	 */
+	cp = (cpm8xx_t *)immr_map(im_cpm);
+	data->cp = cp;
+
+	data->irq = irq_of_parse_and_map(np, 0);
+	if (data->irq < 0)
+		return -EINVAL;
+
+	if (of_address_to_resource(np, 1, &r))
+		return -EINVAL;
+
+	data->iip = ioremap(r.start, r.end - r.start + 1);
+	if (data->iip == NULL)
+		return -EINVAL;
+
+	/* Check for and use a microcode relocation patch.
+	 */
+	data->reloc = data->iip->iic_rpbase;
+	if (data->reloc)
+		data->iip = (iic_t *)&cp->cp_dpmem[data->iip->iic_rpbase];
+
+	if (of_address_to_resource(np, 0, &r))
+		return -EINVAL;
+
+	data->i2c = ioremap(r.start, r.end - r.start + 1);
+	if (data->i2c == NULL)
+		return -EINVAL;
+
+	/* Allocate space for two transmit and two receive buffer
+	 * descriptors in the DP ram.
+	 */
+	data->dp_addr = cpm_dpalloc(sizeof(cbd_t) * 4, 8);
+	if (!data->dp_addr)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int i2c_8xx_probe(struct of_device *ofdev,
+			 const struct of_device_id *match)
+{
+	int result;
+	struct m8xx_i2c *i2c;
+
+	i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
+	if (!i2c)
+		return -ENOMEM;
+
+	i2c->ofdev = ofdev;
+	i2c->algo_8xx = &m8xx_data;
+
+	m8xx_iic_init(i2c);
+
+	dev_set_drvdata(&ofdev->dev, i2c);
+
+	i2c->adap = m8xx_ops;
+	i2c_set_adapdata(&i2c->adap, i2c);
+	i2c->adap.dev.parent = &ofdev->dev;
+
+	result = i2c_cpm_add_bus(&i2c->adap);
+	if (result < 0) {
+		printk(KERN_ERR "i2c-8xx: Unable to register with I2C\n");
+		kfree(i2c);
+	}
+
+	return result;
+}
+
+static int i2c_8xx_remove(struct of_device *ofdev)
+{
+	struct m8xx_i2c *i2c = dev_get_drvdata(&ofdev->dev);
+
+	i2c_cpm_del_bus(&i2c->adap);
+	dev_set_drvdata(&ofdev->dev, NULL);
+
+	kfree(i2c);
+	return 0;
+}
+
+static struct of_device_id i2c_8xx_match[] = {
+	{
+		.type = "i2c",
+		.compatible = "fsl,i2c-cpm",
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, i2c_8xx_match);
+
+static struct of_platform_driver i2c_8xx_driver = {
+	.name		= "fsl-i2c-cpm",
+	.match_table	= i2c_8xx_match,
+	.probe		= i2c_8xx_probe,
+	.remove		= i2c_8xx_remove,
+};
+
+static int __init i2c_8xx_init(void)
+{
+	return of_register_platform_driver(&i2c_8xx_driver);
+}
+
+static void __exit i2c_8xx_exit(void)
+{
+	of_unregister_platform_driver(&i2c_8xx_driver);
+}
+
+module_init(i2c_8xx_init);
+module_exit(i2c_8xx_exit);
+
+MODULE_AUTHOR("Dan Malek <dmalek@jlc.net>");
+MODULE_DESCRIPTION("I2C-Bus adapter routines for MPC8xx boards");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/i2c-algo-cpm.h b/include/linux/i2c-algo-cpm.h
new file mode 100644
index 0000000..2192b7d
--- /dev/null
+++ b/include/linux/i2c-algo-cpm.h
@@ -0,0 +1,34 @@
+/* ------------------------------------------------------------------------- */
+/* i2c-algo-cpm.h i2c driver algorithms for MPX8XX CPM or MPC8250 CPM2       */
+/* ------------------------------------------------------------------------- */
+
+#ifndef I2C_ALGO_CPM_H
+#define I2C_ALGO_CPM_H
+
+#include <linux/i2c.h>
+#include <asm/8xx_immap.h>
+#include <asm/commproc.h>
+
+#define CPM_MAX_READ    513
+#define CPM_MAXBD       4
+
+struct i2c_algo_cpm_data {
+	uint dp_addr;
+	int reloc;
+	int irq;
+	i2c8xx_t *i2c;
+	iic_t *iip;
+	cpm8xx_t *cp;
+	wait_queue_head_t iic_wait;
+	struct mutex iic_mutex; /* Protects I2C CPM */
+	u_char *txbuf[CPM_MAXBD];
+	u_char *rxbuf[CPM_MAXBD];
+	u32 txdma[CPM_MAXBD];
+	u32 rxdma[CPM_MAXBD];
+};
+
+extern int i2c_cpm_add_bus(struct i2c_adapter *);
+extern int i2c_cpm_del_bus(struct i2c_adapter *);
+
+#endif /* I2C_ALGO_CPM_H */
+


--------------000601030707050808070208--
