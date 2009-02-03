Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbZBCDvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbZBCDvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 22:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZBCDvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 22:51:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:33717 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbZBCDve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 22:51:34 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0902021508340.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <200902022239.02453.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
	 <200902022331.49131.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021508340.3247@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 14:51:01 +1100
Message-Id: <1233633061.16867.41.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 15:18 -0800, Linus Torvalds wrote:
> (background: pci_restore_standard_config() will have done 
> pci_raw_set_power_state(PCI_D0) with the device clocks off, which
> wouldn't 
> actualyl have _done_ anythign to the device, but then it does
> 
>         dev->current_state = PCI_D0;
> 
> Maybe the simplest thing to do migth be to replace that with a
> 
>         pci_update_current_state(dev, PCI_D0);
> 
> instead, to try to read back the state explicitly in 
> pci_restore_standard_config()).

Note that I notice on various powerbook models a bunch of things like

<some pci device> : restoring config space at offset XX (was: 0xffffffff, writin 0 ...)

I'm not sure if that will do any good :-)

The reason is that some devices (here sungem, ide-pmac and the firewire OHCI) -do-
get clock gated until either you hit some of my magic pmac_feature calls in
the driver or the driver calls pci_enable_device() (I have a hook there).

So far, it appears to be harmless ... at least on the one machine I have here,
but it shows that we are doing something wrong.

So to recapitulate our entire discussion, let me know if I'm off the mark here:

 - We agree that in general, the arch must have a chance to turn things on
before we do anything such as restoring the config space. This includes
my pmac clock gating stuff and ACPI

 - The problem with ACPI is that it needs interrupts because it uses mutexes,
GFP_KERNEL, etc.... There are two approaches to solving that problem. We can
either make the mutexes not warn etc... or we can use a loop of disable_irq()
instead of local_irq_save() between our normal and our "late" phase of PM.

 - There are some arguments for the fact that making mutexes not warn and
GFP_KERNEL silently degrade to at least GFP_NOIO is a good thing to do at
that stage in the suspend process (and the GFP_KERNEL -> NOIO should probably
happen even earlier) so we might get ACPI for free there.

Now, here's just a few things to throw into the discussion:

 - I think sysdevs should still have real IRQs off (local_irq_off) since that
includes shutting down the PIC itself, the timers, etc...

 - Doing the disable_irq() loop instead of local_irq_save() will introduce one
subtle change to driver semantics, ie, they -might- be entered while in their
suspend_late() via some timer interrupt (ie, IO scheduler acting on a timer,
network stuff, tty output for the serial driver, etc...) while we had a pretty
strong guarantee with the local_irq_save() case that nothing would happen at
that stage, this isn't true anymore. That means more chances for drivers to
get it wrong...   

 - Because of the two things above, I tend to favor myself the option of
making mutexes not warn etc... 

 - There are some additional reasons where generalizing that to the "late"
suspend and early resume stages could be useful, such as allowing early video
resume of fbdev/fbcon or the new KMS etc... while those things may internally
use mutexes or do GFP_KERNEL allocs etc... One example hitting me right now is
my AGP PM code that I need to run early to bring the video back properly,
which calls agp_collect_device_status() which calls pci_get_class() which
does a kzalloc(...,GFP_KERNEL). Another one is the fb_set_suspend() itself
uses the fb_notifier which is a blocking notifier. This is annoying because
this notifier isn't used only for suspend/resume, for for other things that
can legitimately be blocking, so making it an atomic notifier isn't really
the right options, etc...

For those reason, I think we need to look at the few changes to the
scheduler/mutex code, might_sleep() and allocators, so that:

  - During the main suspend/resume phase: GFP_KERNEL -> GFP_NOIO

  - During the "irq off" phase:
	* GFP_KERNEL/NOIO -> GFP_ATOMIC
	* msleep -> mdelay
	* might_sleep() doesn't warn
	* actual blocking on a mutex errors out verbosely

That would allow a whole chunk of code to be used in the later phase as if it
was boot time, including probably ACPI. Of course, we still want to be careful,
we aren't going to allow explicit scheduling, ie, things like sysdev's should
still be written with the idea that it -is- atomic context, but at least cases
such as the ones we've exposed above would be much more manageable.

>From there, we can then rework PCI to properly call the arch stuff first thing
on power on and be happy with it.

Comments ?

Cheers,
Ben.


