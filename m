Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbZBZVwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbZBZVwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbZBZVwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:52:03 -0500
Received: from gate.crashing.org ([63.228.1.57]:39266 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbZBZVwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:52:01 -0500
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during 
 suspend-resume
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <d6200be20902261320q58a347e5s1af790e56b186c81@mail.gmail.com>
References: <200902221837.49396.rjw@sisk.pl>
	 <200902250029.16107.rjw@sisk.pl>
	 <d6200be20902251717r531c022bl4c25fcb902201188@mail.gmail.com>
	 <200902261050.50531.rjw@sisk.pl>
	 <d6200be20902261234i5a3896fo78a7f56d16a247c7@mail.gmail.com>
	 <1235681849.7388.22.camel@pasglop>
	 <d6200be20902261320q58a347e5s1af790e56b186c81@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Feb 2009 08:49:40 +1100
Message-Id: <1235684980.7388.24.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 13:20 -0800, Arve Hjønnevåg wrote:
> On Thu, Feb 26, 2009 at 12:57 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Thu, 2009-02-26 at 12:34 -0800, Arve Hjønnevåg wrote:
> >> That is enough for drivers that use wakelocks to abort suspend (if I
> >> fix the wakelock code to not use a platform device as its last abort
> >> point). It is not enough if you don't have wakelocks, since the
> >> interrupt can occur after suspend_late has been called and the driver
> >> has no way to abort suspend.
> >>
> > I still don't quite see how you deal with the race anyway. Ie. Even
> > without Rafael patch, what if the interrupt occurs after your sysdev
> > suspend ?
> 
> After local_irq_disable has been called, the interrupt will no longer
> be cleared by Linux when it occurs. This means that is still pending
> when you get to the low level suspend code which will prevent suspend.

Ok so you want this interrupt to stay pending at the PIC level ? So just
marking it so the kernel doesn't disable it should do the trick.

> > In general, unless they are level sensitive, wakeup interrupts tend to
> > always be somewhat racy.
> 
> They don't have to be. If you have a separate hardware component that
> tracks wakeup interrupts, you need to start this before you stop the
> main interrupt controller. If any interrupts are pending at this time
> you abort suspend. After a wakeup you do the reverse.

Right but then you can start this earlier and there is no problem. But
if you do want the interrupt to remaining pending in the PIC, then you
probably need to set that magic flag so we don't disable it, that should
do the trick just fine no ?

It's hard to tell without more detailed HW specs of course...

Ben.


