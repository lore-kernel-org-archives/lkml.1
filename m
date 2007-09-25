Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbXIYNSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbXIYNSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 09:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbXIYNR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 09:17:57 -0400
Received: from www.osadl.org ([213.239.205.134]:37704 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750826AbXIYNR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 09:17:56 -0400
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325,
	related to clockevents
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200709251516.58405.rjw@sisk.pl>
References: <200709231257.12213.rjw@sisk.pl>
	 <200709242111.07806.rjw@sisk.pl> <1190661212.4035.242.camel@chaos>
	 <200709251516.58405.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 15:17:53 +0200
Message-Id: <1190726273.4035.331.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 15:16 +0200, Rafael J. Wysocki wrote:
> > > There seems to be a history effect in the box, to make things more
> > > "interesting".
> > 
> > Did you connect this box to Andrews VAIO during KS ?
> 
> No, but it's famous for being interestingly broken nevertheless.

:)

> > > I think the only solid data point so far is that "noapictimer" makes the box
> > > boot.
> > 
> > Ok. Can you add "nmi_watchdog=1" to the command line please. This runs
> > through the calibration of APIC, but registers it as a dummy clock
> > source (the PIT must run to make the watchdog work).
> > 
> > If it boots, please provide the output of /proc/timer_list
> 
> No, it doesn't.

I start to get desperate. Below is a patch, which moves the apic timer
disable check after the calibration routine. Can you please apply on top
of -hrt and add "noapictimer" to the command line ? Does it boot ?

	tglx

Index: linux-2.6.23-rc7/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.23-rc7.orig/arch/x86_64/kernel/apic.c	2007-09-24 20:30:00.000000000 +0200
+++ linux-2.6.23-rc7/arch/x86_64/kernel/apic.c	2007-09-25 15:05:32.000000000 +0200
@@ -927,6 +927,7 @@ static void __init calibrate_APIC_clock(
 
 void __init setup_boot_APIC_clock (void)
 {
+#if 0
 	/*
 	 * The local apic timer can be disabled via the kernel commandline.
 	 * Register the lapic timer as a dummy clock event source on SMP
@@ -940,7 +941,7 @@ void __init setup_boot_APIC_clock (void)
 			setup_APIC_timer();
 		return;
 	}
-
+#endif
 	printk(KERN_INFO "Using local APIC timer interrupts.\n");
 	calibrate_APIC_clock();
 
@@ -949,11 +950,13 @@ void __init setup_boot_APIC_clock (void)
 	 * PIT/HPET going.  Otherwise register lapic as a dummy
 	 * device.
 	 */
-	if (nmi_watchdog != NMI_IO_APIC)
+	if (!disable_apic_timer && nmi_watchdog != NMI_IO_APIC)
 		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
+#if 0
 	else
 		printk(KERN_WARNING "APIC timer registered as dummy,"
 		       " due to nmi_watchdog=1!\n");
+#endif
 
 	setup_APIC_timer();
 }


