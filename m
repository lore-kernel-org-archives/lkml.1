Return-Path: <linux-kernel-owner+w=401wt.eu-S1758977AbZKEXyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977AbZKEXyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 18:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757971AbZKEXyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 18:54:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33517 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855AbZKEXyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 18:54:21 -0500
Date: Fri, 6 Nov 2009 00:53:50 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd/mc13783: near complete rewrite
Message-ID: <20091105235349.GA22519@pengutronix.de>
References: <1257195385-15595-1-git-send-email-u.kleine-koenig@pengutronix.de> <1257276673-30518-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091104183507.GH3607@sortiz.org> <20091104222839.GA15988@pengutronix.de> <20091105223103.GB22366@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091105223103.GB22366@sortiz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 05, 2009 at 11:31:04PM +0100, Samuel Ortiz wrote:
> > The idea here is that I could setup, send and receive multi-transfer
> > messages with a single buffer array.  Then the return value would tell me how
> > much to advance in the buffer for the next result.  Maybe that's just
> > paranoid over-engineering.
> I'm glad we agree :) This routine is just not neede, for the mere fact that it
> does nothing. Unless you have bigger plans for this driver, right now you're
> doing simple SPI register reads and writes, afaict.
OK, I moved the functionality of {prep,eval}_{read,write} to
reg_{read,write} now and removed the BUG_ONs.  Incremental patch below.
 
> > > > +	/* error in message.status implies error return from spi_sync */
> > > > +	BUG_ON(!ret && m.status);
> > > So, you really want to crash your board because of an SPI inconsistency ?
> > > Seems like an overkill to me.
> > This only bugs if spi_sync succeeds even though the message wasn't
> > transfered correctly.  Sascha's driver had:
> > 
> > 	if (spi_sync(spi, &m) != 0 || m.status != 0)
> > 		return -EINVAL;
> > 
> > If I understand spi_sync correctly m.status != 0 implies spi_sync
> > returning != 0, so the above should be equivalent to:
> > 
> > 	if (spi_sync(spi, &m) != 0)
> > 		return -EINVAL;
> > 
> > So my BUG_ON is only for the case that Sascha saw something I missed.
> Oh, dont get me wrong: I'm not saying the check is bogus, I'm just saying that
> I would just have a WARN_ON() here. I wouldnt be happy if my board would crash
> because of an SPI read error.
An SPI read error won't trigger that.  In this case ret is < 0, and so
(!ret && m.status) is false.

The incremental diff based on the earlier post can be found below.  I
will follow up with the updated patch.

Best regards
Uwe

 drivers/mfd/mc13783-core.c |   95 ++++++++++++--------------------------------
 1 files changed, 26 insertions(+), 69 deletions(-)

diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
index 45713a4..99267ed 100644
--- a/drivers/mfd/mc13783-core.c
+++ b/drivers/mfd/mc13783-core.c
@@ -2,6 +2,9 @@
  * Copyright 2009 Pengutronix
  * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
  *
+ * loosely based on an earlier driver that has
+ * Copyright 2009 Pengutronix, Sascha Hauer <s.hauer@pengutronix.de>
+ *
  * This program is free software; you can redistribute it and/or modify it under
  * the terms of the GNU General Public License version 2 as published by the
  * Free Software Foundation.
@@ -112,7 +115,7 @@ void mc13783_lock(struct mc13783 *mc13783)
 {
 	if (!mutex_trylock(&mc13783->lock)) {
 		dev_dbg(&mc13783->spidev->dev, "wait for %s from %pf\n",
-			__func__, __builtin_return_address(0));
+				__func__, __builtin_return_address(0));
 
 		mutex_lock(&mc13783->lock);
 	}
@@ -129,75 +132,25 @@ void mc13783_unlock(struct mc13783 *mc13783)
 }
 EXPORT_SYMBOL(mc13783_unlock);
 
-static int mc13783_prep_read_transfer(struct mc13783 *mc13783,
-		struct spi_transfer *t, u32 *buf,
-		unsigned int offset, u32 *val)
-{
-	if (offset > MC13783_NUMREGS)
-		return -EINVAL;
-
-	buf[0] = offset << 25;
-
-	memset(t, 0, sizeof(*t));
-
-	t->tx_buf = buf;
-	t->rx_buf = buf;
-	t->len = sizeof(u32);
-
-	return 1;
-}
-
-static int mc13783_eval_read_transfer(struct mc13783 *mc13783,
-		struct spi_transfer *t, u32 *buf,
-		unsigned int offset, u32 *val)
-{
-	BUG_ON(t->tx_buf != buf || t->rx_buf != buf);
-
-	*val = buf[0] & 0xffffff;
-
-	return 1;
-}
-
-static int mc13783_prep_write_transfer(struct mc13783 *mc13783,
-		struct spi_transfer *t, u32 *buf,
-		unsigned int offset, u32 val)
-{
-	if (offset > MC13783_NUMREGS || val > 0xffffff)
-		return -EINVAL;
-
-	buf[0] = 1 << 31 | offset << 25 | val;
-
-	memset(t, 0, sizeof(*t));
-
-	t->tx_buf = buf;
-	t->rx_buf = buf;
-	t->len = sizeof(u32);
-
-	return 1;
-}
-
-static int mc13783_eval_write_transfer(struct mc13783 *mc13783,
-		struct spi_transfer *t, u32 *buf,
-		unsigned int offset, u32 val)
-{
-	BUG_ON(t->tx_buf != buf || t->rx_buf != buf);
-
-	return 1;
-}
-
+#define MC13783_REGOFFSET_SHIFT 25
 int mc13783_reg_read(struct mc13783 *mc13783, unsigned int offset, u32 *val)
 {
-	u32 buf;
 	struct spi_transfer t;
 	struct spi_message m;
 	int ret;
 
 	BUG_ON(!mutex_is_locked(&mc13783->lock));
 
-	ret = mc13783_prep_read_transfer(mc13783, &t, &buf, offset, val);
+	if (offset > MC13783_NUMREGS)
+		return -EINVAL;
 
-	if (ret < 0)
-		return ret;
+	*val = offset << MC13783_REGOFFSET_SHIFT;
+
+	memset(&t, 0, sizeof(t));
+
+	t.tx_buf = val;
+	t.rx_buf = val;
+	t.len = sizeof(u32);
 
 	spi_message_init(&m);
 	spi_message_add_tail(&t, &m);
@@ -210,11 +163,11 @@ int mc13783_reg_read(struct mc13783 *mc13783, unsigned int offset, u32 *val)
 	if (ret)
 		return ret;
 
-	ret = mc13783_eval_read_transfer(mc13783, &t, &buf, offset, val);
+	*val &= 0xffffff;
 
 	dev_vdbg(&mc13783->spidev->dev, "[0x%02x] -> 0x%06x\n", offset, *val);
 
-	return ret < 0 ? ret : 0;
+	return 0;
 }
 EXPORT_SYMBOL(mc13783_reg_read);
 
@@ -229,10 +182,16 @@ int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
 
 	dev_vdbg(&mc13783->spidev->dev, "[0x%02x] <- 0x%06x\n", offset, val);
 
-	ret = mc13783_prep_write_transfer(mc13783, &t, &buf, offset, val);
+	if (offset > MC13783_NUMREGS || val > 0xffffff)
+		return -EINVAL;
+
+	buf = 1 << 31 | offset << MC13783_REGOFFSET_SHIFT | val;
 
-	if (ret < 0)
-		return ret;
+	memset(&t, 0, sizeof(t));
+
+	t.tx_buf = &buf;
+	t.rx_buf = &buf;
+	t.len = sizeof(u32);
 
 	spi_message_init(&m);
 	spi_message_add_tail(&t, &m);
@@ -244,9 +203,7 @@ int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
 	if (ret)
 		return ret;
 
-	ret = mc13783_eval_write_transfer(mc13783, &t, &buf, offset, val);
-
-	return ret < 0 ? ret : 0;
+	return 0;
 }
 EXPORT_SYMBOL(mc13783_reg_write);
 
-- 
1.6.5.2


-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
