Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbZA3VbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbZA3VbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 16:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbZA3Va7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 16:30:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50260 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbZA3Va6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 16:30:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Linux 2.6.29-rc2] BUG: using smp_processor_id() in preemptible
Date: Fri, 30 Jan 2009 22:30:14 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com> <200901292329.59121.rjw@sisk.pl> <20090130140620.GD17401@elte.hu>
In-Reply-To: <20090130140620.GD17401@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901302230.15418.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Thursday 29 January 2009, Ingo Molnar wrote:
> > > 
> > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > 
> > > > On Tuesday 27 January 2009, Ingo Molnar wrote:
> > > > > 
> > > > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > > 
> > > > > > > In fact whatever check you put in it's _always_ going to be 
> > > > > > > fundamentally more fragile than direct instrumentation: you cannot 
> > > > > > > possibly check all possible places that enable interrupts. (they could 
> > > > > > > be disabling interrupts as a _restore_irqs() sequence for example)
> > > > > > 
> > > > > > In this particular case, I'm not really interested in that.  What I'm 
> > > > > > interested in is which driver's ->suspend_late() or ->resume_early() (or 
> > > > > > the equivalents for sysdevs) has enabled interrupts, which is quite easy 
> > > > > > to check directly.
> > > > > 
> > > > > But this is exactly what it does - without any need for debug checks 
> > > > > spread around!
> > > > > 
> > > > > You'll get a _full stack dump_ from the very driver that is enabling 
> > > > > interrupts! You dont get a trace - you get a stack dump of the very place 
> > > > > that is buggy. It does not get any better than that.
> > > > 
> > > > I'm not going to argue.
> > > > 
> > > > Nevertheless, IMO something like the patch below should be sufficient to catch
> > > > these bugs.
> > > > 
> > > > Thanks,
> > > > Rafael
> > > > 
> > > > 
> > > > ---
> > > >  drivers/base/power/main.c |   12 ++++++++++++
> > > >  drivers/base/sys.c        |   21 ++++++++++++++++-----
> > > >  include/linux/pm.h        |   18 ++++++++++++++++++
> > > >  3 files changed, 46 insertions(+), 5 deletions(-)
> > > 
> > > hm, so now you sprinkle debug checks all around the code, instead of 
> > > putting in a single pair of:
> > > 
> > >     force_irqs_off_start();
> > >     ...
> > >     force_irqs_off_end();
> > 
> > And what debug options exactly would that require to be set to work?
> 
> hm, if you worry about that aspect: we could make it seemlessly enabled if 
> PM_DEBUG is enabled.

That would be useful, but OTOH I'd rather not like PM_DEBUG to select multiple
tracing options.  Perhaps it's better to add PM_CHECK_IRQS or something similar
and make that depend on PM_DEBUG and whatever else is necessary.

> > > which would catch everything that your checks would catch - and it 
> > > would catch more.
> > 
> > Except that the checks trigger in specific places, so if a check 
> > triggers you know precisely where the bug happened regardless of what 
> > garbage is in the call trace.
> 
> This argument is 100% mystery to me. Do you really not see the quality 
> difference between a stack trace generated _right at the buggy piece of 
> code_ and a warning later on that might (or might not) trigger?
> 
> Especially considering that your approach wont catch such bugs:
> 
>    ...
>    spin_unlock_irq();
>    ...
>    spin_lock_irq();
>    ...
> 
> Or such bugs:
> 
>    local_irq_enable();
>    ...
>    local_irq_disable();
> 
> Or such bugs:
> 
>    spin_lock_irq_save(&lock1, flags);
>    ...
>            spin_lock_irqsave(&lock2, flags);
>            ...
>            spin_unlock_irq(&lock2);          /* accidental bug */
>    ...
>    spin_unlock_irq_restore(&lock1, flags);

I didn't think about that.

I see a value of having this kind of things trigger a warning, but also I see
a value of having some checks in the code, independent of any extra debug
options.

Thanks,
Rafael
