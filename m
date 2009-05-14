Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbZENI3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbZENI3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 04:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbZENI3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 04:29:10 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35883 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbZENI3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 04:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nFddnmnLDIzb197RJotSttTA5LOwM/WI0C+2CN5fe645SkEWHwjWdyJp4jLkfJDo6q
         0g1Op9jqWNQeFlqb4g7WhMlow/+3VudEy+5xnFPyRPiwwbDVwMivzGs9Ntzvk5p4n0Fh
         NydHqvMEw2WG5H1Kxm2gSPEWmHvMVojhWvNG0=
MIME-Version: 1.0
Date: Thu, 14 May 2009 10:29:02 +0200
Message-ID: <63386a3d0905140129s5fd0f32cxde1114489678f012@mail.gmail.com>
Subject: [PATCH] MFD: Add U300 AB3100 core support v1
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
---
 drivers/mfd/Kconfig        |   14 +
 drivers/mfd/Makefile       |    3 +-
 drivers/mfd/ab3100-core.c  |  859 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/ab3100.h |   73 ++++
 4 files changed, 948 insertions(+), 1 deletions(-)
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
index 0000000..8961a4c
--- /dev/null
+++ b/drivers/mfd/ab3100-core.c
@@ -0,0 +1,856 @@
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
+#include <linux/err.h>
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
+/* Initial settings of ab3100 registers */
+#define DIS_SETTING		0xF0
+#define D0C_SETTING		0x00
+#define D1C_SETTING		0x00
+#define D2C_SETTING		0x00
+#define D3C_SETTING		0x00
+
+#define IMRA1_SETTING		0x00
+#define IMRA2_SETTING		0xFF
+#define IMRA3_SETTING		0x01
+#define IMRB1_SETTING		0xFF
+#define IMRB2_SETTING		0xFF
+#define IMRB3_SETTING		0xFF
+#define MCB_SETTING		0x30
+#define SUP_SETTING		0x00
+
+/*
+ * I2C communication
+ *
+ * The AB3100 is assigned address 0x48 (7-bit)
+ * Since the driver does not require SMBus support, we
+ * cannot be sure to probe for the device address here,
+ * so the boot loader or modprobe may need to pass in a parameter
+ * like ab3100-core.force=0,0x48.
+ *
+ */
+static unsigned short normal_i2c[] = { 0x48, I2C_CLIENT_END };
+I2C_CLIENT_INSMOD_1(ab3100);
+
+/* Whether the chip has been initialized */
+static bool ab3100_initialized;
+/* Lock out concurrent accesses to the AB3100 registers */
+static DEFINE_MUTEX(ab3100_access_mutex);
+/* Self describing stuff */
+static struct i2c_client *ab3100_i2c_client;
+static char ab3100_chip_name[32];
+static u8 ab3100_chip_id;
+
+/* Event handling */
+struct event {
+	struct list_head node;
+	struct device *dev;
+	struct ab3100_event_mask event_mask;
+	void *client_data;
+	void (*cb_handler)(struct ab3100_event_mask, void *client_data);
+};
+/* The event list */
+static DEFINE_MUTEX(event_list_mutex);
+static LIST_HEAD(subscribers);
+/* Save the first reading of the event registers */
+static struct ab3100_event_mask startup_event_mask;
+static bool startup_events_read;
+
+u8 ab3100_get_chip_type()
+{
+	u8 chip = ABUNKNOWN;
+
+	switch (ab3100_chip_id & 0xf0) {
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
+int ab3100_set_register(u8 reg, u8 regval)
+{
+	u8 regandval[2] = {reg, regval};
+	struct i2c_msg msgs[1];
+	int err = 0;
+
+	if (!ab3100_initialized)
+		return -ENODEV;
+
+	msgs[0].addr = ab3100_i2c_client->addr;
+	msgs[0].flags = 0;
+	msgs[0].len = 2;
+	msgs[0].buf = regandval;
+	err = mutex_lock_interruptible(&ab3100_access_mutex);
+	if (err)
+		return err;
+
+	/*
+	 * A two-byte write message with the first byte containing the register
+	 * number and the second byte containing the value to be written
+	 * effectively sets a register in the AB3100.
+	 */
+	if ((i2c_transfer(ab3100_i2c_client->adapter,
+					&msgs[0], 1)) != 1) {
+		dev_err(&ab3100_i2c_client->dev,
+				"%s: write error (write register)\n",
+				__func__);
+		err = -EIO;
+	}
+	mutex_unlock(&ab3100_access_mutex);
+	return err;
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
+	struct i2c_msg msgs[1];
+	int err = 0;
+
+	if (!ab3100_initialized)
+		return -ENODEV;
+
+	msgs[0].addr = ab3100_i2c_client->addr + 1;
+	msgs[0].flags = 0;
+	msgs[0].len = 2;
+	msgs[0].buf = regandval;
+	err = mutex_lock_interruptible(&ab3100_access_mutex);
+	if (err)
+		return err;
+
+	/*
+	 * A two-byte write message with the first byte containing the register
+	 * number and the second byte containing the value to be written
+	 * effectively sets a register in the AB3100.
+	 */
+	if ((i2c_transfer(ab3100_i2c_client->adapter,
+			  &msgs[0], 1)) != 1) {
+		dev_err(&ab3100_i2c_client->dev,
+			"%s: write error (write test register)\n",
+			__func__);
+		err = -EIO;
+	}
+	mutex_unlock(&ab3100_access_mutex);
+	return err;
+}
+
+int ab3100_get_register(u8 reg, u8 *regval)
+{
+	int err = 0;
+	struct i2c_msg msgs[2];
+
+	if (!ab3100_initialized)
+		return -ENODEV;
+
+	msgs[0].addr = ab3100_i2c_client->addr;
+	msgs[0].flags = 0;
+	msgs[0].len = 1;
+	msgs[0].buf = &reg;
+	msgs[1].addr = ab3100_i2c_client->addr;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = 1;
+	msgs[1].buf = regval;
+
+	err = mutex_lock_interruptible(&ab3100_access_mutex);
+	if (err)
+		return err;
+
+	/*
+	 * AB3100 require an I2C "stop" command between each message, else
+	 * it will not work. The only way of achieveing this with the
+	 * message transport layer is to send the read and write messages
+	 * separately.
+	 */
+	if ((i2c_transfer(ab3100_i2c_client->adapter, &msgs[0], 1))
+			!= 1) {
+		dev_err(&ab3100_i2c_client->dev,
+				"%s: read error (send register address)\n",
+				__func__);
+		err = -EIO;
+		goto get_reg_out_unlock;
+	}
+	if ((i2c_transfer(ab3100_i2c_client->adapter, &msgs[1], 1))
+			!= 1) {
+		dev_err(&ab3100_i2c_client->dev,
+				"%s: read error (read register value)\n",
+				__func__);
+		err = -EIO;
+	}
+ get_reg_out_unlock:
+	mutex_unlock(&ab3100_access_mutex);
+	return err;
+}
+EXPORT_SYMBOL(ab3100_get_register);
+
+int ab3100_get_register_page(u8 first_reg, u8 *regvals, u8 numregs)
+{
+	int err = 0;
+	struct i2c_msg msgs[] = {
+		{ 0, 0, 1, &first_reg },
+		{ 0, I2C_M_RD, numregs, regvals },
+	};
+
+	msgs[0].addr = ab3100_i2c_client->addr;
+	msgs[1].addr = ab3100_i2c_client->addr;
+
+	if (ab3100_chip_id == 0xa0 ||
+	    ab3100_chip_id == 0xa1)
+		/* These don't support paged reads */
+		return -EIO;
+
+	err = mutex_lock_interruptible(&ab3100_access_mutex);
+	if (err)
+		return err;
+
+	/*
+	 * Paged read also require an I2C "stop" command.
+	 */
+	if ((i2c_transfer(ab3100_i2c_client->adapter, &msgs[0], 1))
+	    != 1) {
+		dev_err(&ab3100_i2c_client->dev,
+			"%s: read error (paged send first register address)\n",
+			__func__);
+		err = -EIO;
+		goto get_reg_page_out_unlock;
+	}
+	if ((i2c_transfer(ab3100_i2c_client->adapter, &msgs[1], 1))
+	    != 1) {
+		dev_err(&ab3100_i2c_client->dev,
+			"%s: read error (paged read register values)\n",
+			__func__);
+		err = -EIO;
+	}
+ get_reg_page_out_unlock:
+	mutex_unlock(&ab3100_access_mutex);
+	return err;
+}
+EXPORT_SYMBOL(ab3100_get_register_page);
+
+int ab3100_mask_and_set_register(u8 reg, u8 andmask, u8 ormask)
+{
+	u8 regval;
+	int err = 0;
+
+	err = ab3100_get_register(reg, &regval);
+	if (err)
+		return err;
+
+	regval &= andmask;
+	regval |= ormask;
+
+	err = ab3100_set_register(reg, regval);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL(ab3100_mask_and_set_register);
+
+/*
+ * Register a simple callback for handling any AB3100 events.
+ */
+int ab3100_event_cb_register(struct device *dev,
+			     void (*cb_handler)
+			     (struct ab3100_event_mask, void *client_data),
+			     struct ab3100_event_mask *subscribe_mask,
+			     void *client_data)
+{
+	struct event *p;
+
+	if ((dev == NULL) ||
+	    ((subscribe_mask->event1 == 0) &&
+	     (subscribe_mask->event2 == 0) &&
+	     (subscribe_mask->event3 == 0)) ||
+	    cb_handler == NULL)
+		return -EINVAL;
+
+	p = kmalloc(sizeof(struct event), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	p->dev = dev;
+	p->cb_handler = cb_handler;
+	memcpy(&p->event_mask, subscribe_mask,
+	       sizeof(struct ab3100_event_mask));
+	p->client_data = client_data;
+
+	mutex_lock(&event_list_mutex);
+	list_add_tail(&p->node, &subscribers);
+	mutex_unlock(&event_list_mutex);
+	return 0;
+}
+EXPORT_SYMBOL(ab3100_event_cb_register);
+
+/*
+ * Remove a previously registered callback.
+ */
+int ab3100_event_cb_unregister(struct device *dev)
+{
+	int err = -ENOENT;
+	struct event *e;
+
+	mutex_lock(&event_list_mutex);
+	list_for_each_entry(e, &subscribers, node) {
+		if (e->dev == dev) {
+			/* Found a client subscription => remove it */
+			list_del(&e->node);
+			kfree(e);
+			err = 0;
+		}
+	}
+	mutex_unlock(&event_list_mutex);
+
+	return err;
+}
+EXPORT_SYMBOL(ab3100_event_cb_unregister);
+
+
+int ab3100_event_registers_startup_state_get(struct ab3100_event_mask
+					     *event_mask)
+{
+	if (!startup_events_read)
+		return -EAGAIN; /* Try again later */
+	memcpy(event_mask, &startup_event_mask,
+	       sizeof(struct ab3100_event_mask));
+
+	return 0;
+}
+EXPORT_SYMBOL(ab3100_event_registers_startup_state_get);
+
+/* Interrupt handling worker */
+static void ab3100_work_cb(struct work_struct *work)
+{
+	struct event *e;
+	u8 event_regs[3];
+	struct ab3100_event_mask event_mask;
+	int err;
+
+	err = ab3100_get_register_page(AB3100_EVENTA1, event_regs, 3);
+	if (err)
+		goto err_event_wq;
+
+	event_mask.event1 = event_regs[0];
+	event_mask.event2 = event_regs[1];
+	event_mask.event3 = event_regs[2];
+
+	if (!startup_events_read) {
+		/* Save the first reading for detecting startup cause etc */
+		memcpy(&startup_event_mask, &event_mask,
+		       sizeof(struct ab3100_event_mask));
+		startup_events_read = true;
+	}
+
+	/* Go through list of susbscribers */
+	mutex_lock(&event_list_mutex);
+	list_for_each_entry(e, &subscribers, node) {
+		/* Check if the client should be notified */
+		if ((e->event_mask.event1 & event_mask.event1) ||
+		    (e->event_mask.event2 & event_mask.event2) ||
+		    (e->event_mask.event3 & event_mask.event3)) {
+			e->cb_handler(event_mask, e->client_data);
+		}
+	}
+	mutex_unlock(&event_list_mutex);
+
+	dev_dbg(&ab3100_i2c_client->dev,
+		"IRQ Event: 0x%x 0x%x 0x%x\n",
+		event_regs[0], event_regs[1], event_regs[2]);
+
+	enable_irq(ab3100_i2c_client->irq);
+	return;
+
+ err_event_wq:
+	dev_dbg(&ab3100_i2c_client->dev,
+		"error in event workqueue\n");
+	/* Enable the IRQ anyway, what choice do we have? */
+	enable_irq(ab3100_i2c_client->irq);
+	return;
+}
+static DECLARE_WORK(ab3100_work, &ab3100_work_cb);
+
+static irqreturn_t ab3100_irq_handler(int irq, void *data)
+{
+	/*
+	 * Disable the IRQ and dispatch a worker to handle the
+	 * event. Since the chip resides on I2C this is slow
+	 * stuff and we will re-enable the interrupts once th
+	 * worker has finished.
+	 */
+	disable_irq(ab3100_i2c_client->irq);
+	schedule_work(&ab3100_work);
+	return IRQ_HANDLED;
+}
+
+#if defined(CONFIG_U300_DEBUG) && defined(CONFIG_DEBUG_FS)
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
+		ab3100_get_register(reg, &value);
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
+static struct file_operations ab3100_registers_fops = {
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
+		ab3100_get_register(reg, &regvalue);
+
+		dev_info(&ab3100_i2c_client->dev,
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
+		ab3100_set_register(reg, value);
+		ab3100_get_register(reg, &regvalue);
+
+		dev_info(&ab3100_i2c_client->dev,
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
+static int __init ab3100_setup(void)
+{
+	int err = 0;
+
+	/* Force internal oscillator */
+	err = ab3100_set_register(AB3100_MCA, 0x01);
+	if (err)
+		goto exit_no_setup;
+
+	err = ab3100_set_register(AB3100_MCB, MCB_SETTING);
+	if (err)
+		goto exit_no_setup;
+
+	err = ab3100_set_register(AB3100_IMRA1, IMRA1_SETTING);
+	if (err)
+		goto exit_no_setup;
+
+	err = ab3100_set_register(AB3100_IMRA2, IMRA2_SETTING);
+	if (err)
+		goto exit_no_setup;
+
+	err = ab3100_set_register(AB3100_IMRA3, IMRA3_SETTING);
+	if (err)
+		goto exit_no_setup;
+
+	err = ab3100_set_register(AB3100_IMRB1, IMRB1_SETTING);
+	if (err)
+		goto exit_no_setup;
+
+	err = ab3100_set_register(AB3100_IMRB2, IMRB2_SETTING);
+	if (err)
+		goto exit_no_setup;
+
+	err = ab3100_set_register(AB3100_IMRB3, IMRB3_SETTING);
+	if (err)
+		goto exit_no_setup;
+
+	err = ab3100_set_register(AB3100_SUP, SUP_SETTING);
+	if (err)
+		goto exit_no_setup;
+
+	err = ab3100_set_register(AB3100_DIS, DIS_SETTING);
+	if (err)
+		goto exit_no_setup;
+
+	err = ab3100_set_register(AB3100_D0C, D0C_SETTING);
+	if (err)
+		goto exit_no_setup;
+
+	err = ab3100_set_register(AB3100_D1C, D1C_SETTING);
+	if (err)
+		goto exit_no_setup;
+
+	err = ab3100_set_register(AB3100_D2C, D2C_SETTING);
+	if (err)
+		goto exit_no_setup;
+
+	err = ab3100_set_register(AB3100_D3C, D3C_SETTING);
+	if (err)
+		goto exit_no_setup;
+
+	/*
+	 * Special trick to make the AB3100 use the 32kHz clock (RTC)
+	 * bit 3 in test registe 0x02 is a special, undocumented test
+	 * register bit that only exist in AB3100 P1E
+	 */
+	if (ab3100_chip_id == 0xc4) {
+		dev_warn(&ab3100_i2c_client->dev,
+			 "AB3100 P1E variant detected, "
+			 "forcing chip to 32KHz\n");
+		err = ab3100_set_test_register(0x02, 0x08);
+	}
+
+ exit_no_setup:
+	return err;
+}
+
+struct ab_family_id {
+	u8	id;
+	char	*name;
+};
+
+const struct ab_family_id ids[] __initdata = {
+	{0xc0, "P1A"}, /* AB3100 */
+	{0xc1, "P1B"},
+	{0xc2, "P1C"},
+	{0xc3, "P1D"},
+	{0xc4, "P1E"},
+	{0xc5, "P1F/R1A"},
+	{0xc6, "P1G/R1A"},
+	{0xc7, "P2A/R2A"},
+	{0xc8, "P2B/R2B"},
+	{0xa0, NULL}, /* AB3000 */
+	{0xa1, NULL},
+	{0xa2, NULL},
+	{0xa3, NULL},
+	{0xa4, NULL},
+	{0xa5, NULL},
+	{0xa6, NULL},
+	{0xa7, NULL},
+	{0x00, NULL}
+};
+
+static int __init ab3100_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	int err;
+	int i;
+
+	ab3100_i2c_client = client;
+	ab3100_initialized = true;
+
+	/* Read chip ID register */
+	err = ab3100_get_register(AB3100_CID, &ab3100_chip_id);
+	if (err) {
+		dev_err(&client->dev,
+			"could not detect i2c bus for AB3100 analog"
+			"baseband chip\n");
+		goto exit_no_detect;
+	}
+
+	for (i = 0; ids[i].id != 0x0; i++) {
+		if (ids[i].id == ab3100_chip_id) {
+			if (ids[i].name != NULL) {
+				snprintf(&ab3100_chip_name[0], 31, "AB3100 %s",
+					 ids[i].name);
+				break;
+			} else {
+				dev_err(&client->dev,
+					"AB3000 is no longer supported\n");
+				goto exit_no_detect;
+			}
+		}
+	}
+
+	if (ids[i].id == 0x0) {
+		dev_err(&client->dev, "Unknown chip id: 0x%x\n",
+			ab3100_chip_id);
+		goto exit_no_detect;
+	}
+
+	dev_info(&client->dev, "Detected chip: %s\n",
+		 &ab3100_chip_name[0]);
+
+	err = ab3100_setup();
+	if (err)
+		goto exit_no_detect;
+
+	/* This real unpredictable IRQ is of course sampled for entropy */
+	err = request_irq(client->irq, ab3100_irq_handler,
+			  IRQF_DISABLED | IRQF_SAMPLE_RANDOM,
+			  "AB3100 IRQ", NULL);
+	if (err)
+		goto exit_no_detect;
+
+	ab3100_setup_debugfs();
+
+	return 0;
+
+ exit_no_detect:
+	return err;
+}
+
+static int __exit ab3100_remove(struct i2c_client *client)
+{
+	struct event *e;
+
+	ab3100_remove_debugfs();
+	/* Free the list of event subscribers here */
+	mutex_lock(&event_list_mutex);
+	list_for_each_entry(e, &subscribers, node) {
+
+		/* Found a client subscription => remove it */
+		list_del(&e->node);
+		kfree(e);
+	}
+	mutex_unlock(&event_list_mutex);
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
index 0000000..ba04448
--- /dev/null
+++ b/include/linux/mfd/ab3100.h
@@ -0,0 +1,73 @@
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
+#define ABUNKNOWN 0
+#define	AB3000    1
+#define	AB3100    2
+
+/* AB3100, EVENTA1 register flags */
+#define AB3100_EVENTA1_ONSWA     0x01
+#define AB3100_EVENTA1_ONSWB     0x02
+#define AB3100_EVENTA1_ONSWC     0x04
+#define AB3100_EVENTA1_DCIO      0x08
+#define AB3100_EVENTA1_OVER_TEMP 0x10
+#define AB3100_EVENTA1_SIM_OFF   0x20
+#define AB3100_EVENTA1_VBUS      0x40
+#define AB3100_EVENTA1_VSET_USB  0x80
+
+#define AB3100_EVENTA2_READY_TX          0x01
+#define AB3100_EVENTA2_READY_RX          0x02
+#define AB3100_EVENTA2_OVERRUN_ERROR     0x04
+#define AB3100_EVENTA2_FRAMING_ERROR     0x08
+#define AB3100_EVENTA2_CHARG_OVERCURRENT 0x10
+#define AB3100_EVENTA2_MIDR              0x20
+#define AB3100_EVENTA2_BATTERY_REM       0x40
+#define AB3100_EVENTA2_ALARM             0x80
+
+/* AB3100, EVENTA3 register flags */
+#define AB3100_EVENTA3_ADC_TRIG5    0x01
+#define AB3100_EVENTA3_ADC_TRIG4    0x02
+#define AB3100_EVENTA3_ADC_TRIG3    0x04
+#define AB3100_EVENTA3_ADC_TRIG2    0x08
+#define AB3100_EVENTA3_ADC_TRIGVBAT 0x10
+
+#define AB3100_EVENTA3_ADC_TRIGVTX  0x20
+#define AB3100_EVENTA3_ADC_TRIG1    0x40
+#define AB3100_EVENTA3_ADC_TRIG0    0x80
+
+/* AB3100, STR register flags */
+#define AB3100_STR_ONSWA        0x01
+#define AB3100_STR_ONSWB        0x02
+#define AB3100_STR_ONSWC        0x04
+#define AB3100_STR_DCIO         0x08
+#define AB3100_STR_BOOT_MODE    0x10
+#define AB3100_STR_SIM_OFF      0x20
+#define AB3100_STR_BATT_REMOVAL 0x40
+#define AB3100_STR_VBUS         0x80
+
+struct ab3100_event_mask {
+	u8 event1;
+	u8 event2;
+	u8 event3;
+};
+
+int ab3100_set_register(u8 reg, u8 regval);
+int ab3100_get_register(u8 reg, u8 *regval);
+int ab3100_get_register_page(u8 first_reg, u8 *regvals, u8 numregs);
+int ab3100_mask_and_set_register(u8 reg, u8 andmask, u8 ormask);
+int ab3100_get_chipid(u8 *chipid);
+u8 ab3100_get_chip_type(void);
+int ab3100_event_cb_register(struct device *dev, void
(*cb_handler)(struct ab3100_event_mask, void *client_data), struct
ab3100_event_mask *subscribe_mask, void *client_data);
+int ab3100_event_cb_unregister(struct device *dev);
+int ab3100_event_registers_startup_state_get(struct ab3100_event_mask
*event_mask);
+
+#endif
-- 
1.6.2.1
