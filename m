Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYGYJCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYGYJCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbYGYJCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:02:06 -0400
Received: from dgate20.fujitsu-siemens.com ([80.70.172.51]:27274 "EHLO
	dgate20.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687AbYGYJCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:02:05 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:Content-Type;
  b=MbR0k9zfRPLIx9pACgrLIJ0K+C6nvuDWVw7Bq/XqXSghF9F5UB7OH1UW
   ooFqQszmA429txh+n8aRM7kHteeV0Af9OfmBvHTiQeZvEVZsuN3ouXwcS
   COW8UlXHAcf3OXs;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.31,252,1215381600"; 
   d="diff'?scan'208";a="21177649"
X-IronPort-AV: E=Sophos;i="4.31,251,1215381600"; 
   d="diff'?scan'208";a="32935004"
Message-ID: <4889968E.6020000@fujitsu-siemens.com>
Date: Fri, 25 Jul 2008 11:02:06 +0200
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe (take
 2)
References: <48885DDC.9010003@fujitsu-siemens.com> <20080724111631.GA3432@lenovo> <48886E6D.1030005@fujitsu-siemens.com> <20080724120512.GA21804@lenovo> <488889B6.9070707@fujitsu-siemens.com> <20080724143151.GA32422@lenovo> <20080724150116.GC32422@lenovo> <48889C14.4070408@fujitsu-siemens.com>
In-Reply-To: <48889C14.4070408@fujitsu-siemens.com>
Content-Type: multipart/mixed;
 boundary="------------080705040003040700010305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080705040003040700010305
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

I wrote:

> This patch fixes this by two separate measures:
>   a) make sure that no significant interruption occurs between APIC and
>      TSC reads
>   b) make sure that the measurement loop isn't significantly longer
>      than originally intended.

Here is a new, simplified version of our patch that only uses measure a).
We verified that this is sufficient for accurate calibration.

If we fail to determine the start or end time of the calibration 
correctly 10 times in a row, we will print a critical error message and 
go on. One might as well argue that this should cause a kernel panic (it 
is impossible to run on the CPU for only a few cycles without being 
interrupted by an SMI!), but Cyrill probably won't agree.

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

--------------080705040003040700010305
Content-Type: text/x-patch;
 name="calibrate_APIC_clock-4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="calibrate_APIC_clock-4.diff"

[PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe (take 2)

Non-maskable asynchronous events (e.g. SMIs) which occur during the APIC 
timer calibration can cause timer miscalibrations, sometimes by large amounts. 
This patch fixes this by making sure that no significant interruption occurs 
between APIC and TSC reads. SMIs may still occur at some stage in the 
calibration loop, causing the loop to last longer than intended. This 
doesn't matter though, as long as the start and end values are both 
taken simultaneously.

Signed-off-by: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Signed-off-by: Gerhard Wichert <gerhard.wichert@fujitsu-siemens.com>

--- arch/x86/kernel/apic_64.c	2008-07-25 10:45:09.000000000 +0200
+++ arch/x86/kernel/apic_64.c.new	2008-07-25 10:45:19.000000000 +0200
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
 
@@ -331,23 +356,25 @@ static void __init calibrate_APIC_clock(
 	 */
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

--------------080705040003040700010305--
