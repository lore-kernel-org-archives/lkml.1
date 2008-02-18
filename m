Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYBRPGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYBRPGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYBRPGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:06:11 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:42612 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbYBRPGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:06:09 -0500
Date: Mon, 18 Feb 2008 10:06:04 -0500 (EST)
Message-Id: <6gr00g$g7mc5k@smtp01.lnh.mail.rcn.net>
From: "David P. Reed" <dpreed@reed.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, "David P. Reed" <dpreed@reed.com>
Subject: [patch 1/2] x86: define outb_pic and inb_pic to stop using outb_p and inb_p
Content-Disposition: inline; filename=fix-8259-iodelay.patch
X-Junkmail-Status: score=10/50, host=mr08.lnh.mail.rcn.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A01020A.47B99EDC.0030,ss=1,fgs=0,
	ip=207.172.4.11,
	so=2007-10-30 19:00:17,
	dmn=5.4.3/2007-11-16
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The delay between io port accesses to the PIC is now defined using outb_pic
and inb_pic.  This fix provides the next step, using udelay(2) to define the
*PIC specific* timing requirements, rather than on bus-oriented timing, which
is not well calibrated.

Again, the primary reason for fixing this is to use proper delay strategy,
and in particular to fix crashes that can result from using port 80 writes
on machines that have resources on port 80, such as the ENE chips used by Quanta
in latops it designs and sells to, e.g. HP.

Signed-off-by: David P. Reed <dpreed@reed.com>
Index: linux-2.6/arch/x86/kernel/i8259_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/i8259_32.c
+++ linux-2.6/arch/x86/kernel/i8259_32.c
@@ -277,6 +277,23 @@ static int __init i8259A_init_sysfs(void
 
 device_initcall(i8259A_init_sysfs);
 
+unsigned char inb_pic(unsigned int port)
+{
+	/* delay for some accesses to PIC on motherboard or in chipset must be
+	   at least one microsecond, but be safe here. */
+	unsigned char value = inb(port);
+	udelay(2);
+	return value;
+}
+
+void outb_pic(unsigned char value, unsigned int port)
+{
+	/* delay for some accesses to PIC on motherboard or in chipset must be
+	   at least one microsecond, but be safe here. */
+	outb(value, port);
+	udelay(2);
+}
+
 void init_8259A(int auto_eoi)
 {
 	unsigned long flags;
Index: linux-2.6/arch/x86/kernel/i8259_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/i8259_64.c
+++ linux-2.6/arch/x86/kernel/i8259_64.c
@@ -347,6 +347,23 @@ static int __init i8259A_init_sysfs(void
 
 device_initcall(i8259A_init_sysfs);
 
+unsigned char inb_pic(unsigned int port)
+{
+	/* delay for some accesses to PIC on motherboard or in chipset must be
+	   at least one microsecond, but be safe here. */
+	unsigned char value = inb(port);
+	udelay(2);
+	return value;
+}
+
+void outb_pic(unsigned char value, unsigned int port)
+{
+	/* delay for some accesses to PIC on motherboard or in chipset must be
+	   at least one microsecond, but be safe here. */
+	outb(value, port);
+	udelay(2);
+}
+
 void init_8259A(int auto_eoi)
 {
 	unsigned long flags;
Index: linux-2.6/include/asm-x86/i8259.h
===================================================================
--- linux-2.6.orig/include/asm-x86/i8259.h
+++ linux-2.6/include/asm-x86/i8259.h
@@ -28,8 +28,8 @@ extern void init_8259A(int auto_eoi);
 extern void enable_8259A_irq(unsigned int irq);
 extern void disable_8259A_irq(unsigned int irq);
 extern unsigned int startup_8259A_irq(unsigned int irq);
-
-#define inb_pic		inb_p
-#define outb_pic	outb_p
+/* the PIC may need a careful delay on some platforms, hence specific calls */
+extern unsigned char inb_pic(unsigned int port);
+extern void outb_pic(unsigned char value, unsigned int port);
 
 #endif	/* __ASM_I8259_H__ */

-- 
