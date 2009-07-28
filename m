Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbZG1XxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbZG1XxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbZG1Xu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:26 -0400
Received: from kroah.org ([198.145.64.141]:35879 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbZG1XuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:17 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:59 2009
Message-Id: <20090728234159.070814850@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
       Research.Support@ualberta.ca, Marc Aurele La France <tsi@xfree86.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 49/71] x86, setup (2.6.30-stable) fix 80x34 and 80x60 console modes
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=x86-setup-fix-80x34-and-80x60-console-modes.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marc Aurele La France <root@ualberta.ca>

Note: this is not in upstream since upstream is not affected due to the
      new "BIOS glovebox" subsystem.

As coded, most INT10 calls in video-vga.c allow the compiler to assume
EAX remains unchanged across them, which is not always the case.  This
triggers an optimisation issue that causes vga_set_vertical_end() to be
called with an incorrect number of scanlines.  Fix this by beefing up
the asm constraints on these calls.

Reported-by: Marc Aurele La France <tsi@xfree86.org>
Signed-off-by: Marc Aurele La France <tsi@xfree86.org>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/boot/video-vga.c |   44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

--- a/arch/x86/boot/video-vga.c
+++ b/arch/x86/boot/video-vga.c
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


