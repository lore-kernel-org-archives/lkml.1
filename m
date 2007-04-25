Return-Path: <linux-kernel-owner+w=401wt.eu-S2993000AbXDYTsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993000AbXDYTsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993008AbXDYTsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:48:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44262 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993000AbXDYTsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:48:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Miles Lane" <miles.lane@gmail.com>
Subject: Re: 2.6.21-rc7-mm1 + sysfs-oops-workaround.patch -- software suspend failed (1 tasks refusing to freeze)
Date: Wed, 25 Apr 2007 21:52:45 +0200
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Gautham R Shenoy" <ego@in.ibm.com>, "Andi Kleen" <ak@suse.de>
References: <a44ae5cd0704242227x14986fe3v5c2fc3a5bceedc89@mail.gmail.com> <20070425000735.130ec3e7.akpm@linux-foundation.org> <a44ae5cd0704250048i474d7249l7d5b27f6adaf2742@mail.gmail.com>
In-Reply-To: <a44ae5cd0704250048i474d7249l7d5b27f6adaf2742@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704252152.46552.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 25 April 2007 09:48, Miles Lane wrote:
> On 4/25/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 24 Apr 2007 23:41:32 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:
> >
> > > On 4/24/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > On Tue, 24 Apr 2007 22:49:48 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:
> > > >
> > > > > On 4/24/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > > > On Tue, 24 Apr 2007 22:27:44 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:
> > > > > >
> > > > > > > [ 1251.506964] PM: Preparing system for mem sleep
> > > > > > > [ 1251.514790] Stopping tasks ...
> > > > > > > [ 1271.456065] Stopping user space processes timed out after 20
> > > > > > > seconds (1 tasks refusing to freeze):
> > > > > > > [ 1271.456243]  multiload-apple
> > > > > > > [ 1271.456291] Restarting tasks ... done.
> > > > > > >
> > > > > > > This isn't happening under earlier builds I've tested.  How can I debug this?
> > > > > > >
> > > > > >
> > > > > > hm, that's multiload-applet, some gnome thing.
> > > > > >
> > > > > > sysrq-T, perhaps?  Perhaps the process is sleeping in the kernel somewhere.
> > > > >
> > > > > Should I wait for the next patch from Tejun before retesting?  Perhaps
> > > > > this suspend problem is a side effect of the locking problem he
> > > > > mentioned.
> > > >
> > > > It's unlikely to be related to Tejun's sysfs changes.
> > > >
> > > I tried to reproduce this, but this time when I tried to suspend, the
> > > machine just hung with a message showing saying the system was
> > > suspending.  When I touched my Synaptics mousepad after about ten
> > > seconds of waiting, the system suddenly suspended.
> >
> > Fun.  Could be one of Greg's trees, could be the swsusp patches, could be
> > the freezer changes, could be USB, could be the input layer, could be
> > anything.  I don't see how we can merge anything at all into 2.6.22 at
> > present.  The only thing to be said for doing that is that we'd increase
> > our pool of bisection-searchers.  argh.
> >
> > Rafael, Oleg: do we have a way of exercising the freezer from userspace?
> > Just do a freeze/unfreeze?  We should.
> >
> > Also, can we get better diagnostics when the freeze fails?  Say, go the
> > equivalent of a sysrq-T?  It could be that multiload-applet is waiting on
> > activity from an already-frozen thread or something.
> >
> > >  Upon resuming, I
> > > checked dmesg and found the time seems to be totally out of whack:
> >
> > So sched_clock() went bad.  That's another tree or three we can't merge.
> >
> > Is the system time also wrong?
> >
> > > [ 1334.589074] pci 0000:00:1f.6: LATE suspend
> > > [ 1334.589080] Intel ICH 0000:00:1f.5: LATE suspend
> > > [ 1334.589085] pci 0000:00:1f.3: LATE suspend
> > > [ 1334.589091] pci 0000:00:1f.0: LATE suspend
> > > [ 1334.589096] pci 0000:00:1e.0: LATE suspend, may wakeup
> > > [ 1334.589102] pci 0000:00:02.1: LATE suspend
> > > [ 1334.589108] pci 0000:00:02.0: LATE suspend
> > > [ 1334.589113] pci 0000:00:00.3: LATE suspend
> > > [ 1334.589118] pci 0000:00:00.1: LATE suspend
> > > [ 1334.589124] agpgart-intel 0000:00:00.0: LATE suspend
> > > [ 1334.589733]  hwsleep-0323 [03] enter_sleep_state     : Entering
> > > sleep state [S3]
> > > [18014527.889728] Intel machine check architecture supported.
> > > [18014527.889749] Intel machine check reporting enabled on CPU#0.
> > > [18014527.889783] Back to C!
> > > [18014527.889783] agpgart-intel 0000:00:00.0: EARLY resume
> > > [18014527.889783] PCI: Calling quirk c01c94b2 for 0000:00:00.0
> >
> 
> After several attempts, I reproduced getting tasks that won't freeze.
> Sorry for the size of this text.  I don't know how to delete the unneeded stuff.

Which wireless driver do you use?

Can you try to suspend with the driver unloaded?

Rafael
