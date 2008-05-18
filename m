Return-Path: <linux-kernel-owner+w=401wt.eu-S1763258AbYERTEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763258AbYERTEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761938AbYERSyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:54:21 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:35490 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761936AbYERSyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:54:06 -0400
Message-Id: <20080518185152.437771120@mail.of.borg>
References: <20080518184706.631023070@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 May 2008 20:47:17 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: [patch 11/18] m68k: Some input drivers do not check the platform
Content-Disposition: inline; filename=m68k-input-drivers-break-multiplatform.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

Some input drivers do not check whether they're actually running on the
correct platform, causing multi-platform kernels to crash if they are not.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/input/keyboard/hilkbd.c  |    4 ++++
 drivers/input/misc/hp_sdc_rtc.c  |    5 +++++
 drivers/input/serio/hp_sdc_mlc.c |    5 +++++
 3 files changed, 14 insertions(+)

--- a/drivers/input/keyboard/hilkbd.c
+++ b/drivers/input/keyboard/hilkbd.c
@@ -217,6 +217,10 @@ hil_keyb_init(void)
 		return -ENOMEM;
 
 #if defined(CONFIG_HP300)
+	if (!MACH_IS_HP300) {
+		err = -ENODEV;
+		goto err1;
+	}
 	if (!hwreg_present((void *)(HILBASE + HIL_DATA))) {
 		printk(KERN_ERR "HIL: hardware register was not found\n");
 		err = -ENODEV;
--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -691,6 +691,11 @@ static int __init hp_sdc_rtc_init(void)
 {
 	int ret;
 
+#ifdef __mc68000__
+	if (!MACH_IS_HP300)
+		return -ENODEV;
+#endif
+
 	init_MUTEX(&i8042tregs);
 
 	if ((ret = hp_sdc_request_timer_irq(&hp_sdc_rtc_isr)))
--- a/drivers/input/serio/hp_sdc_mlc.c
+++ b/drivers/input/serio/hp_sdc_mlc.c
@@ -306,6 +306,11 @@ static int __init hp_sdc_mlc_init(void)
 {
 	hil_mlc *mlc = &hp_sdc_mlc;
 
+#ifdef __mc68000__
+	if (!MACH_IS_HP300)
+		return -ENODEV;
+#endif
+
 	printk(KERN_INFO PREFIX "Registering the System Domain Controller's HIL MLC.\n");
 
 	hp_sdc_mlc_priv.emtestmode = 0;

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

