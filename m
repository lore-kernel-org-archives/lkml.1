Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZBCVEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZBCVEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZBCVEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:04:22 -0500
Received: from gate.crashing.org ([63.228.1.57]:56848 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbZBCVEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:04:21 -0500
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
 standard config registers of all devices early)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200902031804.26752.rjw@sisk.pl>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <1233633061.16867.41.camel@pasglop> <200902031026.34093.rjw@sisk.pl>
	 <200902031804.26752.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 08:02:56 +1100
Message-Id: <1233694976.16867.90.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 18:04 +0100, Rafael J. Wysocki wrote:

> > Now, there's one subtle problem with resume in this picture.  Namely, before
> > running the "early resume of devices" we have to make sure that the interrupts
> > will be masked.  However, masking MSI-X, for example, means writing into
> > the memory space of the device, so we can't do it at this point.  Of course, we
> > can assume that MSI/MSI-X will be masked when we get control from the BIOS
> > (moreover, they are not shareable, so we can just ignore them at this point),
> > but still we'll have to mask the other interrupts before doing the
> > local_irq_enable() on resume - marked by the (*) above.  This appears to be
> > doable, though.

Which is why I prefer making mutex/semaphores/allocations "safe" to use
in that late suspend phase with IRQs off.

It sounds like a less invasive thing, simpler, change, allowing to move
the ACPI stuff back to where it belongs, and it would help solving other
problems such as the problems I exposed with video resume, which I'm
trying to do -very- early (ie, before sysdev's even).

In fact, as I may have said elsewhere, I'm also being bitten by the PCI
layer doing kmalloc(...GFP_KERNEL) all over the place nowadays including
in things like pci_get_device() which are hurting some memory controller
code I have that runs in late suspend (I could refactor that code to
do the pci_get_* earlier, it's just one more thing..).

> Having reconsidered it, I think that the "loop of disable_irq()" may be
> problematic due to MSI/MSI-X and devices that are put into D3 during the
> "normal" suspend.  That is, we shouldn't try to mask MSI/MSI-X for devices in
> D3 (especially MSI-X, since that involves writing to the device's memory
> space).  This implies that devices in D3 should be avoided in the "loop of
> disable_irq()", but that could be tricky if we loop over struct irq_desc
> objects.
> 
> Still, we can modify pci_pm_suspend() (and the other PCI callbacks analogously)
> so that it masks the interrupt of the device right before returning to the
> caller if the device has not been put into a low power state before.  After
> that all devices will either be in low power states, so they won't be able to
> generate interrupts, or have their interrupts masked.  In the latter case the
> core can then put them into low power states in suspend_late().

That's going to be hard to get right vs. shared interrupts no ?

I think the "other" solution overall is much more simple.

Cheers,
Ben.


