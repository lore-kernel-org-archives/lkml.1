Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbZCEKgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbZCEKgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZCEKgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:36:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39602 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbZCEKgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:36:11 -0500
Date: Thu, 5 Mar 2009 11:35:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Update, rev. 5] Re: [RFC][PATCH 1/4] PM: Rework handling of
	interrupts during suspend-resume (rev. 4)
Message-ID: <20090305103524.GC32407@elte.hu>
References: <200902221837.49396.rjw@sisk.pl> <200903030027.13884.rjw@sisk.pl> <d6200be20903031456r7caa3c42qa7c31dc74768449c@mail.gmail.com> <200903042303.30357.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903042303.30357.rjw@sisk.pl>
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

> On Tuesday 03 March 2009, Arve Hjønnevåg wrote:
> > On Mon, Mar 2, 2009 at 3:27 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Tuesday 03 March 2009, Arve Hjønnevåg wrote:
> > >> On Mon, Mar 2, 2009 at 3:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >> > On Tuesday 03 March 2009, Arve Hjønnevåg wrote:
> > >> >> On Sun, Mar 1, 2009 at 2:24 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> [--snip--]
> > > Can you show me a _single_ _driver_ currently in the tree doing something
> > > like you describe in suspend_late and resume_early?  If you can't, then please
> > > give up.
> > 
> > I don't know if any drivers call disable_irq or enable_irq in their
> > suspend hooks, but your change also allow timers, and I assume kernel
> > threads, to run during this phase.
> > 
> > There are several drivers (keypad drivers in particular), in tree and
> > out of tree, that call enable_irq from timers, and disable_irq from
> > their interrupt handler. If you also apply your later change to
> > disable non boot cpus after suspend_device_irqs, then on smp systems
> > the interrupt handler may run at the same time as suspend_device_irqs.
> > If suspend_device_irqs gets the spinlock first, then IRQ_SUSPENDED
> > gets set. If another suspend/resume cycle happens before the timer
> > runs, you will incorrectly enable the interrupt.
> 
> Well, unfortunately this is a valid point IMO.  I've been thinking for quite a
> while how to fix it nicely, but I'm not sure if there is a nice fix.
> 
> Below is an updated patch, hopefully everyone will be fine with it.
> 
> Ingo, is making __enable_irq() an extern function acceptable?

Sure, that's fine - it's a genirq internal function still 
between kernel/irq/manage.c and kernel/irq/pm.c.

	Ingo
