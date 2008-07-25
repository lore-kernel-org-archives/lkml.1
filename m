Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbYGYPN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbYGYPN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbYGYPNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:13:18 -0400
Received: from dgate20.fujitsu-siemens.com ([80.70.172.51]:40893 "EHLO
	dgate20.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbYGYPNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:13:17 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:Content-Type;
  b=CK5Lw+u2ADM47cVnXo/IPai447bv3xUN9pZrmCwMv3zsX3ISDSCe65RT
   PNidkvOSJrZcWRc81QcjHJfwmzSyC3WL8FRgqozARAgXvBRt6m5847T8W
   GE+v4EnuCwnV5pF;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.31,252,1215381600"; 
   d="diff'?scan'208";a="21235800"
X-IronPort-AV: E=Sophos;i="4.31,252,1215381600"; 
   d="diff'?scan'208";a="32955967"
Message-ID: <4889ED91.7050800@fujitsu-siemens.com>
Date: Fri, 25 Jul 2008 17:13:21 +0200
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe (take
 3)
References: <20080724143151.GA32422@lenovo> <20080724150116.GC32422@lenovo> <48889C14.4070408@fujitsu-siemens.com> <4889968E.6020000@fujitsu-siemens.com> <20080725100844.GA16698@lenovo> <4889C723.7050402@fujitsu-siemens.com> <20080725125950.GA28466@lenovo> <4889D767.5050709@fujitsu-siemens.com> <20080725134831.GB28466@lenovo> <4889DCA4.4010800@fujitsu-siemens.com> <20080725150104.GD28466@lenovo>
In-Reply-To: <20080725150104.GD28466@lenovo>
Content-Type: multipart/mixed;
 boundary="------------060209070302030003050102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060209070302030003050102
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Cyrill Gorcunov wrote:
> Martin, it seems you forgot to attach the patch :) 

I am sorry, here it is. Thanks :)

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

--------------060209070302030003050102
Content-Type: text/x-patch;
 name="calibrate_APIC_clock-4a.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="calibrate_APIC_clock-4a.diff"

[PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe (take 3)

Non-maskable asynchronous events (e.g. SMIs) which occur during the APIC 
timer calibration can cause timer miscalibrations, sometimes by large amounts. 
This patch fixes this by making sure that no significant interruption occurs 
between APIC and TSC reads. SMIs may still occur at some stage in the 
calibration loop, causing the loop to last longer than intended. This 
doesn't matter though, as long as the start and end values are both 
taken simultaneously.

Changed wrt take 2: Use max. possible start value for the APIC timer 
to avoid underflow.

Signed-off-by: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Signed-off-by: Gerhard Wichert <gerhard.wichert@fujitsu-siemens.com>

--- arch/x86/kernel/apic_64.c	2008-07-25 15:39:51.000000000 +0200
+++ arch/x86/kernel/apic_64.c.new	2008-07-25 15:55:08.000000000 +0200
@@ -300,6 +300,31 @@ static void setup_APIC_timer(void)
 }
 
 /*
+ * Helper function for calibrate_APIC_clock(): Make sure that
+ * APIC TMCTT and TSC are read at the same time, to reasonable
+ * accuracy. On any sane system, the retry loop won't need more
+ * than a single retry, given that the rdtsc/apic_read/rdtsc
+ * sequence won't take more than a few cycles.
+ */
+
+#define MAX_DIFFERENCE 1000UL
+#define MAX_ITER 10
+static inline int
+__read_tsc_and_apic(unsigned long *tsc, unsigned *apic)
+{
+	unsigned long tsc0, tsc1, diff;
+	int i = 0;
+	do {
+		rdtscll(tsc0);
+		*apic = apic_read(APIC_TMCCT);
+		rdtscll(tsc1);
+		diff = tsc1 - tsc0;
+	} while (diff > MAX_DIFFERENCE && ++i < MAX_ITER); 
+	*tsc = tsc0 + (diff >> 1);
+	return diff > MAX_DIFFERENCE ? -EIO : 0;
+}
+
+/*
  * In this function we calibrate APIC bus clocks to the external
  * timer. Unfortunately we cannot use jiffies and the timer irq
  * to calibrate, since some later bootup code depends on getting
@@ -318,7 +343,7 @@ static void __init calibrate_APIC_clock(
 {
 	unsigned apic, apic_start;
 	unsigned long tsc, tsc_start;
-	int result;
+	int result, err_start, err;
 
 	local_irq_disable();
 
@@ -329,25 +354,27 @@ static void __init calibrate_APIC_clock(
 	 *
 	 * No interrupt enable !
 	 */
-	__setup_APIC_LVTT(250000000, 0, 0);
+	__setup_APIC_LVTT(0xffffffff, 0, 0);
 
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
+		err_start = __read_tsc_and_apic(&tsc_start, &apic_start);
 
 		do {
-			apic = apic_read(APIC_TMCCT);
-			rdtscll(tsc);
+			err = __read_tsc_and_apic(&tsc, &apic);
 		} while ((tsc - tsc_start) < TICK_COUNT &&
 				(apic_start - apic) < TICK_COUNT);
 
+		if (err_start || err)
+			printk(KERN_CRIT "calibrate_APIC_clock: SMI flood - "
+				"the APIC timer calibration may be wrong!\n");
 		result = (apic_start - apic) * 1000L * tsc_khz /
 					(tsc - tsc_start);
 	}

--------------060209070302030003050102--
