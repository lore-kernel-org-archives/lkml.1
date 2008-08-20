Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbYHTP53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbYHTP53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbYHTP5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:57:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36517 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756458AbYHTP5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:57:04 -0400
Date: Wed, 20 Aug 2008 16:57:00 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Michael Chan <mchan@broadcom.com>
Cc: Matthew Carlson <mcarlson@broadcom.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Major stalls due to commit 7c5026aa9b81dd45df8d3f4e0be73e485976a8b6
Message-ID: <20080820155700.GD20199@csn.ul.ie>
References: <20080820120501.GC20199@csn.ul.ie> <C27F8246C663564A84BB7AB343977242024953CE42@IRVEXCHCCR01.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <C27F8246C663564A84BB7AB343977242024953CE42@IRVEXCHCCR01.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (20/08/08 08:06), Michael Chan didst pronounce:
> Mel Gorman wrote:
> 
> > I had the pleasure of getting hold of one of these machines
> > http://www.terrasoftsolutions.com/products/powerstation/ and
> > after some
> > tinkering installed 2.6.27-rc3. However, it was way slower and jerkier
> > (keyboard input for example would stop processing for up to 2 seconds)
> > than the distribution kernel. Network is a bit useless and
> > kernel builds
> > went from about 4 minutes to about 12 even when built
> > locally. I also noted
> > with NO_HZ enabled that a soft-lockup would be reported in a
> > timer related
> > to tg3. The card in question is
> >
> 
> This has been fixed a few days ago by the patch:
> 
> tg3: Fix firmware event timeouts
> 
> in the net-2.6 git tree.  Please try that to see if it fixes
> the problem.  Thanks.
> 

I've pasted that patch below for the convenience of anyone watching. It
doesn't apply cleanly to 2.6.27-rc3 but the merge is obvious. It does fix
the problem and as this is affects 2.6.26, you should consider pushing it
to stable if you are not doing so already. Thanks


>From 4ba526ced990f4d61ee8d65fe8a6f0745e8e455c Mon Sep 17 00:00:00 2001
From: Matt Carlson <mcarlson@broadcom.com>
Date: Fri, 15 Aug 2008 14:10:04 -0700
Subject: [PATCH] tg3: Fix firmware event timeouts

The git commit 7c5026aa9b81dd45df8d3f4e0be73e485976a8b6 ("tg3: Add
link state reporting to UMP firmware") introduced code that waits for
previous firmware events to be serviced before attempting to submit a
new event.  Unfortunately that patch contained a bug that cause the
driver to wait 2.5 seconds, rather than 2.5 milliseconds as intended.
This patch fixes that bug.

This bug revealed that not all firmware versions service driver events
though.  Since we do not know which versions of the firmware do and don't
service these events, the driver needs some way to minimize the effects
of the delay.  This patch solves the problem by recording a jiffies
timestamp when it submits an event to the hardware.  If the jiffies
counter shows that 2.5 milliseconds have already passed, a wait is not
needed and the driver can proceed to submit a new event.

Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index e952b91..c26011e 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -1020,15 +1020,43 @@ static void tg3_mdio_fini(struct tg3 *tp)
 }
 
 /* tp->lock is held. */
+static inline void tg3_generate_fw_event(struct tg3 *tp)
+{
+	u32 val;
+
+	val = tr32(GRC_RX_CPU_EVENT);
+	val |= GRC_RX_CPU_DRIVER_EVENT;
+	tw32_f(GRC_RX_CPU_EVENT, val);
+
+	tp->last_event_jiffies = jiffies;
+}
+
+#define TG3_FW_EVENT_TIMEOUT_USEC 2500
+
+/* tp->lock is held. */
 static void tg3_wait_for_event_ack(struct tg3 *tp)
 {
 	int i;
+	unsigned int delay_cnt;
+	long time_remain;
+
+	/* If enough time has passed, no wait is necessary. */
+	time_remain = (long)(tp->last_event_jiffies + 1 +
+		      usecs_to_jiffies(TG3_FW_EVENT_TIMEOUT_USEC)) -
+		      (long)jiffies;
+	if (time_remain < 0)
+		return;
 
-	/* Wait for up to 2.5 milliseconds */
-	for (i = 0; i < 250000; i++) {
+	/* Check if we can shorten the wait time. */
+	delay_cnt = jiffies_to_usecs(time_remain);
+	if (delay_cnt > TG3_FW_EVENT_TIMEOUT_USEC)
+		delay_cnt = TG3_FW_EVENT_TIMEOUT_USEC;
+	delay_cnt = (delay_cnt >> 3) + 1;
+
+	for (i = 0; i < delay_cnt; i++) {
 		if (!(tr32(GRC_RX_CPU_EVENT) & GRC_RX_CPU_DRIVER_EVENT))
 			break;
-		udelay(10);
+		udelay(8);
 	}
 }
 
@@ -1077,9 +1105,7 @@ static void tg3_ump_link_report(struct tg3 *tp)
 		val = 0;
 	tg3_write_mem(tp, NIC_SRAM_FW_CMD_DATA_MBOX + 12, val);
 
-	val = tr32(GRC_RX_CPU_EVENT);
-	val |= GRC_RX_CPU_DRIVER_EVENT;
-	tw32_f(GRC_RX_CPU_EVENT, val);
+	tg3_generate_fw_event(tp);
 }
 
 static void tg3_link_report(struct tg3 *tp)
@@ -5953,6 +5979,7 @@ static int tg3_chip_reset(struct tg3 *tp)
 		tg3_read_mem(tp, NIC_SRAM_DATA_CFG, &nic_cfg);
 		if (nic_cfg & NIC_SRAM_DATA_CFG_ASF_ENABLE) {
 			tp->tg3_flags |= TG3_FLAG_ENABLE_ASF;
+			tp->last_event_jiffies = jiffies;
 			if (tp->tg3_flags2 & TG3_FLG2_5750_PLUS)
 				tp->tg3_flags2 |= TG3_FLG2_ASF_NEW_HANDSHAKE;
 		}
@@ -5966,15 +5993,12 @@ static void tg3_stop_fw(struct tg3 *tp)
 {
 	if ((tp->tg3_flags & TG3_FLAG_ENABLE_ASF) &&
 	   !(tp->tg3_flags3 & TG3_FLG3_ENABLE_APE)) {
-		u32 val;
-
 		/* Wait for RX cpu to ACK the previous event. */
 		tg3_wait_for_event_ack(tp);
 
 		tg3_write_mem(tp, NIC_SRAM_FW_CMD_MBOX, FWCMD_NICDRV_PAUSE_FW);
-		val = tr32(GRC_RX_CPU_EVENT);
-		val |= GRC_RX_CPU_DRIVER_EVENT;
-		tw32(GRC_RX_CPU_EVENT, val);
+
+		tg3_generate_fw_event(tp);
 
 		/* Wait for RX cpu to ACK this event. */
 		tg3_wait_for_event_ack(tp);
@@ -7864,8 +7888,6 @@ static void tg3_timer(unsigned long __opaque)
 	if (!--tp->asf_counter) {
 		if ((tp->tg3_flags & TG3_FLAG_ENABLE_ASF) &&
 		    !(tp->tg3_flags3 & TG3_FLG3_ENABLE_APE)) {
-			u32 val;
-
 			tg3_wait_for_event_ack(tp);
 
 			tg3_write_mem(tp, NIC_SRAM_FW_CMD_MBOX,
@@ -7873,9 +7895,8 @@ static void tg3_timer(unsigned long __opaque)
 			tg3_write_mem(tp, NIC_SRAM_FW_CMD_LEN_MBOX, 4);
 			/* 5 seconds timeout */
 			tg3_write_mem(tp, NIC_SRAM_FW_CMD_DATA_MBOX, 5);
-			val = tr32(GRC_RX_CPU_EVENT);
-			val |= GRC_RX_CPU_DRIVER_EVENT;
-			tw32_f(GRC_RX_CPU_EVENT, val);
+
+			tg3_generate_fw_event(tp);
 		}
 		tp->asf_counter = tp->asf_multiplier;
 	}
diff --git a/drivers/net/tg3.h b/drivers/net/tg3.h
index 3772349..f5b8cab 100644
--- a/drivers/net/tg3.h
+++ b/drivers/net/tg3.h
@@ -2432,7 +2432,10 @@ struct tg3 {
 	struct tg3_ethtool_stats	estats;
 	struct tg3_ethtool_stats	estats_prev;
 
+	union {
 	unsigned long			phy_crc_errors;
+	unsigned long			last_event_jiffies;
+	};
 
 	u32				rx_offset;
 	u32				tg3_flags;
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
