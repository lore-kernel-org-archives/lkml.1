Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZETJRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZETJRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbZETJRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:17:23 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:52529 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbZETJRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:17:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=agHkkpcJ0IpercKXkUqkiCZp94secIzY42fRfIzhfFDhUifOpQ7RzJ0znikUSErSCv
         KtIHgl0cX3YVqdp83FCOlhn4tkD96WNU0gtEmIwCQK5+bvN31qPMurkmSKIGR9LlU7p8
         jnpfe6DZaLBw7/HEMnbCKZKqkHohOx8AHGXoE=
MIME-Version: 1.0
Date: Wed, 20 May 2009 11:17:18 +0200
Message-ID: <63386a3d0905200217i56accf6fw4ef2f8ed1793e44@mail.gmail.com>
Subject: [PATCH 1/1] MFD: Add U300 AB3100 core support v4
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: linux-i2c@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a core driver for the AB3100 mixed-signal circuit
found in the ST-Ericsson U300 series platforms. This driver
is a singleton proxy for all accesses to the AB3100
sub-drivers which will be merged on top of this one, RTC,
regulators, battery and system power control, vibrator,
LEDs, and an ALSA codec.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Reviewed-by: Mike Rapoport <mike@compulab.co.il>
Reviewed-by: Samuel Ortiz <sameo@linux.intel.com>
Reviewed-by: Ben Dooks <ben-linux@fluff.org>
---
 drivers/mfd/Kconfig        |   14 +
 drivers/mfd/Makefile       |    3 +-
 drivers/mfd/ab3100-core.c  |  974 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/ab3100.h |  103 +++++
 4 files changed, 1093 insertions(+), 1 deletions(-)
 create mode 100755 drivers/mfd/ab3100-core.c
 create mode 100644 include/linux/mfd/ab3100.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ee3927a..61f0346 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -241,6 +241,20 @@ config PCF50633_GPIO
 	 Say yes here if you want to include support GPIO for pins on
 	 the PCF50633 chip.

+config AB3100_CORE
+	tristate "ST-Ericsson AB3100 Mixed Signal Circuit core functions"
+	depends on I2C
+	default y if ARCH_U300
+	help
+	  Select this to enable the AB3100 Mixed Signal IC core
+	  functionality. This connects to a AB3100 on the I2C bus
+	  and expose a number of symbols needed for dependent devices
+	  to read and write registers and subscribe to events from
+	  this multi-functional IC. This is needed to use other features
+	  of the AB3100 such as battery-backed RTC, charging control,
+	  LEDs, vibrator, system power and temperature, power management
+	  and ALSA sound.
+
 endmenu

 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 3afb519..f5f3371 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -40,4 +40,5 @@ obj-$(CONFIG_PMIC_DA903X)	+= da903x.o

 obj-$(CONFIG_MFD_PCF50633)	+= pcf50633-core.o
 obj-$(CONFIG_PCF50633_ADC)	+= pcf50633-adc.o
-obj-$(CONFIG_PCF50633_GPIO)	+= pcf50633-gpio.o
\ No newline at end of file
+obj-$(CONFIG_PCF50633_GPIO)	+= pcf50633-gpio.o
+obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o
diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
new file mode 100755
index 0000000..49f2bfb
--- /dev/null
+++ b/drivers/mfd/ab3100-core.c
@@ -0,0 +1,974 @@
+/*
+ * Copyright (C) 2007-2009 ST-Ericsson
+ * License terms: GNU General Public License (GPL) version 2
+ * Low-level core for exclusive access to the AB3100 IC on the I2C bus
+ * and some basic chip-configuration.
+ * Author: Linus Walleij <linus.walleij@stericsson.com>
+ */
+
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/notifier.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <linux/mfd/ab3100.h>
+
+/* These are the only registers inside AB3100 used in this main file */
+
+/* Interrupt event registers */
+#define AB3100_EVENTA1		0x21
+#define AB3100_EVENTA2		0x22
+#define AB3100_EVENTA3		0x23
+
+/* AB3100 DAC converter registers */
+#define AB3100_DIS		0x00
+#define AB3100_D0C		0x01
+#define AB3100_D1C		0x02
+#define AB3100_D2C		0x03
+#define AB3100_D3C		0x04
+
+/* Chip ID register */
+#define AB3100_CID		0x20
+
+/* AB3100 interrupt registers */
+#define AB3100_IMRA1		0x24
+#define AB3100_IMRA2		0x25
+#define AB3100_IMRA3		0x26
+#define AB3100_IMRB1		0x2B
+#define AB3100_IMRB2		0x2C
+#define AB3100_IMRB3		0x2D
+
+/* System Power Monitoring and control registers */
+#define AB3100_MCA		0x2E
+#define AB3100_MCB		0x2F
+
+/* SIM power up */
+#define AB3100_SUP		0x50
+
+/*
+ * I2C communication
+ *
+ * The AB3100 is usually assigned address 0x48 (7-bit)
+ * The chip is defined in the platform i2c_board_data section.
+ */
+static unsigned short normal_i2c[] = { 0x48, I2C_CLIENT_END };
+I2C_CLIENT_INSMOD_1(ab3100);
+
+/* A local all-containing singleton */
+static struct ab3100 *ab3100_local;
+
+u8 ab3100_get_chip_type(struct ab3100 *ab3100_data)
+{
+	u8 chip = ABUNKNOWN;
+
+	switch (ab3100_data->chip_id & 0xf0) {
+	case  0xa0:
+		chip = AB3000;
+		break;
+	case  0xc0:
+		chip = AB3100;
+		break;
+	}
+	return chip;
+}
+EXPORT_SYMBOL(ab3100_get_chip_type);
+
+int ab3100_set_register(struct ab3100 *ab3100_data, u8 reg, u8 regval)
+{
+	u8 regandval[2] = {reg, regval};
+	int err;
+
+	err = mutex_lock_interruptible(&ab3100_data->access_mutex);
+	if (err)
+		return err;
+
+	/*
+	 * A two-byte write message with the first byte containing the register
+	 * number and the second byte containing the value to be written
+	 * effectively sets a register in the AB3100.
+	 */
+	err = i2c_master_send(ab3100_data->i2c_client, regandval, 2);
+	if (err < 0) {
+		dev_err(ab3100_data->dev,
+			"write error (write register): %d\n",
+			err);
+	} else if (err != 2) {
+		dev_err(ab3100_data->dev,
+			"write error (write register) "
+			"%d bytes transferred (expected 2)\n",
+			err);
+		err = -EIO;
+	} else {
+		/* All is well */
+		err = 0;
+	}
+	mutex_unlock(&ab3100_data->access_mutex);
+	return 0;
+}
+EXPORT_SYMBOL(ab3100_set_register);
+
+/*
+ * The test registers exist at an I2C bus address up one
+ * from the ordinary base. They are not supposed to be used
+ * in production code, but sometimes you have to do that
+ * anyway. It's currently only used from this file so declare
+ * it static and do not export.
+ */
+static int ab3100_set_test_register(u8 reg, u8 regval)
+{
+	u8 regandval[2] = {reg, regval};
+	int err;
+
+	err = mutex_lock_interruptible(&ab3100_local->access_mutex);
+	if (err)
+		return err;
+
+	err = i2c_master_send(ab3100_local->testreg_client, regandval, 2);
+	if (err < 0) {
+		dev_err(ab3100_local->dev,
+			"write error (write test register): %d\n",
+			err);
+	} else if (err != 2) {
+		dev_err(ab3100_local->dev,
+			"write error (write test register) "
+			"%d bytes transferred (expected 2)\n",
+			err);
+		err = -EIO;
+	} else {
+		/* All is well */
+		err = 0;
+	}
+	mutex_unlock(&ab3100_local->access_mutex);
+
+	return err;
+}
+
+int ab3100_get_register(struct ab3100 *ab3100_data, u8 reg, u8 *regval)
+{
+	int err;
+
+	err = mutex_lock_interruptible(&ab3100_data->access_mutex);
+	if (err)
+		return err;
+
+	/*
+	 * AB3100 require an I2C "stop" command between each message, else
+	 * it will not work. The only way of achieveing this with the
+	 * message transport layer is to send the read and write messages
+	 * separately.
+	 */
+	err = i2c_master_send(ab3100_data->i2c_client, &reg, 1);
+	if (err < 0) {
+		dev_err(ab3100_data->dev,
+			"write error (send register address): %d\n",
+			err);
+		goto get_reg_out_unlock;
+	} else if (err != 1) {
+		dev_err(ab3100_data->dev,
+			"write error (send register address) "
+			"%d bytes transferred (expected 1)\n",
+			err);
+		err = -EIO;
+		goto get_reg_out_unlock;
+	} else {
+		/* All is well */
+		err = 0;
+	}
+
+	err = i2c_master_recv(ab3100_data->i2c_client, regval, 1);
+	if (err < 0) {
+		dev_err(ab3100_data->dev,
+			"write error (read register): %d\n",
+			err);
+		goto get_reg_out_unlock;
+	} else if (err != 1) {
+		dev_err(ab3100_data->dev,
+			"write error (read register) "
+			"%d bytes transferred (expected 1)\n",
+			err);
+		err = -EIO;
+		goto get_reg_out_unlock;
+	} else {
+		/* All is well */
+		err = 0;
+	}
+
+ get_reg_out_unlock:
+	mutex_unlock(&ab3100_data->access_mutex);
+	return err;
+}
+EXPORT_SYMBOL(ab3100_get_register);
+
+int ab3100_get_register_page(struct ab3100 *ab3100_data,
+			     u8 first_reg, u8 *regvals, u8 numregs)
+{
+	int err;
+
+	if (ab3100_data->chip_id == 0xa0 ||
+	    ab3100_data->chip_id == 0xa1)
+		/* These don't support paged reads */
+		return -EIO;
+
+	err = mutex_lock_interruptible(&ab3100_data->access_mutex);
+	if (err)
+		return err;
+
+	/*
+	 * Paged read also require an I2C "stop" command.
+	 */
+	err = i2c_master_send(ab3100_data->i2c_client, &first_reg, 1);
+	if (err < 0) {
+		dev_err(ab3100_data->dev,
+			"write error (send first register address): %d\n",
+			err);
+		goto get_reg_page_out_unlock;
+	} else if (err != 1) {
+		dev_err(ab3100_data->dev,
+			"write error (send first register address) "
+			"%d bytes transferred (expected 1)\n",
+			err);
+		err = -EIO;
+		goto get_reg_page_out_unlock;
+	}
+
+	err = i2c_master_recv(ab3100_data->i2c_client, regvals, numregs);
+	if (err < 0) {
+		dev_err(ab3100_data->dev,
+			"write error (read register page): %d\n",
+			err);
+		goto get_reg_page_out_unlock;
+	} else if (err != numregs) {
+		dev_err(ab3100_data->dev,
+			"write error (read register page) "
+			"%d bytes transferred (expected %d)\n",
+			err, numregs);
+		err = -EIO;
+		goto get_reg_page_out_unlock;
+	}
+
+	/* All is well */
+	err = 0;
+
+ get_reg_page_out_unlock:
+	mutex_unlock(&ab3100_data->access_mutex);
+	return err;
+}
+EXPORT_SYMBOL(ab3100_get_register_page);
+
+int ab3100_mask_and_set_register(struct ab3100 *ab3100_data,
+				 u8 reg, u8 andmask, u8 ormask)
+{
+	u8 regandval[2] = {reg, 0};
+	int err;
+
+	err = mutex_lock_interruptible(&ab3100_data->access_mutex);
+	if (err)
+		return err;
+
+	/* First read out the target register */
+	err = i2c_master_send(ab3100_data->i2c_client, &reg, 1);
+	if (err < 0) {
+		dev_err(ab3100_data->dev,
+			"write error (maskset send address): %d\n",
+			err);
+		goto get_maskset_unlock;
+	} else if (err != 1) {
+		dev_err(ab3100_data->dev,
+			"write error (maskset send address) "
+			"%d bytes transferred (expected 1)\n",
+			err);
+		err = -EIO;
+		goto get_maskset_unlock;
+	}
+
+	err = i2c_master_recv(ab3100_data->i2c_client, &regandval[1], 1);
+	if (err < 0) {
+		dev_err(ab3100_data->dev,
+			"write error (maskset read register): %d\n",
+			err);
+		goto get_maskset_unlock;
+	} else if (err != 1) {
+		dev_err(ab3100_data->dev,
+			"write error (maskset read register) "
+			"%d bytes transferred (expected 1)\n",
+			err);
+		err = -EIO;
+		goto get_maskset_unlock;
+	}
+
+	/* Modify the register */
+	regandval[1] &= andmask;
+	regandval[1] |= ormask;
+
+	/* Write the register */
+	err = i2c_master_send(ab3100_data->i2c_client, regandval, 2);
+	if (err < 0) {
+		dev_err(ab3100_data->dev,
+			"write error (write register): %d\n",
+			err);
+		goto get_maskset_unlock;
+	} else if (err != 2) {
+		dev_err(ab3100_data->dev,
+			"write error (write register) "
+			"%d bytes transferred (expected 2)\n",
+			err);
+		err = -EIO;
+		goto get_maskset_unlock;
+	}
+
+	/* All is well */
+	err = 0;
+
+ get_maskset_unlock:
+	mutex_unlock(&ab3100_data->access_mutex);
+	return err;
+}
+EXPORT_SYMBOL(ab3100_mask_and_set_register);
+
+/*
+ * Register a simple callback for handling any AB3100 events.
+ */
+int ab3100_event_register(struct ab3100 *ab3100_data,
+			  struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&ab3100_data->event_subscribers,
+					       nb);
+}
+EXPORT_SYMBOL(ab3100_event_register);
+
+/*
+ * Remove a previously registered callback.
+ */
+int ab3100_event_unregister(struct ab3100 *ab3100_data,
+			    struct notifier_block *nb)
+{
+  return blocking_notifier_chain_unregister(&ab3100_data->event_subscribers,
+					    nb);
+}
+EXPORT_SYMBOL(ab3100_event_unregister);
+
+
+int ab3100_event_registers_startup_state_get(struct ab3100 *ab3100_data,
+					     u32 *fatevent)
+{
+	if (!ab3100_data->startup_events_read)
+		return -EAGAIN; /* Try again later */
+	*fatevent = ab3100_data->startup_events;
+	return 0;
+}
+EXPORT_SYMBOL(ab3100_event_registers_startup_state_get);
+
+/* Interrupt handling worker */
+static void ab3100_work(struct work_struct *work)
+{
+	u8 event_regs[3];
+	u32 fatevent;
+	int err;
+
+	err = ab3100_get_register_page(ab3100_local, AB3100_EVENTA1,
+				       event_regs, 3);
+	if (err)
+		goto err_event_wq;
+
+	fatevent = (event_regs[0] << 16) |
+		(event_regs[1] << 8) |
+		event_regs[2];
+
+	if (!ab3100_local->startup_events_read) {
+		ab3100_local->startup_events = fatevent;
+		ab3100_local->startup_events_read = true;
+	}
+	/*
+	 * The notified parties will have to mask out the events
+	 * they're interested in and react to them. They will be
+	 * notified on all events, then they use the fatevent value
+	 * to determine if they're interested.
+	 */
+	blocking_notifier_call_chain(&ab3100_local->event_subscribers,
+				     fatevent, NULL);
+
+	dev_dbg(ab3100_local->dev,
+		"IRQ Event: 0x%08x\n", fatevent);
+
+	/* By now the IRQ should be acked and deasserted so enable it again */
+	enable_irq(ab3100_local->i2c_client->irq);
+	return;
+
+ err_event_wq:
+	dev_dbg(ab3100_local->dev,
+		"error in event workqueue\n");
+	/* Enable the IRQ anyway, what choice do we have? */
+	enable_irq(ab3100_local->i2c_client->irq);
+	return;
+}
+
+static irqreturn_t ab3100_irq_handler(int irq, void *data)
+{
+	/*
+	 * Disable the IRQ and dispatch a worker to handle the
+	 * event. Since the chip resides on I2C this is slow
+	 * stuff and we will re-enable the interrupts once th
+	 * worker has finished.
+	 */
+	disable_irq(ab3100_local->i2c_client->irq);
+	schedule_work(&ab3100_local->work);
+	return IRQ_HANDLED;
+}
+
+#ifdef CONFIG_DEBUG_FS
+/*
+ * Some debugfs entries only exposed if we're using debug
+ */
+static int ab3100_registers_print(struct seq_file *s, void *p)
+{
+	u8 value;
+	u8 reg;
+
+	seq_printf(s, "AB3100 registers:\n");
+
+	for (reg = 0; reg < 0xff; reg++) {
+		ab3100_get_register(ab3100_local, reg, &value);
+		seq_printf(s, "[0x%x]:  0x%x\n", reg, value);
+	}
+	return 0;
+}
+
+static int ab3100_registers_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab3100_registers_print, inode->i_private);
+}
+
+static const struct file_operations ab3100_registers_fops = {
+	.open = ab3100_registers_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab3100_get_set_reg_open_file(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static int ab3100_get_set_reg(struct file *file,
+			      const char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	int mode = (int) file->private_data;
+	char buf[32];
+	int buf_size;
+	int regp;
+	unsigned long user_reg;
+	int err;
+	int i = 0;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	/*
+	 * The idea is here to parse a string which is either
+	 * "0xnn" for reading a register, or "0xaa 0xbb" for
+	 * writing 0xbb to the register 0xaa. First move past
+	 * whitespace and then begin to parse the register.
+	 */
+	while ((i < buf_size) && (buf[i] == ' '))
+		i++;
+	regp = i;
+
+	/*
+	 * Advance pointer to end of string then terminate
+	 * the register string. This is needed to satisfy
+	 * the strict_strtoul() function.
+	 */
+	while ((i < buf_size) && (buf[i] != ' '))
+		i++;
+	buf[i] = '\0';
+
+	err = strict_strtoul(&buf[regp], 16, &user_reg);
+	if (err)
+		return err;
+	if (user_reg > 0xff)
+		return -EINVAL;
+
+	/* Either we read or we write a register here */
+	if (!mode) {
+		/* Reading */
+		u8 reg = (u8) user_reg;
+		u8 regvalue;
+
+		ab3100_get_register(ab3100_local, reg, &regvalue);
+
+		dev_info(ab3100_local->dev,
+			 "debug read AB3100 reg[0x%02x]: 0x%02x\n",
+			 reg, regvalue);
+	} else {
+		int valp;
+		unsigned long user_value;
+		u8 reg = (u8) user_reg;
+		u8 value;
+		u8 regvalue;
+
+		/*
+		 * Writing, we need some value to write to
+		 * the register so keep parsing the string
+		 * from userspace.
+		 */
+		i++;
+		while ((i < buf_size) && (buf[i] == ' '))
+			i++;
+		valp = i;
+		while ((i < buf_size) && (buf[i] != ' '))
+			i++;
+		buf[i] = '\0';
+
+		err = strict_strtoul(&buf[valp], 16, &user_value);
+		if (err)
+			return err;
+		if (user_reg > 0xff)
+			return -EINVAL;
+
+		value = (u8) user_value;
+		ab3100_set_register(ab3100_local, reg, value);
+		ab3100_get_register(ab3100_local, reg, &regvalue);
+
+		dev_info(ab3100_local->dev,
+			 "debug write reg[0x%02x] with 0x%02x, "
+			 "after readback: 0x%02x\n",
+			 reg, value, regvalue);
+	}
+	return buf_size;
+}
+
+static const struct file_operations ab3100_get_set_reg_fops = {
+	.open = ab3100_get_set_reg_open_file,
+	.write = ab3100_get_set_reg,
+};
+
+static struct dentry *ab3100_dir;
+static struct dentry *ab3100_reg_file;
+static struct dentry *ab3100_get_reg_file;
+static struct dentry *ab3100_set_reg_file;
+
+static void ab3100_setup_debugfs(void)
+{
+	int err;
+
+	ab3100_dir = debugfs_create_dir("ab3100", NULL);
+	if (!ab3100_dir)
+		goto exit_no_debugfs;
+
+	ab3100_reg_file = debugfs_create_file("registers",
+				S_IRUGO, ab3100_dir, NULL,
+				&ab3100_registers_fops);
+	if (!ab3100_reg_file) {
+		err = -ENOMEM;
+		goto exit_destroy_dir;
+	}
+
+	ab3100_get_reg_file = debugfs_create_file("get_reg",
+				S_IRUGO, ab3100_dir, (void *) 0,
+				&ab3100_get_set_reg_fops);
+	if (!ab3100_get_reg_file) {
+		err = -ENOMEM;
+		goto exit_destroy_reg;
+	}
+
+	ab3100_set_reg_file = debugfs_create_file("set_reg",
+				S_IRUGO, ab3100_dir, (void *) 1,
+				&ab3100_get_set_reg_fops);
+	if (!ab3100_set_reg_file) {
+		err = -ENOMEM;
+		goto exit_destroy_get_reg;
+	}
+	return;
+
+ exit_destroy_get_reg:
+	debugfs_remove(ab3100_get_reg_file);
+ exit_destroy_reg:
+	debugfs_remove(ab3100_reg_file);
+ exit_destroy_dir:
+	debugfs_remove(ab3100_dir);
+ exit_no_debugfs:
+	return;
+}
+static inline void ab3100_remove_debugfs(void)
+{
+	debugfs_remove(ab3100_set_reg_file);
+	debugfs_remove(ab3100_get_reg_file);
+	debugfs_remove(ab3100_reg_file);
+	debugfs_remove(ab3100_dir);
+}
+#else
+static inline void ab3100_setup_debugfs(void)
+{
+}
+static inline void ab3100_remove_debugfs(void)
+{
+}
+#endif
+
+/*
+ * Basic set-up, datastructure creation/destruction and I2C interface.
+ * This sets up a default config in the AB3100 chip so that it
+ * will work as expected.
+ */
+
+struct ab3100_init_setting {
+	u8 abreg;
+	u8 setting;
+};
+
+static const struct ab3100_init_setting __initdata
+ab3100_init_settings[] = {
+	{
+		.abreg = AB3100_MCA,
+		.setting = 0x01
+	}, {
+		.abreg = AB3100_MCB,
+		.setting = 0x30
+	}, {
+		.abreg = AB3100_IMRA1,
+		.setting = 0x00
+	}, {
+		.abreg = AB3100_IMRA2,
+		.setting = 0xFF
+	}, {
+		.abreg = AB3100_IMRA3,
+		.setting = 0x01
+	}, {
+		.abreg = AB3100_IMRB1,
+		.setting = 0xFF
+	}, {
+		.abreg = AB3100_IMRB2,
+		.setting = 0xFF
+	}, {
+		.abreg = AB3100_IMRB3,
+		.setting = 0xFF
+	}, {
+		.abreg = AB3100_SUP,
+		.setting = 0x00
+	}, {
+		.abreg = AB3100_DIS,
+		.setting = 0xF0
+	}, {
+		.abreg = AB3100_D0C,
+		.setting = 0x00
+	}, {
+		.abreg = AB3100_D1C,
+		.setting = 0x00
+	}, {
+		.abreg = AB3100_D2C,
+		.setting = 0x00
+	}, {
+		.abreg = AB3100_D3C,
+		.setting = 0x00
+	},
+};
+
+static int __init ab3100_setup(void)
+{
+	int err = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ab3100_init_settings); i++) {
+		err = ab3100_set_register(ab3100_local,
+					  ab3100_init_settings[i].abreg,
+					  ab3100_init_settings[i].setting);
+		if (err)
+			goto exit_no_setup;
+	}
+
+	/*
+	 * Special trick to make the AB3100 use the 32kHz clock (RTC)
+	 * bit 3 in test registe 0x02 is a special, undocumented test
+	 * register bit that only exist in AB3100 P1E
+	 */
+	if (ab3100_local->chip_id == 0xc4) {
+		dev_warn(ab3100_local->dev,
+			 "AB3100 P1E variant detected, "
+			 "forcing chip to 32KHz\n");
+		err = ab3100_set_test_register(0x02, 0x08);
+	}
+
+ exit_no_setup:
+	return err;
+}
+
+/*
+ * Here we define all the platform devices that appear
+ * as children of the AB3100. These are regular platform
+ * devices with the IORESOURCE_IO .start and .end set
+ * to correspond to the internal AB3100 register range
+ * mapping to the corresponding subdevice.
+ */
+
+#define AB3100_DEVICE(devname, devid)				\
+static struct platform_device ab3100_##devname##_device = {	\
+	.name		= devid,				\
+	.id		= -1,					\
+}
+
+/*
+ * This lists all the subdevices and corresponding register
+ * ranges.
+ */
+AB3100_DEVICE(dac, "ab3100-dac");
+AB3100_DEVICE(leds, "ab3100-leds");
+AB3100_DEVICE(power, "ab3100-power");
+AB3100_DEVICE(regulators, "ab3100-regulators");
+AB3100_DEVICE(sim, "ab3100-sim");
+AB3100_DEVICE(uart, "ab3100-uart");
+AB3100_DEVICE(rtc, "ab3100-rtc");
+AB3100_DEVICE(charger, "ab3100-charger");
+AB3100_DEVICE(boost, "ab3100-boost");
+AB3100_DEVICE(adc, "ab3100-adc");
+AB3100_DEVICE(fuelgauge, "ab3100-fuelgauge");
+AB3100_DEVICE(vibrator, "ab3100-vibrator");
+AB3100_DEVICE(otp, "ab3100-otp");
+AB3100_DEVICE(codec, "ab3100-codec");
+
+static struct platform_device *
+ab3100_platform_devs[] = {
+	&ab3100_dac_device,
+	&ab3100_leds_device,
+	&ab3100_power_device,
+	&ab3100_regulators_device,
+	&ab3100_sim_device,
+	&ab3100_uart_device,
+	&ab3100_rtc_device,
+	&ab3100_charger_device,
+	&ab3100_boost_device,
+	&ab3100_adc_device,
+	&ab3100_fuelgauge_device,
+	&ab3100_vibrator_device,
+	&ab3100_otp_device,
+	&ab3100_codec_device,
+};
+
+struct ab_family_id {
+	u8	id;
+	char	*name;
+};
+
+static const struct ab_family_id ids[] __initdata = {
+	/* AB3100 */
+	{
+		.id = 0xc0,
+		.name = "P1A"
+	}, {
+		.id = 0xc1,
+		.name = "P1B"
+	}, {
+		.id = 0xc2,
+		.name = "P1C"
+	}, {
+		.id = 0xc3,
+		.name = "P1D"
+	}, {
+		.id = 0xc4,
+		.name = "P1E"
+	}, {
+		.id = 0xc5,
+		.name = "P1F/R1A"
+	}, {
+		.id = 0xc6,
+		.name = "P1G/R1A"
+	}, {
+		.id = 0xc7,
+		.name = "P2A/R2A"
+	}, {
+		.id = 0xc8,
+		.name = "P2B/R2B"
+	},
+	/* AB3000 variants, not supported */
+	{
+		.id = 0xa0
+	}, {
+		.id = 0xa1
+	}, {
+		.id = 0xa2
+	}, {
+		.id = 0xa3
+	}, {
+		.id = 0xa4
+	}, {
+		.id = 0xa5
+	}, {
+		.id = 0xa6
+	}, {
+		.id = 0xa7
+	},
+	/* Terminator */
+	{
+		.id = 0x00,
+	},
+};
+
+static int __init ab3100_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	int err;
+	int i;
+
+	ab3100_local = kzalloc(sizeof(struct ab3100), GFP_KERNEL);
+	if (!ab3100_local) {
+		dev_err(&client->dev, "could not allocate AB3100 device\n");
+		return -ENOMEM;
+	}
+
+	/* Initialize data structure */
+	mutex_init(&ab3100_local->access_mutex);
+	BLOCKING_INIT_NOTIFIER_HEAD(&ab3100_local->event_subscribers);
+
+	ab3100_local->i2c_client = client;
+	ab3100_local->dev = &ab3100_local->i2c_client->dev;
+
+	/* Read chip ID register */
+	err = ab3100_get_register(ab3100_local, AB3100_CID,
+				  &ab3100_local->chip_id);
+	if (err) {
+		dev_err(&client->dev,
+			"could not communicate with the AB3100 analog "
+			"baseband chip\n");
+		goto exit_no_detect;
+	}
+
+	for (i = 0; ids[i].id != 0x0; i++) {
+		if (ids[i].id == ab3100_local->chip_id) {
+			if (ids[i].name != NULL) {
+				snprintf(&ab3100_local->chip_name[0],
+					 sizeof(ab3100_local->chip_name) - 1,
+					 "AB3100 %s",
+					 ids[i].name);
+				break;
+			} else {
+				dev_err(&client->dev,
+					"AB3000 is not supported\n");
+				goto exit_no_detect;
+			}
+		}
+	}
+
+	if (ids[i].id == 0x0) {
+		dev_err(&client->dev, "unknown analog baseband chip id: 0x%x\n",
+			ab3100_local->chip_id);
+		dev_err(&client->dev, "accepting it anyway. Please update "
+			"the driver.\n");
+		goto exit_no_detect;
+	}
+
+	dev_info(&client->dev, "Detected chip: %s\n",
+		 &ab3100_local->chip_name[0]);
+
+	/* Attach a second dummy i2c_client to the test register address */
+	ab3100_local->testreg_client = i2c_new_dummy(client->adapter,
+						     client->addr + 1);
+	if (!ab3100_local->testreg_client) {
+		err = -ENOMEM;
+		goto exit_no_testreg_client;
+	}
+
+	strlcpy(ab3100_local->testreg_client->name, id->name,
+		sizeof(ab3100_local->testreg_client->name));
+
+	err = ab3100_setup();
+	if (err)
+		goto exit_no_setup;
+
+	INIT_WORK(&ab3100_local->work, ab3100_work);
+
+	/* This real unpredictable IRQ is of course sampled for entropy */
+	err = request_irq(client->irq, ab3100_irq_handler,
+			  IRQF_DISABLED | IRQF_SAMPLE_RANDOM,
+			  "AB3100 IRQ", ab3100_local);
+	if (err)
+		goto exit_no_irq;
+
+	/* Set parent and a pointer back to the container in device data */
+	for (i = 0; i < ARRAY_SIZE(ab3100_platform_devs); i++) {
+		ab3100_platform_devs[i]->dev.parent =
+			&client->dev;
+		platform_set_drvdata(ab3100_platform_devs[i], ab3100_local);
+	}
+
+	/* Register the platform devices */
+	platform_add_devices(ab3100_platform_devs,
+			     ARRAY_SIZE(ab3100_platform_devs));
+
+	ab3100_setup_debugfs();
+
+	return 0;
+
+ exit_no_irq:
+ exit_no_setup:
+	i2c_unregister_device(ab3100_local->testreg_client);
+ exit_no_testreg_client:
+ exit_no_detect:
+	kfree(ab3100_local);
+	return err;
+}
+
+static int __exit ab3100_remove(struct i2c_client *client)
+{
+	int i;
+
+	/* Unregister subdevices */
+	for (i = 0; i < ARRAY_SIZE(ab3100_platform_devs); i++)
+		platform_device_unregister(ab3100_platform_devs[i]);
+
+	ab3100_remove_debugfs();
+	i2c_unregister_device(ab3100_local->testreg_client);
+
+	/*
+	 * At this point, all subscribers should have unregistered
+	 * their notifiers so deactivate IRQ
+	 */
+	free_irq(client->irq, ab3100_local);
+	kfree(ab3100_local);
+	return 0;
+}
+
+static const struct i2c_device_id ab3100_id[] = {
+	{ "ab3100", ab3100 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ab3100_id);
+
+static struct i2c_driver ab3100_driver = {
+	.driver = {
+		.name	= "ab3100",
+		.owner	= THIS_MODULE,
+	},
+	.id_table	= ab3100_id,
+	.probe		= ab3100_probe,
+	.remove		= __exit_p(ab3100_remove),
+};
+
+static int __init ab3100_i2c_init(void)
+{
+	return i2c_add_driver(&ab3100_driver);
+}
+
+static void __exit ab3100_i2c_exit(void)
+{
+	i2c_del_driver(&ab3100_driver);
+}
+
+subsys_initcall(ab3100_i2c_init);
+module_exit(ab3100_i2c_exit);
+
+MODULE_AUTHOR("Linus Walleij <linus.walleij@stericsson.com>");
+MODULE_DESCRIPTION("AB3100 core driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/ab3100.h b/include/linux/mfd/ab3100.h
new file mode 100644
index 0000000..6b930d6
--- /dev/null
+++ b/include/linux/mfd/ab3100.h
@@ -0,0 +1,103 @@
+/*
+ * Copyright (C) 2007-2009 ST-Ericsson AB
+ * License terms: GNU General Public License (GPL) version 2
+ * AB3100 core access functions
+ * Author: Linus Walleij <linus.walleij@stericsson.com>
+ */
+
+#include <linux/device.h>
+
+#ifndef MFD_AB3100_H
+#define MFD_AB3100_H
+
+#define ABUNKNOWN	0
+#define	AB3000		1
+#define	AB3100		2
+
+/*
+ * AB3100, EVENTA1, A2 and A3 event register flags
+ * these are catenated into a single 32-bit flag in the code
+ * for event notification broadcasts.
+ */
+#define AB3100_EVENTA1_ONSWA				(0x01<<16)
+#define AB3100_EVENTA1_ONSWB				(0x02<<16)
+#define AB3100_EVENTA1_ONSWC				(0x04<<16)
+#define AB3100_EVENTA1_DCIO				(0x08<<16)
+#define AB3100_EVENTA1_OVER_TEMP			(0x10<<16)
+#define AB3100_EVENTA1_SIM_OFF				(0x20<<16)
+#define AB3100_EVENTA1_VBUS				(0x40<<16)
+#define AB3100_EVENTA1_VSET_USB				(0x80<<16)
+
+#define AB3100_EVENTA2_READY_TX				(0x01<<8)
+#define AB3100_EVENTA2_READY_RX				(0x02<<8)
+#define AB3100_EVENTA2_OVERRUN_ERROR			(0x04<<8)
+#define AB3100_EVENTA2_FRAMING_ERROR			(0x08<<8)
+#define AB3100_EVENTA2_CHARG_OVERCURRENT		(0x10<<8)
+#define AB3100_EVENTA2_MIDR				(0x20<<8)
+#define AB3100_EVENTA2_BATTERY_REM			(0x40<<8)
+#define AB3100_EVENTA2_ALARM				(0x80<<8)
+
+#define AB3100_EVENTA3_ADC_TRIG5			(0x01)
+#define AB3100_EVENTA3_ADC_TRIG4			(0x02)
+#define AB3100_EVENTA3_ADC_TRIG3			(0x04)
+#define AB3100_EVENTA3_ADC_TRIG2			(0x08)
+#define AB3100_EVENTA3_ADC_TRIGVBAT			(0x10)
+#define AB3100_EVENTA3_ADC_TRIGVTX			(0x20)
+#define AB3100_EVENTA3_ADC_TRIG1			(0x40)
+#define AB3100_EVENTA3_ADC_TRIG0			(0x80)
+
+/* AB3100, STR register flags */
+#define AB3100_STR_ONSWA				(0x01)
+#define AB3100_STR_ONSWB				(0x02)
+#define AB3100_STR_ONSWC				(0x04)
+#define AB3100_STR_DCIO					(0x08)
+#define AB3100_STR_BOOT_MODE				(0x10)
+#define AB3100_STR_SIM_OFF				(0x20)
+#define AB3100_STR_BATT_REMOVAL				(0x40)
+#define AB3100_STR_VBUS					(0x80)
+
+/**
+ * struct ab3100
+ * @access_mutex: lock out concurrent accesses to the AB3100 registers
+ * @dev: pointer to the containing device
+ * @i2c_client: I2C client for this chip
+ * @testreg_client: secondary client for test registers
+ * @chip_name: name of this chip variant
+ * @chip_id: 8 bit chip ID for this chip variant
+ * @work: an event handling worker
+ * @event_subscribers: event subscribers are listed here
+ * @startup_events: a copy of the first reading of the event registers
+ * @startup_events_read: whether the first events have been read
+ *
+ * This struct is PRIVATE and devices using it should NOT
+ * access ANY fields. It is used as a token for calling the
+ * AB3100 functions.
+ */
+struct ab3100 {
+	struct mutex access_mutex;
+	struct device *dev;
+	struct i2c_client *i2c_client;
+	struct i2c_client *testreg_client;
+	char chip_name[32];
+	u8 chip_id;
+	struct work_struct work;
+	struct blocking_notifier_head event_subscribers;
+	u32 startup_events;
+	bool startup_events_read;
+};
+
+int ab3100_set_register(struct ab3100 *ab3100_data, u8 reg, u8 regval);
+int ab3100_get_register(struct ab3100 *ab3100_data, u8 reg, u8 *regval);
+int ab3100_get_register_page(struct ab3100 *ab3100_data,
+			     u8 first_reg, u8 *regvals, u8 numregs);
+int ab3100_mask_and_set_register(struct ab3100 *ab3100_data,
+				 u8 reg, u8 andmask, u8 ormask);
+u8 ab3100_get_chip_type(struct ab3100 *ab3100_data);
+int ab3100_event_register(struct ab3100 *ab3100_data,
+			  struct notifier_block *nb);
+int ab3100_event_unregister(struct ab3100 *ab3100_data,
+			    struct notifier_block *nb);
+int ab3100_event_registers_startup_state_get(struct ab3100 *ab3100_data,
+					     u32 *fatevent);
+
+#endif
-- 
1.6.2.1
