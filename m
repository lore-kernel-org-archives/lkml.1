Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbXKZWYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbXKZWYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbXKZWX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:23:57 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:25362 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbXKZWX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:23:56 -0500
Date: Mon, 26 Nov 2007 15:22:53 -0700
From: Alex Chiang <achiang@hp.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       kaneshige.kenji@jp.fujitsu.com, pcihpd-discuss@lists.sourceforge.net,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
Message-ID: <20071126222253.GA31708@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
	gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
	pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119233225.GA6931@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119233225.GA6931@us.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gary, Kenji-san, et. al,

* Gary Hade <garyhade@us.ibm.com>:
> 
> Alex, What I was trying to suggest is a boot-time kernel
> option, not a kernel configuration option.  The basic idea is
> to give the user (with a single binary kernel) the ability to
> include your ACPI-PCI slot driver feature changes only when
> they are really needed.  In addition to reducing the number of
> system/PCI hotplug driver combinations where your changes would
> need to be validated, I believe would also help alleviate other
> worries (e.g. Andi Kleen's memory consumption concern).  I
> believe this goal could also be achieved with the kernel config
> option by making the pci_slot module runtime loadable with the
> PCI hotplug drivers only visiting your new code when the
> pci_slot driver is loaded, although I think this would be more
> difficult to implement.

I have modified my patch series so that the final patch that
introduces my ACPI-PCI slot driver is a full-fledged module, that
has a tristate Kconfig option.

It can be modprobe'd/rmmod'ed in any combination, and in any
order with other PCI hotplug modules. There is no ordering
dependency, even at module unload time, so you can safely rmmod
pci_slot, and safely continue using features provided by the PCI
hotplug drivers (acpiphp, pciehp, etc.). The opposite works too.

The one limitation is that two separate hotplug drivers cannot
both claim the same device (2nd module loaded will get -EBUSY
errors), but I do not believe that is a regression from current
behavior.

I have only tested with acpiphp and pciehp, as that's the only
hardware I have, but I believe my code will play nicely with the
other PCI hp drivers as well.

The patch series is fully bisectable, and the correct behavior
occurs no matter which patch you happen to have applied.

I'll be sending v5 of patches 3 and 4 shortly (patches 1 and 2
did not change). It is still based on 2.6.24-rc2, because I was
too scared to do another git rebase while using stgit. :-/

> Also, I notice that even with your current CONFIG_ACPI_PCI_SLOT
> implementation your numerous PCI hotplug driver changes (except
> for only two places in pci_hotplug_core.c where there is 
> `#ifndef CONFIG_ACPI_PCI_SLOT` and `#ifdef CONFIG_ACPI_PCI_SLOT`)
> are _always_ exposed.  So, even with CONFIG_ACPI_PCI_SLOT disabled
> there is IMO a need for testing of the affected PCI hotplug drivers
> on more than a small number of isolated systems.

You are, of course, correct.

In my opinion, though, I would say most of the changes to the PCI
hotplug drivers themselves are pretty straightforward, as in
removing the different ways of getting the PCI address.

The scary part of the changes (aside from the ACPI-PCI slot
driver) revolve around the new struct pci_slot, which is
relatively self-contained, and only expose themselves via the
pci_create_slot/pci_destroy_slot interfaces which only the PCI
hotplug corecares about.

Regardless, your point stands. How do you suggest I get more
testing time? Is this patchset appropriate for the -mm tree yet?
Or do you think it still needs more work?

> The good news is that I was able to test your v3 changes
> (w/2.6.24-rc3 source) on our x3850 today with 'acpiphp' and,
> except for the above mentioned inability to run-time
> include/exclude them, they seemed to work fine.  The previous
> boot-time ACPI error messages are gone and I was able to
> successfully hot-remove and hot-add both PCI-X and PCIe
> adapters.

Thanks for testing. Please let me know how v5 works for you too.

chers,

/ac

