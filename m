Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbXKLSmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbXKLSmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 13:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbXKLSmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 13:42:16 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:50413 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbXKLSmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 13:42:15 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.127
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/xKDrUAntp4rlEBmNqzra9
Message-ID: <47388586.7010509@reed.com>
Date: Mon, 12 Nov 2007 11:55:34 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
CC: Allessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH] x86: fix locking and sync bugs in x86_64 RTC code in time_64.c
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>	 <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>	 <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>	 <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos>
In-Reply-To: <1184274754.12353.254.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David P. Reed

Fix two bugs in arch/x86/kernel/time_64.c that affect the x86_64 kernel. 
1) a repeatable hard freeze due to interrupts when the ntpd service 
calls update_persistent_clock(), 2) potentially unstable PC RTC timer 
values when timer is read.

Signed-off-by: David P. Reed <dpreed@reed.com>
---
More explanation:
1) A repeatable but randomly timed freeze has been happening in Fedora 6 
and 7 for the last year, whenever I run the ntpd service on my AMD64x2 
HP Pavilion dv9000z laptop.  This freeze is due to the use of 
spin_lock(&rtc_lock) under the assumption (per a bad comment) that 
set_rtc_mmss is called only with interrupts disabled.  The call from 
ntp.c to update_persistent_clock is made with interrupts enabled.

2) the use of an incorrect technique for reading the standard PC RTC 
timer, which is documented to "disconnect" time registers from the bus 
while updates are in progress.  The use of UIP flag while interrupts are 
disabled to protect a 244 microsecond window is one of the Motorola spec 
sheet's documented ways to read the RTC time registers reliably.  I 
realize that not all "clones" of the

The patch updates the misleading comments and minimizes the amount of 
time that the kernel disables interrupts.

I have thoroughly tested this patch on a number of x86_64 machines with 
various numbers of cores and chipsets, using 2.6.24rc2 kernel source. 
Note that while testing the ntp code I found another bug in 
kernel/time/ntp.c which is independent of this fix - neither patch 
requires the other.

If possible, I'd love to see the patch merged with 2.6.24, and even with 
2.6.23.

Index: linux-2.6/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_64.c
+++ linux-2.6/arch/x86/kernel/time_64.c
@@ -82,13 +82,12 @@ static int set_rtc_mmss(unsigned long no
     int retval = 0;
     int real_seconds, real_minutes, cmos_minutes;
     unsigned char control, freq_select;
+    unsigned long flags;
 
-/*
- * IRQs are disabled when we're called from the timer interrupt,
- * no need for spin_lock_irqsave()
+/*
+ * set_rtc_mmss is called when irqs are enabled, so disable irqs here
  */
-
-    spin_lock(&rtc_lock);
+    spin_lock_irqsave(&rtc_lock, flags);
 
 /*
  * Tell the clock it's being set and stop it.
@@ -138,7 +137,7 @@ static int set_rtc_mmss(unsigned long no
     CMOS_WRITE(control, RTC_CONTROL);
     CMOS_WRITE(freq_select, RTC_FREQ_SELECT);
 
-    spin_unlock(&rtc_lock);
+    spin_unlock_irqrestore(&rtc_lock, flags);
 
     return retval;
 }
@@ -163,22 +162,30 @@ unsigned long read_persistent_clock(void
     unsigned long flags;
     unsigned century = 0;
 
-    spin_lock_irqsave(&rtc_lock, flags);
+ retry:    spin_lock_irqsave(&rtc_lock, flags);
+    /* if UIP is clear, then we have >= 244 microseconds before RTC
+     * registers will be updated.  Spec sheet says that this is the
+     * reliable way to read RTC - registers invalid (off bus) during update
+         */
+    if ((CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP)) {
+      spin_unlock_irqrestore(&rtc_lock, flags);
+      cpu_relax();
+      goto retry;
+    }
 
-    do {
-        sec = CMOS_READ(RTC_SECONDS);
-        min = CMOS_READ(RTC_MINUTES);
-        hour = CMOS_READ(RTC_HOURS);
-        day = CMOS_READ(RTC_DAY_OF_MONTH);
-        mon = CMOS_READ(RTC_MONTH);
-        year = CMOS_READ(RTC_YEAR);
+    /* now read all RTC registers while stable with interrupts disabled */
+
+    sec = CMOS_READ(RTC_SECONDS);
+    min = CMOS_READ(RTC_MINUTES);
+    hour = CMOS_READ(RTC_HOURS);
+    day = CMOS_READ(RTC_DAY_OF_MONTH);
+    mon = CMOS_READ(RTC_MONTH);
+    year = CMOS_READ(RTC_YEAR);
 #ifdef CONFIG_ACPI
-        if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
-                    acpi_gbl_FADT.century)
-            century = CMOS_READ(acpi_gbl_FADT.century);
+    if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
+                acpi_gbl_FADT.century)
+        century = CMOS_READ(acpi_gbl_FADT.century);
 #endif
-    } while (sec != CMOS_READ(RTC_SECONDS));
-
     spin_unlock_irqrestore(&rtc_lock, flags);
 
     /*







