Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbYGANQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbYGANQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbYGANPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:15:09 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:48084 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbYGANPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:15:07 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH v2 4/4] atmel-mci: debugfs support
Date: Tue,  1 Jul 2008 15:14:54 +0200
Message-Id: <1214918094-26758-4-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214918094-26758-3-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214843703-13199-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214918094-26758-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214918094-26758-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1214918094-26758-3-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 01 Jul 2008 13:14:57.0626 (UTC) FILETIME=[75A563A0:01C8DB7C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create additional files under the host's debugfs directory containing
additional host-specific debug information.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Changes since atmel-mci v4:
  * Use seq_file to simplify `req' file ops
  * Make the output from the `regs' debugfs file more readable to humans
---
 drivers/mmc/host/atmel-mci-regs.h |    2 +
 drivers/mmc/host/atmel-mci.c      |  189 +++++++++++++++++++++++++++++++++++++
 2 files changed, 191 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci-regs.h b/drivers/mmc/host/atmel-mci-regs.h
index a9a5657..26bd80e 100644
--- a/drivers/mmc/host/atmel-mci-regs.h
+++ b/drivers/mmc/host/atmel-mci-regs.h
@@ -82,6 +82,8 @@
 # define MCI_OVRE		(  1 <<  30)	/* RX Overrun Error */
 # define MCI_UNRE		(  1 <<  31)	/* TX Underrun Error */
 
+#define MCI_REGS_SIZE		0x100
+
 /* Register access macros */
 #define mci_readl(port,reg)				\
 	__raw_readl((port)->regs + MCI_##reg)
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 25d5324..71f7fe5 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -9,6 +9,7 @@
  */
 #include <linux/blkdev.h>
 #include <linux/clk.h>
+#include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -16,6 +17,8 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/scatterlist.h>
+#include <linux/seq_file.h>
+#include <linux/stat.h>
 
 #include <linux/mmc/host.h>
 
@@ -88,6 +91,188 @@ struct atmel_mci {
 #define atmci_clear_pending(host, event)			\
 	clear_bit(event, &host->pending_events)
 
+/*
+ * The debugfs stuff below is mostly optimized away when
+ * CONFIG_DEBUG_FS is not set.
+ */
+static int atmci_req_show(struct seq_file *s, void *v)
+{
+	struct atmel_mci	*host = s->private;
+	struct mmc_request	*mrq = host->mrq;
+	struct mmc_command	*cmd;
+	struct mmc_command	*stop;
+	struct mmc_data		*data;
+
+	/* Make sure we get a consistent snapshot */
+	spin_lock_irq(&host->mmc->lock);
+
+	if (mrq) {
+		cmd = mrq->cmd;
+		data = mrq->data;
+		stop = mrq->stop;
+
+		if (cmd)
+			seq_printf(s,
+				"CMD%u(0x%x) flg %x rsp %x %x %x %x err %d\n",
+				cmd->opcode, cmd->arg, cmd->flags,
+				cmd->resp[0], cmd->resp[1], cmd->resp[2],
+				cmd->resp[2], cmd->error);
+		if (data)
+			seq_printf(s, "DATA %u / %u * %u flg %x err %d\n",
+				data->bytes_xfered, data->blocks,
+				data->blksz, data->flags, data->error);
+		if (stop)
+			seq_printf(s,
+				"CMD%u(0x%x) flg %x rsp %x %x %x %x err %d\n",
+				stop->opcode, stop->arg, stop->flags,
+				stop->resp[0], stop->resp[1], stop->resp[2],
+				stop->resp[2], stop->error);
+	}
+
+	spin_unlock_irq(&host->mmc->lock);
+
+	return 0;
+}
+
+static int atmci_req_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, atmci_req_show, inode->i_private);
+}
+
+static const struct file_operations atmci_req_fops = {
+	.owner		= THIS_MODULE,
+	.open		= atmci_req_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void atmci_show_status_reg(struct seq_file *s,
+		const char *regname, u32 value)
+{
+	static const char	*sr_bit[] = {
+		[0]	= "CMDRDY",
+		[1]	= "RXRDY",
+		[2]	= "TXRDY",
+		[3]	= "BLKE",
+		[4]	= "DTIP",
+		[5]	= "NOTBUSY",
+		[8]	= "SDIOIRQA",
+		[9]	= "SDIOIRQB",
+		[16]	= "RINDE",
+		[17]	= "RDIRE",
+		[18]	= "RCRCE",
+		[19]	= "RENDE",
+		[20]	= "RTOE",
+		[21]	= "DCRCE",
+		[22]	= "DTOE",
+		[30]	= "OVRE",
+		[31]	= "UNRE",
+	};
+	unsigned int		i;
+
+	seq_printf(s, "%s:\t0x%08x", regname, value);
+	for (i = 0; i < ARRAY_SIZE(sr_bit); i++) {
+		if (value & (1 << i)) {
+			if (sr_bit[i])
+				seq_printf(s, " %s", sr_bit[i]);
+			else
+				seq_puts(s, " UNKNOWN");
+		}
+	}
+	seq_putc(s, '\n');
+}
+
+static int atmci_regs_show(struct seq_file *s, void *v)
+{
+	struct atmel_mci	*host = s->private;
+	u32			*buf;
+
+	buf = kmalloc(MCI_REGS_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	/* Grab a more or less consistent snapshot */
+	spin_lock_irq(&host->mmc->lock);
+	memcpy_fromio(buf, host->regs, MCI_REGS_SIZE);
+	spin_unlock_irq(&host->mmc->lock);
+
+	seq_printf(s, "MR:\t0x%08x%s%s CLKDIV=%u\n",
+			buf[MCI_MR / 4],
+			buf[MCI_MR / 4] & MCI_MR_RDPROOF ? " RDPROOF" : "",
+			buf[MCI_MR / 4] & MCI_MR_WRPROOF ? " WRPROOF" : "",
+			buf[MCI_MR / 4] & 0xff);
+	seq_printf(s, "DTOR:\t0x%08x\n", buf[MCI_DTOR / 4]);
+	seq_printf(s, "SDCR:\t0x%08x\n", buf[MCI_SDCR / 4]);
+	seq_printf(s, "ARGR:\t0x%08x\n", buf[MCI_ARGR / 4]);
+	seq_printf(s, "BLKR:\t0x%08x BCNT=%u BLKLEN=%u\n",
+			buf[MCI_BLKR / 4],
+			buf[MCI_BLKR / 4] & 0xffff,
+			(buf[MCI_BLKR / 4] >> 16) & 0xffff);
+
+	/* Don't read RSPR and RDR; it will consume the data there */
+
+	atmci_show_status_reg(s, "SR", buf[MCI_SR / 4]);
+	atmci_show_status_reg(s, "IMR", buf[MCI_IMR / 4]);
+
+	return 0;
+}
+
+static int atmci_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, atmci_regs_show, inode->i_private);
+}
+
+static const struct file_operations atmci_regs_fops = {
+	.owner		= THIS_MODULE,
+	.open		= atmci_regs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void atmci_init_debugfs(struct atmel_mci *host)
+{
+	struct mmc_host	*mmc;
+	struct dentry	*root;
+	struct dentry	*node;
+	struct resource	*res;
+
+	mmc = host->mmc;
+	root = mmc->debugfs_root;
+	if (!root)
+		return;
+
+	node = debugfs_create_file("regs", S_IRUSR, root, host,
+			&atmci_regs_fops);
+	if (IS_ERR(node))
+		return;
+	if (!node)
+		goto err;
+
+	res = platform_get_resource(host->pdev, IORESOURCE_MEM, 0);
+	node->d_inode->i_size = res->end - res->start + 1;
+
+	node = debugfs_create_file("req", S_IRUSR, root, host, &atmci_req_fops);
+	if (!node)
+		goto err;
+
+	node = debugfs_create_x32("pending_events", S_IRUSR, root,
+				     (u32 *)&host->pending_events);
+	if (!node)
+		goto err;
+
+	node = debugfs_create_x32("completed_events", S_IRUSR, root,
+				     (u32 *)&host->completed_events);
+	if (!node)
+		goto err;
+
+	return;
+
+err:
+	dev_err(&host->pdev->dev,
+		"failed to initialize debugfs for controller\n");
+}
 
 static void atmci_enable(struct atmel_mci *host)
 {
@@ -905,6 +1090,8 @@ static int __init atmci_probe(struct platform_device *pdev)
 			"Atmel MCI controller at 0x%08lx irq %d\n",
 			host->mapbase, irq);
 
+	atmci_init_debugfs(host);
+
 	return 0;
 
 err_request_irq:
@@ -923,6 +1110,8 @@ static int __exit atmci_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 
 	if (host) {
+		/* Debugfs stuff is cleaned up by mmc core */
+
 		if (host->detect_pin >= 0) {
 			int pin = host->detect_pin;
 
-- 
1.5.6

