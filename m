Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbZBTP57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbZBTP57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbZBTP5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:57:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56194 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbZBTP5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:57:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFD] Automatic suspend
Date: Fri, 20 Feb 2009 16:56:59 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902192215.18365.rjw@sisk.pl> <200902201149.37921.rjw@sisk.pl> <d6200be20902200326g6caa211ai388d4aa9fc270a28@mail.gmail.com>
In-Reply-To: <d6200be20902200326g6caa211ai388d4aa9fc270a28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902201657.01145.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009, Arve Hjønnevåg wrote:
> On Fri, Feb 20, 2009 at 2:49 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday 20 February 2009, Arve Hjønnevåg wrote:
> >> On Thu, Feb 19, 2009 at 2:08 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >> >> > It might have to be platform-specific.  The Android people seem to have a
> >> >> > pretty good idea of what criteria will work for them.
> >> >>
> >> >> I'd really like to know in what situations Androind is supposed to suspend
> >> >> automatically.
> >> >
> >> > It might be better to ask in what situations Android is _not_ supposed
> >> > to sleep automatically.  In other words, in what situations is a
> >> > wakelock acquired?  Since the whole system is only a phone, this
> >> > question should have a reasonably well-defined answer.
> >>
> >> On an android phone, any code that needs to run when the screen is off
> >> must hold a wakelock (directly or indirectly). In general if an
> >> application or the system is processing an event that may cause a user
> >> notification (new email, incoming phone call, alarm, etc.) it needs to
> >> prevent suspend. But, we also use wakelocks to upload stats or
> >> download system updates in the background, and for media player or
> >> (gps) data logging applications.
> >
> > All of this doesn't seem to require wakelocks acuired from kernel space.
> > What do you need those wakelocks for?
> 
> Most events do not originate in user-space. Alarms start in our alarm
> driver which locks a wakelock when its timer interrupt occurs. This
> wakelock stays locked until the user-space alarm manager calls the
> driver to wait for the next alarm. I've described how input events are
> handled before. Without kernel wakelocks, if the user space power
> manager had already turned off the screen and decided to suspend right
> before a wakeup key is pressed, then that key could sit in the
> in-kernel input queue until another key is pressed. Even if the
> user-space thread read the key event before being frozen, it cannot
> abort the suspend operation that was already started.

OK, so what about the following approach:

* Keep the decision making logic (power manager etc.) in user space.  Reasons:
  - It may be arbitrarily complicated
  - It may include such things as s2ram quirks or hal quirks needed for some
    graphics adapters

* Have a per-process (per-task or per-thread group, but the former would be
  easier IMO) "I_do_not_want_automatic_suspend_to_occur" flag.

* Add a new callback, say ->acknowledge(), to the set of each driver's PM
  operations, that will be called to check if the driver has anything against
  automatic suspend (true - suspend can happen right now, false - suspend can't
  happen).

* Introduce /sys/power/sleep that will work like /sys/power/state, but:
  - First, it will call ->acknowledge() for each driver (via bus types) to
    check if any of them wants to postpone the suspend (this will prevent tasks
    from being frozen unnecessarily if it is known in advance that the suspend
    should not happen at the moment).
  - Next, it will check the "I_do_not_want_automatic_suspend_to_occur" flag
    of each process and the suspend will be aborted if it is true for any of
    them (quite frankly, I think that should be integrated with the freezer,
    in particular the tasks that have TIF_FREEZE set shouldn't be able to set
    this flag and it should be checked in the freezer loop for every task with
    TIF_FREEZE unset).
  - Next, it will proceed with suspending just like /sys/power/state does (the
    drivers that missed the opportunity to abort the suspend by returning
    'false' from ->acknowledge() can still abort the suspend by failing their
    ->suspend() routines).

Then, the decision making logic will be able to use /sys/power/sleep whenever
it wishes to and the kernel will be able to refuse to suspend if it's not
desirable at the moment.

It seems to be flexible enough to me.

Thanks,
Rafael
