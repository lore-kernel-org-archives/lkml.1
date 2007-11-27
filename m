Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbXK0DFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbXK0DFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 22:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbXK0DFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 22:05:01 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59626 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbXK0DE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 22:04:59 -0500
Date: Mon, 26 Nov 2007 19:04:54 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Alex Chiang <achiang@hp.com>
Cc: Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
Message-ID: <20071127030454.GC23277@us.ibm.com>
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119233225.GA6931@us.ibm.com> <20071126222253.GA31708@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126222253.GA31708@ldl.fc.hp.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 03:22:53PM -0700, Alex Chiang wrote:
> Hi Gary, Kenji-san, et. al,
> 
> * Gary Hade <garyhade@us.ibm.com>:
> > 
> > Alex, What I was trying to suggest is a boot-time kernel
> > option, not a kernel configuration option.  The basic idea is
> > to give the user (with a single binary kernel) the ability to
> > include your ACPI-PCI slot driver feature changes only when
> > they are really needed.  In addition to reducing the number of
> > system/PCI hotplug driver combinations where your changes would
> > need to be validated, I believe would also help alleviate other
> > worries (e.g. Andi Kleen's memory consumption concern).  I
> > believe this goal could also be achieved with the kernel config
> > option by making the pci_slot module runtime loadable with the
> > PCI hotplug drivers only visiting your new code when the
> > pci_slot driver is loaded, although I think this would be more
> > difficult to implement.
> 
> I have modified my patch series so that the final patch that
> introduces my ACPI-PCI slot driver is a full-fledged module, that
> has a tristate Kconfig option.
> 
> It can be modprobe'd/rmmod'ed in any combination, and in any
> order with other PCI hotplug modules. There is no ordering
> dependency, even at module unload time, so you can safely rmmod
> pci_slot, and safely continue using features provided by the PCI
> hotplug drivers (acpiphp, pciehp, etc.). The opposite works too.

Nice!  I like the loadable module approach much better than my
boot-time kernel option suggestion.

> 
> The one limitation is that two separate hotplug drivers cannot
> both claim the same device (2nd module loaded will get -EBUSY
> errors), but I do not believe that is a regression from current
> behavior.

I cannot confirm this since the systems I am using only support
a single hotplug driver (acpiphp).

> 
> I have only tested with acpiphp and pciehp, as that's the only
> hardware I have, but I believe my code will play nicely with the
> other PCI hp drivers as well.

I have only tested your changes with acpiphp.

> 
> The patch series is fully bisectable, and the correct behavior
> occurs no matter which patch you happen to have applied.

Based on my testing (see below) this appears to be true.

> 
> I'll be sending v5 of patches 3 and 4 shortly (patches 1 and 2
> did not change). It is still based on 2.6.24-rc2, because I was
> too scared to do another git rebase while using stgit. :-/

I have been using 2.6.24-rc3 source for my testing.

> 
> > Also, I notice that even with your current CONFIG_ACPI_PCI_SLOT
> > implementation your numerous PCI hotplug driver changes (except
> > for only two places in pci_hotplug_core.c where there is 
> > `#ifndef CONFIG_ACPI_PCI_SLOT` and `#ifdef CONFIG_ACPI_PCI_SLOT`)
> > are _always_ exposed.  So, even with CONFIG_ACPI_PCI_SLOT disabled
> > there is IMO a need for testing of the affected PCI hotplug drivers
> > on more than a small number of isolated systems.
> 
> You are, of course, correct.
> 
> In my opinion, though, I would say most of the changes to the PCI
> hotplug drivers themselves are pretty straightforward, as in
> removing the different ways of getting the PCI address.
> 
> The scary part of the changes (aside from the ACPI-PCI slot
> driver) revolve around the new struct pci_slot, which is
> relatively self-contained, and only expose themselves via the
> pci_create_slot/pci_destroy_slot interfaces which only the PCI
> hotplug corecares about.

I think this sounds like a reasonable argument for not
doing what I was trying to suggest.

> 
> Regardless, your point stands. How do you suggest I get more
> testing time?

I am only able to test with acpiphp.  In addition to the
testing on the x3850 described below I would also like to
do some testing on an x3950 which has a mix of hotplug and
non-hotplug slots.  If this testing which I hope to complete
this week goes well, I will be satisfied.

I will let others speak for the other hotplug drivers
and platforms.

> Is this patchset appropriate for the -mm tree yet?

I would defer to our illustrious maintainers on this one. :)

> Or do you think it still needs more work?

I am now much more comfortable with your changes with respect
to acpiphp on the systems I worry about but others may have
concerns with respect to the other hotplug drivers, or even
acpiphp, on other systems.

> 
> > The good news is that I was able to test your v3 changes
> > (w/2.6.24-rc3 source) on our x3850 today with 'acpiphp' and,
> > except for the above mentioned inability to run-time
> > include/exclude them, they seemed to work fine.  The previous
> > boot-time ACPI error messages are gone and I was able to
> > successfully hot-remove and hot-add both PCI-X and PCIe
> > adapters.
> 
> Thanks for testing. Please let me know how v5 works for you too.

I just tried your v5 (1/4 v3, 2/4 v3, 3/4 v5, 4/4 v5) applied 
to 2.6.24-rc3 source with acpiphp on the x3850 and found 
nothing to complain about.  About time, eh? :)

Following boot, 'pci_slot' was already loaded and slot directories
(each containing an address file) for all 6 (2 PCI-X, 4 PCIe)
slots were present.  I then successfully modprobed acpiphp and
successfully hot-removed the PCI-X and PCIe cards that were present
during boot.  I then successfully hot-added the same cards to
the slots they occupied during boot and to slots that were vacant
during boot.

I then unloaded acpiphp and pci_slot and reloaded both in
the opposite order (acpiphp 1st, pci_slot 2nd) and
successfully repeated the above hot-remove/hot-add operations. 

I then unloaded both drivers again, reloaded only acpiphp,
and successfully repeated the same hot-remove/hot-add operations.

I will let you know how it goes on the x3950.

Thanks for all your hard work on this.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

