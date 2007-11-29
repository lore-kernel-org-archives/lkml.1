Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbXLFMm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbXLFMm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbXLFMlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:41:44 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53673 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbXLFMlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:41:37 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <12cbfaacef5f6845538315485219e13b3b973eeb.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2007 17:03:41 +0100
Subject: [PATCH 02/47] Add new driver files for Artpec-3.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds gpio and nandflash handling for Artpec-3.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/drivers/mach-a3/Makefile    |    6 +
 arch/cris/arch-v32/drivers/mach-a3/gpio.c      |  984 ++++++++++++++++++++++++
 arch/cris/arch-v32/drivers/mach-a3/nandflash.c |  178 +++++
 3 files changed, 1168 insertions(+), 0 deletions(-)
 create mode 100644 arch/cris/arch-v32/drivers/mach-a3/Makefile
 create mode 100644 arch/cris/arch-v32/drivers/mach-a3/gpio.c
 create mode 100644 arch/cris/arch-v32/drivers/mach-a3/nandflash.c

diff --git a/arch/cris/arch-v32/drivers/mach-a3/Makefile b/arch/cris/arch-v32/drivers/mach-a3/Makefile
new file mode 100644
index 0000000..5c6d2a2
--- /dev/null
+++ b/arch/cris/arch-v32/drivers/mach-a3/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for Etrax-specific drivers
+#
+
+obj-$(CONFIG_ETRAX_NANDFLASH)   += nandflash.o
+obj-$(CONFIG_ETRAX_GPIO)        += gpio.o
diff --git a/arch/cris/arch-v32/drivers/mach-a3/gpio.c b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
new file mode 100644
index 0000000..4c48065
--- /dev/null
+++ b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
@@ -0,0 +1,984 @@
+/*
+ * Artec-3 general port I/O device
+ *
+ * Copyright (c) 2007 Axis Communications AB
+ *
+ * Authors:    Bjorn Wesen      (initial version)
+ *             Ola Knutsson     (LED handling)
+ *             Johan Adolfsson  (read/set directions, write, port G,
+ *                               port to ETRAX FS.
+ *             Ricard Wanderlof (PWM for Artpec-3)
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/ioport.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/poll.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+
+#include <asm/etraxgpio.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/gio_defs.h>
+#include <hwregs/intr_vect_defs.h>
+#include <asm/io.h>
+#include <asm/system.h>
+#include <asm/irq.h>
+#include <asm/arch/mach/pinmux.h>
+
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+#include "../i2c.h"
+
+#define VIRT_I2C_ADDR 0x40
+#endif
+
+/* The following gio ports on ARTPEC-3 is available:
+ * pa 32 bits
+ * pb 32 bits
+ * pc 16 bits
+ * each port has a rw_px_dout, r_px_din and rw_px_oe register.
+ */
+
+#define GPIO_MAJOR 120  /* experimental MAJOR number */
+
+#define I2C_INTERRUPT_BITS 0x300 /* i2c0_done and i2c1_done bits */
+
+#define D(x)
+
+#if 0
+static int dp_cnt;
+#define DP(x) \
+	do { \
+		dp_cnt++; \
+		if (dp_cnt % 1000 == 0) \
+			x; \
+	} while (0)
+#else
+#define DP(x)
+#endif
+
+static char gpio_name[] = "etrax gpio";
+
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+static int virtual_gpio_ioctl(struct file *file, unsigned int cmd,
+			      unsigned long arg);
+#endif
+static int gpio_ioctl(struct inode *inode, struct file *file,
+		      unsigned int cmd, unsigned long arg);
+static ssize_t gpio_write(struct file *file, const char *buf, size_t count,
+			  loff_t *off);
+static int gpio_open(struct inode *inode, struct file *filp);
+static int gpio_release(struct inode *inode, struct file *filp);
+static unsigned int gpio_poll(struct file *filp,
+			      struct poll_table_struct *wait);
+
+/* private data per open() of this driver */
+
+struct gpio_private {
+	struct gpio_private *next;
+	/* The IO_CFG_WRITE_MODE_VALUE only support 8 bits: */
+	unsigned char clk_mask;
+	unsigned char data_mask;
+	unsigned char write_msb;
+	unsigned char pad1;
+	/* These fields are generic */
+	unsigned long highalarm, lowalarm;
+	wait_queue_head_t alarm_wq;
+	int minor;
+};
+
+static void gpio_set_alarm(struct gpio_private *priv);
+
+/* linked list of alarms to check for */
+
+static struct gpio_private *alarmlist;
+
+static int wanted_interrupts;
+
+static DEFINE_SPINLOCK(alarm_lock);
+
+#define NUM_PORTS (GPIO_MINOR_LAST+1)
+#define GIO_REG_RD_ADDR(reg) \
+	(volatile unsigned long *)(regi_gio + REG_RD_ADDR_gio_##reg)
+#define GIO_REG_WR_ADDR(reg) \
+	(volatile unsigned long *)(regi_gio + REG_WR_ADDR_gio_##reg)
+unsigned long led_dummy;
+unsigned long port_d_dummy;	/* Only input on Artpec-3 */
+unsigned long port_e_dummy;	/* Non existent on Artpec-3 */
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+static unsigned long virtual_dummy;
+static unsigned long virtual_rw_pv_oe = CONFIG_ETRAX_DEF_GIO_PV_OE;
+static unsigned short cached_virtual_gpio_read;
+#endif
+
+static volatile unsigned long *data_out[NUM_PORTS] = {
+	GIO_REG_WR_ADDR(rw_pa_dout),
+	GIO_REG_WR_ADDR(rw_pb_dout),
+	&led_dummy,
+	GIO_REG_WR_ADDR(rw_pc_dout),
+	&port_d_dummy,
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+	&port_e_dummy,
+	&virtual_dummy,
+#endif
+};
+
+static volatile unsigned long *data_in[NUM_PORTS] = {
+	GIO_REG_RD_ADDR(r_pa_din),
+	GIO_REG_RD_ADDR(r_pb_din),
+	&led_dummy,
+	GIO_REG_RD_ADDR(r_pc_din),
+	GIO_REG_RD_ADDR(r_pd_din),
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+	&port_e_dummy,
+	&virtual_dummy,
+#endif
+};
+
+static unsigned long changeable_dir[NUM_PORTS] = {
+	CONFIG_ETRAX_PA_CHANGEABLE_DIR,
+	CONFIG_ETRAX_PB_CHANGEABLE_DIR,
+	0,
+	CONFIG_ETRAX_PC_CHANGEABLE_DIR,
+	0,
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+	0,
+	CONFIG_ETRAX_PV_CHANGEABLE_DIR,
+#endif
+};
+
+static unsigned long changeable_bits[NUM_PORTS] = {
+	CONFIG_ETRAX_PA_CHANGEABLE_BITS,
+	CONFIG_ETRAX_PB_CHANGEABLE_BITS,
+	0,
+	CONFIG_ETRAX_PC_CHANGEABLE_BITS,
+	0,
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+	0,
+	CONFIG_ETRAX_PV_CHANGEABLE_BITS,
+#endif
+};
+
+static volatile unsigned long *dir_oe[NUM_PORTS] = {
+	GIO_REG_WR_ADDR(rw_pa_oe),
+	GIO_REG_WR_ADDR(rw_pb_oe),
+	&led_dummy,
+	GIO_REG_WR_ADDR(rw_pc_oe),
+	&port_d_dummy,
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+	&port_e_dummy,
+	&virtual_rw_pv_oe,
+#endif
+};
+
+static void
+gpio_set_alarm(struct gpio_private *priv)
+{
+	int bit;
+	int intr_cfg;
+	int mask;
+	int pins;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	intr_cfg = REG_RD_INT(gio, regi_gio, rw_intr_cfg);
+	pins = REG_RD_INT(gio, regi_gio, rw_intr_pins);
+	mask = REG_RD_INT(gio, regi_gio, rw_intr_mask) & I2C_INTERRUPT_BITS;
+
+	for (bit = 0; bit < 32; bit++) {
+		int intr = bit % 8;
+		int pin = bit / 8;
+		if (priv->minor < GPIO_MINOR_LEDS)
+			pin += priv->minor * 4;
+		else
+			pin += (priv->minor - 1) * 4;
+
+		if (priv->highalarm & (1<<bit)) {
+			intr_cfg |= (regk_gio_hi << (intr * 3));
+			mask |= 1 << intr;
+			wanted_interrupts = mask & 0xff;
+			pins |= pin << (intr * 4);
+		} else if (priv->lowalarm & (1<<bit)) {
+			intr_cfg |= (regk_gio_lo << (intr * 3));
+			mask |= 1 << intr;
+			wanted_interrupts = mask & 0xff;
+			pins |= pin << (intr * 4);
+		}
+	}
+
+	REG_WR_INT(gio, regi_gio, rw_intr_cfg, intr_cfg);
+	REG_WR_INT(gio, regi_gio, rw_intr_pins, pins);
+	REG_WR_INT(gio, regi_gio, rw_intr_mask, mask);
+
+	local_irq_restore(flags);
+}
+
+static unsigned int
+gpio_poll(struct file *file, struct poll_table_struct *wait)
+{
+	unsigned int mask = 0;
+	struct gpio_private *priv = (struct gpio_private *)file->private_data;
+	unsigned long data;
+	unsigned long tmp;
+
+	if (priv->minor >= GPIO_MINOR_PWM0 &&
+	    priv->minor <= GPIO_MINOR_LAST_PWM)
+		return 0;
+
+	poll_wait(file, &priv->alarm_wq, wait);
+	if (priv->minor <= GPIO_MINOR_D) {
+		data = *data_in[priv->minor];
+		REG_WR_INT(gio, regi_gio, rw_ack_intr, wanted_interrupts);
+		tmp = REG_RD_INT(gio, regi_gio, rw_intr_mask);
+		tmp &= I2C_INTERRUPT_BITS;
+		tmp |= wanted_interrupts;
+		REG_WR_INT(gio, regi_gio, rw_intr_mask, tmp);
+	} else
+		return 0;
+
+	if ((data & priv->highalarm) || (~data & priv->lowalarm))
+		mask = POLLIN|POLLRDNORM;
+
+	DP(printk(KERN_DEBUG "gpio_poll ready: mask 0x%08X\n", mask));
+	return mask;
+}
+
+static irqreturn_t
+gpio_interrupt(int irq, void *dev_id)
+{
+	reg_gio_rw_intr_mask intr_mask;
+	reg_gio_r_masked_intr masked_intr;
+	reg_gio_rw_ack_intr ack_intr;
+	unsigned long tmp;
+	unsigned long tmp2;
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+	unsigned char enable_gpiov_ack = 0;
+#endif
+
+	/* Find what PA interrupts are active */
+	masked_intr = REG_RD(gio, regi_gio, r_masked_intr);
+	tmp = REG_TYPE_CONV(unsigned long, reg_gio_r_masked_intr, masked_intr);
+
+	/* Find those that we have enabled */
+	spin_lock(&alarm_lock);
+	tmp &= wanted_interrupts;
+	spin_unlock(&alarm_lock);
+
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+	/* Something changed on virtual GPIO. Interrupt is acked by
+	 * reading the device.
+	 */
+	if (tmp & (1 << CONFIG_ETRAX_VIRTUAL_GPIO_INTERRUPT_PA_PIN)) {
+		i2c_read(VIRT_I2C_ADDR, (void *)&cached_virtual_gpio_read,
+			sizeof(cached_virtual_gpio_read));
+		enable_gpiov_ack = 1;
+	}
+#endif
+
+	/* Ack them */
+	ack_intr = REG_TYPE_CONV(reg_gio_rw_ack_intr, unsigned long, tmp);
+	REG_WR(gio, regi_gio, rw_ack_intr, ack_intr);
+
+	/* Disable those interrupts.. */
+	intr_mask = REG_RD(gio, regi_gio, rw_intr_mask);
+	tmp2 = REG_TYPE_CONV(unsigned long, reg_gio_rw_intr_mask, intr_mask);
+	tmp2 &= ~tmp;
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+	/* Do not disable interrupt on virtual GPIO. Changes on virtual
+	 * pins are only noticed by an interrupt.
+	 */
+	if (enable_gpiov_ack)
+		tmp2 |= (1 << CONFIG_ETRAX_VIRTUAL_GPIO_INTERRUPT_PA_PIN);
+#endif
+	intr_mask = REG_TYPE_CONV(reg_gio_rw_intr_mask, unsigned long, tmp2);
+	REG_WR(gio, regi_gio, rw_intr_mask, intr_mask);
+
+	return IRQ_RETVAL(tmp);
+}
+
+
+static ssize_t gpio_write(struct file *file, const char *buf, size_t count,
+	loff_t *off)
+{
+	struct gpio_private *priv = (struct gpio_private *)file->private_data;
+	unsigned char data, clk_mask, data_mask, write_msb;
+	unsigned long flags;
+	unsigned long shadow;
+	volatile unsigned long *port;
+	ssize_t retval = count;
+	/* Only bits 0-7 may be used for write operations but allow all
+	   devices except leds... */
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+	if (priv->minor == GPIO_MINOR_V)
+		return -EFAULT;
+#endif
+	if (priv->minor == GPIO_MINOR_LEDS)
+		return -EFAULT;
+
+	if (priv->minor >= GPIO_MINOR_PWM0 &&
+	    priv->minor <= GPIO_MINOR_LAST_PWM)
+		return -EFAULT;
+
+	if (!access_ok(VERIFY_READ, buf, count))
+		return -EFAULT;
+
+	clk_mask = priv->clk_mask;
+	data_mask = priv->data_mask;
+	/* It must have been configured using the IO_CFG_WRITE_MODE */
+	/* Perhaps a better error code? */
+	if (clk_mask == 0 || data_mask == 0)
+		return -EPERM;
+
+	write_msb = priv->write_msb;
+	D(printk(KERN_DEBUG "gpio_write: %lu to data 0x%02X clk 0x%02X "
+		"msb: %i\n",
+		count, data_mask, clk_mask, write_msb));
+	port = data_out[priv->minor];
+
+	while (count--) {
+		int i;
+		data = *buf++;
+		if (priv->write_msb) {
+			for (i = 7; i >= 0; i--) {
+				local_irq_save(flags);
+				shadow = *port;
+				*port = shadow &= ~clk_mask;
+				if (data & 1<<i)
+					*port = shadow |= data_mask;
+				else
+					*port = shadow &= ~data_mask;
+			/* For FPGA: min 5.0ns (DCC) before CCLK high */
+				*port = shadow |= clk_mask;
+				local_irq_restore(flags);
+			}
+		} else {
+			for (i = 0; i <= 7; i++) {
+				local_irq_save(flags);
+				shadow = *port;
+				*port = shadow &= ~clk_mask;
+				if (data & 1<<i)
+					*port = shadow |= data_mask;
+				else
+					*port = shadow &= ~data_mask;
+			/* For FPGA: min 5.0ns (DCC) before CCLK high */
+				*port = shadow |= clk_mask;
+				local_irq_restore(flags);
+			}
+		}
+	}
+	return retval;
+}
+
+static int
+gpio_open(struct inode *inode, struct file *filp)
+{
+	struct gpio_private *priv;
+	int p = iminor(inode);
+
+	if (p > GPIO_MINOR_LAST_PWM ||
+	    (p > GPIO_MINOR_LAST && p < GPIO_MINOR_PWM0))
+		return -EINVAL;
+
+	priv = kmalloc(sizeof(struct gpio_private), GFP_KERNEL);
+
+	if (!priv)
+		return -ENOMEM;
+	memset(priv, 0, sizeof(*priv));
+
+	priv->minor = p;
+	filp->private_data = (void *)priv;
+
+	/* initialize the io/alarm struct, not for PWM ports though  */
+	if (p <= GPIO_MINOR_LAST) {
+
+		priv->clk_mask = 0;
+		priv->data_mask = 0;
+		priv->highalarm = 0;
+		priv->lowalarm = 0;
+
+		init_waitqueue_head(&priv->alarm_wq);
+
+		/* link it into our alarmlist */
+		spin_lock_irq(&alarm_lock);
+		priv->next = alarmlist;
+		alarmlist = priv;
+		spin_unlock_irq(&alarm_lock);
+	}
+
+	return 0;
+}
+
+static int
+gpio_release(struct inode *inode, struct file *filp)
+{
+	struct gpio_private *p;
+	struct gpio_private *todel;
+	/* local copies while updating them: */
+	unsigned long a_high, a_low;
+
+	/* prepare to free private structure */
+	todel = (struct gpio_private *)filp->private_data;
+
+	/* unlink from alarmlist - only for non-PWM ports though */
+	if (todel->minor <= GPIO_MINOR_LAST) {
+		spin_lock_irq(&alarm_lock);
+		p = alarmlist;
+
+		if (p == todel)
+			alarmlist = todel->next;
+		 else {
+			while (p->next != todel)
+				p = p->next;
+			p->next = todel->next;
+		}
+
+		/* Check if there are still any alarms set */
+		p = alarmlist;
+		a_high = 0;
+		a_low = 0;
+		while (p) {
+			if (p->minor == GPIO_MINOR_A) {
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+				p->lowalarm |= (1 << CONFIG_ETRAX_VIRTUAL_GPIO_INTERRUPT_PA_PIN);
+#endif
+				a_high |= p->highalarm;
+				a_low |= p->lowalarm;
+			}
+
+			p = p->next;
+		}
+
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+	/* Variable 'a_low' needs to be set here again
+	 * to ensure that interrupt for virtual GPIO is handled.
+	 */
+		a_low |= (1 << CONFIG_ETRAX_VIRTUAL_GPIO_INTERRUPT_PA_PIN);
+#endif
+
+		spin_unlock_irq(&alarm_lock);
+	}
+	kfree(todel);
+
+	return 0;
+}
+
+/* Main device API. ioctl's to read/set/clear bits, as well as to
+ * set alarms to wait for using a subsequent select().
+ */
+
+inline unsigned long setget_input(struct gpio_private *priv, unsigned long arg)
+{
+	/* Set direction 0=unchanged 1=input,
+	 * return mask with 1=input
+	 */
+	unsigned long flags;
+	unsigned long dir_shadow;
+
+	local_irq_save(flags);
+	dir_shadow = *dir_oe[priv->minor];
+	dir_shadow &= ~(arg & changeable_dir[priv->minor]);
+	*dir_oe[priv->minor] = dir_shadow;
+	local_irq_restore(flags);
+
+	if (priv->minor == GPIO_MINOR_C)
+		dir_shadow ^= 0xFFFF;		/* Only 16 bits */
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+	else if (priv->minor == GPIO_MINOR_V)
+		dir_shadow ^= 0xFFFF;		/* Only 16 bits */
+#endif
+	else
+		dir_shadow ^= 0xFFFFFFFF;	/* PA, PB and PD 32 bits */
+
+	return dir_shadow;
+
+} /* setget_input */
+
+inline unsigned long setget_output(struct gpio_private *priv, unsigned long arg)
+{
+	unsigned long flags;
+	unsigned long dir_shadow;
+
+	local_irq_save(flags);
+	dir_shadow = *dir_oe[priv->minor];
+	dir_shadow |=  (arg & changeable_dir[priv->minor]);
+	*dir_oe[priv->minor] = dir_shadow;
+	local_irq_restore(flags);
+	return dir_shadow;
+} /* setget_output */
+
+static int
+gpio_leds_ioctl(unsigned int cmd, unsigned long arg);
+
+static int
+gpio_pwm_ioctl(struct gpio_private *priv, unsigned int cmd, unsigned long arg);
+
+static int
+gpio_ioctl(struct inode *inode, struct file *file,
+	   unsigned int cmd, unsigned long arg)
+{
+	unsigned long flags;
+	unsigned long val;
+	unsigned long shadow;
+	struct gpio_private *priv = (struct gpio_private *)file->private_data;
+
+	if (_IOC_TYPE(cmd) != ETRAXGPIO_IOCTYPE)
+		return -EINVAL;
+
+	/* Check for special ioctl handlers first */
+
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+	if (priv->minor == GPIO_MINOR_V)
+		return virtual_gpio_ioctl(file, cmd, arg);
+#endif
+
+	if (priv->minor == GPIO_MINOR_LEDS)
+		return gpio_leds_ioctl(cmd, arg);
+
+	if (priv->minor >= GPIO_MINOR_PWM0 &&
+	    priv->minor <= GPIO_MINOR_LAST_PWM)
+		return gpio_pwm_ioctl(priv, cmd, arg);
+
+	switch (_IOC_NR(cmd)) {
+	case IO_READBITS: /* Use IO_READ_INBITS and IO_READ_OUTBITS instead */
+		/* Read the port. */
+		return *data_in[priv->minor];
+		break;
+	case IO_SETBITS:
+		local_irq_save(flags);
+		/* Set changeable bits with a 1 in arg. */
+		shadow = *data_out[priv->minor];
+		shadow |=  (arg & changeable_bits[priv->minor]);
+		*data_out[priv->minor] = shadow;
+		local_irq_restore(flags);
+		break;
+	case IO_CLRBITS:
+		local_irq_save(flags);
+		/* Clear changeable bits with a 1 in arg. */
+		shadow = *data_out[priv->minor];
+		shadow &=  ~(arg & changeable_bits[priv->minor]);
+		*data_out[priv->minor] = shadow;
+		local_irq_restore(flags);
+		break;
+	case IO_HIGHALARM:
+		/* Set alarm when bits with 1 in arg go high. */
+		priv->highalarm |= arg;
+		gpio_set_alarm(priv);
+		break;
+	case IO_LOWALARM:
+		/* Set alarm when bits with 1 in arg go low. */
+		priv->lowalarm |= arg;
+		gpio_set_alarm(priv);
+		break;
+	case IO_CLRALARM:
+		/* Clear alarm for bits with 1 in arg. */
+		priv->highalarm &= ~arg;
+		priv->lowalarm  &= ~arg;
+		gpio_set_alarm(priv);
+		break;
+	case IO_READDIR: /* Use IO_SETGET_INPUT/OUTPUT instead! */
+		/* Read direction 0=input 1=output */
+		return *dir_oe[priv->minor];
+	case IO_SETINPUT: /* Use IO_SETGET_INPUT instead! */
+		/* Set direction 0=unchanged 1=input,
+		 * return mask with 1=input
+		 */
+		return setget_input(priv, arg);
+		break;
+	case IO_SETOUTPUT: /* Use IO_SETGET_OUTPUT instead! */
+		/* Set direction 0=unchanged 1=output,
+		 * return mask with 1=output
+		 */
+		return setget_output(priv, arg);
+
+	case IO_CFG_WRITE_MODE:
+	{
+		unsigned long dir_shadow;
+		dir_shadow = *dir_oe[priv->minor];
+
+		priv->clk_mask = arg & 0xFF;
+		priv->data_mask = (arg >> 8) & 0xFF;
+		priv->write_msb = (arg >> 16) & 0x01;
+		/* Check if we're allowed to change the bits and
+		 * the direction is correct
+		 */
+		if (!((priv->clk_mask & changeable_bits[priv->minor]) &&
+		      (priv->data_mask & changeable_bits[priv->minor]) &&
+		      (priv->clk_mask & dir_shadow) &&
+		      (priv->data_mask & dir_shadow))) {
+			priv->clk_mask = 0;
+			priv->data_mask = 0;
+			return -EPERM;
+		}
+		break;
+	}
+	case IO_READ_INBITS:
+		/* *arg is result of reading the input pins */
+		val = *data_in[priv->minor];
+		if (copy_to_user((unsigned long *)arg, &val, sizeof(val)))
+			return -EFAULT;
+		return 0;
+		break;
+	case IO_READ_OUTBITS:
+		 /* *arg is result of reading the output shadow */
+		val = *data_out[priv->minor];
+		if (copy_to_user((unsigned long *)arg, &val, sizeof(val)))
+			return -EFAULT;
+		break;
+	case IO_SETGET_INPUT:
+		/* bits set in *arg is set to input,
+		 * *arg updated with current input pins.
+		 */
+		if (copy_from_user(&val, (unsigned long *)arg, sizeof(val)))
+			return -EFAULT;
+		val = setget_input(priv, val);
+		if (copy_to_user((unsigned long *)arg, &val, sizeof(val)))
+			return -EFAULT;
+		break;
+	case IO_SETGET_OUTPUT:
+		/* bits set in *arg is set to output,
+		 * *arg updated with current output pins.
+		 */
+		if (copy_from_user(&val, (unsigned long *)arg, sizeof(val)))
+			return -EFAULT;
+		val = setget_output(priv, val);
+		if (copy_to_user((unsigned long *)arg, &val, sizeof(val)))
+			return -EFAULT;
+		break;
+	default:
+		return -EINVAL;
+	} /* switch */
+
+	return 0;
+}
+
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+static int
+virtual_gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	unsigned long flags;
+	unsigned short val;
+	unsigned short shadow;
+	struct gpio_private *priv = (struct gpio_private *)file->private_data;
+
+	switch (_IOC_NR(cmd)) {
+	case IO_SETBITS:
+		local_irq_save(flags);
+		/* Set changeable bits with a 1 in arg. */
+		i2c_read(VIRT_I2C_ADDR, (void *)&shadow, sizeof(shadow));
+		shadow |= ~*dir_oe[priv->minor];
+		shadow |= (arg & changeable_bits[priv->minor]);
+		i2c_write(VIRT_I2C_ADDR, (void *)&shadow, sizeof(shadow));
+		local_irq_restore(flags);
+		break;
+	case IO_CLRBITS:
+		local_irq_save(flags);
+		/* Clear changeable bits with a 1 in arg. */
+		i2c_read(VIRT_I2C_ADDR, (void *)&shadow, sizeof(shadow));
+		shadow |= ~*dir_oe[priv->minor];
+		shadow &= ~(arg & changeable_bits[priv->minor]);
+		i2c_write(VIRT_I2C_ADDR, (void *)&shadow, sizeof(shadow));
+		local_irq_restore(flags);
+		break;
+	case IO_HIGHALARM:
+		/* Set alarm when bits with 1 in arg go high. */
+		priv->highalarm |= arg;
+		break;
+	case IO_LOWALARM:
+		/* Set alarm when bits with 1 in arg go low. */
+		priv->lowalarm |= arg;
+		break;
+	case IO_CLRALARM:
+		/* Clear alarm for bits with 1 in arg. */
+		priv->highalarm &= ~arg;
+		priv->lowalarm  &= ~arg;
+		break;
+	case IO_CFG_WRITE_MODE:
+	{
+		unsigned long dir_shadow;
+		dir_shadow = *dir_oe[priv->minor];
+
+		priv->clk_mask = arg & 0xFF;
+		priv->data_mask = (arg >> 8) & 0xFF;
+		priv->write_msb = (arg >> 16) & 0x01;
+		/* Check if we're allowed to change the bits and
+		 * the direction is correct
+		 */
+		if (!((priv->clk_mask & changeable_bits[priv->minor]) &&
+		      (priv->data_mask & changeable_bits[priv->minor]) &&
+		      (priv->clk_mask & dir_shadow) &&
+		      (priv->data_mask & dir_shadow))) {
+			priv->clk_mask = 0;
+			priv->data_mask = 0;
+			return -EPERM;
+		}
+		break;
+	}
+	case IO_READ_INBITS:
+		/* *arg is result of reading the input pins */
+		val = cached_virtual_gpio_read;
+		val &= ~*dir_oe[priv->minor];
+		if (copy_to_user((unsigned long *)arg, &val, sizeof(val)))
+			return -EFAULT;
+		return 0;
+		break;
+	case IO_READ_OUTBITS:
+		 /* *arg is result of reading the output shadow */
+		i2c_read(VIRT_I2C_ADDR, (void *)&val, sizeof(val));
+		val &= *dir_oe[priv->minor];
+		if (copy_to_user((unsigned long *)arg, &val, sizeof(val)))
+			return -EFAULT;
+		break;
+	case IO_SETGET_INPUT:
+	{
+		/* bits set in *arg is set to input,
+		 * *arg updated with current input pins.
+		 */
+		unsigned short input_mask = ~*dir_oe[priv->minor];
+		if (copy_from_user(&val, (unsigned long *)arg, sizeof(val)))
+			return -EFAULT;
+		val = setget_input(priv, val);
+		if (copy_to_user((unsigned long *)arg, &val, sizeof(val)))
+			return -EFAULT;
+		if ((input_mask & val) != input_mask) {
+			/* Input pins changed. All ports desired as input
+			 * should be set to logic 1.
+			 */
+			unsigned short change = input_mask ^ val;
+			i2c_read(VIRT_I2C_ADDR, (void *)&shadow,
+				sizeof(shadow));
+			shadow &= ~change;
+			shadow |= val;
+			i2c_write(VIRT_I2C_ADDR, (void *)&shadow,
+				sizeof(shadow));
+		}
+		break;
+	}
+	case IO_SETGET_OUTPUT:
+		/* bits set in *arg is set to output,
+		 * *arg updated with current output pins.
+		 */
+		if (copy_from_user(&val, (unsigned long *)arg, sizeof(val)))
+			return -EFAULT;
+		val = setget_output(priv, val);
+		if (copy_to_user((unsigned long *)arg, &val, sizeof(val)))
+			return -EFAULT;
+		break;
+	default:
+		return -EINVAL;
+	} /* switch */
+	return 0;
+}
+#endif /* CONFIG_ETRAX_VIRTUAL_GPIO */
+
+static int
+gpio_leds_ioctl(unsigned int cmd, unsigned long arg)
+{
+	unsigned char green;
+	unsigned char red;
+
+	switch (_IOC_NR(cmd)) {
+	case IO_LEDACTIVE_SET:
+		green = ((unsigned char) arg) & 1;
+		red   = (((unsigned char) arg) >> 1) & 1;
+		LED_ACTIVE_SET_G(green);
+		LED_ACTIVE_SET_R(red);
+		break;
+
+	default:
+		return -EINVAL;
+	} /* switch */
+
+	return 0;
+}
+
+static int gpio_pwm_set_mode(unsigned long arg, int pwm_port)
+{
+	int pinmux_pwm = pinmux_pwm0 + pwm_port;
+	int mode;
+	reg_gio_rw_pwm0_ctrl rw_pwm_ctrl = {
+		.ccd_val = 0,
+		.ccd_override = regk_gio_no,
+		.mode = regk_gio_no
+	};
+	int allocstatus;
+
+	if (get_user(mode, &((struct io_pwm_set_mode *) arg)->mode))
+		return -EFAULT;
+	rw_pwm_ctrl.mode = mode;
+	if (mode != PWM_OFF)
+		allocstatus = crisv32_pinmux_alloc_fixed(pinmux_pwm);
+	else
+		allocstatus = crisv32_pinmux_dealloc_fixed(pinmux_pwm);
+	if (allocstatus)
+		return allocstatus;
+	REG_WRITE(reg_gio_rw_pwm0_ctrl, REG_ADDR(gio, regi_gio, rw_pwm0_ctrl) +
+		12 * pwm_port, rw_pwm_ctrl);
+	return 0;
+}
+
+static int gpio_pwm_set_period(unsigned long arg, int pwm_port)
+{
+	struct io_pwm_set_period periods;
+	reg_gio_rw_pwm0_var rw_pwm_widths;
+
+	if (copy_from_user(&periods, (struct io_pwm_set_period *) arg,
+			sizeof(periods)))
+		return -EFAULT;
+	if (periods.lo > 8191 || periods.hi > 8191)
+		return -EINVAL;
+	rw_pwm_widths.lo = periods.lo;
+	rw_pwm_widths.hi = periods.hi;
+	REG_WRITE(reg_gio_rw_pwm0_var, REG_ADDR(gio, regi_gio, rw_pwm0_var) +
+		12 * pwm_port, rw_pwm_widths);
+	return 0;
+}
+
+static int gpio_pwm_set_duty(unsigned long arg, int pwm_port)
+{
+	unsigned int duty;
+	reg_gio_rw_pwm0_data rw_pwm_duty;
+
+	if (get_user(duty, &((struct io_pwm_set_duty *) arg)->duty))
+		return -EFAULT;
+	if (duty > 255)
+		return -EINVAL;
+	rw_pwm_duty.data = duty;
+	REG_WRITE(reg_gio_rw_pwm0_data, REG_ADDR(gio, regi_gio, rw_pwm0_data) +
+		12 * pwm_port, rw_pwm_duty);
+	return 0;
+}
+
+static int
+gpio_pwm_ioctl(struct gpio_private *priv, unsigned int cmd, unsigned long arg)
+{
+	int pwm_port = priv->minor - GPIO_MINOR_PWM0;
+
+	switch (_IOC_NR(cmd)) {
+	case IO_PWM_SET_MODE:
+		return gpio_pwm_set_mode(arg, pwm_port);
+	case IO_PWM_SET_PERIOD:
+		return gpio_pwm_set_period(arg, pwm_port);
+	case IO_PWM_SET_DUTY:
+		return gpio_pwm_set_duty(arg, pwm_port);
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+struct file_operations gpio_fops = {
+	.owner       = THIS_MODULE,
+	.poll        = gpio_poll,
+	.ioctl       = gpio_ioctl,
+	.write       = gpio_write,
+	.open        = gpio_open,
+	.release     = gpio_release,
+};
+
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+static void
+virtual_gpio_init(void)
+{
+	reg_gio_rw_intr_cfg intr_cfg;
+	reg_gio_rw_intr_mask intr_mask;
+	unsigned short shadow;
+
+	shadow = ~virtual_rw_pv_oe; /* Input ports should be set to logic 1 */
+	shadow |= CONFIG_ETRAX_DEF_GIO_PV_OUT;
+	i2c_write(VIRT_I2C_ADDR, (void *)&shadow, sizeof(shadow));
+
+	/* Set interrupt mask and on what state the interrupt shall trigger.
+	 * For virtual gpio the interrupt shall trigger on logic '0'.
+	 */
+	intr_cfg = REG_RD(gio, regi_gio, rw_intr_cfg);
+	intr_mask = REG_RD(gio, regi_gio, rw_intr_mask);
+
+	switch (CONFIG_ETRAX_VIRTUAL_GPIO_INTERRUPT_PA_PIN) {
+	case 0:
+		intr_cfg.pa0 = regk_gio_lo;
+		intr_mask.pa0 = regk_gio_yes;
+		break;
+	case 1:
+		intr_cfg.pa1 = regk_gio_lo;
+		intr_mask.pa1 = regk_gio_yes;
+		break;
+	case 2:
+		intr_cfg.pa2 = regk_gio_lo;
+		intr_mask.pa2 = regk_gio_yes;
+		break;
+	case 3:
+		intr_cfg.pa3 = regk_gio_lo;
+		intr_mask.pa3 = regk_gio_yes;
+		break;
+	case 4:
+		intr_cfg.pa4 = regk_gio_lo;
+		intr_mask.pa4 = regk_gio_yes;
+		break;
+	case 5:
+		intr_cfg.pa5 = regk_gio_lo;
+		intr_mask.pa5 = regk_gio_yes;
+		break;
+	case 6:
+		intr_cfg.pa6 = regk_gio_lo;
+		intr_mask.pa6 = regk_gio_yes;
+		break;
+	case 7:
+		intr_cfg.pa7 = regk_gio_lo;
+		intr_mask.pa7 = regk_gio_yes;
+		break;
+	}
+
+	REG_WR(gio, regi_gio, rw_intr_cfg, intr_cfg);
+	REG_WR(gio, regi_gio, rw_intr_mask, intr_mask);
+}
+#endif
+
+/* main driver initialization routine, called from mem.c */
+
+static __init int
+gpio_init(void)
+{
+	int res;
+
+	/* do the formalities */
+
+	res = register_chrdev(GPIO_MAJOR, gpio_name, &gpio_fops);
+	if (res < 0) {
+		printk(KERN_ERR "gpio: couldn't get a major number.\n");
+		return res;
+	}
+
+	/* Clear all leds */
+	LED_NETWORK_GRP0_SET(0);
+	LED_NETWORK_GRP1_SET(0);
+	LED_ACTIVE_SET(0);
+	LED_DISK_READ(0);
+	LED_DISK_WRITE(0);
+
+	printk(KERN_INFO "ETRAX FS GPIO driver v2.6, (c) 2003-2007 "
+		"Axis Communications AB\n");
+	if (request_irq(GIO_INTR_VECT, gpio_interrupt,
+			IRQF_SHARED | IRQF_DISABLED, "gpio", &alarmlist))
+		printk(KERN_ERR "err: irq for gpio\n");
+
+	/* No IRQs by default. */
+	REG_WR_INT(gio, regi_gio, rw_intr_pins, 0);
+
+#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
+	virtual_gpio_init();
+#endif
+
+	return res;
+}
+
+/* this makes sure that gpio_init is called during kernel boot */
+
+module_init(gpio_init);
diff --git a/arch/cris/arch-v32/drivers/mach-a3/nandflash.c b/arch/cris/arch-v32/drivers/mach-a3/nandflash.c
new file mode 100644
index 0000000..2fda3db
--- /dev/null
+++ b/arch/cris/arch-v32/drivers/mach-a3/nandflash.c
@@ -0,0 +1,178 @@
+/*
+ *  arch/cris/arch-v32/drivers/nandflash.c
+ *
+ *  Copyright (c) 2007
+ *
+ *  Derived from drivers/mtd/nand/spia.c
+ *	  Copyright (C) 2000 Steven J. Hill (sjhill@realitydiluted.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/mtd/partitions.h>
+#include <asm/arch/memmap.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/pio_defs.h>
+#include <pinmux.h>
+#include <asm/io.h>
+
+#define MANUAL_ALE_CLE_CONTROL 1
+
+#define regf_ALE	a0
+#define regf_CLE	a1
+#define regf_NCE	ce0_n
+
+#define CLE_BIT 10
+#define ALE_BIT 11
+#define CE_BIT 12
+
+/* Bitmask for control pins */
+#define PIN_BITMASK ((1 << CE_BIT) | (1 << CLE_BIT) | (1 << ALE_BIT))
+
+static struct mtd_info *crisv32_mtd;
+/*
+ *	hardware specific access to control-lines
+ */
+static void crisv32_hwcontrol(struct mtd_info *mtd, int cmd,
+			      unsigned int ctrl)
+{
+	unsigned long flags;
+	reg_pio_rw_dout dout;
+	struct nand_chip *this = mtd->priv;
+
+	local_irq_save(flags);
+
+	/* control bits change */
+	if (ctrl & NAND_CTRL_CHANGE) {
+		dout = REG_RD(pio, regi_pio, rw_dout);
+		dout.regf_NCE = (ctrl & NAND_NCE) ? 0 : 1;
+
+#if !MANUAL_ALE_CLE_CONTROL
+		if (ctrl & NAND_ALE) {
+			/* A0 = ALE high */
+			this->IO_ADDR_W = (void __iomem *)REG_ADDR(pio,
+				regi_pio, rw_io_access1);
+		} else if (ctrl & NAND_CLE) {
+			/* A1 = CLE high */
+			this->IO_ADDR_W = (void __iomem *)REG_ADDR(pio,
+				regi_pio, rw_io_access2);
+		} else {
+			/* A1 = CLE and A0 = ALE low */
+			this->IO_ADDR_W = (void __iomem *)REG_ADDR(pio,
+				regi_pio, rw_io_access0);
+		}
+#else
+
+		dout.regf_CLE = (ctrl & NAND_CLE) ? 1 : 0;
+		dout.regf_ALE = (ctrl & NAND_ALE) ? 1 : 0;
+#endif
+		REG_WR(pio, regi_pio, rw_dout, dout);
+	}
+
+	/* command to chip */
+	if (cmd != NAND_CMD_NONE)
+		writeb(cmd, this->IO_ADDR_W);
+
+	local_irq_restore(flags);
+}
+
+/*
+*	read device ready pin
+*/
+int crisv32_device_ready(struct mtd_info *mtd)
+{
+	reg_pio_r_din din = REG_RD(pio, regi_pio, r_din);
+	return din.rdy;
+}
+
+/*
+ * Main initialization routine
+ */
+struct mtd_info *__init crisv32_nand_flash_probe(void)
+{
+	void __iomem *read_cs;
+	void __iomem *write_cs;
+
+	struct nand_chip *this;
+	int err = 0;
+
+	reg_pio_rw_man_ctrl man_ctrl = {
+		.regf_NCE = regk_pio_yes,
+#if MANUAL_ALE_CLE_CONTROL
+		.regf_ALE = regk_pio_yes,
+		.regf_CLE = regk_pio_yes
+#endif
+	};
+	reg_pio_rw_oe oe = {
+		.regf_NCE = regk_pio_yes,
+#if MANUAL_ALE_CLE_CONTROL
+		.regf_ALE = regk_pio_yes,
+		.regf_CLE = regk_pio_yes
+#endif
+	};
+	reg_pio_rw_dout dout = { .regf_NCE = 1 };
+
+	/* Allocate pio pins to pio */
+	crisv32_pinmux_alloc_fixed(pinmux_pio);
+	/* Set up CE, ALE, CLE (ce0_n, a0, a1) for manual control and output */
+	REG_WR(pio, regi_pio, rw_man_ctrl, man_ctrl);
+	REG_WR(pio, regi_pio, rw_dout, dout);
+	REG_WR(pio, regi_pio, rw_oe, oe);
+
+	/* Allocate memory for MTD device structure and private data */
+	crisv32_mtd = kmalloc(sizeof(struct mtd_info) +
+		sizeof(struct nand_chip), GFP_KERNEL);
+	if (!crisv32_mtd) {
+		printk(KERN_ERR "Unable to allocate CRISv32 NAND MTD "
+			"device structure.\n");
+		err = -ENOMEM;
+		return NULL;
+	}
+
+	read_cs = write_cs = (void __iomem *)REG_ADDR(pio, regi_pio,
+		rw_io_access0);
+
+	/* Get pointer to private data */
+	this = (struct nand_chip *) (&crisv32_mtd[1]);
+
+	/* Initialize structures */
+	memset((char *) crisv32_mtd, 0, sizeof(struct mtd_info));
+	memset((char *) this, 0, sizeof(struct nand_chip));
+
+	/* Link the private data with the MTD structure */
+	crisv32_mtd->priv = this;
+
+	/* Set address of NAND IO lines */
+	this->IO_ADDR_R = read_cs;
+	this->IO_ADDR_W = write_cs;
+	this->cmd_ctrl = crisv32_hwcontrol;
+	this->dev_ready = crisv32_device_ready;
+	/* 20 us command delay time */
+	this->chip_delay = 20;
+	this->ecc.mode = NAND_ECC_SOFT;
+
+	/* Enable the following for a flash based bad block table */
+	/* this->options = NAND_USE_FLASH_BBT; */
+
+	/* Scan to find existance of the device */
+	if (nand_scan(crisv32_mtd, 1)) {
+		err = -ENXIO;
+		goto out_mtd;
+	}
+
+	return crisv32_mtd;
+
+out_mtd:
+	kfree(crisv32_mtd);
+	return NULL;
+}
+
-- 
1.5.3.6.970.gd25430

