Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbXEUPnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbXEUPnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbXEUPnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:43:33 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:62808 "EHLO
	outbound4-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755684AbXEUPnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:43:32 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "LKML" <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: [PATCH] -rt fix TSC calibration from PM Timer
Date: Mon, 21 May 2007 17:43:09 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Message-ID: <200705211743.10402.joachim.deguara@amd.com>
X-OriginalArrivalTime: 21 May 2007 15:43:11.0979 (UTC)
 FILETIME=[BCF7B3B0:01C79BBE]
X-WSS-ID: 6A4F61991SK2305818-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The code to calibrate TSC frequency from the PM timer does not work on my 
laptop with the 2.6.21-rt5.

[    0.247815] time.c: Detected 62117.606 MHz processor.

The code looks to be copied from the calibration from HPET but unfortunately 
it reports frequency instead of period in femtoseconds as the HPET does.  I 
also rearranged the math to make the femtoseconds and kHz clearer but it does 
loose a negligible amount of precision.

Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>

Index: 2.6-rt/arch/x86_64/kernel/tsc.c
===================================================================
--- 2.6-rt.orig/arch/x86_64/kernel/tsc.c
+++ 2.6-rt/arch/x86_64/kernel/tsc.c
@@ -187,14 +187,14 @@ void __init tsc_calibrate(void)
 		return;
 	}
 
-	tsc2 = (tsc2 - tsc1) * 1000000000L;
+	tsc2 = tsc2 - tsc1;
 
 	if (hpet) {
 		hpet2 = (hpet2 - hpet1) & 0xFFFFFFFF;
-		tsc1 = (hpet2 * hpet_readl(HPET_PERIOD)) / 1000;
+		tsc1 = hpet2 * hpet_readl(HPET_PERIOD) / 1e12;
 	} else {
 		pm2 = (pm2 -pm1) & ACPI_PM_MASK;
-		tsc1 = (pm2 * PMTMR_TICKS_PER_SEC) / 1000;
+		tsc1 = (pm2 * 1e3) / PMTMR_TICKS_PER_SEC;
 	}
 
 	tsc_khz = tsc2 / tsc1;


