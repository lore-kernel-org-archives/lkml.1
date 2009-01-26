Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZAZRmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZAZRmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZAZRlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:41:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60119 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZAZRlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:41:52 -0500
Date: Mon, 26 Jan 2009 18:41:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Linux 2.6.29-rc2] BUG: using smp_processor_id() in preemptible
Message-ID: <20090126174113.GF6238@elte.hu>
References: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com> <alpine.LFD.2.00.0901260807290.5284@localhost.localdomain> <200901261753.35416.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901261753.35416.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Monday 26 January 2009, Linus Torvalds wrote:
> > 
> > On Sat, 17 Jan 2009, Maciej Rutecki wrote:
> > >
> > > During suspend to ram:
> > > [  131.287012] BUG: using smp_processor_id() in preemptible [00000000]
> > > code: suspend_to_ram./2958
> > > [  131.287012] caller is retrigger_next_event+0x13/0xb0
> > > [  131.287012] Pid: 2958, comm: suspend_to_ram. Not tainted 2.6.29-rc2 #1
> > > [  131.287012] Call Trace:
> > > [  131.287012]  [<c025b41f>] debug_smp_processor_id+0xbf/0xd0
> > > [  131.287012]  [<c01473b3>] retrigger_next_event+0x13/0xb0
> > > [  131.287012]  [<c01489b7>] raw_notifier_call_chain+0x17/0x20
> > > [  131.287012]  [<c014b938>] timekeeping_resume+0xe8/0x110
> > > [  131.287012]  [<c02cc651>] __sysdev_resume+0x11/0x50
> > > [  131.287012]  [<c02cc6d7>] sysdev_resume+0x47/0x80
> > > [  131.287012]  [<c02d2478>] device_power_up+0x8/0x10
> > 
> > Very scary.
> > 
> > device_power_up() calls sysdev_resume _before_ it enables interrupts so it 
> > sounds like something else has - very incorrectly - enabled interrupts too 
> > early in your resume sequence. 
> > 
> > The patch that Andrew sent out and that apparently fixed things for you 
> > should absolutely not have made any difference. This is suspend_enter():
> > 
> > 	        arch_suspend_disable_irqs();
> > 	        BUG_ON(!irqs_disabled());
> > 
> > 	        if ((error = device_power_down(PMSG_SUSPEND))) {
> > 	                printk(KERN_ERR "PM: Some devices failed to power down\n");
> > 	                goto Done;
> > 	        }
> > 	
> > 	        if (!suspend_test(TEST_CORE))
> > 	                error = suspend_ops->enter(state);
> > 
> > 	        device_power_up(PMSG_RESUME);
> > 	 Done:
> > 	        arch_suspend_enable_irqs();
> > 
> > and notice how the whole thing is surrounded by that 
> > arch_suspend_disable/enable_irqs().
> > 
> > So it looks like some sysdev driver (device_power_up does the sysdev 
> > drivers first, so it can't be the regular low-level PCI drivers) is 
> > enabling interrupts in its resume function. Scary and very wrong.
> > 
> > It could easily be ACPI, of course. There was some other case where ACPI 
> > did that, iirc.
> 
> There is a known bug in the USB controllers' suspend that enables interrupts
> from within ->suspend_late().  It should be fixed by the next USB merge
> AFAICS.

the patch from Andrew looks wrong, as it hides the only place in the 
kernel that was able to report the resume bug. Nevertheless related to 
that bug we've got a new debug check queued up in timers/urgent:

 void hres_timers_resume(void)
 {
-       /* Retrigger the CPU local events: */
+       WARN_ONCE(!irqs_disabled(),
+                 KERN_INFO "hres_timers_resume() called with IRQs enabled!");
+
        retrigger_next_event(NULL);
 }

as the buggy 'irqs are enabled' condition was not detected reliably. (it 
was only detected with certain lockdep options turned on - and even then 
it did not seem to be 100% triggerable)

i sent it to Linus earlier today.

	Ingo
