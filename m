Return-Path: <linux-kernel-owner+w=401wt.eu-S1759735AbZBEKKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735AbZBEKKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 05:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759438AbZBEKKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 05:10:39 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:33701 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759361AbZBEKKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 05:10:37 -0500
X-IronPort-AV: E=Sophos;i="4.37,384,1231131600"; 
   d="scan'208";a="82352172"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Wolfgang Muees <wolfgang.mues@auerswald.de>,
       Yi Li <yi.li@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] mmc spi: make mmc_spi driver work on blackfin
Date: Thu,  5 Feb 2009 18:12:30 +0800
Message-Id: <1233828750-13788-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

- Use jiffies for busy waiting. No need to deal with ns-Precision and 64
  bit variables if all we need is timeouts in the ms area.
- Release CPU time if busy timeout gets long.
- Extend write timeout to 1s to cope with cheap high capacity SDHC cards
  which got totaly upset if we write large chunks of data at once.
- Allow for the fact that a card is not able to send the response token
  after a data transfer in time. The token may be delayed a few bits(!)
- Make the driver accept SPI_MODE_3

[Yi Li <yi.li@analog.com>: use SPI lock to share bus with other SPI devices]

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mmc/host/mmc_spi.c |   91 +++++++++++++++++++++++++-------------------
 1 files changed, 52 insertions(+), 39 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 87e211d..2adaf28 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -25,6 +25,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #include <linux/hrtimer.h>
+#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/bio.h>
 #include <linux/dma-mapping.h>
@@ -186,9 +187,10 @@ mmc_spi_readbytes(struct mmc_spi_host *host, unsigned len)
 static int
 mmc_spi_skip(struct mmc_spi_host *host, ktime_t timeout, unsigned n, u8 byte)
 {
-	u8		*cp = host->data->status;
-
-	timeout = ktime_add(timeout, ktime_get());
+	u8 *cp = host->data->status;
+	struct timeval tv = ktime_to_timeval(timeout);
+	unsigned long timeout_jiffies = tv.tv_sec * HZ +  (tv.tv_usec * HZ) / USEC_PER_SEC;
+	unsigned long starttime = jiffies;
 
 	while (1) {
 		int		status;
@@ -203,11 +205,14 @@ mmc_spi_skip(struct mmc_spi_host *host, ktime_t timeout, unsigned n, u8 byte)
 				return cp[i];
 		}
 
-		/* REVISIT investigate msleep() to avoid busy-wait I/O
-		 * in at least some cases.
-		 */
-		if (ktime_to_ns(ktime_sub(ktime_get(), timeout)) > 0)
+		if ((jiffies - starttime) > timeout_jiffies)
 			break;
+
+		/* If we need long timeouts, we may release the CPU. */
+		/* We use jiffies here because we want to have a relation between
+		   elapsed time and the blocking of the scheduler. */
+		if ((jiffies - starttime) > 1)
+			schedule();
 	}
 	return -ETIMEDOUT;
 }
@@ -280,7 +285,9 @@ static int mmc_spi_response_get(struct mmc_spi_host *host,
 		 * It'd probably be better to memcpy() the first chunk and
 		 * avoid extra i/o calls...
 		 */
-		for (i = 2; i < 9; i++) {
+		/* Note we check for more than 8 bytes, because in practice,
+		   some SD cards are slow... */
+		for (i = 2; i < 16; i++) {
 			value = mmc_spi_readbytes(host, 1);
 			if (value < 0)
 				goto done;
@@ -609,6 +616,15 @@ mmc_spi_writeblock(struct mmc_spi_host *host, struct spi_transfer *t,
 	struct spi_device	*spi = host->spi;
 	int			status, i;
 	struct scratch		*scratch = host->data;
+	u32			pattern;
+
+	/* The MMC framework does a good job of computing timeouts
+	   according to the mmc/sd standard. However, we found that in
+	   SPI mode, there are many cards which need a longer timeout
+	   of 1s after receiving a long stream of write data. */
+	struct timeval tv = ktime_to_timeval(timeout);
+	if (tv.tv_sec == 0)
+		timeout = ktime_set(1, 0);
 
 	if (host->mmc->use_spi_crc)
 		scratch->crc_val = cpu_to_be16(
@@ -636,8 +652,23 @@ mmc_spi_writeblock(struct mmc_spi_host *host, struct spi_transfer *t,
 	 * doesn't necessarily tell whether the write operation succeeded;
 	 * it just says if the transmission was ok and whether *earlier*
 	 * writes succeeded; see the standard.
+	 *
+	 * In practice, there are (even modern SDHC-)Cards which need
+	 * some bits to send the response, so we have to cope with this
+	 * situation and check the response bit-by-bit. Arggh!!!
 	 */
-	switch (SPI_MMC_RESPONSE_CODE(scratch->status[0])) {
+	pattern  = scratch->status[0] << 24;
+	pattern |= scratch->status[1] << 16;
+	pattern |= scratch->status[2] << 8;
+	pattern |= scratch->status[3];
+
+	/* left-adjust to leading 0 bit */
+	while (pattern & 0x80000000)
+		pattern <<= 1;
+	/* right-adjust for pattern matching. Code is in bit 4..0 now. */
+	pattern >>= 27;
+
+	switch (pattern) {
 	case SPI_RESPONSE_ACCEPTED:
 		status = 0;
 		break;
@@ -668,8 +699,8 @@ mmc_spi_writeblock(struct mmc_spi_host *host, struct spi_transfer *t,
 	/* Return when not busy.  If we didn't collect that status yet,
 	 * we'll need some more I/O.
 	 */
-	for (i = 1; i < sizeof(scratch->status); i++) {
-		if (scratch->status[i] != 0)
+	for (i = 4; i < sizeof(scratch->status); i++) {
+		if (scratch->status[i] & 0x01)
 			return 0;
 	}
 	return mmc_spi_wait_unbusy(host, timeout);
@@ -973,6 +1004,7 @@ static void mmc_spi_request(struct mmc_host *mmc, struct mmc_request *mrq)
 #endif
 
 	/* issue command; then optionally data and stop */
+	spi_lock_bus(host->spi);
 	status = mmc_spi_command_send(host, mrq, mrq->cmd, mrq->data != NULL);
 	if (status == 0 && mrq->data) {
 		mmc_spi_data_do(host, mrq->cmd, mrq->data, mrq->data->blksz);
@@ -981,7 +1013,7 @@ static void mmc_spi_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		else
 			mmc_cs_off(host);
 	}
-
+	spi_unlock_bus(host->spi);
 	mmc_request_done(host->mmc, mrq);
 }
 
@@ -1206,8 +1238,15 @@ static int mmc_spi_probe(struct spi_device *spi)
 	 * rising edge ... meaning SPI modes 0 or 3.  So either SPI mode
 	 * should be legit.  We'll use mode 0 since it seems to be a
 	 * bit less troublesome on some hardware ... unclear why.
+	 *
+	 * If the platform_data specifies mode 3, trust the platform_data
+	 * and use this one. This allows for platforms which do not support
+	 * mode 0.
 	 */
-	spi->mode = SPI_MODE_0;
+	if (spi->mode != SPI_MODE_3)
+		/* set our default */
+		spi->mode = SPI_MODE_0;
+
 	spi->bits_per_word = 8;
 
 	status = spi_setup(spi);
@@ -1218,32 +1257,6 @@ static int mmc_spi_probe(struct spi_device *spi)
 		return status;
 	}
 
-	/* We can use the bus safely iff nobody else will interfere with us.
-	 * Most commands consist of one SPI message to issue a command, then
-	 * several more to collect its response, then possibly more for data
-	 * transfer.  Clocking access to other devices during that period will
-	 * corrupt the command execution.
-	 *
-	 * Until we have software primitives which guarantee non-interference,
-	 * we'll aim for a hardware-level guarantee.
-	 *
-	 * REVISIT we can't guarantee another device won't be added later...
-	 */
-	if (spi->master->num_chipselect > 1) {
-		struct count_children cc;
-
-		cc.n = 0;
-		cc.bus = spi->dev.bus;
-		status = device_for_each_child(spi->dev.parent, &cc,
-				maybe_count_child);
-		if (status < 0) {
-			dev_err(&spi->dev, "can't share SPI bus\n");
-			return status;
-		}
-
-		dev_warn(&spi->dev, "ASSUMING SPI bus stays unshared!\n");
-	}
-
 	/* We need a supply of ones to transmit.  This is the only time
 	 * the CPU touches these, so cache coherency isn't a concern.
 	 *
-- 
1.5.6.3
