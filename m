Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbXEPI5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbXEPI5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbXEPI5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:57:23 -0400
Received: from www.osadl.org ([213.239.205.134]:45992 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753641AbXEPI5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:57:22 -0400
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v4
From: Thomas Gleixner <tglx@linutronix.de>
To: Frank Sorenson <frank@tuxrocks.com>
Cc: Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1179296431.12838.51.camel@chaos>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <200705142215.08910.s0348365@sms.ed.ac.uk> <1179180314.7074.36.camel@chaos>
	 <200705142342.29994.s0348365@sms.ed.ac.uk> <1179217082.7074.47.camel@chaos>
	 <4649BE4A.8000707@tuxrocks.com> <1179266013.12838.31.camel@chaos>
	 <464A403A.3050202@tuxrocks.com> <464A9077.1010403@tuxrocks.com>
	 <1179296431.12838.51.camel@chaos>
Content-Type: text/plain
Date: Wed, 16 May 2007 11:01:31 +0200
Message-Id: <1179306091.12838.67.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frank,

On Wed, 2007-05-16 at 08:20 +0200, Thomas Gleixner wrote:
> > I have tracked down the offending patch in the series to
> > x86-64-convert-to-clockevents.patch
> 
> Not surprising. :)
> 
> I'm going to add some early_printks for the next version, so we can get
> an idea where it gets stuck

I went through the relevant changes since the git2-v2 version and the
only thing, which could affect the early boot process is the patch
snippet below.

Can you apply this either to the git2-v2 version and check, if it fails
as well, or reverse apply it to rc1-v4 and check, if the problem goes
away ?

Thanks,

	tglx


diff -uprN --exclude-from=/home/tglx/bin/diffit.exclude linux-2.6.21-git-x86-64/arch/i386/kernel/i8253.c linux-2.6.21/arch/i386/kernel/i8253.c
--- linux-2.6.21-git-x86-64/arch/i386/kernel/i8253.c	2007-05-16 09:58:01.000000000 +0200
+++ linux-2.6.21/arch/i386/kernel/i8253.c	2007-05-16 09:10:34.000000000 +0200
@@ -29,24 +29,6 @@ EXPORT_SYMBOL(i8253_lock);
  */
 struct clock_event_device *global_clock_event;
 
-/* Status of the PIT interrupt */
-static int pit_irq_disabled;
-
-/*
- * Control pit interrupt enable / disable
- */
-static void pit_control_irq(int disable)
-{
-	if (pit_irq_disabled == disable)
-		return;
-
-	pit_irq_disabled = disable;
-	if (disable)
-		disable_irq(0);
-	else
-		enable_irq(0);
-}
-
 /*
  * Initialize the PIT timer.
  *
@@ -65,17 +47,18 @@ static void init_pit_timer(enum clock_ev
 		outb_p(0x34, PIT_MODE);
 		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
 		outb(LATCH >> 8 , PIT_CH0);	/* MSB */
-		pit_control_irq(0);
 		break;
 
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	case CLOCK_EVT_MODE_UNUSED:
-		pit_control_irq(1);
+		outb_p(0x30, PIT_MODE);
+		outb_p(0, PIT_CH0);	/* LSB */
+		outb_p(0, PIT_CH0);	/* MSB */
 		break;
+
 	case CLOCK_EVT_MODE_ONESHOT:
 		/* One shot setup */
 		outb_p(0x38, PIT_MODE);
-		pit_control_irq(0);
 		break;
 
 	case CLOCK_EVT_MODE_RESUME:
@@ -129,7 +112,7 @@ void __init setup_pit_timer(void)
 	 * Start pit with the boot cpu mask and make it global after the
 	 * IO_APIC has been initialized.
 	 */
-	pit_clockevent.cpumask = cpumask_of_cpu(0);
+	pit_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
 	pit_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, 32);
 	pit_clockevent.max_delta_ns =
 		clockevent_delta2ns(0x7FFF, &pit_clockevent);


