Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbZGHEPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbZGHEPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZGHEOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:14:33 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:46912 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZGHEOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:14:08 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: [PATCH v2 for 2.6.32] SFI - Simple Firmware Interface support
Date: Wed, 08 Jul 2009 00:13:46 -0400
Message-id: <1247026438-20891-1-git-send-email-lenb@kernel.org>
X-Mailer: git-send-email 1.6.3.3.385.g60647
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is version 2 of the SFI patch series for Linux 2.6.32.
This series is based on 2.6.31-rc2, and is available in git:

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git sfi-test

We've tried to respond to all feedback on the v1 series.
In particular, thanks to Ingo Molnar and Andi Kleen for their thorough review.

We followed Andi's advice and deleted the data structure
to track tables, and instead we access all table headers in-place.
Indeed, this shrunk the memory footprint a bit.

We also now detect and optimize for the common case
where all SFI tables fit on a single page.

We added some small bits from the upcoming draft of SFI 0.7,
which should be available on http://simplefirmware.org shortly.
Of note, we can assert that the SYST shall not cross a 4K boundary.

Thanks,
-Len Brown & Tang-Feng, Intel Open Source Technology Center

---
 Documentation/kernel-parameters.txt |    5 +
 MAINTAINERS                         |   12 +
 arch/x86/Kconfig                    |    4 +-
 arch/x86/include/asm/io_apic.h      |    3 +-
 arch/x86/kernel/Makefile            |    1 +
 arch/x86/kernel/acpi/boot.c         |   22 --
 arch/x86/kernel/apic/io_apic.c      |   28 ++-
 arch/x86/kernel/e820.c              |    5 +
 arch/x86/kernel/setup.c             |    3 +
 arch/x86/kernel/sfi.c               |  284 +++++++++++++++++++++++++
 arch/x86/pci/mmconfig-shared.c      |    5 +-
 drivers/Makefile                    |    1 +
 drivers/acpi/tables.c               |    3 +
 drivers/sfi/Kconfig                 |   16 ++
 drivers/sfi/Makefile                |    3 +
 drivers/sfi/sfi_acpi.c              |  151 ++++++++++++++
 drivers/sfi/sfi_core.c              |  387 +++++++++++++++++++++++++++++++++++
 drivers/sfi/sfi_core.h              |   44 ++++
 include/linux/sfi.h                 |  198 ++++++++++++++++++
 include/linux/sfi_acpi.h            |   60 ++++++
 init/main.c                         |    2 +
 21 files changed, 1204 insertions(+), 33 deletions(-)
 create mode 100644 arch/x86/kernel/sfi.c
 create mode 100644 drivers/sfi/Kconfig
 create mode 100644 drivers/sfi/Makefile
 create mode 100644 drivers/sfi/sfi_acpi.c
 create mode 100644 drivers/sfi/sfi_core.c
 create mode 100644 drivers/sfi/sfi_core.h
 create mode 100644 include/linux/sfi.h
 create mode 100644 include/linux/sfi_acpi.h

commits:

Feng Tang (10):
      SFI, x86: add CONFIG_SFI
      SFI: document boot param "sfi=off"
      SFI: create include/linux/sfi.h
      SFI: add core support
      ACPI, x86: remove ACPI dependency on some IO-APIC routines
      SFI: add x86 support
      SFI, x86: hook e820() for memory map initialization
      SFI: Enable SFI to parse ACPI tables
      SFI, PCI: Hook MMCONFIG
      SFI: add boot-time initialization hooks

Len Brown (2):
      SFI: Simple Firmware Interface - new MAINTAINERS entry
      ACPI: check acpi_disabled in acpi_table_parse()

with this log:

commit 7d8801c4e11f26a68fca70798dc40d5f405b4be2
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue Jul 7 23:34:39 2009 -0400

    SFI: add boot-time initialization hooks
    
    There are two SFI boot-time hooks:
    
    sfi_init() maps the SYST using early_ioremap() and validates all the tables.
    
    sfi_init_late() re-maps SYST with ioremap(), and initializes
    the ACPI extension, if present.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 24fe646fcbbd9049850de4ac57cf6a67846b38c4
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue Jul 7 23:30:32 2009 -0400

    SFI, PCI: Hook MMCONFIG
    
    First check ACPI, and if that fails, ask SFI to find the MCFG.
    
    Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4e176b0f00143e2dfca4480402d3b27b3a0f835f
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jul 7 23:22:58 2009 -0400

    ACPI: check acpi_disabled in acpi_table_parse()
    
    Allow consumers of the acpi_table_parse() API
    to gracefully handle the acpi_disabled=1 case
    without checking the flag themselves.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5ab9dd34acc6209c5b6a3c754075e408e5298a2d
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue Jul 7 23:15:22 2009 -0400

    SFI: Enable SFI to parse ACPI tables
    
    Extend SFI to access standard ACPI tables.
    (eg. the PCI MCFG) using sfi_acpi_table_parse().
    
    Note that this is _not_ a hybrid ACPI + SFI mode.
    The platform boots in either ACPI mode or SFI mode.
    
    SFI runs only with acpi_disabled=1, which can be set
    at build-time via CONFIG_ACPI=n, or at boot time by
    the failure to find ACPI platform support.
    
    So this extension simply allows SFI-platforms to
    re-use existing standard table formats that happen to
    be defined to live in ACPI envelopes.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5bf6b3c7c08a76ea8dc52e9e07728c2958938952
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue Jul 7 23:11:44 2009 -0400

    SFI, x86: hook e820() for memory map initialization
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4676b1fee4cae65c678754fbdecae626ac161b81
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue Jul 7 23:09:19 2009 -0400

    SFI: add x86 support
    
    arch/x86/kernel/sfi.c serves the dual-purpose of supporting the
    SFI core with arch specific code, as well as a home for the
    arch-specific code that uses SFI.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bf8ea7cda3ad3f287f1c9164d366a94eae07a4a5
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue Jul 7 23:01:15 2009 -0400

    ACPI, x86: remove ACPI dependency on some IO-APIC routines
    
    Both ACPI and SFI x86 systems will use these io_apic routines:
    
    uniq_ioapic_id(u8 id);
    io_apic_get_unique_id(int ioapic, int apic_id);
    io_apic_get_version(int ioapic);
    io_apic_get_redir_entries(int ioapic);
    
    so move the 1st from acpi/boot.c to io_apic.c,
    and remove the #ifdef ACPI around the other three.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 10fb28adc204382cb3b1acc99eabbb369d378a0f
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue Jul 7 22:54:22 2009 -0400

    SFI: add core support
    
    drivers/sfi/sfi_core.c contains the generic SFI implementation.
    It has a private header, sfi_core.h, for its own use and the
    private use of future files in drivers/sfi/
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 56f1291c60859b65ac62521e7fe4b82e73205ef6
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue Jul 7 22:39:49 2009 -0400

    SFI: create include/linux/sfi.h
    
    include/linux/include/sfi.h defines everything that customers
    of SFI need to know in order to use the SFI suport in the kernel.
    
    The primary API is sfi_table_parse(), where a driver or another part
    of the kernel can supply a handler to parse the named table.
    
    sfi.h also includes the currently defined table signatures and table formats.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 57dac60d76c191e3bd72f186833fac01e4c5f8f1
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue Jul 7 22:33:09 2009 -0400

    SFI: document boot param "sfi=off"
    
    "sfi=off" is analogous to "acpi=off"
    
    In practice, "sfi=off" isn't likely to be very useful, for
    1. SFI is used only when ACPI is not available
    2. Today's SFI systems are not legacy PC-compatible
    
    ie. "sfi=off" on an ACPI-platform is a NO-OP,
    and "sfi=off" on an SFI-platform will likely result in boot failure.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d5a8e3203627c313e8fdbf4fa9ac1cb1cdc6706c
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue Jul 7 22:30:29 2009 -0400

    SFI, x86: add CONFIG_SFI
    
    analogous to ACPI, drivers/sfi/Kconfig is pulled in by arch/x86/Kconfig
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8e4a93858bce74ed3080dd607aa471023f1a2737
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jul 7 22:25:46 2009 -0400

    SFI: Simple Firmware Interface - new MAINTAINERS entry
    
    CONFIG_SFI=y shall enable the kernel to boot and run optimally
    on platforms that support the Simple Firmware Interface.
    
    Thanks to Jacob Pan for prototyping the initial Linux SFI support,
    and to Feng Tang for Linux bring-up and debug both in emulation
    and on Moorestown hardware.
    
    See http://simplefirmware.org for more information on SFI.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

