Return-Path: <linux-kernel-owner+w=401wt.eu-S1751453AbZH2Mt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbZH2Mt1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 08:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbZH2Mt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 08:49:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbZH2MtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 08:49:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/6] PM: Asynchronous resume of devices
Date: Sat, 29 Aug 2009 14:49:57 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908282146550.9540-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908282146550.9540-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908291449.57667.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 August 2009, Alan Stern wrote:
> On Sat, 29 Aug 2009, Rafael J. Wysocki wrote:
> 
> > On Friday 28 August 2009, Alan Stern wrote:
> > > On Fri, 28 Aug 2009, Rafael J. Wysocki wrote:
> > > 
> > > > > Given this design, why bother to invoke device_resume() for the async 
> > > > > devices?  Why not just start up a bunch of async threads, each of which 
> > > > > calls async_resume() repeatedly until everything is finished?  (And 
> > > > > rearrange async_resume() to scan the list first and do the actual 
> > > > > resume second.)
> > > > > 
> > > > > The same goes for the noirq versions.
> > > > 
> > > > I thought about that, but there are a few things to figure out:
> > > > - how many threads to start
> > > 
> > > That's a tough question.  Right now you start roughly as many threads
> > > as there are async devices.  That seems like overkill.
> > 
> > In fact they are substantially fewer than that, for the following reasons.
> > 
> > First, the async framework will not start more than MAX_THREADS threads,
> > which is 256 at the moment.  This number is less than the number of async
> > devices to handle on an average system.
> 
> Okay, but MAX_THREADS isn't under your control.  Remember also that 
> each thread takes up some memory, and during hibernation we are in a 
> memory-constrained situation.

We keep some extra free memory for things like this.  It's not likely to be
exhausted by the async threads alone.

> > Second, no new async threads are started while the main thread is handling the
> > sync devices , so the existing threads have a chance to do their job.  If
> > there's a "cluster" of sync devices in dpm_list, the number of async threads
> > running is likely to drop rapidly while those devices are being handled.
> > (BTW, if there were no sync devices, the whole thing would be much simpler,
> > but I don't think it's realistic to assume we'll be able to get rid of them any
> > time soon).
> 
> Perhaps not, but it would be interesting to see what happens if every 
> device is async.  Maybe you can try it and get a meaningful result.

I could if it didn't crash.  Perhaps I can with init=/bin/bash.

> > Finally, but not least importantly, async threads are not started for the
> > async devices that were previously handled "out of order" by the already
> > running async threads (or by async threads that have already finished).  My
> > testing shows that there are quite a few of them on the average.  For example,
> > on the HP nx6325 typically there are as many as 580 async devices handled "out
> > of order" during a _single_ suspend-resume cycle (including the "early" and
> > "late" phases), while only a few (below 10) devices are waited for by at least
> > one async thread.
> 
> That is a difficult sort of thing to know in advance.  It ought to be 
> highly influenced by the percentage of async devices; that's another 
> reason for wanting to know what happens when every device is async.

There are a few factors beyond our direct control influencing this, like for
example how much time it takes to handle each individual device (that may
vary from .5 s to microseconds AFAICS).

In addition to this not only the percentage, but also the distribution of sync
devices in dpm_list has an effect.  For example, the situations where every
second device is sync and where the first half of devices are async and the
other is sync would lead to different kinds of behavior.

> > > I would expect that a reasonably small number of threads would suffice 
> > > to achieve most of the possible time savings.  Something on the order 
> > > of 10 should work well.  If the majority of the time is spent 
> > > handling N devices then N+1 threads would be enough.  Judging from some 
> > > of the comments posted earlier, even 4 threads would give a big 
> > > advantage.
> > 
> > That unfortunately is not the case with the set of async devices including
> > PCI, ACPI and serio devices only.  The average time savings are between 5% to
> > 14%, depending on the system and the phase of the cycle (the relative savings
> > are typically greater for suspend).  Still, that amounts to .5 s in some cases.
> 
> Without context it's hard to be sure, but I don't think your numbers 
> contradict what I said.  If you get between 5% and 14% time savings 
> with 14 threads, then you might get between 4% and 10% savings with 
> only 4 threads.

I only wanted to say that the advantage is not really that "big". :-)

> I must agree, 14 threads isn't a lot.  But at the moment that number is 
> random, not under your control.

It's not directly controlled, but there are some interactions between the
async threads, the main threads and the async framework that don't allow this
number to grow too much.

IMO it sometimes is better to allow things to work themselves out, as long as
they don't explode, than to try to keep everything under strict control.  YMMV.

> > > > - when to start them
> > > 
> > > You might as well start them at the beginning of dpm_resume and 
> > > dpm_resume_noirq.  That way they can overlap with the synchronous 
> > > operations.
> > 
> > In that case they would have to wait in the beginning, so I'd need a mechanism
> > to wake them up.
> 
> You already have two such mechanisms: dpm_list_mtx and the embedded 
> wait_queue_heads.  Although in the scheme I'm proposing, no async 
> threads would ever have to wait on a per-device waitqueue.  A 
> system-wide waitqueue might work out better (for use when a thread 
> reaches the end of the list and then waits before starting over at the 
> beginning).

However, sync devices may depend on the async ones and they need the
per-device wait queues for this purpose.

> > Alternatively, there could be a limit to the number of async threads started
> > within the current design, but I'd prefer to leave that to the async framework
> > (namely, if MAX_THREADS makes sense for boot, it's also likely to make sense
> > for PM).
> 
> Strictly speaking, a new thread should be started only when needed.  
> That is, only when all the existing threads are busy running a 
> callback.  It shouldn't be too hard to keep track of when that happens.

The async framework does that for us. :-)

Thanks,
Rafael
