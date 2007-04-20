Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbXDTFHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbXDTFHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422894AbXDTFHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:07:16 -0400
Received: from dialup.esmr.ru ([85.94.3.83]:50832 "EHLO localhost.localdomain"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754417AbXDTFG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:06:59 -0400
X-Greylist: delayed 2350 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2007 01:06:58 EDT
Date: Fri, 20 Apr 2007 08:27:14 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Subject: [PATCH][RFC][POWERPC] i2c: adds support for i2c bus on 8xx
Message-ID: <20070420082714.4f10f186@localhost.localdomain>
X-Mailer: Claws Mail 2.8.1cvs91 (GTK+ 2.10.9; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Utilized devicetree to store I2C data, ported i2c-algo-8xx.c from 2.4
approach(which remains nearly intact), refined i2c-rpx.c. I2C functionality has been validated on
mpc885ads with EEPROM access.

Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
---
Jean, 

The patch below may have rough edges but I'd appreciate you to take a look.
It adds I2C capabilities of PQ series (mpc8xx mostly) or, more correctly, takes
them off from the 2.4 kernel and makes it work.

Validated with quilt tree residing at
http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/


 arch/powerpc/boot/dts/mpc885ads.dts          |    7 
 arch/powerpc/platforms/8xx/mpc885ads_setup.c |   14 +
 arch/powerpc/sysdev/fsl_soc.c                |   61 +++
 drivers/i2c/algos/Kconfig                    |    2 
 drivers/i2c/algos/Makefile                   |    1 
 drivers/i2c/algos/i2c-algo-8xx.c             |  622 ++++++++++++++++++++++++++
 drivers/i2c/busses/Kconfig                   |    4 
 drivers/i2c/busses/i2c-rpx.c                 |  129 ++++-
 include/linux/i2c-algo-8xx.h                 |   29 +
 9 files changed, 822 insertions(+), 47 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc885ads.dts b/arch/powerpc/boot/dts/mpc885ads.dts
index 19d2d79..90e047a 100644
--- a/arch/powerpc/boot/dts/mpc885ads.dts
+++ b/arch/powerpc/boot/dts/mpc885ads.dts
@@ -188,6 +188,13 @@
 				interrupts = <1d 3>;
 				interrupt-parent = <930>;
 			};
+			i2c@860 {
+				device_type = "i2c";
+				compatible = "fsl-i2c-cpm";
+				reg = <860 20 3c80 30>;
+				interrupts = <10 3>;
+				interrupt-parent = <930>;
+			};
 		};
 	};
 };
diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index 9bd81c7..d32e066 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -51,6 +51,7 @@ static void init_smc1_uart_ioports(struc
 static void init_smc2_uart_ioports(struct fs_uart_platform_info* fpi);
 static void init_scc3_ioports(struct fs_platform_info* ptr);
 static void init_irda_ioports(void);
+static void init_i2c_ioports(void);
 
 void __init mpc885ads_board_setup(void)
 {
@@ -120,6 +121,10 @@ #endif
 #ifdef CONFIG_8XX_SIR
 	init_irda_ioports();
 #endif
+
+#ifdef CONFIG_I2C_RPXLITE
+	init_i2c_ioports();
+#endif
 }
 
 
@@ -361,6 +366,15 @@ static void init_irda_ioports()
 	immr_unmap(cp);
 }
 
+static void init_i2c_ioports()
+{
+	cpm8xx_t *cp = (cpm8xx_t *)immr_map(im_cpm);
+
+        setbits32(&cp->cp_pbpar, 0x00000030);
+        setbits32(&cp->cp_pbdir, 0x00000030);
+        setbits16(&cp->cp_pbodr, 0x0030);
+}
+
 int platform_device_skip(const char *model, int id)
 {
 #ifdef CONFIG_MPC8xx_SECOND_ETH_SCC3
diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index 419b688..7ecd537 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -331,7 +331,7 @@ static int __init fsl_i2c_of_init(void)
 	for (np = NULL, i = 0;
 	     (np = of_find_compatible_node(np, "i2c", "fsl-i2c")) != NULL;
 	     i++) {
-		struct resource r[2];
+		struct resource r[3];
 		struct fsl_i2c_platform_data i2c_data;
 		const unsigned char *flags = NULL;
 
@@ -1215,4 +1215,63 @@ err:
 
 arch_initcall(fs_irda_of_init);
 
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
+
 #endif /* CONFIG_8xx */
diff --git a/drivers/i2c/algos/Kconfig b/drivers/i2c/algos/Kconfig
index 5889907..7d7fb87 100644
--- a/drivers/i2c/algos/Kconfig
+++ b/drivers/i2c/algos/Kconfig
@@ -37,6 +37,8 @@ config I2C_ALGOPCA
 config I2C_ALGO8XX
 	tristate "MPC8xx CPM I2C interface"
 	depends on 8xx
+	help
+	  8xx I2C Algorithm
 
 config I2C_ALGO_SGI
 	tristate "I2C SGI interfaces"
diff --git a/drivers/i2c/algos/Makefile b/drivers/i2c/algos/Makefile
index cac1051..1bd3b37 100644
--- a/drivers/i2c/algos/Makefile
+++ b/drivers/i2c/algos/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_I2C_ALGOBIT)	+= i2c-algo-bi
 obj-$(CONFIG_I2C_ALGOPCF)	+= i2c-algo-pcf.o
 obj-$(CONFIG_I2C_ALGOPCA)	+= i2c-algo-pca.o
 obj-$(CONFIG_I2C_ALGO_SGI)	+= i2c-algo-sgi.o
+obj-$(CONFIG_I2C_ALGO8XX)	+= i2c-algo-8xx.o
 
 ifeq ($(CONFIG_I2C_DEBUG_ALGO),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/drivers/i2c/algos/i2c-algo-8xx.c b/drivers/i2c/algos/i2c-algo-8xx.c
new file mode 100644
index 0000000..b1f414a
--- /dev/null
+++ b/drivers/i2c/algos/i2c-algo-8xx.c
@@ -0,0 +1,622 @@
+/*
+ * i2c-algo-8xx.c i2x driver algorithms for MPC8XX CPM
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
+ * parts into i2c-rpx.c
+ * Brad Parker (brad@heeltoe.com)
+ */
+
+
+/* $Id: i2c-algo-8xx.c,v 1.15 2004/11/20 08:02:24 khali Exp $ */
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
+#include <linux/i2c-algo-8xx.h>
+#include <asm/io.h>
+#include <asm/cacheflush.h>
+#include <asm/time.h>
+#include <asm/mpc8xx.h>
+
+#define CPM_MAX_READ	513
+#undef	I2C_CHIP_ERRATA /* Try ot define this if you have an older CPU(earlier than rev D4) */
+
+static wait_queue_head_t iic_wait;
+static ushort r_tbase, r_rbase;
+
+int cpm_debug = 0;
+int cpm_scan = 0;
+
+static irqreturn_t cpm_iic_interrupt(int irq, void *dev_id)
+{
+	i2c8xx_t *i2c = (i2c8xx_t *) dev_id;
+	if (cpm_debug > 1)
+		printk("cpm_iic_interrupt(dev_id=%p)\n", dev_id);
+#if 0
+	/* Chip errata, clear enable. This is not needed on rev D4 CPUs */
+	/* This should probably be removed and replaced by I2C_CHIP_ERRATA stuff */
+	/* Someone with a buggy CPU needs to confirm that */
+	out_8(&i2c->i2c_i2mod, in_8(&i2c->i2c_i2mod) | ~1);
+#endif
+	/* Clear interrupt.
+	 */
+	out_8(&i2c->i2c_i2cer, 0xff);
+
+	/* Get 'me going again.
+	 */
+	wake_up_interruptible(&iic_wait);
+
+	return IRQ_HANDLED;
+}
+
+static void cpm_iic_init(struct i2c_algo_8xx_data *cpm)
+{
+	iic_t *iip = cpm->iip;
+	i2c8xx_t *i2c = cpm->i2c;
+	unsigned char brg;
+
+	if (cpm_debug)
+		printk(KERN_DEBUG "cpm_iic_init()\n");
+
+	/* Initialize the parameter ram.
+	 * We need to make sure many things are initialized to zero,
+	 * especially in the case of a microcode patch.
+	 */
+	iip->iic_rstate = 0;
+	iip->iic_rdp = 0;
+	iip->iic_rbptr = 0;
+	iip->iic_rbc = 0;
+	iip->iic_rxtmp = 0;
+	iip->iic_tstate = 0;
+	iip->iic_tdp = 0;
+	iip->iic_tbptr = 0;
+	iip->iic_tbc = 0;
+	iip->iic_txtmp = 0;
+
+	/* Set up the IIC parameters in the parameter ram.
+	 */
+	iip->iic_tbase = r_tbase = cpm->dp_addr;
+	iip->iic_rbase = r_rbase = cpm->dp_addr + sizeof(cbd_t) * 2;
+
+	if (cpm_debug) {
+		printk("iip %p, dp_addr 0x%x\n", cpm->iip, cpm->dp_addr);
+		printk("iic_tbase %d, r_tbase %d\n", iip->iic_tbase, r_tbase);
+	}
+
+	iip->iic_tfcr = SMC_EB;
+	iip->iic_rfcr = SMC_EB;
+
+	/* Set maximum receive size.
+	 */
+	iip->iic_mrblr = CPM_MAX_READ;
+
+	/* Initialize Tx/Rx parameters.
+	 */
+	if (cpm->reloc == 0) {
+		cpm8xx_t *cp = cpm->cp;
+		u16 v = mk_cr_cmd(CPM_CR_CH_I2C, CPM_CR_INIT_TRX) | CPM_CR_FLG;
+
+		out_be16(&cp->cp_cpcr, v);
+		while (in_be16(&cp->cp_cpcr) & CPM_CR_FLG) ;
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
+	/* Make clock run at 60 KHz.
+	 */
+	brg = (unsigned char)(ppc_proc_freq / (32 * 2 * 60000) - 3);
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
+	init_waitqueue_head(&iic_wait);
+
+	/* Install interrupt handler.
+	 */
+	if (cpm_debug) {
+		printk("%s[%d] Install ISR for IRQ %d\n",
+		       __func__, __LINE__, CPMVEC_I2C);
+	}
+	request_irq(cpm->irq, cpm_iic_interrupt, 0, "8xx_i2c", i2c);
+}
+
+static int cpm_iic_shutdown(struct i2c_algo_8xx_data *cpm)
+{
+	i2c8xx_t *i2c = cpm->i2c;
+
+	/* Shut down IIC.
+	 */
+	out_8(&i2c->i2c_i2mod, in_8(&i2c->i2c_i2mod) | ~1);
+	out_8(&i2c->i2c_i2cmr, 0);
+	out_8(&i2c->i2c_i2cer, 0xff);
+
+	return (0);
+}
+
+static void cpm_reset_iic_params(iic_t * iip)
+{
+	iip->iic_tbase = r_tbase;
+	iip->iic_rbase = r_rbase;
+
+	iip->iic_tfcr = SMC_EB;
+	iip->iic_rfcr = SMC_EB;
+
+	iip->iic_mrblr = CPM_MAX_READ;
+
+	iip->iic_rstate = 0;
+	iip->iic_rdp = 0;
+	iip->iic_rbptr = iip->iic_rbase;
+	iip->iic_rbc = 0;
+	iip->iic_rxtmp = 0;
+	iip->iic_tstate = 0;
+	iip->iic_tdp = 0;
+	iip->iic_tbptr = iip->iic_tbase;
+	iip->iic_tbc = 0;
+	iip->iic_txtmp = 0;
+}
+
+#define BD_SC_NAK		((ushort)0x0004)	/* NAK - did not respond */
+#define BD_SC_OV		((ushort)0x0002)	/* OV - receive overrun */
+#define CPM_CR_CLOSE_RXBD	((ushort)0x0007)
+
+static void force_close(struct i2c_algo_8xx_data *cpm)
+{
+	i2c8xx_t *i2c = cpm->i2c;
+	if (cpm->reloc == 0) {	/* micro code disabled */
+		cpm8xx_t *cp = cpm->cp;
+		u16 v = mk_cr_cmd(CPM_CR_CH_I2C, CPM_CR_CLOSE_RXBD) | CPM_CR_FLG;
+
+		if (cpm_debug)
+			printk("force_close()\n");
+
+		out_be16(&cp->cp_cpcr, v);
+		while (in_be16(&cp->cp_cpcr) & CPM_CR_FLG) ;
+	}
+	out_8(&i2c->i2c_i2cmr, 0x00);	/* Disable all interrupts */
+	out_8(&i2c->i2c_i2cer, 0xff);
+}
+
+/* Read from IIC...
+ * abyte = address byte, with r/w flag already set
+ */
+static int
+cpm_iic_read(struct i2c_algo_8xx_data *cpm, u_char abyte, char *buf, int count)
+{
+	iic_t *iip = cpm->iip;
+	i2c8xx_t *i2c = cpm->i2c;
+	cbd_t *tbdf, *rbdf;
+	u_char *tb;
+	unsigned long tmo;
+	int res = 0;
+
+	if (count >= CPM_MAX_READ)
+		return -EINVAL;
+
+	/* check for and use a microcode relocation patch */
+	if (cpm->reloc) {
+		cpm_reset_iic_params(iip);
+	}
+
+	tbdf = (cbd_t *) cpm_dpram_addr(iip->iic_tbase);
+	rbdf = (cbd_t *) cpm_dpram_addr(iip->iic_rbase);
+
+	/* To read, we need an empty buffer of the proper length.
+	 * All that is used is the first byte for address, the remainder
+	 * is just used for timing (and doesn't really have to exist).
+	 */
+	tb = cpm->temp;
+	tb = (u_char *) (((uint) tb + 15) & ~15);
+	tb[0] = abyte;		/* Device address byte w/rw flag */
+
+	flush_dcache_range((unsigned long)tb, (unsigned long)(tb + 1));
+
+	if (cpm_debug)
+		printk("cpm_iic_read(abyte=0x%x)\n", abyte);
+
+	tbdf->cbd_bufaddr = __pa(tb);
+	tbdf->cbd_datlen = count + 1;
+	tbdf->cbd_sc = BD_SC_READY | BD_SC_LAST | BD_SC_WRAP | BD_IIC_START;
+
+	iip->iic_mrblr = count + 1;	/* prevent excessive read, +1
+					   is needed otherwise will the
+					   RXB interrupt come too early */
+
+	/* flush will invalidate too. */
+	flush_dcache_range((unsigned long)buf, (unsigned long)(buf + count));
+
+	rbdf->cbd_datlen = 0;
+	rbdf->cbd_bufaddr = __pa(buf);
+	rbdf->cbd_sc = BD_SC_EMPTY | BD_SC_WRAP | BD_SC_INTRPT;
+
+	if (count > 16) {
+		/* Chip bug, set enable here */
+		out_8(&i2c->i2c_i2cmr, 0x13);	/* Enable some interupts */
+		out_8(&i2c->i2c_i2cer, 0xff);
+		out_8(&i2c->i2c_i2mod, in_8(&i2c->i2c_i2mod) | 1);	/* Enable */
+		out_8(&i2c->i2c_i2com, in_8(&i2c->i2c_i2com) | 0x80);	/* Begin transmission */
+
+		/* Wait for IIC transfer */
+		res = wait_event_interruptible_timeout(iic_wait, 0, 1 * HZ);
+	} else {		/* busy wait for small transfers, its faster */
+		out_8(&i2c->i2c_i2cmr, 0x00);	/* Disable I2C interupts */
+		out_8(&i2c->i2c_i2cer, 0xff);
+		out_8(&i2c->i2c_i2mod, in_8(&i2c->i2c_i2mod) | 1);	/* Enable */
+		out_8(&i2c->i2c_i2com, in_8(&i2c->i2c_i2com) | 0x80);	/* Begin transmission */
+
+		tmo = jiffies + 1 * HZ;
+		while (!(in_8(&i2c->i2c_i2cer) & 0x11 || time_after(jiffies, tmo))) ;/* Busy wait, with a timeout */
+	}
+
+	if ( res < 0) {
+		force_close(cpm);
+		if (cpm_debug)
+			printk("IIC read: timeout!\n");
+		return -EIO;
+	}
+#ifdef I2C_CHIP_ERRATA
+	/* Chip errata, clear enable. This is not needed on rev D4 CPUs.
+	   Disabling I2C too early may cause too short stop condition */
+	udelay(4);
+	out_8(&i2c->i2c_i2mod, in_8(&i2c->i2c_i2mod) | ~1);
+#endif
+	if (cpm_debug) {
+		printk("tx sc %04x, rx sc %04x\n", tbdf->cbd_sc, rbdf->cbd_sc);
+	}
+
+	if (tbdf->cbd_sc & BD_SC_READY) {
+		printk("IIC read; complete but tbuf ready\n");
+		force_close(cpm);
+		printk("tx sc %04x, rx sc %04x\n", tbdf->cbd_sc, rbdf->cbd_sc);
+	}
+
+	if (tbdf->cbd_sc & BD_SC_NAK) {
+		if (cpm_debug)
+			printk("IIC read; no ack\n");
+		return -EREMOTEIO;
+	}
+
+	if (rbdf->cbd_sc & BD_SC_EMPTY) {
+		/* force_close(cpm); */
+		if (cpm_debug) {
+			printk("IIC read; complete but rbuf empty\n");
+			printk("tx sc %04x, rx sc %04x\n",
+			       tbdf->cbd_sc, rbdf->cbd_sc);
+		}
+		return -EREMOTEIO;
+	}
+
+	if (rbdf->cbd_sc & BD_SC_OV) {
+		if (cpm_debug)
+			printk("IIC read; Overrun\n");
+		return -EREMOTEIO;;
+	}
+
+	if (cpm_debug)
+		printk("read %d bytes\n", rbdf->cbd_datlen);
+
+	if (rbdf->cbd_datlen < count) {
+		if (cpm_debug)
+			printk("IIC read; short, wanted %d got %d\n",
+			       count, rbdf->cbd_datlen);
+		return 0;
+	}
+
+	return count;
+}
+
+/* Write to IIC...
+ * addr = address byte, with r/w flag already set
+ */
+static int
+cpm_iic_write(struct i2c_algo_8xx_data *cpm, u_char abyte, char *buf, int count)
+{
+	iic_t *iip = cpm->iip;
+	i2c8xx_t *i2c = cpm->i2c;
+	cbd_t *tbdf;
+	u_char *tb;
+	unsigned long tmo;
+	int res = 0;
+
+	/* check for and use a microcode relocation patch */
+	if (cpm->reloc) {
+		cpm_reset_iic_params(iip);
+	}
+	tb = cpm->temp;
+	tb = (u_char *) (((uint) tb + 15) & ~15);
+	*tb = abyte;		/* Device address byte w/rw flag */
+
+	flush_dcache_range((unsigned long)tb, (unsigned long)(tb + 1));
+	flush_dcache_range((unsigned long)buf, (unsigned long)(buf + count));
+
+	if (cpm_debug)
+		printk("cpm_iic_write(abyte=0x%x)\n", abyte);
+
+	/* set up 2 descriptors */
+
+
+	tbdf = (cbd_t *) cpm_dpram_addr(iip->iic_tbase);
+
+	tbdf[0].cbd_bufaddr = __pa(tb);
+	tbdf[0].cbd_datlen = 1;
+	tbdf[0].cbd_sc = BD_SC_READY | BD_IIC_START;
+
+	tbdf[1].cbd_bufaddr = __pa(buf);
+	tbdf[1].cbd_datlen = count;
+	tbdf[1].cbd_sc = BD_SC_READY | BD_SC_INTRPT | BD_SC_LAST | BD_SC_WRAP;
+
+	if (count > 16) {
+		/* Chip bug, set enable here */
+		out_8(&i2c->i2c_i2cmr, 0x13);	/* Enable some interupts */
+		out_8(&i2c->i2c_i2cer, 0xff);
+		out_8(&i2c->i2c_i2mod, in_8(&i2c->i2c_i2mod) | 1);	/* Enable */
+		out_8(&i2c->i2c_i2com, in_8(&i2c->i2c_i2com) | 0x80);	/* Begin transmission */
+
+		/* Wait for IIC transfer */
+		res = wait_event_interruptible_timeout(iic_wait, 0, 1 * HZ);
+	} else {		/* busy wait for small transfers, its faster */
+		out_8(&i2c->i2c_i2cmr, 0x00);	/* Disable I2C interupts */
+		out_8(&i2c->i2c_i2cer, 0xff);
+		out_8(&i2c->i2c_i2mod, in_8(&i2c->i2c_i2mod) | 1);	/* Enable */
+		out_8(&i2c->i2c_i2com, in_8(&i2c->i2c_i2com) | 0x80);	/* Begin transmission */
+		tmo = jiffies + 1 * HZ;
+		while (!(in_8(&i2c->i2c_i2cer) & 0x12 || time_after(jiffies, tmo))) ;/* Busy wait, with a timeout */
+	}
+
+	if ( res < 0) {
+		force_close(cpm);
+		if (cpm_debug)
+			printk("IIC write: timeout!\n");
+		return -EIO;
+	}
+#ifdef I2C_CHIP_ERRATA
+	/* Chip errata, clear enable. This is not needed on rev D4 CPUs.
+	   Disabling I2C too early may cause too short stop condition */
+	udelay(4);
+	out_8(&i2c->i2c_i2mod, in_8(&i2c->i2c_i2mod) | ~1);
+#endif
+	if (cpm_debug) {
+		printk("tx0 sc %04x, tx1 sc %04x\n",
+		       tbdf[0].cbd_sc, tbdf[1].cbd_sc);
+	}
+
+	if (tbdf->cbd_sc & BD_SC_NAK) {
+		if (cpm_debug)
+			printk("IIC write; no ack\n");
+		return 0;
+	}
+
+	if (tbdf->cbd_sc & BD_SC_READY) {
+		if (cpm_debug)
+			printk("IIC write; complete but tbuf ready\n");
+		return 0;
+	}
+
+	return count;
+}
+
+/* See if an IIC address exists..
+ * addr = 7 bit address, unshifted
+ */
+static int cpm_iic_tryaddress(struct i2c_algo_8xx_data *cpm, int addr)
+{
+	iic_t *iip = cpm->iip;
+	i2c8xx_t *i2c = cpm->i2c;
+	cbd_t *tbdf, *rbdf;
+	u_char *tb;
+	unsigned long len;
+	int res = 0;
+
+	if (cpm_debug > 1)
+		printk("cpm_iic_tryaddress(cpm=%p,addr=%d)\n", cpm, addr);
+
+	/* check for and use a microcode relocation patch */
+	if (cpm->reloc) {
+		cpm_reset_iic_params(iip);
+	}
+
+	if (cpm_debug && addr == 0) {
+		printk("iip %p, dp_addr 0x%x\n", cpm->iip, cpm->dp_addr);
+		printk("iic_tbase %d, r_tbase %d\n", iip->iic_tbase, r_tbase);
+	}
+
+	tbdf = (cbd_t *) cpm_dpram_addr(iip->iic_tbase);
+	rbdf = (cbd_t *) cpm_dpram_addr(iip->iic_rbase);
+
+	tb = cpm->temp;
+	tb = (u_char *) (((uint) tb + 15) & ~15);
+
+	/* do a simple read */
+	tb[0] = (addr << 1) | 1;	/* device address (+ read) */
+	len = 2;
+
+	flush_dcache_range((unsigned long)tb, (unsigned long)(tb + 2));
+
+	tbdf->cbd_bufaddr = __pa(tb);
+	tbdf->cbd_datlen = len;
+	tbdf->cbd_sc = BD_SC_READY | BD_SC_LAST | BD_SC_WRAP | BD_IIC_START;
+
+	rbdf->cbd_datlen = 0;
+	rbdf->cbd_bufaddr = __pa(tb + 2);
+	rbdf->cbd_sc = BD_SC_EMPTY | BD_SC_WRAP | BD_SC_INTRPT;
+
+	out_8(&i2c->i2c_i2cmr, 0x13);	/* Enable some interupts */
+	out_8(&i2c->i2c_i2cer, 0xff);
+	out_8(&i2c->i2c_i2mod, in_8(&i2c->i2c_i2mod) | 1);	/* Enable */
+	out_8(&i2c->i2c_i2com, in_8(&i2c->i2c_i2com) | 0x80);	/* Begin transmission */
+
+	if (cpm_debug > 1)
+		printk("about to sleep\n");
+
+	/* wait for IIC transfer */
+	res = wait_event_interruptible_timeout(iic_wait, 0, 1 * HZ);
+
+#ifdef I2C_CHIP_ERRATA
+	/* Chip errata, clear enable. This is not needed on rev D4 CPUs.
+	   Disabling I2C too early may cause too short stop condition */
+	udelay(4);
+	out_8(&i2c->i2c_i2mod, in_8(&i2c->i2c_i2mod) | ~1);
+#endif
+
+	if ( res < 0) {
+		force_close(cpm);
+		if (cpm_debug)
+			printk("IIC tryaddress: timeout!\n");
+		return -EIO;
+	}
+
+	if (cpm_debug > 1)
+		printk("back from sleep\n");
+
+	if (tbdf->cbd_sc & BD_SC_NAK) {
+		if (cpm_debug > 1)
+			printk("IIC try; no ack\n");
+		return 0;
+	}
+
+	if (tbdf->cbd_sc & BD_SC_READY) {
+		printk("IIC try; complete but tbuf ready\n");
+	}
+
+	return 1;
+}
+
+static int cpm_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
+{
+	struct i2c_algo_8xx_data *cpm = adap->algo_data;
+	struct i2c_msg *pmsg;
+	int i, ret;
+	u_char addr;
+
+	for (i = 0; i < num; i++) {
+		pmsg = &msgs[i];
+
+		if (cpm_debug)
+			printk("i2c-algo-8xx.o: "
+			       "#%d addr=0x%x flags=0x%x len=%d\n buf=%lx\n",
+			       i, pmsg->addr, pmsg->flags, pmsg->len,
+			       (unsigned long)pmsg->buf);
+
+		addr = pmsg->addr << 1;
+		if (pmsg->flags & I2C_M_RD)
+			addr |= 1;
+		if (pmsg->flags & I2C_M_REV_DIR_ADDR)
+			addr ^= 1;
+
+		if (!(pmsg->flags & I2C_M_NOSTART)) {
+		}
+		if (pmsg->flags & I2C_M_RD) {
+			/* read bytes into buffer */
+			ret = cpm_iic_read(cpm, addr, pmsg->buf, pmsg->len);
+			if (cpm_debug)
+				printk("i2c-algo-8xx.o: read %d bytes\n", ret);
+			if (ret < pmsg->len) {
+				return (ret < 0) ? ret : -EREMOTEIO;
+			}
+		} else {
+			/* write bytes from buffer */
+			ret = cpm_iic_write(cpm, addr, pmsg->buf, pmsg->len);
+			if (cpm_debug)
+				printk("i2c-algo-8xx.o: wrote %d\n", ret);
+			if (ret < pmsg->len) {
+				return (ret < 0) ? ret : -EREMOTEIO;
+			}
+		}
+	}
+	return (num);
+}
+
+static u32 cpm_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_SMBUS_EMUL | I2C_FUNC_10BIT_ADDR |
+	    I2C_FUNC_PROTOCOL_MANGLING;
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
+int i2c_8xx_add_bus(struct i2c_adapter *adap)
+{
+	struct i2c_algo_8xx_data *cpm = adap->algo_data;
+	int i;
+
+	if (cpm_debug)
+		printk("i2c-algo-8xx.o: hw routines for %s registered.\n",
+		       adap->name);
+
+	/* register new adapter to i2c module... */
+
+	adap->algo = &cpm_algo;
+
+	i2c_add_adapter(adap);
+	cpm_iic_init(cpm);
+
+	/* scan bus */
+	if (cpm_scan) {
+		printk(KERN_INFO " i2c-algo-8xx.o: scanning bus %s...\n",
+			adap->name);
+		for (i = 0; i < 128; i++) {
+			if (cpm_iic_tryaddress(cpm, i))
+				printk("(%02x)",i<<1);
+		}
+		printk("\n");
+	}
+
+	return 0;
+}
+
+int i2c_8xx_del_bus(struct i2c_adapter *adap)
+{
+	struct i2c_algo_8xx_data *cpm = adap->algo_data;
+
+	cpm_iic_shutdown(cpm);
+
+	return i2c_del_adapter(adap);
+}
+
+EXPORT_SYMBOL(i2c_8xx_add_bus);
+EXPORT_SYMBOL(i2c_8xx_del_bus);
+
+MODULE_AUTHOR("Brad Parker <brad@heeltoe.com>");
+MODULE_DESCRIPTION("I2C-Bus MPC8XX algorithm");
+MODULE_LICENSE("GPL");
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 4afc795..83d9aef 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -385,8 +385,8 @@ config I2C_PROSAVAGE
 	  will be called i2c-prosavage.
 
 config I2C_RPXLITE
-	tristate "Embedded Planet RPX Lite/Classic support"
-	depends on RPXLITE || RPXCLASSIC
+	tristate "Embedded Planet RPX Lite/Classic and Freescale 86x/885 ads support"
+	depends on RPXLITE || RPXCLASSIC || MPC86XADS || MPC885ADS
 	select I2C_ALGO8XX
 
 config I2C_S3C2410
diff --git a/drivers/i2c/busses/i2c-rpx.c b/drivers/i2c/busses/i2c-rpx.c
index 8764df0..ebddd94 100644
--- a/drivers/i2c/busses/i2c-rpx.c
+++ b/drivers/i2c/busses/i2c-rpx.c
@@ -14,88 +14,129 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/stddef.h>
+#include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-8xx.h>
 #include <asm/mpc8xx.h>
 #include <asm/commproc.h>
+#include <asm/fs_pd.h>
 
 
-static void
-rpx_iic_init(struct i2c_algo_8xx_data *data)
+struct m8xx_i2c {
+	char *base;
+	struct device *dev;
+	struct i2c_adapter adap;
+	struct i2c_algo_8xx_data *algo_8xx;
+};
+
+static struct i2c_algo_8xx_data rpx_data;
+
+static struct i2c_adapter rpx_ops = {
+	.owner		= THIS_MODULE,
+	.name		= "m8xx",
+	.id		= I2C_HW_MPC8XX_EPON,
+	.algo_data	= &rpx_data,
+};
+
+static int rpx_iic_init(struct m8xx_i2c *i2c)
 {
 	volatile cpm8xx_t *cp;
-	volatile immap_t *immap;
+	struct resource *r;
+	struct i2c_algo_8xx_data *data = i2c->algo_8xx;
+	struct platform_device *pdev = to_platform_device(i2c->dev);
+
+	cp = data->cp = (cpm8xx_t *)immr_map(im_cpm);	/* pointer to Communication Processor */
 
-	cp = cpmp;	/* Get pointer to Communication Processor */
-	immap = (immap_t *)IMAP_ADDR;	/* and to internal registers */
+	data->irq = platform_get_irq_byname(pdev, "interrupt");
+  
+	if (data->irq < 0)
+		return -EINVAL;
 
-	data->iip = (iic_t *)&cp->cp_dparam[PROFF_IIC];
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "pram");
+	data->iip = ioremap(r->start, r->end - r->start + 1);
+	if (data->iip == NULL)
+		return -EINVAL;
 
 	/* Check for and use a microcode relocation patch.
-	*/
+	 */
 	if ((data->reloc = data->iip->iic_rpbase))
 		data->iip = (iic_t *)&cp->cp_dpmem[data->iip->iic_rpbase];
 		
-	data->i2c = (i2c8xx_t *)&(immap->im_i2c);
-	data->cp = cp;
-
-	/* Initialize Port B IIC pins.
-	*/
-	cp->cp_pbpar |= 0x00000030;
-	cp->cp_pbdir |= 0x00000030;
-	cp->cp_pbodr |= 0x00000030;
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
+	data->i2c = ioremap(r->start, r->end - r->start + 1);
+	if (data->i2c == NULL)
+		return -EINVAL;
 
 	/* Allocate space for two transmit and two receive buffer
 	 * descriptors in the DP ram.
 	 */
 	data->dp_addr = cpm_dpalloc(sizeof(cbd_t) * 4, 8);
-		
-	/* ptr to i2c area */
-	data->i2c = (i2c8xx_t *)&(((immap_t *)IMAP_ADDR)->im_i2c);
 }
 
-static int rpx_install_isr(int irq, void (*func)(void *), void *data)
+static int i2c_rpx_probe(struct device *device)
 {
-	/* install interrupt handler */
-	cpm_install_handler(irq, func, data);
-
-	return 0;
-}
+	int result = 0;
+	struct m8xx_i2c *i2c;
+	struct platform_device *pdev = to_platform_device(device);
 
-static struct i2c_algo_8xx_data rpx_data = {
-	.setisr = rpx_install_isr
-};
+	if (!(i2c = kmalloc(sizeof(*i2c), GFP_KERNEL))) {
+		return -ENOMEM;
+	}
+	memset(i2c, 0, sizeof(*i2c));
+	i2c->dev = device;
+	i2c->algo_8xx = &rpx_data;
 
-static struct i2c_adapter rpx_ops = {
-	.owner		= THIS_MODULE,
-	.name		= "m8xx",
-	.id		= I2C_HW_MPC8XX_EPON,
-	.algo_data	= &rpx_data,
-};
+	rpx_iic_init(i2c);
 
-int __init i2c_rpx_init(void)
-{
-	printk(KERN_INFO "i2c-rpx: i2c MPC8xx driver\n");
+	dev_set_drvdata(device, i2c);
 
-	/* reset hardware to sane state */
-	rpx_iic_init(&rpx_data);
+	i2c->adap = rpx_ops;
+	i2c_set_adapdata(&i2c->adap, i2c);
+	i2c->adap.dev.parent = &pdev->dev;
 
-	if (i2c_8xx_add_bus(&rpx_ops) < 0) {
+	if ((result = i2c_8xx_add_bus(&rpx_ops) < 0)) {
 		printk(KERN_ERR "i2c-rpx: Unable to register with I2C\n");
-		return -ENODEV;
+		kfree(i2c);
 	}
 
+	return result;
+}
+
+
+static int i2c_rpx_remove(struct device *device)
+{
+	struct m8xx_i2c *i2c = dev_get_drvdata(device);
+
+	i2c_8xx_del_bus(&i2c->adap);
+	dev_set_drvdata(device, NULL);
+
+	kfree(i2c);
 	return 0;
 }
 
-void __exit i2c_rpx_exit(void)
+
+/* Structure for a device driver */
+static struct device_driver i2c_rpx_driver = {
+	.name = "fsl-i2c-cpm",
+	.bus = &platform_bus_type,
+	.probe = i2c_rpx_probe,
+	.remove = i2c_rpx_remove,
+};
+
+static int __init i2c_rpx_init(void)
 {
-	i2c_8xx_del_bus(&rpx_ops);
+	return driver_register(&i2c_rpx_driver);
 }
 
-MODULE_AUTHOR("Dan Malek <dmalek@jlc.net>");
-MODULE_DESCRIPTION("I2C-Bus adapter routines for MPC8xx boards");
+static void __exit i2c_rpx_exit(void)
+{
+	driver_unregister(&i2c_rpx_driver);
+}
 
 module_init(i2c_rpx_init);
 module_exit(i2c_rpx_exit);
+
+MODULE_AUTHOR("Dan Malek <dmalek@jlc.net>");
+MODULE_DESCRIPTION("I2C-Bus adapter routines for MPC8xx boards");
diff --git a/include/linux/i2c-algo-8xx.h b/include/linux/i2c-algo-8xx.h
new file mode 100644
index 0000000..a644512
--- /dev/null
+++ b/include/linux/i2c-algo-8xx.h
@@ -0,0 +1,29 @@
+/* ------------------------------------------------------------------------- */
+/* i2c-algo-8xx.h i2c driver algorithms for MPX8XX CPM			     */
+/* ------------------------------------------------------------------------- */
+
+/* $Id$ */
+
+#ifndef I2C_ALGO_8XX_H
+#define I2C_ALGO_8XX_H
+
+#include <linux/i2c.h>
+#include <asm/8xx_immap.h>
+#include <asm/commproc.h>
+
+struct i2c_algo_8xx_data {
+	uint dp_addr;
+	int reloc;
+	int irq;
+	i2c8xx_t *i2c;
+	iic_t	*iip;
+	cpm8xx_t *cp;
+
+	u_char	temp[513];
+};
+
+extern int i2c_8xx_add_bus(struct i2c_adapter *);
+extern int i2c_8xx_del_bus(struct i2c_adapter *);
+
+#endif /* I2C_ALGO_8XX_H */
+


-- 
Sincerely, Vitaly

