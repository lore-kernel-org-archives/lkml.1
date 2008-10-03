Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbYJCLxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbYJCLxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 07:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbYJCLxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 07:53:18 -0400
Received: from smtp.nokia.com ([192.100.105.134]:32333 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbYJCLxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 07:53:10 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: [RFC][PATCH 3/5] OMAP SSI driver code
Date: Fri,  3 Oct 2008 14:52:28 +0300
Message-Id: <1223034750-18690-3-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1223034750-18690-2-git-send-email-carlos.chinea@nokia.com>
References: <1223034606.32631.156.camel@groo.research.nokia.com>
 <1223034750-18690-1-git-send-email-carlos.chinea@nokia.com>
 <1223034750-18690-2-git-send-email-carlos.chinea@nokia.com>
X-OriginalArrivalTime: 03 Oct 2008 11:52:57.0170 (UTC) FILETIME=[93A7E320:01C9254E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
---
 drivers/misc/ssi/Kconfig          |   11 +
 drivers/misc/ssi/Makefile         |    7 +
 drivers/misc/ssi/ssi_driver.c     |  513 +++++++++++++++++++++++++++++++++++++
 drivers/misc/ssi/ssi_driver.h     |  211 +++++++++++++++
 drivers/misc/ssi/ssi_driver_bus.c |  192 ++++++++++++++
 drivers/misc/ssi/ssi_driver_dma.c |  406 +++++++++++++++++++++++++++++
 drivers/misc/ssi/ssi_driver_if.c  |  335 ++++++++++++++++++++++++
 drivers/misc/ssi/ssi_driver_int.c |  232 +++++++++++++++++
 8 files changed, 1907 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/ssi/Kconfig
 create mode 100644 drivers/misc/ssi/Makefile
 create mode 100644 drivers/misc/ssi/ssi_driver.c
 create mode 100644 drivers/misc/ssi/ssi_driver.h
 create mode 100644 drivers/misc/ssi/ssi_driver_bus.c
 create mode 100644 drivers/misc/ssi/ssi_driver_dma.c
 create mode 100644 drivers/misc/ssi/ssi_driver_if.c
 create mode 100644 drivers/misc/ssi/ssi_driver_int.c

diff --git a/drivers/misc/ssi/Kconfig b/drivers/misc/ssi/Kconfig
new file mode 100644
index 0000000..5e0842c
--- /dev/null
+++ b/drivers/misc/ssi/Kconfig
@@ -0,0 +1,11 @@
+#
+# OMAP SSI HW kernel configuration
+#
+config OMAP_SSI
+	tristate "OMAP SSI hardware driver"
+	depends on ARCH_OMAP
+	default n
+	---help---
+	  If you say Y here, you will enable the OMAP SSI hardware driver.
+
+	  If unsure, say N.
diff --git a/drivers/misc/ssi/Makefile b/drivers/misc/ssi/Makefile
new file mode 100644
index 0000000..2b74e02
--- /dev/null
+++ b/drivers/misc/ssi/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for SSI drivers
+#
+omap_ssi-objs := 	ssi_driver.o ssi_driver_dma.o ssi_driver_int.o \
+			ssi_driver_if.o ssi_driver_bus.o
+
+obj-$(CONFIG_OMAP_SSI)	+= omap_ssi.o
diff --git a/drivers/misc/ssi/ssi_driver.c b/drivers/misc/ssi/ssi_driver.c
new file mode 100644
index 0000000..292e868
--- /dev/null
+++ b/drivers/misc/ssi/ssi_driver.c
@@ -0,0 +1,513 @@
+/*
+ * ssi_driver.c
+ *
+ * Implements SSI module interface, initialization, and PM related functions.
+ *
+ * Copyright (C) 2007-2008 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/err.h>
+#include "ssi_driver.h"
+
+static void ssi_dev_release(struct device *dev)
+{
+}
+
+static void __init ssi_undo_reg_dev(struct platform_device *pd,
+								int p, int ch)
+{
+	struct ssi_platform_data *p_data =
+		(struct ssi_platform_data *) pd->dev.platform_data;
+	struct ssi_port *ssi_p;
+	int port;
+	int channel;
+
+	for (port = p; port >= 0; port--) {
+		ssi_p = &p_data->ssi_ctrl->ssi_port[port];
+		for (channel = ch; channel >= 0 ; channel--)
+			device_unregister(&ssi_p->ssi_channel[channel].dev
+								->device);
+	}
+}
+
+static int __init reg_ssi_dev_ch(struct platform_device *pd,
+						unsigned int p, unsigned int ch)
+{
+	struct ssi_device *dev;
+	struct ssi_platform_data *p_data =
+		(struct ssi_platform_data *) pd->dev.platform_data;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+	dev->n_ctrl = pd->id;
+	dev->n_p = p;
+	dev->n_ch = ch;
+	dev->ch = &p_data->ssi_ctrl->ssi_port[p].ssi_channel[ch];
+	p_data->ssi_ctrl->ssi_port[p].ssi_channel[ch].dev = dev;
+	dev->device.bus = &ssi_bus_type;
+	dev->device.parent = &pd->dev;
+	dev->device.release = ssi_dev_release;
+	if (dev->n_ctrl < 0)
+		snprintf(dev->device.bus_id, sizeof(dev->device.bus_id),
+			"omap_ssi-p%u.c%u", p, ch);
+	else
+		snprintf(dev->device.bus_id, sizeof(dev->device.bus_id),
+			"omap_ssi%d-p%u.c%u", dev->n_ctrl, p, ch);
+
+	return device_register(&dev->device);
+}
+
+static int __init register_ssi_devices(struct platform_device *pd)
+{
+	struct ssi_platform_data *p_data =
+		(struct ssi_platform_data *) pd->dev.platform_data;
+	unsigned int n_ch = 0;
+	int port;
+	int ch = 0;
+	int err = 0;
+
+	for (port = 0; ((port < p_data->num_ports) && (err >= 0)); port++) {
+		n_ch = max(p_data->ports[port].tx_ch,
+						p_data->ports[port].rx_ch);
+		for (ch = 0; ((ch < n_ch) && (err >= 0)); ch++)
+			err = reg_ssi_dev_ch(pd, port, ch);
+	}
+
+	if (err < 0) {
+		port--;
+		ch--;
+		dev_err(&pd->dev, "Error registering ssi device channel "
+					"p%d-c%d : %d\n", port, ch, err);
+		if ((port == 0) && (ch == 0))
+			return err;
+		else if ((port > 0) && (ch == 0))
+			ch = n_ch;
+		ssi_undo_reg_dev(pd, port, ch);
+	}
+	return err;
+}
+
+static int __init ssi_softreset(struct ssi_dev *ssi_ctrl)
+{
+	int ind = 0;
+	void __iomem *base = ssi_ctrl->base;
+	u32 status;
+
+	ssi_outl_or(SSI_SOFTRESET, base, SSI_SYS_SYSCONFIG_REG);
+
+	status = ssi_inl(base, SSI_SYS_SYSSTATUS_REG);
+	while ((!(status & SSI_RESETDONE)) && (ind < SSI_RESETDONE_RETRIES)) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(msecs_to_jiffies(SSI_RESETDONE_TIMEOUT));
+		status = ssi_inl(base, SSI_SYS_SYSSTATUS_REG);
+		ind++;
+	}
+
+	if (ind >= SSI_RESETDONE_RETRIES)
+		return -EIO;
+
+	/* Reseting GDD */
+	ssi_outl_or(SSI_SWRESET, base, SSI_GDD_GRST_REG);
+
+	return 0;
+}
+
+static void __init set_ssi_ports_default(
+						struct platform_device *pd)
+{
+	struct ssi_port_pd *cfg = NULL;
+	struct ssi_platform_data *p_data =
+		(struct ssi_platform_data *) pd->dev.platform_data;
+	unsigned int port = 0;
+	void __iomem *base = p_data->ssi_ctrl->base;
+
+	for (port = 1; port <= p_data->num_ports; port++) {
+		cfg = &p_data->ports[port - 1];
+		ssi_outl(cfg->tx_mode, base, SSI_SST_MODE_REG(port));
+		ssi_outl(cfg->tx_frame_size, base, SSI_SST_FRAMESIZE_REG(port));
+		ssi_outl(cfg->divisor, base, SSI_SST_DIVISOR_REG(port));
+		ssi_outl(cfg->tx_ch, base, SSI_SST_CHANNELS_REG(port));
+		ssi_outl(cfg->arb_mode, base, SSI_SST_ARBMODE_REG(port));
+
+		ssi_outl(cfg->rx_mode, base, SSI_SSR_MODE_REG(port));
+		ssi_outl(cfg->rx_frame_size, base, SSI_SSR_FRAMESIZE_REG(port));
+		ssi_outl(cfg->rx_ch, base, SSI_SSR_CHANNELS_REG(port));
+		ssi_outl(cfg->timeout, base, SSI_SSR_TIMEOUT_REG(port));
+	}
+}
+
+static int __init ssi_port_channels_init(
+			struct platform_device *pd, unsigned int lport)
+{
+	struct ssi_platform_data *p_data =
+		(struct ssi_platform_data *) pd->dev.platform_data;
+	struct ssi_channel *ch;
+	struct ssi_port *port;
+	unsigned int n_ch;
+	unsigned int ch_i;
+
+	n_ch = max(p_data->ports[lport].tx_ch, p_data->ports[lport].rx_ch);
+	port =  &p_data->ssi_ctrl->ssi_port[lport];
+	for (ch_i = 0; ch_i < n_ch; ch_i++) {
+		ch = &port->ssi_channel[ch_i];
+		ch->channel_number = ch_i;
+		ch->flags = 0;
+		ch->ssi_port = port;
+		ch->read_data.addr = NULL;
+		ch->read_data.size = 0;
+		ch->read_data.lch = -1;
+		ch->write_data.addr = NULL;
+		ch->write_data.size = 0;
+		ch->write_data.lch = -1;
+		spin_lock_init(&ch->ssi_ch_lock);
+	}
+
+	return 0;
+}
+
+static int __init ssi_ports_init(struct platform_device *pd)
+{
+	struct ssi_platform_data *p_data =
+		(struct ssi_platform_data *) pd->dev.platform_data;
+	struct ssi_port *ssi_p = NULL;
+	unsigned int port = 0;
+	unsigned int err = 0;
+	unsigned int n_ports;
+
+	n_ports = min(p_data->num_ports, (u8)SSI_MAX_PORTS);
+
+	for (port = 0; ((port < n_ports) && (err >= 0)); port++) {
+		ssi_p = &p_data->ssi_ctrl->ssi_port[port];
+		ssi_p->port_number = port + 1;
+		ssi_p->ssi_controller = p_data->ssi_ctrl;
+		ssi_p->max_ch = max(p_data->ports[port].tx_ch,
+						p_data->ports[port].rx_ch);
+		ssi_p->max_ch = min(ssi_p->max_ch, (u8)SSI_PORT_MAX_CH);
+		ssi_p->n_irq = p_data->ports[port].n_irq;
+		ssi_p->irq = 0;
+		spin_lock_init(&ssi_p->lock);
+		err = ssi_port_channels_init(pd, port);
+	}
+
+	return 0;
+}
+
+static int __init ssi_controller_init(struct platform_device *pd)
+{
+	struct ssi_platform_data *p_data =
+		(struct ssi_platform_data *) pd->dev.platform_data;
+	struct ssi_dev *ssi_ctrl = p_data->ssi_ctrl;
+	int err;
+
+	ssi_ctrl->id = pd->id;
+	ssi_ctrl->max_p = p_data->num_ports;
+	ssi_ctrl->pdev = pd;
+	spin_lock_init(&ssi_ctrl->lock);
+	ssi_ctrl->ssi_clk = clk_get(&pd->dev, p_data->clk_name);
+	if (IS_ERR(ssi_ctrl->ssi_clk)) {
+		dev_err(&pd->dev, "Unable to get SSI clocks");
+		return PTR_ERR(ssi_ctrl->ssi_clk);
+	}
+
+	err = ssi_ports_init(pd);
+	if (err < 0) {
+		dev_err(&pd->dev, "Error on ssi_controller initialization");
+		clk_put(ssi_ctrl->ssi_clk);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static void ssi_controller_exit(struct platform_device *pd)
+{
+	struct ssi_platform_data *p_data =
+		(struct ssi_platform_data *) pd->dev.platform_data;
+	struct ssi_dev *ssi_ctrl = p_data->ssi_ctrl;
+
+	p_data->ssi_ctrl = NULL;
+	ssi_ctrl->pdev = NULL;
+	clk_put(ssi_ctrl->ssi_clk);
+
+}
+
+static int __init request_ssi_irqs(struct platform_device *pd)
+{
+	struct ssi_platform_data *p_data = pd->dev.platform_data;
+	struct ssi_dev *ssi_ctrl = p_data->ssi_ctrl;
+	struct ssi_port *ssi_p;
+	struct resource *mpu_irq;
+	int i;
+	int j;
+	int err = 0;
+
+	for (i = 0; ((i < p_data->num_ports) && (!err)); i++) {
+		mpu_irq = platform_get_resource(pd, IORESOURCE_IRQ, i*2);
+		if (!mpu_irq) {
+			dev_err(&pd->dev, "SSI misses info for MPU IRQ"
+							" on port %d", i + 1);
+			err = -ENODEV;
+		} else {
+			ssi_p = &ssi_ctrl->ssi_port[i];
+			ssi_p->n_irq = 0; /* We only use one irq line */
+			ssi_p->irq = mpu_irq->start;
+			tasklet_init(&ssi_p->ssi_tasklet,
+					do_ssi_tasklet,	(unsigned long)ssi_p);
+			err = request_irq(mpu_irq->start, ssi_mpu_handler,
+				IRQF_DISABLED, mpu_irq->name, ssi_p);
+			if (err < 0) {
+				dev_err(&pd->dev, "FAILED request IRQ (%d)",
+							 mpu_irq->start);
+				err = -EBUSY;
+			}
+		}
+	}
+
+	if (err < 0) {
+		/* Let's free the reserved resources if there are any errors */
+		for (j = 0; (j > (i-1)); j++) {
+			printk(KERN_DEBUG LOG_NAME "Free resources on port %d",
+									j+1);
+			ssi_p = &ssi_ctrl->ssi_port[i];
+			tasklet_disable(&ssi_p->ssi_tasklet);
+			free_irq(ssi_p->irq, ssi_p);
+		}
+	}
+
+	return err;
+}
+
+static int __init request_ssi_gdd_irq(struct platform_device *pd)
+{
+	struct ssi_platform_data *p_data = pd->dev.platform_data;
+	struct ssi_dev *ssi_ctrl = p_data->ssi_ctrl;
+	struct resource *gdd_irq;
+	int err = 0;
+
+	gdd_irq = platform_get_resource(pd, IORESOURCE_IRQ, 4);
+	if (!gdd_irq) {
+		dev_err(&pd->dev, "SSI device has no info about GDD IRQ");
+		return -ENODEV;
+	}
+
+	ssi_ctrl->gdd_irq = gdd_irq->start;
+	err = request_irq(gdd_irq->start, ssi_gdd_mpu_handler,
+		IRQF_DISABLED, gdd_irq->name, ssi_ctrl);
+	if (err < 0) {
+		dev_err(&pd->dev, "FAILED to request IRQ NUMBER (%d)",
+							gdd_irq->start);
+		return -EBUSY;
+	}
+	tasklet_init(&ssi_ctrl->ssi_gdd_tasklet, do_ssi_gdd_tasklet,
+			(unsigned long)ssi_ctrl);
+
+	return err;
+}
+
+static void free_ssi_irqs(struct ssi_dev *ssi_ctrl)
+{
+	struct ssi_port *ssi_p;
+	int i;
+
+	for (i = 0; (i < ssi_ctrl->max_p); i++) {
+		ssi_p = &ssi_ctrl->ssi_port[i];
+		tasklet_disable(&ssi_p->ssi_tasklet);
+		free_irq(ssi_p->irq, ssi_p);
+	}
+}
+
+static void free_ssi_gdd_irq(struct ssi_dev *ssi_ctrl)
+{
+	tasklet_disable(&ssi_ctrl->ssi_gdd_tasklet);
+	free_irq(ssi_ctrl->gdd_irq, ssi_ctrl);
+}
+
+static int __init ssi_probe(struct platform_device *pd)
+{
+	struct resource *mem, *ioarea;
+	struct ssi_dev *ssi_ctrl = NULL;
+	struct ssi_platform_data *p_data = NULL;
+	u32 revision = 0;
+	int err = 0;
+
+
+	if ((pd == NULL) || (pd->dev.platform_data == NULL)) {
+		pr_err(LOG_NAME "No device/platform_data found on "
+								"ssi device\n");
+		return -ENODEV;
+	}
+
+	ssi_ctrl = kzalloc(sizeof(*ssi_ctrl), GFP_KERNEL);
+	if (ssi_ctrl == NULL) {
+		dev_err(&pd->dev, "Could not allocate memory for"
+					" struct ssi_dev\n");
+		return -ENOMEM;
+	}
+
+	p_data = (struct ssi_platform_data *) pd->dev.platform_data;
+	p_data->ssi_ctrl = ssi_ctrl;
+
+	mem = platform_get_resource(pd, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(&pd->dev, "SSI device does not have "
+					"SSI IO memory region information\n");
+		err = -ENODEV;
+		goto rback5;
+	}
+
+	err = ssi_controller_init(pd);
+	if (err < 0) {
+		dev_err(&pd->dev, "Could not initialize ssi controller:"
+						" %d\n", err);
+		goto rback5;
+	}
+
+	ioarea = request_mem_region(mem->start, (mem->end - mem->start) + 1,
+		 pd->dev.bus_id);
+	if (!ioarea) {
+		dev_err(&pd->dev, "Unable to request SSI IO memory "
+								"region\n");
+		err = -EBUSY;
+		goto rollback4;
+	}
+
+	ssi_ctrl->base = (void __iomem *)mem->start;
+
+	clk_enable(ssi_ctrl->ssi_clk);
+
+	err = request_ssi_irqs(pd);
+	if (err < 0)
+		goto rollback1;
+
+	err = request_ssi_gdd_irq(pd);
+	if (err < 0)
+		goto rollback2;
+
+	err = ssi_softreset(ssi_ctrl);
+	if (err < 0)
+		goto rollback3;
+
+	/* Set default PM settings */
+	ssi_outl((SSI_AUTOIDLE | SSI_SIDLEMODE_SMART | SSI_MIDLEMODE_SMART),
+			ssi_ctrl->base,  SSI_SYS_SYSCONFIG_REG);
+	ssi_outl(SSI_CLK_AUTOGATING_ON, ssi_ctrl->base, SSI_GDD_GCR_REG);
+
+	set_ssi_ports_default(pd);
+
+	/* Gather info from registers for the driver.(REVISION) */
+	revision = ssi_inl(ssi_ctrl->base, SSI_SYS_REVISION_REG);
+	dev_info(&pd->dev, "SSI Hardware REVISION %d.%d\n",
+		 (revision & SSI_REV_MAJOR) >> 4, (revision & SSI_REV_MINOR));
+
+	err = register_ssi_devices(pd);
+	if (err < 0)
+		goto rollback3;
+
+	clk_disable(ssi_ctrl->ssi_clk);
+
+	return err;
+
+rollback3:
+	free_ssi_gdd_irq(ssi_ctrl);
+rollback2:
+	free_ssi_irqs(ssi_ctrl);
+rollback1:
+	release_mem_region(mem->start, mem->end - mem->start + 1);
+	clk_disable(ssi_ctrl->ssi_clk);
+rollback4:
+	ssi_controller_exit(pd);
+rback5:
+	kfree(ssi_ctrl);
+	return err;
+}
+
+static void __exit close_all_ch(struct ssi_dev *ssi_ctrl)
+{
+	struct ssi_port *ssi_p;
+	unsigned int port;
+	unsigned int ch;
+
+	for (port = 0; port < ssi_ctrl->max_p; port++) {
+		ssi_p = &ssi_ctrl->ssi_port[port];
+		for (ch = 0; ch < ssi_p->max_ch; ch++)
+			ssi_close(ssi_p->ssi_channel[ch].dev);
+	}
+}
+
+static int __exit ssi_remove(struct platform_device *pd)
+{
+	struct resource *mem;
+	struct ssi_platform_data *p_data =
+		(struct ssi_platform_data *) pd->dev.platform_data;
+	struct ssi_dev *ssi_ctrl = p_data->ssi_ctrl;
+
+	close_all_ch(ssi_ctrl);
+	free_ssi_gdd_irq(ssi_ctrl);
+	free_ssi_irqs(ssi_ctrl);
+	mem = platform_get_resource(pd, IORESOURCE_MEM, 0);
+	if (mem)
+		release_mem_region(mem->start, mem->end - mem->start + 1);
+	ssi_controller_exit(pd);
+	kfree(ssi_ctrl);
+
+	return 0;
+}
+
+static struct platform_driver ssi_pdriver = {
+	.probe = ssi_probe,
+	.remove = __exit_p(ssi_remove),
+	.driver = {
+		.name = "omap_ssi",
+		.owner = THIS_MODULE,
+	}
+};
+
+static int __init ssi_driver_init(void)
+{
+	int err = 0;
+
+	pr_info("SSI DRIVER Version " SSI_DRIVER_VERSION "\n");
+
+	ssi_bus_init();
+	err = platform_driver_probe(&ssi_pdriver, ssi_probe);
+	if (err < 0) {
+		pr_err(LOG_NAME "Platform DRIVER register FAILED: %d\n", err);
+		ssi_bus_exit();
+		return err;
+	}
+
+	return 0;
+}
+
+static void __exit ssi_driver_exit(void)
+{
+	ssi_bus_exit();
+	platform_driver_unregister(&ssi_pdriver);
+
+	pr_info("SSI DRIVER removed\n");
+}
+
+module_init(ssi_driver_init);
+module_exit(ssi_driver_exit);
+
+MODULE_ALIAS("platform:omap_ssi");
+MODULE_AUTHOR(SSI_DRIVER_AUTHOR);
+MODULE_DESCRIPTION(SSI_DRIVER_DESC);
+MODULE_LICENSE("GPL");
diff --git a/drivers/misc/ssi/ssi_driver.h b/drivers/misc/ssi/ssi_driver.h
new file mode 100644
index 0000000..3c6d849
--- /dev/null
+++ b/drivers/misc/ssi/ssi_driver.h
@@ -0,0 +1,211 @@
+/*
+ * ssi_driver.h
+ *
+ * Header file for the SSI driver low level interface.
+ *
+ * Copyright (C) 2007-2008 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __SSI_DRIVER_H__
+#define __SSI_DRIVER_H__
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/clk.h>
+#include <linux/ioport.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+
+#include <mach/ssi/ssi_reg_common.h>
+#include <mach/ssi/ssi_sys_reg.h>
+#include <mach/ssi/ssi_ssr_reg.h>
+#include <mach/ssi/ssi_sst_reg.h>
+#include <mach/ssi/ssi_gdd_reg.h>
+
+#include <linux/ssi_driver_if.h>
+
+#define	SSI_DRIVER_VERSION	"1.1-rc2"
+#define SSI_DRIVER_AUTHOR	"Carlos Chinea / Nokia"
+#define SSI_DRIVER_DESC		"Synchronous Serial Interface Driver"
+#define SSI_DRIVER_LINCESE	"GPL"
+#define SSI_DRIVER_NAME		"ssi_driver"
+
+#define SSI_DEVICE_NAME		"ssi_device"
+
+/* 10 ms */
+#define SSI_RESETDONE_TIMEOUT	10
+/* Let's retry 20 times.=>20x10 ms=200 ms */
+#define SSI_RESETDONE_RETRIES	20
+
+/* Channel states */
+#define	SSI_CH_OPEN		0x01
+
+/*
+ * The number of channels to use by the driver in the ports, or the highest
+ * port channel number (+1) used. (MAX:8)
+ */
+#define SSI_PORT_MAX_CH		4
+/* Number of logical channel in GDD */
+#define SSI_NUM_LCH		8
+
+#define LOG_NAME		"OMAP SSI: "
+#define SSI_PREFIX		"ssi:"
+
+/*
+ * Callbacks use by the SSI upper layer (SSI protocol) to receive data
+ * from the port channels.
+ */
+struct ssi_channel_ops {
+	void (*write_done) (struct ssi_device *dev);
+	void (*read_done) (struct ssi_device *dev);
+};
+
+struct ssi_data {
+	/* Pointer to the data to be sent/received */
+	u32 *addr;
+	/*
+	 * Number of words to be sent or space reserved for data to be
+	 * received.
+	 */
+	unsigned int size;
+	/* Holds GDD logical channed number */
+	int lch;
+};
+
+struct ssi_channel {
+	struct ssi_channel_ops ops;
+	struct ssi_data read_data;
+	struct ssi_data write_data;
+	struct ssi_port *ssi_port;
+	u8 flags;
+	u8 channel_number;
+	spinlock_t ssi_ch_lock;
+	struct ssi_device *dev;
+	void *priv;
+};
+
+/* Holds information related to SSI port */
+struct ssi_port {
+	struct ssi_channel ssi_channel[SSI_PORT_MAX_CH];
+	struct ssi_dev *ssi_controller;
+	u8 port_number;
+	u8 max_ch;
+	u8 n_irq; /* IRQ0 or IRQ1 */
+	int irq	    /* Actual IRQ number */;
+	spinlock_t lock;
+	struct tasklet_struct ssi_tasklet;
+};
+
+/*
+ * Struct definition to hold information about the clocks, ssi controller
+ * and the ssi ports.
+ */
+struct ssi_dev {
+	/* Holds reference to PORT 1 (and PORT2 if defined) */
+	struct ssi_port ssi_port[SSI_MAX_PORTS];
+	int id;
+	u8 flags;
+	u8 max_p;
+	struct clk *ssi_clk;
+	void __iomem *base;
+	spinlock_t lock;
+	int gdd_irq;
+	struct tasklet_struct ssi_gdd_tasklet;
+	struct platform_device *pdev;
+};
+
+/* SSI Bus */
+struct ssi_port_event {
+	struct ssi_port *ssi_port;
+	unsigned int event;
+	void *priv;
+};
+extern struct bus_type ssi_bus_type;
+
+int ssi_port_event_handler(struct ssi_port *p, unsigned int event, void *arg);
+int ssi_bus_init(void);
+void ssi_bus_exit(void);
+/* End SSI Bus */
+
+int ssi_driver_read_interrupt(struct ssi_channel *ssi_channel, u32 *data);
+int ssi_driver_write_interrupt(struct ssi_channel *ssi_channel, u32 *data);
+int ssi_driver_read_dma(struct ssi_channel *ssi_channel, u32 *data,
+			unsigned int count);
+int ssi_driver_write_dma(struct ssi_channel *ssi_channel, u32 *data,
+			unsigned int count);
+
+void ssi_driver_cancel_write_interrupt(struct ssi_channel *ch);
+void ssi_driver_cancel_read_interrupt(struct ssi_channel *ch);
+void ssi_driver_cancel_write_dma(struct ssi_channel *ch);
+void ssi_driver_cancel_read_dma(struct ssi_channel *ch);
+
+irqreturn_t ssi_mpu_handler(int irq, void *ssi_port);
+irqreturn_t ssi_gdd_mpu_handler(int irq, void *ssi_controller);
+
+void do_ssi_tasklet(unsigned long ssi_port);
+void do_ssi_gdd_tasklet(unsigned long device);
+
+static inline u32 ssi_inl(void __iomem *base, u32 offset)
+{
+	return inl(OMAP2_IO_ADDRESS(base + offset));
+}
+
+static inline void ssi_outl(u32 data, void __iomem *base, u32 offset)
+{
+	outl(data, OMAP2_IO_ADDRESS(base + offset));
+}
+
+static inline void ssi_outl_or(u32 data, void __iomem *base, u32 offset)
+{
+	u32 tmp = ssi_inl(base, offset);
+	ssi_outl((tmp | data), base, offset);
+}
+
+static inline void ssi_outl_and(u32 data, void __iomem *base, u32 offset)
+{
+	u32 tmp = ssi_inl(base, offset);
+	ssi_outl((tmp & data), base, offset);
+}
+
+static inline u16 ssi_inw(void __iomem *base, u32 offset)
+{
+	return inw(OMAP2_IO_ADDRESS(base + offset));
+}
+
+static inline void ssi_outw(u16 data, void __iomem *base, u32 offset)
+{
+	outw(data, OMAP2_IO_ADDRESS(base + offset));
+}
+
+static inline void ssi_outw_or(u16 data, void __iomem *base, u32 offset)
+{
+	u16 tmp = ssi_inw(base, offset);
+	ssi_outw((tmp | data), base, offset);
+}
+
+static inline void ssi_outw_and(u16 data, void __iomem *base, u32 offset)
+{
+	u16 tmp = ssi_inw(base, offset);
+	ssi_outw((tmp & data), base, offset);
+}
+#endif
diff --git a/drivers/misc/ssi/ssi_driver_bus.c b/drivers/misc/ssi/ssi_driver_bus.c
new file mode 100644
index 0000000..6a07ee0
--- /dev/null
+++ b/drivers/misc/ssi/ssi_driver_bus.c
@@ -0,0 +1,192 @@
+/*
+ * ssi_driver_bus.c
+ *
+ * Implements SSI bus, device and driver interface.
+ *
+ * Copyright (C) 2007-2008 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+#include <linux/device.h>
+#include "ssi_driver.h"
+
+/* LDM. defintions for the ssi bus, ssi device, and ssi_device driver */
+struct bus_type ssi_bus_type;
+
+static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
+								char *buf)
+{
+	return snprintf(buf, BUS_ID_SIZE + 1, "%s%s\n", SSI_PREFIX,
+								dev->bus_id);
+}
+
+static struct device_attribute ssi_dev_attrs[] = {
+	__ATTR_RO(modalias),
+	__ATTR_NULL,
+};
+
+static int ssi_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	add_uevent_var(env, "MODALIAS=%s%s", SSI_PREFIX, dev->bus_id);
+	return 0;
+}
+
+/* NOTE: Function called in interrupt context */
+static int ssi_e_handler(struct device_driver *drv, void *p_event)
+{
+	struct ssi_port_event *event = (struct ssi_port_event *)p_event;
+	struct ssi_device_driver *ssi_drv =  to_ssi_device_driver(drv);
+	struct ssi_port *p = event->ssi_port;
+
+	BUG_ON(p_event == NULL);
+
+	if ((ssi_drv->port_event) &&
+		(test_bit(event->event, &ssi_drv->event_mask)) &&
+		((p->ssi_controller->id == -1) ||
+		(test_bit(p->ssi_controller->id, &ssi_drv->ctrl_mask))) &&
+		(ssi_drv->ch_mask[p->port_number - 1] != 0)) {
+
+		(*ssi_drv->port_event)(p->ssi_controller->id, p->port_number,
+					event->event, event->priv);
+	}
+
+	return 0;
+}
+
+int ssi_port_event_handler(struct ssi_port *p, unsigned int event, void *arg)
+{
+	int err = 0;
+	struct ssi_port_event p_ev = {
+		.ssi_port = p,
+		.event = event,
+		.priv = arg
+	};
+
+	BUG_ON(p == NULL);
+
+	err = bus_for_each_drv(&ssi_bus_type, NULL, &p_ev, ssi_e_handler);
+
+	return err;
+}
+
+static int ssi_bus_match(struct device *device, struct device_driver *driver)
+{
+	struct ssi_device *dev = to_ssi_device(device);
+	struct ssi_device_driver *drv = to_ssi_device_driver(driver);
+
+	if (!test_bit(dev->n_ctrl, &drv->ctrl_mask))
+		return 0;
+
+	if (!test_bit(dev->n_ch, &drv->ch_mask[dev->n_p]))
+		return 0;
+
+	return 1;
+}
+
+int ssi_bus_unreg_dev(struct device *device, void *p)
+{
+	device->release(device);
+	device_unregister(device);
+
+	return 0;
+}
+
+int __init ssi_bus_init(void)
+{
+
+	return bus_register(&ssi_bus_type);
+
+}
+
+void ssi_bus_exit(void)
+{
+	bus_for_each_dev(&ssi_bus_type, NULL, NULL, ssi_bus_unreg_dev);
+	bus_unregister(&ssi_bus_type);
+}
+
+static int ssi_driver_probe(struct device *dev)
+{
+	struct ssi_device_driver *drv = to_ssi_device_driver(dev->driver);
+
+	return 	drv->probe(to_ssi_device(dev));
+}
+
+static int ssi_driver_remove(struct device *dev)
+{
+	struct ssi_device_driver *drv = to_ssi_device_driver(dev->driver);
+
+	return drv->remove(to_ssi_device(dev));
+}
+
+static int ssi_driver_suspend(struct device *dev, pm_message_t mesg)
+{
+	struct ssi_device_driver *drv = to_ssi_device_driver(dev->driver);
+
+	return drv->suspend(to_ssi_device(dev), mesg);
+}
+
+static int ssi_driver_resume(struct device *dev)
+{
+	struct ssi_device_driver *drv = to_ssi_device_driver(dev->driver);
+
+	return drv->resume(to_ssi_device(dev));
+}
+
+struct bus_type ssi_bus_type = {
+	.name = "ssi",
+	.dev_attrs = ssi_dev_attrs,
+	.match = ssi_bus_match,
+	.uevent = ssi_bus_uevent,
+};
+
+/**
+ * register_ssi_driver - Register SSI device driver
+ * @driver - reference to the SSI device driver.
+ */
+int register_ssi_driver(struct ssi_device_driver *driver)
+{
+	int ret = 0;
+
+	BUG_ON(driver == NULL);
+
+	driver->driver.bus = &ssi_bus_type;
+	if (driver->probe)
+		driver->driver.probe = ssi_driver_probe;
+	if (driver->remove)
+		driver->driver.remove = ssi_driver_remove;
+	if (driver->suspend)
+		driver->driver.suspend = ssi_driver_suspend;
+	if (driver->resume)
+		driver->driver.resume = ssi_driver_resume;
+
+	ret = driver_register(&driver->driver);
+
+	return ret;
+}
+EXPORT_SYMBOL(register_ssi_driver);
+
+/**
+ * unregister_ssi_driver - Unregister SSI device driver
+ * @driver - reference to the SSI device driver.
+ */
+void unregister_ssi_driver(struct ssi_device_driver *driver)
+{
+	BUG_ON(driver == NULL);
+
+	driver_unregister(&driver->driver);
+}
+EXPORT_SYMBOL(unregister_ssi_driver);
diff --git a/drivers/misc/ssi/ssi_driver_dma.c b/drivers/misc/ssi/ssi_driver_dma.c
new file mode 100644
index 0000000..2524a12
--- /dev/null
+++ b/drivers/misc/ssi/ssi_driver_dma.c
@@ -0,0 +1,406 @@
+/*
+ * ssi_driver_dma.c
+ *
+ * Implements SSI low level interface driver functionality with DMA support.
+ *
+ * Copyright (C) 2007-2008 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+#include <linux/dma-mapping.h>
+#include "ssi_driver.h"
+
+#define SSI_SYNC_WRITE	0
+#define SSI_SYNC_READ  	1
+
+static unsigned char sync_table[2][2][8] = {
+	{
+	 {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08},
+	 {0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x00}
+	 },
+	{
+	 {0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17},
+	 {0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F}
+	 }
+};
+
+static unsigned int get_sync_type(unsigned int sync)
+{
+	return (sync & 0x10) ? SSI_SYNC_READ : SSI_SYNC_WRITE;
+}
+
+static unsigned int get_sync_port(unsigned int sync)
+{
+	if (((sync >= 0x01) && (sync <= 0x08)) ||
+					((sync >= 0x10) && (sync <= 0x17)))
+		return 1;
+	else if (((sync >= 0x09) && (sync <= 0x0F)) ||
+					((sync >= 0x18) && (sync <= 0x1E)))
+		return 2;
+	else
+		return 3;
+}
+
+static unsigned int get_sync_channel(unsigned int sync)
+{
+	if ((sync == 0x00) || (sync == 0x1F))
+		return 8;
+
+	if (sync & 0x10)
+		return (sync & 0x0F) % 8;
+	else
+		return (sync - 1) % 8;
+}
+
+static unsigned int get_sync(unsigned int port,
+			     unsigned int channel, unsigned int type)
+{
+	if ((port == 0) || (port > SSI_MAX_PORTS) ||
+			(channel >= SSI_PORT_MAX_CH) || (type > SSI_SYNC_READ))
+		return 0x00;
+
+	return sync_table[type][port - 1][channel];
+}
+
+static void rst_ch_read(struct ssi_dev *ssi_ctrl,
+				unsigned int n_p, unsigned int n_ch)
+{
+	struct ssi_channel *ch =
+		&ssi_ctrl->ssi_port[n_p - 1].ssi_channel[n_ch];
+
+	ch->read_data.addr = NULL;
+	ch->read_data.size = 0;
+	ch->read_data.lch = -1;
+}
+
+static void rst_ch_write(struct ssi_dev *ssi_ctrl,
+				unsigned int n_p, unsigned int n_ch)
+{
+	struct ssi_channel *ch =
+		&ssi_ctrl->ssi_port[n_p - 1].ssi_channel[n_ch];
+
+	ch->write_data.addr = NULL;
+	ch->write_data.size = 0;
+	ch->write_data.lch = -1;
+}
+
+/*
+ * get_free_lch - Get a free GDD(DMA)logical channel
+ * @ssi_ctrl- SSI controller of the GDD.
+ *
+ * Needs to be called holding the gdd controller lock
+ */
+static unsigned int get_free_lch(struct ssi_dev *ssi_ctrl)
+{
+	unsigned int enable_reg;
+	unsigned int lch = 0;
+
+	enable_reg = ssi_inl(ssi_ctrl->base, SSI_SYS_GDD_MPU_IRQ_ENABLE_REG);
+	while ((lch < SSI_NUM_LCH) && (enable_reg & SSI_GDD_LCH(lch)))
+		lch++;
+
+	return lch;
+}
+
+/*
+ * ssi_driver_write_dma - Program GDD [DMA] to write data from memory to
+ * the ssi channel buffer.
+ * @ssi_channel - pointer to the ssi_channel to write data to.
+ * @data - 32-bit word pointer to the data.
+ * @size - Number of 32bit words to be transfered.
+ *
+ * ssi_controller lock must be hold before calling this function.
+ */
+int ssi_driver_write_dma(struct ssi_channel *ssi_channel, u32 *data,
+			 unsigned int size)
+{
+	struct ssi_dev *ssi_ctrl = ssi_channel->ssi_port->ssi_controller;
+	void __iomem *base = ssi_ctrl->base;
+	unsigned int port = ssi_channel->ssi_port->port_number;
+	unsigned int channel = ssi_channel->channel_number;
+	unsigned int sync;
+	int lch;
+	dma_addr_t dma_data;
+	u32 s_addr;
+	u16 tmp;
+
+	if ((size < 1) || (data == NULL))
+		return -EINVAL;
+
+	clk_enable(ssi_ctrl->ssi_clk);
+
+	lch = get_free_lch(ssi_ctrl);
+	if (lch >= SSI_NUM_LCH) {
+		dev_err(&ssi_ctrl->pdev->dev, "No free GDD logical "
+								"channels.\n");
+		clk_disable(ssi_ctrl->ssi_clk);
+		return -EBUSY;	/* No free GDD logical channels. */
+	}
+	/* NOTE: Gettting a free gdd logical channel and
+	 * reserve it must be done atomicaly. */
+	ssi_channel->write_data.lch = lch;
+
+	sync = get_sync(port, channel, SSI_SYNC_WRITE);
+	dma_data = dma_map_single(NULL, data, size * 4, DMA_TO_DEVICE);
+	dma_sync_single(NULL, dma_data, size * 4, DMA_TO_DEVICE);
+
+	tmp = SSI_SRC_SINGLE_ACCESS0 |
+		SSI_SRC_MEMORY_PORT |
+		SSI_DST_SINGLE_ACCESS0 |
+		SSI_DST_PERIPHERAL_PORT |
+		SSI_DATA_TYPE_S32;
+	ssi_outw(tmp, base, SSI_GDD_CSDP_REG(lch));
+	tmp = SSI_SRC_AMODE_POSTINC | SSI_DST_AMODE_CONST | sync;
+	ssi_outw(tmp, base, SSI_GDD_CCR_REG(lch));
+	ssi_outw((SSI_BLOCK_IE | SSI_TOUT_IE), base, SSI_GDD_CICR_REG(lch));
+	s_addr = (u32)base + SSI_SST_BUFFER_CH_REG(port, channel);
+	ssi_outl(s_addr, base, SSI_GDD_CDSA_REG(lch));
+	ssi_outl(dma_data, base, SSI_GDD_CSSA_REG(lch));
+	ssi_outw(size, base, SSI_GDD_CEN_REG(lch));
+	ssi_outl_or(SSI_GDD_LCH(lch), base, SSI_SYS_GDD_MPU_IRQ_ENABLE_REG);
+	ssi_outw_or(SSI_CCR_ENABLE, base, SSI_GDD_CCR_REG(lch));
+
+	return 0;
+}
+
+/*
+ * ssi_driver_read_dma - Program GDD [DMA] to write data to memory from
+ * the ssi channel buffer.
+ * @ssi_channel - pointer to the ssi_channel to read data from.
+ * @data - 32-bit word pointer where to store the incoming data.
+ * @size - Number of 32bit words to be transfered to the buffer.
+ *
+ * ssi_controller lock must be hold before calling this function.
+ */
+int ssi_driver_read_dma(struct ssi_channel *ssi_channel, u32 *data,
+			unsigned int count)
+{
+	struct ssi_dev *ssi_ctrl = ssi_channel->ssi_port->ssi_controller;
+	void __iomem *base = ssi_ctrl->base;
+	unsigned int port = ssi_channel->ssi_port->port_number;
+	unsigned int channel = ssi_channel->channel_number;
+	unsigned int sync;
+	unsigned int lch;
+	dma_addr_t dma_data;
+	u32 d_addr;
+	u16 tmp;
+
+	clk_enable(ssi_ctrl->ssi_clk);
+	lch = get_free_lch(ssi_ctrl);
+	if (lch >= SSI_NUM_LCH) {
+		dev_err(&ssi_ctrl->pdev->dev, "No free GDD logical "
+								"channels.\n");
+		clk_disable(ssi_ctrl->ssi_clk);
+		return -EBUSY;	/* No free GDD logical channels. */
+	}
+	/*
+	 * NOTE: Gettting a free gdd logical channel and
+	 * reserve it must be done atomicaly.
+	 */
+	ssi_channel->read_data.lch = lch;
+
+	sync = get_sync(port, channel, SSI_SYNC_READ);
+
+	dma_data = dma_map_single(NULL, data, count * 4, DMA_FROM_DEVICE);
+
+	tmp = SSI_DST_SINGLE_ACCESS0 |
+		SSI_DST_MEMORY_PORT |
+		SSI_SRC_SINGLE_ACCESS0 |
+		SSI_SRC_PERIPHERAL_PORT |
+		SSI_DATA_TYPE_S32;
+	ssi_outw(tmp, base, SSI_GDD_CSDP_REG(lch));
+	tmp = SSI_DST_AMODE_POSTINC | SSI_SRC_AMODE_CONST | sync;
+	ssi_outw(tmp, base, SSI_GDD_CCR_REG(lch));
+	ssi_outw((SSI_BLOCK_IE | SSI_TOUT_IE), base, SSI_GDD_CICR_REG(lch));
+	d_addr = (u32)base + SSI_SSR_BUFFER_CH_REG(port, channel);
+	ssi_outl(d_addr, base, SSI_GDD_CSSA_REG(lch));
+	ssi_outl((u32)dma_data, base, SSI_GDD_CDSA_REG(lch));
+	ssi_outw(count, base, SSI_GDD_CEN_REG(lch));
+
+	ssi_outl_or(SSI_GDD_LCH(lch), base, SSI_SYS_GDD_MPU_IRQ_ENABLE_REG);
+	ssi_outw_or(SSI_CCR_ENABLE, base, SSI_GDD_CCR_REG(lch));
+
+	return 0;
+}
+
+void ssi_driver_cancel_write_dma(struct ssi_channel *ssi_ch)
+{
+	int lch = ssi_ch->write_data.lch;
+	unsigned int port = ssi_ch->ssi_port->port_number;
+	unsigned int channel = ssi_ch->channel_number;
+	struct ssi_dev *ssi_ctrl = ssi_ch->ssi_port->ssi_controller;
+	u32 ccr;
+
+	if (lch < 0)
+		return;
+
+	clk_enable(ssi_ctrl->ssi_clk);
+	ccr = ssi_inw(ssi_ctrl->base, SSI_GDD_CCR_REG(lch));
+	if (!(ccr & SSI_CCR_ENABLE)) {
+		dev_dbg(&ssi_ch->dev->device, LOG_NAME "Write cancel on not "
+		"enabled logical channel %d CCR REG 0x%08X\n", lch, ccr);
+		clk_disable(ssi_ctrl->ssi_clk);
+		return;
+	}
+
+	ssi_outw_and(~SSI_CCR_ENABLE, ssi_ctrl->base, SSI_GDD_CCR_REG(lch));
+	ssi_outl_and(~SSI_GDD_LCH(lch), ssi_ctrl->base,
+						SSI_SYS_GDD_MPU_IRQ_ENABLE_REG);
+	ssi_outl(SSI_GDD_LCH(lch), ssi_ctrl->base,
+						SSI_SYS_GDD_MPU_IRQ_STATUS_REG);
+
+	ssi_outl_and(~NOTFULL(channel), ssi_ctrl->base,
+						SSI_SST_BUFSTATE_REG(port));
+
+
+	ssi_ch->write_data.addr = NULL;
+	ssi_ch->write_data.size = 0;
+	ssi_ch->write_data.lch = -1;
+	clk_disable(ssi_ctrl->ssi_clk);
+	clk_disable(ssi_ctrl->ssi_clk);
+}
+
+void ssi_driver_cancel_read_dma(struct ssi_channel *ssi_ch)
+{
+	int lch = ssi_ch->read_data.lch;
+	struct ssi_dev *ssi_ctrl = ssi_ch->ssi_port->ssi_controller;
+	unsigned int port = ssi_ch->ssi_port->port_number;
+	unsigned int channel = ssi_ch->channel_number;
+	u32 reg;
+
+	if (lch < 0)
+		return;
+
+	clk_enable(ssi_ctrl->ssi_clk);
+	reg = ssi_inw(ssi_ctrl->base, SSI_GDD_CCR_REG(lch));
+	if (!(reg & SSI_CCR_ENABLE)) {
+		dev_dbg(&ssi_ch->dev->device, LOG_NAME "Read cancel on not "
+		"enable logical channel %d CCR REG 0x%08X\n", lch, reg);
+		clk_disable(ssi_ctrl->ssi_clk);
+		return;
+	}
+
+	ssi_outw_and(~SSI_CCR_ENABLE, ssi_ctrl->base, SSI_GDD_CCR_REG(lch));
+	ssi_outl_and(~SSI_GDD_LCH(lch), ssi_ctrl->base,
+						SSI_SYS_GDD_MPU_IRQ_ENABLE_REG);
+	ssi_outl(SSI_GDD_LCH(lch), ssi_ctrl->base,
+						SSI_SYS_GDD_MPU_IRQ_STATUS_REG);
+
+	ssi_outl_and(~NOTEMPTY(channel), ssi_ctrl->base,
+						SSI_SSR_BUFSTATE_REG(port));
+
+	ssi_ch->read_data.addr = NULL;
+	ssi_ch->read_data.size = 0;
+	ssi_ch->read_data.lch = -1;
+	clk_disable(ssi_ctrl->ssi_clk);
+	clk_disable(ssi_ctrl->ssi_clk);
+}
+
+static void dma_read_cb(struct ssi_dev *ctrl, unsigned int port,
+							unsigned int channel)
+{
+	struct ssi_channel *ch = &ctrl->ssi_port[port - 1].ssi_channel[channel];
+
+	ch->ops.read_done(ch->dev);
+}
+
+static void dma_write_cb(struct ssi_dev *ctrl, unsigned int port,
+							unsigned int channel)
+{
+	struct ssi_channel *ch = &ctrl->ssi_port[port - 1].ssi_channel[channel];
+
+	ch->ops.write_done(ch->dev);
+}
+
+static void do_gdd_lch(struct ssi_dev *ssi_ctrl, unsigned int gdd_lch)
+{
+	void __iomem *base = ssi_ctrl->base;
+	unsigned int port;
+	unsigned int channel;
+	u32 sync;
+	u32 gdd_csr;
+	dma_addr_t dma_h;
+	size_t size;
+
+	sync = ssi_inw(base, SSI_GDD_CCR_REG(gdd_lch)) & SSI_CCR_SYNC_MASK;
+	port = get_sync_port(sync);
+	channel = get_sync_channel(sync);
+
+	spin_lock(&ssi_ctrl->lock);
+
+	ssi_outl_and(~SSI_GDD_LCH(gdd_lch), base,
+						SSI_SYS_GDD_MPU_IRQ_ENABLE_REG);
+	gdd_csr = ssi_inw(base, SSI_GDD_CSR_REG(gdd_lch));
+
+	if (!(gdd_csr & SSI_CSR_TOUR)) {
+		if (get_sync_type(sync) == SSI_SYNC_READ) {
+			dma_h = ssi_inl(base, SSI_GDD_CDSA_REG(gdd_lch));
+			size = ssi_inw(base, SSI_GDD_CEN_REG(gdd_lch)) * 4;
+			dma_sync_single(NULL, dma_h, size, DMA_FROM_DEVICE);
+			rst_ch_read(ssi_ctrl, port, channel);
+			spin_unlock(&ssi_ctrl->lock);
+			dma_read_cb(ssi_ctrl, port, channel);
+		} else {
+			rst_ch_write(ssi_ctrl, port, channel);
+			spin_unlock(&ssi_ctrl->lock);
+			dma_write_cb(ssi_ctrl, port, channel);
+		}
+	} else {
+		dev_err(&ssi_ctrl->pdev->dev, "Error  on GDD transfer "
+				"on gdd channel %d port %d channel %d\n",
+						gdd_lch, port, channel);
+		spin_unlock(&ssi_ctrl->lock);
+		ssi_port_event_handler(&ssi_ctrl->ssi_port[port - 1],
+							SSI_EVENT_ERROR, NULL);
+	}
+}
+
+void do_ssi_gdd_tasklet(unsigned long device)
+{
+	struct ssi_dev *ssi_ctrl = (struct ssi_dev *)device;
+	void __iomem *base = ssi_ctrl->base;
+	unsigned int gdd_lch = 0;
+	u32 status_reg = 0;
+	u32 lch_served = 0;
+
+	clk_enable(ssi_ctrl->ssi_clk);
+
+	status_reg = ssi_inl(base, SSI_SYS_GDD_MPU_IRQ_STATUS_REG);
+
+	for (gdd_lch = 0; gdd_lch < SSI_NUM_LCH; gdd_lch++) {
+		if (status_reg & SSI_GDD_LCH(gdd_lch)) {
+			do_gdd_lch(ssi_ctrl, gdd_lch);
+			lch_served |= SSI_GDD_LCH(gdd_lch);
+			clk_disable(ssi_ctrl->ssi_clk);
+		}
+	}
+
+	ssi_outl(lch_served, base, SSI_SYS_GDD_MPU_IRQ_STATUS_REG);
+	clk_disable(ssi_ctrl->ssi_clk);
+
+	enable_irq(ssi_ctrl->gdd_irq);
+}
+
+irqreturn_t ssi_gdd_mpu_handler(int irq, void *ssi_controller)
+{
+	struct ssi_dev *ssi_ctrl = (struct ssi_dev *)ssi_controller;
+
+	tasklet_hi_schedule(&ssi_ctrl->ssi_gdd_tasklet);
+	disable_irq_nosync(ssi_ctrl->gdd_irq);
+
+	return IRQ_HANDLED;
+}
diff --git a/drivers/misc/ssi/ssi_driver_if.c b/drivers/misc/ssi/ssi_driver_if.c
new file mode 100644
index 0000000..385467e
--- /dev/null
+++ b/drivers/misc/ssi/ssi_driver_if.c
@@ -0,0 +1,335 @@
+/*
+ * ssi_driver_if.c
+ *
+ * Implements SSI hardware driver interfaces for the upper layers.
+ *
+ * Copyright (C) 2007-2008 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include "ssi_driver.h"
+
+/**
+ * ssi_open - open a ssi device channel.
+ * @dev - Reference to the ssi device channel to be openned.
+ *
+ * Returns 0 on success, -EINVAL on bad parameters, -EBUSY if is already opened.
+ */
+int ssi_open(struct ssi_device *dev)
+{
+	struct ssi_channel *ch;
+	struct ssi_port *port;
+	struct ssi_dev *ssi_ctrl;
+
+	if (!dev || !dev->ch) {
+		pr_err(LOG_NAME "Wrong SSI device %p\n", dev);
+		return -EINVAL;
+	}
+
+	ch = dev->ch;
+	if (!ch->ops.read_done || !ch->ops.write_done) {
+		dev_err(&dev->device, "Trying to open with no callbacks "
+								"registered\n");
+		return -EINVAL;
+	}
+	port = ch->ssi_port;
+	ssi_ctrl = port->ssi_controller;
+	spin_lock_bh(&ssi_ctrl->lock);
+	if (ch->flags & SSI_CH_OPEN) {
+		dev_err(&dev->device, "Port %d Channel %d already OPENED\n",
+							dev->n_p, dev->n_ch);
+		spin_unlock_bh(&ssi_ctrl->lock);
+		return -EBUSY;
+	}
+	clk_enable(ssi_ctrl->ssi_clk);
+	ch->flags |= SSI_CH_OPEN;
+	ssi_outl_or(SSI_ERROROCCURED | SSI_BREAKDETECTED, ssi_ctrl->base,
+		SSI_SYS_MPU_ENABLE_REG(port->port_number, port->n_irq));
+	clk_disable(ssi_ctrl->ssi_clk);
+	spin_unlock_bh(&ssi_ctrl->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(ssi_open);
+
+/**
+ * ssi_write - write data into the ssi device channel
+ * @dev - reference to the ssi device channel  to write into.
+ * @data - pointer to a 32-bit word data to be written.
+ * @count - number of 32-bit word to be written.
+ *
+ * Return 0 on sucess, a negative value on failure.
+ * A success values only indicates that the request has been accepted.
+ * Transfer is only completed when the write_done callback is called.
+ *
+ */
+int ssi_write(struct ssi_device *dev, u32 *data, unsigned int count)
+{
+	struct ssi_channel *ch;
+	int err;
+
+	if (unlikely(!dev || !dev->ch || !data || (count <= 0))) {
+		dev_err(&dev->device, "Wrong paramenters "
+			"ssi_device %p data %p count %d", dev, data, count);
+		return -EINVAL;
+	}
+	if (unlikely(!(dev->ch->flags & SSI_CH_OPEN))) {
+		dev_err(&dev->device, "SSI device NOT open\n");
+		return -EINVAL;
+	}
+
+	ch = dev->ch;
+	spin_lock_bh(&ch->ssi_port->ssi_controller->lock);
+	ch->write_data.addr = data;
+	ch->write_data.size = count;
+
+	if (count == 1)
+		err = ssi_driver_write_interrupt(ch, data);
+	else
+		err = ssi_driver_write_dma(ch, data, count);
+
+	if (unlikely(err < 0)) {
+		ch->write_data.addr = NULL;
+		ch->write_data.size = 0;
+	}
+	spin_unlock_bh(&ch->ssi_port->ssi_controller->lock);
+
+	return err;
+
+}
+EXPORT_SYMBOL(ssi_write);
+
+/**
+ * ssi_read - read data from the ssi device channel
+ * @dev - ssi device channel reference to read data from.
+ * @data - pointer to a 32-bit word data to store the data.
+ * @count - number of 32-bit word to be stored.
+ *
+ * Return 0 on sucess, a negative value on failure.
+ * A success values only indicates that the request has been accepted.
+ * Data is only available in the buffer when the read_done callback is called.
+ *
+ */
+int ssi_read(struct ssi_device *dev, u32 *data, unsigned int count)
+{
+	struct ssi_channel *ch;
+	int err;
+
+	if (unlikely(!dev || !dev->ch || !data || (count <= 0))) {
+		dev_err(&dev->device, "Wrong paramenters "
+			"ssi_device %p data %p count %d", dev, data, count);
+		return -EINVAL;
+	}
+	if (unlikely(!(dev->ch->flags & SSI_CH_OPEN))) {
+		dev_err(&dev->device, "SSI device NOT open\n");
+		return -EINVAL;
+	}
+
+	ch = dev->ch;
+	spin_lock_bh(&ch->ssi_port->ssi_controller->lock);
+	ch->read_data.addr = data;
+	ch->read_data.size = count;
+
+	if (count == 1)
+		err = ssi_driver_read_interrupt(ch, data);
+	else
+		err = ssi_driver_read_dma(ch, data, count);
+
+	if (unlikely(err < 0)) {
+		ch->read_data.addr = NULL;
+		ch->read_data.size = 0;
+	}
+	spin_unlock_bh(&ch->ssi_port->ssi_controller->lock);
+
+	return err;
+}
+EXPORT_SYMBOL(ssi_read);
+
+void __ssi_write_cancel(struct ssi_channel *ch)
+{
+	if (ch->write_data.size == 1)
+		ssi_driver_cancel_write_interrupt(ch);
+	else if (ch->write_data.size > 1)
+		ssi_driver_cancel_write_dma(ch);
+
+}
+/**
+ * ssi_write_cancel - Cancel pending write request.
+ * @dev - ssi device channel where to cancel the pending write.
+ *
+ * write_done() callback will not be called after sucess of this function.
+ */
+void ssi_write_cancel(struct ssi_device *dev)
+{
+	if (unlikely(!dev || !dev->ch)) {
+		pr_err(LOG_NAME "Wrong SSI device %p\n", dev);
+		return;
+	}
+	if (unlikely(!(dev->ch->flags & SSI_CH_OPEN))) {
+		dev_err(&dev->device, "SSI device NOT open\n");
+		return;
+	}
+
+	spin_lock_bh(&dev->ch->ssi_port->ssi_controller->lock);
+	__ssi_write_cancel(dev->ch);
+	spin_unlock_bh(&dev->ch->ssi_port->ssi_controller->lock);
+}
+EXPORT_SYMBOL(ssi_write_cancel);
+
+void __ssi_read_cancel(struct ssi_channel *ch)
+{
+	if (ch->read_data.size == 1)
+		ssi_driver_cancel_read_interrupt(ch);
+	else if (ch->read_data.size > 1)
+		ssi_driver_cancel_read_dma(ch);
+}
+
+/**
+ * ssi_read_cancel - Cancel pending read request.
+ * @dev - ssi device channel where to cancel the pending read.
+ *
+ * read_done() callback will not be called after sucess of this function.
+ */
+void ssi_read_cancel(struct ssi_device *dev)
+{
+	if (unlikely(!dev || !dev->ch)) {
+		pr_err(LOG_NAME "Wrong SSI device %p\n", dev);
+		return;
+	}
+
+	if (unlikely(!(dev->ch->flags & SSI_CH_OPEN))) {
+		dev_err(&dev->device, "SSI device NOT open\n");
+		return;
+	}
+
+	spin_lock_bh(&dev->ch->ssi_port->ssi_controller->lock);
+	__ssi_read_cancel(dev->ch);
+	spin_unlock_bh(&dev->ch->ssi_port->ssi_controller->lock);
+
+}
+EXPORT_SYMBOL(ssi_read_cancel);
+
+/**
+ * ssi_ioctl - SSI I/O control
+ * @dev - ssi device channel reference to apply the I/O control
+ * 						(or port associated to it)
+ * @command - SSI I/O control command
+ * @arg - parameter associated to the control command. NULL, if no parameter.
+ *
+ * Return 0 on sucess, a negative value on failure.
+ *
+ */
+int ssi_ioctl(struct ssi_device *dev, unsigned int command, void *arg)
+{
+	struct ssi_channel *ch;
+	struct ssi_dev *ssi_ctrl;
+	void __iomem *base;
+	unsigned int port, channel;
+	u32 wake;
+	int err = 0;
+
+	if (unlikely((!dev) ||
+		(!dev->ch) ||
+		(!dev->ch->ssi_port) ||
+		(!dev->ch->ssi_port->ssi_controller)) ||
+		(!(dev->ch->flags & SSI_CH_OPEN))) {
+		pr_err(LOG_NAME "SSI IOCTL Invalid parameter\n");
+		return -EINVAL;
+	}
+
+
+	ch = dev->ch;
+	ssi_ctrl = ch->ssi_port->ssi_controller;
+	port = ch->ssi_port->port_number;
+	channel = ch->channel_number;
+	base = ssi_ctrl->base;
+	clk_enable(ssi_ctrl->ssi_clk);
+
+	switch (command) {
+	case SSI_IOCTL_WAKE_UP:
+		/* We only claim once the wake line per channel */
+		wake = ssi_inl(base, SSI_SYS_WAKE_REG(port));
+		if (!(wake & SSI_WAKE(channel))) {
+			clk_enable(ssi_ctrl->ssi_clk);
+			ssi_outl(SSI_WAKE(channel), base,
+					SSI_SYS_SET_WAKE_REG(port));
+		}
+		break;
+	case SSI_IOCTL_WAKE_DOWN:
+		wake = ssi_inl(base, SSI_SYS_WAKE_REG(port));
+		if ((wake & SSI_WAKE(channel))) {
+			ssi_outl(SSI_WAKE(channel), base,
+						SSI_SYS_CLEAR_WAKE_REG(port));
+			clk_disable(ssi_ctrl->ssi_clk);
+		}
+		break;
+	case SSI_IOCTL_SEND_BREAK:
+		ssi_outl(1, base, SSI_SST_BREAK_REG(port));
+		break;
+	case SSI_IOCTL_WAKE:
+		if (arg == NULL)
+			err = -EINVAL;
+		else
+			*(u32 *)arg = ssi_inl(base, SSI_SYS_WAKE_REG(port));
+		break;
+	default:
+		err = -ENOIOCTLCMD;
+		break;
+	}
+
+	clk_disable(ssi_ctrl->ssi_clk);
+
+	return err;
+}
+EXPORT_SYMBOL(ssi_ioctl);
+
+/**
+ * ssi_close - close given ssi device channel
+ * @dev - reference to ssi device channel.
+ */
+void ssi_close(struct ssi_device *dev)
+{
+	if (!dev || !dev->ch) {
+		pr_err(LOG_NAME "Trying to close wrong SSI device %p\n", dev);
+		return;
+	}
+
+	spin_lock_bh(&dev->ch->ssi_port->ssi_controller->lock);
+	if (dev->ch->flags & SSI_CH_OPEN) {
+		dev->ch->flags &= ~SSI_CH_OPEN;
+		__ssi_write_cancel(dev->ch);
+		__ssi_read_cancel(dev->ch);
+	}
+	spin_unlock_bh(&dev->ch->ssi_port->ssi_controller->lock);
+
+}
+EXPORT_SYMBOL(ssi_close);
+
+/**
+ * ssi_dev_set_cb - register read_done() and write_done() callbacks.
+ * @dev - reference to ssi device channel where callbacks are associated.
+ * @r_cb - callback to signal read transfer completed.
+ * @w_cb - callback to signal write transfer completed.
+ */
+void ssi_dev_set_cb(struct ssi_device *dev, void (*r_cb)(struct ssi_device *dev)
+					, void (*w_cb)(struct ssi_device *dev))
+{
+	dev->ch->ops.read_done = r_cb;
+	dev->ch->ops.write_done = w_cb;
+}
+EXPORT_SYMBOL(ssi_dev_set_cb);
diff --git a/drivers/misc/ssi/ssi_driver_int.c b/drivers/misc/ssi/ssi_driver_int.c
new file mode 100644
index 0000000..6491e48
--- /dev/null
+++ b/drivers/misc/ssi/ssi_driver_int.c
@@ -0,0 +1,232 @@
+/*
+ * ssi_driver_int.c
+ *
+ * Implements SSI interrupt functionality.
+ *
+ * Copyright (C) 2007-2008 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+#include "ssi_driver.h"
+
+static void reset_ch_read(struct ssi_channel *ch)
+{
+	ch->read_data.addr = NULL;
+	ch->read_data.size = 0;
+	ch->read_data.lch = -1;
+}
+
+static void reset_ch_write(struct ssi_channel *ch)
+{
+	ch->write_data.addr = NULL;
+	ch->write_data.size = 0;
+	ch->write_data.lch = -1;
+}
+
+int ssi_driver_write_interrupt(struct ssi_channel *ch, u32 *data)
+{
+	struct ssi_port *p = ch->ssi_port;
+	unsigned int port = p->port_number;
+	unsigned int channel = ch->channel_number;
+
+	clk_enable(p->ssi_controller->ssi_clk);
+	ssi_outl_or(SSI_SST_DATAACCEPT(channel), p->ssi_controller->base,
+					SSI_SYS_MPU_ENABLE_REG(port, p->n_irq));
+
+
+	return 0;
+}
+
+int ssi_driver_read_interrupt(struct ssi_channel *ch, u32 *data)
+{
+	struct ssi_port *p = ch->ssi_port;
+	unsigned int port = p->port_number;
+	unsigned int channel = ch->channel_number;
+
+	clk_enable(p->ssi_controller->ssi_clk);
+
+	ssi_outl_or(SSI_SSR_DATAAVAILABLE(channel), p->ssi_controller->base,
+					SSI_SYS_MPU_ENABLE_REG(port, p->n_irq));
+
+	clk_disable(p->ssi_controller->ssi_clk);
+
+	return 0;
+}
+
+void ssi_driver_cancel_write_interrupt(struct ssi_channel *ch)
+{
+	struct ssi_port *p = ch->ssi_port;
+	unsigned int port = p->port_number;
+	unsigned int channel = ch->channel_number;
+	void __iomem *base = p->ssi_controller->base;
+	u32 enable;
+
+	clk_enable(p->ssi_controller->ssi_clk);
+
+	enable = ssi_inl(base, SSI_SYS_MPU_ENABLE_REG(port, p->n_irq));
+	if (!(enable & SSI_SST_DATAACCEPT(channel))) {
+		dev_dbg(&ch->dev->device, LOG_NAME "Write cancel on not "
+		"enabled channel %d ENABLE REG 0x%08X", channel, enable);
+		clk_disable(p->ssi_controller->ssi_clk);
+		return;
+	}
+	ssi_outl_and(~SSI_SST_DATAACCEPT(channel), base,
+				SSI_SYS_MPU_ENABLE_REG(port, p->n_irq));
+	ssi_outl_and(~NOTFULL(channel), base, SSI_SST_BUFSTATE_REG(port));
+	reset_ch_write(ch);
+
+	clk_disable(p->ssi_controller->ssi_clk);
+	clk_disable(p->ssi_controller->ssi_clk);
+
+}
+
+void ssi_driver_cancel_read_interrupt(struct ssi_channel *ch)
+{
+	struct ssi_port *p = ch->ssi_port;
+	unsigned int port = p->port_number;
+	unsigned int channel = ch->channel_number;
+	void __iomem *base = p->ssi_controller->base;
+
+	clk_enable(p->ssi_controller->ssi_clk);
+
+	ssi_outl_and(~SSI_SSR_DATAAVAILABLE(channel), base,
+					SSI_SYS_MPU_ENABLE_REG(port, p->n_irq));
+	ssi_outl_and(~NOTEMPTY(channel), base, SSI_SSR_BUFSTATE_REG(port));
+	reset_ch_read(ch);
+
+	clk_disable(p->ssi_controller->ssi_clk);
+}
+
+static void do_channel_tx(struct ssi_channel *ch)
+{
+	struct ssi_dev *ssi_ctrl = ch->ssi_port->ssi_controller;
+	void __iomem *base = ssi_ctrl->base;
+	unsigned int n_ch;
+	unsigned int n_p;
+	unsigned int irq;
+
+	n_ch = ch->channel_number;
+	n_p = ch->ssi_port->port_number;
+	irq = ch->ssi_port->n_irq;
+
+	spin_lock(&ssi_ctrl->lock);
+
+	if (ch->write_data.addr == NULL) {
+		ssi_outl_and(~SSI_SST_DATAACCEPT(n_ch), base,
+					SSI_SYS_MPU_ENABLE_REG(n_p, irq));
+		reset_ch_write(ch);
+		spin_unlock(&ssi_ctrl->lock);
+		clk_disable(ssi_ctrl->ssi_clk);
+		(*ch->ops.write_done)(ch->dev);
+	} else {
+		ssi_outl(*(ch->write_data.addr), base,
+					SSI_SST_BUFFER_CH_REG(n_p, n_ch));
+		ch->write_data.addr = NULL;
+		spin_unlock(&ssi_ctrl->lock);
+	}
+}
+
+static void do_channel_rx(struct ssi_channel *ch)
+{
+	struct ssi_dev *ssi_ctrl = ch->ssi_port->ssi_controller;
+	void __iomem *base = ch->ssi_port->ssi_controller->base;
+	unsigned int n_ch;
+	unsigned int n_p;
+	unsigned int irq;
+
+	n_ch = ch->channel_number;
+	n_p = ch->ssi_port->port_number;
+	irq = ch->ssi_port->n_irq;
+
+	spin_lock(&ssi_ctrl->lock);
+
+	*(ch->read_data.addr) = ssi_inl(base, SSI_SSR_BUFFER_CH_REG(n_p, n_ch));
+
+	ssi_outl_and(~SSI_SSR_DATAAVAILABLE(n_ch), base,
+					SSI_SYS_MPU_ENABLE_REG(n_p, irq));
+	reset_ch_read(ch);
+
+	spin_unlock(&ssi_ctrl->lock);
+
+	(*ch->ops.read_done)(ch->dev);
+}
+
+void do_ssi_tasklet(unsigned long ssi_port)
+{
+	struct ssi_port *pport = (struct ssi_port *)ssi_port;
+	struct ssi_dev *ssi_ctrl = pport->ssi_controller;
+	void __iomem *base = ssi_ctrl->base;
+	unsigned int port = pport->port_number;
+	unsigned int channel = 0;
+	unsigned int irq = pport->n_irq;
+	u32 status_reg;
+	u32 enable_reg;
+	u32 ssr_err_reg;
+	u32 channels_served;
+
+	clk_enable(ssi_ctrl->ssi_clk);
+
+	channels_served = 0;
+	status_reg = ssi_inl(base, SSI_SYS_MPU_STATUS_REG(port, irq));
+	enable_reg = ssi_inl(base, SSI_SYS_MPU_ENABLE_REG(port, irq));
+
+	for (channel = 0; channel < pport->max_ch; channel++) {
+		if ((status_reg & SSI_SST_DATAACCEPT(channel)) &&
+		    (enable_reg & SSI_SST_DATAACCEPT(channel))) {
+			do_channel_tx(&pport->ssi_channel[channel]);
+			channels_served |= SSI_SST_DATAACCEPT(channel);
+		}
+
+		if ((status_reg & SSI_SSR_DATAAVAILABLE(channel)) &&
+		    (enable_reg & SSI_SSR_DATAAVAILABLE(channel))) {
+			do_channel_rx(&pport->ssi_channel[channel]);
+			channels_served |= SSI_SSR_DATAAVAILABLE(channel);
+		}
+	}
+
+	if ((status_reg & SSI_BREAKDETECTED) &&
+	    (enable_reg & SSI_BREAKDETECTED)) {
+		dev_info(&ssi_ctrl->pdev->dev,
+					"Hardware BREAK on port %d\n", port);
+		ssi_outl(0, base, SSI_SSR_BREAK_REG(port));
+		ssi_port_event_handler(pport, SSI_EVENT_BREAK_DETECTED, NULL);
+	}
+
+	if (status_reg & SSI_ERROROCCURED) {
+		ssr_err_reg = ssi_inl(base, SSI_SSR_ERROR_REG(port));
+		dev_err(&ssi_ctrl->pdev->dev, "SSI ERROR Port %d: 0x%02x\n",
+							port, ssr_err_reg);
+		ssi_outl(ssr_err_reg, base, SSI_SSR_ERRORACK_REG(port));
+		ssi_port_event_handler(pport, SSI_EVENT_ERROR, NULL);
+	}
+
+	ssi_outl((channels_served | SSI_ERROROCCURED | SSI_BREAKDETECTED), base,
+					SSI_SYS_MPU_STATUS_REG(port, irq));
+
+	clk_disable(ssi_ctrl->ssi_clk);
+	enable_irq(pport->irq);
+}
+
+irqreturn_t ssi_mpu_handler(int irq, void *ssi_port)
+{
+	struct ssi_port *p = (struct ssi_port *)ssi_port;
+
+	tasklet_hi_schedule(&p->ssi_tasklet);
+	disable_irq_nosync(p->irq);
+
+	return IRQ_HANDLED;
+}
-- 
1.5.3.6

