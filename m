Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbZBCRFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbZBCRFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZBCRFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:05:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39999 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbZBCRFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:05:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Reworking suspend-resume sequence (was: Re: PCI PM: Restore standard config registers of all devices early)
Date: Tue, 3 Feb 2009 18:04:25 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <1233633061.16867.41.camel@pasglop> <200902031026.34093.rjw@sisk.pl>
In-Reply-To: <200902031026.34093.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031804.26752.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, Rafael J. Wysocki wrote:
> On Tuesday 03 February 2009, Benjamin Herrenschmidt wrote:
> > On Mon, 2009-02-02 at 15:18 -0800, Linus Torvalds wrote:

[--snip--]

> > Comments ?
> 
> As I said, I tend to prefer the "loop of disable_irq()" approach, because it
> would allow us to preserve the current ordering of ACPI operations.  Namely,
> if we do:
> 
> suspend devices (normal suspend)
>   loop of disable_irq()
>     late suspend of devices
>       _PTS
>         disable nonboot CPUs
>           local_irq_disable()
>             sysdev suspend
>               enter sleep state
>               get control from the BIOS
>             sysdev resume
>             (*)
>           local_irq_enable()
>         enable nonboot CPUs
>       _WAK
>     early resume of devices
>   loop of enable_irq()
> resume devices (normal resume)
> 
> the ordering of _PTS with respect to putting devices into low power states and
> disabling the nonboot CPUs will be the same as it is now and the same applies
> to _WAK and putting devices into D0 etc. (I really _really_ wouldn't like to
> change this ordering, since this alone is likely to break things badly).
> 
> Now, there's one subtle problem with resume in this picture.  Namely, before
> running the "early resume of devices" we have to make sure that the interrupts
> will be masked.  However, masking MSI-X, for example, means writing into
> the memory space of the device, so we can't do it at this point.  Of course, we
> can assume that MSI/MSI-X will be masked when we get control from the BIOS
> (moreover, they are not shareable, so we can just ignore them at this point),
> but still we'll have to mask the other interrupts before doing the
> local_irq_enable() on resume - marked by the (*) above.  This appears to be
> doable, though.

Having reconsidered it, I think that the "loop of disable_irq()" may be
problematic due to MSI/MSI-X and devices that are put into D3 during the
"normal" suspend.  That is, we shouldn't try to mask MSI/MSI-X for devices in
D3 (especially MSI-X, since that involves writing to the device's memory
space).  This implies that devices in D3 should be avoided in the "loop of
disable_irq()", but that could be tricky if we loop over struct irq_desc
objects.

Still, we can modify pci_pm_suspend() (and the other PCI callbacks analogously)
so that it masks the interrupt of the device right before returning to the
caller if the device has not been put into a low power state before.  After
that all devices will either be in low power states, so they won't be able to
generate interrupts, or have their interrupts masked.  In the latter case the
core can then put them into low power states in suspend_late().

To summarize, I'd like to do the following:

  suspend devices (normal suspend, mask interrupts for devices still in D0)
    late suspend of devices (devices cannot generate interrupts)
      _PTS
        disable nonboot CPUs
          local_irq_disable()
            sysdev suspend
              enter sleep state
              get control from the BIOS
            sysdev resume
            (*)
          local_irq_enable()
        enable nonboot CPUs
      _WAK
    early resume of devices {
      - devices cannot generate interrupts
      - devices are being put into D0
      - standard config registers are being restored
    }
  resume devices (unmask device interrupts, normal resume)

The "early resume of devices" step can effectively unmask MSI/MSI-X, but that
shouldn't matter, since they are not shared anyway.

IOW, I would just move the late suspend of devices before _PTS and the
early resume of devices after _WAK, with the additional disabling/enabling of
device interrups (all PCI devices must enter the late suspend phase either in a
low power state, or with their interrupts masked; analogously for resume).

Thanks,
Rafael
