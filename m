Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbYBQV5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbYBQV5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbYBQV4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:56:49 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:11294 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbYBQV4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:56:42 -0500
Date: Sun, 17 Feb 2008 16:56:39 -0500 (EST)
Message-Id: <6gr00g$g7cm9p@smtp01.lnh.mail.rcn.net>
From: "David P. Reed" <dpreed@reed.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, "David P. Reed" <dpreed@reed.com>
Subject: [PATCH 2/3] x86: fix cmos read and write to not use inb_p and outb_p
Content-Disposition: inline; filename=fix-rtc-iodelay.patch
X-Junkmail-Status: score=10/50, host=mr08.lnh.mail.rcn.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A010207.47B8AD98.003C,ss=1,fgs=0,
	ip=207.172.4.11,
	so=2007-10-30 19:00:17,
	dmn=5.4.3/2007-11-16
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix code to access CMOS rtc registers so that it does not use inb_p and
outb_p routines, which are deprecated.  Extensive research on all known CMOS RTC
chipset timing shows that there is no need for a delay in accessing the
registers of these chips even on old machines. These chipa are never on an
expansion bus, but have always been "motherboard" resources, either in the
processor chipset or explicitly on the motherboard, and they are not part of 
the ISA/LPC or PCI buses, so delays should not be based on bus timing.
The reason to fix it:
1) port 80 writes often hang some laptops that use ENE EC chipsets, esp. those
designed and manufactured by Quanta for HP;
2) RTC accesses are timing sensitive, and extra microseconds may matter;
3) the new "io_delay" function is calibrated by expansion bus timing needs,
thus is not appropriate for access to CMOS rtc registers.

Signed-off-by: David P. Reed <dpreed@reed.com>
Index: linux-2.6/arch/x86/kernel/rtc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/rtc.c
+++ linux-2.6/arch/x86/kernel/rtc.c
@@ -151,8 +151,8 @@ unsigned char rtc_cmos_read(unsigned cha
 	unsigned char val;
 
 	lock_cmos_prefix(addr);
-	outb_p(addr, RTC_PORT(0));
-	val = inb_p(RTC_PORT(1));
+	outb(addr, RTC_PORT(0));
+	val = inb(RTC_PORT(1));
 	lock_cmos_suffix(addr);
 	return val;
 }
@@ -161,8 +161,8 @@ EXPORT_SYMBOL(rtc_cmos_read);
 void rtc_cmos_write(unsigned char val, unsigned char addr)
 {
 	lock_cmos_prefix(addr);
-	outb_p(addr, RTC_PORT(0));
-	outb_p(val, RTC_PORT(1));
+	outb(addr, RTC_PORT(0));
+	outb(val, RTC_PORT(1));
 	lock_cmos_suffix(addr);
 }
 EXPORT_SYMBOL(rtc_cmos_write);

-- 
