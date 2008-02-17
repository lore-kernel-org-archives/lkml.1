Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbYBQVRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbYBQVRs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbYBQVRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:17:38 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:6010 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbYBQVRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:17:36 -0500
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2008 16:17:36 EST
Date: Sun, 17 Feb 2008 16:08:15 -0500 (EST)
From: <dpreed@reed.com>
Message-Id: <200802172108.JRY53925@mr08.lnh.mail.rcn.net>
X-Junkmail-Status: score=10/50, host=mr08.lnh.mail.rcn.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A010201.47B8A23F.004E,ss=1,fgs=0,
	ip=207.172.4.11,
	so=2007-10-30 19:00:17,
	dmn=5.4.3/2007-11-16
X-Junkmail-IWF: false
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From David P. Reed <dpreed@reed.com> Sat Feb 16 15:05:17 2008
Message-Id: <20080216200517.384525783@reed.com>>
References: <20080216200517.113862251@reed.com>>
User-Agent: quilt/0.46-1
Date: Sat, 16 Feb 2008 15:05:19 -0500
From: David P. Reed <dpreed@reed.com>
To: Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org,
 "David P. Reed" <dpreed@reed.com>
Subject: [PATCH 2/3] x86: fix cmos read and write to not use inb_p and outb_p
Content-Disposition: inline; filename=fix-rtc-iodelay.patch

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
