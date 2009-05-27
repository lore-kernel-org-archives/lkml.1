Return-Path: <linux-kernel-owner+w=401wt.eu-S1764096AbZE0Hjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764096AbZE0Hjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763878AbZE0Hhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:37:52 -0400
Received: from claw.goop.org ([74.207.240.146]:41685 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763926AbZE0Hhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:37:50 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>
Subject: [GIT PULL REPOST] xen/dom0/apic-ops: Xen dom0 APIC changes
Date: Wed, 27 May 2009 00:37:13 -0700
Message-Id: <1243409850-21577-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This is a repost of the changes for Xen's apic hooks.  This is unchanged
from the last time I posted it.

These changes allow us to route interrupts via Xen's event channel
mechanism, so that hardware interrupts can be distributed to the
appropriate guest domain.

It adds a minimal ioapic_ops interface to allow us to transform the
low-level IO-APIC accesses from mmio into hypercalls.  This is sufficient
for our needs because the accesses themselves are going to the real
hardware IO APICs, and we want all the other logic above generating
the requests.  You initially approved of this approach.

More recently, you proposed that we add a higher-level ioapic driver
abstraction to encompass not only Xen's current needs, but also to address
KVM possible use for such an interface.  This seems like a good idea in
general, but not something we can do in time for the next merge window.

I propose that you take the current minimal approach, and we can
develop something fuller when we can see what KVM's needs are, and have
enough time to do a proper job.

There are no other outstanding issues.

Please pull it into tip.git x86/xen/dom0/apic

Thanks,
	J

The following changes since commit ce791368bb4a53d05e78e1588bac0aacde8db84c:
  Jeremy Fitzhardinge (1):
        xen/i386: make sure initial VGA/ISA mappings are not overridden

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git for-ingo/xen/dom0/apic-ops

Gerd Hoffmann (2):
      xen: set pirq name to something useful.
      xen: fix legacy irq setup, make ioapic-less machines work.

Ian Campbell (1):
      xen: pre-initialize legacy irqs early

Jeremy Fitzhardinge (14):
      xen/dom0: handle acpi lapic parsing in Xen dom0
      x86: add io_apic_ops to allow interception
      xen: implement io_apic_ops
      xen: create dummy ioapic mapping
      xen: implement pirq type event channels
      x86/io_apic: add get_nr_irqs_gsi()
      xen/apic: identity map gsi->irqs
      xen: direct irq registration to pirq event channels
      xen: bind pirq to vector and event channel
      xen: don't setup acpi interrupt unless there is one
      xen: use acpi_get_override_irq() to get triggering for legacy irqs
      xen: initialize irq 0 too
      xen: dynamically allocate irq & event structures
      xen: disable MSI

 arch/x86/include/asm/io_apic.h |   10 ++
 arch/x86/include/asm/xen/pci.h |   13 ++
 arch/x86/kernel/acpi/boot.c    |   18 +++-
 arch/x86/kernel/apic/io_apic.c |   55 ++++++++-
 arch/x86/xen/Kconfig           |   11 ++
 arch/x86/xen/Makefile          |    3 +-
 arch/x86/xen/apic.c            |   69 ++++++++++
 arch/x86/xen/enlighten.c       |    2 +
 arch/x86/xen/mmu.c             |   10 ++
 arch/x86/xen/pci.c             |   86 +++++++++++++
 arch/x86/xen/xen-ops.h         |    6 +
 drivers/pci/pci.h              |    2 -
 drivers/xen/events.c           |  273 ++++++++++++++++++++++++++++++++++++++--
 include/linux/pci.h            |    6 +
 include/xen/events.h           |   19 +++
 15 files changed, 568 insertions(+), 15 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/pci.h
 create mode 100644 arch/x86/xen/apic.c
 create mode 100644 arch/x86/xen/pci.c

