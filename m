Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbZBFSIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbZBFSIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbZBFSG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:06:57 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:3221 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759159AbZBFSGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:06:55 -0500
Date: Fri, 6 Feb 2009 21:06:54 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 06/11] sdhci: Add support for hosts with strict 32 bit
	addressing
Message-ID: <20090206180654.GF11548@oksana.dev.rtsoft.ru>
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
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
 drivers/mmc/host/sdhci.c |   19 ++++++++++++++-----
 drivers/mmc/host/sdhci.h |    4 ++++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 85f3780..9b43588 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -747,13 +747,13 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 	sdhci_writew(host, data->blocks, SDHCI_BLOCK_COUNT);
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
 
@@ -765,7 +765,7 @@ static void sdhci_set_transfer_mode(struct sdhci_host *host,
 	if (host->flags & SDHCI_REQ_USE_DMA)
 		mode |= SDHCI_TRNS_DMA;
 
-	sdhci_writew(host, mode, SDHCI_TRANSFER_MODE);
+	return mode;
 }
 
 static void sdhci_finish_data(struct sdhci_host *host)
@@ -817,6 +817,7 @@ static void sdhci_finish_data(struct sdhci_host *host)
 static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 {
 	int flags;
+	u16 xfer_mode;
 	u32 mask;
 	unsigned long timeout;
 
@@ -855,7 +856,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 
 	sdhci_writel(host, cmd->arg, SDHCI_ARGUMENT);
 
-	sdhci_set_transfer_mode(host, cmd->data);
+	xfer_mode = sdhci_get_transfer_mode(host, cmd->data);
 
 	if ((cmd->flags & MMC_RSP_136) && (cmd->flags & MMC_RSP_BUSY)) {
 		printk(KERN_ERR "%s: Unsupported response type!\n",
@@ -881,7 +882,15 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 	if (cmd->data)
 		flags |= SDHCI_CMD_DATA;
 
-	sdhci_writew(host, SDHCI_MAKE_CMD(cmd->opcode, flags), SDHCI_COMMAND);
+	if (host->quirks & SDHCI_QUIRK_32BIT_REGISTERS) {
+		sdhci_writel(host,
+			SDHCI_MAKE_CMD_32BIT(cmd->opcode, flags, xfer_mode),
+			SDHCI_TRANSFER_MODE);
+	} else {
+		sdhci_writew(host, xfer_mode, SDHCI_TRANSFER_MODE);
+		sdhci_writew(host, SDHCI_MAKE_CMD(cmd->opcode, flags),
+			SDHCI_COMMAND);
+	}
 }
 
 static void sdhci_finish_command(struct sdhci_host *host)
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index fd151a1..c4edd52 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -58,6 +58,8 @@ static inline int sdhci_off(sdhci_reg_t reg)
 #define  SDHCI_CMD_RESP_SHORT_BUSY 0x03
 
 #define SDHCI_MAKE_CMD(c, f) (((c & 0xff) << 8) | (f & 0xff))
+#define SDHCI_MAKE_CMD_32BIT(c, f, m) \
+	((((c) & 0xff) << 24) | (((f) & 0xff) << 16) | ((m) & 0x37))
 
 #define SDHCI_RESPONSE		sdhci_reg(0x10)
 
@@ -231,6 +233,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_BROKEN_CARD_DETECTION		(1<<16)
 /* Controller reports inverted write-protect state */
 #define SDHCI_QUIRK_INVERTED_WRITE_PROTECT		(1<<17)
+/* Controller has all registers of 32 bit width */
+#define SDHCI_QUIRK_32BIT_REGISTERS			(1<<18)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5

