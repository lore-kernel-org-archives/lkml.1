Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZA3OGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZA3OGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 09:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZA3OGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 09:06:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51753 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbZA3OGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 09:06:32 -0500
Date: Fri, 30 Jan 2009 15:06:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Linux 2.6.29-rc2] BUG: using smp_processor_id() in preemptible
Message-ID: <20090130140620.GD17401@elte.hu>
References: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com> <200901272218.39608.rjw@sisk.pl> <20090129150701.GE6512@elte.hu> <200901292329.59121.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901292329.59121.rjw@sisk.pl>
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

> On Thursday 29 January 2009, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > On Tuesday 27 January 2009, Ingo Molnar wrote:
> > > > 
> > > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > 
> > > > > > In fact whatever check you put in it's _always_ going to be 
> > > > > > fundamentally more fragile than direct instrumentation: you cannot 
> > > > > > possibly check all possible places that enable interrupts. (they could 
> > > > > > be disabling interrupts as a _restore_irqs() sequence for example)
> > > > > 
> > > > > In this particular case, I'm not really interested in that.  What I'm 
> > > > > interested in is which driver's ->suspend_late() or ->resume_early() (or 
> > > > > the equivalents for sysdevs) has enabled interrupts, which is quite easy 
> > > > > to check directly.
> > > > 
> > > > But this is exactly what it does - without any need for debug checks 
> > > > spread around!
> > > > 
> > > > You'll get a _full stack dump_ from the very driver that is enabling 
> > > > interrupts! You dont get a trace - you get a stack dump of the very place 
> > > > that is buggy. It does not get any better than that.
> > > 
> > > I'm not going to argue.
> > > 
> > > Nevertheless, IMO something like the patch below should be sufficient to catch
> > > these bugs.
> > > 
> > > Thanks,
> > > Rafael
> > > 
> > > 
> > > ---
> > >  drivers/base/power/main.c |   12 ++++++++++++
> > >  drivers/base/sys.c        |   21 ++++++++++++++++-----
> > >  include/linux/pm.h        |   18 ++++++++++++++++++
> > >  3 files changed, 46 insertions(+), 5 deletions(-)
> > 
> > hm, so now you sprinkle debug checks all around the code, instead of 
> > putting in a single pair of:
> > 
> >     force_irqs_off_start();
> >     ...
> >     force_irqs_off_end();
> 
> And what debug options exactly would that require to be set to work?

hm, if you worry about that aspect: we could make it seemlessly enabled if 
PM_DEBUG is enabled.

> > which would catch everything that your checks would catch - and it 
> > would catch more.
> 
> Except that the checks trigger in specific places, so if a check 
> triggers you know precisely where the bug happened regardless of what 
> garbage is in the call trace.

This argument is 100% mystery to me. Do you really not see the quality 
difference between a stack trace generated _right at the buggy piece of 
code_ and a warning later on that might (or might not) trigger?

Especially considering that your approach wont catch such bugs:

   ...
   spin_unlock_irq();
   ...
   spin_lock_irq();
   ...

Or such bugs:

   local_irq_enable();
   ...
   local_irq_disable();

Or such bugs:

   spin_lock_irq_save(&lock1, flags);
   ...
           spin_lock_irqsave(&lock2, flags);
           ...
           spin_unlock_irq(&lock2);          /* accidental bug */
   ...
   spin_unlock_irq_restore(&lock1, flags);

Such types of bugs might be especially hard to find in practice, if the 
window where irqs are enabled is small. There is no guarantee at all that 
accidental irq enabling survives a critical section - it can be 
re-disabled in the normal flow of things very easily.

And even if we are lucky and if the irqs stay enabled by the time the 
callback returns, what if your warning flags some big and complex driver, 
one line of which is buggy?

If you had the choice, what would you prefer - a stack dump done at the 
point of incident (pinpointing the driver, the subsystem and the buggy 
function with its full callframe), or your "this driver is buggy" generic 
warning with no specificity about where that bug might be?

Stacktraces _at the point of incident_, and a _guaranteed_ facility that 
_enforces_ that irqs are off during the whole resume cycle are just about 
the highest quality debug info and debug protection we can get in such 
situations.

I really dont understand your points about this.

	Ingo
