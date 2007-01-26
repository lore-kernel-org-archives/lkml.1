Return-Path: <linux-kernel-owner+w=401wt.eu-S965712AbXAZQCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965712AbXAZQCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965721AbXAZQCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:02:00 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:57032 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965712AbXAZQB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:01:57 -0500
Date: Fri, 26 Jan 2007 17:01:29 +0100
Message-Id: <200701261601.l0QG1Tqb004474@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: david-b@pacbell.net
CC: hans-peter.nilsson@axis.com, dbrownell@users.sourceforge.net,
       mikael.starvik@axis.com, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <200701251728.12119.david-b@pacbell.net> (message from David
	Brownell on Thu, 25 Jan 2007 17:28:11 -0800)
Subject: [PATCH] take 2: mmc_spi update, 2.6.19
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Brownell <david-b@pacbell.net>
> Date: Thu, 25 Jan 2007 17:28:11 -0800

> On Wednesday 24 January 2007 8:50 pm, Hans-Peter Nilsson wrote:
> > The gotcha is that the SPI framework didn't have a way to
> > express transfers with chip-select inactive.  Sure, you can set
> > chip-select to inactive for a period of *time*, but never while
> > also toggling the clock. 
> 
> Actually it _does_ have a way to handle it, if you think about the
> problem a bit differently ... focus on high/low, not "inactive":

... (Using "spi->mode |= SPI_CS_HIGH" and calling spi_setup)...

I did, but I believed that "setup" should happen only before any
transfer.  Allright, it's documented as callable multiple times
and you define the API anyway :) and it's one less feature to
maintain and worry about to make everyone implement correctly,
so I agree this is better.

> If you agree on this, please update your patch #4 accordingly.

Here we go.  Only the mmc_spi part is updated; the other ones
are identical.  I resend them anyway to keep this message
self-contained.  (Except it uses the previous default_tx_value,
patch, bother. :)

(Previous authors: Mike Lavender, David Brownell, missing explicit signoff)
Signed-off-by: Hans-Peter Nilsson <hp@axis.com>

diff -uprN a/drivers/mmc/Kconfig b/drivers/mmc/Kconfig
--- a/drivers/mmc/Kconfig	2007-01-13 18:59:19.000000000 +0100
+++ b/drivers/mmc/Kconfig	2007-01-14 12:52:17.000000000 +0100
@@ -125,4 +125,15 @@ config MMC_TIFM_SD
           To compile this driver as a module, choose M here: the
 	  module will be called tifm_sd.
 
+config MMC_SPI
+	tristate "MMC/SD over SPI"
+	depends on MMC && SPI && EXPERIMENTAL
+	help
+	  Some systems accss MMC/SD cards using the SPI protocol instead of
+	  using an MMC/SD controller.  The disadvantage of using SPI is that
+	  it's often not as fast; its compensating advantage is that SPI is
+	  available on many systems without MMC/SD controllers.
+
+	  If unsure, or if your system has no SPI controller driver, say N.
+
 endmenu
diff -uprN a/drivers/mmc/Makefile b/drivers/mmc/Makefile
--- a/drivers/mmc/Makefile	2007-01-13 18:59:19.000000000 +0100
+++ b/drivers/mmc/Makefile	2007-01-14 12:54:06.000000000 +0100
@@ -24,6 +24,7 @@ obj-$(CONFIG_MMC_AU1X)		+= au1xmmc.o
 obj-$(CONFIG_MMC_OMAP)		+= omap.o
 obj-$(CONFIG_MMC_AT91RM9200)	+= at91_mci.o
 obj-$(CONFIG_MMC_TIFM_SD)	+= tifm_sd.o
+obj-$(CONFIG_MMC_SPI)		+= mmc_spi.o
 
 mmc_core-y := mmc.o mmc_sysfs.o sdio.o
 mmc_core-$(CONFIG_BLOCK) += mmc_queue.o
--- a/drivers/mmc/mmc_spi.c	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/mmc/mmc_spi.c	2007-01-26 10:07:24.000000000 +0100
@@ -0,0 +1,1500 @@
+/*
+ * mmc_spi.c - Access an SD/MMC card using the SPI bus
+ *
+ * (C) Copyright 2005, Intec Automation,
+ *		 Mike Lavender (mike@steroidmicros)
+ * (C) Copyright 2006, David Brownell
+ * (C) Copyright 2007, Axis Communications,
+ *		 Hans-Peter Nilsson (hp@axis.com)
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/autoconf.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <linux/blkdev.h>
+#include <linux/dma-mapping.h>
+
+#include <linux/mmc/host.h>
+#include <linux/mmc/protocol.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/mmc_spi.h>
+
+
+/* NOTES:
+ *
+ * - For now, we won't try to interoperate with a real mmc/sd/sdio
+ *   controller.  The main reason for such configs would be mmc-format
+ *   cards which (like dataflash) don't support that "other" protocol.
+ *   SPI mode is a bit slower than non-parallel versions of MMC.
+ *
+ * - Likewise we don't try to detect dataflash cards, which would
+ *   imply switching to a different driver.  Not many folk folk use
+ *   both dataflash cards and MMC/SD cards, and Linux doesn't have
+ *   an "MMC/SD interface" abstraction for coupling to drivers.
+ *
+ * - This version gets part way through enumeration of MMC cards.
+ *
+ * - Protocol details, including timings, need to be audited
+ *
+ * - A "use CRCs" option would probably be useful.
+ */
+
+
+/*
+ * Local defines
+ */
+
+// MOVE TO <linux/mmc/protocol.h> ?
+#define SPI_MMC_COMMAND		0x40	/* mask into mmc command */
+
+/* class 0 */
+#define SPI_MMC_READ_OCR	58	/* R3, SPI-only */
+#define SPI_MMC_CRC_ON_OFF	59	/* SPI-only */
+
+/* R1 response status to almost all commands */
+#define SPI_MMC_R1_IDLE			0x01
+#define SPI_MMC_R1_ERASE_RESET		0x02
+#define SPI_MMC_R1_ILLEGAL_COMMAND	0x04
+#define SPI_MMC_R1_COM_CRC		0x08
+#define SPI_MMC_R1_ERASE_SEQ		0x10
+#define SPI_MMC_R1_ADDRESS		0x20
+#define SPI_MMC_R1_PARAMETER		0x40
+
+/* R2 response to CMD13 (SEND_STATUS) is an R1 plus a high byte */
+#define SPI_MMC_R2_CARD_LOCKED		0x01
+#define SPI_MMC_R2_WP_ERASE_SKIP	0x02
+#define SPI_MMC_R2_ERROR		0x04
+#define SPI_MMC_R2_CC_ERROR		0x08
+#define SPI_MMC_R2_CARD_ECC_ERROR	0x10
+#define SPI_MMC_R2_WP_VIOLATION		0x20
+#define SPI_MMC_R2_ERASE_PARAM		0x40
+#define SPI_MMC_R2_OUT_OF_RANGE		0x80
+
+/* response tokens used to ack each block written: */
+#define SPI_MMC_RESPONSE_CODE(x) ((x) & (7 << 1))
+#define SPI_RESPONSE_ACCEPTED	(2 << 1)
+#define SPI_RESPONSE_CRC_ERR	(5 << 1)
+#define SPI_RESPONSE_WRITE_ERR	(6 << 1)
+
+/* read and write blocks start with these tokens and end with crc;
+ * on error, read tokens act like SPI_MMC_R2 values.
+ */
+#define SPI_TOKEN_SINGLE	0xfe	/* single block r/w, multiblock read */
+#define SPI_TOKEN_MULTI_WRITE	0xfc	/* multiblock write */
+#define SPI_TOKEN_STOP_TRAN	0xfd	/* terminate multiblock write */
+// END MOVE
+
+
+#define NO_ARG			0x00000000  // No argument all 0's
+
+#define CRC_GO_IDLE_STATE	0x95
+#define CRC_NO_CRC		0x01
+
+#define	MMC_POWERCYCLE_MSECS	20		/* board-specific? */
+
+
+/* The unit for these timeouts is milliseconds.  See mmc_spi_scanbyte.  */
+#define MINI_TIMEOUT		1
+#define READ_TIMEOUT		100
+#define WRITE_TIMEOUT		250
+
+
+/****************************************************************************/
+
+/*
+ * Local Data Structures
+ */
+
+union mmc_spi_command {
+	u8 buf[7];
+	struct {
+		u8 dummy;
+		u8 code;
+		u8 addr1;
+		u8 addr2;
+		u8 addr3;
+		u8 addr4;
+		u8 crc;
+	} command;
+};
+
+
+struct mmc_spi_host {
+	struct mmc_host		*mmc;
+	struct spi_device	*spi;
+	u8			*rx_buf;
+	u8			*tx_buf;
+	u32			tx_idx;
+	u32			rx_idx;
+	u8			cid_sequence;
+	u8			rsp_type;
+	u8			app_cmd;
+
+	struct mmc_spi_platform_data	*pdata;
+
+	/* for bulk data transfers */
+	struct spi_transfer	token, t, crc;
+	struct spi_message	m;
+	struct spi_transfer	early_status;
+
+	/* for status readback */
+	struct spi_transfer	status;
+	struct spi_message	readback;
+
+	/* underlying controller might support dma, but we can't
+	 * rely on it being used for any particular request
+	 */
+	struct device		*dma_dev;
+	dma_addr_t		dma;		/* of mmc_spi_host */
+
+	/* pre-allocated dma-safe buffers */
+	union mmc_spi_command	command;
+	u8			data_token;
+	u8			status_byte;
+	u16			crc_val;
+	u8			response[2];
+	u8			bundled_status[2];
+
+	/* specs describe always writing ones even if we
+	 * don't think the card should care what it sees.
+	 * (Unused if the spi controller can specify default tx data.)
+	 */
+	u8			ones[];
+#define ONES_BUFFER_SIZE 512
+};
+
+#ifdef	DEBUG
+static unsigned debug = 1;
+module_param(debug, uint, 0644);
+#else
+#define	debug	0
+#endif
+
+/****************************************************************************/
+
+static inline int mmc_spi_readbyte(struct mmc_spi_host *host)
+{
+	int status = spi_sync(host->spi, &host->readback);
+	if (status < 0)
+		return status;
+	return host->status_byte;
+}
+
+static inline int
+mmc_spi_readbytes(struct mmc_spi_host *host, void *bytes, unsigned len)
+{
+	int status;
+
+	host->status.rx_buf = bytes;
+	host->status.len = len;
+
+	host->readback.is_dma_mapped = 0;
+	status = spi_sync(host->spi, &host->readback);
+	host->readback.is_dma_mapped = 1;
+
+	host->status.rx_buf = &host->status_byte;
+	host->status.len = 1;
+	return status;
+}
+
+
+/* REVISIT:  is this fast enough?  these kinds of sync points could easily
+ * be offloaded to irq-ish code called by controller drivers, eliminating
+ * context switch costs.
+ *
+ * REVISIT:  after writes and erases, mmc_spi_busy() == true might be a
+ * fair hint to yield exclusive access to the card (so another driver can
+ * use the bus) and msleep if busy-waiting doesn't succeed quickly.
+ * Measurements on half a dozen cards show however that a simple
+ * implementation doing msleep(1) every 100 busy-iterations (when
+ * busy, increment and test a static variable, reset it after the
+ * msleep) doesn't provide any consistent speedup or increased
+ * user-level system performance (less load).
+ */
+static int mmc_spi_busy(u8 byte)
+{
+	return byte == 0;
+}
+
+static int mmc_spi_delayed(u8 byte)
+{
+	return byte == 0xff;
+}
+
+static int
+mmc_spi_scanbyte(struct mmc_spi_host *host, int (*fail)(u8), unsigned delay)
+{
+	int		value;
+	unsigned	wait;
+
+	/*
+	 * Because we might (we will, for bitbanged SPI) be scheduled
+	 * out for extensive periods in this call, we'd get an
+	 * abundance of timeouts if we counted in jiffies on a system
+	 * with load, so instead we calculate it in the max number of
+	 * bytes we could theoretically scan before the timeout, if
+	 * everything else took zero time.
+	 */
+	unsigned long	end_wait = delay * host->spi->max_speed_hz / 1000 / 8;
+
+	for (wait = 0; wait < end_wait; wait++) {
+		value = mmc_spi_readbyte(host);
+		if (value < 0)
+			return value;
+		if (!fail(value)) {
+			if (debug > 1)
+				dev_dbg(&host->spi->dev,
+					"  mmc_spi: token %02x, wait %d\n",
+					value, wait);
+			return value;
+		}
+	}
+
+	return -ETIMEDOUT;
+}
+
+static inline void mmc_spi_map_r1(struct mmc_command *cmd, u8 r1)
+{
+	u32	mapped = 0;
+
+	/* spi mode doesn't expose the mmc/sd state machine, but
+	 * we can at least avoid lying about the IDLE state
+	 */
+	if (!(r1 & SPI_MMC_R1_IDLE))
+		mapped |= (3 /*standby*/ << 9);
+
+	if (r1 & (SPI_MMC_R1_ERASE_RESET
+			| SPI_MMC_R1_ERASE_SEQ
+			| SPI_MMC_R1_ADDRESS
+			| SPI_MMC_R1_PARAMETER)) {
+		cmd->error = MMC_ERR_FAILED;
+		if (r1 & SPI_MMC_R1_ERASE_RESET)
+			mapped |= R1_ERASE_RESET;
+		if (r1 & SPI_MMC_R1_ERASE_SEQ)
+			mapped |= R1_ERASE_SEQ_ERROR;
+		if (r1 & SPI_MMC_R1_ADDRESS)
+			mapped |= R1_ADDRESS_ERROR;
+		/* this one's a loose match... */
+		if (r1 & SPI_MMC_R1_PARAMETER)
+			mapped |= R1_BLOCK_LEN_ERROR;
+	}
+	if (r1 & SPI_MMC_R1_ILLEGAL_COMMAND) {
+		cmd->error = MMC_ERR_INVALID;
+		mapped |= R1_ILLEGAL_COMMAND;
+	}
+	if (r1 & SPI_MMC_R1_COM_CRC) {
+		cmd->error = MMC_ERR_BADCRC;
+		mapped |= R1_COM_CRC_ERROR;
+	}
+
+	cmd->resp[0] = mapped;
+}
+
+static void mmc_spi_map_r2(struct mmc_command *cmd, u8 r2)
+{
+	u32	mapped = 0;
+
+	if (!r2)
+		return;
+
+	if (r2 & SPI_MMC_R2_CARD_LOCKED)
+		mapped |= R1_CARD_IS_LOCKED;
+	if (r2 & SPI_MMC_R2_WP_ERASE_SKIP)
+		mapped |= R1_WP_ERASE_SKIP;
+	if (r2 & SPI_MMC_R2_ERROR)
+		mapped |= R1_ERROR;
+	if (r2 & SPI_MMC_R2_CC_ERROR)
+		mapped |= R1_CC_ERROR;
+	if (r2 & SPI_MMC_R2_CARD_ECC_ERROR)
+		mapped |= R1_CARD_ECC_FAILED;
+	if (r2 & SPI_MMC_R2_WP_VIOLATION)
+		mapped |= R1_WP_VIOLATION;
+	if (r2 & SPI_MMC_R2_ERASE_PARAM)
+		mapped |= R1_ERASE_PARAM;
+	if (r2 & SPI_MMC_R2_OUT_OF_RANGE)
+		mapped |= R1_OUT_OF_RANGE | R1_CID_CSD_OVERWRITE;
+
+	if (mapped) {
+		cmd->resp[0] |= mapped;
+		if (cmd->error == MMC_ERR_NONE)
+			cmd->error = MMC_ERR_FAILED;
+	}
+}
+
+#ifdef	DEBUG
+static char *maptype(u8 type)
+{
+	switch (type) {
+	case MMC_RSP_R1:	return "R1";
+	case MMC_RSP_R1B:	return "R1B";
+	case MMC_RSP_R2:	return "R2";
+	case MMC_RSP_R3:	return "R3";
+	case MMC_RSP_NONE:	return "NONE";
+	default:		return "?";
+	}
+}
+#endif
+
+static void
+mmc_spi_response_get(struct mmc_spi_host *host, struct mmc_command *cmd)
+{
+	int value;
+
+	dev_dbg(&host->spi->dev,
+		"%sCMD%d response SPI_%s: ",
+		host->app_cmd ? "A" : "",
+		cmd->opcode, maptype(host->rsp_type));
+
+	if (cmd->opcode == MMC_STOP_TRANSMISSION) {
+		/*
+		 * We can't tell whether we read block data or the
+		 * command reply, so to cope with trash data during
+		 * the latency, we just read in 14 bytes (8 would be
+		 * enough according to the MMC spec; SD doesn't say)
+		 * after the command and fake a clean reply.  We could
+		 * avoid this if we saved what the card sent us while
+		 * we sent the command, and treat it like a normal
+		 * response if we didn't get a SPI_TOKEN_SINGLE.
+		 */
+		(void) mmc_spi_readbytes(host, host->command.buf,
+					 sizeof host->command.buf);
+		(void) mmc_spi_readbytes(host, host->command.buf,
+					 sizeof host->command.buf);
+		value = 0;
+	} else
+		value = mmc_spi_scanbyte(host, mmc_spi_delayed, MINI_TIMEOUT);
+	host->response[0] = value;
+	host->response[1] = 0;
+
+	if (value < 0) {
+		dev_dbg(&host->spi->dev,
+			"mmc_spi: response error, %d\n", value);
+		cmd->error = MMC_ERR_FAILED;
+		return;
+	}
+
+	if (host->response[0] & 0x80) {
+		dev_err(&host->spi->dev, "INVALID RESPONSE, %02x\n",
+					host->response[0]);
+		cmd->error = MMC_ERR_FAILED;
+		return;
+	}
+
+	cmd->error = MMC_ERR_NONE;
+	mmc_spi_map_r1(cmd, host->response[0]);
+
+	switch (host->rsp_type) {
+
+	/* SPI R1 and R1B are a subset of the MMC/SD R1 */
+	case MMC_RSP_R1B:
+		/* wait for not-busy (could be deferred...) */
+		// REVISIT:  could be a (shorter) read timeout
+		// ... and the timeouts derived from chip parameters
+		// will likely be nicer/shorter
+		(void) mmc_spi_scanbyte(host, mmc_spi_busy, WRITE_TIMEOUT);
+		/* FALLTHROUGH */
+	case MMC_RSP_R1:
+		/* no more */
+		break;
+
+	/* SPI R2 is bigger subset of the MMC/SD R1; unrelated to MMC/SD R2 */
+	case MMC_RSP_R2:
+		/* read second status byte */
+		host->response[1] = mmc_spi_readbyte(host);
+		mmc_spi_map_r2(cmd, host->response[1]);
+		break;
+
+	/* SPI R3 is SPI R1 plus OCR */
+	case MMC_RSP_R3:
+		/* NOTE: many controllers can't support 32 bit words,
+		 * which is why we use byteswapping here instead.
+		 */
+		(void) mmc_spi_readbytes(host, &cmd->resp[0], 4);
+		be32_to_cpus(&cmd->resp[0]);
+		be32_to_cpus(&cmd->resp[1]);
+		be32_to_cpus(&cmd->resp[2]);
+		be32_to_cpus(&cmd->resp[3]);
+		break;
+
+	default:
+		dev_dbg(&host->spi->dev,
+			"unknown rsp_type\n");
+	}
+
+	if (host->response[0] || host->response[1])
+		dev_dbg(&host->spi->dev,
+			"  mmc_spi: resp %02x.%02x\n",
+			host->response[1],
+			host->response[0]);
+
+	/* The SPI binding to MMC/SD cards uses different conventions
+	 * than the other one.  Unless/until the mmc core learns about
+	 * SPI rules, we must handle it here...
+	 */
+	switch (mmc_resp_type(cmd)) {
+	case MMC_RSP_R1:
+	case MMC_RSP_R1B:
+		switch (host->rsp_type) {
+		case MMC_RSP_R1B:
+		case MMC_RSP_R1:
+		case MMC_RSP_R2:
+			/* spi doesn't explicitly expose this bit */
+			if (cmd->error == MMC_ERR_NONE
+					&& cmd->opcode == MMC_APP_CMD)
+				cmd->resp[0] |= R1_APP_CMD;
+			break;
+		default:
+badmap:
+			dev_dbg(&host->spi->dev,
+				"mmc_spi: no map SPI_%s --> MMC_%s/%02x\n",
+				maptype(host->rsp_type),
+				maptype(mmc_resp_type(cmd)),
+				mmc_resp_type(cmd));
+			if (cmd->error == MMC_ERR_NONE)
+				cmd->error = MMC_ERR_FAILED;
+		}
+		break;
+	case MMC_RSP_R2:
+		switch (cmd->opcode) {
+		case MMC_SEND_CID:
+		case MMC_SEND_CSD:
+			/* we special case these by waiting for the
+			 * data stage (with CID/CSD)
+			 */
+			break;
+		default:
+			goto badmap;
+		}
+		break;
+	case MMC_RSP_R3:
+		/* for some cases, OCR is patched up later */
+		if (host->rsp_type != MMC_RSP_R3
+				&& cmd->error == MMC_ERR_NONE
+				&& !( (cmd->opcode == MMC_SEND_OP_COND
+					&& !host->app_cmd)
+				   || (cmd->opcode == SD_APP_OP_COND
+					&& host->app_cmd))
+				) {
+			dev_dbg(&host->spi->dev,
+				"** MMC_R3 mismatch to SPI_%s\n",
+				maptype(host->rsp_type));
+			cmd->error = MMC_ERR_FAILED;
+		}
+		break;
+	case MMC_RSP_NONE:
+		if (cmd->opcode == MMC_GO_IDLE_STATE) {
+			if (!(host->response[0] & SPI_MMC_R1_IDLE)
+					&& cmd->error == MMC_ERR_NONE) {
+				/* maybe it finished initialization early */
+				dev_dbg(&host->spi->dev, "  ?? not idle ??\n");
+			}
+		} else
+			goto badmap;
+	}
+}
+
+/* SPI response types aren't always good matches for "native" ones */
+
+/* REVISIT probably should have SPI_RSP_R1 etc */
+
+static const u8 resp_map[64] = {
+	[ 0] = MMC_RSP_R1,
+	[ 1] = MMC_RSP_R1,
+	[ 6] = MMC_RSP_R1,
+	[ 9] = MMC_RSP_R1,
+
+	[10] = MMC_RSP_R1,
+	[12] = MMC_RSP_R1B,
+	[13] = MMC_RSP_R2,
+	[16] = MMC_RSP_R1,
+	[17] = MMC_RSP_R1,
+	[18] = MMC_RSP_R1,
+
+	[24] = MMC_RSP_R1,
+	[25] = MMC_RSP_R1,
+	[27] = MMC_RSP_R1,
+	[28] = MMC_RSP_R1B,
+	[29] = MMC_RSP_R1B,
+
+	[30] = MMC_RSP_R1,
+	[32] = MMC_RSP_R1,
+	[33] = MMC_RSP_R1,
+	[34] = MMC_RSP_R1,
+	[35] = MMC_RSP_R1,
+	[36] = MMC_RSP_R1,
+	[37] = MMC_RSP_R1,
+	[38] = MMC_RSP_R1B,
+
+	[42] = MMC_RSP_R1B,
+
+	[55] = MMC_RSP_R1,
+	[56] = MMC_RSP_R1,
+	[58] = MMC_RSP_R3,	/* SPI-only command */
+	[59] = MMC_RSP_R1,	/* SPI-only command */
+};
+
+static const u8 acmd_map[64] = {
+	[13] = MMC_RSP_R2,
+
+	[22] = MMC_RSP_R1,
+	[23] = MMC_RSP_R1,
+
+	[41] = MMC_RSP_R1,
+	[42] = MMC_RSP_R1,
+
+	[51] = MMC_RSP_R1,
+};
+
+
+/* Issue command and read its response.
+ * Returns zero on success, negative for error.
+ *
+ * On error, caller must cope with mmc core retry mechanism.  That
+ * means immediate low-level resubmit, which affects the bus lock...
+ */
+static int
+mmc_spi_command_send(struct mmc_spi_host *host,
+		     struct mmc_request *mrq, u32 crc,
+		     struct mmc_command *cmd)
+{
+	union mmc_spi_command	*tx = &host->command;
+	u32			arg = cmd->arg;
+	int			status;
+	unsigned		opcode;
+	unsigned		opcond_retries = 25;
+
+again:
+	opcode = cmd->opcode;
+	if (host->app_cmd)
+		host->rsp_type = acmd_map[opcode & 0x3f];
+	else
+		host->rsp_type = resp_map[opcode & 0x3f];
+
+	if (host->rsp_type == MMC_RSP_NONE) {
+		dev_dbg(&host->spi->dev,
+			"  mmc_spi: INVALID %sCMD%d (%02x)\n",
+			host->app_cmd ? "A" : "",
+			opcode, opcode);
+		cmd->error = MMC_ERR_INVALID;
+		cmd->resp[0] = R1_ILLEGAL_COMMAND;
+		return -EBADR;
+	}
+
+	/* after 8 clock cycles the card is ready, and done previous cmd */
+	tx->command.dummy = 0xFF;
+
+	tx->command.code = opcode | SPI_MMC_COMMAND;
+	tx->command.addr1 = (arg & 0xFF000000) >> 24;
+	tx->command.addr2 = (arg & 0x00FF0000) >> 16;
+	tx->command.addr3 = (arg & 0x0000FF00) >> 8;
+	tx->command.addr4 = (arg & 0x000000FF);
+	tx->command.crc = crc & 0x000000FF;
+
+	dev_dbg(&host->spi->dev, "  mmc_spi: %scmd%d (%02x)\n",
+		host->app_cmd ? "a" : "", opcode, opcode);
+	status = spi_write(host->spi, tx->buf, sizeof(tx->buf));
+	if (status < 0) {
+		dev_dbg(&host->spi->dev, "  ... write returned %d\n", status);
+		cmd->error = MMC_ERR_FAILED;
+		return -EBADR;
+	}
+
+	mmc_spi_response_get(host, cmd);
+	if (cmd->error != MMC_ERR_NONE)
+		return -EBADR;
+
+	switch (opcode) {
+	case MMC_SEND_CID:
+	case MMC_SEND_CSD:
+		if (host->app_cmd)
+			goto done;
+		/* we report success later, after making it look like
+		 * there was no data stage (just a big status stage)
+		 */
+		break;
+	case SD_APP_OP_COND:
+		if (!host->app_cmd)
+			goto done;
+		/* retry MMC's OP_COND; it does the same thing, and it's
+		 * simpler to not send MMC_APP_COND then SD_APP_OP_COND
+		 */
+		host->app_cmd = 0;
+		cmd->opcode = MMC_SEND_OP_COND;
+		/* FALLTHROUGH */
+	case MMC_SEND_OP_COND:
+		if (host->app_cmd)
+			goto done;
+		/* without retries, the OCR we read is garbage */
+		if (host->status_byte & 0x01) {
+			if (opcond_retries == 0) {
+				dev_err(&host->spi->dev, "init failed\n");
+				goto done;
+			}
+			dev_dbg(&host->spi->dev,
+				"  retry for init complete...\n");
+			msleep(50);
+			opcond_retries--;
+			goto again;
+		}
+		dev_dbg(&host->spi->dev, "  patchup R3/OCR ...\n");
+		cmd->opcode = SPI_MMC_READ_OCR;
+		goto again;
+	default:
+done:
+		/*
+		 * If this was part of a request that has a stop-part,
+		 * don't signal the request as done; the caller will
+		 * do that.  Just return successfully.
+		 */
+		if (mrq->stop != NULL)
+			return 0;
+		mmc_request_done(host->mmc, mrq);
+	}
+	return 0;
+}
+
+/* Set up data message: first byte, data block (filled in later), then CRC. */
+static void
+mmc_spi_setup_message(
+	struct mmc_spi_host	*host,
+	int			multiple,
+	enum dma_data_direction	direction)
+{
+	struct device		*dma_dev = host->dma_dev;
+	struct spi_transfer	*t;
+
+	spi_message_init(&host->m);
+	if (dma_dev)
+		host->m.is_dma_mapped = 1;
+
+	/* for reads, we (manually) skip 0xff bytes before finding
+	 * the token; for writes, we issue it ourselves.
+	 */
+	if (direction == DMA_TO_DEVICE) {
+		t = &host->token;
+		memset(t, 0, sizeof *t);
+		t->len = 1;
+		if (multiple)
+			host->data_token = SPI_TOKEN_MULTI_WRITE;
+		else
+			host->data_token = SPI_TOKEN_SINGLE;
+		t->tx_buf = &host->data_token;
+		spi_message_add_tail(t, &host->m);
+	}
+
+	t = &host->t;
+	memset(t, 0, sizeof *t);
+	spi_message_add_tail(t, &host->m);
+
+	t = &host->crc;
+	memset(t, 0, sizeof *t);
+	t->len = 2;
+	spi_message_add_tail(t, &host->m);
+
+	t = &host->early_status;
+	memset(t, 0, sizeof *t);
+
+	/*
+	 * If this is a read, we need room for 0xFF (for
+	 * N\subscript{AC}) and the next token.  For a write, we need
+	 * room just for the one-byte data response.
+	 */
+	t->len = (direction == DMA_FROM_DEVICE) ? 2 : 1;
+	spi_message_add_tail(t, &host->m);
+	t->rx_buf = host->bundled_status;
+	if (dma_dev)
+		t->rx_dma = host->dma
+			+ offsetof(struct mmc_spi_host, bundled_status);
+	if (host->spi->default_tx_word == 0) {
+		t->tx_buf = &host->ones;
+		if (dma_dev)
+			t->tx_dma = host->dma
+				+ offsetof(struct mmc_spi_host, ones);
+	}
+
+	t = &host->crc;
+
+	/* REVISIT crc wordsize == 2, avoid byteswap issues ... */
+
+	if (direction == DMA_TO_DEVICE) {
+		host->crc_val = CRC_NO_CRC;
+		t->tx_buf = &host->crc_val;
+		if (dma_dev) {
+			host->token.tx_dma = host->dma
+				+ offsetof(struct mmc_spi_host, data_token);
+			t->tx_dma = host->dma
+				+ offsetof(struct mmc_spi_host, crc_val);
+		}
+	} else {
+		t->rx_buf = &host->crc_val;
+		if (dma_dev)
+			t->rx_dma = host->dma
+				+ offsetof(struct mmc_spi_host, crc_val);
+
+		/* while we read data, write all-ones */
+		if (host->spi->default_tx_word == 0) {
+			t->tx_buf = host->t.tx_buf = &host->ones;
+			if (dma_dev)
+				t->tx_dma = host->t.tx_dma = host->dma
+					+ offsetof(struct mmc_spi_host, ones);
+		}
+	}
+}
+
+
+static inline int resp2status(u8 write_resp)
+{
+	switch (SPI_MMC_RESPONSE_CODE(write_resp)) {
+	case SPI_RESPONSE_ACCEPTED:
+		return 0;
+	case SPI_RESPONSE_CRC_ERR:
+	case SPI_RESPONSE_WRITE_ERR:
+		/* host shall then issue MMC_STOP_TRANSMISSION */
+		return -EIO;
+	default:
+		return -EILSEQ;
+	}
+}
+
+
+static void
+mmc_spi_data_do(struct mmc_spi_host *host, struct mmc_command *cmd,
+		struct mmc_data *data, u32 blk_size)
+{
+	struct spi_device	*spi = host->spi;
+	struct device		*dma_dev = host->dma_dev;
+	struct spi_transfer	*t;
+	enum dma_data_direction	direction;
+	struct scatterlist	*sg;
+	unsigned		n_sg;
+	int			multiple;
+
+	if (data->flags & MMC_DATA_READ) {
+		direction = DMA_FROM_DEVICE;
+		multiple = (cmd->opcode == MMC_READ_MULTIPLE_BLOCK);
+
+		/*
+		 * We need to scan for the SPI_TOKEN_SINGLE token
+		 * *before* we issue the first (of multiple)
+		 * spi_messages reading the data plus two extra bytes,
+		 * (implying N\subscript{AC} and the *next* token), so
+		 * to avoid looking at garbage from an earlier
+		 * command, we reset the location where we'll read in
+		 * subsequent tokens.
+		 */
+		host->bundled_status[0] = 0xff;
+		host->bundled_status[1] = 0xff;
+	} else {
+		direction = DMA_TO_DEVICE;
+		multiple = (cmd->opcode == MMC_WRITE_MULTIPLE_BLOCK);
+	}
+	mmc_spi_setup_message(host, multiple, direction);
+	t = &host->t;
+
+	/* Handle scatterlist segments one at a time, with synch for
+	 * each 512-byte block
+	 */
+	for (sg = data->sg, n_sg = data->sg_len; n_sg; n_sg--, sg++) {
+		int			status = 0;
+		dma_addr_t		dma_addr = 0;
+		void			*kmap_addr;
+		unsigned		length = sg->length;
+
+		/* set up dma mapping for controller drivers that might
+		 * use DMA ... though they may fall back to PIO
+		 */
+		if (dma_dev) {
+			dma_addr = dma_map_page(dma_dev, sg->page, 0,
+						PAGE_SIZE, direction);
+			if (direction == DMA_TO_DEVICE)
+				t->tx_dma = dma_addr + sg->offset;
+			else
+				t->rx_dma = dma_addr + sg->offset;
+			dma_sync_single_for_device(host->dma_dev,
+				host->dma, sizeof *host, direction);
+		}
+
+		/* allow pio too, with kmap handling any highmem */
+		kmap_addr = kmap_atomic(sg->page, 0);
+		if (direction == DMA_TO_DEVICE)
+			t->tx_buf = kmap_addr + sg->offset;
+		else
+			t->rx_buf = kmap_addr + sg->offset;
+
+		/* transfer each block, and update request status */
+		while (length && status == 0) {
+			t->len = min(length, blk_size);
+
+			dev_dbg(&host->spi->dev,
+				"    mmc_spi: %s block, %d bytes\n",
+				(direction == DMA_TO_DEVICE)
+				? "write"
+				: "read",
+				t->len);
+
+			if (direction == DMA_TO_DEVICE) {
+				int	response;
+
+				/* REVISIT once we start using TX crc, first
+				 * compute that value then dma_sync
+				 */
+
+				status = spi_sync(spi, &host->m);
+				if (status != 0) {
+					dev_err(&spi->dev,
+						"write error (%d)\n", status);
+					break;
+				}
+
+				/*
+				 * Get the transmission data-response
+				 * reply.  It must follow immediately
+				 * after the data block we
+				 * transferred.  This reply doesn't
+				 * necessarily tell whether the write
+				 * operation succeeded, it just tells
+				 * that the transmission was ok and
+				 * whether *earlier* writes succeeded;
+				 * see the standard.
+				 */
+				response = host->bundled_status[0];
+				if (response == 0xff) {
+					dev_err(&spi->dev,
+						"missing card response\n");
+					status = -EIO;
+					break;
+				}
+
+				if (response < 0)
+					status = response;
+				else
+					status = resp2status(response);
+				if (status != 0) {
+					dev_err(&spi->dev,
+						"write error %02x (%d)\n",
+						response, status);
+					break;
+				}
+				t->tx_buf += t->len;
+				if (dma_dev)
+					t->tx_dma += t->len;
+
+				/* Wait until not busy.  */
+				response = mmc_spi_scanbyte(host, mmc_spi_busy,
+							WRITE_TIMEOUT);
+			} else {
+				/*
+				 * Note that N\subscript{AC} is *at
+				 * least* one byte, so we should never
+				 * see a card that responds in the
+				 * first byte (otherwise defined to be
+				 * 0xff).  Right, better assert that...
+				 */
+				if (host->bundled_status[0] != 0xff) {
+					/* We either make it an error or
+					 * somehow wedge in the next byte,
+					 * because that's then the first
+					 * in the block we read.  */
+					dev_err(&spi->dev,
+						"too-early card "
+						"response %02x %02x\n",
+						host->bundled_status[0],
+						host->bundled_status[1]);
+					status = -EIO;
+					break;
+				}
+
+				if (host->bundled_status[1] != 0xff)
+					status = host->bundled_status[1];
+				else
+					status = mmc_spi_scanbyte(host, mmc_spi_delayed,
+								  READ_TIMEOUT);
+
+				if (status == SPI_TOKEN_SINGLE) {
+					status = spi_sync(spi, &host->m);
+					dma_sync_single_for_cpu(host->dma_dev,
+						host->dma, sizeof *host,
+						direction);
+				} else {
+					/* we've read extra garbage */
+					dev_err(&spi->dev,
+						"read error %02x\n",
+						status);
+					cmd->resp[0] = 0;
+					mmc_spi_map_r2(cmd, status);
+					if (cmd->error == MMC_ERR_NONE)
+						cmd->error = MMC_ERR_FAILED;
+					break;
+				}
+
+				/* REVISIT eventually, check crc */
+				t->rx_buf += t->len;
+				if (dma_dev)
+					t->rx_dma += t->len;
+			}
+
+			data->bytes_xfered += t->len;
+			if (status == 0) {
+				status = host->m.status;
+				length -= t->len;
+			}
+
+			if (!multiple)
+				break;
+		}
+
+		/* discard mappings */
+		kunmap_atomic(addr, 0);
+		if (direction == DMA_FROM_DEVICE)
+			flush_kernel_dcache_page(sg->page);
+		if (dma_dev)
+			dma_unmap_page(dma_dev, dma_addr,
+					PAGE_SIZE, direction);
+
+		if (status < 0) {
+			dev_dbg(&spi->dev, "%s status %d\n",
+				(direction == DMA_TO_DEVICE)
+					? "write" : "read",
+				status);
+			if (cmd->error == MMC_ERR_NONE)
+				cmd->error = MMC_ERR_FAILED;
+			break;
+		}
+	}
+
+	if (direction == DMA_TO_DEVICE && multiple) {
+		/*
+		 * Send the SPI_TOKEN_STOP_TRAN byte, ignoring the
+		 * received byte (presumably 0xff).
+		 */
+		u8 dat = SPI_TOKEN_STOP_TRAN;
+		ssize_t status = spi_write(spi, &dat, 1);
+
+		if (status < 0) {
+			cmd->error = MMC_ERR_FAILED;
+			return;
+		}
+
+		/*
+		 * Then skip the next byte.  This is the maximum
+		 * non-busy time before the first busy-token.  If we
+		 * don't skip it, we'll mistake it for the end of the
+		 * busy-period.  See also "Figure 5-28" in SanDisk's
+		 * ProdManRS-MMCv1.3.pdf; this is marked "X"
+		 * (undefined value) of length N\subscript{BR} (min 0
+		 * max 1 byte).
+		 */
+		status = mmc_spi_readbyte(host);
+		if (status < 0) {
+			cmd->error = MMC_ERR_FAILED;
+			return;
+		}
+
+		/*
+		 * Now wait until the end of the busy period.  If
+		 * N\subscript{BR} (see ref above) was 0, we'll never
+		 * see any busy period.  FIXME: defer the wait to next
+		 * command; sleep.
+		 */
+		status = mmc_spi_scanbyte(host, mmc_spi_busy, WRITE_TIMEOUT);
+		if (status < 0) {
+			cmd->error = MMC_ERR_FAILED;
+			return;
+		}
+	}
+}
+
+static int
+mmc_spi_command_do(struct mmc_spi_host *host, struct mmc_request *mrq)
+{
+	int status;
+
+	status = mmc_spi_command_send(host, mrq, CRC_NO_CRC, mrq->cmd);
+
+	if (status == 0 && mrq->data)
+		mmc_spi_data_do(host, mrq->cmd, mrq->data,
+				mrq->data->blksz);
+	if (mrq->stop) {
+		if (status == 0) {
+			status = mmc_spi_command_send(host, mrq, CRC_NO_CRC,
+						      mrq->stop);
+			if (status != 0)
+				mrq->stop->error = MMC_ERR_FAILED;
+			mmc_request_done(host->mmc, mrq);
+		}
+	}
+
+	return status;
+}
+
+static int
+mmc_spi_send_cXd(struct mmc_spi_host *host, struct mmc_request *mrq)
+{
+	int	status;
+	u32	*resp = mrq->cmd->resp;
+
+	mrq->cmd->arg = NO_ARG;
+	status = mmc_spi_command_send(host, mrq, CRC_NO_CRC, mrq->cmd);
+	if (status < 0)
+		return status;
+
+	/* response_get() saw an SPI R1 response, but command_send()
+	 * knew we'd patch the expected MMC/SD "R2" style status here.
+	 */
+	mmc_spi_setup_message(host, 0, DMA_FROM_DEVICE);
+	host->m.is_dma_mapped = 0;
+	host->t.rx_buf = resp;
+	host->t.len = 16;
+
+	status = mmc_spi_scanbyte(host, mmc_spi_delayed, READ_TIMEOUT);
+
+	if (status == SPI_TOKEN_SINGLE) {
+		/* NOTE: many controllers can't support 32 bit words,
+		 * which is why we use byteswapping here instead.
+		 */
+		status = spi_sync(host->spi, &host->m);
+		if (status < 0)
+			mrq->cmd->error = MMC_ERR_FAILED;
+		else {
+			be32_to_cpus(&resp[0]);
+			be32_to_cpus(&resp[1]);
+			be32_to_cpus(&resp[2]);
+			be32_to_cpus(&resp[3]);
+		}
+	} else {
+		if (status >= 0) {
+			dev_dbg(&host->spi->dev,
+				"mmc_spi: read cXd err %02x\n",
+				status);
+			mmc_spi_map_r2(mrq->cmd, status);
+			status = -ETIMEDOUT;
+		}
+		mrq->cmd->error = MMC_ERR_TIMEOUT;
+	}
+	if (status == 0)
+		mmc_request_done(host->mmc, mrq);
+	else
+		dev_dbg(&host->spi->dev,
+			"mmc_spi: read cXd, %d \n", status);
+	return status;
+}
+
+/* reset ... with cmd->opcode == MMC_GO_IDLE_STATE */
+static int
+mmc_spi_initialize(struct mmc_spi_host *host, struct mmc_request *mrq)
+{
+	struct mmc_command	*cmd = mrq->cmd;
+	int			status;
+	int			could_invert_cs = 0;
+
+	host->cid_sequence = 0;
+
+	/* REVISIT put a powercycle reset here?  */
+
+	/* try to be very sure any previous command has completed;
+	 * wait till not-busy, skip debris from any old commands,
+	 */
+	(void) mmc_spi_scanbyte(host, mmc_spi_busy, WRITE_TIMEOUT);
+	(void) mmc_spi_readbytes(host, host->command.buf,
+				 sizeof host->command.buf);
+
+	/*
+	 * Do a burst with chipselect deactivated.  We need to do this
+	 * to meet the requirement of 74 clock cycles with chipselect
+	 * high before CMD0.  (Section 6.4.1, in "Simplified Physical
+	 * Layer Specification 2.0".)  Some cards are particularly
+	 * needy of this (e.g. Viking "SD256") while most others don't
+	 * seem to care.  Note that it's not enough to deactivate
+	 * chipselect without toggling the clock.  Beware of the hack:
+	 * we "know" that mmc_spi_readbytes uses the host->status
+	 * spi_transfer.
+	 */
+	host->spi->mode |= SPI_CS_HIGH;
+	if (spi_setup(host->spi) != 0)
+		/* Just a brief warning; most cards work without it.  */
+		dev_warn(&host->spi->dev,
+			 "can't invert the active chip-select level\n");
+	else
+		could_invert_cs = 1;
+
+	(void) mmc_spi_readbytes(host, host->command.buf,
+				 sizeof host->command.buf);
+	(void) mmc_spi_readbytes(host, host->command.buf,
+				 sizeof host->command.buf);
+
+	host->spi->mode &= ~SPI_CS_HIGH;
+	if (spi_setup(host->spi) != 0) {
+		/* Wot, we can't get (back) the same setup we had before?  */
+		dev_err(&host->spi->dev,
+			 "failed inverting the active chip-select level\n");
+		return -EIO;
+	}
+
+	/* issue software reset */
+	cmd->arg = 0;
+	status = mmc_spi_command_send(host, mrq, CRC_GO_IDLE_STATE, cmd);
+	if (status < 0) {
+		/* maybe:
+		 *  - there's no card present
+		 *  - the card isn't seated correctly (bad contacts)
+		 *  - it didn't leave MMC/SD mode
+		 *  - there's other confusion in the card state
+		 *
+		 * power cycling the card ought to help a lot.
+		 * At any rate, let's try again.
+		 */
+		status = mmc_spi_command_send(host, mrq, CRC_GO_IDLE_STATE,
+					      cmd);
+		if (status < 0)
+			dev_err(&host->spi->dev,
+				"can't initialize the card: no card%s?\n",
+				!could_invert_cs
+				? (" or because the active chip-select"
+				   " level can't be inverted") : "");
+	}
+	return status;
+}
+
+/****************************************************************************/
+
+/*
+ * MMC Implementation
+ */
+
+static void mmc_spi_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	struct mmc_spi_host	*host = mmc_priv(mmc);
+	int			status = 0;
+	u8			opcode = mrq->cmd->opcode;
+
+	/*
+	 * Translation between MMC/SD protocol commands and SPI ones
+	 */
+	if (!host->app_cmd) {
+		switch (opcode) {
+		case MMC_GO_IDLE_STATE:
+			status = mmc_spi_initialize(host, mrq);
+			break;
+		case MMC_APP_CMD:
+			status = mmc_spi_command_do(host, mrq);
+			if (status == 0) {
+				host->app_cmd = 1;
+				mrq->cmd->resp[0] |= R1_APP_CMD;
+			}
+			break;
+		case MMC_ALL_SEND_CID:
+			/* fake a one-node broadcast */
+			if (host->cid_sequence) {
+				mrq->cmd->retries = 0;
+				mrq->cmd->error = MMC_ERR_TIMEOUT;
+				host->cid_sequence = 0;
+				status = -ETIMEDOUT;
+			} else {
+				mrq->cmd->opcode = MMC_SEND_CID;
+				status = mmc_spi_send_cXd(host, mrq);
+				host->cid_sequence++;
+			}
+			break;
+		case MMC_SEND_CID:
+		case MMC_SEND_CSD:
+			status = mmc_spi_send_cXd(host, mrq);
+			break;
+
+		/* No honest translation for these in SPI mode :(
+		 * ... mmc core shouldn't issue them, then!!
+		 */
+		case MMC_SET_RELATIVE_ADDR:
+		case MMC_SET_DSR:
+		case MMC_SELECT_CARD:
+		case MMC_READ_DAT_UNTIL_STOP:
+		case MMC_GO_INACTIVE_STATE:
+		case MMC_SET_BLOCK_COUNT:
+		case MMC_PROGRAM_CID:
+			mmc_request_done(host->mmc, mrq);
+			break;
+
+		case MMC_SEND_STATUS:
+			/*
+			 * This command must be allowed to fail, else we
+			 * won't notice card changes (de/insertion).
+			 */
+			status = mmc_spi_command_do(host, mrq);
+
+			if (status == 0) {
+				mrq->cmd->resp[0] |= R1_READY_FOR_DATA;
+				/*
+				 * The mmc_spi_map_r2 function in the
+				 * mmc_spi_command_do call helpfully filled in the
+				 * "failed" status, but we're just the messenger.
+				 * We have no way to show that *this* command
+				 * actually failed.
+				 */
+				mrq->cmd->error = MMC_ERR_NONE;
+			}
+			break;
+
+		default:
+			status = mmc_spi_command_do(host, mrq);
+		}
+	} else {
+		status = mmc_spi_command_do(host, mrq);
+		host->app_cmd = 0;
+	}
+
+	/*
+	 * No need to wait before the next command.  The minimum time
+	 * between commands is handled by the "dummy" byte in the command.
+	 */
+
+	/*
+	 * If status was ok, the request would have been signalled done by
+	 * mmc_spi_command_do.
+	 */
+	if (status < 0)
+		mmc_request_done(host->mmc, mrq);
+}
+
+
+static void mmc_spi_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct mmc_spi_host *host = mmc_priv(mmc);
+
+	if (host->pdata && host->pdata->setpower) {
+		dev_dbg(&host->spi->dev,
+			"mmc_spi:  power %08x\n", ios->vdd);
+		host->pdata->setpower(&host->spi->dev, ios->vdd);
+		msleep(MMC_POWERCYCLE_MSECS);
+	}
+
+	if (host->spi->max_speed_hz != ios->clock && ios->clock != 0) {
+		int		status;
+
+		host->spi->max_speed_hz = ios->clock;
+		status = spi_setup(host->spi);
+		dev_dbg(&host->spi->dev,
+			"mmc_spi:  clock to %d Hz, %d\n",
+			host->spi->max_speed_hz, status);
+	}
+}
+
+static int mmc_spi_get_ro(struct mmc_host *mmc)
+{
+	struct mmc_spi_host *host = mmc_priv(mmc);
+
+	if (host->pdata && host->pdata->get_ro)
+		return host->pdata->get_ro(mmc->dev);
+	/* board doesn't support read only detection; assume writeable */
+	return 0;
+}
+
+
+static struct mmc_host_ops mmc_spi_ops = {
+	.request	= mmc_spi_request,
+	.set_ios	= mmc_spi_set_ios,
+	.get_ro		= mmc_spi_get_ro,
+};
+
+
+/****************************************************************************/
+
+/*
+ * Generic Device driver routines and interface implementation
+ */
+
+static irqreturn_t
+mmc_spi_detect_irq(int irq, void *mmc)
+{
+	struct mmc_spi_host *host = mmc_priv(mmc);
+
+	mmc_detect_change(mmc, host->pdata->detect_delay);
+	return IRQ_HANDLED;
+}
+
+static int __devinit mmc_spi_probe(struct spi_device *spi)
+{
+	struct mmc_host		*mmc;
+	struct mmc_spi_host	*host;
+	int			status;
+	int			power_manageable = 1;
+
+	spi->mode |= (SPI_CPOL|SPI_CPHA);
+	spi->default_tx_word = 0xff;
+	spi->bits_per_word = 8;
+
+	status = spi_setup(spi);
+	if (status < 0) {
+		dev_dbg(&spi->dev, "bad default_tx_word?\n");
+
+		/*
+		 * Maybe because we specified a default_tx_word that the
+		 * controller didn't like.  We'll fall back on using a
+		 * buffer with ones.
+		 */
+		spi->default_tx_word = 0;
+		status = spi_setup(spi);
+		if (status < 0) {
+			/* Nope, guess it's the mode then.  */
+			dev_dbg(&spi->dev, "needs SPI mode 3\n");
+			return status;
+		}
+	}
+
+	mmc = mmc_alloc_host(sizeof *host
+			     + (spi->default_tx_word == 0
+				? ONES_BUFFER_SIZE : 0), &spi->dev);
+	if (!mmc)
+		/* Luckily, there's no spi_takedown or any need for it.  */
+		return -ENOMEM;
+
+	mmc->ops = &mmc_spi_ops;
+	mmc->ocr_avail = 0xFFFFFFFF;
+
+	/*
+	 * As long as we keep track of the number of successfully
+	 * transmitted blocks, we're good for this.  The lesser bytes
+	 * over the wire, the better.
+	 */
+	mmc->caps |= MMC_CAP_MULTIWRITE;
+
+	mmc->f_min = 125000;
+	mmc->f_max = 25 * 1000 * 1000;
+
+	host = mmc_priv(mmc);
+	host->mmc = mmc;
+	host->spi = spi;
+	host->cid_sequence = 0;
+	if (spi->default_tx_word == 0)
+		memset(host->ones, 0xff, ONES_BUFFER_SIZE);
+
+	/* platform data is used to hook up things like card sensing
+	 * and power switching gpios
+	 */
+	host->pdata = spi->dev.platform_data;
+	mmc->ocr_avail = host->pdata
+			?  host->pdata->ocr_mask
+			: MMC_VDD_32_33|MMC_VDD_33_34;
+
+	dev_set_drvdata(&spi->dev, mmc);
+
+	/* setup message for status readback/write-ones */
+	spi_message_init(&host->readback);
+	spi_message_add_tail(&host->status, &host->readback);
+	if (spi->default_tx_word == 0)
+		host->status.tx_buf = host->ones;
+	host->status.rx_buf = &host->status_byte;
+	host->status.len = 1;
+
+	if (spi->master->cdev.dev->dma_mask) {
+		host->dma_dev = spi->master->cdev.dev;
+		host->dma = dma_map_single(host->dma_dev, host,
+				sizeof *host, DMA_BIDIRECTIONAL);
+#ifdef	CONFIG_HIGHMEM
+		dev_dbg(&spi->dev, "highmem + dma-or-pio ...\n");
+#endif
+	}
+
+	/* once card enters SPI mode it stays that way till power cycled.
+	 * power cycling can be used as a hard reset for fault recovery.
+	 */
+	if (!host->pdata || !host->pdata->setpower)
+		power_manageable = 0;
+	else
+		host->pdata->setpower(&spi->dev, 0);
+
+	if (host->pdata && host->pdata->init) {
+		status = host->pdata->init(&spi->dev,
+					   mmc_spi_detect_irq, mmc);
+		if (status != 0)
+			goto fail_glue_init;
+	}
+
+	status = mmc_add_host(mmc);
+	if (status != 0)
+		goto fail_add_host;
+
+	dev_info(&spi->dev, "SD/MMC <-> SPI proxy driver%s\n",
+		 power_manageable ? "" : ", no card power management");
+	return 0;
+
+ fail_add_host:
+	mmc_remove_host (mmc);
+	if (host->dma_dev)
+		dma_unmap_single(host->dma_dev, host->dma,
+				 sizeof *host, DMA_BIDIRECTIONAL);
+ fail_glue_init:
+	mmc_free_host(mmc);
+	dev_set_drvdata(&spi->dev, NULL);
+	return status;
+}
+
+
+static int __devexit mmc_spi_remove(struct spi_device *spi)
+{
+	struct mmc_host		*mmc = dev_get_drvdata(&spi->dev);
+	struct mmc_spi_host	*host;
+
+	if (mmc) {
+		mmc_remove_host(mmc);
+		host = mmc_priv(mmc);
+
+		if (host->pdata && host->pdata->exit)
+			host->pdata->exit(&spi->dev, mmc);
+		if (host->dma_dev)
+			dma_unmap_single(host->dma_dev, host->dma,
+				sizeof *host, DMA_BIDIRECTIONAL);
+
+		mmc_free_host(mmc);
+		dev_set_drvdata(&spi->dev, NULL);
+	}
+	return 0;
+}
+
+
+static struct spi_driver mmc_spi_driver = {
+	.driver = {
+		.name =		"mmc_spi",
+		.bus =		&spi_bus_type,
+		.owner =	THIS_MODULE,
+	},
+	.probe =	mmc_spi_probe,
+	.remove =	__devexit_p(mmc_spi_remove),
+};
+
+
+static int __init mmc_spi_init(void)
+{
+	return spi_register_driver(&mmc_spi_driver);
+}
+module_init(mmc_spi_init);
+
+
+static void __exit mmc_spi_exit(void)
+{
+	spi_unregister_driver(&mmc_spi_driver);
+}
+module_exit(mmc_spi_exit);
+
+
+MODULE_AUTHOR("Mike Lavender, David Brownell");
+MODULE_DESCRIPTION("SPI SD/MMC driver");
+MODULE_LICENSE("GPL");
diff -uprN a/include/linux/spi/mmc_spi.h b/include/linux/spi/mmc_spi.h
--- a/include/linux/spi/mmc_spi.h	1970-01-01 01:00:00.000000000 +0100
+++ b/include/linux/spi/mmc_spi.h	2007-01-24 06:09:08.000000000 +0100
@@ -0,0 +1,34 @@
+#ifndef __LINUX_SPI_MMC_SPI_H
+#define __LINUX_SPI_MMC_SPI_H
+
+#include <linux/mmc/protocol.h>
+#include <linux/interrupt.h>
+
+struct device;
+struct mmc_host;
+
+/* something to put in platform_data of a device being used
+ * to manage an MMC/SD card slot
+ *
+ * REVISIT this isn't spi-specific, any card slot should be
+ * able to handle it
+ */
+struct mmc_spi_platform_data {
+	/* driver activation and (optional) card detect irq */
+	int (*init)(struct device *,
+		irqreturn_t (*)(int, void *),
+		void *);
+	void (*exit)(struct device *, void *);
+
+	/* how long to debounce card detect, in jiffies */
+	unsigned long detect_delay;
+
+	/* sense switch on sd cards */
+	int (*get_ro)(struct device *);
+
+	/* power management */
+	unsigned int ocr_mask;			/* available voltages */
+	void (*setpower)(struct device *, unsigned int);
+};
+
+#endif /* __LINUX_SPI_MMC_SPI_H */

brgds, H-P
