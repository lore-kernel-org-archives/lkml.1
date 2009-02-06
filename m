Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbZBFSHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbZBFSHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbZBFSGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:06:51 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:3194 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756784AbZBFSGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:06:50 -0500
Date: Fri, 6 Feb 2009 21:06:48 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 03/11] sdhci: Add type checking for IO memory accessors
Message-ID: <20090206180648.GC11548@oksana.dev.rtsoft.ru>
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new restricted integer type introduced: sdhci_reg_t.

Header file now specifies registers via sdhci_reg() inline function.
Only one place (not counting sdhci_def_*() accessors) need to cast
a register back to an offset, i.e. sdhci_finish_command().

>From now on sparse tool will warn about IO memory accessors misuses,
for exampple:

sdhci_writeb(host, SDHCI_TIMEOUT_CONTROL, count);

  CHECK   sdhci.c
sdhci.c:614:21: warning: incorrect type in argument 2 (different base types)
sdhci.c:614:21:    expected unsigned char [unsigned] [usertype] val
sdhci.c:614:21:    got restricted int
sdhci.c:614:44: warning: incorrect type in argument 3 (different base types)
sdhci.c:614:44:    expected restricted int [usertype] reg
sdhci.c:614:44:    got unsigned char [unsigned] [assigned] [usertype] count

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |   32 +++++++------
 drivers/mmc/host/sdhci.h |  113 ++++++++++++++++++++++++++-------------------
 2 files changed, 82 insertions(+), 63 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 8557521..b7a79a0 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -87,34 +87,34 @@ static void sdhci_dumpregs(struct sdhci_host *host)
  *                                                                           *
 \*****************************************************************************/
 
-static u32 sdhci_def_readl(struct sdhci_host *host, int reg)
+static u32 sdhci_def_readl(struct sdhci_host *host, sdhci_reg_t reg)
 {
-	return readl(host->ioaddr + reg);
+	return readl(host->ioaddr + sdhci_off(reg));
 }
 
-static u16 sdhci_def_readw(struct sdhci_host *host, int reg)
+static u16 sdhci_def_readw(struct sdhci_host *host, sdhci_reg_t reg)
 {
-	return readw(host->ioaddr + reg);
+	return readw(host->ioaddr + sdhci_off(reg));
 }
 
-static u8 sdhci_def_readb(struct sdhci_host *host, int reg)
+static u8 sdhci_def_readb(struct sdhci_host *host, sdhci_reg_t reg)
 {
-	return readb(host->ioaddr + reg);
+	return readb(host->ioaddr + sdhci_off(reg));
 }
 
-static void sdhci_def_writel(struct sdhci_host *host, u32 val, int reg)
+static void sdhci_def_writel(struct sdhci_host *host, u32 val, sdhci_reg_t reg)
 {
-	writel(val, host->ioaddr + reg);
+	writel(val, host->ioaddr + sdhci_off(reg));
 }
 
-static void sdhci_def_writew(struct sdhci_host *host, u16 val, int reg)
+static void sdhci_def_writew(struct sdhci_host *host, u16 val, sdhci_reg_t reg)
 {
-	writew(val, host->ioaddr + reg);
+	writew(val, host->ioaddr + sdhci_off(reg));
 }
 
-static void sdhci_def_writeb(struct sdhci_host *host, u8 val, int reg)
+static void sdhci_def_writeb(struct sdhci_host *host, u8 val, sdhci_reg_t reg)
 {
-	writeb(val, host->ioaddr + reg);
+	writeb(val, host->ioaddr + sdhci_off(reg));
 }
 
 static void sdhci_reset(struct sdhci_host *host, u8 mask)
@@ -891,12 +891,14 @@ static void sdhci_finish_command(struct sdhci_host *host)
 		if (host->cmd->flags & MMC_RSP_136) {
 			/* CRC is stripped so we need to do some shifting. */
 			for (i = 0;i < 4;i++) {
+				int resp = sdhci_off(SDHCI_RESPONSE);
+
 				host->cmd->resp[i] = sdhci_readl(host,
-					SDHCI_RESPONSE + (3-i)*4) << 8;
+					sdhci_reg(resp + (3-i)*4)) << 8;
 				if (i != 3)
 					host->cmd->resp[i] |=
-						sdhci_readb(host,
-						SDHCI_RESPONSE + (3-i)*4-1);
+						sdhci_readb(host, sdhci_reg(
+							resp + (3-i)*4-1));
 			}
 		} else {
 			host->cmd->resp[0] = sdhci_readl(host, SDHCI_RESPONSE);
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 8e4c4a6..5a5c119 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -12,27 +12,41 @@
 #include <linux/types.h>
 #include <linux/scatterlist.h>
 
+typedef int __bitwise__ sdhci_reg_t;
+
+/* Cast pure integer to register. */
+static inline sdhci_reg_t sdhci_reg(int off)
+{
+	return (sdhci_reg_t __force)off;
+}
+
+/* Cast register to integer (for use with arithmetics). */
+static inline int sdhci_off(sdhci_reg_t reg)
+{
+	return (int __force)reg;
+}
+
 /*
  * Controller registers
  */
 
-#define SDHCI_DMA_ADDRESS	0x00
+#define SDHCI_DMA_ADDRESS	sdhci_reg(0x00)
 
-#define SDHCI_BLOCK_SIZE	0x04
+#define SDHCI_BLOCK_SIZE	sdhci_reg(0x04)
 #define  SDHCI_MAKE_BLKSZ(dma, blksz) (((dma & 0x7) << 12) | (blksz & 0xFFF))
 
-#define SDHCI_BLOCK_COUNT	0x06
+#define SDHCI_BLOCK_COUNT	sdhci_reg(0x06)
 
-#define SDHCI_ARGUMENT		0x08
+#define SDHCI_ARGUMENT		sdhci_reg(0x08)
 
-#define SDHCI_TRANSFER_MODE	0x0C
+#define SDHCI_TRANSFER_MODE	sdhci_reg(0x0C)
 #define  SDHCI_TRNS_DMA		0x01
 #define  SDHCI_TRNS_BLK_CNT_EN	0x02
 #define  SDHCI_TRNS_ACMD12	0x04
 #define  SDHCI_TRNS_READ	0x10
 #define  SDHCI_TRNS_MULTI	0x20
 
-#define SDHCI_COMMAND		0x0E
+#define SDHCI_COMMAND		sdhci_reg(0x0E)
 #define  SDHCI_CMD_RESP_MASK	0x03
 #define  SDHCI_CMD_CRC		0x08
 #define  SDHCI_CMD_INDEX	0x10
@@ -45,11 +59,11 @@
 
 #define SDHCI_MAKE_CMD(c, f) (((c & 0xff) << 8) | (f & 0xff))
 
-#define SDHCI_RESPONSE		0x10
+#define SDHCI_RESPONSE		sdhci_reg(0x10)
 
-#define SDHCI_BUFFER		0x20
+#define SDHCI_BUFFER		sdhci_reg(0x20)
 
-#define SDHCI_PRESENT_STATE	0x24
+#define SDHCI_PRESENT_STATE	sdhci_reg(0x24)
 #define  SDHCI_CMD_INHIBIT	0x00000001
 #define  SDHCI_DATA_INHIBIT	0x00000002
 #define  SDHCI_DOING_WRITE	0x00000100
@@ -59,7 +73,7 @@
 #define  SDHCI_CARD_PRESENT	0x00010000
 #define  SDHCI_WRITE_PROTECT	0x00080000
 
-#define SDHCI_HOST_CONTROL 	0x28
+#define SDHCI_HOST_CONTROL 	sdhci_reg(0x28)
 #define  SDHCI_CTRL_LED		0x01
 #define  SDHCI_CTRL_4BITBUS	0x02
 #define  SDHCI_CTRL_HISPD	0x04
@@ -69,32 +83,32 @@
 #define   SDHCI_CTRL_ADMA32	0x10
 #define   SDHCI_CTRL_ADMA64	0x18
 
-#define SDHCI_POWER_CONTROL	0x29
+#define SDHCI_POWER_CONTROL	sdhci_reg(0x29)
 #define  SDHCI_POWER_ON		0x01
 #define  SDHCI_POWER_180	0x0A
 #define  SDHCI_POWER_300	0x0C
 #define  SDHCI_POWER_330	0x0E
 
-#define SDHCI_BLOCK_GAP_CONTROL	0x2A
+#define SDHCI_BLOCK_GAP_CONTROL	sdhci_reg(0x2A)
 
-#define SDHCI_WAKE_UP_CONTROL	0x2B
+#define SDHCI_WAKE_UP_CONTROL	sdhci_reg(0x2B)
 
-#define SDHCI_CLOCK_CONTROL	0x2C
+#define SDHCI_CLOCK_CONTROL	sdhci_reg(0x2C)
 #define  SDHCI_DIVIDER_SHIFT	8
 #define  SDHCI_CLOCK_CARD_EN	0x0004
 #define  SDHCI_CLOCK_INT_STABLE	0x0002
 #define  SDHCI_CLOCK_INT_EN	0x0001
 
-#define SDHCI_TIMEOUT_CONTROL	0x2E
+#define SDHCI_TIMEOUT_CONTROL	sdhci_reg(0x2E)
 
-#define SDHCI_SOFTWARE_RESET	0x2F
+#define SDHCI_SOFTWARE_RESET	sdhci_reg(0x2F)
 #define  SDHCI_RESET_ALL	0x01
 #define  SDHCI_RESET_CMD	0x02
 #define  SDHCI_RESET_DATA	0x04
 
-#define SDHCI_INT_STATUS	0x30
-#define SDHCI_INT_ENABLE	0x34
-#define SDHCI_SIGNAL_ENABLE	0x38
+#define SDHCI_INT_STATUS	sdhci_reg(0x30)
+#define SDHCI_INT_ENABLE	sdhci_reg(0x34)
+#define SDHCI_SIGNAL_ENABLE	sdhci_reg(0x38)
 #define  SDHCI_INT_RESPONSE	0x00000001
 #define  SDHCI_INT_DATA_END	0x00000002
 #define  SDHCI_INT_DMA_END	0x00000008
@@ -125,11 +139,11 @@
 		SDHCI_INT_DATA_TIMEOUT | SDHCI_INT_DATA_CRC | \
 		SDHCI_INT_DATA_END_BIT)
 
-#define SDHCI_ACMD12_ERR	0x3C
+#define SDHCI_ACMD12_ERR	sdhci_reg(0x3C)
 
 /* 3E-3F reserved */
 
-#define SDHCI_CAPABILITIES	0x40
+#define SDHCI_CAPABILITIES	sdhci_reg(0x40)
 #define  SDHCI_TIMEOUT_CLK_MASK	0x0000003F
 #define  SDHCI_TIMEOUT_CLK_SHIFT 0
 #define  SDHCI_TIMEOUT_CLK_UNIT	0x00000080
@@ -148,24 +162,24 @@
 
 /* 44-47 reserved for more caps */
 
-#define SDHCI_MAX_CURRENT	0x48
+#define SDHCI_MAX_CURRENT	sdhci_reg(0x48)
 
 /* 4C-4F reserved for more max current */
 
-#define SDHCI_SET_ACMD12_ERROR	0x50
-#define SDHCI_SET_INT_ERROR	0x52
+#define SDHCI_SET_ACMD12_ERROR	sdhci_reg(0x50)
+#define SDHCI_SET_INT_ERROR	sdhci_reg(0x52)
 
-#define SDHCI_ADMA_ERROR	0x54
+#define SDHCI_ADMA_ERROR	sdhci_reg(0x54)
 
 /* 55-57 reserved */
 
-#define SDHCI_ADMA_ADDRESS	0x58
+#define SDHCI_ADMA_ADDRESS	sdhci_reg(0x58)
 
 /* 60-FB reserved */
 
-#define SDHCI_SLOT_INT_STATUS	0xFC
+#define SDHCI_SLOT_INT_STATUS	sdhci_reg(0xFC)
 
-#define SDHCI_HOST_VERSION	0xFE
+#define SDHCI_HOST_VERSION	sdhci_reg(0xFE)
 #define  SDHCI_VENDOR_VER_MASK	0xFF00
 #define  SDHCI_VENDOR_VER_SHIFT	8
 #define  SDHCI_SPEC_VER_MASK	0x00FF
@@ -268,54 +282,57 @@ struct sdhci_host {
 	 * We have to duplicate a part of `struct sdhci_ops' since ->ops are
 	 * const, so the sdhci core won't able to assign default ops.
 	 */
-	u32		(*readl)(struct sdhci_host *host, int reg);
-	u16		(*readw)(struct sdhci_host *host, int reg);
-	u8		(*readb)(struct sdhci_host *host, int reg);
-	void		(*writel)(struct sdhci_host *host, u32 val, int reg);
-	void		(*writew)(struct sdhci_host *host, u16 val, int reg);
-	void		(*writeb)(struct sdhci_host *host, u8 val, int reg);
+	u32	(*readl)(struct sdhci_host *host, sdhci_reg_t reg);
+	u16	(*readw)(struct sdhci_host *host, sdhci_reg_t reg);
+	u8	(*readb)(struct sdhci_host *host, sdhci_reg_t reg);
+	void	(*writel)(struct sdhci_host *host, u32 val, sdhci_reg_t reg);
+	void	(*writew)(struct sdhci_host *host, u16 val, sdhci_reg_t reg);
+	void	(*writeb)(struct sdhci_host *host, u8 val, sdhci_reg_t reg);
 
 	unsigned long		private[0] ____cacheline_aligned;
 };
 
 
 struct sdhci_ops {
-	u32		(*readl)(struct sdhci_host *host, int reg);
-	u16		(*readw)(struct sdhci_host *host, int reg);
-	u8		(*readb)(struct sdhci_host *host, int reg);
-	void		(*writel)(struct sdhci_host *host, u32 val, int reg);
-	void		(*writew)(struct sdhci_host *host, u16 val, int reg);
-	void		(*writeb)(struct sdhci_host *host, u8 val, int reg);
-
-	int		(*enable_dma)(struct sdhci_host *host);
+	u32	(*readl)(struct sdhci_host *host, sdhci_reg_t reg);
+	u16	(*readw)(struct sdhci_host *host, sdhci_reg_t reg);
+	u8	(*readb)(struct sdhci_host *host, sdhci_reg_t reg);
+	void	(*writel)(struct sdhci_host *host, u32 val, sdhci_reg_t reg);
+	void	(*writew)(struct sdhci_host *host, u16 val, sdhci_reg_t reg);
+	void	(*writeb)(struct sdhci_host *host, u8 val, sdhci_reg_t reg);
+
+	int	(*enable_dma)(struct sdhci_host *host);
 };
 
-static inline void sdhci_writel(struct sdhci_host *host, u32 val, int reg)
+static inline void sdhci_writel(struct sdhci_host *host, u32 val,
+				sdhci_reg_t reg)
 {
 	host->writel(host, val, reg);
 }
 
-static inline void sdhci_writew(struct sdhci_host *host, u16 val, int reg)
+static inline void sdhci_writew(struct sdhci_host *host, u16 val,
+				sdhci_reg_t reg)
 {
 	host->writew(host, val, reg);
 }
 
-static inline void sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
+static inline void sdhci_writeb(struct sdhci_host *host, u8 val,
+				sdhci_reg_t reg)
 {
 	host->writeb(host, val, reg);
 }
 
-static inline u32 sdhci_readl(struct sdhci_host *host, int reg)
+static inline u32 sdhci_readl(struct sdhci_host *host, sdhci_reg_t reg)
 {
 	return host->readl(host, reg);
 }
 
-static inline u16 sdhci_readw(struct sdhci_host *host, int reg)
+static inline u16 sdhci_readw(struct sdhci_host *host, sdhci_reg_t reg)
 {
 	return host->readw(host, reg);
 }
 
-static inline u8 sdhci_readb(struct sdhci_host *host, int reg)
+static inline u8 sdhci_readb(struct sdhci_host *host, sdhci_reg_t reg)
 {
 	return host->readb(host, reg);
 }
-- 
1.5.6.5

