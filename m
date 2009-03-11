Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbZCKT7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbZCKT7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZCKT7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:59:07 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:38955 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZCKT7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:59:06 -0400
Date: Wed, 11 Mar 2009 20:58:55 +0100
Message-Id: <634847794@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] xen: core dom0 support
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/IctyXTO/RvLROkAKE1bMgu0/esn8xHUfPh2xshKOljXhdl
 vqgOIA4v3tAtQEaz4D1qwlVIEm0CqHftAyXZ03Yslj80dXIoVQ=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so - after a lot of discussion about this, can we expect linux getting dom0 support or not ?

besides vmware, xen is the most important and popular virtualization solution, existing for years now.

there are still many (new) processors around which do have NO virtualization support, and if i look at the current market share of kvm based virtualization solution, i wonder why xen vs. kvm is being discussed at all.  

is dom0 support really that intrusive, especially in comparison to domU support (which is already in) ?

i think dom0 AND domU support is what users want.....

>to patched up (old) kernels for dom0.  This is a real problem because 
>all the drivers for interesting new devices are in the new kernels, so 
>there's an additional burden of backporting device support into old kernels.
>
>    J

yes. i already had big trouble to install xenserver enterprise product on several machines now, and this really sucks big !
it`s that old game: new machine, windows - no problem. linux? sles? rhel? driver disk? doh!

esx sucks because of proprietary, raped linux drivers where also half of the ones i need are enirely missing and xenserver is not better with that, as it is using an outdated dom0 kernel.....

regards
roland




List:       linux-kernel
Subject:    [PATCH] xen: core dom0 support
From:       Jeremy Fitzhardinge <jeremy () goop ! org>
Date:       2009-02-28 1:59:06
Message-ID: 1235786365-17744-1-git-send-email-jeremy () goop ! org
[Download message RAW]


Hi,

This series implements the core parts of Xen dom0 support; that is, just
enough to get the kernel started when booted by Xen as a dom0 kernel.

The Xen dom0 kernel runs as a normal paravirtualized Xen kernel, but
it also has the additional responsibilty for managing all the machine's
hardware, as Xen itself has almost no internal driver support (it barely
even knows about PCI).

This series includes:
 - setting up a Xen hvc console
 - initializing Xenbus
 - enabling IO permissions for the kernel
 - MTRR setup hooks
 - Use _PAGE_IOMAP to allow direct hardware mappings
 - add a paravirt-ops for page_is_ram, to allow Xen to exclude granted pages
 - enable the use of a vga console

Not included in this series is the hooks into apic setup; that's next.

This may be pulled from:

The following changes since commit cc2f3b455c8efa01c66b8e66df8aad1da9310901:
  Ingo Molnar (1):
        Merge branch 'sched/urgent'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push/xen/dom0/core

Ian Campbell (4):
      xen: disable PAT
      xen/dom0: Use host E820 map
      xen: implement XENMEM_machphys_mapping
      xen: clear reserved bits in l3 entries given in the initial pagetables

Jeremy Fitzhardinge (6):
      xen dom0: Make hvc_xen console work for dom0.
      xen-dom0: only selectively disable cpu features
      xen/dom0: use _PAGE_IOMAP in ioremap to do machine mappings
      paravirt/xen: add pvop for page_is_ram
      xen/dom0: add XEN_DOM0 config option
      xen: allow enable use of VGA console on dom0

Juan Quintela (2):
      xen dom0: Initialize xenbus for dom0.
      xen dom0: Set up basic IO permissions for dom0.

Mark McLoughlin (5):
      xen mtrr: Use specific cpu_has_foo macros instead of generic cpu_has()
      xen mtrr: Kill some unneccessary includes
      xen mtrr: Use generic_validate_add_page()
      xen mtrr: Implement xen_get_free_region()
      xen mtrr: Add xen_{get,set}_mtrr() implementations

Stephen Tweedie (2):
      xen dom0: Add support for the platform_ops hypercall
      xen mtrr: Add mtrr_ops support for Xen mtrr

 arch/x86/include/asm/page.h             |    9 +-
 arch/x86/include/asm/paravirt.h         |    7 +
 arch/x86/include/asm/pat.h              |    5 +
 arch/x86/include/asm/xen/hypercall.h    |    8 +
 arch/x86/include/asm/xen/interface.h    |    6 +-
 arch/x86/include/asm/xen/interface_32.h |    5 +
 arch/x86/include/asm/xen/interface_64.h |   13 +--
 arch/x86/include/asm/xen/page.h         |   15 +--
 arch/x86/kernel/cpu/mtrr/Makefile       |    1 +
 arch/x86/kernel/cpu/mtrr/amd.c          |    1 +
 arch/x86/kernel/cpu/mtrr/centaur.c      |    1 +
 arch/x86/kernel/cpu/mtrr/cyrix.c        |    1 +
 arch/x86/kernel/cpu/mtrr/generic.c      |    1 +
 arch/x86/kernel/cpu/mtrr/main.c         |   11 +-
 arch/x86/kernel/cpu/mtrr/mtrr.h         |    7 +
 arch/x86/kernel/cpu/mtrr/xen.c          |  120 ++++++++++++++++
 arch/x86/kernel/paravirt.c              |    1 +
 arch/x86/mm/ioremap.c                   |    2 +-
 arch/x86/mm/pat.c                       |    5 -
 arch/x86/xen/Kconfig                    |   26 ++++
 arch/x86/xen/Makefile                   |    3 +-
 arch/x86/xen/enlighten.c                |   58 ++++++--
 arch/x86/xen/mmu.c                      |  135 ++++++++++++++++++-
 arch/x86/xen/setup.c                    |   51 ++++++-
 arch/x86/xen/vga.c                      |   65 +++++++++
 arch/x86/xen/xen-ops.h                  |   12 ++
 drivers/char/hvc_xen.c                  |  101 +++++++++-----
 drivers/xen/events.c                    |    2 +-
 drivers/xen/xenbus/xenbus_probe.c       |   30 ++++-
 include/xen/events.h                    |    2 +
 include/xen/interface/memory.h          |   42 ++++++
 include/xen/interface/platform.h        |  232 +++++++++++++++++++++++++++++++
 include/xen/interface/xen.h             |   41 ++++++
 33 files changed, 931 insertions(+), 88 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mtrr/xen.c
 create mode 100644 arch/x86/xen/vga.c
 create mode 100644 include/xen/interface/platform.h

Thanks,
	J

_______________________________________________________________________
DSL zum Nulltarif + 20 Euro Extraprämie bei Online-Bestellung über die
DSL Freundschaftswerbung! http://dsl.web.de/?ac=OM.AD.AD008K15279B7069a

