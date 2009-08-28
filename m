Return-Path: <linux-kernel-owner+w=401wt.eu-S1751830AbZH1WVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbZH1WVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 18:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZH1WVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 18:21:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45138 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZH1WV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 18:21:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/6] PM: Asynchronous resume of devices
Date: Sat, 29 Aug 2009 00:22:00 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908281548140.2865-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908281548140.2865-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908290022.00446.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 August 2009, Alan Stern wrote:
> On Fri, 28 Aug 2009, Rafael J. Wysocki wrote:
> 
> > > Given this design, why bother to invoke device_resume() for the async 
> > > devices?  Why not just start up a bunch of async threads, each of which 
> > > calls async_resume() repeatedly until everything is finished?  (And 
> > > rearrange async_resume() to scan the list first and do the actual 
> > > resume second.)
> > > 
> > > The same goes for the noirq versions.
> > 
> > I thought about that, but there are a few things to figure out:
> > - how many threads to start
> 
> That's a tough question.  Right now you start roughly as many threads
> as there are async devices.  That seems like overkill.

In fact they are substantially fewer than that, for the following reasons.

First, the async framework will not start more than MAX_THREADS threads,
which is 256 at the moment.  This number is less than the number of async
devices to handle on an average system.

Second, no new async threads are started while the main thread is handling the
sync devices , so the existing threads have a chance to do their job.  If
there's a "cluster" of sync devices in dpm_list, the number of async threads
running is likely to drop rapidly while those devices are being handled.
(BTW, if there were no sync devices, the whole thing would be much simpler,
but I don't think it's realistic to assume we'll be able to get rid of them any
time soon).

Finally, but not least importantly, async threads are not started for the
async devices that were previously handled "out of order" by the already
running async threads (or by async threads that have already finished).  My
testing shows that there are quite a few of them on the average.  For example,
on the HP nx6325 typically there are as many as 580 async devices handled "out
of order" during a _single_ suspend-resume cycle (including the "early" and
"late" phases), while only a few (below 10) devices are waited for by at least
one async thread.

I can try to monitor the number of asyn threads started if you're interested.

> I would expect that a reasonably small number of threads would suffice 
> to achieve most of the possible time savings.  Something on the order 
> of 10 should work well.  If the majority of the time is spent 
> handling N devices then N+1 threads would be enough.  Judging from some 
> of the comments posted earlier, even 4 threads would give a big 
> advantage.

That unfortunately is not the case with the set of async devices including
PCI, ACPI and serio devices only.  The average time savings are between 5% to
14%, depending on the system and the phase of the cycle (the relative savings
are typically greater for suspend).  Still, that amounts to .5 s in some cases.

> > - when to start them
> 
> You might as well start them at the beginning of dpm_resume and 
> dpm_resume_noirq.  That way they can overlap with the synchronous 
> operations.

In that case they would have to wait in the beginning, so I'd need a mechanism
to wake them up.

Alternatively, there could be a limit to the number of async threads started
within the current design, but I'd prefer to leave that to the async framework
(namely, if MAX_THREADS makes sense for boot, it's also likely to make sense
for PM).

> > - stop condition
> 
> When an error occurs or when op_started has been set for every 
> remaining async device.

Yeah, that's the easy one. :-)

> > I had a few ideas, but then I thought it would be simpler to start an async
> > thread when we know there's some async work to do (ie. there's an async
> > device to handle) and make each async thread browse the list just once (the
> > rationale is that we've just handled a device, so there's a chance there are
> > some devices with satisfied dependencies down the list).
> 
> It comes down to this: Should there be many threads, each of which 
> browses the list only once, or should there be a few threads, each of 
> which browses the list many times?

Well, quite obviously I prefer the many threads version. :-)

Thanks,
Rafael
