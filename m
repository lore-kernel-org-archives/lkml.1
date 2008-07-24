Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbYGXNzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbYGXNzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbYGXNzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:55:06 -0400
Received: from dgate10.fujitsu-siemens.com ([80.70.172.49]:25385 "EHLO
	dgate10.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbYGXNzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:55:02 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:Content-Type;
  b=Yy7P8hX0MVJND/XlY4L4Q3CmB4gvKPhn15rU+jC3Wd/KATUkLRc0Lkpw
   DHc3ggFHgDPFTKTxpJ7D04GX4uHJROCR4pUmHYyq/n4xJh+H9FjTj9tBQ
   SezjkUvtNGBhMeD;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.31,245,1215381600"; 
   d="diff'?scan'208";a="23410882"
X-IronPort-AV: E=Sophos;i="4.31,245,1215381600"; 
   d="diff'?scan'208";a="36320273"
Message-ID: <488889B6.9070707@fujitsu-siemens.com>
Date: Thu, 24 Jul 2008 15:55:02 +0200
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
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe
References: <48885DDC.9010003@fujitsu-siemens.com> <20080724111631.GA3432@lenovo> <48886E6D.1030005@fujitsu-siemens.com> <20080724120512.GA21804@lenovo>
In-Reply-To: <20080724120512.GA21804@lenovo>
Content-Type: multipart/mixed;
 boundary="------------090006050909090809030409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090006050909090809030409
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Cyrill Gorcunov wrote:

> yes, it will issue some effects but it's better then stuck there.
> More over in 'case of SMI flood with current patch you don't get
> error message printed i think so you better add max iteration
> counter so user will see on console (or whatever) that he is got
> problems.
>                 - Cyrill -

I disagree. If you have a system that generates SMIs in this extreme 
frequency, you're better off stuck than running on such an unstable 
system. The user _will_ see messages on the console if this happens. 
Note that apparently there are few people who have trouble with this. We 
did see problems, but never had more than 1 SMI disturbing the 
calibration procedure.

Anyway, here is another patch that defines max iteration counts. I 
haven't added a "Signed-off:" line, because I prefer the original version.

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

--------------090006050909090809030409
Content-Type: text/x-patch;
 name="calibrate_APIC_clock-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="calibrate_APIC_clock-2.diff"

--- arch/x86/kernel/apic_64.c	2008-07-24 15:25:30.000000000 +0200
+++ arch/x86/kernel/apic_64.c.new	2008-07-24 15:26:13.000000000 +0200
@@ -314,11 +314,35 @@ static void setup_APIC_timer(void)
 
 #define TICK_COUNT 100000000
 
+#define MAX_DIFFERENCE 1000UL
+#define MAX_ITER 10
+#define MAX_CALIBRATIONS 10
+static inline int
+__read_tsc_and_apic(unsigned long *tsc, unsigned *apic)
+{
+	unsigned long tsc0, tsc1, diff;
+	int i;
+	for (i = 0; i < MAX_ITER; i++) {
+		rdtscll(tsc0);
+		*apic = apic_read(APIC_TMCCT);
+		rdtscll(tsc1);
+		diff = tsc1 - tsc0;
+		if (diff <= MAX_DIFFERENCE)
+			break;
+	}
+	*tsc = tsc0 + (diff >> 1);
+	if (i == MAX_ITER) {
+		printk(KERN_ERR "unable to read TSC abd APIC simultaneously\n");
+		return -EIO;
+	}
+	return 0;
+}
+
 static void __init calibrate_APIC_clock(void)
 {
 	unsigned apic, apic_start;
 	unsigned long tsc, tsc_start;
-	int result;
+	int result, cnt = 0, err_start, err;
 
 	local_irq_disable();
 
@@ -329,25 +353,41 @@ static void __init calibrate_APIC_clock(
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
-
+		err_start = __read_tsc_and_apic(&tsc_start, &apic_start);
 		do {
-			apic = apic_read(APIC_TMCCT);
-			rdtscll(tsc);
+			err = __read_tsc_and_apic(&tsc, &apic);
 		} while ((tsc - tsc_start) < TICK_COUNT &&
 				(apic_start - apic) < TICK_COUNT);
 
+		/*
+		 * If this takes significantly longer than TICK_COUNT,
+		 * some interruption must have occured - retry.
+		 */
+		if (err_start || err || 
+			(tsc - tsc_start) > (TICK_COUNT + TICK_COUNT/1000) ||
+		    	(apic_start - apic) > (TICK_COUNT + TICK_COUNT/1000)) {
+			printk(KERN_ERR
+			       "calibrate_APIC_clock: SMI occured? %lx %x\n",
+			       tsc - tsc_start, apic_start - apic);
+			if (++cnt < MAX_CALIBRATIONS)
+				goto smi_occured;
+			else
+				printk(KERN_CRIT
+				"calibrate_APIC_clock: SMI flood - "
+				"the APIC timer calibration may be wrong!\n");
+		}
 		result = (apic_start - apic) * 1000L * tsc_khz /
 					(tsc - tsc_start);
 	}

--------------090006050909090809030409--
