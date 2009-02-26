Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZBZXLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZBZXLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 18:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZBZXLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 18:11:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39043 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbZBZXLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 18:11:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Fri, 27 Feb 2009 00:10:35 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <alpine.LFD.2.00.0902261404580.3111@localhost.localdomain> <d6200be20902261430w19ea3e6fye014f8443d9ab5ca@mail.gmail.com>
In-Reply-To: <d6200be20902261430w19ea3e6fye014f8443d9ab5ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902270010.38291.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Arve Hjønnevåg wrote:
> On Thu, Feb 26, 2009 at 2:10 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >
> > On Thu, 26 Feb 2009, Rafael J. Wysocki wrote:
> >>
> >> Well, how exactly the $subject patch does cause this problem to happen?
> >
> > Rafael, the problem is that if an interrupt happens while it's disabled -
> > but before the CPU has actually turned all interrupts off - the CPU will
> > ACK the interrupt (but just set a flag for it being PENDING), so now the
> > chipset logic around it will not see it as pending any more, so now the
> > chipset won't auto-wake the CPU immediately (or more likely, it won't
> > even suspend it).
> >
> > It's trivial to fix multiple ways, so I wouldn't worry. The most trivial
> > way is to just have some sysdev drievr code simply do something like
> >
> >  static int sysdev_suspend()
> >  {
> >        for_each_irq(irq,desc) {
> >                if (!(desc->flags & IRQF_WAKE))
> >                        continue;
> >                if (desc->flags & IRQ_PENDING)
> >                        return -EBUSY;
> >        }
> >        return 0;
> >  }
> >
> > and that should automatically mean that if any irq is pending, the suspend
> > will fail and we'll immediately wake up again.
> >
> > It looks trivial, and I don't understand why Arve can't just do the sysdev
> > thing.
> 
> I can. My point is that the patch breaks our existing code.

Is that a mainline kernel code?

> If anyone else uses edge triggered wakeup interrupt it may break from them as
> well. The main question if this should be fixed separately for every
> platform that needs it, or if pending wakeup interrupts should always
> abort sleep.

Well, I'm not really sure if this is the problem.  In fact the problem is that
you have a regular device the interrupt of which can be a wake-up one.  I think
the problem wouldn't have existed at all if it had been a sysdev.  Is that
correct?

Rafael
