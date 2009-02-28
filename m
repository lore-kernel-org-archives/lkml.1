Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbZB1COX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbZB1COX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZB1COM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 21:14:12 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:46130
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750910AbZB1COL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 21:14:11 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH] xen: dom0 apic programming hooks
Date: Fri, 27 Feb 2009 18:13:58 -0800
Message-Id: <1235787248-18184-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series implements the hooks requires for interrupt management.

The relationship between Xen and the dom0 kernel with respect to the
interrupt hardware is interesting.  Xen owns the local apics,
but the dom0 kernel is responsible for managing the IO apics.

We hook acpi_register_gsi so that when an interrupt is being
routed, we intercept the routing.  Given a gsi, we allocate
ask Xen to allocate a vector for the particular io_apic+pin,
set up a pirq event channel for that vector, and route the
event channel into the normal interrupt pathways.

We reserve a range of irq space so we can 1:1 map irqs to gsis,
and then use higher irqs for Xen's event-channel-only interrupt
sources.

Despite being responsible for controlling them, dom0 kernel doesn't
have a real mapping of the IO APICs, and so must program their registers
with hypercalls.  At the moment this is just done with straightforward
hooks in io_apic_read/write/etc.  We could also use a io_apic_ops-style
approach, but there's not much point if there are no other users.

This series may be pulled from:

The following changes since commit 59586d42b3accf0be025139066fcd08ed96de425:
  Jeremy Fitzhardinge (1):
        xen/dom0/core: fix mismerge miscompilation

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push/xen/dom0/apic

Ian Campbell (1):
      xen: pre-initialize legacy irqs early

Jeremy Fitzhardinge (9):
      xen/dom0: handle acpi lapic parsing in Xen dom0
      xen: hook io_apic read/write operations
      xen: create dummy ioapic mapping
      xen: implement pirq type event channels
      x86/io_apic: add get_nr_irqs_gsi()
      xen/apic: identity map gsi->irqs
      xen: direct irq registration to pirq event channels
      xen: bind pirq to vector and event channel
      xen/apic: program the apic triggering and polarity properly

 arch/x86/include/asm/io_apic.h |    7 +
 arch/x86/include/asm/xen/pci.h |   13 ++
 arch/x86/kernel/acpi/boot.c    |   18 +++-
 arch/x86/kernel/io_apic.c      |   37 +++++-
 arch/x86/xen/Kconfig           |   11 ++
 arch/x86/xen/Makefile          |    3 +-
 arch/x86/xen/apic.c            |   57 +++++++++
 arch/x86/xen/enlighten.c       |    2 +
 arch/x86/xen/mmu.c             |   10 ++
 arch/x86/xen/pci.c             |   83 +++++++++++++
 arch/x86/xen/xen-ops.h         |    6 +
 drivers/xen/events.c           |  260 +++++++++++++++++++++++++++++++++++++++-
 include/xen/events.h           |   22 ++++
 13 files changed, 521 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/pci.h
 create mode 100644 arch/x86/xen/apic.c
 create mode 100644 arch/x86/xen/pci.c

Thanks,
	J
