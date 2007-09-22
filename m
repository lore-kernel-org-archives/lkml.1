Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbXIVWVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbXIVWVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 18:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbXIVWVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 18:21:04 -0400
Received: from khc.piap.pl ([195.187.100.11]:39490 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbXIVWVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 18:21:01 -0400
To: adaplas@gmail.com, sylvain.meyer@worldonline.fr, akpm@linux-foundation.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] Intel FB: obvious changes and corrections
References: <m33ax65ot6.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
In-Reply-To: <m33ax65ot6.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Sun, 23 Sep 2007 00:16:05 +0200")
Date: Sun, 23 Sep 2007 00:20:57 +0200
Message-ID: <m3tzpm4a0m.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Intel FB: obvious changes and corrections

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>

--- a/drivers/video/intelfb/intelfb.h
+++ b/drivers/video/intelfb/intelfb.h
@@ -355,7 +355,10 @@ struct intelfb_info {
 	struct intelfb_output_rec output[MAX_OUTPUTS];
 };
 
-#define IS_I9XX(dinfo) (((dinfo)->chipset == INTEL_915G)||(dinfo->chipset == INTEL_915GM)||((dinfo)->chipset == INTEL_945G)||(dinfo->chipset==INTEL_945GM))
+#define IS_I9XX(dinfo) (((dinfo)->chipset == INTEL_915G) ||	\
+			((dinfo)->chipset == INTEL_915GM) ||	\
+			((dinfo)->chipset == INTEL_945G) ||	\
+			((dinfo)->chipset==INTEL_945GM))
 
 #ifndef FBIO_WAITFORVSYNC
 #define FBIO_WAITFORVSYNC	_IOW('F', 0x20, __u32)
--- a/drivers/video/intelfb/intelfbhw.c
+++ b/drivers/video/intelfb/intelfbhw.c
@@ -434,14 +434,14 @@ void intelfbhw_setcolreg(struct intelfb_info *dinfo, unsigned regno,
 			 unsigned red, unsigned green, unsigned blue,
 			 unsigned transp)
 {
+	u32 palette_reg = (dinfo->pipe == PIPE_A) ?
+			  PALETTE_A : PALETTE_B;
+
 #if VERBOSE > 0
 	DBG_MSG("intelfbhw_setcolreg: %d: (%d, %d, %d)\n",
 		regno, red, green, blue);
 #endif
 
-	u32 palette_reg = (dinfo->pipe == PIPE_A) ?
-			  PALETTE_A : PALETTE_B;
-
 	OUTREG(palette_reg + (regno << 2),
 	       (red << PALETTE_8_RED_SHIFT) |
 	       (green << PALETTE_8_GREEN_SHIFT) |
@@ -1305,8 +1305,8 @@ int intelfbhw_program_mode(struct intelfb_info *dinfo,
 
 	count = 0;
 	do {
-		tmp_val[count%3] = INREG(0x70000);
-		if ((tmp_val[0] == tmp_val[1]) && (tmp_val[1]==tmp_val[2]))
+		tmp_val[count % 3] = INREG(PIPEA_DSL);
+		if ((tmp_val[0] == tmp_val[1]) && (tmp_val[1] == tmp_val[2]))
 			break;
 		count++;
 		udelay(1);
@@ -2004,7 +2004,6 @@ intelfbhw_enable_irq(struct intelfb_info *dinfo, int reenable) {
 
 void
 intelfbhw_disable_irq(struct intelfb_info *dinfo) {
-	u16 tmp;
 
 	if (test_and_clear_bit(0, &dinfo->irq_flags)) {
 		if (dinfo->vsync.pan_display) {
@@ -2016,8 +2015,7 @@ intelfbhw_disable_irq(struct intelfb_info *dinfo) {
 		OUTREG16(IMR, 0xffff);
 		OUTREG16(IER, 0x0);
 
-		tmp = INREG16(IIR);
-		OUTREG16(IIR, tmp);
+		OUTREG16(IIR, INREG16(IIR)); /* clear IRQ requests */
 		spin_unlock_irq(&dinfo->int_lock);
 
 		free_irq(dinfo->pdev->irq, dinfo);
--- a/drivers/video/intelfb/intelfbhw.h
+++ b/drivers/video/intelfb/intelfbhw.h
@@ -93,7 +93,7 @@
 #define IIR			0x20A4
 #define IMR			0x20A8
 #define VSYNC_PIPE_A_INTERRUPT		(1 << 7)
-#define PIPE_A_EVENT_INTERRUPT		(1 << 4)
+#define PIPE_A_EVENT_INTERRUPT		(1 << 6)
 #define VSYNC_PIPE_B_INTERRUPT		(1 << 5)
 #define PIPE_B_EVENT_INTERRUPT		(1 << 4)
 #define HOST_PORT_EVENT_INTERRUPT	(1 << 3)
@@ -276,6 +276,8 @@
 #define DVOB_SRCDIM		0x61144
 #define DVOC_SRCDIM		0x61164
 
+#define PIPEA_DSL		0x70000
+#define PIPEB_DSL		0x71000
 #define PIPEACONF		0x70008
 #define PIPEBCONF		0x71008
 #define PIPECONF_ENABLE			(1 << 31)
