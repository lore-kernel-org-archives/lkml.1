Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbXENWBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbXENWBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXENWBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:01:49 -0400
Received: from www.osadl.org ([213.239.205.134]:48012 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754848AbXENWBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:01:48 -0400
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v1
From: Thomas Gleixner <tglx@linutronix.de>
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200705142215.08910.s0348365@sms.ed.ac.uk>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <200705140217.11515.s0348365@sms.ed.ac.uk>
	 <1179138368.22481.334.camel@localhost.localdomain>
	 <200705142215.08910.s0348365@sms.ed.ac.uk>
Content-Type: text/plain
Date: Tue, 15 May 2007 00:05:14 +0200
Message-Id: <1179180314.7074.36.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 22:15 +0100, Alistair John Strachan wrote:
> On Monday 14 May 2007 11:26:08 Thomas Gleixner wrote:
> > I'm pleased to announce an updated version of the x86_64 highres/dyntick
> > support patches against 2.6.22-rc1:
> [snip]
> > - Various fixups from Chris Wright
> > - TSC calibration fix (pointed out by Alistair John Strachan)
> >
> > Comments, bugreports, patches are welcome as ususal
> 
> Neither of the bugs I reported appear to be fixed.
> 
> I took a clean git tree from the 2.6.22-rc1 tag and patched with this version; 
> my CPU MHz and dmesg counter still appear to be broken (v3 was used).

Sigh. /me feels stupid.

Can you please apply the following patch on top and check, whether it
fixes the problem ? Please provide the debug output, when it fails.

Thanks,

	tglx

Index: linux-2.6.21/arch/x86_64/kernel/tsc.c
===================================================================
--- linux-2.6.21.orig/arch/x86_64/kernel/tsc.c
+++ linux-2.6.21/arch/x86_64/kernel/tsc.c
@@ -135,7 +135,7 @@ static unsigned long __init tsc_read_ref
 	for (i = 0; i < MAX_RETRIES; i++) {
 		t1 = get_cycles_sync();
 		if (hpet)
-			*hpet = hpet_readl(HPET_COUNTER);
+			*hpet = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
 		else
 			*pm = acpi_pm_read_early();
 		t2 = get_cycles_sync();
@@ -177,8 +177,10 @@ void __init tsc_calibrate(void)
 	tsc_khz = (tr2 - tr1) / 50;
 
 	/* hpet or pmtimer available ? */
-	if (!hpet && !pm1 && !pm2)
+	if (!hpet && !pm1 && !pm2) {
+		printk(KERN_INFO "TSC calibrated against tick interrupt\n");
 		return;
+	}
 
 	/* Check, whether the sampling was disturbed by an SMI */
 	if (tsc1 == ULONG_MAX || tsc2 == ULONG_MAX) {
@@ -190,14 +192,25 @@ void __init tsc_calibrate(void)
 	tsc2 = (tsc2 - tsc1) * 1000000000L;
 
 	if (hpet) {
-		hpet2 = (hpet2 - hpet1) & 0xFFFFFFFF;
+		printk(KERN_INFO "TSC calibrated against hpet %ld %ld",
+		       hpet1, hpet2);
+		if (hpet2 < hpet1)
+			hpet2 += 0x100000000;
+		hpet2 -= hpet1;
 		tsc1 = (hpet2 * hpet_readl(HPET_PERIOD)) / 1000;
+		printk(" %lu %lu\n", hpet2, tsc1);
 	} else {
-		pm2 = (pm2 -pm1) & ACPI_PM_MASK;
+		printk(KERN_INFO "TSC calibrated against pm_timer %ld %ld",
+		       pm1, pm2);
+		if (pm2 < pm1)
+			pm2 += ACPI_PM_OVRRUN;
+		pm2 -= pm1;
 		tsc1 = (pm2 * PMTMR_TICKS_PER_SEC) / 1000;
+		printk(" %lu %lu\n", pm2, tsc1);
 	}
 
 	tsc_khz = tsc2 / tsc1;
+	printk(KERN_INFO "tsckhz: %lu %lu %u\n", tsc2, tsc1, tsc_khz);
 }
 
 /*


