Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbYKMTeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbYKMTeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYKMTeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:00 -0500
Received: from gw.goop.org ([64.81.55.164]:34362 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbYKMTeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:00 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 00 of 38] xen: add more Xen dom0 support
Message-Id: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:09:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's the chunk of patches to add Xen Dom0 support (it's probably
worth creating a new xen/dom0 topic branch for it).

A dom0 Xen domain is basically the same as a normal domU domain, but
it has extra privileges to directly access hardware.  There are two
issues to deal with:
 - translating to and from the domain's pseudo-physical addresses and
   real machine addresses (for ioremap and setting up DMA)
 - routing hardware interrupts into the domain

ioremap is relatively easy to deal with.  An earlier patch introduced
the _PAGE_IOMAP pte flag, which we use to distinguish between a
regular pseudo-physical mapping and a real machine mapping.
Everything falls out pretty cleanly.  A consequence is that the
various pieces of table-parsing code - DMI, ACPI, MP, etc - work out
of the box.

Similarly, the series adds hooks into swiotlb so that architectures
can allocate the swiotlb memory appropriately; on the x86/xen side,
Xen hooks these allocation functions to make special hypercalls to
guarantee that the allocated memory is contiguous in machine memory.

Interrupts are a very different affair.  The descriptions in each
patch describe how it all fits together in detail, but the overview
is:

1. Xen owns the local APICs; the dom0 kernel controls the IO APICs
2. Hardware interrupts are delivered on event channels like everything else
3. To set this up, we intercept at pcibios_enable_irq:
   - given a dev+pin, we use ACPI to get a gsi
   - hook acpi_register_gsi to call xen_register_gsi, which
   - allocates an irq (generally not 1:1 with the gsi)
   - asks Xen for a vector and event channel for the irq
   - program the IO APIC to deliver the hardware interrupt to the
     allocated vector

The upshot is that the device driver gets an irq, and when the
hardware raises an interrupt, it gets delivered on that irq.

We maintain our own irq allocation space, since the hardware-bound
event channel irqs are intermixed with all the other normal Xen event
channel irqs (inter-domain, timers, IPIs, etc).  For compatibility the
irqs 0-15 are reserved for legacy device interrupts, but the rest of
the range is dynamically allocated.

Initialization also requires care.  The dom0 kernel parses the ACPI
tables as usual, in order to discover the local and IO APICs, and all
the rest of the ACPI-provided data the kernel requires.  However,
because the kernel doesn't own the local APICs and can't directly map
the IO APICs, we must be sure to avoid actually touching the hardware
when running under Xen.

TODO: work out how to fit MSI into all this.

So, in summary, this series contains:
 - dom0 console support
 - dom0 xenbus support
 - CPU features and IO access for a privleged domain
 - mtrrs
 - making ioremap work on machine addresses
 - swiotlb allocation hooks
 - interrupts
   - introduce PV io_apic operations
   - add Xen-specific IRQ allocator
   - switch to using all-Xen event delivery
   - add pirq Xen interrupt type
   - table parsing and setup
   - intercept driver interrupt registration

All this code will compile away to nothing when CONFIG_XEN_DOM0 is not
enabled.  If it is enabled, it will only have an effect if booted as a
dom0 kernel; normal native execution and domU execution should be
unaffected.

Thanks,
	J

