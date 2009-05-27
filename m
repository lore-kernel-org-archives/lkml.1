Return-Path: <linux-kernel-owner+w=401wt.eu-S1758980AbZE0Cft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980AbZE0Cft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbZE0Cfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:35:41 -0400
Received: from relais.videotron.ca ([24.201.245.36]:31540 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546AbZE0Cfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:35:40 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 26 May 2009 22:35:34 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Pierre Ossman <pierre@ossman.eu>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] mvsdio: fix config failure with some high speed SDHC cards
Message-id: <alpine.LFD.2.00.0905262231120.3906@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    
Especially with Sandisk SDHC cards, the second SWITCH command was failing
with a timeout and the card was not recognized at all.  However if the
system was busy, or debugging was enabled, or a udelay(100) was inserted
before the second SWITCH command in the core code, then the timing was
so that the card started to work.

This appears to be a problem with the host hardware.  With some unusual
block sizes, the data FIFO status doesn't indicate a "empty" state right
away when the data transfer is done.  Queuing another data transfer in
that condition results in a transfer timeout.

The empty FIFO bit eventually get set by itself in less than 50 usecs
when it is not set right away. So let's just poll for that bit before
configuring the controller with a new data transfer.

Signed-off-by: Nicolas Pitre <nico@marvell.com>

diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 9d3cfa9..b56d72f 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -64,6 +64,31 @@ static int mvsd_setup_data(struct mvsd_host *host, struct mmc_data *data)
 	unsigned int tmout;
 	int tmout_index;
 
+	/*
+	 * Hardware weirdness.  The FIFO_EMPTY bit of the HW_STATE
+	 * register is sometimes not set before a while when some
+	 * "unusual" data block sizes are used (such as with the SWITCH
+	 * command), even despite the fact that the XFER_DONE interrupt
+	 * was raised.  And if another data transfer starts before
+	 * this bit comes to good sense (which eventually happens by
+	 * itself) then the new transfer simply fails with a timeout.
+	 */
+	if (!(mvsd_read(MVSD_HW_STATE) & (1 << 13))) {
+		unsigned long t = jiffies + HZ;
+		unsigned int hw_state,  count = 0;
+		do {
+			if (time_after(jiffies, t)) {
+				dev_warn(host->dev, "FIFO_EMPTY bit missing\n");
+				break;
+			}
+			hw_state = mvsd_read(MVSD_HW_STATE);
+			count++;
+		} while (!(hw_state & (1 << 13)));
+		dev_dbg(host->dev, "*** wait for FIFO_EMPTY bit "
+				   "(hw=0x%04x, count=%d, jiffies=%ld)\n",
+				   hw_state, count, jiffies - (t - HZ));
+	}
+
 	/* If timeout=0 then maximum timeout index is used. */
 	tmout = DIV_ROUND_UP(data->timeout_ns, host->ns_per_clk);
 	tmout += data->timeout_clks;
