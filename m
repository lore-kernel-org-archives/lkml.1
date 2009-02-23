Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbZBWIoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbZBWIoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZBWIo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:44:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52517 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbZBWIo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:44:28 -0500
Date: Mon, 23 Feb 2009 09:44:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
	suspend-resume
Message-ID: <20090223084400.GB9582@elte.hu>
References: <200902221837.49396.rjw@sisk.pl> <alpine.LFD.2.00.0902220946070.3111@localhost.localdomain> <200902222342.08285.rjw@sisk.pl> <200902230048.33635.rjw@sisk.pl> <m1ab8ddfbr.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ab8ddfbr.fsf@fess.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Sunday 22 February 2009, Rafael J. Wysocki wrote:
> >> On Sunday 22 February 2009, Linus Torvalds wrote:
> >> > 
> >> > On Sun, 22 Feb 2009, Rafael J. Wysocki wrote:
> > [--snip--]
> >> 
> >> Thanks a lot for your comments, I'll send an updated patch shortly.
> >
> > The updated patch is appended.
> >
> > It has been initially tested, but requires more testing, especially with APM,
> > XEN, kexec jump etc.
> >
> > Thanks,
> > Rafael
> >
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM: Rework handling of interrupts during suspend-resume (rev. 2)
> >
> > Introduce two helper functions allowing us to disable device 
> > interrupts (at the IO-APIC level) during suspend or 
> > hibernation and enable them during the subsequent resume, 
> > respectively, so that the timer interrupts are enabled while 
> > "late" suspend callbacks and "early" resume callbacks 
> > provided by device drivers are being executed.
> >
> > Use these functions to rework the handling of interrupts 
> > during suspend (hibernation) and resume.  Namely, interrupts 
> > will only be disabled on the CPU right before suspending 
> > sysdevs, while device interrupts will be disabled (at the 
> > IO-APIC level), with the help of the new helper function, 
> > before calling "late" suspend callbacks provided by device 
> > drivers and analogously during resume.
> 
> I don't have an issue with the code, but I do have an issue 
> with this description of it.
> 
> Calling disable especially for ioapics does nothing directly. 
> It simply arranges for the irq to be marked pending and for 
> the irq to be masked if the irq happens.
> 
> So what you are doing is arranging so that no interrupts will 
> be delivered to drivers.  Not really disabling interrupts at 
> the IO-APIC level.
> 
> In addition not all interrupts (even on x86) go through an 
> IO-APIC anymore so describing the patch in terms of an IO-APIC 
> makes it a bit hard to understand what your intent actually 
> is.

I think this aspect has been well-understood during the 
discussion of this topic and it's just a slightly misleading 
changelog.

The new suspend code does not rely on truly disabling IRQs on 
the low level. The purpose is to not get IRQs to drivers - which 
might crash/hang/race/misbehave.

Still, it might make sense to not just use the ->disable 
sequence but primarily the ->shutdown irqchip method (when it's 
available in the irqchip).

While we obviously cannot turn off the PIC that delivers timer 
IRQs at this stage - there's no theoretical reason why the 
suspend sequence couldnt power down some secondary PICs as well 
- in some arch code, or maybe even in the generic driver suspend 
sequence if the device tree is structured carefully enough so 
that the PIC gets turned off last.

So turning off all device IRQs in the most lowlevel way possible 
would be prudent. I.e. the suspend stage should do:

                if (desc->chip->shutdown)
                        desc->chip->shutdown(irq);
                else
                        desc->chip->disable(irq);

(there's no change needed for the resume stage)

	Ingo
