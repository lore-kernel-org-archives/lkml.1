Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZBTXli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZBTXli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZBTXl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:41:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbZBTXl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:41:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFD] Automatic suspend
Date: Sat, 21 Feb 2009 00:40:48 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902192215.18365.rjw@sisk.pl> <200902201657.01145.rjw@sisk.pl> <200902210012.08088.oliver@neukum.org>
In-Reply-To: <200902210012.08088.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902210040.50344.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 February 2009, Oliver Neukum wrote:
> Am Freitag 20 Februar 2009 16:56:59 schrieb Rafael J. Wysocki:
> 
> > OK, so what about the following approach:
> >
> > * Keep the decision making logic (power manager etc.) in user space. 
> > Reasons: - It may be arbitrarily complicated
> 
> Therefore something functionally equivalent to wakelocks
> is needed.
> 
> >   - It may include such things as s2ram quirks or hal quirks needed for
> > some graphics adapters
> 
> If you can't do that I'd say the situation is hopeless.
> You need full support for all devices including graphics
> cards.

We can't do the quirks from the kernel and that's one of the reasons why I
think user space should start automatic suspend (it can do the quirks if
necessary).

> > * Have a per-process (per-task or per-thread group, but the former would be
> >   easier IMO) "I_do_not_want_automatic_suspend_to_occur" flag.
> 
> I think you got the default logic inverted.

Well, it may be "suspend_possible_right_now" just as well. :-)
 
> > * Add a new callback, say ->acknowledge(), to the set of each driver's PM
> >   operations, that will be called to check if the driver has anything
> > against automatic suspend (true - suspend can happen right now, false -
> > suspend can't happen).
> >
> > * Introduce /sys/power/sleep that will work like /sys/power/state, but:
> >   - First, it will call ->acknowledge() for each driver (via bus types) to
> >     check if any of them wants to postpone the suspend (this will prevent
> > tasks from being frozen unnecessarily if it is known in advance that the
> > suspend should not happen at the moment).
> 
> Ideally most devices should be already suspended, so I am not
> sure a new callback is really needed. In any cases it is an optimization
> only.

Yes, it is, but an important one (the total time of freezing and thawing tasks
can be substantial).

> >   - Next, it will check the "I_do_not_want_automatic_suspend_to_occur" flag
> >     of each process and the suspend will be aborted if it is true for any
> > of them (quite frankly, I think that should be integrated with the freezer,
> > in particular the tasks that have TIF_FREEZE set shouldn't be able to set
> > this flag and it should be checked in the freezer loop for every task with
> > TIF_FREEZE unset).
> 
> Why in this order?

Because the freezing of tasks takes time and it would be a bad idea to do it
unnecessarily.

> >   - Next, it will proceed with suspending just like /sys/power/state does
> > (the drivers that missed the opportunity to abort the suspend by returning
> > 'false' from ->acknowledge() can still abort the suspend by failing their
> > ->suspend() routines).
> >
> > Then, the decision making logic will be able to use /sys/power/sleep
> > whenever it wishes to and the kernel will be able to refuse to suspend if
> > it's not desirable at the moment.
> 
> I think everything that uses a "trigger" logic from user space is not
> a good idea. This will necessary introduce a race between the decision
> and the execution during which circumstances can change.

Well, in this particulare case if the circumstances change in the meantime,
the kernel will just refuse to suspend.  Also, even if the kernel starts
automatic suspend, it _still_ is possible that the conditions change in the
meantime (for example, one of the tasks may enter a state in which it wouldn't
like to the suspend to happen just after the operation is started and before
it's frozen).

> So it seems to me that an allow/disallow system from user space
> would be better.

I don't really see the benefit, but I can easily see drawbacks (the handling
of graphics that requires user space quirks, for instance).

Thanks,
Rafael
