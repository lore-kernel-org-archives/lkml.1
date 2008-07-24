Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYGXK5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYGXK5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYGXK5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:57:39 -0400
Received: from dgate10.fujitsu-siemens.com ([80.70.172.49]:10220 "EHLO
	dgate10.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308AbYGXK5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:57:38 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jul 2008 06:57:38 EDT
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:Content-Type;
  b=LMLSgmJf88fcySjTgjI+odMKwAXGYNUiy9idQ0Kffk/w64Rdyrk/f31O
   F+XnDNrlBVWFsaVZ31Da6P9tSsF53Ad9FtW0rIA0fe0RdnYPPzNKvxcJN
   YhZAxkD0Ylu2ap0;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.31,245,1215381600"; 
   d="diff'?scan'208";a="23370554"
X-IronPort-AV: E=Sophos;i="4.31,245,1215381600"; 
   d="diff'?scan'208";a="32895531"
Message-ID: <48885DDC.9010003@fujitsu-siemens.com>
Date: Thu, 24 Jul 2008 12:47:56 +0200
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>
Subject: [PATCH] x86 (64): make calibrate_APIC_clock() smp-safe
Content-Type: multipart/mixed;
 boundary="------------040905090605060207010108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040905090605060207010108
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Thomas and Peter, hi everyone,

Asynchrounous events (e.g.SMIs) which occur during the APIC timer 
calibration can cause timer miscalibrations, sometimes by large amounts.

This patch fixes this by two separate measures:
   a) make sure that no significant interruption occurs between APIC and
      TSC reads
   b) make sure that the measurement loop isn't significantly longer
      than originally intended.

I am sorry, due to a misconfiguration of our SMTP server I need to send 
the patch as attachment.

Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DEV 6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 8 15113
Fax:			++49 5251 8 20209
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html

--------------040905090605060207010108
Content-Type: text/x-patch;
 name="calibrate_APIC_clock-1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="calibrate_APIC_clock-1.diff"

Patch: make calibrate_APIC_clock() SMI-safe

Asynchrounous events (e.g.SMIs) which occur during the APIC timer calibration
can cause timer miscalibrations, sometimes by large amounts. This patch fixes
this by two separate measures:
  a) make sure that no significant interruption occurs between APIC and 
     TSC reads
  b) make sure that the measurement loop isn't significantly longer 
     than originally intended.

Signed-off-by: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Signed-off-by: Gerhard Wichert <gerhard.wichert@fujitsu-siemens.com>

--- linux-2.6.26/arch/x86/kernel/apic_64.c	2008-07-13 23:51:29.000000000 +0200
+++ linux-2.6.26/arch/x86/kernel/apic_64.c.new	2008-07-24 11:41:24.000000000 +0200
@@ -314,6 +314,19 @@ static void setup_APIC_timer(void)
 
 #define TICK_COUNT 100000000
 
+#define MAX_DIFFERENCE 1000UL
+static inline void __read_tsc_and_apic(unsigned long *tsc, unsigned *apic)
+{
+	unsigned long tsc0, tsc1, diff;
+	do {
+		rdtscll(tsc0);
+		*apic = apic_read(APIC_TMCCT);
+		rdtscll(tsc1);
+		diff = tsc1 - tsc0;
+	} while (diff > MAX_DIFFERENCE);
+	*tsc = tsc0 + (diff >> 1);
+}
+
 static void __init calibrate_APIC_clock(void)
 {
 	unsigned apic, apic_start;
@@ -329,25 +342,37 @@ static void __init calibrate_APIC_clock(
 	 *
 	 * No interrupt enable !
 	 */
+smi_occured:
 	__setup_APIC_LVTT(250000000, 0, 0);
 
-	apic_start = apic_read(APIC_TMCCT);
 #ifdef CONFIG_X86_PM_TIMER
 	if (apic_calibrate_pmtmr && pmtmr_ioport) {
+		apic_start = apic_read(APIC_TMCCT);
 		pmtimer_wait(5000);  /* 5ms wait */
 		apic = apic_read(APIC_TMCCT);
 		result = (apic_start - apic) * 1000L / 5;
 	} else
 #endif
 	{
-		rdtscll(tsc_start);
+		__read_tsc_and_apic(&tsc_start, &apic_start);
 
 		do {
-			apic = apic_read(APIC_TMCCT);
-			rdtscll(tsc);
+			__read_tsc_and_apic(&tsc, &apic);
 		} while ((tsc - tsc_start) < TICK_COUNT &&
 				(apic_start - apic) < TICK_COUNT);
 
+		/*
+		 * If this takes significantly longer than TICK_COUNT,
+		 * some interruption must have occured - retry.
+		 */
+		if ((tsc - tsc_start) > (TICK_COUNT + TICK_COUNT/1000) ||
+		    (apic_start - apic) > (TICK_COUNT + TICK_COUNT/1000)) {
+			printk(KERN_ERR
+			       "calibrate_APIC_clock: SMI occured? %lx %x",
+			       tsc - tsc_start, apic_start - apic);
+			goto smi_occured;
+		}
+
 		result = (apic_start - apic) * 1000L * tsc_khz /
 					(tsc - tsc_start);
 	}

--------------040905090605060207010108--
