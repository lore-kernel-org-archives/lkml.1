Return-Path: <linux-kernel-owner+w=401wt.eu-S933729AbYA2SM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729AbYA2SM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758048AbYA2SKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:10:34 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:50259 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754675AbYA2SKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:10:21 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Shannon Nelson <shannon.nelson@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [RFC v2 5/5] Atmel MCI: Driver for Atmel on-chip MMC controllers
Date: Tue, 29 Jan 2008 19:10:13 +0100
Message-Id: <1201630213-31900-6-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201630213-31900-5-git-send-email-hskinnemoen@atmel.com>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
 <1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
 <1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
 <1201630213-31900-4-git-send-email-hskinnemoen@atmel.com>
 <1201630213-31900-5-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a driver for the MMC controller on the AP7000 chips from
Atmel. It should in theory work on AT91 systems too with some
tweaking, but since the DMA interface is quite different, it's not
entirely clear if it's worth it.

This driver has been around for a while in BSPs and kernel sources
provided by Atmel, but this particular version uses the generic DMA
Engine framework (with the slave extensions) instead of an
avr32-only DMA controller framework.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/boards/atngw100/setup.c      |    6 +
 arch/avr32/boards/atstk1000/atstk1002.c |    3 +
 arch/avr32/mach-at32ap/at32ap700x.c     |   31 +-
 drivers/mmc/host/Kconfig                |   10 +
 drivers/mmc/host/Makefile               |    1 +
 drivers/mmc/host/atmel-mci.c            | 1159 +++++++++++++++++++++++++++++++
 drivers/mmc/host/atmel-mci.h            |  192 +++++
 include/asm-avr32/arch-at32ap/board.h   |   10 +-
 8 files changed, 1406 insertions(+), 6 deletions(-)
 create mode 100644 drivers/mmc/host/atmel-mci.c
 create mode 100644 drivers/mmc/host/atmel-mci.h

diff --git a/arch/avr32/boards/atngw100/setup.c b/arch/avr32/boards/atngw100/setup.c
index a398be2..c58f2cf 100644
--- a/arch/avr32/boards/atngw100/setup.c
+++ b/arch/avr32/boards/atngw100/setup.c
@@ -42,6 +42,11 @@ static struct spi_board_info spi0_board_info[] __initdata = {
 	},
 };
 
+static struct mci_platform_data __initdata mci0_data = {
+	.detect_pin	= GPIO_PIN_PC(25),
+	.wp_pin		= GPIO_PIN_PE(0),
+};
+
 /*
  * The next two functions should go away as the boot loader is
  * supposed to initialize the macb address registers with a valid
@@ -157,6 +162,7 @@ static int __init atngw100_init(void)
 	set_hw_addr(at32_add_device_eth(1, &eth_data[1]));
 
 	at32_add_device_spi(0, spi0_board_info, ARRAY_SIZE(spi0_board_info));
+	at32_add_device_mci(0, &mci0_data);
 	at32_add_device_usba(0, NULL);
 
 	for (i = 0; i < ARRAY_SIZE(ngw_leds); i++) {
diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index 000eb42..8b92cd6 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -228,6 +228,9 @@ static int __init atstk1002_init(void)
 #ifdef CONFIG_BOARD_ATSTK100X_SPI1
 	at32_add_device_spi(1, spi1_board_info, ARRAY_SIZE(spi1_board_info));
 #endif
+#ifndef CONFIG_BOARD_ATSTK1002_SW2_CUSTOM
+	at32_add_device_mci(0, NULL);
+#endif
 #ifdef CONFIG_BOARD_ATSTK1002_SW5_CUSTOM
 	set_hw_addr(at32_add_device_eth(1, &eth_data[1]));
 #else
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 4f130a8..de0644b 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1035,20 +1035,34 @@ static struct clk atmel_mci0_pclk = {
 	.index		= 9,
 };
 
-struct platform_device *__init at32_add_device_mci(unsigned int id)
+struct platform_device *__init
+at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 {
-	struct platform_device *pdev;
+	struct mci_platform_data	_data;
+	struct platform_device		*pdev;
 
 	if (id != 0)
 		return NULL;
 
 	pdev = platform_device_alloc("atmel_mci", id);
 	if (!pdev)
-		return NULL;
+		goto fail;
 
 	if (platform_device_add_resources(pdev, atmel_mci0_resource,
 				ARRAY_SIZE(atmel_mci0_resource)))
-		goto err_add_resources;
+		goto fail;
+
+	if (!data) {
+		data = &_data;
+		memset(data, 0, sizeof(struct mci_platform_data));
+	}
+
+	data->rx_periph_id = 0;
+	data->tx_periph_id = 1;
+
+	if (platform_device_add_data(pdev, data,
+				sizeof(struct mci_platform_data)))
+		goto fail;
 
 	select_peripheral(PA(10), PERIPH_A, 0);	/* CLK	 */
 	select_peripheral(PA(11), PERIPH_A, 0);	/* CMD	 */
@@ -1057,12 +1071,19 @@ struct platform_device *__init at32_add_device_mci(unsigned int id)
 	select_peripheral(PA(14), PERIPH_A, 0);	/* DATA2 */
 	select_peripheral(PA(15), PERIPH_A, 0);	/* DATA3 */
 
+	if (data) {
+		if (data->detect_pin != GPIO_PIN_NONE)
+			at32_select_gpio(data->detect_pin, 0);
+		if (data->wp_pin != GPIO_PIN_NONE)
+			at32_select_gpio(data->wp_pin, 0);
+	}
+
 	atmel_mci0_pclk.dev = &pdev->dev;
 
 	platform_device_add(pdev);
 	return pdev;
 
-err_add_resources:
+fail:
 	platform_device_put(pdev);
 	return NULL;
 }
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 5fef678..daddca0 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -91,6 +91,16 @@ config MMC_AT91
 
 	  If unsure, say N.
 
+config MMC_ATMELMCI
+	tristate "Atmel Multimedia Card Interface support"
+	depends on AVR32 && DMA_ENGINE
+	help
+	  This selects the Atmel Multimedia Card Interface driver. If
+	  you have an AT32 (AVR32) platform with a Multimedia Card
+	  slot, say Y or M here.
+
+	  If unsure, say N.
+
 config MMC_IMX
 	tristate "Motorola i.MX Multimedia Card Interface support"
 	depends on ARCH_IMX
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 3877c87..e80ea72 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_MMC_WBSD)		+= wbsd.o
 obj-$(CONFIG_MMC_AU1X)		+= au1xmmc.o
 obj-$(CONFIG_MMC_OMAP)		+= omap.o
 obj-$(CONFIG_MMC_AT91)		+= at91_mci.o
+obj-$(CONFIG_MMC_ATMELMCI)	+= atmel-mci.o
 obj-$(CONFIG_MMC_TIFM_SD)	+= tifm_sd.o
 obj-$(CONFIG_MMC_SPI)		+= mmc_spi.o
 
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
new file mode 100644
index 0000000..d484b91
--- /dev/null
+++ b/drivers/mmc/host/atmel-mci.c
@@ -0,0 +1,1159 @@
+/*
+ * Atmel MultiMedia Card Interface driver
+ *
+ * Copyright (C) 2004-2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/blkdev.h>
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <linux/mmc/host.h>
+
+#include <asm/io.h>
+#include <asm/arch/board.h>
+#include <asm/arch/gpio.h>
+
+#include "atmel-mci.h"
+
+#define DRIVER_NAME "atmel_mci"
+
+#define MCI_DATA_ERROR_FLAGS	(MCI_BIT(DCRCE) | MCI_BIT(DTOE) |	\
+				 MCI_BIT(OVRE) | MCI_BIT(UNRE))
+
+enum {
+	EVENT_CMD_COMPLETE = 0,
+	EVENT_DATA_COMPLETE,
+	EVENT_DATA_ERROR,
+	EVENT_STOP_SENT,
+	EVENT_STOP_COMPLETE,
+	EVENT_DMA_COMPLETE,
+	EVENT_DMA_ERROR,
+	EVENT_CARD_DETECT,
+};
+
+struct atmel_mci_dma {
+	struct dma_client	client;
+	struct dma_slave	slave;
+	struct dma_chan		*chan;
+	struct list_head	data_descs;
+};
+
+struct atmel_mci {
+	struct mmc_host		*mmc;
+	void __iomem		*regs;
+	struct atmel_mci_dma	dma;
+
+	struct mmc_request	*mrq;
+	struct mmc_command	*cmd;
+	struct mmc_data		*data;
+
+	u32			cmd_status;
+	u32			data_status;
+	u32			stop_status;
+	u32			stop_cmdr;
+
+	struct tasklet_struct	tasklet;
+	unsigned long		pending_events;
+	unsigned long		completed_events;
+
+	int			present;
+	int			detect_pin;
+	int			wp_pin;
+
+	unsigned long		bus_hz;
+	unsigned long		mapbase;
+	struct clk		*mck;
+	struct platform_device	*pdev;
+
+#ifdef CONFIG_DEBUG_FS
+	struct dentry		*debugfs_root;
+	struct dentry		*debugfs_regs;
+	struct dentry		*debugfs_req;
+	struct dentry		*debugfs_pending_events;
+	struct dentry		*debugfs_completed_events;
+#endif
+};
+
+static inline struct atmel_mci *
+dma_client_to_atmel_mci(struct dma_client *client)
+{
+	return container_of(client, struct atmel_mci, dma.client);
+}
+
+/* Those printks take an awful lot of time... */
+#ifndef DEBUG
+static unsigned int fmax = 15000000U;
+#else
+static unsigned int fmax = 1000000U;
+#endif
+module_param(fmax, uint, 0444);
+MODULE_PARM_DESC(fmax, "Max frequency in Hz of the MMC bus clock");
+
+#define atmci_is_completed(host, event)				\
+	test_bit(event, &host->completed_events)
+#define atmci_test_and_clear_pending(host, event)		\
+	test_and_clear_bit(event, &host->pending_events)
+#define atmci_test_and_set_completed(host, event)		\
+	test_and_set_bit(event, &host->completed_events)
+#define atmci_set_completed(host, event)			\
+	set_bit(event, &host->completed_events)
+#define atmci_set_pending(host, event)				\
+	set_bit(event, &host->pending_events)
+#define atmci_clear_pending(host, event)			\
+	clear_bit(event, &host->pending_events)
+
+
+#ifdef CONFIG_DEBUG_FS
+#include <linux/debugfs.h>
+
+#define DBG_REQ_BUF_SIZE	(4096 - sizeof(unsigned int))
+
+struct req_dbg_data {
+	unsigned int	nbytes;
+	char		str[DBG_REQ_BUF_SIZE];
+};
+
+static int req_dbg_open(struct inode *inode, struct file *file)
+{
+	struct atmel_mci	*host;
+	struct mmc_request	*mrq;
+	struct mmc_command	*cmd;
+	struct mmc_command	*stop;
+	struct mmc_data		*data;
+	struct req_dbg_data	*priv;
+	char			*str;
+	unsigned long		n = 0;
+
+	priv = kzalloc(DBG_REQ_BUF_SIZE, GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	str = priv->str;
+
+	mutex_lock(&inode->i_mutex);
+	host = inode->i_private;
+
+	spin_lock_irq(&host->mmc->lock);
+	mrq = host->mrq;
+	if (mrq) {
+		cmd = mrq->cmd;
+		data = mrq->data;
+		stop = mrq->stop;
+		n = snprintf(str, DBG_REQ_BUF_SIZE,
+			     "CMD%u(0x%x) %x %x %x %x %x (err %u)\n",
+			     cmd->opcode, cmd->arg, cmd->flags,
+			     cmd->resp[0], cmd->resp[1], cmd->resp[2],
+			     cmd->resp[3], cmd->error);
+		if (n < DBG_REQ_BUF_SIZE && data)
+			n += snprintf(str + n, DBG_REQ_BUF_SIZE - n,
+				      "DATA %u * %u (%u) %x (err %u)\n",
+				      data->blocks, data->blksz,
+				      data->bytes_xfered, data->flags,
+				      data->error);
+		if (n < DBG_REQ_BUF_SIZE && stop)
+			n += snprintf(str + n, DBG_REQ_BUF_SIZE - n,
+				      "CMD%u(0x%x) %x %x %x %x %x (err %u)\n",
+				      stop->opcode, stop->arg, stop->flags,
+				      stop->resp[0], stop->resp[1],
+				      stop->resp[2], stop->resp[3],
+				      stop->error);
+	}
+	spin_unlock_irq(&host->mmc->lock);
+	mutex_unlock(&inode->i_mutex);
+
+	priv->nbytes = min(n, DBG_REQ_BUF_SIZE);
+	file->private_data = priv;
+
+	return 0;
+}
+
+static ssize_t req_dbg_read(struct file *file, char __user *buf,
+			    size_t nbytes, loff_t *ppos)
+{
+	struct req_dbg_data *priv = file->private_data;
+
+	return simple_read_from_buffer(buf, nbytes, ppos,
+				       priv->str, priv->nbytes);
+}
+
+static int req_dbg_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
+static const struct file_operations req_dbg_fops = {
+	.owner		= THIS_MODULE,
+	.open		= req_dbg_open,
+	.llseek		= no_llseek,
+	.read		= req_dbg_read,
+	.release	= req_dbg_release,
+};
+
+static int regs_dbg_open(struct inode *inode, struct file *file)
+{
+	struct atmel_mci	*host;
+	unsigned int		i;
+	u32			*data;
+	int			ret;
+
+	mutex_lock(&inode->i_mutex);
+	host = inode->i_private;
+	data = kmalloc(inode->i_size, GFP_KERNEL);
+	if (!data) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	spin_lock_irq(&host->mmc->lock);
+	for (i = 0; i < inode->i_size / 4; i++)
+		data[i] = __raw_readl(host->regs + i * 4);
+	spin_unlock_irq(&host->mmc->lock);
+
+	file->private_data = data;
+	ret = 0;
+
+out:
+	mutex_unlock(&inode->i_mutex);
+
+	return ret;
+}
+
+static ssize_t regs_dbg_read(struct file *file, char __user *buf,
+			     size_t nbytes, loff_t *ppos)
+{
+	struct inode	*inode = file->f_dentry->d_inode;
+	int		ret;
+
+	mutex_lock(&inode->i_mutex);
+	ret = simple_read_from_buffer(buf, nbytes, ppos,
+				      file->private_data,
+				      file->f_dentry->d_inode->i_size);
+	mutex_unlock(&inode->i_mutex);
+
+	return ret;
+}
+
+static int regs_dbg_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
+static const struct file_operations regs_dbg_fops = {
+	.owner		= THIS_MODULE,
+	.open		= regs_dbg_open,
+	.llseek		= generic_file_llseek,
+	.read		= regs_dbg_read,
+	.release	= regs_dbg_release,
+};
+
+static void atmci_init_debugfs(struct atmel_mci *host)
+{
+	struct mmc_host	*mmc;
+	struct dentry	*root;
+	struct dentry	*regs;
+	struct resource	*res;
+
+	mmc = host->mmc;
+	root = debugfs_create_dir(mmc_hostname(mmc), NULL);
+	if (IS_ERR(root) || !root)
+		goto err_root;
+	host->debugfs_root = root;
+
+	regs = debugfs_create_file("regs", 0400, root, host, &regs_dbg_fops);
+	if (!regs)
+		goto err_regs;
+
+	res = platform_get_resource(host->pdev, IORESOURCE_MEM, 0);
+	regs->d_inode->i_size = res->end - res->start + 1;
+	host->debugfs_regs = regs;
+
+	host->debugfs_req = debugfs_create_file("req", 0400, root,
+						host, &req_dbg_fops);
+	if (!host->debugfs_req)
+		goto err_req;
+
+	host->debugfs_pending_events
+		= debugfs_create_u32("pending_events", 0400, root,
+				     (u32 *)&host->pending_events);
+	if (!host->debugfs_pending_events)
+		goto err_pending_events;
+
+	host->debugfs_completed_events
+		= debugfs_create_u32("completed_events", 0400, root,
+				     (u32 *)&host->completed_events);
+	if (!host->debugfs_completed_events)
+		goto err_completed_events;
+
+	return;
+
+err_completed_events:
+	debugfs_remove(host->debugfs_pending_events);
+err_pending_events:
+	debugfs_remove(host->debugfs_req);
+err_req:
+	debugfs_remove(host->debugfs_regs);
+err_regs:
+	debugfs_remove(host->debugfs_root);
+err_root:
+	host->debugfs_root = NULL;
+	dev_err(&host->pdev->dev,
+		"failed to initialize debugfs for %s\n",
+		mmc_hostname(mmc));
+}
+
+static void atmci_cleanup_debugfs(struct atmel_mci *host)
+{
+	if (host->debugfs_root) {
+		debugfs_remove(host->debugfs_completed_events);
+		debugfs_remove(host->debugfs_pending_events);
+		debugfs_remove(host->debugfs_req);
+		debugfs_remove(host->debugfs_regs);
+		debugfs_remove(host->debugfs_root);
+		host->debugfs_root = NULL;
+	}
+}
+#else
+static inline void atmci_init_debugfs(struct atmel_mci *host)
+{
+
+}
+
+static inline void atmci_cleanup_debugfs(struct atmel_mci *host)
+{
+
+}
+#endif /* CONFIG_DEBUG_FS */
+
+static inline unsigned int ns_to_clocks(struct atmel_mci *host,
+					unsigned int ns)
+{
+	return (ns * (host->bus_hz / 1000000) + 999) / 1000;
+}
+
+static void atmci_set_timeout(struct atmel_mci *host,
+			      struct mmc_data *data)
+{
+	static unsigned	dtomul_to_shift[] = {
+		0, 4, 7, 8, 10, 12, 16, 20
+	};
+	unsigned	timeout;
+	unsigned	dtocyc;
+	unsigned	dtomul;
+
+	timeout = ns_to_clocks(host, data->timeout_ns) + data->timeout_clks;
+
+	for (dtomul = 0; dtomul < 8; dtomul++) {
+		unsigned shift = dtomul_to_shift[dtomul];
+		dtocyc = (timeout + (1 << shift) - 1) >> shift;
+		if (dtocyc < 15)
+			break;
+	}
+
+	if (dtomul >= 8) {
+		dtomul = 7;
+		dtocyc = 15;
+	}
+
+	dev_vdbg(&host->mmc->class_dev, "setting timeout to %u cycles\n",
+			dtocyc << dtomul_to_shift[dtomul]);
+	mci_writel(host, DTOR, (MCI_BF(DTOMUL, dtomul)
+				| MCI_BF(DTOCYC, dtocyc)));
+}
+
+/*
+ * Return mask with command flags to be enabled for this command.
+ */
+static u32 atmci_prepare_command(struct mmc_host *mmc,
+				 struct mmc_command *cmd)
+{
+	u32 cmdr;
+
+	cmd->error = 0;
+
+	cmdr = MCI_BF(CMDNB, cmd->opcode);
+
+	if (cmd->flags & MMC_RSP_PRESENT) {
+		if (cmd->flags & MMC_RSP_136)
+			cmdr |= MCI_BF(RSPTYP, MCI_RSPTYP_136_BIT);
+		else
+			cmdr |= MCI_BF(RSPTYP, MCI_RSPTYP_48_BIT);
+	}
+
+	/*
+	 * This should really be MAXLAT_5 for CMD2 and ACMD41, but
+	 * it's too difficult to determine whether this is an ACMD or
+	 * not. Better make it 64.
+	 */
+	cmdr |= MCI_BIT(MAXLAT);
+
+	if (mmc->ios.bus_mode == MMC_BUSMODE_OPENDRAIN)
+		cmdr |= MCI_BIT(OPDCMD);
+
+	return cmdr;
+}
+
+static void atmci_start_data(struct atmel_mci *host)
+{
+	struct dma_slave_descriptor	*desc, *_desc;
+	struct dma_chan			*chan;
+
+	dev_vdbg(&host->mmc->class_dev, "submitting descriptors...\n");
+
+	/*
+	 * Use the _safe() variant here because the might complete and
+	 * get deleted from the list before we get around to the next
+	 * entry. No need to lock since we're not modifying the list,
+	 * and only entries we've submitted can be removed.
+	 */
+	list_for_each_entry_safe(desc, _desc, &host->dma.data_descs,
+			client_node)
+		desc->txd.tx_submit(&desc->txd);
+
+	chan = host->dma.chan;
+
+	chan->device->device_issue_pending(chan);
+}
+
+static void atmci_start_command(struct atmel_mci *host,
+				struct mmc_command *cmd,
+				u32 cmd_flags)
+{
+	WARN_ON(host->cmd);
+	host->cmd = cmd;
+
+	dev_vdbg(&host->mmc->class_dev,
+			"start command: ARGR=0x%08x CMDR=0x%08x\n",
+			cmd->arg, cmd_flags);
+
+	mci_writel(host, ARGR, cmd->arg);
+	mci_writel(host, CMDR, cmd_flags);
+
+	if (cmd->data)
+		atmci_start_data(host);
+}
+
+static void send_stop_cmd(struct mmc_host *mmc, struct mmc_data *data)
+{
+	struct atmel_mci *host = mmc_priv(mmc);
+
+	atmci_start_command(host, data->stop, host->stop_cmdr);
+	mci_writel(host, IER, MCI_BIT(CMDRDY));
+}
+
+static void atmci_request_end(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	struct atmel_mci *host = mmc_priv(mmc);
+
+	WARN_ON(host->cmd || host->data);
+	host->mrq = NULL;
+
+	mmc_request_done(mmc, mrq);
+}
+
+static void atmci_dma_cleanup(struct atmel_mci *host)
+{
+	struct dma_slave_descriptor	*desc, *_desc;
+	struct mmc_data			*data = host->data;
+
+	dma_unmap_sg(&host->pdev->dev, data->sg, data->sg_len,
+		     ((data->flags & MMC_DATA_WRITE)
+		      ? DMA_TO_DEVICE : DMA_FROM_DEVICE));
+
+	/*
+	 * REVISIT: Recycle these descriptors instead of handing them
+	 * back to the controller.
+	 */
+	list_for_each_entry_safe(desc, _desc, &host->dma.data_descs,
+			client_node) {
+		list_del(&desc->client_node);
+		async_tx_ack(&desc->txd);
+	}
+}
+
+static void atmci_stop_dma(struct atmel_mci *host)
+{
+	struct dma_chan *chan = host->dma.chan;
+
+	chan->device->device_terminate_all(chan);
+
+	atmci_dma_cleanup(host);
+}
+
+/* This function is called by the DMA driver from tasklet context. */
+static void atmci_dma_complete(void *arg)
+{
+	struct atmel_mci	*host = arg;
+	struct mmc_data		*data = host->data;
+
+	/* A short DMA transfer may complete before the command */
+	atmci_set_completed(host, EVENT_DMA_COMPLETE);
+	if (atmci_is_completed(host, EVENT_CMD_COMPLETE)
+			&& data->stop
+			&& !atmci_test_and_set_completed(host, EVENT_STOP_SENT))
+		send_stop_cmd(host->mmc, data);
+
+	atmci_dma_cleanup(host);
+
+	/*
+	 * Regardless of what the documentation says, we have to wait
+	 * for NOTBUSY even after block read operations.
+	 *
+	 * When the DMA transfer is complete, the controller may still
+	 * be reading the CRC from the card, i.e. the data transfer is
+	 * still in progress and we haven't seen all the potential
+	 * error bits yet.
+	 *
+	 * The interrupt handler will schedule a different tasklet to
+	 * finish things up when the data transfer is completely done.
+	 *
+	 * We may not complete the mmc request here anyway because the
+	 * mmc layer may call back and cause us to violate the "don't
+	 * submit new operations from the completion callback" rule of
+	 * the dma engine framework.
+	 */
+	mci_writel(host, IER, MCI_BIT(NOTBUSY));
+}
+
+/*
+ * Returns a mask of flags to be set in the command register when the
+ * command to start the transfer is to be sent.
+ */
+static u32 atmci_prepare_data(struct mmc_host *mmc, struct mmc_data *data)
+{
+	struct atmel_mci		*host = mmc_priv(mmc);
+	struct dma_chan			*chan = host->dma.chan;
+	struct dma_slave_descriptor	*desc;
+	struct scatterlist		*sg;
+	unsigned int			sg_len;
+	unsigned int			i;
+	enum dma_slave_direction	direction;
+	unsigned long			dma_flags;
+	u32				cmd_flags;
+
+	WARN_ON(host->data);
+	host->data = data;
+
+	atmci_set_timeout(host, data);
+	mci_writel(host, BLKR, (MCI_BF(BCNT, data->blocks)
+				| MCI_BF(BLKLEN, data->blksz)));
+	dev_vdbg(&mmc->class_dev, "BLKR=0x%08x\n",
+			(MCI_BF(BCNT, data->blocks)
+				| MCI_BF(BLKLEN, data->blksz)));
+
+	cmd_flags = MCI_BF(TRCMD, MCI_TRCMD_START_TRANS);
+	if (data->flags & MMC_DATA_STREAM)
+		cmd_flags |= MCI_BF(TRTYP, MCI_TRTYP_STREAM);
+	else if (data->blocks > 1)
+		cmd_flags |= MCI_BF(TRTYP, MCI_TRTYP_MULTI_BLOCK);
+	else
+		cmd_flags |= MCI_BF(TRTYP, MCI_TRTYP_BLOCK);
+
+	/* REVISIT: Try to cache pre-initialized descriptors */
+	dma_flags = 0;
+	dev_vdbg(&mmc->class_dev, "setting up descriptors (%c)...\n",
+			(data->flags & MMC_DATA_READ) ? 'r' : 'w');
+
+	if (data->flags & MMC_DATA_READ) {
+		cmd_flags |= MCI_BIT(TRDIR);
+		direction = DMA_SLAVE_TO_MEMORY;
+
+#ifdef POISON_READ_BUFFER
+		for_each_sg(data->sg, sg, data->sg_len, i) {
+			void *p = kmap(sg_page(sg));
+			memset(p + sg->offset, 0x55, sg->length);
+			kunmap(p);
+		}
+#endif
+		sg_len = dma_map_sg(&host->pdev->dev, data->sg,
+				data->sg_len, DMA_FROM_DEVICE);
+	} else {
+		direction = DMA_SLAVE_FROM_MEMORY;
+
+		sg_len = dma_map_sg(&host->pdev->dev, data->sg,
+				data->sg_len, DMA_TO_DEVICE);
+	}
+
+	for_each_sg(data->sg, sg, sg_len, i) {
+		if (i == sg_len - 1)
+			dma_flags = DMA_PREP_INTERRUPT;
+
+		dev_vdbg(&mmc->class_dev, "  addr %08x len %u\n",
+				sg_dma_address(sg), sg_dma_len(sg));
+
+		desc = chan->device->device_prep_slave(chan,
+				sg_dma_address(sg), direction,
+				DMA_SLAVE_WIDTH_32BIT,
+				sg_dma_len(sg), dma_flags);
+		desc->txd.callback = NULL;
+		list_add_tail(&desc->client_node,
+				&host->dma.data_descs);
+	}
+
+	/* Make sure we get notified when the last descriptor is done. */
+	desc = list_entry(host->dma.data_descs.prev,
+			struct dma_slave_descriptor, client_node);
+	desc->txd.callback = atmci_dma_complete;
+	desc->txd.callback_param = host;
+
+	return cmd_flags;
+}
+
+static void atmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	struct atmel_mci	*host = mmc_priv(mmc);
+	struct mmc_data		*data = mrq->data;
+	u32			iflags;
+	u32			cmdflags = 0;
+
+	iflags = mci_readl(host, IMR);
+	if (iflags)
+		dev_warn(&mmc->class_dev, "WARNING: IMR=0x%08x\n",
+				mci_readl(host, IMR));
+
+	WARN_ON(host->mrq != NULL);
+	host->mrq = mrq;
+	host->pending_events = 0;
+	host->completed_events = 0;
+
+	iflags = MCI_BIT(CMDRDY);
+	cmdflags = atmci_prepare_command(mmc, mrq->cmd);
+
+	if (mrq->stop) {
+		WARN_ON(!data);
+
+		host->stop_cmdr = atmci_prepare_command(mmc, mrq->stop);
+		host->stop_cmdr |= MCI_BF(TRCMD, MCI_TRCMD_STOP_TRANS);
+		if (!(data->flags & MMC_DATA_WRITE))
+			host->stop_cmdr |= MCI_BIT(TRDIR);
+		if (data->flags & MMC_DATA_STREAM)
+			host->stop_cmdr |= MCI_BF(TRTYP, MCI_TRTYP_STREAM);
+		else
+			host->stop_cmdr |= MCI_BF(TRTYP, MCI_TRTYP_MULTI_BLOCK);
+	}
+	if (data) {
+		cmdflags |= atmci_prepare_data(mmc, data);
+		iflags |= MCI_DATA_ERROR_FLAGS;
+	}
+
+	atmci_start_command(host, mrq->cmd, cmdflags);
+	mci_writel(host, IER, iflags);
+}
+
+static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct atmel_mci	*host = mmc_priv(mmc);
+	u32			mr;
+
+	if (ios->clock) {
+		u32 clkdiv;
+
+		/* Set clock rate */
+		clkdiv = host->bus_hz / (2 * ios->clock) - 1;
+		if (clkdiv > 255) {
+			dev_warn(&mmc->class_dev,
+				"clock %u too slow; using %lu\n",
+				ios->clock, host->bus_hz / (2 * 256));
+			clkdiv = 255;
+		}
+
+		mr = mci_readl(host, MR);
+		mr = MCI_BFINS(CLKDIV, clkdiv, mr)
+			| MCI_BIT(WRPROOF) | MCI_BIT(RDPROOF);
+		mci_writel(host, MR, mr);
+
+		/* Enable the MCI controller */
+		mci_writel(host, CR, MCI_BIT(MCIEN));
+	} else {
+		/* Disable the MCI controller */
+		mci_writel(host, CR, MCI_BIT(MCIDIS));
+	}
+
+	switch (ios->bus_width) {
+	case MMC_BUS_WIDTH_1:
+		mci_writel(host, SDCR, 0);
+		break;
+	case MMC_BUS_WIDTH_4:
+		mci_writel(host, SDCR, MCI_BIT(SDCBUS));
+		break;
+	}
+
+	switch (ios->power_mode) {
+	case MMC_POWER_ON:
+		/* Send init sequence (74 clock cycles) */
+		mci_writel(host, IDR, ~0UL);
+		mci_writel(host, CMDR, MCI_BF(SPCMD, MCI_SPCMD_INIT_CMD));
+		while (!(mci_readl(host, SR) & MCI_BIT(CMDRDY)))
+			cpu_relax();
+		break;
+	default:
+		/*
+		 * TODO: None of the currently available AVR32-based
+		 * boards allow MMC power to be turned off. Implement
+		 * power control when this can be tested properly.
+		 */
+		break;
+	}
+}
+
+static int atmci_get_ro(struct mmc_host *mmc)
+{
+	int			read_only = 0;
+	struct atmel_mci	*host = mmc_priv(mmc);
+
+	if (host->wp_pin >= 0) {
+		read_only = gpio_get_value(host->wp_pin);
+		dev_dbg(&mmc->class_dev, "card is %s\n",
+				read_only ? "read-only" : "read-write");
+	} else {
+		dev_dbg(&mmc->class_dev,
+			"no pin for checking read-only switch."
+			" Assuming write-enable.\n");
+	}
+
+	return read_only;
+}
+
+static struct mmc_host_ops atmci_ops = {
+	.request	= atmci_request,
+	.set_ios	= atmci_set_ios,
+	.get_ro		= atmci_get_ro,
+};
+
+static void atmci_command_complete(struct atmel_mci *host,
+			struct mmc_command *cmd, u32 status)
+{
+	/* Read the response from the card (up to 16 bytes) */
+	cmd->resp[0] = mci_readl(host, RSPR);
+	cmd->resp[1] = mci_readl(host, RSPR);
+	cmd->resp[2] = mci_readl(host, RSPR);
+	cmd->resp[3] = mci_readl(host, RSPR);
+
+	host->cmd = NULL;
+
+	if (status & MCI_BIT(RTOE))
+		cmd->error = -ETIMEDOUT;
+	else if ((cmd->flags & MMC_RSP_CRC) && (status & MCI_BIT(RCRCE)))
+		cmd->error = -EILSEQ;
+	else if (status & (MCI_BIT(RINDE) | MCI_BIT(RDIRE) | MCI_BIT(RENDE)))
+		cmd->error = -EIO;
+
+	if (cmd->error) {
+		dev_dbg(&host->mmc->class_dev,
+			"command error: status=0x%08x\n", status);
+
+		if (cmd->data) {
+			atmci_stop_dma(host);
+			mci_writel(host, IDR, MCI_BIT(NOTBUSY)
+					| MCI_DATA_ERROR_FLAGS);
+			host->data = NULL;
+		}
+	}
+}
+
+static void atmci_tasklet_func(unsigned long priv)
+{
+	struct mmc_host		*mmc = (struct mmc_host *)priv;
+	struct atmel_mci	*host = mmc_priv(mmc);
+	struct mmc_request	*mrq = host->mrq;
+	struct mmc_data		*data = host->data;
+
+	dev_vdbg(&mmc->class_dev,
+		"tasklet: pending/completed/mask %lx/%lx/%x\n",
+		 host->pending_events, host->completed_events,
+		 mci_readl(host, IMR));
+
+	if (atmci_test_and_clear_pending(host, EVENT_CMD_COMPLETE)) {
+		atmci_set_completed(host, EVENT_CMD_COMPLETE);
+		atmci_command_complete(host, mrq->cmd, host->cmd_status);
+
+		if (mrq->stop && atmci_is_completed(host, EVENT_DMA_COMPLETE)
+				&& !atmci_test_and_set_completed(host,
+					EVENT_STOP_SENT))
+			send_stop_cmd(host->mmc, mrq->data);
+	}
+	if (atmci_test_and_clear_pending(host, EVENT_STOP_COMPLETE)) {
+		atmci_set_completed(host, EVENT_STOP_COMPLETE);
+		atmci_command_complete(host, mrq->stop, host->stop_status);
+	}
+	if (atmci_test_and_clear_pending(host, EVENT_DATA_ERROR)) {
+		u32 status = host->data_status;
+
+		atmci_set_completed(host, EVENT_DATA_ERROR);
+		atmci_clear_pending(host, EVENT_DATA_COMPLETE);
+
+		atmci_stop_dma(host);
+
+		if (status & MCI_BIT(DCRCE)) {
+			dev_dbg(&mmc->class_dev, "data CRC error\n");
+			data->error = -EILSEQ;
+		} else if (status & MCI_BIT(DTOE)) {
+			dev_dbg(&mmc->class_dev, "data timeout error\n");
+			data->error = -ETIMEDOUT;
+		} else {
+			dev_dbg(&mmc->class_dev, "data FIFO error\n");
+			data->error = -EIO;
+		}
+
+		if (data->stop && atmci_test_and_set_completed(host,
+					EVENT_STOP_SENT))
+			/* TODO: Check if card is still present */
+			send_stop_cmd(host->mmc, data);
+
+		host->data = NULL;
+	}
+	if (atmci_test_and_clear_pending(host, EVENT_DATA_COMPLETE)) {
+		atmci_set_completed(host, EVENT_DATA_COMPLETE);
+		data->bytes_xfered = data->blocks * data->blksz;
+		host->data = NULL;
+	}
+	if (atmci_test_and_clear_pending(host, EVENT_CARD_DETECT)) {
+		/* Reset controller if card is gone */
+		if (!host->present) {
+			mci_writel(host, CR, MCI_BIT(SWRST));
+			mci_writel(host, IDR, ~0UL);
+			mci_writel(host, CR, MCI_BIT(MCIEN));
+		}
+
+		/* Clean up queue if present */
+		if (mrq) {
+			if (!atmci_is_completed(host, EVENT_CMD_COMPLETE))
+				mrq->cmd->error = -EIO;
+
+			if (mrq->data && !atmci_is_completed(host,
+						EVENT_DATA_COMPLETE)
+					&& !atmci_is_completed(host,
+						EVENT_DATA_ERROR)) {
+				atmci_stop_dma(host);
+				mrq->data->error = -EIO;
+				host->data = NULL;
+			}
+			if (mrq->stop && !atmci_is_completed(host,
+						EVENT_STOP_COMPLETE))
+				mrq->stop->error = -EIO;
+
+			host->cmd = NULL;
+			atmci_request_end(mmc, mrq);
+		}
+		mmc_detect_change(host->mmc, msecs_to_jiffies(100));
+	}
+
+	if (host->mrq && !host->cmd && !host->data)
+		atmci_request_end(mmc, host->mrq);
+}
+
+static void atmci_cmd_interrupt(struct mmc_host *mmc, u32 status)
+{
+	struct atmel_mci	*host = mmc_priv(mmc);
+
+	mci_writel(host, IDR, MCI_BIT(CMDRDY));
+
+	if (atmci_is_completed(host, EVENT_STOP_SENT)) {
+		host->stop_status = status;
+		atmci_set_pending(host, EVENT_STOP_COMPLETE);
+	} else {
+		host->cmd_status = status;
+		atmci_set_pending(host, EVENT_CMD_COMPLETE);
+	}
+
+	tasklet_schedule(&host->tasklet);
+}
+
+static irqreturn_t atmci_interrupt(int irq, void *dev_id)
+{
+	struct mmc_host		*mmc = dev_id;
+	struct atmel_mci	*host = mmc_priv(mmc);
+	u32			status, mask, pending;
+
+	spin_lock(&mmc->lock);
+
+	status = mci_readl(host, SR);
+	mask = mci_readl(host, IMR);
+	pending = status & mask;
+
+	do {
+		if (pending & MCI_DATA_ERROR_FLAGS) {
+			mci_writel(host, IDR, (MCI_BIT(NOTBUSY)
+					       | MCI_DATA_ERROR_FLAGS));
+			host->data_status = status;
+			atmci_set_pending(host, EVENT_DATA_ERROR);
+			tasklet_schedule(&host->tasklet);
+			break;
+		}
+		if (pending & MCI_BIT(CMDRDY))
+			atmci_cmd_interrupt(mmc, status);
+		if (pending & MCI_BIT(NOTBUSY)) {
+			mci_writel(host, IDR, (MCI_BIT(NOTBUSY)
+					       | MCI_DATA_ERROR_FLAGS));
+			atmci_set_pending(host, EVENT_DATA_COMPLETE);
+			tasklet_schedule(&host->tasklet);
+		}
+
+		status = mci_readl(host, SR);
+		mask = mci_readl(host, IMR);
+		pending = status & mask;
+	} while (pending);
+
+	spin_unlock(&mmc->lock);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t atmci_detect_change(int irq, void *dev_id)
+{
+	struct mmc_host		*mmc = dev_id;
+	struct atmel_mci	*host = mmc_priv(mmc);
+
+	int present = !gpio_get_value(irq_to_gpio(irq));
+
+	if (present != host->present) {
+		dev_dbg(&mmc->class_dev, "card %s\n",
+			present ? "inserted" : "removed");
+		host->present = present;
+		atmci_set_pending(host, EVENT_CARD_DETECT);
+		tasklet_schedule(&host->tasklet);
+	}
+	return IRQ_HANDLED;
+}
+
+static enum dma_state_client atmci_dma_event(struct dma_client *client,
+		struct dma_chan *chan, enum dma_state state)
+{
+	struct atmel_mci	*host;
+	enum dma_state_client	ret = DMA_NAK;
+
+	host = dma_client_to_atmel_mci(client);
+
+	switch (state) {
+	case DMA_RESOURCE_AVAILABLE:
+		if (!host->dma.chan) {
+			dev_dbg(&host->pdev->dev, "Got channel %s\n",
+					chan->dev.bus_id);
+			host->dma.chan = chan;
+			ret = DMA_ACK;
+		}
+		break;
+
+	case DMA_RESOURCE_REMOVED:
+		if (host->dma.chan == chan) {
+			dev_dbg(&host->pdev->dev, "Lost channel %s\n",
+					chan->dev.bus_id);
+			host->dma.chan = NULL;
+			ret = DMA_ACK;
+		}
+		break;
+
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int __init atmci_probe(struct platform_device *pdev)
+{
+	struct mci_platform_data	*pdata;
+	struct atmel_mci *host;
+	struct mmc_host *mmc;
+	struct resource *regs;
+	struct dma_chan *chan;
+	int irq;
+	int ret;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs)
+		return -ENXIO;
+	pdata = pdev->dev.platform_data;
+	if (!pdata)
+		return -ENXIO;
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	mmc = mmc_alloc_host(sizeof(struct atmel_mci), &pdev->dev);
+	if (!mmc)
+		return -ENOMEM;
+
+	host = mmc_priv(mmc);
+	host->pdev = pdev;
+	host->mmc = mmc;
+	host->detect_pin = pdata->detect_pin;
+	host->wp_pin = pdata->wp_pin;
+	INIT_LIST_HEAD(&host->dma.data_descs);
+
+	host->mck = clk_get(&pdev->dev, "mci_clk");
+	if (IS_ERR(host->mck)) {
+		ret = PTR_ERR(host->mck);
+		goto err_clk_get;
+	}
+	clk_enable(host->mck);
+
+	ret = -ENOMEM;
+	host->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	if (!host->regs)
+		goto err_ioremap;
+
+	mci_writel(host, CR, MCI_BIT(SWRST));
+	mci_writel(host, IDR, ~0UL);
+
+	host->bus_hz = clk_get_rate(host->mck);
+	host->mapbase = regs->start;
+
+	mmc->ops = &atmci_ops;
+	mmc->f_min = (host->bus_hz + 511) / 512;
+	mmc->f_max = min((unsigned int)(host->bus_hz / 2), fmax);
+	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
+	mmc->caps |= MMC_CAP_4_BIT_DATA;
+
+	tasklet_init(&host->tasklet, atmci_tasklet_func, (unsigned long)mmc);
+
+	ret = request_irq(irq, atmci_interrupt, 0, "mmci", mmc);
+	if (ret)
+		goto err_request_irq;
+
+	host->dma.slave.dev = &pdev->dev;
+	host->dma.slave.tx_reg = regs->start + MCI_TDR;
+	host->dma.slave.rx_reg = regs->start + MCI_RDR;
+	host->dma.slave.tx_handshake_id = pdata->tx_periph_id;
+	host->dma.slave.rx_handshake_id = pdata->rx_periph_id;
+
+	/* Try to grab a DMA channel */
+	host->dma.client.event_callback = atmci_dma_event;
+	dma_cap_set(DMA_SLAVE, host->dma.client.cap_mask);
+	host->dma.client.slave = &host->dma.slave;
+
+	dma_async_client_register(&host->dma.client);
+	dma_async_client_chan_request(&host->dma.client);
+
+	chan = host->dma.chan;
+	if (!chan) {
+		dev_dbg(&mmc->class_dev, "no DMA channels available\n");
+		ret = -ENODEV;
+		goto err_dma_chan;
+	}
+
+	/* Assume card is present if we don't have a detect pin */
+	host->present = 1;
+	if (host->detect_pin >= 0) {
+		if (gpio_request(host->detect_pin, "mmc_detect")) {
+			dev_dbg(&mmc->class_dev, "no detect pin available\n");
+			host->detect_pin = -1;
+		} else {
+			host->present = !gpio_get_value(host->detect_pin);
+		}
+	}
+	if (host->wp_pin >= 0) {
+		if (gpio_request(host->wp_pin, "mmc_wp")) {
+			dev_dbg(&mmc->class_dev, "no WP pin available\n");
+			host->wp_pin = -1;
+		}
+	}
+
+	platform_set_drvdata(pdev, host);
+
+	mmc_add_host(mmc);
+
+	if (host->detect_pin >= 0) {
+		ret = request_irq(gpio_to_irq(host->detect_pin),
+				atmci_detect_change,
+				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+				DRIVER_NAME, mmc);
+		if (ret) {
+			dev_dbg(&mmc->class_dev,
+				"could not request IRQ %d for detect pin\n",
+				gpio_to_irq(host->detect_pin));
+			gpio_free(host->detect_pin);
+			host->detect_pin = -1;
+		}
+	}
+
+	dev_info(&mmc->class_dev,
+			"Atmel MCI controller at 0x%08lx irq %d dma %s\n",
+			host->mapbase, irq, chan->dev.bus_id);
+
+	atmci_init_debugfs(host);
+
+	return 0;
+
+err_dma_chan:
+	free_irq(irq, mmc);
+err_request_irq:
+	iounmap(host->regs);
+err_ioremap:
+	clk_disable(host->mck);
+	clk_put(host->mck);
+err_clk_get:
+	mmc_free_host(mmc);
+	return ret;
+}
+
+static int __exit atmci_remove(struct platform_device *pdev)
+{
+	struct atmel_mci *host = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+
+	if (host) {
+		atmci_cleanup_debugfs(host);
+
+		if (host->detect_pin >= 0) {
+			free_irq(gpio_to_irq(host->detect_pin), host->mmc);
+			cancel_delayed_work(&host->mmc->detect);
+			gpio_free(host->detect_pin);
+		}
+
+		mmc_remove_host(host->mmc);
+
+		mci_writel(host, IDR, ~0UL);
+		mci_writel(host, CR, MCI_BIT(MCIDIS));
+		mci_readl(host, SR);
+
+		dma_async_client_unregister(&host->dma.client);
+
+		if (host->wp_pin >= 0)
+			gpio_free(host->wp_pin);
+
+		free_irq(platform_get_irq(pdev, 0), host->mmc);
+		iounmap(host->regs);
+
+		clk_disable(host->mck);
+		clk_put(host->mck);
+
+		mmc_free_host(host->mmc);
+	}
+	return 0;
+}
+
+static struct platform_driver atmci_driver = {
+	.remove		= __exit_p(atmci_remove),
+	.driver		= {
+		.name		= DRIVER_NAME,
+	},
+};
+
+static int __init atmci_init(void)
+{
+	return platform_driver_probe(&atmci_driver, atmci_probe);
+}
+
+static void __exit atmci_exit(void)
+{
+	platform_driver_unregister(&atmci_driver);
+}
+
+module_init(atmci_init);
+module_exit(atmci_exit);
+
+MODULE_DESCRIPTION("Atmel Multimedia Card Interface driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mmc/host/atmel-mci.h b/drivers/mmc/host/atmel-mci.h
new file mode 100644
index 0000000..60d15c4
--- /dev/null
+++ b/drivers/mmc/host/atmel-mci.h
@@ -0,0 +1,192 @@
+/*
+ * Atmel MultiMedia Card Interface driver
+ *
+ * Copyright (C) 2004-2006 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __DRIVERS_MMC_ATMEL_MCI_H__
+#define __DRIVERS_MMC_ATMEL_MCI_H__
+
+/* MCI register offsets */
+#define MCI_CR					0x0000
+#define MCI_MR					0x0004
+#define MCI_DTOR				0x0008
+#define MCI_SDCR				0x000c
+#define MCI_ARGR				0x0010
+#define MCI_CMDR				0x0014
+#define MCI_BLKR				0x0018
+#define MCI_RSPR				0x0020
+#define MCI_RSPR1				0x0024
+#define MCI_RSPR2				0x0028
+#define MCI_RSPR3				0x002c
+#define MCI_RDR					0x0030
+#define MCI_TDR					0x0034
+#define MCI_SR					0x0040
+#define MCI_IER					0x0044
+#define MCI_IDR					0x0048
+#define MCI_IMR					0x004c
+
+/* Bitfields in CR */
+#define MCI_MCIEN_OFFSET			0
+#define MCI_MCIEN_SIZE				1
+#define MCI_MCIDIS_OFFSET			1
+#define MCI_MCIDIS_SIZE				1
+#define MCI_PWSEN_OFFSET			2
+#define MCI_PWSEN_SIZE				1
+#define MCI_PWSDIS_OFFSET			3
+#define MCI_PWSDIS_SIZE				1
+#define MCI_SWRST_OFFSET			7
+#define MCI_SWRST_SIZE				1
+
+/* Bitfields in MR */
+#define MCI_CLKDIV_OFFSET			0
+#define MCI_CLKDIV_SIZE				8
+#define MCI_PWSDIV_OFFSET			8
+#define MCI_PWSDIV_SIZE				3
+#define MCI_RDPROOF_OFFSET			11
+#define MCI_RDPROOF_SIZE			1
+#define MCI_WRPROOF_OFFSET			12
+#define MCI_WRPROOF_SIZE			1
+#define MCI_DMAPADV_OFFSET			14
+#define MCI_DMAPADV_SIZE			1
+#define MCI_BLKLEN_OFFSET			16
+#define MCI_BLKLEN_SIZE				16
+
+/* Bitfields in DTOR */
+#define MCI_DTOCYC_OFFSET			0
+#define MCI_DTOCYC_SIZE				4
+#define MCI_DTOMUL_OFFSET			4
+#define MCI_DTOMUL_SIZE				3
+
+/* Bitfields in SDCR */
+#define MCI_SDCSEL_OFFSET			0
+#define MCI_SDCSEL_SIZE				4
+#define MCI_SDCBUS_OFFSET			7
+#define MCI_SDCBUS_SIZE				1
+
+/* Bitfields in ARGR */
+#define MCI_ARG_OFFSET				0
+#define MCI_ARG_SIZE				32
+
+/* Bitfields in CMDR */
+#define MCI_CMDNB_OFFSET			0
+#define MCI_CMDNB_SIZE				6
+#define MCI_RSPTYP_OFFSET			6
+#define MCI_RSPTYP_SIZE				2
+#define MCI_SPCMD_OFFSET			8
+#define MCI_SPCMD_SIZE				3
+#define MCI_OPDCMD_OFFSET			11
+#define MCI_OPDCMD_SIZE				1
+#define MCI_MAXLAT_OFFSET			12
+#define MCI_MAXLAT_SIZE				1
+#define MCI_TRCMD_OFFSET			16
+#define MCI_TRCMD_SIZE				2
+#define MCI_TRDIR_OFFSET			18
+#define MCI_TRDIR_SIZE				1
+#define MCI_TRTYP_OFFSET			19
+#define MCI_TRTYP_SIZE				2
+
+/* Bitfields in BLKR */
+#define MCI_BCNT_OFFSET				0
+#define MCI_BCNT_SIZE				16
+
+/* Bitfields in RSPRn */
+#define MCI_RSP_OFFSET				0
+#define MCI_RSP_SIZE				32
+
+/* Bitfields in SR/IER/IDR/IMR */
+#define MCI_CMDRDY_OFFSET			0
+#define MCI_CMDRDY_SIZE				1
+#define MCI_RXRDY_OFFSET			1
+#define MCI_RXRDY_SIZE				1
+#define MCI_TXRDY_OFFSET			2
+#define MCI_TXRDY_SIZE				1
+#define MCI_BLKE_OFFSET				3
+#define MCI_BLKE_SIZE				1
+#define MCI_DTIP_OFFSET				4
+#define MCI_DTIP_SIZE				1
+#define MCI_NOTBUSY_OFFSET			5
+#define MCI_NOTBUSY_SIZE			1
+#define MCI_ENDRX_OFFSET			6
+#define MCI_ENDRX_SIZE				1
+#define MCI_ENDTX_OFFSET			7
+#define MCI_ENDTX_SIZE				1
+#define MCI_RXBUFF_OFFSET			14
+#define MCI_RXBUFF_SIZE				1
+#define MCI_TXBUFE_OFFSET			15
+#define MCI_TXBUFE_SIZE				1
+#define MCI_RINDE_OFFSET			16
+#define MCI_RINDE_SIZE				1
+#define MCI_RDIRE_OFFSET			17
+#define MCI_RDIRE_SIZE				1
+#define MCI_RCRCE_OFFSET			18
+#define MCI_RCRCE_SIZE				1
+#define MCI_RENDE_OFFSET			19
+#define MCI_RENDE_SIZE				1
+#define MCI_RTOE_OFFSET				20
+#define MCI_RTOE_SIZE				1
+#define MCI_DCRCE_OFFSET			21
+#define MCI_DCRCE_SIZE				1
+#define MCI_DTOE_OFFSET				22
+#define MCI_DTOE_SIZE				1
+#define MCI_OVRE_OFFSET				30
+#define MCI_OVRE_SIZE				1
+#define MCI_UNRE_OFFSET				31
+#define MCI_UNRE_SIZE				1
+
+/* Constants for DTOMUL */
+#define MCI_DTOMUL_1_CYCLE			0
+#define MCI_DTOMUL_16_CYCLES			1
+#define MCI_DTOMUL_128_CYCLES			2
+#define MCI_DTOMUL_256_CYCLES			3
+#define MCI_DTOMUL_1024_CYCLES			4
+#define MCI_DTOMUL_4096_CYCLES			5
+#define MCI_DTOMUL_65536_CYCLES			6
+#define MCI_DTOMUL_1048576_CYCLES		7
+
+/* Constants for RSPTYP */
+#define MCI_RSPTYP_NO_RESP			0
+#define MCI_RSPTYP_48_BIT			1
+#define MCI_RSPTYP_136_BIT			2
+
+/* Constants for SPCMD */
+#define MCI_SPCMD_NO_SPEC_CMD			0
+#define MCI_SPCMD_INIT_CMD			1
+#define MCI_SPCMD_SYNC_CMD			2
+#define MCI_SPCMD_INT_CMD			4
+#define MCI_SPCMD_INT_RESP			5
+
+/* Constants for TRCMD */
+#define MCI_TRCMD_NO_TRANS			0
+#define MCI_TRCMD_START_TRANS			1
+#define MCI_TRCMD_STOP_TRANS			2
+
+/* Constants for TRTYP */
+#define MCI_TRTYP_BLOCK				0
+#define MCI_TRTYP_MULTI_BLOCK			1
+#define MCI_TRTYP_STREAM			2
+
+/* Bit manipulation macros */
+#define MCI_BIT(name)					\
+	(1 << MCI_##name##_OFFSET)
+#define MCI_BF(name,value)				\
+	(((value) & ((1 << MCI_##name##_SIZE) - 1))	\
+	 << MCI_##name##_OFFSET)
+#define MCI_BFEXT(name,value)				\
+	(((value) >> MCI_##name##_OFFSET)		\
+	 & ((1 << MCI_##name##_SIZE) - 1))
+#define MCI_BFINS(name,value,old)			\
+	(((old) & ~(((1 << MCI_##name##_SIZE) - 1)	\
+		    << MCI_##name##_OFFSET))		\
+	 | MCI_BF(name,value))
+
+/* Register access macros */
+#define mci_readl(port,reg)				\
+	__raw_readl((port)->regs + MCI_##reg)
+#define mci_writel(port,reg,value)			\
+	__raw_writel((value), (port)->regs + MCI_##reg)
+
+#endif /* __DRIVERS_MMC_ATMEL_MCI_H__ */
diff --git a/include/asm-avr32/arch-at32ap/board.h b/include/asm-avr32/arch-at32ap/board.h
index d6993a6..665682e 100644
--- a/include/asm-avr32/arch-at32ap/board.h
+++ b/include/asm-avr32/arch-at32ap/board.h
@@ -66,7 +66,15 @@ struct platform_device *
 at32_add_device_ssc(unsigned int id, unsigned int flags);
 
 struct platform_device *at32_add_device_twi(unsigned int id);
-struct platform_device *at32_add_device_mci(unsigned int id);
+
+struct mci_platform_data {
+	unsigned int tx_periph_id;
+	unsigned int rx_periph_id;
+	int detect_pin;
+	int wp_pin;
+};
+struct platform_device *
+at32_add_device_mci(unsigned int id, struct mci_platform_data *data);
 struct platform_device *at32_add_device_ac97c(unsigned int id);
 struct platform_device *at32_add_device_abdac(unsigned int id);
 
-- 
1.5.3.8

