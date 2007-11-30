Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbXLFMyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbXLFMyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbXLFMoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:44:24 -0500
Received: from nic2.axis.se ([193.13.178.10]:45010 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067AbXLFMoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:44:22 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <9ab653be05d474d8803c89c135c00e1b0039612c.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 17:16:09 +0100
Subject: [PATCH 35/47] Update CRISv32 boot/compressed/misc.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Shorten include paths to machine specific headers.
- Remove fill_inbuf, not defined here.
- Return __dest as value from memcpy.
- Enable serial port hardware transmitter and receiver in serial_setup.
- Correct baudrate divisor calculation, changed from 4800 to 115200.
- Add support for Artpec-3 specific serial port setup.
- Initialize pinmux for the correct serial port.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/boot/compressed/misc.c |   72 +++++++++++++++++++++--------
 1 files changed, 53 insertions(+), 19 deletions(-)

diff --git a/arch/cris/arch-v32/boot/compressed/misc.c b/arch/cris/arch-v32/boot/compressed/misc.c
index 0169ba1..55b2695 100644
--- a/arch/cris/arch-v32/boot/compressed/misc.c
+++ b/arch/cris/arch-v32/boot/compressed/misc.c
@@ -1,8 +1,6 @@
 /*
  * misc.c
  *
- * $Id: misc.c,v 1.8 2005/04/24 18:34:29 starvik Exp $
- *
  * This is a collection of several routines from gzip-1.0.3
  * adapted for Linux.
  *
@@ -22,9 +20,13 @@
 
 
 #include <linux/types.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/hwregs/reg_map.h>
-#include <asm/arch/hwregs/ser_defs.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/ser_defs.h>
+#include <hwregs/pinmux_defs.h>
+#ifdef CONFIG_CRIS_MACH_ARTPEC3
+#include <hwregs/clkgen_defs.h>
+#endif
 
 /*
  * gzip declarations
@@ -85,7 +87,6 @@ static unsigned outcnt = 0;  /* bytes in output buffer */
 #  define Tracecv(c,x)
 #endif
 
-static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
 static void gzip_mark(void **);
@@ -186,6 +187,8 @@ memset(void* s, int c, size_t n)
 	char *ss = (char*)s;
 
 	for (i=0;i<n;i++) ss[i] = c;
+
+	return s;
 }
 
 void*
@@ -196,6 +199,8 @@ memcpy(void* __dest, __const void* __src,
 	char *d = (char *)__dest, *s = (char *)__src;
 
 	for (i=0;i<__n;i++) d[i] = s[i];
+
+	return __dest;
 }
 
 /* ===========================================================================
@@ -225,15 +230,15 @@ flush_window()
 static void
 error(char *x)
 {
-	puts("\n\n");
+	puts("\r\n\n");
 	puts(x);
-	puts("\n\n -- System halted\n");
+	puts("\r\n\n -- System halted\n");
 
 	while(1);	/* Halt */
 }
 
 void
-setup_normal_output_buffer()
+setup_normal_output_buffer(void)
 {
 	output_data = (char *)KERNEL_LOAD_ADR;
 }
@@ -262,15 +267,17 @@ serial_setup(reg_scope_instances regi_ser)
 	rec_baud = REG_RD(ser, regi_ser, rw_rec_baud_div);
 
 	tr_ctrl.stop_bits = 1;	/* 2 stop bits. */
+	tr_ctrl.en = 1; /* enable transmitter */
+	rec_ctrl.en = 1; /* enabler receiver */
 
 	/*
-	 * The baudrate setup is a bit fishy, but in the end the transceiver is
-	 * set to 4800 and the receiver to 115200. The magic value is
-	 * 29.493 MHz.
+	 * The baudrate setup used to be a bit fishy, but now transmitter and
+	 * receiver are both set to the intended baud rate, 115200.
+	 * The magic value is 29.493 MHz.
 	 */
 	tr_ctrl.base_freq = regk_ser_f29_493;
 	rec_ctrl.base_freq = regk_ser_f29_493;
-	tr_baud.div = (29493000 / 8) / 4800;
+	tr_baud.div = (29493000 / 8) / 115200;
 	rec_baud.div = (29493000 / 8) / 115200;
 
 	REG_WR(ser, regi_ser, rw_tr_ctrl, tr_ctrl);
@@ -280,25 +287,52 @@ serial_setup(reg_scope_instances regi_ser)
 }
 
 void
-decompress_kernel()
+decompress_kernel(void)
 {
 	char revision;
 
-	/* input_data is set in head.S */
-	inbuf = input_data;
+#if defined(CONFIG_ETRAX_DEBUG_PORT1) || \
+    defined(CONFIG_ETRAX_DEBUG_PORT2) || \
+    defined(CONFIG_ETRAX_DEBUG_PORT3)
+	reg_pinmux_rw_hwprot hwprot;
+
+#ifdef CONFIG_CRIS_MACH_ARTPEC3
+	reg_clkgen_rw_clk_ctrl clk_ctrl;
+
+	/* Enable corresponding clock region when serial 1..3 selected */
+
+	clk_ctrl = REG_RD(clkgen, regi_clkgen, rw_clk_ctrl);
+	clk_ctrl.sser_ser_dma6_7 = regk_clkgen_yes;
+	REG_WR(clkgen, regi_clkgen, rw_clk_ctrl, clk_ctrl);
+#endif
+
+	/* pinmux setup for ports 1..3 */
+	hwprot = REG_RD(pinmux, regi_pinmux, rw_hwprot);
+#endif
 
 #ifdef CONFIG_ETRAX_DEBUG_PORT0
 	serial_setup(regi_ser0);
 #endif
 #ifdef CONFIG_ETRAX_DEBUG_PORT1
+	hwprot.ser1 = regk_pinmux_yes;
 	serial_setup(regi_ser1);
 #endif
 #ifdef CONFIG_ETRAX_DEBUG_PORT2
+	hwprot.ser2 = regk_pinmux_yes;
 	serial_setup(regi_ser2);
 #endif
 #ifdef CONFIG_ETRAX_DEBUG_PORT3
+	hwprot.ser3 = regk_pinmux_yes;
 	serial_setup(regi_ser3);
 #endif
+#if defined(CONFIG_ETRAX_DEBUG_PORT1) || \
+    defined(CONFIG_ETRAX_DEBUG_PORT2) || \
+    defined(CONFIG_ETRAX_DEBUG_PORT3)
+	REG_WR(pinmux, regi_pinmux, rw_hwprot, hwprot);
+#endif
+
+	/* input_data is set in head.S */
+	inbuf = input_data;
 
 	setup_normal_output_buffer();
 
@@ -307,11 +341,11 @@ decompress_kernel()
 	__asm__ volatile ("move $vr,%0" : "=rm" (revision));
 	if (revision < 32)
 	{
-		puts("You need an ETRAX FS to run Linux 2.6/crisv32.\n");
+		puts("You need an ETRAX FS to run Linux 2.6/crisv32.\r\n");
 		while(1);
 	}
 
-	puts("Uncompressing Linux...\n");
+	puts("Uncompressing Linux...\r\n");
 	gunzip();
-	puts("Done. Now booting the kernel.\n");
+	puts("Done. Now booting the kernel.\r\n");
 }
-- 
1.5.3.6.970.gd25430

