Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbZCHKBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbZCHKBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZCHKAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:00:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33283 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbZCHKAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:00:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [RFC][PATCH][1/8] PM: Rework handling of interrupts during suspend-resume (rev. 5)
Date: Sun, 8 Mar 2009 11:00:42 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
References: <Pine.LNX.4.44L0.0903072248030.8870-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0903072248030.8870-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903081100.43757.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 March 2009, Alan Stern wrote:
> On Sat, 7 Mar 2009, Rafael J. Wysocki wrote:
> 
> > > One thing about this isn't clear: the distinction between "wake-up" 
> > > interrupts and other interrupts.
> > > 
> > > In an ideal world, the only pending interrupts during sysdev_suspend
> > > would be wake-up interrupts, because drivers would have prevented their
> > > devices from generating any other kind of IRQ and would have done all
> > > the necessary synchronization as part of their suspend (_not_
> > > suspend_late) methods.  Thus there would be no need to distinguish
> > > between wake-up and non-wake-up interrupts.
> > > 
> > > So perhaps you're worried about drivers that aren't sufficiently
> > > clever.  Or is something deeper going on?
> > 
> > Some drivers leave interrupts enabled during suspend on purpose and mark
> > them as "wake-up interrupts" so that the platform can abort suspend if any
> > of them is pending at the time the "enter suspend" hook is called (this doesn't
> > happen on x86 AFAICS).
> > 
> > However, after the $subject patch the CPU will ACK those interrupts if they
> > happen between suspend_device_irqs() and local_irq_disable(), so the platform
> > won't see them as pending.  Instead, they will have IRQ_PENDING set in
> > desc->status, so we check if this is the case.
> 
> You didn't answer my question.  Why bother to distinguish between 
> "wake-up" interrupts and non-"wake-up" interrupts?

Sorry, I thought it followed from what I wrote.

> In other words, why not simply abort the suspend if IRQ_PENDING is set
> for _any_ interrupt during sysdev_suspend()?

The "wake-up" ones are _intentionally_ left enabled, while the other ones may
be left enabled by mistake.  The check is intended to prevent the current
behavior from changing (ie. suspend is aborted if any "wake-up" interrupts
are pending) and since the platforms only check for the "wake-up" interrupts,
it doesn't go any further.  Moreover, I think it might introduce a regression
if it did.

Thanks,
Rafael
