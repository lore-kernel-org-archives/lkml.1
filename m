Return-Path: <linux-kernel-owner+w=401wt.eu-S1751921AbZJWUj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbZJWUj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 16:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZJWUj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 16:39:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58827 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZJWUjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 16:39:54 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] mfd/mc13783: near complete rewrite
Date: Fri, 23 Oct 2009 22:38:43 +0200
Message-Id: <1256330323-13300-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes several things while still providing the old API:

 - simplify and fix locking
 - better error handling
 - don't ack all irqs making it impossible to detect a reset of the
   rtc
 - use a timeout variant to wait for completion of ADC conversion
 - provide platform-data to regulator subdevice (This allows making
   struct mc13783 opaque for other drivers after the regulator driver is
   updated to use its platform_data.)
 - expose all interrupts
 - use threaded irq

After all users in mainline are converted to the new API, some things
(e.g. mc13783-private.h) can go away.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/mc13783-core.c          |  789 ++++++++++++++++++++++++-----------
 include/linux/mfd/mc13783-private.h |  208 +---------
 include/linux/mfd/mc13783.h         |  122 +++++--
 3 files changed, 651 insertions(+), 468 deletions(-)

diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
index e354d29..63a5104 100644
--- a/drivers/mfd/mc13783-core.c
+++ b/drivers/mfd/mc13783-core.c
@@ -1,286 +1,579 @@
 /*
- * Copyright 2009 Pengutronix, Sascha Hauer <s.hauer@pengutronix.de>
+ * Copyright 2009 Pengutronix
+ * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
  *
- * This code is in parts based on wm8350-core.c and pcf50633-core.c
- *
- * Initial development of this code was funded by
- * Phytec Messtechnik GmbH, http://www.phytec.de
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
  */
-
-#include <linux/mfd/mc13783-private.h>
-#include <linux/platform_device.h>
-#include <linux/mfd/mc13783.h>
-#include <linux/completion.h>
-#include <linux/interrupt.h>
-#include <linux/mfd/core.h>
-#include <linux/spi/spi.h>
-#include <linux/uaccess.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/irq.h>
+#include <linux/spi/spi.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/mc13783-private.h>
 
-#define MC13783_MAX_REG_NUM	0x3f
-#define MC13783_FRAME_MASK	0x00ffffff
-#define MC13783_MAX_REG_NUM	0x3f
-#define MC13783_REG_NUM_SHIFT	0x19
-#define MC13783_WRITE_BIT_SHIFT	31
+#define MC13783_IRQSTAT0	0
+#define MC13783_IRQSTAT0_ADCDONEI	(1 << 0)
+#define MC13783_IRQSTAT0_ADCBISDONEI	(1 << 1)
+#define MC13783_IRQSTAT0_TSI		(1 << 2)
+#define MC13783_IRQSTAT0_WHIGHI		(1 << 3)
+#define MC13783_IRQSTAT0_WLOWI		(1 << 4)
+#define MC13783_IRQSTAT0_CHGDETI	(1 << 6)
+#define MC13783_IRQSTAT0_CHGOVI		(1 << 7)
+#define MC13783_IRQSTAT0_CHGREVI	(1 << 8)
+#define MC13783_IRQSTAT0_CHGSHORTI	(1 << 9)
+#define MC13783_IRQSTAT0_CCCVI		(1 << 10)
+#define MC13783_IRQSTAT0_CHGCURRI	(1 << 11)
+#define MC13783_IRQSTAT0_BPONI		(1 << 12)
+#define MC13783_IRQSTAT0_LOBATLI	(1 << 13)
+#define MC13783_IRQSTAT0_LOBATHI	(1 << 14)
+#define MC13783_IRQSTAT0_UDPI		(1 << 15)
+#define MC13783_IRQSTAT0_USBI		(1 << 16)
+#define MC13783_IRQSTAT0_IDI		(1 << 19)
+#define MC13783_IRQSTAT0_SE1I		(1 << 21)
+#define MC13783_IRQSTAT0_CKDETI		(1 << 22)
+#define MC13783_IRQSTAT0_UDMI		(1 << 23)
+
+#define MC13783_IRQMASK0	1
+#define MC13783_IRQMASK0_ADCDONEM	MC13783_IRQSTAT0_ADCDONEI
+#define MC13783_IRQMASK0_ADCBISDONEM	MC13783_IRQSTAT0_ADCBISDONEI
+#define MC13783_IRQMASK0_TSM		MC13783_IRQSTAT0_TSI
+#define MC13783_IRQMASK0_WHIGHM		MC13783_IRQSTAT0_WHIGHI
+#define MC13783_IRQMASK0_WLOWM		MC13783_IRQSTAT0_WLOWI
+#define MC13783_IRQMASK0_CHGDETM	MC13783_IRQSTAT0_CHGDETI
+#define MC13783_IRQMASK0_CHGOVM		MC13783_IRQSTAT0_CHGOVI
+#define MC13783_IRQMASK0_CHGREVM	MC13783_IRQSTAT0_CHGREVI
+#define MC13783_IRQMASK0_CHGSHORTM	MC13783_IRQSTAT0_CHGSHORTI
+#define MC13783_IRQMASK0_CCCVM		MC13783_IRQSTAT0_CCCVI
+#define MC13783_IRQMASK0_CHGCURRM	MC13783_IRQSTAT0_CHGCURRI
+#define MC13783_IRQMASK0_BPONM		MC13783_IRQSTAT0_BPONI
+#define MC13783_IRQMASK0_LOBATLM	MC13783_IRQSTAT0_LOBATLI
+#define MC13783_IRQMASK0_LOBATHM	MC13783_IRQSTAT0_LOBATHI
+#define MC13783_IRQMASK0_UDPM		MC13783_IRQSTAT0_UDPI
+#define MC13783_IRQMASK0_USBM		MC13783_IRQSTAT0_USBI
+#define MC13783_IRQMASK0_IDM		MC13783_IRQSTAT0_IDI
+#define MC13783_IRQMASK0_SE1M		MC13783_IRQSTAT0_SE1I
+#define MC13783_IRQMASK0_CKDETM		MC13783_IRQSTAT0_CKDETI
+#define MC13783_IRQMASK0_UDMM		MC13783_IRQSTAT0_UDMI
+
+#define MC13783_IRQSTAT1	3
+#define MC13783_IRQSTAT1_1HZI		(1 << 0)
+#define MC13783_IRQSTAT1_TODAI		(1 << 1)
+#define MC13783_IRQSTAT1_ONOFD1I	(1 << 3)
+#define MC13783_IRQSTAT1_ONOFD2I	(1 << 4)
+#define MC13783_IRQSTAT1_ONOFD3I	(1 << 5)
+#define MC13783_IRQSTAT1_SYSRSTI	(1 << 6)
+#define MC13783_IRQSTAT1_RTCRSTI	(1 << 7)
+#define MC13783_IRQSTAT1_PCI		(1 << 8)
+#define MC13783_IRQSTAT1_WARMI		(1 << 9)
+#define MC13783_IRQSTAT1_MEMHLDI	(1 << 10)
+#define MC13783_IRQSTAT1_PWRRDYI	(1 << 11)
+#define MC13783_IRQSTAT1_THWARNLI	(1 << 12)
+#define MC13783_IRQSTAT1_THWARNHI	(1 << 13)
+#define MC13783_IRQSTAT1_CLKI		(1 << 14)
+#define MC13783_IRQSTAT1_SEMAFI		(1 << 15)
+#define MC13783_IRQSTAT1_MC2BI		(1 << 17)
+#define MC13783_IRQSTAT1_HSDETI		(1 << 18)
+#define MC13783_IRQSTAT1_HSLI		(1 << 19)
+#define MC13783_IRQSTAT1_ALSPTHI	(1 << 20)
+#define MC13783_IRQSTAT1_AHSSHORTI	(1 << 21)
+
+#define MC13783_IRQMASK1	4
+#define MC13783_IRQMASK1_1HZM		MC13783_IRQSTAT1_1HZI
+#define MC13783_IRQMASK1_TODAM		MC13783_IRQSTAT1_TODAI
+#define MC13783_IRQMASK1_ONOFD1M	MC13783_IRQSTAT1_ONOFD1I
+#define MC13783_IRQMASK1_ONOFD2M	MC13783_IRQSTAT1_ONOFD2I
+#define MC13783_IRQMASK1_ONOFD3M	MC13783_IRQSTAT1_ONOFD3I
+#define MC13783_IRQMASK1_SYSRSTM	MC13783_IRQSTAT1_SYSRSTI
+#define MC13783_IRQMASK1_RTCRSTM	MC13783_IRQSTAT1_RTCRSTI
+#define MC13783_IRQMASK1_PCM		MC13783_IRQSTAT1_PCI
+#define MC13783_IRQMASK1_WARMM		MC13783_IRQSTAT1_WARMI
+#define MC13783_IRQMASK1_MEMHLDM	MC13783_IRQSTAT1_MEMHLDI
+#define MC13783_IRQMASK1_PWRRDYM	MC13783_IRQSTAT1_PWRRDYI
+#define MC13783_IRQMASK1_THWARNLM	MC13783_IRQSTAT1_THWARNLI
+#define MC13783_IRQMASK1_THWARNHM	MC13783_IRQSTAT1_THWARNHI
+#define MC13783_IRQMASK1_CLKM		MC13783_IRQSTAT1_CLKI
+#define MC13783_IRQMASK1_SEMAFM		MC13783_IRQSTAT1_SEMAFI
+#define MC13783_IRQMASK1_MC2BM		MC13783_IRQSTAT1_MC2BI
+#define MC13783_IRQMASK1_HSDETM		MC13783_IRQSTAT1_HSDETI
+#define MC13783_IRQMASK1_HSLM		MC13783_IRQSTAT1_HSLI
+#define MC13783_IRQMASK1_ALSPTHM	MC13783_IRQSTAT1_ALSPTHI
+#define MC13783_IRQMASK1_AHSSHORTM	MC13783_IRQSTAT1_AHSSHORTI
+
+#define MC13783_ADC1		44
+#define MC13783_ADC1_ADEN		(1 << 0)
+#define MC13783_ADC1_RAND		(1 << 1)
+#define MC13783_ADC1_ADSEL		(1 << 3)
+#define MC13783_ADC1_ASC		(1 << 20)
+#define MC13783_ADC1_ADTRIGIGN		(1 << 21)
+
+#define MC13783_NUMREGS 0x3f
+
+void mc13783_lock(struct mc13783 *mc13783)
+{
+	if (!mutex_trylock(&mc13783->lock)) {
+		dev_dbg(&mc13783->spidev->dev, "wait for %s from %pf\n",
+			__func__, __builtin_return_address(0));
 
-static inline int spi_rw(struct spi_device *spi, u8 * buf, size_t len)
+		mutex_lock(&mc13783->lock);
+	}
+	dev_dbg(&mc13783->spidev->dev, "%s from %pf\n",
+			__func__, __builtin_return_address(0));
+}
+EXPORT_SYMBOL(mc13783_lock);
+
+void mc13783_unlock(struct mc13783 *mc13783)
 {
-	struct spi_transfer t = {
-		.tx_buf = (const void *)buf,
-		.rx_buf = buf,
-		.len = len,
-		.cs_change = 0,
-		.delay_usecs = 0,
-	};
-	struct spi_message m;
+	dev_dbg(&mc13783->spidev->dev, "%s from %pf\n",
+			__func__, __builtin_return_address(0));
+	mutex_unlock(&mc13783->lock);
+}
+EXPORT_SYMBOL(mc13783_unlock);
 
-	spi_message_init(&m);
-	spi_message_add_tail(&t, &m);
-	if (spi_sync(spi, &m) != 0 || m.status != 0)
+static int mc13783_prep_read_transfer(struct mc13783 *mc13783,
+		struct spi_transfer *t, u32 *buf,
+		unsigned int offset, u32 *val)
+{
+	if (offset > MC13783_NUMREGS)
 		return -EINVAL;
-	return len - m.actual_length;
+
+	buf[0] = offset << 25;
+
+	memset(t, 0, sizeof(*t));
+
+	t->tx_buf = buf;
+	t->rx_buf = buf;
+	t->len = sizeof(u32);
+
+	return 1;
 }
 
-static int mc13783_read(struct mc13783 *mc13783, int reg_num, u32 *reg_val)
+static int mc13783_eval_read_transfer(struct mc13783 *mc13783,
+		struct spi_transfer *t, u32 *buf,
+		unsigned int offset, u32 *val)
 {
-	unsigned int frame = 0;
-	int ret = 0;
+	BUG_ON(t->tx_buf != buf || t->rx_buf != buf);
+
+	*val = buf[0] & 0xffffff;
 
-	if (reg_num > MC13783_MAX_REG_NUM)
+	return 1;
+}
+
+static int mc13783_prep_write_transfer(struct mc13783 *mc13783,
+		struct spi_transfer *t, u32 *buf,
+		unsigned int offset, u32 val)
+{
+	if (offset > MC13783_NUMREGS || val > 0xffffff) 
 		return -EINVAL;
 
-	frame |= reg_num << MC13783_REG_NUM_SHIFT;
+	buf[0] = 1 << 31 | offset << 25 | val;
 
-	ret = spi_rw(mc13783->spi_device, (u8 *)&frame, 4);
+	memset(t, 0, sizeof(*t));
 
-	*reg_val = frame & MC13783_FRAME_MASK;
+	t->tx_buf = buf;
+	t->rx_buf = buf;
+	t->len = sizeof(u32);
 
-	return ret;
+	return 1;
 }
 
-static int mc13783_write(struct mc13783 *mc13783, int reg_num, u32 reg_val)
+static int mc13783_eval_write_transfer(struct mc13783 *mc13783,
+		struct spi_transfer *t, u32 *buf,
+		unsigned int offset, u32 val)
 {
-	unsigned int frame = 0;
+	BUG_ON(t->tx_buf != buf || t->rx_buf != buf);
 
-	if (reg_num > MC13783_MAX_REG_NUM)
-		return -EINVAL;
+	return 1;
+}
+
+int mc13783_reg_read(struct mc13783 *mc13783, unsigned int offset, u32 *val)
+{
+	u32 buf;
+	struct spi_transfer t;
+	struct spi_message m;
+	int ret;
 
-	frame |= (1 << MC13783_WRITE_BIT_SHIFT);
-	frame |= reg_num << MC13783_REG_NUM_SHIFT;
-	frame |= reg_val & MC13783_FRAME_MASK;
+	BUG_ON(!mutex_is_locked(&mc13783->lock));
+
+	ret = mc13783_prep_read_transfer(mc13783, &t, &buf, offset, val);
+
+	if (ret < 0)
+		return ret;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t, &m);
 
-	return spi_rw(mc13783->spi_device, (u8 *)&frame, 4);
+	ret = spi_sync(mc13783->spidev, &m);
+
+	/* error in message.status implies error return from spi_sync */
+	BUG_ON(!ret && m.status);
+
+	if (ret)
+		return ret;
+
+	ret = mc13783_eval_read_transfer(mc13783, &t, &buf, offset, val);
+
+	dev_vdbg(&mc13783->spidev->dev, "[0x%02x] -> 0x%06x\n", offset, *val);
+	
+	return ret < 0 ? ret : 0;
 }
+EXPORT_SYMBOL(mc13783_reg_read);
 
-int mc13783_reg_read(struct mc13783 *mc13783, int reg_num, u32 *reg_val)
+int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
 {
+	u32 buf;
+	struct spi_transfer t;
+	struct spi_message m;
 	int ret;
 
-	mutex_lock(&mc13783->io_lock);
-	ret = mc13783_read(mc13783, reg_num, reg_val);
-	mutex_unlock(&mc13783->io_lock);
+	BUG_ON(!mutex_is_locked(&mc13783->lock));
 
-	return ret;
+	dev_vdbg(&mc13783->spidev->dev, "[0x%02x] <- 0x%06x\n", offset, val);
+
+	ret = mc13783_prep_write_transfer(mc13783, &t, &buf, offset, val);
+
+	if (ret < 0)
+		return ret;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t, &m);
+
+	ret = spi_sync(mc13783->spidev, &m);
+
+	BUG_ON(!ret && m.status);
+
+	if (ret)
+		return ret;
+
+	ret = mc13783_eval_write_transfer(mc13783, &t, &buf, offset, val);
+
+	return ret < 0 ? ret : 0;
 }
-EXPORT_SYMBOL_GPL(mc13783_reg_read);
+EXPORT_SYMBOL(mc13783_reg_write);
 
-int mc13783_reg_write(struct mc13783 *mc13783, int reg_num, u32 reg_val)
+int mc13783_reg_rmw(struct mc13783 *mc13783, unsigned int offset,
+		u32 mask, u32 val)
 {
 	int ret;
+	u32 valread;
 
-	mutex_lock(&mc13783->io_lock);
-	ret = mc13783_write(mc13783, reg_num, reg_val);
-	mutex_unlock(&mc13783->io_lock);
+	BUG_ON(val & ~mask);
 
-	return ret;
+	ret = mc13783_reg_read(mc13783, offset, &valread);
+	if (ret)
+		return ret;
+
+	valread = (valread & ~mask) | val;
+
+	return mc13783_reg_write(mc13783, offset, valread);
 }
-EXPORT_SYMBOL_GPL(mc13783_reg_write);
+EXPORT_SYMBOL(mc13783_reg_rmw);
 
-/**
- * mc13783_set_bits - Bitmask write
- *
- * @mc13783: Pointer to mc13783 control structure
- * @reg:    Register to access
- * @mask:   Mask of bits to change
- * @val:    Value to set for masked bits
- */
-int mc13783_set_bits(struct mc13783 *mc13783, int reg, u32 mask, u32 val)
+int mc13783_mask(struct mc13783 *mc13783, unsigned int irq)
 {
-	u32 tmp;
 	int ret;
+	unsigned int offmask = irq < 24 ? MC13783_IRQMASK0 : MC13783_IRQMASK1;
+	u32 irqbit = 1 << (irq < 24 ? irq : irq - 24);
+	u32 mask;
+
+	ret = mc13783_reg_read(mc13783, offmask, &mask);
+	if (ret)
+		return ret;
 
-	mutex_lock(&mc13783->io_lock);
+	if (mask & irqbit)
+		/* already masked */
+		return 0;
 
-	ret = mc13783_read(mc13783, reg, &tmp);
-	tmp = (tmp & ~mask) | val;
-	if (ret == 0)
-		ret = mc13783_write(mc13783, reg, tmp);
+	return mc13783_reg_write(mc13783, offmask, mask | irqbit);
+}
+EXPORT_SYMBOL(mc13783_mask);
 
-	mutex_unlock(&mc13783->io_lock);
+int mc13783_unmask(struct mc13783 *mc13783, unsigned int irq)
+{
+	int ret;
+	unsigned int offmask = irq < 24 ? MC13783_IRQMASK0 : MC13783_IRQMASK1;
+	u32 irqbit = 1 << (irq < 24 ? irq : irq - 24);
+	u32 mask;
 
-	return ret;
+	ret = mc13783_reg_read(mc13783, offmask, &mask);
+	if (ret)
+		return ret;
+
+	if (!(mask & irqbit))
+		/* already unmasked */
+		return 0;
+
+	return mc13783_reg_write(mc13783, offmask, mask & ~irqbit);
 }
-EXPORT_SYMBOL_GPL(mc13783_set_bits);
+EXPORT_SYMBOL(mc13783_unmask);
 
-int mc13783_register_irq(struct mc13783 *mc13783, int irq,
-		void (*handler) (int, void *), void *data)
+int mc13783_irq_request_nounmask(struct mc13783 *mc13783, unsigned int irq,
+		irqreturn_t (*handler)(struct mc13783 *, unsigned int, void *),
+		const char *name, void *dev)
 {
-	if (irq < 0 || irq > MC13783_NUM_IRQ || !handler)
+	BUG_ON(!mutex_is_locked(&mc13783->lock));
+	BUG_ON(!handler);
+
+	if (irq >= MC13783_NUM_IRQ)
 		return -EINVAL;
 
-	if (WARN_ON(mc13783->irq_handler[irq].handler))
+	if (mc13783->irqhandler[irq])
 		return -EBUSY;
 
-	mutex_lock(&mc13783->io_lock);
-	mc13783->irq_handler[irq].handler = handler;
-	mc13783->irq_handler[irq].data = data;
-	mutex_unlock(&mc13783->io_lock);
+	mc13783->irqhandler[irq] = handler;
+	mc13783->irqdata[irq] = dev;
+
+	return 0;
+}
+EXPORT_SYMBOL(mc13783_irq_request_nounmask);
+
+int mc13783_irq_request(struct mc13783 *mc13783, unsigned int irq,
+		irqreturn_t (*handler)(struct mc13783 *, unsigned int, void *),
+		const char *name, void *dev)
+{
+	int ret;
+
+	ret = mc13783_irq_request_nounmask(mc13783, irq, handler, name, dev);
+	if (ret)
+		return ret;
+
+	ret = mc13783_unmask(mc13783, irq);
+	if (ret) {
+		mc13783->irqhandler[irq] = NULL;
+		mc13783->irqdata[irq] = NULL;
+		return ret;
+	}
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(mc13783_register_irq);
+EXPORT_SYMBOL(mc13783_irq_request);
 
-int mc13783_free_irq(struct mc13783 *mc13783, int irq)
+int mc13783_irq_free(struct mc13783 *mc13783, unsigned int irq, void *dev)
 {
-	if (irq < 0 || irq > MC13783_NUM_IRQ)
+	int ret;
+	BUG_ON(!mutex_is_locked(&mc13783->lock));
+
+	if (irq >= MC13783_NUM_IRQ || !mc13783->irqhandler[irq] ||
+			mc13783->irqdata[irq] != dev)
 		return -EINVAL;
 
-	mutex_lock(&mc13783->io_lock);
-	mc13783->irq_handler[irq].handler = NULL;
-	mutex_unlock(&mc13783->io_lock);
+	ret = mc13783_mask(mc13783, irq);
+	if (ret)
+		return ret;
+
+	mc13783->irqhandler[irq] = NULL;
+	mc13783->irqdata[irq] = NULL;
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(mc13783_free_irq);
+EXPORT_SYMBOL(mc13783_irq_free);
 
-static void mc13783_irq_work(struct work_struct *work)
+static inline irqreturn_t mc13783_irqhandler(struct mc13783 *mc13783,
+		unsigned int irq)
 {
-	struct mc13783 *mc13783 = container_of(work, struct mc13783, work);
-	int i;
-	unsigned int adc_sts;
-
-	/* check if the adc has finished any completion */
-	mc13783_reg_read(mc13783, MC13783_REG_INTERRUPT_STATUS_0, &adc_sts);
-	mc13783_reg_write(mc13783, MC13783_REG_INTERRUPT_STATUS_0,
-			adc_sts & MC13783_INT_STAT_ADCDONEI);
-
-	if (adc_sts & MC13783_INT_STAT_ADCDONEI)
-		complete_all(&mc13783->adc_done);
-
-	for (i = 0; i < MC13783_NUM_IRQ; i++)
-		if (mc13783->irq_handler[i].handler)
-			mc13783->irq_handler[i].handler(i,
-					mc13783->irq_handler[i].data);
-	enable_irq(mc13783->irq);
+	return mc13783->irqhandler[irq](mc13783, irq, mc13783->irqdata[irq]);
 }
 
-static irqreturn_t mc13783_interrupt(int irq, void *dev_id)
+int mc13783_ackirq(struct mc13783 *mc13783, unsigned int irq)
 {
-	struct mc13783 *mc13783 = dev_id;
+	unsigned int offstat = irq < 24 ? MC13783_IRQSTAT0 : MC13783_IRQSTAT1;
+	unsigned int val = 1 << (irq < 24 ? irq : irq - 24);
 
-	disable_irq_nosync(irq);
+	BUG_ON(irq >= MC13783_NUM_IRQ);
 
-	schedule_work(&mc13783->work);
-	return IRQ_HANDLED;
+	return mc13783_reg_write(mc13783, offstat, val);
 }
+EXPORT_SYMBOL(mc13783_ackirq);
 
-/* set adc to ts interrupt mode, which generates touchscreen wakeup interrupt */
-static inline void mc13783_adc_set_ts_irq_mode(struct mc13783 *mc13783)
+/*
+ * returns: number of handled irqs or negative error
+ * locking: holds mc13783->lock
+ */
+static int mc13783_irq_handle(struct mc13783 *mc13783,
+		unsigned int offstat, unsigned int offmask,
+		unsigned int baseirq)
 {
-	unsigned int reg_adc0, reg_adc1;
+	u32 stat, mask;
+	int ret = mc13783_reg_read(mc13783, offstat, &stat);
+	int num_handled = 0;
 
-	reg_adc0 = MC13783_ADC0_ADREFEN | MC13783_ADC0_ADREFMODE
-			| MC13783_ADC0_TSMOD0;
-	reg_adc1 = MC13783_ADC1_ADEN | MC13783_ADC1_ADTRIGIGN;
+	if (ret)
+		return ret;
+
+	ret = mc13783_reg_read(mc13783, offmask, &mask);
+	if (ret)
+		return ret;
+
+	while (stat & ~mask) {
+		unsigned int irq = __ffs(stat & ~mask);
+
+		stat &= ~(1 << irq);
+
+		if (likely(mc13783->irqhandler[baseirq + irq])) {
+			irqreturn_t handled;
+
+			handled = mc13783_irqhandler(mc13783, baseirq + irq);
+			if (handled == IRQ_HANDLED)
+				num_handled++;
+		} else {
+			dev_err(&mc13783->spidev->dev,
+					"BUG: irq %u but no handler\n",
+					baseirq + irq);
+
+			mask |= 1 << irq;
+
+			ret = mc13783_reg_write(mc13783, offmask, mask);
+		}
+	}
 
-	mc13783_reg_write(mc13783, MC13783_REG_ADC_0, reg_adc0);
-	mc13783_reg_write(mc13783, MC13783_REG_ADC_1, reg_adc1);
+	return num_handled;
 }
 
+static irqreturn_t mc13783_irq_thread(int irq, void *data)
+{
+	struct mc13783 *mc13783 = data;
+	irqreturn_t ret;
+	int handled = 0;
+
+	mc13783_lock(mc13783);
+
+	ret = mc13783_irq_handle(mc13783, MC13783_IRQSTAT0,
+			MC13783_IRQMASK0, MC13783_IRQ_ADCDONE);
+	if (ret > 0)
+		handled = 1;
+
+	ret = mc13783_irq_handle(mc13783, MC13783_IRQSTAT1,
+			MC13783_IRQMASK1, MC13783_IRQ_1HZ);
+	if (ret > 0)
+		handled = 1;
+
+	mc13783_unlock(mc13783);
+
+	return IRQ_RETVAL(handled);
+}
+
+#define MC13783_ADC1_CHAN0_SHIFT	5
+#define MC13783_ADC1_CHAN1_SHIFT	8
+
+static irqreturn_t mc13783_handler_adcdone(struct mc13783 *mc13783,
+		unsigned int irq, void *data)
+{
+	struct completion *done = data;
+
+	mc13783_ackirq(mc13783, irq);
+
+	complete_all(done);
+
+	return IRQ_HANDLED;
+}
+
+#define MC13783_ADC_WORKING (1 << 16)
+
 int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
 		unsigned int channel, unsigned int *sample)
 {
-	unsigned int reg_adc0, reg_adc1;
-	int i;
+	u32 adc0, adc1, old_adc0;
+	int i, ret;
+
+	DECLARE_COMPLETION_ONSTACK(done);
+	dev_dbg(&mc13783->spidev->dev, "%s\n", __func__);
 
-	mutex_lock(&mc13783->adc_conv_lock);
+	mc13783_lock(mc13783);
+
+	if (mc13783->flags & MC13783_ADC_WORKING) {
+		ret = -EBUSY;
+		goto out;
+	}
 
-	/* set up auto incrementing anyway to make quick read */
-	reg_adc0 =  MC13783_ADC0_ADINC1 | MC13783_ADC0_ADINC2;
-	/* enable the adc, ignore external triggering and set ASC to trigger
-	 * conversion */
-	reg_adc1 =  MC13783_ADC1_ADEN | MC13783_ADC1_ADTRIGIGN
-		| MC13783_ADC1_ASC;
+	mc13783->flags |= MC13783_ADC_WORKING;
+
+	mc13783_reg_read(mc13783, MC13783_ADC0, &old_adc0);
+
+	adc0 = MC13783_ADC0_ADINC1 | MC13783_ADC0_ADINC2;
+	adc1 = MC13783_ADC1_ADEN | MC13783_ADC1_ADTRIGIGN | MC13783_ADC1_ASC;
 
-	/* setup channel number */
 	if (channel > 7)
-		reg_adc1 |= MC13783_ADC1_ADSEL;
+		adc1 |= MC13783_ADC1_ADSEL;
 
-	switch (mode) {
+	switch(mode) {
 	case MC13783_ADC_MODE_TS:
-		/* enables touch screen reference mode and set touchscreen mode
-		 * to position mode */
-		reg_adc0 |= MC13783_ADC0_ADREFEN | MC13783_ADC0_ADREFMODE
+		adc0 |= MC13783_ADC0_ADREFEN | MC13783_ADC0_ADREFMODE
 			| MC13783_ADC0_TSMOD0 | MC13783_ADC0_TSMOD1;
-		reg_adc1 |= 4 << MC13783_ADC1_CHAN1_SHIFT;
+		adc1 |= 4 << MC13783_ADC1_CHAN1_SHIFT;
 		break;
+
 	case MC13783_ADC_MODE_SINGLE_CHAN:
-		reg_adc1 |= (channel & 0x7) << MC13783_ADC1_CHAN0_SHIFT;
-		reg_adc1 |= MC13783_ADC1_RAND;
+		adc0 |= old_adc0 & MC13783_ADC0_TSMOD_MASK;
+		adc1 |= (channel & 0x7) << MC13783_ADC1_CHAN0_SHIFT;
+		adc1 |= MC13783_ADC1_RAND;
 		break;
+
 	case MC13783_ADC_MODE_MULT_CHAN:
-		reg_adc1 |= 4 << MC13783_ADC1_CHAN1_SHIFT;
+		adc0 |= old_adc0 & MC13783_ADC0_TSMOD_MASK;
+		adc1 |= 4 << MC13783_ADC1_CHAN1_SHIFT;
 		break;
+
 	default:
+		mc13783_unlock(mc13783);
 		return -EINVAL;
 	}
 
-	mc13783_reg_write(mc13783, MC13783_REG_ADC_0, reg_adc0);
-	mc13783_reg_write(mc13783, MC13783_REG_ADC_1, reg_adc1);
+	mc13783_reg_write(mc13783, MC13783_REG_ADC_0, adc0);
+	mc13783_reg_write(mc13783, MC13783_REG_ADC_1, adc1);
 
-	wait_for_completion_interruptible(&mc13783->adc_done);
+	dev_dbg(&mc13783->spidev->dev, "%s: request irq\n", __func__);
+	mc13783_irq_request(mc13783, MC13783_IRQ_ADCDONE,
+			mc13783_handler_adcdone, __func__, &done);
 
-	for (i = 0; i < 4; i++)
-		mc13783_reg_read(mc13783, MC13783_REG_ADC_2, &sample[i]);
+	mc13783_unlock(mc13783);
 
-	if (mc13783->ts_active)
-		mc13783_adc_set_ts_irq_mode(mc13783);
+	ret = wait_for_completion_interruptible_timeout(&done, HZ);
 
-	mutex_unlock(&mc13783->adc_conv_lock);
+	if (!ret)
+		ret = -ETIMEDOUT;
 
-	return 0;
+	mc13783_lock(mc13783);
+
+	mc13783_irq_free(mc13783, MC13783_IRQ_ADCDONE, &done);
+
+	if (mode == MC13783_ADC_MODE_TS)
+		/* restore TSMOD */
+		mc13783_reg_write(mc13783, MC13783_REG_ADC_0, old_adc0);
+
+	if (ret > 0)
+		for (i = 0; i < 4; ++i)
+			mc13783_reg_read(mc13783,
+					MC13783_REG_ADC_2, &sample[i]);
+
+	mc13783->flags &= ~MC13783_ADC_WORKING;
+out:
+	mc13783_unlock(mc13783);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(mc13783_adc_do_conversion);
 
-void mc13783_adc_set_ts_status(struct mc13783 *mc13783, unsigned int status)
+static int mc13783_add_subdevice_pdata(struct mc13783 *mc13783,
+		const char *name, void *pdata, size_t pdata_size)
+{
+	struct mfd_cell cell = {
+		.name = name,
+		.platform_data = pdata,
+		.data_size = pdata_size,
+	};
+
+	return mfd_add_devices(&mc13783->spidev->dev, -1, &cell, 1, NULL, 0);
+}
+
+static int mc13783_add_subdevice(struct mc13783 *mc13783, const char *name)
 {
-	mc13783->ts_active = status;
+	return mc13783_add_subdevice_pdata(mc13783, name, NULL, 0);
 }
-EXPORT_SYMBOL_GPL(mc13783_adc_set_ts_status);
 
 static int mc13783_check_revision(struct mc13783 *mc13783)
 {
 	u32 rev_id, rev1, rev2, finid, icid;
 
-	mc13783_read(mc13783, MC13783_REG_REVISION, &rev_id);
+	mc13783_reg_read(mc13783, MC13783_REG_REVISION, &rev_id);
 
 	rev1 = (rev_id & 0x018) >> 3;
 	rev2 = (rev_id & 0x007);
@@ -292,38 +585,24 @@ static int mc13783_check_revision(struct mc13783 *mc13783)
 		rev1 = 3;
 
 	if (rev1 == 0 || icid != 2) {
-		dev_err(mc13783->dev, "No MC13783 detected.\n");
+		dev_err(&mc13783->spidev->dev, "No MC13783 detected.\n");
 		return -ENODEV;
 	}
 
-	mc13783->revision = ((rev1 * 10) + rev2);
-	dev_info(mc13783->dev, "MC13783 Rev %d.%d FinVer %x detected\n", rev1,
-	       rev2, finid);
+	dev_info(&mc13783->spidev->dev,
+			"MC13783 Rev %d.%d FinVer %x detected\n",
+			rev1, rev2, finid);
 
 	return 0;
 }
 
-/*
- * Register a client device.  This is non-fatal since there is no need to
- * fail the entire device init due to a single platform device failing.
- */
-static void mc13783_client_dev_register(struct mc13783 *mc13783,
-				       const char *name)
-{
-	struct mfd_cell cell = {};
-
-	cell.name = name;
-
-	mfd_add_devices(mc13783->dev, -1, &cell, 1, NULL, 0);
-}
-
-static int __devinit mc13783_probe(struct spi_device *spi)
+static int mc13783_probe(struct spi_device *spi)
 {
 	struct mc13783 *mc13783;
-	struct mc13783_platform_data *pdata = spi->dev.platform_data;
+	struct mc13783_platform_data *pdata = dev_get_platdata(&spi->dev);
 	int ret;
 
-	mc13783 = kzalloc(sizeof(struct mc13783), GFP_KERNEL);
+	mc13783 = kzalloc(sizeof(*mc13783), GFP_KERNEL);
 	if (!mc13783)
 		return -ENOMEM;
 
@@ -332,96 +611,104 @@ static int __devinit mc13783_probe(struct spi_device *spi)
 	spi->bits_per_word = 32;
 	spi_setup(spi);
 
-	mc13783->spi_device = spi;
-	mc13783->dev = &spi->dev;
-	mc13783->irq = spi->irq;
+	mc13783->spidev = spi;
+
+	mutex_init(&mc13783->lock);
+	mc13783_lock(mc13783);
 
-	INIT_WORK(&mc13783->work, mc13783_irq_work);
-	mutex_init(&mc13783->io_lock);
-	mutex_init(&mc13783->adc_conv_lock);
-	init_completion(&mc13783->adc_done);
+	ret = mc13783_check_revision(mc13783);
+	if (ret)
+		goto err_revision;
+
+	/* mask all irqs */
+	ret = mc13783_reg_write(mc13783, MC13783_IRQMASK0, 0x00ffffff);
+	if (ret)
+		goto err_mask;
+
+	ret = mc13783_reg_write(mc13783, MC13783_IRQMASK1, 0x00ffffff);
+	if (ret)
+		goto err_mask;
+
+	ret = request_threaded_irq(spi->irq, NULL, mc13783_irq_thread,
+			IRQF_ONESHOT | IRQF_TRIGGER_HIGH, "mc13783", mc13783);
+
+	if (ret) {
+err_mask:
+err_revision:
+		mutex_unlock(&mc13783->lock);
+		dev_set_drvdata(&spi->dev, NULL);
+		kfree(mc13783);
+		return ret;
+	}
 
+	/* This should go away (BEGIN) */
 	if (pdata) {
 		mc13783->flags = pdata->flags;
 		mc13783->regulators = pdata->regulators;
 		mc13783->num_regulators = pdata->num_regulators;
 	}
+	/* This should go away (END) */
+
+	if (pdata->flags & MC13783_USE_ADC)
+		mc13783_add_subdevice(mc13783, "mc13783-adc");
+
+	if (pdata->flags & MC13783_USE_CODEC)
+		mc13783_add_subdevice(mc13783, "mc13783-codec");
 
-	if (mc13783_check_revision(mc13783)) {
-		ret = -ENODEV;
-		goto err_out;
+	if (pdata->flags & MC13783_USE_REGULATOR) {
+		struct mc13783_regulator_platform_data regulator_pdata = {
+			.num_regulators = pdata->num_regulators,
+			.regulators = pdata->regulators,
+		};
+
+		mc13783_add_subdevice_pdata(mc13783, "mc13783-regulator",
+				&regulator_pdata, sizeof(regulator_pdata));
 	}
 
-	/* clear and mask all interrupts */
-	mc13783_reg_write(mc13783, MC13783_REG_INTERRUPT_STATUS_0, 0x00ffffff);
-	mc13783_reg_write(mc13783, MC13783_REG_INTERRUPT_MASK_0, 0x00ffffff);
-	mc13783_reg_write(mc13783, MC13783_REG_INTERRUPT_STATUS_1, 0x00ffffff);
-	mc13783_reg_write(mc13783, MC13783_REG_INTERRUPT_MASK_1, 0x00ffffff);
+	if (pdata->flags & MC13783_USE_RTC)
+		mc13783_add_subdevice(mc13783, "mc13783-rtc");
 
-	/* unmask adcdone interrupts */
-	mc13783_set_bits(mc13783, MC13783_REG_INTERRUPT_MASK_0,
-			MC13783_INT_MASK_ADCDONEM, 0);
+	if (pdata->flags & MC13783_USE_TOUCHSCREEN)
+		mc13783_add_subdevice(mc13783, "mc13783-ts");
 
-	ret = request_irq(mc13783->irq, mc13783_interrupt,
-			IRQF_DISABLED | IRQF_TRIGGER_HIGH, "mc13783",
-			mc13783);
-	if (ret)
-		goto err_out;
-
-	if (mc13783->flags & MC13783_USE_CODEC)
-		mc13783_client_dev_register(mc13783, "mc13783-codec");
-	if (mc13783->flags & MC13783_USE_ADC)
-		mc13783_client_dev_register(mc13783, "mc13783-adc");
-	if (mc13783->flags & MC13783_USE_RTC)
-		mc13783_client_dev_register(mc13783, "mc13783-rtc");
-	if (mc13783->flags & MC13783_USE_REGULATOR)
-		mc13783_client_dev_register(mc13783, "mc13783-regulator");
-	if (mc13783->flags & MC13783_USE_TOUCHSCREEN)
-		mc13783_client_dev_register(mc13783, "mc13783-ts");
+	mc13783_unlock(mc13783);
 
 	return 0;
-
-err_out:
-	kfree(mc13783);
-	return ret;
 }
 
 static int __devexit mc13783_remove(struct spi_device *spi)
 {
-	struct mc13783 *mc13783;
+	struct mc13783 *mc13783 = dev_get_drvdata(&spi->dev);
 
-	mc13783 = dev_get_drvdata(&spi->dev);
-
-	free_irq(mc13783->irq, mc13783);
+	free_irq(mc13783->spidev->irq, mc13783);
 
 	mfd_remove_devices(&spi->dev);
 
 	return 0;
 }
 
-static struct spi_driver pmic_driver = {
+static struct spi_driver mc13783_driver = {
 	.driver = {
-		   .name = "mc13783",
-		   .bus = &spi_bus_type,
-		   .owner = THIS_MODULE,
+		.name = "mc13783",
+		.bus = &spi_bus_type,
+		.owner = THIS_MODULE,
 	},
 	.probe = mc13783_probe,
 	.remove = __devexit_p(mc13783_remove),
 };
 
-static int __init pmic_init(void)
+static int __init mc13783_init(void)
 {
-	return spi_register_driver(&pmic_driver);
+	return spi_register_driver(&mc13783_driver);
 }
-subsys_initcall(pmic_init);
+subsys_initcall(mc13783_init);
 
-static void __exit pmic_exit(void)
+static void __exit mc13783_exit(void)
 {
-	spi_unregister_driver(&pmic_driver);
+	spi_unregister_driver(&mc13783_driver);
 }
-module_exit(pmic_exit);
-
-MODULE_DESCRIPTION("Core/Protocol driver for Freescale MC13783 PMIC");
-MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
-MODULE_LICENSE("GPL");
+module_exit(mc13783_exit);
 
+MODULE_DESCRIPTION("Core driver for Freescale MC13783 PMIC");
+MODULE_AUTHOR("Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/mc13783-private.h b/include/linux/mfd/mc13783-private.h
index 47e698c..c5eca82 100644
--- a/include/linux/mfd/mc13783-private.h
+++ b/include/linux/mfd/mc13783-private.h
@@ -24,52 +24,24 @@
 
 #include <linux/platform_device.h>
 #include <linux/mfd/mc13783.h>
-#include <linux/workqueue.h>
 #include <linux/mutex.h>
-
-struct mc13783_irq {
-	void (*handler)(int, void *);
-	void *data;
-};
-
-#define MC13783_NUM_IRQ		2
-#define MC13783_IRQ_TS		0
-#define MC13783_IRQ_REGULATOR	1
-
-#define MC13783_ADC_MODE_TS		1
-#define MC13783_ADC_MODE_SINGLE_CHAN	2
-#define MC13783_ADC_MODE_MULT_CHAN	3
+#include <linux/interrupt.h>
 
 struct mc13783 {
-	int revision;
-	struct device *dev;
-	struct spi_device *spi_device;
-
-	int (*read_dev)(void *data, char reg, int count, u32 *dst);
-	int (*write_dev)(void *data, char reg, int count, const u32 *src);
-
-	struct mutex io_lock;
-	void *io_data;
+	struct spi_device *spidev;
+	struct mutex lock;
 	int irq;
-	unsigned int flags;
+	int flags;
 
-	struct mc13783_irq irq_handler[MC13783_NUM_IRQ];
-	struct work_struct work;
-	struct completion adc_done;
-	unsigned int ts_active;
-	struct mutex adc_conv_lock;
+	irqreturn_t (*irqhandler[MC13783_NUM_IRQ])(struct mc13783 *,
+			unsigned int, void *);
+	void *irqdata[MC13783_NUM_IRQ];
 
+	/* XXX these should go as platformdata to the regulator subdevice */
 	struct mc13783_regulator_init_data *regulators;
 	int num_regulators;
 };
 
-int mc13783_reg_read(struct mc13783 *, int reg_num, u32 *);
-int mc13783_reg_write(struct mc13783 *, int, u32);
-int mc13783_set_bits(struct mc13783 *, int, u32, u32);
-int mc13783_free_irq(struct mc13783 *mc13783, int irq);
-int mc13783_register_irq(struct mc13783 *mc13783, int irq,
-		void (*handler) (int, void *), void *data);
-
 #define MC13783_REG_INTERRUPT_STATUS_0		 0
 #define MC13783_REG_INTERRUPT_MASK_0		 1
 #define MC13783_REG_INTERRUPT_SENSE_0		 2
@@ -136,55 +108,6 @@ int mc13783_register_irq(struct mc13783 *mc13783, int irq,
 #define MC13783_REG_TEST_3			63
 #define MC13783_REG_NB				64
 
-
-/*
- * Interrupt Status
- */
-#define MC13783_INT_STAT_ADCDONEI	(1 << 0)
-#define MC13783_INT_STAT_ADCBISDONEI	(1 << 1)
-#define MC13783_INT_STAT_TSI		(1 << 2)
-#define MC13783_INT_STAT_WHIGHI		(1 << 3)
-#define MC13783_INT_STAT_WLOWI		(1 << 4)
-#define MC13783_INT_STAT_CHGDETI	(1 << 6)
-#define MC13783_INT_STAT_CHGOVI		(1 << 7)
-#define MC13783_INT_STAT_CHGREVI	(1 << 8)
-#define MC13783_INT_STAT_CHGSHORTI	(1 << 9)
-#define MC13783_INT_STAT_CCCVI		(1 << 10)
-#define MC13783_INT_STAT_CHGCURRI	(1 << 11)
-#define MC13783_INT_STAT_BPONI		(1 << 12)
-#define MC13783_INT_STAT_LOBATLI	(1 << 13)
-#define MC13783_INT_STAT_LOBATHI	(1 << 14)
-#define MC13783_INT_STAT_UDPI		(1 << 15)
-#define MC13783_INT_STAT_USBI		(1 << 16)
-#define MC13783_INT_STAT_IDI		(1 << 19)
-#define MC13783_INT_STAT_Unused		(1 << 20)
-#define MC13783_INT_STAT_SE1I		(1 << 21)
-#define MC13783_INT_STAT_CKDETI		(1 << 22)
-#define MC13783_INT_STAT_UDMI		(1 << 23)
-
-/*
- * Interrupt Mask
- */
-#define MC13783_INT_MASK_ADCDONEM	(1 << 0)
-#define MC13783_INT_MASK_ADCBISDONEM	(1 << 1)
-#define MC13783_INT_MASK_TSM		(1 << 2)
-#define MC13783_INT_MASK_WHIGHM		(1 << 3)
-#define MC13783_INT_MASK_WLOWM		(1 << 4)
-#define MC13783_INT_MASK_CHGDETM	(1 << 6)
-#define MC13783_INT_MASK_CHGOVM		(1 << 7)
-#define MC13783_INT_MASK_CHGREVM	(1 << 8)
-#define MC13783_INT_MASK_CHGSHORTM	(1 << 9)
-#define MC13783_INT_MASK_CCCVM		(1 << 10)
-#define MC13783_INT_MASK_CHGCURRM	(1 << 11)
-#define MC13783_INT_MASK_BPONM		(1 << 12)
-#define MC13783_INT_MASK_LOBATLM	(1 << 13)
-#define MC13783_INT_MASK_LOBATHM	(1 << 14)
-#define MC13783_INT_MASK_UDPM		(1 << 15)
-#define MC13783_INT_MASK_USBM		(1 << 16)
-#define MC13783_INT_MASK_IDM		(1 << 19)
-#define MC13783_INT_MASK_SE1M		(1 << 21)
-#define MC13783_INT_MASK_CKDETM		(1 << 22)
-
 /*
  * Reg Regulator Mode 0
  */
@@ -284,113 +207,14 @@ int mc13783_register_irq(struct mc13783 *mc13783, int irq,
 #define MC13783_SWCTRL_SW3_STBY		(1 << 21)
 #define MC13783_SWCTRL_SW3_MODE		(1 << 22)
 
-/*
- * ADC/Touch
- */
-#define MC13783_ADC0_LICELLCON		(1 << 0)
-#define MC13783_ADC0_CHRGICON		(1 << 1)
-#define MC13783_ADC0_BATICON		(1 << 2)
-#define MC13783_ADC0_RTHEN 		(1 << 3)
-#define MC13783_ADC0_DTHEN		(1 << 4)
-#define MC13783_ADC0_UIDEN		(1 << 5)
-#define MC13783_ADC0_ADOUTEN 		(1 << 6)
-#define MC13783_ADC0_ADOUTPER		(1 << 7)
-#define MC13783_ADC0_ADREFEN		(1 << 10)
-#define MC13783_ADC0_ADREFMODE		(1 << 11)
-#define MC13783_ADC0_TSMOD0		(1 << 12)
-#define MC13783_ADC0_TSMOD1		(1 << 13)
-#define MC13783_ADC0_TSMOD2		(1 << 14)
-#define MC13783_ADC0_CHRGRAWDIV		(1 << 15)
-#define MC13783_ADC0_ADINC1		(1 << 16)
-#define MC13783_ADC0_ADINC2		(1 << 17)
-#define MC13783_ADC0_WCOMP		(1 << 18)
-#define MC13783_ADC0_ADCBIS0		(1 << 23)
-
-#define MC13783_ADC1_ADEN		(1 << 0)
-#define MC13783_ADC1_RAND		(1 << 1)
-#define MC13783_ADC1_ADSEL		(1 << 3)
-#define MC13783_ADC1_TRIGMASK		(1 << 4)
-#define MC13783_ADC1_ADA10		(1 << 5)
-#define MC13783_ADC1_ADA11		(1 << 6)
-#define MC13783_ADC1_ADA12		(1 << 7)
-#define MC13783_ADC1_ADA20		(1 << 8)
-#define MC13783_ADC1_ADA21		(1 << 9)
-#define MC13783_ADC1_ADA22		(1 << 10)
-#define MC13783_ADC1_ATO0		(1 << 11)
-#define MC13783_ADC1_ATO1		(1 << 12)
-#define MC13783_ADC1_ATO2		(1 << 13)
-#define MC13783_ADC1_ATO3		(1 << 14)
-#define MC13783_ADC1_ATO4		(1 << 15)
-#define MC13783_ADC1_ATO5		(1 << 16)
-#define MC13783_ADC1_ATO6		(1 << 17)
-#define MC13783_ADC1_ATO7		(1 << 18)
-#define MC13783_ADC1_ATOX		(1 << 19)
-#define MC13783_ADC1_ASC		(1 << 20)
-#define MC13783_ADC1_ADTRIGIGN		(1 << 21)
-#define MC13783_ADC1_ADONESHOT		(1 << 22)
-#define MC13783_ADC1_ADCBIS1		(1 << 23)
-
-#define MC13783_ADC1_CHAN0_SHIFT	5
-#define MC13783_ADC1_CHAN1_SHIFT	8
-
-#define MC13783_ADC2_ADD10		(1 << 2)
-#define MC13783_ADC2_ADD11		(1 << 3)
-#define MC13783_ADC2_ADD12		(1 << 4)
-#define MC13783_ADC2_ADD13		(1 << 5)
-#define MC13783_ADC2_ADD14		(1 << 6)
-#define MC13783_ADC2_ADD15		(1 << 7)
-#define MC13783_ADC2_ADD16		(1 << 8)
-#define MC13783_ADC2_ADD17		(1 << 9)
-#define MC13783_ADC2_ADD18		(1 << 10)
-#define MC13783_ADC2_ADD19		(1 << 11)
-#define MC13783_ADC2_ADD20		(1 << 14)
-#define MC13783_ADC2_ADD21		(1 << 15)
-#define MC13783_ADC2_ADD22		(1 << 16)
-#define MC13783_ADC2_ADD23		(1 << 17)
-#define MC13783_ADC2_ADD24		(1 << 18)
-#define MC13783_ADC2_ADD25		(1 << 19)
-#define MC13783_ADC2_ADD26		(1 << 20)
-#define MC13783_ADC2_ADD27		(1 << 21)
-#define MC13783_ADC2_ADD28		(1 << 22)
-#define MC13783_ADC2_ADD29		(1 << 23)
+static inline int mc13783_set_bits(struct mc13783 *mc13783, unsigned int offset, u32 mask, u32 val)
+{
+	int ret;
+	mc13783_lock(mc13783);
+	ret = mc13783_reg_rmw(mc13783, offset, mask, val);
+	mc13783_unlock(mc13783);
 
-#define MC13783_ADC3_WHIGH0		(1 << 0)
-#define MC13783_ADC3_WHIGH1		(1 << 1)
-#define MC13783_ADC3_WHIGH2		(1 << 2)
-#define MC13783_ADC3_WHIGH3		(1 << 3)
-#define MC13783_ADC3_WHIGH4		(1 << 4)
-#define MC13783_ADC3_WHIGH5		(1 << 5)
-#define MC13783_ADC3_ICID0		(1 << 6)
-#define MC13783_ADC3_ICID1		(1 << 7)
-#define MC13783_ADC3_ICID2		(1 << 8)
-#define MC13783_ADC3_WLOW0		(1 << 9)
-#define MC13783_ADC3_WLOW1		(1 << 10)
-#define MC13783_ADC3_WLOW2		(1 << 11)
-#define MC13783_ADC3_WLOW3		(1 << 12)
-#define MC13783_ADC3_WLOW4		(1 << 13)
-#define MC13783_ADC3_WLOW5		(1 << 14)
-#define MC13783_ADC3_ADCBIS2		(1 << 23)
-
-#define MC13783_ADC4_ADDBIS10		(1 << 2)
-#define MC13783_ADC4_ADDBIS11		(1 << 3)
-#define MC13783_ADC4_ADDBIS12		(1 << 4)
-#define MC13783_ADC4_ADDBIS13		(1 << 5)
-#define MC13783_ADC4_ADDBIS14		(1 << 6)
-#define MC13783_ADC4_ADDBIS15		(1 << 7)
-#define MC13783_ADC4_ADDBIS16		(1 << 8)
-#define MC13783_ADC4_ADDBIS17		(1 << 9)
-#define MC13783_ADC4_ADDBIS18		(1 << 10)
-#define MC13783_ADC4_ADDBIS19		(1 << 11)
-#define MC13783_ADC4_ADDBIS20		(1 << 14)
-#define MC13783_ADC4_ADDBIS21		(1 << 15)
-#define MC13783_ADC4_ADDBIS22		(1 << 16)
-#define MC13783_ADC4_ADDBIS23		(1 << 17)
-#define MC13783_ADC4_ADDBIS24		(1 << 18)
-#define MC13783_ADC4_ADDBIS25		(1 << 19)
-#define MC13783_ADC4_ADDBIS26		(1 << 20)
-#define MC13783_ADC4_ADDBIS27		(1 << 21)
-#define MC13783_ADC4_ADDBIS28		(1 << 22)
-#define MC13783_ADC4_ADDBIS29		(1 << 23)
+	return ret;
+}
 
 #endif /* __LINUX_MFD_MC13783_PRIV_H */
-
diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
index b3a2a72..910d5cf 100644
--- a/include/linux/mfd/mc13783.h
+++ b/include/linux/mfd/mc13783.h
@@ -1,28 +1,52 @@
 /*
- * Copyright 2009 Pengutronix, Sascha Hauer <s.hauer@pengutronix.de>
+ * Copyright 2009 Pengutronix
+ * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
  *
- * Initial development of this code was funded by
- * Phytec Messtechnik GmbH, http://www.phytec.de
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
  */
+#ifndef __LINUX_MFD_MC13783_H
+#define __LINUX_MFD_MC13783_H
 
-#ifndef __INCLUDE_LINUX_MFD_MC13783_H
-#define __INCLUDE_LINUX_MFD_MC13783_H
+#include <linux/interrupt.h>
 
 struct mc13783;
+
+void mc13783_lock(struct mc13783 *mc13783);
+void mc13783_unlock(struct mc13783 *mc13783);
+
+int mc13783_reg_read(struct mc13783 *mc13783, unsigned int offset, u32 *val);
+int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val);
+int mc13783_reg_rmw(struct mc13783 *mc13783, unsigned int offset,
+		u32 mask, u32 val);
+
+int mc13783_irq_request(struct mc13783 *mc13783, unsigned int irq,
+		irqreturn_t (*handler)(struct mc13783 *, unsigned int, void *),
+		const char *name, void *dev);
+int mc13783_irq_request_nounmask(struct mc13783 *mc13783, unsigned int irq,
+		irqreturn_t (*handler)(struct mc13783 *, unsigned int, void *),
+		const char *name, void *dev);
+int mc13783_irq_free(struct mc13783 *mc13783, unsigned int irq, void *dev);
+int mc13783_ackirq(struct mc13783 *mc13783, unsigned int irq);
+
+int mc13783_mask(struct mc13783 *mc13783, unsigned int irq);
+int mc13783_unmask(struct mc13783 *mc13783, unsigned int irq);
+
+#define MC13783_ADC0		43
+#define MC13783_ADC0_ADREFEN		(1 << 10)
+#define MC13783_ADC0_ADREFMODE		(1 << 11)
+#define MC13783_ADC0_TSMOD0		(1 << 12)
+#define MC13783_ADC0_TSMOD1		(1 << 13)
+#define MC13783_ADC0_TSMOD2		(1 << 14)
+#define MC13783_ADC0_ADINC1		(1 << 16)
+#define MC13783_ADC0_ADINC2		(1 << 17)
+
+#define MC13783_ADC0_TSMOD_MASK		(MC13783_ADC0_TSMOD0 | \
+					MC13783_ADC0_TSMOD1 | \
+					MC13783_ADC0_TSMOD2)
+
+/* to be cleaned up */
 struct regulator_init_data;
 
 struct mc13783_regulator_init_data {
@@ -30,23 +54,30 @@ struct mc13783_regulator_init_data {
 	struct regulator_init_data *init_data;
 };
 
-struct mc13783_platform_data {
-	struct mc13783_regulator_init_data *regulators;
+struct mc13783_regulator_platform_data {
 	int num_regulators;
-	unsigned int flags;
+	struct mc13783_regulator_init_data *regulators;
 };
 
-/* mc13783_platform_data flags */
+struct mc13783_platform_data {
+	int num_regulators;
+	struct mc13783_regulator_init_data *regulators;
+
 #define MC13783_USE_TOUCHSCREEN (1 << 0)
 #define MC13783_USE_CODEC	(1 << 1)
 #define MC13783_USE_ADC		(1 << 2)
 #define MC13783_USE_RTC		(1 << 3)
 #define MC13783_USE_REGULATOR	(1 << 4)
+	unsigned int flags;
+};
+
+#define MC13783_ADC_MODE_TS		1
+#define MC13783_ADC_MODE_SINGLE_CHAN	2
+#define MC13783_ADC_MODE_MULT_CHAN	3
 
 int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
 		unsigned int channel, unsigned int *sample);
 
-void mc13783_adc_set_ts_status(struct mc13783 *mc13783, unsigned int status);
 
 #define	MC13783_SW_SW1A		0
 #define	MC13783_SW_SW1B		1
@@ -80,5 +111,46 @@ void mc13783_adc_set_ts_status(struct mc13783 *mc13783, unsigned int status);
 #define	MC13783_REGU_V3		29
 #define	MC13783_REGU_V4		30
 
-#endif /* __INCLUDE_LINUX_MFD_MC13783_H */
+#define MC13783_IRQ_ADCDONE	0
+#define MC13783_IRQ_ADCBISDONE	1
+#define MC13783_IRQ_TS		2
+#define MC13783_IRQ_WHIGH	3
+#define MC13783_IRQ_WLOW	4
+#define MC13783_IRQ_CHGDET	6
+#define MC13783_IRQ_CHGOV	7
+#define MC13783_IRQ_CHGREV	8
+#define MC13783_IRQ_CHGSHORT	9
+#define MC13783_IRQ_CCCV	10
+#define MC13783_IRQ_CHGCURR	11
+#define MC13783_IRQ_BPON	12
+#define MC13783_IRQ_LOBATL	13
+#define MC13783_IRQ_LOBATH	14
+#define MC13783_IRQ_UDP		15
+#define MC13783_IRQ_USB		16
+#define MC13783_IRQ_ID		19
+#define MC13783_IRQ_SE1		21
+#define MC13783_IRQ_CKDET	22
+#define MC13783_IRQ_UDM		23
+#define MC13783_IRQ_1HZ		24
+#define MC13783_IRQ_TODA	25
+#define MC13783_IRQ_ONOFD1	27
+#define MC13783_IRQ_ONOFD2	28
+#define MC13783_IRQ_ONOFD3	29
+#define MC13783_IRQ_SYSRST	30
+#define MC13783_IRQ_RTCRST	31
+#define MC13783_IRQ_PC		32
+#define MC13783_IRQ_WARM	33
+#define MC13783_IRQ_MEMHLD	34
+#define MC13783_IRQ_PWRRDY	35
+#define MC13783_IRQ_THWARNL	36
+#define MC13783_IRQ_THWARNH	37
+#define MC13783_IRQ_CLK		38
+#define MC13783_IRQ_SEMAF	39
+#define MC13783_IRQ_MC2B	41
+#define MC13783_IRQ_HSDET	42
+#define MC13783_IRQ_HSL		43
+#define MC13783_IRQ_ALSPTH	44
+#define MC13783_IRQ_AHSSHORT	45
+#define MC13783_NUM_IRQ		46
 
+#endif /* __LINUX_MFD_MC13783_H */
-- 
1.6.5

