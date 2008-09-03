Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbYICRpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbYICRpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbYICRpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:45:33 -0400
Received: from ns2.suse.de ([195.135.220.15]:57676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539AbYICRpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:45:31 -0400
Date: Wed, 3 Sep 2008 10:26:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Matt Carlson <mcarlson@broadcom.com>,
       Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 36/42] tg3: Fix firmware event timeouts
Message-ID: <20080903172640.GK7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tg3-fix-firmware-event-timeouts.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Carlson <mcarlson@broadcom.com>

patch 4ba526ced990f4d61ee8d65fe8a6f0745e8e455c upstream

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tg3.c |   53 +++++++++++++++++++++++++++++++++++++----------------
 drivers/net/tg3.h |    3 +++
 2 files changed, 40 insertions(+), 16 deletions(-)

--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -1672,15 +1672,43 @@ static int tg3_set_power_state(struct tg
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
+
+	/* Check if we can shorten the wait time. */
+	delay_cnt = jiffies_to_usecs(time_remain);
+	if (delay_cnt > TG3_FW_EVENT_TIMEOUT_USEC)
+		delay_cnt = TG3_FW_EVENT_TIMEOUT_USEC;
+	delay_cnt = (delay_cnt >> 3) + 1;
 
-	/* Wait for up to 2.5 milliseconds */
-	for (i = 0; i < 250000; i++) {
+	for (i = 0; i < delay_cnt; i++) {
 		if (!(tr32(GRC_RX_CPU_EVENT) & GRC_RX_CPU_DRIVER_EVENT))
 			break;
-		udelay(10);
+		udelay(8);
 	}
 }
 
@@ -1729,9 +1757,7 @@ static void tg3_ump_link_report(struct t
 		val = 0;
 	tg3_write_mem(tp, NIC_SRAM_FW_CMD_DATA_MBOX + 12, val);
 
-	val = tr32(GRC_RX_CPU_EVENT);
-	val |= GRC_RX_CPU_DRIVER_EVENT;
-	tw32_f(GRC_RX_CPU_EVENT, val);
+	tg3_generate_fw_event(tp);
 }
 
 static void tg3_link_report(struct tg3 *tp)
@@ -5565,6 +5591,7 @@ static int tg3_chip_reset(struct tg3 *tp
 		tg3_read_mem(tp, NIC_SRAM_DATA_CFG, &nic_cfg);
 		if (nic_cfg & NIC_SRAM_DATA_CFG_ASF_ENABLE) {
 			tp->tg3_flags |= TG3_FLAG_ENABLE_ASF;
+			tp->last_event_jiffies = jiffies;
 			if (tp->tg3_flags2 & TG3_FLG2_5750_PLUS)
 				tp->tg3_flags2 |= TG3_FLG2_ASF_NEW_HANDSHAKE;
 		}
@@ -5578,15 +5605,12 @@ static void tg3_stop_fw(struct tg3 *tp)
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
@@ -7477,8 +7501,6 @@ static void tg3_timer(unsigned long __op
 	 */
 	if (!--tp->asf_counter) {
 		if (tp->tg3_flags & TG3_FLAG_ENABLE_ASF) {
-			u32 val;
-
 			tg3_wait_for_event_ack(tp);
 
 			tg3_write_mem(tp, NIC_SRAM_FW_CMD_MBOX,
@@ -7486,9 +7508,8 @@ static void tg3_timer(unsigned long __op
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
--- a/drivers/net/tg3.h
+++ b/drivers/net/tg3.h
@@ -2404,7 +2404,10 @@ struct tg3 {
 	struct tg3_ethtool_stats	estats;
 	struct tg3_ethtool_stats	estats_prev;
 
+	union {
 	unsigned long			phy_crc_errors;
+	unsigned long			last_event_jiffies;
+	};
 
 	u32				rx_offset;
 	u32				tg3_flags;

-- 
