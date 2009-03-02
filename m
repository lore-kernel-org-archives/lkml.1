Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbZCBXNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbZCBXNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZCBXN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:13:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33550 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbZCBXNZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:13:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFC][PATCH 1/4] PM: Rework handling of interrupts during suspend-resume (rev. 4)
Date: Tue, 3 Mar 2009 00:13:01 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>
References: <200902221837.49396.rjw@sisk.pl> <200903012324.39327.rjw@sisk.pl> <d6200be20903021501x4ad710fbr834b11b8a6647d2c@mail.gmail.com>
In-Reply-To: <d6200be20903021501x4ad710fbr834b11b8a6647d2c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903030013.02805.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 March 2009, Arve Hjønnevåg wrote:
> On Sun, Mar 1, 2009 at 2:24 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Introduce two helper functions allowing us to prevent device drivers
> > from getting any interrupts (without disabling interrupts on the CPU)
> > during suspend (or hibernation) and to make them start to receive
> > interrupts again during the subsequent resume, respectively.  These
> > functions make it possible to keep timer interrupts enabled while the
> > "late" suspend and "early" resume callbacks provided by device
> > drivers are being executed.
> >
> > Use these functions to rework the handling of interrupts during
> > suspend (hibernation) and resume.  Namely, interrupts will only be
> > disabled on the CPU right before suspending sysdevs, while device
> > drivers will be prevented from receiving interrupts, with the help of
> > the new helper function, before their "late" suspend callbacks run
> > (and analogously during resume).
> >
> > In addition, since the device interrups are now disabled before the
> > CPU has turned all interrupts off and the CPU will ACK the interrupts
> > setting the IRQ_PENDING bit for them, check in sysdev_suspend() if
> > any wake-up interrupts are pending and abort suspend if that's the
> > case.
> >
> 
> 
> > +void resume_device_irqs(void)
> > +{
> > +       struct irq_desc *desc;
> > +       int irq;
> > +
> > +       for_each_irq_desc(irq, desc)
> > +               if (desc->status & IRQ_SUSPENDED)
> > +                       enable_irq(irq);
> > +}
> 
> I think you need to clear IRQ_SUSPENDED here, not in enable_irq.

enable_irq() clears IRQ_SUSPENDED.  This has already been discussed btw.

> > @@ -222,8 +222,9 @@ static void __enable_irq(struct irq_desc
> >                WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
> >                break;
> >        case 1: {
> > -               unsigned int status = desc->status & ~IRQ_DISABLED;
> > +               unsigned int status;
> >
> > +               status = desc->status & ~(IRQ_DISABLED | IRQ_SUSPENDED);
> >                /* Prevent probing on this irq: */
> >                desc->status = status | IRQ_NOPROBE;
> >                check_irq_resend(desc, irq);
> 
> This only clears IRQ_SUSPENDED if the interrupt was not disabled
> elsewhere. If a driver calls interrupt_disable in suspend_late, but
> calls interrupt_enable lazily, resume_device_irqs will reenable the
> interrupt even though the driver has a disable reference.

Then I'd regard the driver as buggy.
 
> The rest of the patch looks good.

I'm glad you like it.

Thanks,
Rafael
