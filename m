Return-Path: <linux-kernel-owner+w=401wt.eu-S1765275AbXKOBPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765275AbXKOBPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 20:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbXKOBPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 20:15:04 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:63714 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954AbXKOBPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 20:15:01 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 209.94.135.27
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18zsGTH86xTJAWy8jdETC94
Message-ID: <473B9D8A.5000006@reed.com>
Date: Wed, 14 Nov 2007 20:14:50 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
CC: Allessandro Zummo <a.zummo@towertech.it>, Matt Mackall <mpm@selenic.com>
Subject: [PATCH] x86: on x86_64, correct reading of PC RTC when update in
 progress in time_64.c
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>	 <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>	 <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>	 <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos>
In-Reply-To: <1184274754.12353.254.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Correct potentially unstable PC RTC time register reading in time_64.c

Stop the use of an incorrect technique for reading the standard PC RTC
timer, which is documented to "disconnect" time registers from the bus
while updates are in progress.  The use of UIP flag while interrupts
are disabled to protect a 244 microsecond window is one of the
Motorola spec sheet's documented ways to read the RTC time registers
reliably.

The patch updates the misleading comments and also minimizes the amount of
time that the kernel disables interrupts during the reading.

Signed-off-by: David P. Reed <dpreed@reed.com>
---
Index: linux-2.6/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_64.c
+++ linux-2.6/arch/x86/kernel/time_64.c
@@ -160,22 +160,30 @@ unsigned long read_persistent_clock(void
  	unsigned long flags;
  	unsigned century = 0;

-	spin_lock_irqsave(&rtc_lock, flags);
+ retry:	spin_lock_irqsave(&rtc_lock, flags);
+	/* if UIP is clear, then we have >= 244 microseconds before RTC
+	 * registers will be updated.  Spec sheet says that this is the
+	 * reliable way to read RTC - registers invalid (off bus) during update
+	 */
+	if ((CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP)) {
+	  spin_unlock_irqrestore(&rtc_lock, flags);
+	  cpu_relax();
+	  goto retry;
+	}

-	do {
-		sec = CMOS_READ(RTC_SECONDS);
-		min = CMOS_READ(RTC_MINUTES);
-		hour = CMOS_READ(RTC_HOURS);
-		day = CMOS_READ(RTC_DAY_OF_MONTH);
-		mon = CMOS_READ(RTC_MONTH);
-		year = CMOS_READ(RTC_YEAR);
+	/* now read all RTC registers while stable with interrupts disabled */
+
+	sec = CMOS_READ(RTC_SECONDS);
+	min = CMOS_READ(RTC_MINUTES);
+	hour = CMOS_READ(RTC_HOURS);
+	day = CMOS_READ(RTC_DAY_OF_MONTH);
+	mon = CMOS_READ(RTC_MONTH);
+	year = CMOS_READ(RTC_YEAR);
  #ifdef CONFIG_ACPI
-		if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
-					acpi_gbl_FADT.century)
-			century = CMOS_READ(acpi_gbl_FADT.century);
+	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
+				acpi_gbl_FADT.century)
+		century = CMOS_READ(acpi_gbl_FADT.century);
  #endif
-	} while (sec != CMOS_READ(RTC_SECONDS));
-
  	spin_unlock_irqrestore(&rtc_lock, flags);

  	/*


