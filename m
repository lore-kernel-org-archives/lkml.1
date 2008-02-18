Return-Path: <linux-kernel-owner+w=401wt.eu-S1758413AbYBRPGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbYBRPGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYBRPGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:06:13 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:42612 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbYBRPGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:06:10 -0500
Date: Mon, 18 Feb 2008 10:06:07 -0500 (EST)
Message-Id: <6gr00g$g7mc7l@smtp01.lnh.mail.rcn.net>
From: "David P. Reed" <dpreed@reed.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, "David P. Reed" <dpreed@reed.com>
Subject: [patch 2/2] x86: use explicit timing delay for pit accesses
Content-Disposition: inline; filename=fix-pit-and-spkr-iodelay.patch
X-Junkmail-Status: score=10/50, host=mr08.lnh.mail.rcn.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A010208.47B99EE0.00DB,ss=1,fgs=0,
	ip=207.172.4.11,
	so=2007-10-30 19:00:17,
	dmn=5.4.3/2007-11-16
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pit accesses in i8253.c and pcspkr driver use outb_p for timing.
Fix them to use explicit timing delay for access to PIT,
rather than inb_p/outb_p calls, which use insufficiently explicit
delays (defaulting to port 80 writes) that can cause freeze problems
on some machines, such as Quanta moterboard  machines using ENE EC's.

The explicit timing delay is only needed in pcspkr for accesses to the 8253 PIT.
Fix pcspkr driver to use the new outb_pic call properly, use
named port values rather than hex constants, and drop its use of
inb_p and outb_p in accessing port 61h where it has never been needed.

Signed-off-by: David P. Reed <dpreed@reed.com>

Index: linux-2.6/drivers/input/misc/pcspkr.c
===================================================================
--- linux-2.6.orig/drivers/input/misc/pcspkr.c
+++ linux-2.6/drivers/input/misc/pcspkr.c
@@ -36,6 +36,7 @@ static int pcspkr_event(struct input_dev
 {
 	unsigned int count = 0;
 	unsigned long flags;
+	unsigned char port61;
 
 	if (type != EV_SND)
 		return -1;
@@ -51,17 +52,18 @@ static int pcspkr_event(struct input_dev
 
 	spin_lock_irqsave(&i8253_lock, flags);
 
+	port61 = inb(0x61);
 	if (count) {
 		/* enable counter 2 */
-		outb_p(inb_p(0x61) | 3, 0x61);
+		outb(port61 | 3, 0x61);
 		/* set command for counter 2, 2 byte write */
-		outb_p(0xB6, 0x43);
+		outb_pit(0xB6, PIT_MODE);
 		/* select desired HZ */
-		outb_p(count & 0xff, 0x42);
-		outb((count >> 8) & 0xff, 0x42);
+		outb_pit(count & 0xff, PIT_CH2);
+		outb((count >> 8) & 0xff, PIT_CH2);
 	} else {
 		/* disable counter 2 */
-		outb(inb_p(0x61) & 0xFC, 0x61);
+		outb(port61 & 0xFC, 0x61);
 	}
 
 	spin_unlock_irqrestore(&i8253_lock, flags);
Index: linux-2.6/arch/x86/kernel/i8253.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/i8253.c
+++ linux-2.6/arch/x86/kernel/i8253.c
@@ -31,6 +31,27 @@ static inline void pit_disable_clocksour
 struct clock_event_device *global_clock_event;
 
 /*
+ * define the PIT specific port access routines, which define the timing
+ * needed by the PIT registers on some platforms.
+ */
+unsigned char inb_pit(unsigned int port)
+{
+	/* delay for some accesses to PIC on motherboard or in chipset must be
+	   at least one microsecond, but be safe here. */
+	unsigned char value = inb(port);
+	udelay(2);
+	return value;
+}
+
+void outb_pit(unsigned char value, unsigned int port)
+{
+	/* delay for some accesses to PIC on motherboard or in chipset must be
+	   at least one microsecond, but be safe here. */
+	outb(value, port);
+	udelay(2);
+}
+
+/*
  * Initialize the PIT timer.
  *
  * This is also called after resume to bring the PIT into operation again.
Index: linux-2.6/include/asm-x86/i8253.h
===================================================================
--- linux-2.6.orig/include/asm-x86/i8253.h
+++ linux-2.6/include/asm-x86/i8253.h
@@ -12,7 +12,9 @@ extern struct clock_event_device *global
 
 extern void setup_pit_timer(void);
 
-#define inb_pit		inb_p
-#define outb_pit	outb_p
+/* accesses to PIT registers need careful delays on some platforms. Define
+   them here in a common place */
+extern unsigned char inb_pit(unsigned int port);
+extern void outb_pit(unsigned char value, unsigned int port);
 
 #endif	/* __ASM_I8253_H__ */

-- 
