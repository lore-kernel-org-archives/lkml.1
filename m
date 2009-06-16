Return-Path: <linux-kernel-owner+w=401wt.eu-S1760498AbZFPVjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760498AbZFPVjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZFPVjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:39:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55283 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbZFPVja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:39:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.30: hibernation/swsusp lockup due to acpi-cpufreq
Date: Tue, 16 Jun 2009 23:39:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Stezenbach <js@sig21.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "davej@redhat.com" <davej@redhat.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>, benh@kernel.crashing.org
References: <20090615232709.GA6059@sig21.net> <20090616140923.eb3ae6e3.akpm@linux-foundation.org> <1245187090.4534.7423.camel@localhost.localdomain>
In-Reply-To: <1245187090.4534.7423.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906162340.00384.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 June 2009, Pallipadi, Venkatesh wrote:
> On Tue, 2009-06-16 at 14:09 -0700, Andrew Morton wrote:
> > On Tue, 16 Jun 2009 22:40:39 +0200
> >
> > Johannes Stezenbach <js@sig21.net> wrote:
> > > On Tue, Jun 16, 2009 at 01:25:58PM -0700, Pallipadi, Venkatesh wrote:
> > > > Can you try the patch below (your changes + a warnon). That should
> > > > give the stack trace with successful suspend-resume.
> > > >
> > > > acpi-cpufreq will not directly disable interrupt and call these
> > > > routines. So, it will be interesting to see how we are ending up in
> > > > this state.
> > >
> > > Yes, I actually had the same idea and just did it ;-)
> > > I also found this:
> > > http://lkml.org/lkml/2007/7/17/674
> > >
> > > ------------[ cut here ]------------
> > > WARNING: at kernel/up.c:18 smp_call_function_single+0x45/0x60()
> > > Hardware name: 2373Y4M
> > > Modules linked in: ath5k mac80211 cfg80211 uhci_hcd ehci_hcd
> > > Pid: 4139, comm: bash Not tainted 2.6.30 #8
> > > Call Trace:
> > >  [<c011ea0d>] warn_slowpath_common+0x60/0x90
> > >  [<c010d86c>] ? do_drv_read+0x0/0x31
> > >  [<c011ea4a>] warn_slowpath_null+0xd/0x10
> > >  [<c013acc1>] smp_call_function_single+0x45/0x60
> > >  [<c010d4e5>] get_cur_val+0x62/0x6c
> > >  [<c010d72f>] get_cur_freq_on_cpu+0x35/0x58
> > >  [<c03786e9>] cpufreq_suspend+0x76/0xd9
> > >  [<c0136c3b>] ? clockevents_notify+0x1e/0x68
> > >  [<c02ff570>] sysdev_suspend+0x4e/0x182
> > >  [<c013fd28>] hibernation_snapshot+0x89/0x16b
> > >  [<c013fe99>] hibernate+0x8f/0x147
> > >  [<c013ec82>] ? state_store+0x0/0xa2
> > >  [<c013ecd7>] state_store+0x55/0xa2
> > >  [<c013ec82>] ? state_store+0x0/0xa2
> > >  [<c024dff5>] kobj_attr_store+0x1a/0x22
> > >  [<c01a7164>] sysfs_write_file+0xb4/0xdf
> > >  [<c01a70b0>] ? sysfs_write_file+0x0/0xdf
> > >  [<c0170cf2>] vfs_write+0x8a/0x12c
> > >  [<c0170e2d>] sys_write+0x3b/0x60
> > >  [<c01028f4>] sysenter_do_call+0x12/0x26
> > > ---[ end trace 1c2172bce3982a59 ]---
> >
> > Right, so it's the suspend-must-disable-local-interrupts thing.  Again.
> >  create_image()'s local_irq_disable().
> >
> > It was wrong to call work_on_cpu() with lcoal interrupts disabled, and
> > it's now wrong to call smp_call_function_single() with local interrupts
> > disabled.  It's just that smp_call_function_single() warns while
> > work_on_cpu() didn't.
> >
> > That all explains the warning But afaik we still don't know why your
> > machine actually failed.  Perhaps it is a side-efect of emitting the
> > warning when the console is in a weird state?
> >
> > So..  what to do?  Possibly we could hack cpufreq to not use
> > smp_call_function_single() if the call is to be done on the local CPU.
> > But SMP might still be broken - if it really does want to do a cross-cpu
> > call.
>
> We surely do not need cross CPU cal at this point as all secondary cpus
> will be offline at this point.
>
> > Why does cpufreq need to do a cross-CPU get_cur_freq_on_cpu() call at
> > suspend time _anyway_?  Surely cpufreq knows the target CPU's frequency
> > from its internal in-main-memory state?
>
> That was what I was wondering as well. Looks like this part of
> cpufreq_suspend came from
>
> commit 42d4dc3f4e1ec1396371aac89d0dccfdd977191b
> Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date:   Fri Apr 29 07:40:12 2005 -0700
>
>     [PATCH] Add suspend method to cpufreq core
>
>     In order to properly fix some issues with cpufreq vs. sleep on
>     PowerBooks, I had to add a suspend callback to the pmac_cpufreq
> driver.
>     I must force a switch to full speed before sleep and I switch back
> to
>     previous speed on resume.
>
>     I also added a driver flag to disable the warnings in suspend/resume
>     since it is expected in this case to have different speed (and I
> want it
>     to fixup the jiffies properly).
>
>     Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>     Signed-off-by: Andrew Morton <akpm@osdl.org>
>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>
>
>
>
> benh: Do you think we still need this cpufreq_driver->get() and return
> error on (!cur_freq || !cpu_policy->cur) stuff?
> May be we should all the checks only if CPUFREQ_PM_NO_WARN is set?

In fact, we need to do this entire thing differently.

The basic problem is that cpufreq_suspend() is a sysdev thing, so it will 
always be called with iterrupts off and *only* for CPU0.  So, it looks like
the majority of things we do there is just unnecessary (at least).

Best,
Rafael

