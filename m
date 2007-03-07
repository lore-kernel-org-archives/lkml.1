Return-Path: <linux-kernel-owner+w=401wt.eu-S1422706AbXCGJxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422706AbXCGJxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422707AbXCGJxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:53:15 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:22535 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422706AbXCGJxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:53:13 -0500
X-IronPort-AV: i="4.14,258,1170651600"; 
   d="scan'208"; a="23777674:sNHT31665046"
Subject: Re: [PATCH -mm] Blackfin: blackfin i2c driver
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Cc: Bryan Wu <bryan.wu@analog.com>, Sonic Zhang <sonic.adi@gmail.com>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       mhfan@ustc.edu
In-Reply-To: <20070307075822.53e53c42.khali@linux-fr.org>
References: <1173164058.31825.16.camel@roc-desktop>
	 <20070306214301.GA5590@martell.zuzino.mipt.ru>
	 <1173247078.28531.24.camel@roc-desktop>
	 <20070307075822.53e53c42.khali@linux-fr.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 07 Mar 2007 17:53:17 +0800
Message-Id: <1173261197.28531.60.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
> > ---
> >  drivers/i2c/busses/Kconfig         |   47 ++++
> >  drivers/i2c/busses/i2c-bfin-gpio.c |   98 +++++++++
> >  drivers/i2c/busses/i2c-bfin-twi.c  |  589 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> 
> I'd prefer i2c-blackfin-gpio and i2c-blackfin-twi. Abreviations tend to
> confuse newcomers.
> 

There are tons of code using bfin abreviations for
functions/files/variables names. So we prefer to follow the name scheme.

> >  3 files changed, 734 insertions(+)
> > 
> > Index: linux-2.6/drivers/i2c/busses/Kconfig
> > ===================================================================
> > --- linux-2.6.orig/drivers/i2c/busses/Kconfig	2007-03-07 13:32:02.000000000 +0800
> > +++ linux-2.6/drivers/i2c/busses/Kconfig	2007-03-07 13:44:19.000000000 +0800
> > @@ -5,6 +5,53 @@
> >  menu "I2C Hardware Bus support"
> >  	depends on I2C
> >  
> > +config I2C_BFIN_GPIO
> 
> I2C_BLACKFIN_GPIO
> 

In the Kconfig, we are trying to using CONFIG_BLACKFIN. So, I changed
all the BFIN to BLACKFIN as you mentioned.

> Please move the entries to the right location. The list is sorted
> alphabetically if you didn't notice.
> 
> > +	tristate "Generic Blackfin and HHBF533/561 development board I2C support"
> 
> You can drop the trailing "I2C support", the user is in a menu named
> "I2C hardware bus support" so it's pretty clear what we're talking
> about.
> 
> > +	depends on I2C && EXPERIMENTAL
> > +	select I2C_ALGOBIT
> > +	help
> > +	--
> > +
> > +menu "BFIN I2C SDA/SCL Selection"
> > +	depends on I2C_BFIN_GPIO
> > +config BFIN_SDA
> 
> I2C_BLACKFIN_SDA
> 
> > +	int "SDA is GPIO Number"
> 
> "SDA GPIO pin number"
> 
> > +	range 0 15 if (BF533 || BF532 || BF531) 
> 
> Trailing whitespace.
> 
> > +	range 0 47 if (BF534 || BF536 || BF537)
> > +	range 0 47 if BF561
> > +	default 2 if (BF533 || BF532 || BF531) 
> 
> Trailing whitespace.
> 
> No default for the other cases?
> 
> > +
> > +config BFIN_SCL
> 
> I2C_BLACKFIN_SCL
> Etc etc, all the options should start with I2C_BLACKFIN.
> 
> > +	int "SCL is GPIO Number"
> 
> "SCL GPIO pin number"
> 
> > +	range 0 15 if (BF533 || BF532 || BF531) 
> 
> Trailing whitespace, and many more after that. Please fix them all!
> 

All above fixed.

> > +	range 0 47 if (BF534 || BF536 || BF537)
> > +	range 0 47 if BF561
> > +	default 3 
> > +endmenu
> > +
> > +config I2C_BFIN_GPIO_CYCLE_DELAY
> > +	int "Cycle Delay in usec"
> > +	depends on I2C_BFIN_GPIO
> > +	range 1 100 
> > +	default 40
> 
> This should really not be a kernel configuration option. Please turn it
> into a kernel module parameter or a sysfs attribute if you really need
> it. Also note that we already have an interface to change this
> value from user-space (using an ioctl on /dev/i2c-N) and that might be
> sufficient for your needs.
> 

Actually, for some customer's requirement, they just want to set the
configuration in kernel config time not in the runtime. 


> And allowing 1 usec delay is probably not a good idea, I don't
> recommend values below 6 usec with i2c-algo-bit.

I add a range here from 5 to 100, default is 40.

> > +
> > +config I2C_BFIN_TWI
> > +	tristate "Blackfin TWI I2C support"
> > +	depends on I2C && (BF534 || BF536 || BF537)
> > +	help
> > +	  This the TWI I2C device driver for Blackfin 534/536/537.
> > +
> > +	  This driver can also be built as a module.  If so, the module
> > +	  will be called i2c-bfin-twi.
> > +
> > +config TWICLK_KHZ
> > +	int "TWI clock (kHZ)"
> 
> kHz
> 
> > +	depends on I2C_BFIN_TWI
> > +	default 50
> > +	help
> > +	  The unit of the TWI clock is kilo HZ. Please divide the clock 
> > +	  by 1024 if you count it in HZ. The value should be less than 400.
> 
> Why don't you use "range" here too to ensure that the value is actually
> less than 400? Either way, same as above, IMHO this should not be a
> compilation-time decision.
> 
> A kHz is really 1000 Hz, not 1024. And everybody skilled enough to
> configure a kernel should know that, I doubt it's worth reminding.
> 

All above fixed.

> > +
> >  config I2C_ALI1535
> >  	tristate "ALI 1535"
> >  	depends on I2C && PCI
> 
> All these options won't work really well until you also change
> drivers/i2c/busses/Makefile to make something useful with them...
> 

Sorry for missing the Makefile in this patch. 

Thanks for your review and this is the latest one.

Andrew, I also fixed Kconfig bug in your
blackfin-blackfin-i2c-driver-fix.patch
Please add this one to -mm tree and remove old
one/update.patch/fix.patch from -mm tree.

[PATCH] Blackfin: blackfin i2c driver

The i2c linux driver for blackfin architecture which supports both GPIO
i2c operation and blackfin on-chip TWI controller i2c operation.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Jean Delvare <khali@linux-fr.org>
---

 drivers/i2c/busses/Kconfig         |   47 ++++
 drivers/i2c/busses/Makefile        |    2
 drivers/i2c/busses/i2c-bfin-gpio.c |  100 +++++++++
 drivers/i2c/busses/i2c-bfin-twi.c  |  589 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 738 insertions(+)

Index: linux-2.6/drivers/i2c/busses/Kconfig
===================================================================
--- linux-2.6.orig/drivers/i2c/busses/Kconfig	2007-03-07 17:18:49.000000000 +0800
+++ linux-2.6/drivers/i2c/busses/Kconfig	2007-03-07 17:23:05.000000000 +0800
@@ -91,6 +91,53 @@
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-au1550.
 
+config I2C_BLACKFIN_GPIO
+	tristate "Blackfin GPIO based I2C interface"
+	depends on I2C && BLACKFIN && EXPERIMENTAL
+	select I2C_ALGOBIT
+	help
+	  Say Y here if you have an Blackfin BF5xx based
+	  system and are using GPIO lines for an I2C bus.
+
+menu "Blackfin I2C SDA/SCL Selection"
+	depends on I2C_BLACKFIN_GPIO
+config I2C_BLACKFIN_GPIO_SDA
+	int "SDA GPIO pin number"
+	range 0 15 if (BF533 || BF532 || BF531)
+	range 0 47 if (BF534 || BF536 || BF537)
+	range 0 47 if BF561
+	default 2
+
+config I2C_BLACKFIN_GPIO_SCL
+	int "SCL GPIO pin number"
+	range 0 15 if (BF533 || BF532 || BF531)
+	range 0 47 if (BF534 || BF536 || BF537)
+	range 0 47 if BF561
+	default 3
+endmenu
+
+config I2C_BLACKFIN_GPIO_CYCLE_DELAY
+	int "Cycle Delay in uSec"
+	depends on I2C_BLACKFIN_GPIO
+	range 5 100
+	default 40
+
+config I2C_BLACKFIN_TWI
+	tristate "Blackfin TWI I2C support"
+	depends on I2C && (BF534 || BF536 || BF537)
+	help
+	  This is the TWI I2C device driver for Blackfin 534/536/537.
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-bfin-twi.
+
+config I2C_BLACKFIN_TWI_CLK_KHZ
+	int "Blackfin TWI I2C clock (kHz)"
+	depends on I2C_BLACKFIN_TWI
+	range 10 400
+	default 50
+	help
+	  The unit of the TWI clock is kilo HZ.
+
 config I2C_ELEKTOR
 	tristate "Elektor ISA card"
 	depends on I2C && ISA && BROKEN_ON_SMP
Index: linux-2.6/drivers/i2c/busses/i2c-bfin-gpio.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/i2c/busses/i2c-bfin-gpio.c	2007-03-07 17:32:30.000000000 +0800
@@ -0,0 +1,100 @@
+/****************************************************************
+ * Description:                                                 *
+ *                                                              *
+ * Maintainer: Meihui Fan <mhfan@ustc.edu>		        *
+ *                                                              *
+ * CopyRight (c)  2004  HHTech                                  *
+ *   www.hhcn.com, www.hhcn.org                                 *
+ *   All rights reserved.                                       *
+ *                                                              *
+ * This file is free software;                                  *
+ *   you are free to modify and/or redistribute it   	        *
+ *   under the terms of the GNU General Public Licence (GPL).   *
+ *                                                              *
+ ****************************************************************/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
+
+#include <asm/blackfin.h>
+#include <asm/gpio.h>
+
+#define	I2C_HW_B_HHBF		    0x13
+
+static void hhbf_setsda(void *data, int state)
+{
+	if (state) {
+		gpio_direction_input(CONFIG_I2C_BLACKFIN_GPIO_SDA);
+
+	} else {
+		gpio_direction_output(CONFIG_I2C_BLACKFIN_GPIO_SDA);
+		gpio_set_value(CONFIG_I2C_BLACKFIN_GPIO_SDA, 0);
+	}
+}
+
+static void hhbf_setscl(void *data, int state)
+{
+	gpio_set_value(CONFIG_I2C_BLACKFIN_GPIO_SCL, state);
+}
+
+static int hhbf_getsda(void *data)
+{
+	return (gpio_get_value(CONFIG_I2C_BLACKFIN_GPIO_SDA) != 0);
+}
+
+
+static struct i2c_algo_bit_data bit_hhbf_data = {
+	.setsda  = hhbf_setsda,
+	.setscl  = hhbf_setscl,
+	.getsda  = hhbf_getsda,
+	.udelay  = CONFIG_I2C_BLACKFIN_GPIO_CYCLE_DELAY,
+	.timeout = HZ
+};
+
+static struct i2c_adapter hhbf_ops = {
+	.owner 	= THIS_MODULE,
+	.id 	= I2C_HW_B_HHBF,
+	.algo_data 	= &bit_hhbf_data,
+	.name	= "Blackfin GPIO based I2C driver",
+};
+
+static int __init i2c_hhbf_init(void)
+{
+
+	if (gpio_request(CONFIG_I2C_BLACKFIN_GPIO_SCL, NULL)) {
+		printk(KERN_ERR "%s: gpio_request GPIO %d failed \n", __func__,
+				CONFIG_I2C_BLACKFIN_GPIO_SCL);
+		return -1;
+	}
+
+	if (gpio_request(CONFIG_I2C_BLACKFIN_GPIO_SDA, NULL)) {
+		printk(KERN_ERR "%s: gpio_request GPIO %d failed \n", __func__,
+				CONFIG_I2C_BLACKFIN_GPIO_SDA);
+		return -1;
+	}
+
+
+	gpio_direction_output(CONFIG_I2C_BLACKFIN_GPIO_SCL);
+	gpio_direction_input(CONFIG_I2C_BLACKFIN_GPIO_SDA);
+	gpio_set_value(CONFIG_I2C_BLACKFIN_GPIO_SCL, 1);
+
+	return i2c_bit_add_bus(&hhbf_ops);
+}
+
+static void __exit i2c_hhbf_exit(void)
+{
+	gpio_free(CONFIG_I2C_BLACKFIN_GPIO_SCL);
+	gpio_free(CONFIG_I2C_BLACKFIN_GPIO_SDA);
+	i2c_bit_del_bus(&hhbf_ops);
+}
+
+MODULE_AUTHOR("Meihui Fan <mhfan@ustc.edu>");
+MODULE_DESCRIPTION("I2C-Bus adapter routines for Blackfin and HHBF Boards");
+MODULE_LICENSE("GPL");
+
+module_init(i2c_hhbf_init);
+module_exit(i2c_hhbf_exit);
Index: linux-2.6/drivers/i2c/busses/i2c-bfin-twi.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/i2c/busses/i2c-bfin-twi.c	2007-03-07 17:28:57.000000000 +0800
@@ -0,0 +1,589 @@
+/****************************************************************
+ * Description: Driver for Blackfin Two Wire Interface          *
+ * Maintainer:  sonicz  <sonic.zhang@analog.com>                *
+ *                                                              *
+ * Copyright (c) 2005-2007 Analog Device                        *
+ *                                                              *
+ * This file is free software;                                  *
+ *   you are free to modify and/or redistribute it   	        *
+ *   under the terms of the GNU General Public Licence (GPL).   *
+ ****************************************************************/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/mm.h>
+#include <linux/timer.h>
+#include <linux/spinlock.h>
+#include <linux/completion.h>
+#include <linux/interrupt.h>
+
+#include <asm/blackfin.h>
+#include <asm/irq.h>
+
+#define I2C_BLACKFIN_TWI       0x00
+#define POLL_TIMEOUT       (2 * HZ)
+#ifndef CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ
+#define CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ  400
+#endif
+
+/* SMBus mode*/
+#define TWI_I2C_MODE_STANDARD		0x01
+#define TWI_I2C_MODE_STANDARDSUB	0x02
+#define TWI_I2C_MODE_COMBINED		0x04
+
+struct bfin_twi_iface
+{
+	struct mutex		twi_lock;
+	int			irq;
+	spinlock_t		lock;
+	char			read_write;
+	u8			command;
+	u8			*transPtr;
+	int			readNum;
+	int			writeNum;
+	int			cur_mode;
+	int			manual_stop;
+	int			result;
+	int			timeout_count;
+	struct timer_list	timeout_timer;
+	struct i2c_adapter	adap;
+	struct completion	complete;
+};
+
+static struct bfin_twi_iface twi_iface;
+
+static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
+{
+	unsigned short twi_int_status = bfin_read_TWI_INT_STAT();
+	unsigned short mast_stat = bfin_read_TWI_MASTER_STAT();
+
+	if (twi_int_status & XMTSERV) {
+		/* Transmit next data */
+		if (iface->writeNum > 0) {
+			bfin_write_TWI_XMT_DATA8(*(iface->transPtr++));
+			iface->writeNum--;
+		}
+		/* start receive immediately after complete sending in
+		 * combine mode.
+		 */
+		else if (iface->cur_mode == TWI_I2C_MODE_COMBINED) {
+			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
+				| MDIR | RSTART);
+		} else if (iface->manual_stop)
+			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
+				| STOP);
+		SSYNC();
+		/* Clear status */
+		bfin_write_TWI_INT_STAT(XMTSERV);
+		SSYNC();
+	}
+	if (twi_int_status & RCVSERV) {
+		if (iface->readNum > 0) {
+			/* Receive next data */
+			*(iface->transPtr) = bfin_read_TWI_RCV_DATA8();
+			if (iface->cur_mode == TWI_I2C_MODE_COMBINED) {
+				/* Change combine mode into sub mode after
+				 * read first data.
+				 */
+				iface->cur_mode = TWI_I2C_MODE_STANDARDSUB;
+				/* Get read number from first byte in block
+				 * combine mode.
+				 */
+				if (iface->readNum == 1 && iface->manual_stop)
+					iface->readNum = *iface->transPtr+1;
+			}
+			iface->transPtr++;
+			iface->readNum--;
+		} else if (iface->manual_stop) {
+			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
+				| STOP);
+			SSYNC();
+		}
+		/* Clear interrupt source */
+		bfin_write_TWI_INT_STAT(RCVSERV);
+		SSYNC();
+	}
+	if (twi_int_status & MERR) {
+		bfin_write_TWI_INT_STAT(MERR);
+		bfin_write_TWI_INT_MASK(0);
+		bfin_write_TWI_MASTER_STAT(0x3e);
+		bfin_write_TWI_MASTER_CTL(0);
+		SSYNC();
+		iface->result = -1;
+		/* if both err and complete int stats are set, return proper
+		 * results.
+		 */
+		if (twi_int_status & MCOMP) {
+			bfin_write_TWI_INT_STAT(MCOMP);
+			bfin_write_TWI_INT_MASK(0);
+			bfin_write_TWI_MASTER_CTL(0);
+			SSYNC();
+			/* If it is a quick transfer, only address bug no data,
+			 * not an err, return 1.
+			 */
+			if (iface->writeNum == 0 && (mast_stat & BUFRDERR))
+				iface->result = 1;
+			/* If address not acknowledged return -1,
+			 * else return 0.
+			 */
+			else if (!(mast_stat & ANAK))
+				iface->result = 0;
+		}
+		complete(&iface->complete);
+		return;
+	}
+	if (twi_int_status & MCOMP) {
+		bfin_write_TWI_INT_STAT(MCOMP);
+		SSYNC();
+		if (iface->cur_mode == TWI_I2C_MODE_COMBINED) {
+			if (iface->readNum == 0) {
+				/* set the read number to 1 and ask for manual
+				 * stop in block combine mode
+				 */
+				iface->readNum = 1;
+				iface->manual_stop = 1;
+				bfin_write_TWI_MASTER_CTL(
+					bfin_read_TWI_MASTER_CTL()
+					| (0xff << 6));
+			} else {
+				/* set the readd number in other
+				 * combine mode.
+				 */
+				bfin_write_TWI_MASTER_CTL(
+					(bfin_read_TWI_MASTER_CTL() &
+					(~(0xff << 6))) |
+					( iface->readNum << 6));
+			}
+			/* remove restart bit and enable master receive */
+			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() &
+				~RSTART);
+			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() |
+				MEN | MDIR);
+			SSYNC();
+		} else {
+			iface->result = 1;
+			bfin_write_TWI_INT_MASK(0);
+			bfin_write_TWI_MASTER_CTL(0);
+			SSYNC();
+			complete(&iface->complete);
+		}
+	}
+}
+
+/* Interrupt handler */
+static irqreturn_t bfin_twi_interrupt_entry(int irq, void *dev_id)
+{
+	struct bfin_twi_iface *iface = (struct bfin_twi_iface *)dev_id;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iface->lock, flags);
+	del_timer(&iface->timeout_timer);
+	bfin_twi_handle_interrupt(iface);
+	spin_unlock_irqrestore(&iface->lock, flags);
+	return IRQ_HANDLED;
+}
+
+static void bfin_twi_timeout(unsigned long data)
+{
+	struct bfin_twi_iface *iface = (struct bfin_twi_iface *)data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iface->lock, flags);
+	bfin_twi_handle_interrupt(iface);
+	if (iface->result == 0) {
+		iface->timeout_count--;
+		if (iface->timeout_count > 0) {
+			iface->timeout_timer.expires = jiffies + POLL_TIMEOUT;
+			add_timer(&iface->timeout_timer);
+		} else {
+			iface->result = -1;
+			complete(&iface->complete);
+		}
+	}
+	spin_unlock_irqrestore(&iface->lock, flags);
+}
+
+/*
+ * Generic i2c master transfer entrypoint
+ */
+static int bfin_twi_master_xfer(struct i2c_adapter *adap,
+				struct i2c_msg msgs[], int num)
+{
+	struct bfin_twi_iface* iface = adap->algo_data;
+	struct i2c_msg *pmsg;
+	int i, ret;
+	int rc = 0;
+
+	if (!(bfin_read_TWI_CONTROL() & TWI_ENA))
+		return -ENXIO;
+
+	mutex_lock(&iface->twi_lock);
+
+	while (bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
+		mutex_unlock(&iface->twi_lock);
+		cond_resched();
+		mutex_lock(&iface->twi_lock);
+	}
+
+	ret = 0;
+	for (i = 0; rc >= 0 && i < num; i++) {
+		pmsg = &msgs[i];
+		if (pmsg->flags & I2C_M_TEN) {
+			printk(KERN_ERR "i2c-bfin-twi: 10 bits addr \
+					not supported !\n");
+			rc = -EINVAL;
+			break;
+		}
+
+		iface->cur_mode = TWI_I2C_MODE_STANDARD;
+		iface->manual_stop = 0;
+		iface->transPtr = pmsg->buf;
+		iface->writeNum = iface->readNum = pmsg->len;
+		iface->result = 0;
+		iface->timeout_count = 10;
+		/* Set Transmit device address */
+		bfin_write_TWI_MASTER_ADDR(pmsg->addr);
+
+		/* FIFO Initiation. Data in FIFO should be
+		 *  discarded before start a new operation.
+		 */
+		bfin_write_TWI_FIFO_CTL(0x3);
+		SSYNC();
+		bfin_write_TWI_FIFO_CTL(0);
+		SSYNC();
+
+		if (pmsg->flags & I2C_M_RD)
+			iface->read_write = I2C_SMBUS_READ;
+		else {
+			iface->read_write = I2C_SMBUS_WRITE;
+			/* Transmit first data */
+			if (iface->writeNum > 0) {
+				bfin_write_TWI_XMT_DATA8(*(iface->transPtr++));
+				iface->writeNum--;
+				SSYNC();
+			}
+		}
+
+		/* clear int stat */
+		bfin_write_TWI_INT_STAT(MERR|MCOMP|XMTSERV|RCVSERV);
+
+		/* Interrupt mask . Enable XMT, RCV interrupt */
+		bfin_write_TWI_INT_MASK(MCOMP | MERR |
+			((iface->read_write == I2C_SMBUS_READ)?
+			RCVSERV : XMTSERV));
+		SSYNC();
+
+		if (pmsg->len > 0 && pmsg->len <= 255)
+			bfin_write_TWI_MASTER_CTL(pmsg->len << 6);
+		else if (pmsg->len > 255) {
+			bfin_write_TWI_MASTER_CTL(0xff << 6);
+			iface->manual_stop = 1;
+		} else
+			break;
+
+		iface->timeout_timer.expires = jiffies + POLL_TIMEOUT;
+		add_timer(&iface->timeout_timer);
+
+		/* Master enable */
+		bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() | MEN |
+			((iface->read_write == I2C_SMBUS_READ) ? MDIR : 0) |
+			((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ>100) ? FAST : 0));
+		SSYNC();
+
+		wait_for_completion(&iface->complete);
+
+		rc = iface->result;
+		if (rc == 1)
+			ret++;
+		else if (rc == -1)
+			break;
+	}
+
+	/* Release mutex */
+	mutex_unlock(&iface->twi_lock);
+
+	return ret;
+}
+
+/*
+ * SMBus type transfer entrypoint
+ */
+
+int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
+			unsigned short flags, char read_write,
+			u8 command, int size, union i2c_smbus_data * data)
+{
+	struct bfin_twi_iface* iface = adap->algo_data;
+	int rc = 0;
+
+	if (!(bfin_read_TWI_CONTROL() & TWI_ENA))
+		return -ENXIO;
+
+	mutex_lock(&iface->twi_lock);
+
+	while(bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
+		mutex_unlock(&iface->twi_lock);
+		cond_resched();
+		mutex_lock(&iface->twi_lock);
+	}
+
+	iface->writeNum = 0;
+	iface->readNum = 0;
+
+	/* Prepare datas & select mode */
+	switch (size) {
+	case I2C_SMBUS_QUICK:
+		iface->transPtr = NULL;
+		iface->cur_mode = TWI_I2C_MODE_STANDARD;
+		break;
+	case I2C_SMBUS_BYTE:
+		if (data == NULL)
+			iface->transPtr = NULL;
+		else {
+			if (read_write == I2C_SMBUS_READ)
+				iface->readNum = 1;
+			else
+				iface->writeNum = 1;
+			iface->transPtr = &data->byte;
+		}
+		iface->cur_mode = TWI_I2C_MODE_STANDARD;
+		break;
+	case I2C_SMBUS_BYTE_DATA:
+		if (read_write == I2C_SMBUS_READ) {
+			iface->readNum = 1;
+			iface->cur_mode = TWI_I2C_MODE_COMBINED;
+		} else {
+			iface->writeNum = 1;
+			iface->cur_mode = TWI_I2C_MODE_STANDARDSUB;
+		}
+		iface->transPtr = &data->byte;
+		break;
+	case I2C_SMBUS_WORD_DATA:
+		if (read_write == I2C_SMBUS_READ) {
+			iface->readNum = 2;
+			iface->cur_mode = TWI_I2C_MODE_COMBINED;
+		} else {
+			iface->writeNum = 2;
+			iface->cur_mode = TWI_I2C_MODE_STANDARDSUB;
+		}
+		iface->transPtr = (u8 *)&data->word;
+		break;
+	case I2C_SMBUS_PROC_CALL:
+		iface->writeNum = 2;
+		iface->readNum = 2;
+		iface->cur_mode = TWI_I2C_MODE_COMBINED;
+		iface->transPtr = (u8 *)&data->word;
+		break;
+	case I2C_SMBUS_BLOCK_DATA:
+		if (read_write == I2C_SMBUS_READ) {
+			iface->readNum = 0;
+			iface->cur_mode = TWI_I2C_MODE_COMBINED;
+		} else {
+			iface->writeNum = data->block[0]+1;
+			iface->cur_mode = TWI_I2C_MODE_STANDARDSUB;
+		}
+		iface->transPtr = data->block;
+		break;
+	default:
+		return -1;
+	}
+
+	iface->result = 0;
+	iface->manual_stop = 0;
+	iface->read_write = read_write;
+	iface->command = command;
+	iface->timeout_count = 10;
+
+	/* FIFO Initiation. Data in FIFO should be discarded before
+	 * start a new operation.
+	 */
+	bfin_write_TWI_FIFO_CTL(0x3);
+	SSYNC();
+	bfin_write_TWI_FIFO_CTL(0);
+
+	/* clear int stat */
+	bfin_write_TWI_INT_STAT(MERR|MCOMP|XMTSERV|RCVSERV);
+
+	/* Set Transmit device address */
+	bfin_write_TWI_MASTER_ADDR(addr);
+	SSYNC();
+
+	iface->timeout_timer.expires = jiffies + POLL_TIMEOUT;
+	add_timer(&iface->timeout_timer);
+
+	switch (iface->cur_mode) {
+	case TWI_I2C_MODE_STANDARDSUB:
+		bfin_write_TWI_XMT_DATA8(iface->command);
+		bfin_write_TWI_INT_MASK(MCOMP | MERR |
+			((iface->read_write == I2C_SMBUS_READ) ?
+			RCVSERV : XMTSERV));
+		SSYNC();
+
+		if (iface->writeNum + 1 <= 255)
+			bfin_write_TWI_MASTER_CTL((iface->writeNum+1) << 6);
+		else {
+			bfin_write_TWI_MASTER_CTL(0xff << 6);
+			iface->manual_stop = 1;
+		}
+		/* Master enable */
+		bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() | MEN |
+			((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ>100) ? FAST : 0));
+		break;
+	case TWI_I2C_MODE_COMBINED:
+		bfin_write_TWI_XMT_DATA8(iface->command);
+		bfin_write_TWI_INT_MASK(MCOMP | MERR | RCVSERV | XMTSERV);
+		SSYNC();
+
+		if (iface->writeNum > 0)
+			bfin_write_TWI_MASTER_CTL((iface->writeNum+1) << 6);
+		else
+			bfin_write_TWI_MASTER_CTL(0x1 << 6);
+		/* Master enable */
+		bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() | MEN |
+			((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ>100) ? FAST : 0));
+		break;
+	default:
+		bfin_write_TWI_MASTER_CTL(0);
+		if (size != I2C_SMBUS_QUICK) {
+			/* Don't access xmit data register when this is a
+			 * read operation.
+			 */
+			if (iface->read_write != I2C_SMBUS_READ) {
+				if (iface->writeNum > 0) {
+					bfin_write_TWI_XMT_DATA8
+						(*(iface->transPtr++));
+					if (iface->writeNum <= 255)
+						bfin_write_TWI_MASTER_CTL
+							(iface->writeNum << 6);
+					else {
+						bfin_write_TWI_MASTER_CTL
+							(0xff << 6);
+						iface->manual_stop = 1;
+					}
+					iface->writeNum--;
+				} else {
+					bfin_write_TWI_XMT_DATA8
+						(iface->command);
+					bfin_write_TWI_MASTER_CTL(1 << 6);
+				}
+			} else {
+				if (iface->readNum > 0
+					&& iface->readNum <= 255)
+					bfin_write_TWI_MASTER_CTL
+						(iface->readNum << 6);
+				else if (iface->readNum > 255) {
+					bfin_write_TWI_MASTER_CTL( 0xff << 6 );
+					iface->manual_stop = 1;
+				} else {
+					del_timer(&iface->timeout_timer);
+					break;
+				}
+			}
+		}
+		bfin_write_TWI_INT_MASK(MCOMP | MERR |
+			((iface->read_write == I2C_SMBUS_READ) ?
+			RCVSERV : XMTSERV));
+		SSYNC();
+
+		/* Master enable */
+		bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() | MEN |
+			((iface->read_write == I2C_SMBUS_READ) ? MDIR : 0) |
+			((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ > 100) ? FAST : 0));
+		break;
+	}
+	SSYNC();
+
+	wait_for_completion(&iface->complete);
+
+	rc = (iface->result >= 0) ? 0 : -1;
+
+	/* Release mutex */
+	mutex_unlock(&iface->twi_lock);
+
+	return rc;
+}
+
+/*
+ * Return what the adapter supports
+ */
+static u32 bfin_twi_functionality(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
+	       I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
+	       I2C_FUNC_SMBUS_BLOCK_DATA | I2C_FUNC_SMBUS_PROC_CALL |
+	       I2C_FUNC_I2C;
+}
+
+
+static struct i2c_algorithm bfin_twi_algorithm = {
+	.master_xfer   = bfin_twi_master_xfer,
+	.smbus_xfer    = bfin_twi_smbus_xfer,
+	.functionality = bfin_twi_functionality,
+};
+
+static int __init i2c_bfin_twi_init(void)
+{
+	struct i2c_adapter *p_adap;
+	int rc;
+
+	mutex_init(&(twi_iface.twi_lock));
+	spin_lock_init(&twi_iface.lock);
+	init_completion(&twi_iface.complete);
+	twi_iface.irq = IRQ_TWI;
+
+	init_timer(&twi_iface.timeout_timer);
+	twi_iface.timeout_timer.function = bfin_twi_timeout;
+	twi_iface.timeout_timer.data = (unsigned long)&twi_iface;
+
+	p_adap = &twi_iface.adap;
+	p_adap->id = I2C_BLACKFIN_TWI;
+	strcpy(p_adap->name, "i2c-bfin-twi");
+	p_adap->algo = &bfin_twi_algorithm;
+	p_adap->algo_data = &twi_iface;
+	p_adap->client_register = NULL;
+	p_adap->client_unregister = NULL;
+	p_adap->class = I2C_CLASS_ALL;
+
+	rc = request_irq(twi_iface.irq, bfin_twi_interrupt_entry,
+		SA_INTERRUPT, "i2c-bfin-twi", &twi_iface);
+	if (rc) {
+		printk(KERN_ERR "i2c-bfin-twi: can't get IRQ %d !\n",
+			twi_iface.irq);
+		return -ENODEV;
+	}
+
+	/* Set TWI internal clock as 10MHz */
+	bfin_write_TWI_CONTROL(((get_sclk() / 1024 / 1024 + 5) / 10) & 0x7F);
+
+	/* Set Twi interface clock as specified */
+	if (CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ > 400)
+		bfin_write_TWI_CLKDIV((( 5*1024 / 400 ) << 8) |
+			(( 5*1024 / 400 ) & 0xFF));
+	else
+		bfin_write_TWI_CLKDIV((( 5*1024 / CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ ) << 8) |
+			(( 5*1024 / CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ ) & 0xFF));
+
+	/* Enable TWI */
+	bfin_write_TWI_CONTROL(bfin_read_TWI_CONTROL() | TWI_ENA);
+	SSYNC();
+
+	rc = i2c_add_adapter(p_adap);
+	if(rc < 0)
+		free_irq(twi_iface.irq, &twi_iface);
+	return rc;
+}
+
+static void __exit i2c_bfin_twi_exit(void)
+{
+	i2c_del_adapter(&twi_iface.adap);
+	free_irq(twi_iface.irq, &twi_iface);
+}
+
+MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
+MODULE_DESCRIPTION("I2C-Bus adapter routines for Blackfin TWI");
+MODULE_LICENSE("GPL");
+
+module_init(i2c_bfin_twi_init);
+module_exit(i2c_bfin_twi_exit);
Index: linux-2.6/drivers/i2c/busses/Makefile
===================================================================
--- linux-2.6.orig/drivers/i2c/busses/Makefile	2007-03-07 17:18:49.000000000 +0800
+++ linux-2.6/drivers/i2c/busses/Makefile	2007-03-07 17:30:11.000000000 +0800
@@ -10,6 +10,8 @@
 obj-$(CONFIG_I2C_AMD8111)	+= i2c-amd8111.o
 obj-$(CONFIG_I2C_AT91)		+= i2c-at91.o
 obj-$(CONFIG_I2C_AU1550)	+= i2c-au1550.o
+obj-$(CONFIG_I2C_BLACKFIN_GPIO) += i2c-bfin-gpio.o
+obj-$(CONFIG_I2C_BLACKFIN_TWI)  += i2c-bfin-twi.o
 obj-$(CONFIG_I2C_ELEKTOR)	+= i2c-elektor.o
 obj-$(CONFIG_I2C_HYDRA)		+= i2c-hydra.o
 obj-$(CONFIG_I2C_I801)		+= i2c-i801.o
_

Thanks again
Best Regards,
-Bryan Wu
