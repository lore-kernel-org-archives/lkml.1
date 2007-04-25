Return-Path: <linux-kernel-owner+w=401wt.eu-S1423241AbXDYHIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423241AbXDYHIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 03:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423246AbXDYHIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 03:08:47 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423241AbXDYHIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 03:08:46 -0400
Date: Wed, 25 Apr 2007 00:07:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Oleg Nesterov" <oleg@tv-sign.ru>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.21-rc7-mm1 + sysfs-oops-workaround.patch -- software
 suspend failed (1 tasks refusing to freeze)
Message-Id: <20070425000735.130ec3e7.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0704242341n4c8d9eaaw4516759ff79e8cd5@mail.gmail.com>
References: <a44ae5cd0704242227x14986fe3v5c2fc3a5bceedc89@mail.gmail.com>
	<20070424224137.0ccf7874.akpm@linux-foundation.org>
	<a44ae5cd0704242249i210ba860i659c230b5dbb211c@mail.gmail.com>
	<20070424225429.544075c8.akpm@linux-foundation.org>
	<a44ae5cd0704242341n4c8d9eaaw4516759ff79e8cd5@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 23:41:32 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:

> On 4/24/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 24 Apr 2007 22:49:48 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:
> >
> > > On 4/24/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > On Tue, 24 Apr 2007 22:27:44 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:
> > > >
> > > > > [ 1251.506964] PM: Preparing system for mem sleep
> > > > > [ 1251.514790] Stopping tasks ...
> > > > > [ 1271.456065] Stopping user space processes timed out after 20
> > > > > seconds (1 tasks refusing to freeze):
> > > > > [ 1271.456243]  multiload-apple
> > > > > [ 1271.456291] Restarting tasks ... done.
> > > > >
> > > > > This isn't happening under earlier builds I've tested.  How can I debug this?
> > > > >
> > > >
> > > > hm, that's multiload-applet, some gnome thing.
> > > >
> > > > sysrq-T, perhaps?  Perhaps the process is sleeping in the kernel somewhere.
> > >
> > > Should I wait for the next patch from Tejun before retesting?  Perhaps
> > > this suspend problem is a side effect of the locking problem he
> > > mentioned.
> >
> > It's unlikely to be related to Tejun's sysfs changes.
> >
> I tried to reproduce this, but this time when I tried to suspend, the
> machine just hung with a message showing saying the system was
> suspending.  When I touched my Synaptics mousepad after about ten
> seconds of waiting, the system suddenly suspended.

Fun.  Could be one of Greg's trees, could be the swsusp patches, could be
the freezer changes, could be USB, could be the input layer, could be
anything.  I don't see how we can merge anything at all into 2.6.22 at
present.  The only thing to be said for doing that is that we'd increase
our pool of bisection-searchers.  argh.

Rafael, Oleg: do we have a way of exercising the freezer from userspace? 
Just do a freeze/unfreeze?  We should.

Also, can we get better diagnostics when the freeze fails?  Say, go the
equivalent of a sysrq-T?  It could be that multiload-applet is waiting on
activity from an already-frozen thread or something.

>  Upon resuming, I
> checked dmesg and found the time seems to be totally out of whack:

So sched_clock() went bad.  That's another tree or three we can't merge.

Is the system time also wrong?

> [ 1334.589074] pci 0000:00:1f.6: LATE suspend
> [ 1334.589080] Intel ICH 0000:00:1f.5: LATE suspend
> [ 1334.589085] pci 0000:00:1f.3: LATE suspend
> [ 1334.589091] pci 0000:00:1f.0: LATE suspend
> [ 1334.589096] pci 0000:00:1e.0: LATE suspend, may wakeup
> [ 1334.589102] pci 0000:00:02.1: LATE suspend
> [ 1334.589108] pci 0000:00:02.0: LATE suspend
> [ 1334.589113] pci 0000:00:00.3: LATE suspend
> [ 1334.589118] pci 0000:00:00.1: LATE suspend
> [ 1334.589124] agpgart-intel 0000:00:00.0: LATE suspend
> [ 1334.589733]  hwsleep-0323 [03] enter_sleep_state     : Entering
> sleep state [S3]
> [18014527.889728] Intel machine check architecture supported.
> [18014527.889749] Intel machine check reporting enabled on CPU#0.
> [18014527.889783] Back to C!
> [18014527.889783] agpgart-intel 0000:00:00.0: EARLY resume
> [18014527.889783] PCI: Calling quirk c01c94b2 for 0000:00:00.0
