Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbZAVCBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbZAVCBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 21:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbZAVCAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 21:00:31 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:44879 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755824AbZAVCAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 21:00:31 -0500
Date: Thu, 22 Jan 2009 05:00:29 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, Xie Xiaobo <X.Xie@freescale.com>,
       Konjin Lai <Konjin.Lai@freescale.com>,
       "Joe D'Abbraccio" <Joe.D'abbraccio@freescale.com>,
       sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 05/10] sdhci: Add support for hosts with strict 32 bit
	addressing
Message-ID: <20090122020029.GE11492@oksana.dev.rtsoft.ru>
References: <20090122015649.GA6835@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090122015649.GA6835@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SDHCI driver must take special care when working with "triggering"
registers on hosts with strict 32 bit addressing.

In FSL eSDHC hosts all registers are 32 bit width, writing to the
first half of any register will cause [undefined?] write the second
half of the register. That is, 16 bit write to the TRANSFER_MODE
register, makes hardware see a bogus write to the COMMAND register
(these two registers are adjacent).

This patch adds SDHCI_QUIRK_32BIT_REGISTERS quirk. When specified,
the sdhci driver will try to "pack" all dangerous writes into single
32 bit write transaction.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |   18 +++++++++++++-----
 drivers/mmc/host/sdhci.h |    4 ++++
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 63809f5..c3737fe 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -742,13 +742,13 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 	sdhci_writew(host, SDHCI_BLOCK_COUNT, data->blocks);
 }
 
-static void sdhci_set_transfer_mode(struct sdhci_host *host,
+static u16 sdhci_get_transfer_mode(struct sdhci_host *host,
 	struct mmc_data *data)
 {
 	u16 mode;
 
 	if (data == NULL)
-		return;
+		return 0;
 
 	WARN_ON(!host->data);
 
@@ -760,7 +760,7 @@ static void sdhci_set_transfer_mode(struct sdhci_host *host,
 	if (host->flags & SDHCI_REQ_USE_DMA)
 		mode |= SDHCI_TRNS_DMA;
 
-	sdhci_writew(host, SDHCI_TRANSFER_MODE, mode);
+	return mode;
 }
 
 static void sdhci_finish_data(struct sdhci_host *host)
@@ -812,6 +812,7 @@ static void sdhci_finish_data(struct sdhci_host *host)
 static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 {
 	int flags;
+	u16 xfer_mode;
 	u32 mask;
 	unsigned long timeout;
 
@@ -850,7 +851,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 
 	sdhci_writel(host, SDHCI_ARGUMENT, cmd->arg);
 
-	sdhci_set_transfer_mode(host, cmd->data);
+	xfer_mode = sdhci_get_transfer_mode(host, cmd->data);
 
 	if ((cmd->flags & MMC_RSP_136) && (cmd->flags & MMC_RSP_BUSY)) {
 		printk(KERN_ERR "%s: Unsupported response type!\n",
@@ -876,7 +877,14 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 	if (cmd->data)
 		flags |= SDHCI_CMD_DATA;
 
-	sdhci_writew(host, SDHCI_COMMAND, SDHCI_MAKE_CMD(cmd->opcode, flags));
+	if (host->quirks & SDHCI_QUIRK_32BIT_REGISTERS) {
+		sdhci_writel(host, SDHCI_TRANSFER_MODE,
+			SDHCI_MAKE_CMD_32BIT(cmd->opcode, flags, xfer_mode));
+	} else {
+		sdhci_writew(host, SDHCI_TRANSFER_MODE, xfer_mode);
+		sdhci_writew(host, SDHCI_COMMAND,
+			SDHCI_MAKE_CMD(cmd->opcode, flags));
+	}
 }
 
 static void sdhci_finish_command(struct sdhci_host *host)
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 9cd2b78..2747340 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -44,6 +44,8 @@
 #define  SDHCI_CMD_RESP_SHORT_BUSY 0x03
 
 #define SDHCI_MAKE_CMD(c, f) (((c & 0xff) << 8) | (f & 0xff))
+#define SDHCI_MAKE_CMD_32BIT(c, f, m) \
+	((((c) & 0xff) << 24) | (((f) & 0xff) << 16) | ((m) & 0x37))
 
 #define SDHCI_RESPONSE		0x10
 
@@ -217,6 +219,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_BROKEN_CARD_DETECTION		(1<<16)
 /* Controller reports inverted write-protect state */
 #define SDHCI_QUIRK_INVERTED_WRITE_PROTECT		(1<<17)
+/* Controller has all registers of 32 bit width */
+#define SDHCI_QUIRK_32BIT_REGISTERS			(1<<18)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5

