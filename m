Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbYHNSse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbYHNSse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbYHNSq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:46:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:55419 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbYHNSqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:46:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=MW5BEpptaDV/VNgSaKukpw4076hpS0iQiVrAK6QmehypzcwAeFB8uhFdoEsajW5ot0
         g/RoB9hSNY7LebPuhXTix0vX8tVE9k/HFxfaL6ENSNfJCHOPIgPZG85spqgQkEB9A3Y1
         qNwJkxs8yRVzCP5+L9ZIZDJQmlfU4Oqx0y6Ig=
Message-Id: <20080814184652.022151205@gmail.com>
References: <20080814183428.550709025@gmail.com>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: macro@linux-mips.org, mingo@elte.hu, tglx@linutronix.de
Cc: hpa@zytor.com, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 5/8] x86: apic - get rid of local_apic_timer_verify_ok
Content-Disposition: inline; filename=x86-apic-get-rid-of-local_apic_timer_verify_ok.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are able to use clock_event_device as it's done in
64bit apic code so lets get rid of local_apic_timer_verify_ok
variable.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-08-14 22:16:01.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-08-14 22:18:00.000000000 +0400
@@ -60,8 +60,6 @@ unsigned long mp_lapic_addr;
 static int force_enable_local_apic;
 int disable_apic;
 
-/* Local APIC timer verification ok */
-static int local_apic_timer_verify_ok;
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
 static int disable_apic_timer __cpuinitdata;
 /* Local APIC timer works in C2 */
@@ -301,7 +299,7 @@ static void lapic_timer_setup(enum clock
 	unsigned int v;
 
 	/* Lapic used for broadcast ? */
-	if (!local_apic_timer_verify_ok)
+	if (evt->features & CLOCK_EVT_FEAT_DUMMY)
 		return;
 
 	local_irq_save(flags);
@@ -514,7 +512,7 @@ static int __init calibrate_APIC_clock(v
 		return -1;
 	}
 
-	local_apic_timer_verify_ok = 1;
+	levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
 
 	/* We trust the pm timer based calibration */
 	if (!pm_referenced) {
@@ -548,11 +546,11 @@ static int __init calibrate_APIC_clock(v
 		if (deltaj >= LAPIC_CAL_LOOPS-2 && deltaj <= LAPIC_CAL_LOOPS+2)
 			apic_printk(APIC_VERBOSE, "... jiffies result ok\n");
 		else
-			local_apic_timer_verify_ok = 0;
+			levt->features |= CLOCK_EVT_FEAT_DUMMY;
 	} else
 		local_irq_enable();
 
-	if (!local_apic_timer_verify_ok) {
+	if (levt->features & CLOCK_EVT_FEAT_DUMMY) {
 		printk(KERN_WARNING
 		       "APIC timer disabled due to verification failure.\n");
 			return -1;

-- 
