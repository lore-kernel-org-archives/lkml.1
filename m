Return-Path: <linux-kernel-owner+w=401wt.eu-S1759093AbZABKrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093AbZABKrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbZABKmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:42:01 -0500
Received: from winston.telenet-ops.be ([195.130.137.75]:45073 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204AbZABKlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:39 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: dmasound - kill warn_unused_result warnings
Date: Fri,  2 Jan 2009 11:41:31 +0100
Message-Id: <1230892892-25751-19-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-18-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-4-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-5-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-6-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-7-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-8-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-9-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-10-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-11-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-12-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-13-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-14-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-15-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-16-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-17-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-18-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: ignoring return value of 'request_irq', declared with attribute
warn_unused_result

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 sound/oss/dmasound/dmasound_atari.c |    5 +++--
 sound/oss/dmasound/dmasound_q40.c   |   16 ++++++++++------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/sound/oss/dmasound/dmasound_atari.c b/sound/oss/dmasound/dmasound_atari.c
index 4d45bd6..57d9f15 100644
--- a/sound/oss/dmasound/dmasound_atari.c
+++ b/sound/oss/dmasound/dmasound_atari.c
@@ -851,8 +851,9 @@ static int __init AtaIrqInit(void)
 	mfp.tim_dt_a = 1;	/* Cause interrupt after first event. */
 	mfp.tim_ct_a = 8;	/* Turn on event counting. */
 	/* Register interrupt handler. */
-	request_irq(IRQ_MFP_TIMA, AtaInterrupt, IRQ_TYPE_SLOW, "DMA sound",
-		    AtaInterrupt);
+	if (request_irq(IRQ_MFP_TIMA, AtaInterrupt, IRQ_TYPE_SLOW, "DMA sound",
+			AtaInterrupt))
+		return 0;
 	mfp.int_en_a |= 0x20;	/* Turn interrupt on. */
 	mfp.int_mk_a |= 0x20;
 	return 1;
diff --git a/sound/oss/dmasound/dmasound_q40.c b/sound/oss/dmasound/dmasound_q40.c
index 1855b14..99bcb21 100644
--- a/sound/oss/dmasound/dmasound_q40.c
+++ b/sound/oss/dmasound/dmasound_q40.c
@@ -371,8 +371,9 @@ static void Q40Free(void *ptr, unsigned int size)
 static int __init Q40IrqInit(void)
 {
 	/* Register interrupt handler. */
-	request_irq(Q40_IRQ_SAMPLE, Q40StereoInterrupt, 0,
-		    "DMA sound", Q40Interrupt);
+	if (request_irq(Q40_IRQ_SAMPLE, Q40StereoInterrupt, 0,
+		    "DMA sound", Q40Interrupt))
+		return 0;
 
 	return(1);
 }
@@ -401,6 +402,7 @@ static void Q40PlayNextFrame(int index)
 	u_char *start;
 	u_long size;
 	u_char speed;
+	int error;
 
 	/* used by Q40Play() if all doubts whether there really is something
 	 * to be played are already wiped out.
@@ -419,11 +421,13 @@ static void Q40PlayNextFrame(int index)
 	master_outb( 0,SAMPLE_ENABLE_REG);
 	free_irq(Q40_IRQ_SAMPLE, Q40Interrupt);
 	if (dmasound.soft.stereo)
-	  	request_irq(Q40_IRQ_SAMPLE, Q40StereoInterrupt, 0,
-		    "Q40 sound", Q40Interrupt);
+		error = request_irq(Q40_IRQ_SAMPLE, Q40StereoInterrupt, 0,
+				    "Q40 sound", Q40Interrupt);
 	  else
-	        request_irq(Q40_IRQ_SAMPLE, Q40MonoInterrupt, 0,
-		    "Q40 sound", Q40Interrupt);
+		error = request_irq(Q40_IRQ_SAMPLE, Q40MonoInterrupt, 0,
+				    "Q40 sound", Q40Interrupt);
+	if (error && printk_ratelimit())
+		pr_err("Couldn't register sound interrupt\n");
 
 	master_outb( speed, SAMPLE_RATE_REG);
 	master_outb( 1,SAMPLE_CLEAR_REG);
-- 
1.5.6.5

