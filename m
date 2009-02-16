Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbZBPXyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbZBPXyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757206AbZBPXr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:47:58 -0500
Received: from gw.goop.org ([64.81.55.164]:45781 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665AbZBPXr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:47:56 -0500
Message-ID: <4999FB2A.9050802@goop.org>
Date: Mon, 16 Feb 2009 15:47:54 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Xen-devel] [PATCH 00/19] *** SUBJECT HERE ***
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>	<cover.1234826723.git.jeremy.fitzhardinge@citrix.com> <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> *** BLURB HERE ***
>   

Bugger.  Teach me to send before saving.  That should be:

Subject: [PATCH 00/19] xen/dom0: core implementation

This series implements the core part of Xen dom0 support.  Domain 0
(dom0) is the first Xen domain started on system boot, loaded by the
hypervisor itself.  Unlike a normal domain, it has direct hardware
access, and is responsible for supplying the device drivers for most
of the system's hardware.

The series covers the following areas:
 - dom0 console support
 - initialize xenbus
 - give dom0 kernel direct hardware access (both IO ports and IO mappings)
 - enable more CPU features, specifically APIC and ACPI
 - support for dom0-specific hypercalls
 - Kconfig updates to enable dom0
 - MTRR updates, to paravirtualize the mtrr via Xen

This series can also be pulled from:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push/xen/dom0/core

Thanks,
	J

Ian Campbell (4):
  xen: disable PAT
  xen/dom0: Use host E820 map
  xen: implement XENMEM_machphys_mapping
  xen: clear reserved bits in l3 entries given in the initial
    pagetables

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
  xen mtrr: Use specific cpu_has_foo macros instead of generic
    cpu_has()
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



