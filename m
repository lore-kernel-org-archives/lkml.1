Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZDGO1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZDGO1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbZDGO0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:26:53 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:19952 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753415AbZDGO0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:26:53 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH 6/7 revised] mmc_spi: convert timeout handling to jiffies and avoid busy waiting
Date: Tue, 7 Apr 2009 15:26:30 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904071626.30917.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

o SD/MMC card timeouts can be very high. So avoid busy-waiting,
  using the scheduler. Calculate all timeouts in jiffies units,
  because this will give us the correct sign when to involve
  the scheduler.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---

This patch was discussed on lkml. Some where concerned about
performance loss, but no performance loss was visible in real-
life tests, and nobody came up with a better solution. And it
was clear that a busy waiting of several 100 of ms has to be
ended.

diff -uprN 2_6_29_rc7_patch12534/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch125346/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_patch12534/drivers/mmc/host/mmc_spi.c	2009-03-16 12:15:36.000000000 +0100
+++ 2_6_29_rc7_patch125346/drivers/mmc/host/mmc_spi.c	2009-04-07 15:59:54.000000000 +0200
@@ -24,7 +24,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-#include <linux/hrtimer.h>
+#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/bio.h>
 #include <linux/dma-mapping.h>
@@ -95,7 +95,7 @@
  * reads which takes nowhere near that long.  Older cards may be able to use
  * shorter timeouts ... but why bother?
  */
-#define r1b_timeout		ktime_set(3, 0)
+#define r1b_timeout		(HZ * 3)
 
 
 /****************************************************************************/
@@ -183,12 +183,11 @@ mmc_spi_readbytes(struct mmc_spi_host *h
 	return status;
 }
 
-static int
-mmc_spi_skip(struct mmc_spi_host *host, ktime_t timeout, unsigned n, u8 byte)
+static int mmc_spi_skip(struct mmc_spi_host *host, unsigned long timeout,
+			unsigned n, u8 byte)
 {
 	u8		*cp = host->data->status;
-
-	timeout = ktime_add(timeout, ktime_get());
+	unsigned long start = jiffies;
 
 	while (1) {
 		int		status;
@@ -203,22 +202,26 @@ mmc_spi_skip(struct mmc_spi_host *host, 
 				return cp[i];
 		}
 
-		/* REVISIT investigate msleep() to avoid busy-wait I/O
-		 * in at least some cases.
-		 */
-		if (ktime_to_ns(ktime_sub(ktime_get(), timeout)) > 0)
+		if (time_is_before_jiffies(start + timeout))
 			break;
+
+		/* If we need long timeouts, we may release the CPU.
+		 * We use jiffies here because we want to have a relation
+		 * between elapsed time and the blocking of the scheduler.
+		 */
+		if (time_is_before_jiffies(start+1))
+			schedule();
 	}
 	return -ETIMEDOUT;
 }
 
 static inline int
-mmc_spi_wait_unbusy(struct mmc_spi_host *host, ktime_t timeout)
+mmc_spi_wait_unbusy(struct mmc_spi_host *host, unsigned long timeout)
 {
 	return mmc_spi_skip(host, timeout, sizeof(host->data->status), 0);
 }
 
-static int mmc_spi_readtoken(struct mmc_spi_host *host, ktime_t timeout)
+static int mmc_spi_readtoken(struct mmc_spi_host *host, unsigned long timeout)
 {
 	return mmc_spi_skip(host, timeout, 1, 0xff);
 }
@@ -607,7 +610,7 @@ mmc_spi_setup_data_message(
  */
 static int
 mmc_spi_writeblock(struct mmc_spi_host *host, struct spi_transfer *t,
-	ktime_t timeout)
+	unsigned long timeout)
 {
 	struct spi_device	*spi = host->spi;
 	int			status, i;
@@ -717,7 +720,7 @@ mmc_spi_writeblock(struct mmc_spi_host *
  */
 static int
 mmc_spi_readblock(struct mmc_spi_host *host, struct spi_transfer *t,
-	ktime_t timeout)
+	unsigned long timeout)
 {
 	struct spi_device	*spi = host->spi;
 	int			status;
@@ -803,7 +806,7 @@ mmc_spi_data_do(struct mmc_spi_host *hos
 	unsigned		n_sg;
 	int			multiple = (data->blocks > 1);
 	u32			clock_rate;
-	ktime_t			timeout;
+	unsigned long		timeout;
 
 	if (data->flags & MMC_DATA_READ)
 		direction = DMA_FROM_DEVICE;
@@ -817,8 +820,9 @@ mmc_spi_data_do(struct mmc_spi_host *hos
 	else
 		clock_rate = spi->max_speed_hz;
 
-	timeout = ktime_add_ns(ktime_set(0, 0), data->timeout_ns +
-			data->timeout_clks * 1000000 / clock_rate);
+	timeout = data->timeout_ns +
+		  data->timeout_clks * 1000000 / clock_rate;
+	timeout = usecs_to_jiffies((unsigned int)(timeout / 1000)) + 1;
 
 	/* Handle scatterlist segments one at a time, with synch for
 	 * each 512-byte block

---
regards

i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
