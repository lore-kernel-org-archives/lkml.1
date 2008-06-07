Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbYFGGj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbYFGGj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 02:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYFGGjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 02:39:17 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:46908 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760547AbYFGGjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 02:39:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=z0cVjw2/r26akNwrixFHL21I/5A1lcjI7TF2cLzsTop0IrEKu0ZKwtjODpr2cHAQvQfTG+Av7mU2VM3DsVE5Kd5Y+RwtmpednQbCj5txgDtdzPZfkyTm+hOgZSeiGzbPoxqtqoEJFdTFoF0t9GrUOhIDGc1f+oV9f6RRPVeD1UM=  ;
X-YMail-OSG: h6.HKjwVM1lfUK2lLbVs.b2fXk2_7.8PjxJM65hQkKyAjAE5UpfmtOc3G58TVDmOmKWE8P4ubc2kV8GMkfXE9TyH2wA3MuCippmUpLvb1rJ8o5clT0faE4Eq4r4ZM.3ZRcA-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Andrew Victor" <avictor.za@gmail.com>
Subject: Re: AT91SAM9/CAP9 watchdog driver
Date: Fri, 6 Jun 2008 23:39:13 -0700
User-Agent: KMail/1.9.9
Cc: linux-arm-kernel@lists.arm.linux.org.uk, akpm@linux-foundation.org,
       wim@iguana.be, Linux Kernel list <linux-kernel@vger.kernel.org>
References: <cd73a99e0806010940g501f11b4jcb7caf6acfd5c49f@mail.gmail.com>
In-Reply-To: <cd73a99e0806010940g501f11b4jcb7caf6acfd5c49f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806062339.13418.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought I'd finally get around to trying this driver.
No luck.

The proximate cause is that Atmel's second stage "at91boot"
loader disables the watchdog.  That's because the reset state
of this watchdog is "reset after 16 seconds" ... so it must
be tended carefully until the Linux "watchdog" daemon takes
over.  Since there's no code in at91boot, U-Boot, or Linux to
do that, it gets disabled.  (How was this driver tested??)

Needless to say, this isn't exactly my model of how to make
a useful watchdog.  That "write once" rule is pure trouble.

I suggest merging the following patch, to reduce confusion.

- Dave


======== CUT HERE
The at91sam9 watchdog is a kind of annoying bit of hardware:  since its
mode register is write-once, it can't be reconfigured.  Moreover, Atmel's
standard second stage loader "at91boot" always this watchdog (at least
on Atmel's reference boards), ensuring that Linux normally can't use it.

This patch removes some confusion by not registering the watchdog device
on systems where it was disabled before Linux starts.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- a/arch/arm/mach-at91/at91sam9260_devices.c	2008-06-06 15:00:06.000000000 -0700
+++ b/arch/arm/mach-at91/at91sam9260_devices.c	2008-06-06 20:40:38.000000000 -0700
@@ -21,6 +21,7 @@
 #include <asm/arch/at91sam9260.h>
 #include <asm/arch/at91sam9260_matrix.h>
 #include <asm/arch/at91sam9_smc.h>
+#include <asm/arch/at91_wdt.h>
 
 #include "generic.h"
 
@@ -666,6 +667,9 @@ static struct platform_device at91sam926
 
 static void __init at91_add_device_watchdog(void)
 {
+	/* WDT_MR is write-once; if it was disabled, we're stuck */
+	if (at91_sys_read(AT91_WDT_MR) & AT91_WDT_WDDIS)
+		return;
 	platform_device_register(&at91sam9260_wdt_device);
 }
 #else
--- a/arch/arm/mach-at91/at91sam9261_devices.c	2008-06-06 15:00:06.000000000 -0700
+++ b/arch/arm/mach-at91/at91sam9261_devices.c	2008-06-06 20:40:45.000000000 -0700
@@ -25,6 +25,7 @@
 #include <asm/arch/at91sam9261.h>
 #include <asm/arch/at91sam9261_matrix.h>
 #include <asm/arch/at91sam9_smc.h>
+#include <asm/arch/at91_wdt.h>
 
 #include "generic.h"
 
@@ -654,6 +655,9 @@ static struct platform_device at91sam926
 
 static void __init at91_add_device_watchdog(void)
 {
+	/* WDT_MR is write-once; if it was disabled, we're stuck */
+	if (at91_sys_read(AT91_WDT_MR) & AT91_WDT_WDDIS)
+		return;
 	platform_device_register(&at91sam9261_wdt_device);
 }
 #else
--- a/arch/arm/mach-at91/at91sam9263_devices.c	2008-06-06 15:00:06.000000000 -0700
+++ b/arch/arm/mach-at91/at91sam9263_devices.c	2008-06-06 20:40:48.000000000 -0700
@@ -24,6 +24,7 @@
 #include <asm/arch/at91sam9263.h>
 #include <asm/arch/at91sam9263_matrix.h>
 #include <asm/arch/at91sam9_smc.h>
+#include <asm/arch/at91_wdt.h>
 
 #include "generic.h"
 
@@ -911,6 +912,9 @@ static struct platform_device at91sam926
 
 static void __init at91_add_device_watchdog(void)
 {
+	/* WDT_MR is write-once; if it was disabled, we're stuck */
+	if (at91_sys_read(AT91_WDT_MR) & AT91_WDT_WDDIS)
+		return;
 	platform_device_register(&at91sam9263_wdt_device);
 }
 #else
--- a/arch/arm/mach-at91/at91sam9rl_devices.c	2008-06-06 15:00:06.000000000 -0700
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c	2008-06-06 20:40:52.000000000 -0700
@@ -21,6 +21,7 @@
 #include <asm/arch/at91sam9rl.h>
 #include <asm/arch/at91sam9rl_matrix.h>
 #include <asm/arch/at91sam9_smc.h>
+#include <asm/arch/at91_wdt.h>
 
 #include "generic.h"
 
@@ -501,6 +502,9 @@ static struct platform_device at91sam9rl
 
 static void __init at91_add_device_watchdog(void)
 {
+	/* WDT_MR is write-once; if it was disabled, we're stuck */
+	if (at91_sys_read(AT91_WDT_MR) & AT91_WDT_WDDIS)
+		return;
 	platform_device_register(&at91sam9rl_wdt_device);
 }
 #else


