Return-Path: <linux-kernel-owner+w=401wt.eu-S1762294AbYA1TgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762294AbYA1TgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYA1TgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:36:00 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:38728
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbYA1Tf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:35:59 -0500
X-Greylist: delayed 3258 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2008 14:35:59 EST
Subject: [PATCH] synclink_gt fix missed serial input signal changes
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 12:41:06 -0600
Message-Id: <1201545666.17700.4.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix missed serial input signal changes caused by rereading the
serial status register during interrupt processing. Now
processing is performed on original status register value.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/drivers/char/synclink_gt.c	2008-01-24 16:58:37.000000000 -0600
+++ b/drivers/char/synclink_gt.c	2008-01-28 12:22:22.000000000 -0600
@@ -2040,37 +2040,41 @@ static void bh_transmit(struct slgt_info
 		tty_wakeup(tty);
 }
 
-static void dsr_change(struct slgt_info *info)
+static void dsr_change(struct slgt_info *info, unsigned short status)
 {
-	get_signals(info);
+	if (status & BIT3) {
+		info->signals |= SerialSignal_DSR;
+		info->input_signal_events.dsr_up++;
+	} else {
+		info->signals &= ~SerialSignal_DSR;
+		info->input_signal_events.dsr_down++;
+	}
 	DBGISR(("dsr_change %s signals=%04X\n", info->device_name, info->signals));
 	if ((info->dsr_chkcount)++ == IO_PIN_SHUTDOWN_LIMIT) {
 		slgt_irq_off(info, IRQ_DSR);
 		return;
 	}
 	info->icount.dsr++;
-	if (info->signals & SerialSignal_DSR)
-		info->input_signal_events.dsr_up++;
-	else
-		info->input_signal_events.dsr_down++;
 	wake_up_interruptible(&info->status_event_wait_q);
 	wake_up_interruptible(&info->event_wait_q);
 	info->pending_bh |= BH_STATUS;
 }
 
-static void cts_change(struct slgt_info *info)
+static void cts_change(struct slgt_info *info, unsigned short status)
 {
-	get_signals(info);
+	if (status & BIT2) {
+		info->signals |= SerialSignal_CTS;
+		info->input_signal_events.cts_up++;
+	} else {
+		info->signals &= ~SerialSignal_CTS;
+		info->input_signal_events.cts_down++;
+	}
 	DBGISR(("cts_change %s signals=%04X\n", info->device_name, info->signals));
 	if ((info->cts_chkcount)++ == IO_PIN_SHUTDOWN_LIMIT) {
 		slgt_irq_off(info, IRQ_CTS);
 		return;
 	}
 	info->icount.cts++;
-	if (info->signals & SerialSignal_CTS)
-		info->input_signal_events.cts_up++;
-	else
-		info->input_signal_events.cts_down++;
 	wake_up_interruptible(&info->status_event_wait_q);
 	wake_up_interruptible(&info->event_wait_q);
 	info->pending_bh |= BH_STATUS;
@@ -2091,20 +2095,21 @@ static void cts_change(struct slgt_info 
 	}
 }
 
-static void dcd_change(struct slgt_info *info)
+static void dcd_change(struct slgt_info *info, unsigned short status)
 {
-	get_signals(info);
+	if (status & BIT1) {
+		info->signals |= SerialSignal_DCD;
+		info->input_signal_events.dcd_up++;
+	} else {
+		info->signals &= ~SerialSignal_DCD;
+		info->input_signal_events.dcd_down++;
+	}
 	DBGISR(("dcd_change %s signals=%04X\n", info->device_name, info->signals));
 	if ((info->dcd_chkcount)++ == IO_PIN_SHUTDOWN_LIMIT) {
 		slgt_irq_off(info, IRQ_DCD);
 		return;
 	}
 	info->icount.dcd++;
-	if (info->signals & SerialSignal_DCD) {
-		info->input_signal_events.dcd_up++;
-	} else {
-		info->input_signal_events.dcd_down++;
-	}
 #if SYNCLINK_GENERIC_HDLC
 	if (info->netcount) {
 		if (info->signals & SerialSignal_DCD)
@@ -2127,20 +2132,21 @@ static void dcd_change(struct slgt_info 
 	}
 }
 
-static void ri_change(struct slgt_info *info)
+static void ri_change(struct slgt_info *info, unsigned short status)
 {
-	get_signals(info);
+	if (status & BIT0) {
+		info->signals |= SerialSignal_RI;
+		info->input_signal_events.ri_up++;
+	} else {
+		info->signals &= ~SerialSignal_RI;
+		info->input_signal_events.ri_down++;
+	}
 	DBGISR(("ri_change %s signals=%04X\n", info->device_name, info->signals));
 	if ((info->ri_chkcount)++ == IO_PIN_SHUTDOWN_LIMIT) {
 		slgt_irq_off(info, IRQ_RI);
 		return;
 	}
-	info->icount.dcd++;
-	if (info->signals & SerialSignal_RI) {
-		info->input_signal_events.ri_up++;
-	} else {
-		info->input_signal_events.ri_down++;
-	}
+	info->icount.rng++;
 	wake_up_interruptible(&info->status_event_wait_q);
 	wake_up_interruptible(&info->event_wait_q);
 	info->pending_bh |= BH_STATUS;
@@ -2191,13 +2197,13 @@ static void isr_serial(struct slgt_info 
 	}
 
 	if (status & IRQ_DSR)
-		dsr_change(info);
+		dsr_change(info, status);
 	if (status & IRQ_CTS)
-		cts_change(info);
+		cts_change(info, status);
 	if (status & IRQ_DCD)
-		dcd_change(info);
+		dcd_change(info, status);
 	if (status & IRQ_RI)
-		ri_change(info);
+		ri_change(info, status);
 }
 
 static void isr_rdma(struct slgt_info *info)


