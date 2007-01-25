Return-Path: <linux-kernel-owner+w=401wt.eu-S965260AbXAYEy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965260AbXAYEy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 23:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933231AbXAYEyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 23:54:50 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:56434 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933232AbXAYEys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 23:54:48 -0500
Date: Thu, 25 Jan 2007 05:50:40 +0100
Message-Id: <200701250450.l0P4oe3I017089@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: dbrownell@users.sourceforge.net
CC: mikael.starvik@axis.com, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: 2/5: Updates to SPI and mmc_spi: clock with cs inactive, kernel 2.6.19
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Please CC me on replies, I'm not subscribed to LKML or the SPI list.  Thanks.)

There was a comment in the mmc_spi.c glue driver at
<URL:http://www.gossamer-threads.com/lists/linux/kernel/671939#671939>:
+                * some cards seemed happier if they were initialized first
+                * by the native MMC stack, not SPI ... and in other cases
+                * rmmod/modprobe of mmc_spi helped the card work better,
+                * even without power cycling
+                *
+                * FIXME find out what that important state is, which is
+                * not reset here... and makes robustness problems

I think I've spotted the problem, or at least a problem with a
solution that fits the description.  What's missing is "at least
74 SD clocks to the SD card with keeping CMD line to high. In
case of SPI mode, CS shall be held to high during 74 clock
cycles" (from Section 6.4.1, in "Simplified Physical Layer
Specification 2.0").  This is to happen before sending CMD0.  I
have only one card (of 7) where this fails, a Viking Interworks
256 MB card.  It matches the description in the comment; it
never initializes, gives invalid replies (with bit 7 set)
without this, but works fine with it.

The gotcha is that the SPI framework didn't have a way to
express transfers with chip-select inactive.  Sure, you can set
chip-select to inactive for a period of *time*, but never while
also toggling the clock.  So here's an implementation for that.

I made this functionality optional, with the updated mmc_spi
driver trying anyway if the spi host doesn't provide the
function.  So, no SPI drivers require updating, unless they
really want to work with mmc_spi flawlessly with all cards.
I initially thought the function important enough to warrant
mandatory implementation for all SPI drivers, but it hasn't been
needed before, so I reconsidered.  Also, some SPI drivers seem
to implement the chip-select function as optional, a clear hint
to this being optional IMHO.  I looked at the existing drivers
and went as far as writing proof-of-concept patches for them,
but as I can't test them, I'll just stop there and call that a
feasibility study.  The spi_bitbang looked like it could have
always can_cs_inactive = 1, but then I noticed what
spi_mpc83xx.c does in its mpc83xx_spi_chipselect() (register
writes only on BITBANG_CS_ACTIVE supposedly controlling the
clock) and so I think setting the capability is better be left
to the respective caller (typically just before its call to
spi_bitbang_start), and just adjust the various chipselect calls
i spi_bitbang.

Tested together with the other patches on the spi_crisv32_sser
and the spi_crisv32_gpio drivers, both using the spi_bitbang
framework though not yet in the kernel (will IIUC be submitted
as part of the usual arch-maintainer-pushes).

Signed-off-by: Hans-Peter Nilsson <hp@axis.com>

diff -upr a/include/linux/spi/spi.h b/include/linux/spi/spi.h
--- a/include/linux/spi/spi.h	2006-10-13 10:02:56.000000000 +0200
+++ b/include/linux/spi/spi.h	2007-01-24 07:10:09.000000000 +0100
@@ -153,6 +153,8 @@ static inline void spi_unregister_driver
  *	SPI slaves, and are numbered from zero to num_chipselects.
  *	each slave has a chipselect signal, but it's common that not
  *	every chipselect is connected to a slave.
+ * @can_cs_inactive: the controller can send data (or at least toggle the
+ *	clock with undefined data output) while having chipselect inactive.
  * @setup: updates the device mode and clocking records used by a
  *	device's SPI controller; protocol code may call this.
  * @transfer: adds a message to the controller's transfer queue.
@@ -185,6 +187,12 @@ struct spi_master {
 	 */
 	u16			num_chipselect;
 
+	/* clients that want to toggle the clock while chipselect is
+	 * inactive (has different polarity compared to when data is
+	 * output) must test this bit.
+	 */
+	unsigned		can_cs_inactive:1;
+
 	/* setup mode and clock, etc (spi driver may call many times) */
 	int			(*setup)(struct spi_device *spi);
 
@@ -202,7 +210,8 @@ struct spi_master {
 	 *   arbitration algorithm is unspecified (round robin, fifo,
 	 *   priority, reservations, preemption, etc)
 	 *
-	 * + Chipselect stays active during the entire message
+	 * + Chipselect stays active (or inactive when using
+	 *   spi_transfer.cs_inactive) during the entire message
 	 *   (unless modified by spi_transfer.cs_change != 0).
 	 * + The message transfers use clock and SPI mode parameters
 	 *   previously established by setup() for this device
@@ -278,6 +287,15 @@ extern struct spi_master *spi_busnum_to_
  * @bits_per_word: select a bits_per_word other then the device default
  *      for this transfer. If 0 the default (from spi_device) is used.
  * @cs_change: affects chipselect after this transfer completes
+ * @cs_inactive: if the host supports this function (see spi_device
+ *	.can_cs_inactive) and if this is 1, chipselect will be inactive
+ *	during this transfer.  The value of cs_change is correspondingly
+ *	affected; a cs_change = 1 in a transfer with cs_inactive = 1 means
+ *	"changing back to active".  Input and output data are undefined
+ *	with regards to signal levels on the hardware; the length is the
+ *	important information, and it's ok to pass NULL for both tx_buf
+ *	and rx_buf.  It is an error to set this bit if spi_device
+ *	.can_cs_inactive == 0.
  * @delay_usecs: microseconds to delay after this transfer before
  *	(optionally) changing the chipselect status, then starting
  *	the next transfer or completing this spi_message.
@@ -296,8 +314,9 @@ extern struct spi_master *spi_busnum_to_
  * shifting out three bytes with word size of sixteen or twenty bits;
  * the former uses two bytes per word, the latter uses four bytes.)
  *
- * All SPI transfers start with the relevant chipselect active.  Normally
- * it stays selected until after the last transfer in a message.  Drivers
+ * All SPI transfers start with the relevant chipselect active (except of
+ * course with cs_inactive = 1 in the transfer, it's inactive).  Normally
+ * it stays that way until after the last transfer in a message.  Drivers
  * can affect the chipselect signal using cs_change:
  *
  * (i) If the transfer isn't the last one in the message, this flag is
@@ -331,6 +350,7 @@ struct spi_transfer {
 	dma_addr_t	rx_dma;
 
 	unsigned	cs_change:1;
+	unsigned	cs_inactive:1;
 	u8		bits_per_word;
 	u16		delay_usecs;
 	u32		speed_hz;
diff -upr a/drivers/spi/spi_bitbang.c b/drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c	2007-01-24 05:48:25.000000000 +0100
+++ b/drivers/spi/spi_bitbang.c	2007-01-24 07:14:12.000000000 +0100
@@ -279,6 +279,7 @@ static void bitbang_work(void *_bitbang)
 		struct spi_transfer	*t = NULL;
 		unsigned		tmp;
 		unsigned		cs_change;
+		unsigned		cs_inactive;
 		int			status;
 		int			(*setup_transfer)(struct spi_device *,
 						struct spi_transfer *);
@@ -297,10 +298,14 @@ static void bitbang_work(void *_bitbang)
 		spi = m->spi;
 		tmp = 0;
 		cs_change = 1;
+		cs_inactive = 0;
 		status = 0;
 		setup_transfer = NULL;
 
 		list_for_each_entry (t, &m->transfers, transfer_list) {
+			cs_inactive = t->cs_inactive;
+			BUG_ON(cs_inactive && !spi->master->can_cs_inactive);
+
 			if (bitbang->shutdown) {
 				status = -ESHUTDOWN;
 				break;
@@ -327,11 +332,15 @@ static void bitbang_work(void *_bitbang)
 			 * selected ...)
 			 */
 			if (cs_change) {
-				bitbang->chipselect(spi, BITBANG_CS_ACTIVE);
+				bitbang->chipselect(spi,
+						    cs_inactive
+						    ? BITBANG_CS_INACTIVE
+						    : BITBANG_CS_ACTIVE);
 				ndelay(nsecs);
 			}
 			cs_change = t->cs_change;
-			if (!t->tx_buf && !t->rx_buf && t->len) {
+			if (!t->tx_buf && !t->rx_buf && t->len
+			    && !cs_inactive) {
 				status = -EINVAL;
 				break;
 			}
@@ -369,7 +378,10 @@ static void bitbang_work(void *_bitbang)
 			 * may be needed to terminate a mode or command
 			 */
 			ndelay(nsecs);
-			bitbang->chipselect(spi, BITBANG_CS_INACTIVE);
+			bitbang->chipselect(spi,
+					    cs_inactive
+					    ? BITBANG_CS_ACTIVE
+					    : BITBANG_CS_INACTIVE);
 			ndelay(nsecs);
 		}
 
@@ -386,7 +398,10 @@ static void bitbang_work(void *_bitbang)
 		 */
 		if (!(status == 0 && cs_change)) {
 			ndelay(nsecs);
-			bitbang->chipselect(spi, BITBANG_CS_INACTIVE);
+			bitbang->chipselect(spi,
+					    cs_inactive
+					    ? BITBANG_CS_ACTIVE
+					    : BITBANG_CS_INACTIVE);
 			ndelay(nsecs);
 		}
 

brgds, H-P
