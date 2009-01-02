Return-Path: <linux-kernel-owner+w=401wt.eu-S1758237AbZABKnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbZABKnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbZABKll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:41 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:37311 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbZABKlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:36 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: atari core - kill warn_unused_result warnings
Date: Fri,  2 Jan 2009 11:41:16 +0100
Message-Id: <1230892892-25751-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: ignoring return value of 'request_irq', declared with attribute
warn_unused_result

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/atari/atakeyb.c |    9 +++++++--
 arch/m68k/atari/stdma.c   |    5 +++--
 arch/m68k/atari/time.c    |    5 +++--
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/m68k/atari/atakeyb.c b/arch/m68k/atari/atakeyb.c
index dedfc09..e384f97 100644
--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -563,14 +563,19 @@ static int atari_keyb_done = 0;
 
 int atari_keyb_init(void)
 {
+	int error;
+
 	if (atari_keyb_done)
 		return 0;
 
 	kb_state.state = KEYBOARD;
 	kb_state.len = 0;
 
-	request_irq(IRQ_MFP_ACIA, atari_keyboard_interrupt, IRQ_TYPE_SLOW,
-		    "keyboard/mouse/MIDI", atari_keyboard_interrupt);
+	error = request_irq(IRQ_MFP_ACIA, atari_keyboard_interrupt,
+			    IRQ_TYPE_SLOW, "keyboard/mouse/MIDI",
+			    atari_keyboard_interrupt);
+	if (error)
+		return error;
 
 	atari_turnoff_irq(IRQ_MFP_ACIA);
 	do {
diff --git a/arch/m68k/atari/stdma.c b/arch/m68k/atari/stdma.c
index d1bd029..604329f 100644
--- a/arch/m68k/atari/stdma.c
+++ b/arch/m68k/atari/stdma.c
@@ -179,8 +179,9 @@ EXPORT_SYMBOL(stdma_islocked);
 void __init stdma_init(void)
 {
 	stdma_isr = NULL;
-	request_irq(IRQ_MFP_FDC, stdma_int, IRQ_TYPE_SLOW | IRQF_SHARED,
-	            "ST-DMA: floppy/ACSI/IDE/Falcon-SCSI", stdma_int);
+	if (request_irq(IRQ_MFP_FDC, stdma_int, IRQ_TYPE_SLOW | IRQF_SHARED,
+			"ST-DMA: floppy/ACSI/IDE/Falcon-SCSI", stdma_int))
+		pr_err("Couldn't register ST-DMA interrupt\n");
 }
 
 
diff --git a/arch/m68k/atari/time.c b/arch/m68k/atari/time.c
index 1edde27..d076ff8 100644
--- a/arch/m68k/atari/time.c
+++ b/arch/m68k/atari/time.c
@@ -31,8 +31,9 @@ atari_sched_init(irq_handler_t timer_routine)
     /* start timer C, div = 1:100 */
     mfp.tim_ct_cd = (mfp.tim_ct_cd & 15) | 0x60;
     /* install interrupt service routine for MFP Timer C */
-    request_irq(IRQ_MFP_TIMC, timer_routine, IRQ_TYPE_SLOW,
-                "timer", timer_routine);
+    if (request_irq(IRQ_MFP_TIMC, timer_routine, IRQ_TYPE_SLOW,
+		    "timer", timer_routine))
+	pr_err("Couldn't register timer interrupt\n");
 }
 
 /* ++andreas: gettimeoffset fixed to check for pending interrupt */
-- 
1.5.6.5

