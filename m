Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbZF3ApH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbZF3ApH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZF3Ao6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:44:58 -0400
Received: from fanir.ucs.ualberta.ca ([129.128.8.200]:33111 "EHLO
	fanir.ucs.ualberta.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZF3Ao5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:44:57 -0400
X-Greylist: delayed 1579 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jun 2009 20:44:57 EDT
Date: Mon, 29 Jun 2009 18:07:02 -0600 (MDT)
From: Marc Aurele La France <root@ualberta.ca>
X-X-Sender: root@fanir.ucs.ualberta.ca
To: stable@kernel.org
cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@linux.intel.com>, Research.Support@ualberta.ca
Subject: [PATCH] x86, setup (2.6.30-stable) fix 80x34 and 80x60 console
 modes
Message-ID: <alpine.BSO.1.10.0906291746410.14658@fanir.ucs.ualberta.ca>
User-Agent: Alpine 1.10 (BSO 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As coded, most INT10 calls in video-vga.c allow the compiler to assume EAX 
remains unchanged across them, which is not always the case.  This 
triggers an optimisation issue that causes vga_set_vertical_end() to be 
called with an incorrect number of scanlines.  Fix this by beefing up the 
asm constraints on these calls.

Reported-by: Marc Aurele La France <tsi@xfree86.org>
Signed-off-by: Marc Aurele La France <tsi@xfree86.org>
Acked-by: H. Peter Anvin <hpa@zytor.com>

diff -adNpru linux-2.6.30/arch/x86/boot/video-vga.c devel-2.6.30/arch/x86/boot/video-vga.c
--- linux-2.6.30/arch/x86/boot/video-vga.c	2009-06-10 12:33:53.000000000 -0600
+++ devel-2.6.30/arch/x86/boot/video-vga.c	2009-06-25 13:35:16.000000000 -0600
@@ -45,8 +45,10 @@ static u8 vga_set_basic_mode(void)

 #ifdef CONFIG_VIDEO_400_HACK
 	if (adapter >= ADAPTER_VGA) {
+		ax = 0x1202;
 		asm volatile(INT10
-			     : : "a" (0x1202), "b" (0x0030)
+			     : "+a" (ax)
+			     : "b" (0x0030)
 			     : "ecx", "edx", "esi", "edi");
 	}
 #endif
@@ -81,44 +83,59 @@ static u8 vga_set_basic_mode(void)

 static void vga_set_8font(void)
 {
+	u16 ax;
+
 	/* Set 8x8 font - 80x43 on EGA, 80x50 on VGA */

 	/* Set 8x8 font */
-	asm volatile(INT10 : : "a" (0x1112), "b" (0));
+	ax = 0x1112;
+	asm volatile(INT10 : "+a" (ax) : "b" (0));

 	/* Use alternate print screen */
-	asm volatile(INT10 : : "a" (0x1200), "b" (0x20));
+	ax = 0x1200;
+	asm volatile(INT10 : "+a" (ax) : "b" (0x20));

 	/* Turn off cursor emulation */
-	asm volatile(INT10 : : "a" (0x1201), "b" (0x34));
+	ax = 0x1201;
+	asm volatile(INT10 : "+a" (ax) : "b" (0x34));

 	/* Cursor is scan lines 6-7 */
-	asm volatile(INT10 : : "a" (0x0100), "c" (0x0607));
+	ax = 0x0100;
+	asm volatile(INT10 : "+a" (ax) : "c" (0x0607));
 }

 static void vga_set_14font(void)
 {
+	u16 ax;
+
 	/* Set 9x14 font - 80x28 on VGA */

 	/* Set 9x14 font */
-	asm volatile(INT10 : : "a" (0x1111), "b" (0));
+	ax = 0x1111;
+	asm volatile(INT10 : "+a" (ax) : "b" (0));

 	/* Turn off cursor emulation */
-	asm volatile(INT10 : : "a" (0x1201), "b" (0x34));
+	ax = 0x1201;
+	asm volatile(INT10 : "+a" (ax) : "b" (0x34));

 	/* Cursor is scan lines 11-12 */
-	asm volatile(INT10 : : "a" (0x0100), "c" (0x0b0c));
+	ax = 0x0100;
+	asm volatile(INT10 : "+a" (ax) : "c" (0x0b0c));
 }

 static void vga_set_80x43(void)
 {
+	u16 ax;
+
 	/* Set 80x43 mode on VGA (not EGA) */

 	/* Set 350 scans */
-	asm volatile(INT10 : : "a" (0x1201), "b" (0x30));
+	ax = 0x1201;
+	asm volatile(INT10 : "+a" (ax) : "b" (0x30));

 	/* Reset video mode */
-	asm volatile(INT10 : : "a" (0x0003));
+	ax = 0x0003;
+	asm volatile(INT10 : "+a" (ax));

 	vga_set_8font();
 }
@@ -225,7 +242,7 @@ static int vga_set_mode(struct mode_info
  */
 static int vga_probe(void)
 {
-	u16 ega_bx;
+	u16 ax, ega_bx;

 	static const char *card_name[] = {
 		"CGA/MDA/HGC", "EGA", "VGA"
@@ -242,9 +259,10 @@ static int vga_probe(void)
 	};
 	u8 vga_flag;

+	ax = 0x1200;
 	asm(INT10
-	    : "=b" (ega_bx)
-	    : "a" (0x1200), "b" (0x10) /* Check EGA/VGA */
+	    : "+a" (ax), "=b" (ega_bx)
+	    : "b" (0x10) /* Check EGA/VGA */
 	    : "ecx", "edx", "esi", "edi");

 #ifndef _WAKEUP

Marc.

+----------------------------------+----------------------------------+
|  Marc Aurele La France           |  work:   1-780-492-9310          |
|  Academic Information and        |  fax:    1-780-492-1729          |
|    Communications Technologies   |  email:  tsi@ualberta.ca         |
|  352 General Services Building   +----------------------------------+
|  University of Alberta           |                                  |
|  Edmonton, Alberta               |    Standard disclaimers apply    |
|  T6G 2H1                         |                                  |
|  CANADA                          |                                  |
+----------------------------------+----------------------------------+
XFree86 developer and VP.  ATI driver and X server internals.
