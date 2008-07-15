Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbYGORJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbYGORJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757253AbYGORJC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:09:02 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:16421 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316AbYGORJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:09:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=Rl2ICumKEx5DIN8oCY2gzLQqJEIUISu2FWNanzwzJMaQWeJT9y7z3zFFKsyN7Y1KDt
         Ol3jyGd8SA6EFdLOzlc3WeDQ+uSIHCQYPa8fiPFeFeQ00RJSGXEbeZhv9TSHapLU6/GF
         rP5RStCQQdfSIr8aqWSDW6TO+ZMRRdF2yYUEA=
References: <20080715170253.921844144@gmail.com>>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 21:02:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, macro@linux-mips.org,
       yhlu.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 1/2] x86: apic_64 - make calibrate_APIC_clock to return error code
Content-Disposition: inline; filename=cvgapic-calibrate-64
Message-ID: <487cd9a9.165b4e0a.0709.2148@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make calibration_result to return error and check calibration_result
to be sufficient inside calibrate_APIC_clock.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_64.c	2008-07-15 19:44:28.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_64.c	2008-07-15 19:51:01.000000000 +0400
@@ -314,7 +314,7 @@ static void setup_APIC_timer(void)
 
 #define TICK_COUNT 100000000
 
-static void __init calibrate_APIC_clock(void)
+static int __init calibrate_APIC_clock(void)
 {
 	unsigned apic, apic_start;
 	unsigned long tsc, tsc_start;
@@ -368,6 +368,17 @@ static void __init calibrate_APIC_clock(
 		clockevent_delta2ns(0xF, &lapic_clockevent);
 
 	calibration_result = result / HZ;
+
+	/*
+	 * Do a sanity check on the APIC calibration result
+	 */
+	if (calibration_result < (1000000 / HZ)) {
+		printk(KERN_WARNING
+			"APIC frequency too slow, disabling apic timer\n");
+		return -1;
+	}
+
+	return 0;
 }
 
 /*
@@ -394,14 +405,7 @@ void __init setup_boot_APIC_clock(void)
 	}
 
 	printk(KERN_INFO "Using local APIC timer interrupts.\n");
-	calibrate_APIC_clock();
-
-	/*
-	 * Do a sanity check on the APIC calibration result
-	 */
-	if (calibration_result < (1000000 / HZ)) {
-		printk(KERN_WARNING
-		       "APIC frequency too slow, disabling apic timer\n");
+	if (calibrate_APIC_clock()) {
 		/* No broadcast on UP ! */
 		if (num_possible_cpus() > 1)
 			setup_APIC_timer();

-- 
