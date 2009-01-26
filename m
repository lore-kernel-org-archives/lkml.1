Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbZAZUgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbZAZUgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZAZUg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:36:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59381 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbZAZUg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:36:26 -0500
Date: Mon, 26 Jan 2009 21:35:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Linux 2.6.29-rc2] BUG: using smp_processor_id() in preemptible
Message-ID: <20090126203559.GD8867@elte.hu>
References: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com> <200901261753.35416.rjw@sisk.pl> <20090126174113.GF6238@elte.hu> <200901262021.23763.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901262021.23763.rjw@sisk.pl>
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

> On Monday 26 January 2009, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > On Monday 26 January 2009, Linus Torvalds wrote:
> > > > 
> > > > On Sat, 17 Jan 2009, Maciej Rutecki wrote:
> > > > >
> > > > > During suspend to ram:
> > > > > [  131.287012] BUG: using smp_processor_id() in preemptible [00000000]
> > > > > code: suspend_to_ram./2958
> > > > > [  131.287012] caller is retrigger_next_event+0x13/0xb0
> > > > > [  131.287012] Pid: 2958, comm: suspend_to_ram. Not tainted 2.6.29-rc2 #1
> > > > > [  131.287012] Call Trace:
> > > > > [  131.287012]  [<c025b41f>] debug_smp_processor_id+0xbf/0xd0
> > > > > [  131.287012]  [<c01473b3>] retrigger_next_event+0x13/0xb0
> > > > > [  131.287012]  [<c01489b7>] raw_notifier_call_chain+0x17/0x20
> > > > > [  131.287012]  [<c014b938>] timekeeping_resume+0xe8/0x110
> > > > > [  131.287012]  [<c02cc651>] __sysdev_resume+0x11/0x50
> > > > > [  131.287012]  [<c02cc6d7>] sysdev_resume+0x47/0x80
> > > > > [  131.287012]  [<c02d2478>] device_power_up+0x8/0x10
> > > > 
> > > > Very scary.
> > > > 
> > > > device_power_up() calls sysdev_resume _before_ it enables interrupts so it 
> > > > sounds like something else has - very incorrectly - enabled interrupts too 
> > > > early in your resume sequence. 
> > > > 
> > > > The patch that Andrew sent out and that apparently fixed things for you 
> > > > should absolutely not have made any difference. This is suspend_enter():
> > > > 
> > > > 	        arch_suspend_disable_irqs();
> > > > 	        BUG_ON(!irqs_disabled());
> > > > 
> > > > 	        if ((error = device_power_down(PMSG_SUSPEND))) {
> > > > 	                printk(KERN_ERR "PM: Some devices failed to power down\n");
> > > > 	                goto Done;
> > > > 	        }
> > > > 	
> > > > 	        if (!suspend_test(TEST_CORE))
> > > > 	                error = suspend_ops->enter(state);
> > > > 
> > > > 	        device_power_up(PMSG_RESUME);
> > > > 	 Done:
> > > > 	        arch_suspend_enable_irqs();
> > > > 
> > > > and notice how the whole thing is surrounded by that 
> > > > arch_suspend_disable/enable_irqs().
> > > > 
> > > > So it looks like some sysdev driver (device_power_up does the sysdev 
> > > > drivers first, so it can't be the regular low-level PCI drivers) is 
> > > > enabling interrupts in its resume function. Scary and very wrong.
> > > > 
> > > > It could easily be ACPI, of course. There was some other case where ACPI 
> > > > did that, iirc.
> > > 
> > > There is a known bug in the USB controllers' suspend that enables interrupts
> > > from within ->suspend_late().  It should be fixed by the next USB merge
> > > AFAICS.
> > 
> > the patch from Andrew looks wrong, as it hides the only place in the 
> > kernel that was able to report the resume bug. Nevertheless related to 
> > that bug we've got a new debug check queued up in timers/urgent:
> > 
> >  void hres_timers_resume(void)
> >  {
> > -       /* Retrigger the CPU local events: */
> > +       WARN_ONCE(!irqs_disabled(),
> > +                 KERN_INFO "hres_timers_resume() called with IRQs enabled!");
> > +
> >         retrigger_next_event(NULL);
> >  }
> > 
> > as the buggy 'irqs are enabled' condition was not detected reliably. (it 
> > was only detected with certain lockdep options turned on - and even then 
> > it did not seem to be 100% triggerable)
> 
> Yeah.
> 
> > i sent it to Linus earlier today.
> 
> OK, thanks.
> 
> I'll write a debug patch covering that more generally when I recover from the
> flu a bit.
> 
> Rafael

note, we could reuse the ftrace/irqtrace callbacks as well to create an: 
"enforce IRQs off and debug violations of that" facility.

It would work like this, you could mark IRQs as disabled 'permanently':

   force_irqs_off_start();
   ...
   force_irqs_off_end();

you could mark an arbitrarily complex code sequence that way, and ftrace 
would emit a WARN_ONCE() if irqs are enable anytime during that sequence - 
by using the irq-tracking facilities we have for the irqsoff tracer (and 
which we also have for lockdep).

Would that be useful?

	Ingo
