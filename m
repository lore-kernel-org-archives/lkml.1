Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbXCHUTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbXCHUTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXCHUTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:19:09 -0500
Received: from father.pmc-sierra.com ([216.241.224.13]:63904 "HELO
	father.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752648AbXCHUTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:19:06 -0500
From: Marc St-Jean <stjeanma@pmc-sierra.com>
Date: Thu, 8 Mar 2007 14:18:40 -0600
Message-Id: <200703082018.l28KIeqt017408@pasqua.pmc-sierra.bc.ca>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: PMC MSP71xx GPIO char driver
Cc: linux-mips@linux-mips.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] drivers: PMC MSP71xx GPIO char driver

Patch to add a GPIO char driver for the PMC-Sierra
MSP71xx devices.

This patch references some platform support files previously
submitted to the linux-mips@linux-mips.org list.

Thanks,
Marc

Signed-off-by: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
---
Re-posting patch with recommended changes:
-Cleanup on style and formatting for comments, macros, etc.
-Moved some driver private data structures from .h to .c.
-Eliminated MSP_GPIO_BIT macro.
-Added call to new read_reg32 function to eliminate need
for use of volatile keyword.
-Made use of schedule_timeout_interruptible() call instead
of multiple calls.
-Added calls to kthread_should_stop and try_to_freeze().

 drivers/char/Kconfig                           |    4 
 drivers/char/Makefile                          |    1 
 drivers/char/pmcmsp_gpio.c                     |  644 +++++++++++++++++++++++++
 include/asm-mips/pmc-sierra/msp71xx/msp_gpio.h |   98 +++
 4 files changed, 747 insertions(+)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index ed5453f..dea96a0 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -372,6 +372,10 @@ config ISTALLION
 	  To compile this driver as a module, choose M here: the
 	  module will be called istallion.
 
+config PMCMSP_GPIO
+	tristate "PMC MSP 7120 GPIO device support"
+	depends on MIPS && (PMC_MSP7120_EVAL || PMC_MSP7120_GW || PMC_MSP7120_FPGA)
+	  
 config AU1X00_GPIO
 	tristate "Alchemy Au1000 GPIO device support"
 	depends on MIPS && SOC_AU1X00
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 3ed7647..9abbcc1 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_DS1620)		+= ds1620.o
 obj-$(CONFIG_HW_RANDOM)		+= hw_random/
 obj-$(CONFIG_COBALT_LCD)	+= lcd.o
 obj-$(CONFIG_AU1000_GPIO)	+= au1000_gpio.o
+obj-$(CONFIG_PMCMSP_GPIO)	+= pmcmsp_gpio.o
 obj-$(CONFIG_PPDEV)		+= ppdev.o
 obj-$(CONFIG_NWBUTTON)		+= nwbutton.o
 obj-$(CONFIG_NWFLASH)		+= nwflash.o
diff --git a/drivers/char/pmcmsp_gpio.c b/drivers/char/pmcmsp_gpio.c
new file mode 100644
index 0000000..e2d65bd
--- /dev/null
+++ b/drivers/char/pmcmsp_gpio.c
@@ -0,0 +1,644 @@
+/*
+ * Driver for the PMC MSP7120 reference board GPIO pins
+ *
+ * Copyright 2005-2007 PMC-Sierra, Inc.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/ioport.h>
+#include <linux/spinlock.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/completion.h>
+
+#include <asm/io.h>
+#include <asm/war.h>
+#include <asm/regops.h>
+
+#include <msp_regs.h>
+#include <msp_gpio.h>
+
+/* -- Private definitions -- */
+
+/* Special bitflags and whatnot for the driver's convenience */
+#define GPIO_REG_COUNT		4
+const u32 GPIO_DATA_COUNT[] = { 2, 4, 4, 6 };
+const u32 GPIO_DATA_SHIFT[] = { 0, 2, 6, 10 };
+const u32 GPIO_DATA_MASK[] = { 0x03, 0x0f, 0x0f, 0x3f };
+u32 * const GPIO_DATA_REG[] = {
+	(u32 *)GPIO_DATA1_REG, (u32 *)GPIO_DATA2_REG,
+	(u32 *)GPIO_DATA3_REG, (u32 *)GPIO_DATA4_REG,
+};
+const u32 GPIO_CFG_MASK[] = { 0x0000ff, 0x00ffff, 0x00ffff, 0xffffff };
+u32 * const GPIO_CFG_REG[] = {
+	(u32 *)GPIO_CFG1_REG, (u32 *)GPIO_CFG2_REG,
+	(u32 *)GPIO_CFG3_REG, (u32 *)GPIO_CFG4_REG,
+};
+
+#define GPIO_CFG_SHIFT(i)	(i * 4)
+#define GPIO_CFG_PINMASK	0xf
+
+/* The extended gpio register */
+
+#define EXTENDED_GPIO_COUNT	4
+#define EXTENDED_GPIO_SHIFT	16
+#define EXTENDED_GPIO_MASK	0x0f
+
+#define EXTENDED_GPIO_DATA_SHIFT(i)	(i * 2)
+#define EXTENDED_GPIO_DATA_MASK(i)	(0x3 << (i*2))
+#define EXTENDED_GPIO_DATA_SET		0x2
+#define EXTENDED_GPIO_DATA_CLR		0x1
+#define EXTENDED_GPIO_CFG_SHIFT(i)	((i * 2) + 16)
+#define EXTENDED_GPIO_CFG_MASK(i)	(0x3 << ((i*2)+16))
+#define EXTENDED_GPIO_CFG_DISABLE	0x2
+#define EXTENDED_GPIO_CFG_ENABLE	0x1
+
+/* -- Data structures -- */
+
+static DEFINE_SPINLOCK(msp_gpio_spinlock);
+
+static struct task_struct *msp_blinkthread;
+static DEFINE_SPINLOCK(msp_blink_lock);
+static DECLARE_COMPLETION(msp_blink_wait);
+
+struct blink_table {
+	u32 count;
+	u32 period;
+	u32 dcycle;
+};
+
+static struct blink_table blink_table[MSP_NUM_GPIOS];
+
+/* -- Utility functions -- */
+
+/* Define the following for extra debug output */
+#undef DEBUG
+
+#ifdef DEBUG
+#define DBG(args...) printk(args)
+#else
+#define DBG(args...) do {} while (0)
+#endif
+
+/* Reads the data bits from a single register set */
+static u32 msp_gpio_read_data_basic(int reg)
+{
+	return read_reg32(GPIO_DATA_REG[reg], GPIO_DATA_MASK[reg]);
+}
+
+/* Reads the data bits from the extended register set */
+static u32 msp_gpio_read_data_extended(void)
+{
+	int pin;
+	u32 tmp = *EXTENDED_GPIO_REG;
+	u32 retval = 0;
+	
+	for (pin = 0; pin < EXTENDED_GPIO_COUNT; pin++) {
+		u32 bit = 0;
+		
+		/*
+		 * In output mode, read CLR bit
+		 * In input mode, read SET bit
+		 */
+		if (tmp & (EXTENDED_GPIO_CFG_ENABLE <<
+				EXTENDED_GPIO_CFG_SHIFT(pin)))
+			bit = EXTENDED_GPIO_DATA_CLR <<
+				EXTENDED_GPIO_DATA_SHIFT(pin);
+		else
+			bit = EXTENDED_GPIO_DATA_SET <<
+				EXTENDED_GPIO_DATA_SHIFT(pin);
+
+		if (tmp & bit)
+			retval |= 1 << pin;
+	}
+	
+	return retval;
+}
+
+/*
+ * Reads the current state of all 20 pins, putting the values in
+ * the lowest 20 bits (1=HI, 0=LO)
+ */
+static u32 msp_gpio_read_data(void)
+{
+	int reg;
+	u32 retval = 0;
+	
+	spin_lock(&msp_gpio_spinlock);
+	for (reg = 0; reg < GPIO_REG_COUNT; reg++)
+		retval |= msp_gpio_read_data_basic(reg) <<
+				GPIO_DATA_SHIFT[reg];
+	retval |= msp_gpio_read_data_extended() << EXTENDED_GPIO_SHIFT;
+	spin_unlock(&msp_gpio_spinlock);
+	
+	DBG("%s: 0x%08x\n", __FUNCTION__, retval);
+	return retval;
+}
+
+/*
+ * This assumes both data and mask are register-ready, and does
+ * the set atomically
+ */
+static void msp_gpio_write_data_basic(int reg, u32 data, u32 mask)
+{
+	set_value_reg32(GPIO_DATA_REG[reg], mask, data);
+}
+
+/*
+ * The four lowest bits of 'data' and 'mask' are used, and the set
+ * is done atomically
+ */
+static void msp_gpio_write_data_extended(u32 data, u32 mask)
+{
+	int i;
+	u32 tmpmask = 0xffffffff, tmpdata = 0;
+
+	/* Set all SET/CLR values based on data bits passed in */
+	for (i = 0; i < EXTENDED_GPIO_COUNT; i++) {
+		if (mask & (1 << i)) {
+			if (data & (1 << i))
+				/* Set the bit HI */
+				tmpdata |= EXTENDED_GPIO_DATA_SET <<
+					   EXTENDED_GPIO_DATA_SHIFT(i);
+			else
+				/* Set the bit LO */
+				tmpdata |= EXTENDED_GPIO_DATA_CLR <<
+					   EXTENDED_GPIO_DATA_SHIFT(i);
+		}
+	}
+	
+	set_value_reg32(EXTENDED_GPIO_REG, tmpmask, tmpdata);
+}
+
+/*
+ * Sets all masked GPIOs based on the first 20 bits of the data
+ * passed in (1=HI, 0=LO)
+ */
+static void msp_gpio_write_data(u32 data, u32 mask)
+{
+	int reg;
+	
+	spin_lock(&msp_gpio_spinlock);
+	for (reg = 0; reg < GPIO_REG_COUNT; reg++) {
+		u32 tmpdata = (data >> GPIO_DATA_SHIFT[reg]) &
+					GPIO_DATA_MASK[reg];
+		u32 tmpmask = (mask >> GPIO_DATA_SHIFT[reg]) &
+					GPIO_DATA_MASK[reg];
+		if (tmpmask > 0)
+			msp_gpio_write_data_basic(reg, tmpdata, tmpmask);
+	}
+	msp_gpio_write_data_extended(data >> EXTENDED_GPIO_SHIFT,
+					mask >> EXTENDED_GPIO_SHIFT);
+	spin_unlock(&msp_gpio_spinlock);
+}
+
+/* Reads the config bits from a single register set */
+static u32 msp_gpio_read_cfg_basic(int reg)
+{
+	return read_reg32(GPIO_CFG_REG[reg], GPIO_CFG_MASK[reg]);
+}
+
+/*
+ * This assumes both data and mask are register-ready, and does
+ * the write atomically
+ */
+static void msp_gpio_write_cfg_basic(int reg, u32 data, u32 mask)
+{
+	set_value_reg32(GPIO_CFG_REG[reg], mask, data);
+}
+
+/*
+ * Reads the configuration of the extended pins, returning the current
+ * configuration in the lowest 4 bits (1-output, 0-input)
+ */
+static u32 msp_gpio_read_cfg_extended(void)
+{
+	int i;
+	u32 tmp = *EXTENDED_GPIO_REG;
+	u32 retval = 0;
+
+	/* Read all ENABLE/DISABLE values and translate to single bits */
+	for (i = 0; i < EXTENDED_GPIO_COUNT; i++) {
+		if (tmp & (EXTENDED_GPIO_CFG_ENABLE <<
+				EXTENDED_GPIO_CFG_SHIFT(i)))
+			/* Pin is OUTPUT */
+			retval |= 1 << i;
+		else
+			/* Pin is INPUT */
+			retval &= ~(1 << i);
+	}
+	
+	return retval;
+}
+
+/*
+ * Sets the masked extended pins to (1-output, 0-input)
+ * (uses 4 lowest bits of the mask)
+ * Does the write atomically
+ */
+static void msp_gpio_write_cfg_extended(u32 data, u32 mask)
+{
+	int i;
+	u32 tmpmask = 0xffffffff, tmpdata = 0;
+
+	/* Set all ENABLE/DISABLE values based on mask bits passed in */
+	for (i = 0; i < EXTENDED_GPIO_COUNT; i++) {
+		if (mask & (1 << i)) {
+			if (data & (1 << i))
+				/* Set the pin to OUTPUT */
+				tmpdata |= EXTENDED_GPIO_CFG_ENABLE <<
+					   EXTENDED_GPIO_CFG_SHIFT(i);
+			else
+				/* Set the pin to INPUT */
+				tmpdata |= EXTENDED_GPIO_CFG_DISABLE <<
+					   EXTENDED_GPIO_CFG_SHIFT(i);
+		}
+	}
+	
+	set_value_reg32(EXTENDED_GPIO_REG, tmpmask, tmpdata);
+}
+
+/*
+ * Sets all GPIOs to input/output based on the first 20 bits of the mask
+ * (1-output, 0-input)
+ */
+static void msp_gpio_write_cfg(msp_gpio_mode_t mode, u32 mask)
+{
+	int reg;
+	u32 extdata = 0, extmask = 0;
+	
+	spin_lock(&msp_gpio_spinlock);
+	for (reg = 0; reg < GPIO_REG_COUNT; reg++) {
+		int pin;
+		u32 tmpdata = 0, tmpmask = 0;
+		for (pin = 0; pin < GPIO_DATA_COUNT[reg]; pin++) {
+			if (mask & (1 << (GPIO_DATA_SHIFT[reg] + pin))) {
+				tmpmask |= GPIO_CFG_PINMASK <<
+					   GPIO_CFG_SHIFT(pin);
+				tmpdata |= (u32)mode <<
+					   GPIO_CFG_SHIFT(pin);
+			}
+		}
+		if (tmpmask)
+			msp_gpio_write_cfg_basic(reg, tmpdata, tmpmask);
+	}
+
+	extmask = mask >> EXTENDED_GPIO_SHIFT;
+	if (mode == MSP_GPIO_INPUT)
+		extdata = 0;
+	else if (mode == MSP_GPIO_OUTPUT)
+		extdata = 0xf;
+	else
+		extmask = 0;
+	if (extmask)
+		msp_gpio_write_cfg_extended(extdata, extmask);
+	spin_unlock(&msp_gpio_spinlock);
+}
+
+/*
+ * Reads all GPIO config values and checks if they match the pin mode given,
+ * placing the result in the lowest 20 bits of the result, one bit per pin
+ * (1-pin matches mode give, 0-pin does not match)
+ */
+static u32 msp_gpio_read_cfg(u32 mode)
+{
+	u32 retval = 0;
+	int reg;
+	
+	spin_lock(&msp_gpio_spinlock);
+	for (reg = 0; reg < GPIO_REG_COUNT; reg++) {
+		int pin;
+		u32 tmpdata = msp_gpio_read_cfg_basic(reg);
+		for (pin = 0; pin < GPIO_DATA_COUNT[reg]; pin++) {
+			u32 val = (tmpdata >> GPIO_CFG_SHIFT(pin)) &
+					GPIO_CFG_PINMASK;
+			if (val == mode)
+				retval |= 1 << (GPIO_DATA_SHIFT[reg] + pin);
+		}
+	}
+	
+	/* Extended pins only have INPUT or OUTPUT pins */
+	if (mode == MSP_GPIO_INPUT)
+		retval |= (~msp_gpio_read_cfg_extended() & EXTENDED_GPIO_MASK)
+			  << EXTENDED_GPIO_SHIFT;
+	else if (mode == MSP_GPIO_OUTPUT)
+		retval |= (msp_gpio_read_cfg_extended() & EXTENDED_GPIO_MASK)
+			  << EXTENDED_GPIO_SHIFT;
+	spin_unlock(&msp_gpio_spinlock);
+	
+	DBG("%s(0x%02x): 0x%08x\n", __FUNCTION__, mode, retval);
+	return retval;
+}
+
+/* -- Public functions -- */
+
+/*
+ * Reads the bits specified by the mask and puts the values in data.
+ * May include output statuses also, if in mask.
+ *
+ * Returns 0 on success
+ */
+int msp_gpio_in(u32 *data, u32 mask)
+{
+	*data = msp_gpio_read_data() & mask;
+	
+	return 0;
+}
+
+/*
+ * Sets the specified data on the masked pins
+ *
+ * Returns 0 on success or one of the following:
+ *  -EINVAL if any of the pins in the mask are not free or not already
+ *  in output mode
+ */
+int msp_gpio_out(u32 data, u32 mask)
+{
+	if ((mask & ~MSP_GPIO_FREE_MASK) != 0) {
+		printk(KERN_WARNING
+			"Invalid GPIO mask - References non-free pins\n");
+		return -EINVAL;
+	}
+	if ((mask & ~msp_gpio_read_cfg(MSP_GPIO_OUTPUT)) != 0) {
+		printk(KERN_WARNING
+			"Invalid GPIO mask - Cannot set non-output pins\n");
+		return -EINVAL;
+	}
+	
+	msp_gpio_noblink(mask);
+	msp_gpio_write_data(data, mask);
+
+	return 0;
+}
+
+/*
+ * Sets masked pins to the specified msp_gpio_mode_t
+ *
+ * Returns 0 on success or one of the following:
+ *  -EINVAL if any of the pins in the mask are not free or if any pins
+ *  are not allowed to be set to the specified mode
+ */
+int msp_gpio_mode(msp_gpio_mode_t mode, u32 mask)
+{
+	u32 allowedmask;
+
+	if ((mask & ~MSP_GPIO_FREE_MASK) != 0) {
+		printk(KERN_WARNING
+			"Invalid GPIO mask - References non-free pins\n");
+		return -EINVAL;
+	}
+	
+	/* Enforce pin-mode rules */
+	allowedmask = MSP_GPIO_MODE_ALLOWED[mode];
+	if ((mask & ~allowedmask) != 0) {
+		printk(KERN_WARNING
+			"Invalid GPIO mode for masked pins\n");
+		return -EINVAL;
+	}
+
+	msp_gpio_noblink(mask);
+	msp_gpio_write_cfg(mode, mask);
+
+	return 0;
+}
+
+/*
+ * Stops the specified GPIOs from blinking
+ */
+int msp_gpio_noblink(u32 mask)
+{
+	int i;
+
+	if ((mask & ~msp_gpio_read_cfg(MSP_GPIO_OUTPUT)) != 0)
+		return -EINVAL;
+
+	spin_lock(&msp_blink_lock);
+	for (i = 0; i < MSP_NUM_GPIOS; i++) {
+		if (mask & (1 << i)) {
+			blink_table[i].count = 0;
+			blink_table[i].period = 0;
+			blink_table[i].dcycle = 0;
+		}
+	}
+	spin_unlock(&msp_blink_lock);
+
+	msp_gpio_write_data(0, mask);
+
+	return 0;
+}
+
+/*
+ * Configures GPIO(s) to blink
+ *  - mask shows which GPIOs to blink
+ *  - period is the time in 100ths of a second for the total period
+ *    (0 disables blinking)
+ *  - dcycle is the percentage of the period where the GPIO is HI
+ */
+int msp_gpio_blink(u32 mask, u32 period, u32 dcycle)
+{
+	int i;
+
+	if ((mask & ~msp_gpio_read_cfg(MSP_GPIO_OUTPUT)) != 0) {
+		printk(KERN_WARNING
+			"Invalid GPIO mask - Cannot blink non-output pins\n");
+		return -EINVAL;
+	}
+
+	if (period == 0) 
+		return msp_gpio_noblink(mask);
+
+	spin_lock(&msp_blink_lock);
+	for (i = 0; i < MSP_NUM_GPIOS; i++) {
+		if (mask & (1 << i)) {
+			blink_table[i].count = 0;
+			blink_table[i].period = period;
+			blink_table[i].dcycle = dcycle;
+		}
+	}
+	spin_unlock(&msp_blink_lock);
+
+	complete(&msp_blink_wait);
+
+	return 0;
+}
+
+/* -- File functions -- */
+
+static int msp_gpio_open(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static int msp_gpio_release(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static int msp_gpio_ioctl(struct inode *inode, struct file *file,
+			  unsigned int cmd, unsigned long arg)
+{
+	static struct msp_gpio_ioctl_io_data data;
+	static struct msp_gpio_ioctl_blink_data blink;
+
+	switch (cmd) {
+	case MSP_GPIO_BLINK:
+		if (copy_from_user(&blink,
+		    (struct msp_gpio_ioctl_blink_data *)arg, sizeof(blink)))
+			return -EFAULT;
+		break;
+	default:
+		if (copy_from_user(&data,
+		    (struct msp_gpio_ioctl_io_data *)arg, sizeof(data)))
+			return -EFAULT;
+		break;
+	}
+
+	switch (cmd) {
+	case MSP_GPIO_IN:
+		if (msp_gpio_in(&data.data, data.mask))
+			return -EFAULT;
+		if (copy_to_user((struct msp_gpio_ioctl_io_data *)arg,
+		    &data, sizeof(data)))
+			return -EFAULT;
+		break;
+	case MSP_GPIO_OUT:
+		if (msp_gpio_out(data.data, data.mask))
+			return -EFAULT;
+		break;
+	case MSP_GPIO_MODE:
+		if (msp_gpio_mode( data.data, data.mask))
+			return -EFAULT;
+		break;
+	case MSP_GPIO_BLINK:
+		if (msp_gpio_blink(blink.mask, blink.period, blink.dcycle))
+			return -EFAULT;
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+	
+	return 0;
+}
+
+static struct file_operations msp_gpio_fops = {
+	.owner		= THIS_MODULE,
+	.ioctl		= msp_gpio_ioctl,
+	.open		= msp_gpio_open,
+	.release	= msp_gpio_release,
+};
+
+static struct miscdevice msp_gpio_miscdev = {
+	MISC_DYNAMIC_MINOR,
+	"pmcmsp_gpio",
+	&msp_gpio_fops
+};
+
+static int msp_gpio_blinkthread(void *none)
+{
+	int firstrun = 1;
+	
+	do {
+		u32 mask = 0, data = 0;
+		int i, blinking = 0;
+		spin_lock(&msp_blink_lock);
+		for (i = 0; i < MSP_NUM_GPIOS; i++) {
+			/* use blink_table[i].period as 'blink enabled' test */
+			if (blink_table[i].period) {
+				blinking = 1;
+				mask |= 1 << i;
+				blink_table[i].count++;
+
+				if (blink_table[i].count >=
+				    blink_table[i].period)
+					blink_table[i].count = 0;
+
+				if (blink_table[i].count <
+				    (blink_table[i].period *
+				    blink_table[i].dcycle / 100))
+					data |= 1 << i;
+			}
+		}
+		spin_unlock(&msp_blink_lock);
+
+		if (!firstrun || blinking)
+			msp_gpio_write_data(data, mask);
+		else
+			firstrun = 0;
+
+		if (blinking)
+			schedule_timeout_interruptible(HZ/100);
+		else
+			wait_for_completion_interruptible(&msp_blink_wait);
+		
+		/* Thread may have been woken up to freeze or to exit */
+		try_to_freeze();
+	} while (!kthread_should_stop());
+
+	return 0;
+}
+
+/* -- Module functions -- */
+
+static int __init msp_gpio_init(void)
+{
+	if (misc_register(&msp_gpio_miscdev)) {
+		printk(KERN_ERR "Device registration failed\n");
+		goto err_miscdev;
+	}
+
+	msp_blinkthread = kthread_run(msp_gpio_blinkthread,NULL, "gpio_blink");
+	if (msp_blinkthread == NULL) {
+		printk(KERN_ERR "Could not start kthread\n");
+		goto err_blinkthread;
+	}
+
+	printk(KERN_WARNING "MSP7120 GPIO subsystem initialized\n");
+	return 0;
+
+err_blinkthread:
+	misc_deregister(&msp_gpio_miscdev);
+err_miscdev:
+	return -ENOMEM;
+}
+
+static void __exit msp_gpio_exit(void)
+{
+	complete(&msp_blink_wait);
+	kthread_stop(msp_blinkthread);
+
+	misc_deregister(&msp_gpio_miscdev);
+}
+
+EXPORT_SYMBOL(msp_gpio_in);
+EXPORT_SYMBOL(msp_gpio_out);
+EXPORT_SYMBOL(msp_gpio_mode);
+EXPORT_SYMBOL(msp_gpio_blink);
+EXPORT_SYMBOL(msp_gpio_noblink);
+
+MODULE_DESCRIPTION("PMC MSP GPIO driver");
+MODULE_LICENSE("GPL");
+
+module_init(msp_gpio_init);
+module_exit(msp_gpio_exit);
diff --git a/include/asm-mips/pmc-sierra/msp71xx/msp_gpio.h b/include/asm-mips/pmc-sierra/msp71xx/msp_gpio.h
new file mode 100644
index 0000000..3c930ed
--- /dev/null
+++ b/include/asm-mips/pmc-sierra/msp71xx/msp_gpio.h
@@ -0,0 +1,98 @@
+/*
+ * Character driver for the PMC Athena (MSP7120) reference board GPIO pins
+ *
+ * Copyright 2005-2007 PMC-Sierra, Inc.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __MSP_GPIO_H__
+#define __MSP_GPIO_H__
+
+#include <linux/ioctl.h>
+
+#include <msp_gpio_macros.h>
+
+/* IOCTL structs macros */
+
+struct msp_gpio_ioctl_io_data {
+	u32 data;
+	u32 mask;
+};
+
+struct msp_gpio_ioctl_blink_data {
+	u32 mask;
+	u32 period;
+	u32 dcycle;
+};
+
+#define MSP_GPIO_IOCTL_BASE	'Z'
+
+/* Reads the current data bits */
+#define MSP_GPIO_IN	_IOWR(MSP_GPIO_IOCTL_BASE, 0, \
+			      struct msp_gpio_ioctl_io_data)
+
+/* Writes data bits */
+#define MSP_GPIO_OUT	_IOW(MSP_GPIO_IOCTL_BASE, 1, \
+			      struct msp_gpio_ioctl_io_data)
+
+/* Sets all masked pins to the msp_gpio_mode_t given in the data field */
+#define MSP_GPIO_MODE	_IOW(MSP_GPIO_IOCTL_BASE, 2, \
+			      struct msp_gpio_ioctl_io_data)
+
+/* 
+ * Starts any masked LEDs blinking with parameters as follows:
+ *   - period - The time in 100ths of a second for a single period
+ *              (set to '0' to stop blinking)
+ *   - dcycle - The 'duty cycle' - what percentage of the period should
+ *              the gpio be on?
+ */
+#define MSP_GPIO_BLINK	_IOW(MSP_GPIO_IOCTL_BASE, 3, \
+			      struct msp_gpio_ioctl_blink_data)
+
+/* Bit flags and masks for GPIOs */
+#define MSP_NUM_GPIOS		20
+#define MSP_GPIO_ALL_MASK 	((1 << MSP_NUM_GPIOS) - 1)
+#define MSP_GPIO_NONE_MASK 	0LL
+#define MSP_GPIO_FREE_MASK	MSP_GPIO_ALL_MASK
+
+/* The following is only available to other modules */
+
+#ifdef __KERNEL__
+
+/* Reads the bits specified by the mask and puts the values in data */
+extern int msp_gpio_in(u32 *data, u32 mask);
+
+/* Sets the specified data on the masked pins */
+extern int msp_gpio_out(u32 data, u32 mask);
+
+/* Sets masked pins to the specified msp_gpio_mode_t */
+extern int msp_gpio_mode(msp_gpio_mode_t mode, u32 mask);
+
+/* Stops the specified GPIOs from blinking */
+extern int msp_gpio_noblink(u32 mask);
+
+/* Configures GPIO(s) to blink */
+int msp_gpio_blink(u32 mask, u32 period, u32 dcycle);
+
+#endif /* __KERNEL__ */
+
+#endif /* !__MSP_GPIO_H__ */
