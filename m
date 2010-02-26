Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965549Ab0BZRjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:39:37 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:56295 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965567Ab0BZRjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:39:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Qb/mF2j7kQdE7i36PcC4WBQUqlEcq2PCztOVWSGkQleK3NA6uROyfhzYHWGawmkV0he+sXKlfdy05zBOajkWcYaXERfFsrIT/KjDilTKytrQrQRaa3tVT6nKV2PFQsSZ;
Date: Fri, 26 Feb 2010 09:39:57 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI changes for 2.6.34
Message-ID: <20100226093957.7b99d09c@jbarnes-piketon>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
bee415ce427d1eab6cfb30221461c7d20cbf1903: Linus Torvalds (1):
        Merge branch 'perf-fixes-for-linus' of
git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next

There are a few somewhat scary bits in this request:
  - Bjorn's _CRS data changes
  - Yinghai's resource reallocation code
  - Rafael's runtime PM code

If you recall, we tried to enable _CRS last release and it caused
trouble, in particular because our existing code couldn't handle the
number of resources provided by some _CRS implementations.  Bjorn's
fixed that though, and added code to use _CRS data by default on any
machine made in 2008 or later, which allows it to fix some existing
bugs on machines where pci=use_crs was previously required.  Other bugs
requiring the old intel_bus.c code are also fixed by using _CRS by
default, now that the affected machines are running with production
firmware.

Yinghai's code also affects resource allocation.  His patchset will
evaluate the resource tree at boot time looking for devices whose
resources couldn't be enabled because their upstream bridge window
wasn't large enough.  If it find any, it'll free the associated
resources and re-try, attempting to get a large enough bridge window to
enable affected leaf devices.  If that fails, it'll recurse higher into
the resource tree.  With luck, it'll manage to make our resource
allocation code more effective by overriding over conservative BIOS
settings and giving Linux access to more device resources.

Finally there's Rafael's PM code.  It should be in pretty good shape
now.  There may be a few more ACPI changes on the way, but it's seen a
lot of testing in previous iterations, and has seen a lot of review as
well, so hopefully it won't cause any big problems.

Shortlog and diffstat below.

Thanks,
Jesse

Andrew Morton (1):
      PCI hotplug: check ioremap() return value in ibmphp_ebda.c

Bjorn Helgaas (5):
      PCI: split up pci_read_bridge_bases()
      PCI: read bridge windows before filling in subtractive decode resources
      PCI: add pci_bus_for_each_resource(), remove direct bus->resource[] refs
      PCI: augment bus resource table with a list
      x86/PCI: use host bridge _CRS info by default on 2008 and newer machines

Chandru (1):
      PCI hotplug: ibmphp: read the length of ebda and map entire ebda region

Dominik Brodowski (2):
      resource/PCI: align functions now return start of resource
      resource/PCI: mark struct resource as const

Jesse Barnes (1):
      PCI hotplug: remove obsolete usage of get_bus_speed from rpaphp hotplug ops

Jiri Slaby (2):
      PCI hotplug: fix memory leaks
      PCI: hotplug/cpcihp, fix pci device refcounting

Kenji Kaneshige (3):
      PCI: mark is_pcie obsolete
      PCIe PME: use pci_is_pcie()
      PCIe PME: use pci_pcie_cap()

Matthew Wilcox (7):
      PCI: Rewrite pci_scan_slot
      PCI: Unify pcie_link_speed and pci_bus_speed
      PCI: Make current and maximum bus speeds part of the PCI core
      PCI: Add support for detection of PCIe and PCI-X bus speeds
      PCI: Add support for AGP in cur/max bus speed
      PCI: Add support for reporting PCIe 3.0 speeds
      PCI: Make pci_scan_slot more robust

Rafael J. Wysocki (10):
      PCI: Clean up build for CONFIG_PCI_QUIRKS unset
      PCI PM: Add function for checking PME status of devices
      PCI PM: PCIe PME root port service driver
      PCI PM: Make it possible to force using INTx for PCIe PME signaling
      ACPI: Use GPE reference counting to support shared GPEs
      ACPI / PM: Add more run-time wake-up fields
      ACPI / ACPICA: Multiple system notify handlers per device
      PCI / ACPI / PM: Platform support for PCI PME wake-up
      PCI PM: Run-time callbacks for PCI bus type
      ACPI: Use GPE reference counting to support shared GPEs

Randy Dunlap (1):
      PCI hotplug: fix ibmphp build error

Seth Heasley (1):
      x86/PCI: irq and pci_ids patch for Intel Cougar Point DeviceIDs

Thomas Gleixner (1):
      x86/PCI: Prevent mmconfig memory corruption

Tilman Schmidt (1):
      PCI: push deprecated pci_find_device() function to last user

Yinghai Lu (12):
      PCI: separate pci_setup_bridge to small functions
      resource: add release_child_resources
      PCI: don't dump resource when bus resource flags indicates unused
      PCI: add pci_bridge_release_resources and pci_bus_release_bridge_resources
      PCI: add failed_list to pci_bus_assign_resources
      PCI: reject mmio ranges starting at 0 on pci_bridge read
      PCI: don't shrink bridge resources
      PCI: update bridge resources to get more big ranges in PCI assign unssigned
      PCI: introduce pci_assign_unassigned_bridge_resources
      PCI: pciehp: cleanup flow in pciehp_configure_device
      PCI: pciehp: second try to get big range for pcie devices
      PCI: set PCI_PREF_RANGE_TYPE_64 in pci_bridge_check_ranges

 Documentation/kernel-parameters.txt     |   16 +-
 arch/alpha/kernel/pci.c                 |    6 +-
 arch/arm/kernel/bios32.c                |    8 +-
 arch/cris/arch-v32/drivers/pci/bios.c   |   16 +-
 arch/frv/mb93090-mb00/pci-frv.c         |   16 +-
 arch/ia64/include/asm/acpi.h            |    1 +
 arch/ia64/pci/pci.c                     |   22 +-
 arch/mips/pci/pci.c                     |    6 +-
 arch/mips/pmc-sierra/yosemite/ht.c      |   10 +-
 arch/mn10300/unit-asb2305/pci-asb2305.c |   16 +-
 arch/mn10300/unit-asb2305/pci.c         |    6 +-
 arch/parisc/kernel/pci.c                |   10 +-
 arch/powerpc/kernel/pci-common.c        |   24 +-
 arch/powerpc/platforms/fsl_uli1575.c    |   12 +-
 arch/sh/drivers/pci/pci.c               |    6 +-
 arch/sparc/kernel/pci.c                 |    5 +-
 arch/sparc/kernel/pcic.c                |    5 +-
 arch/x86/include/asm/pci_x86.h          |    1 +
 arch/x86/pci/acpi.c                     |   82 +++--
 arch/x86/pci/bus_numa.c                 |    3 +-
 arch/x86/pci/bus_numa.h                 |    3 +-
 arch/x86/pci/common.c                   |    3 +
 arch/x86/pci/i386.c                     |   14 +-
 arch/x86/pci/irq.c                      |    2 +
 arch/x86/pci/mmconfig-shared.c          |   17 +-
 arch/xtensa/kernel/pci.c                |   15 +-
 drivers/acpi/acpica/acevents.h          |   10 +-
 drivers/acpi/acpica/aclocal.h           |    2 +
 drivers/acpi/acpica/acobject.h          |    2 +
 drivers/acpi/acpica/evgpe.c             |  161 ++---------
 drivers/acpi/acpica/evgpeblk.c          |   87 ++----
 drivers/acpi/acpica/evmisc.c            |   12 +-
 drivers/acpi/acpica/evxface.c           |  189 +++++++++---
 drivers/acpi/acpica/evxfevnt.c          |   96 +++++--
 drivers/acpi/button.c                   |   15 +-
 drivers/acpi/ec.c                       |   28 ++-
 drivers/acpi/internal.h                 |    2 -
 drivers/acpi/pci_bind.c                 |   14 +-
 drivers/acpi/pci_root.c                 |    9 +
 drivers/acpi/scan.c                     |   38 ++-
 drivers/acpi/sleep.c                    |   15 +-
 drivers/acpi/system.c                   |    4 +-
 drivers/acpi/wakeup.c                   |   84 ++----
 drivers/isdn/hisax/Kconfig              |   18 +-
 drivers/isdn/hisax/avm_pci.c            |    6 +-
 drivers/isdn/hisax/bkm_a4t.c            |    2 +-
 drivers/isdn/hisax/bkm_a8.c             |    2 +-
 drivers/isdn/hisax/diva.c               |   14 +-
 drivers/isdn/hisax/elsa.c               |    8 +-
 drivers/isdn/hisax/enternow_pci.c       |    2 +-
 drivers/isdn/hisax/gazel.c              |    8 +-
 drivers/isdn/hisax/hfc_pci.c            |    2 +-
 drivers/isdn/hisax/hisax.h              |   23 ++
 drivers/isdn/hisax/niccy.c              |    6 +-
 drivers/isdn/hisax/nj_s.c               |    2 +-
 drivers/isdn/hisax/nj_u.c               |    2 +-
 drivers/isdn/hisax/sedlbauer.c          |    6 +-
 drivers/isdn/hisax/telespci.c           |    2 +-
 drivers/isdn/hisax/w6692.c              |    2 +-
 drivers/pci/Kconfig                     |   11 -
 drivers/pci/Makefile                    |    5 +-
 drivers/pci/bus.c                       |   56 ++++-
 drivers/pci/hotplug/acpiphp_core.c      |    2 -
 drivers/pci/hotplug/cpcihp_generic.c    |    1 +
 drivers/pci/hotplug/cpqphp.h            |    2 -
 drivers/pci/hotplug/cpqphp_core.c       |   57 +---
 drivers/pci/hotplug/cpqphp_ctrl.c       |   27 +-
 drivers/pci/hotplug/ibmphp_core.c       |  106 ++-----
 drivers/pci/hotplug/ibmphp_ebda.c       |   13 +-
 drivers/pci/hotplug/ibmphp_hpc.c        |    1 +
 drivers/pci/hotplug/pci_hotplug_core.c  |  132 --------
 drivers/pci/hotplug/pciehp_core.c       |   25 --
 drivers/pci/hotplug/pciehp_ctrl.c       |    1 +
 drivers/pci/hotplug/pciehp_hpc.c        |   72 +----
 drivers/pci/hotplug/pciehp_pci.c        |   23 +-
 drivers/pci/hotplug/rpaphp_core.c       |   24 +-
 drivers/pci/hotplug/shpchp.h            |    2 -
 drivers/pci/hotplug/shpchp_core.c       |   35 ---
 drivers/pci/hotplug/shpchp_ctrl.c       |   14 +-
 drivers/pci/hotplug/shpchp_hpc.c        |  149 +++++-----
 drivers/pci/hotplug/shpchp_sysfs.c      |    9 +-
 drivers/pci/legacy.c                    |   34 --
 drivers/pci/pci-acpi.c                  |  211 +++++++++++++
 drivers/pci/pci-driver.c                |  160 ++++++++--
 drivers/pci/pci.c                       |  157 +++++++++-
 drivers/pci/pci.h                       |   16 +
 drivers/pci/pcie/Kconfig                |    4 +
 drivers/pci/pcie/Makefile               |    2 +
 drivers/pci/pcie/pme/Makefile           |    8 +
 drivers/pci/pcie/pme/pcie_pme.c         |  505 ++++++++++++++++++++++++++++++
 drivers/pci/pcie/pme/pcie_pme.h         |   28 ++
 drivers/pci/pcie/pme/pcie_pme_acpi.c    |   54 ++++
 drivers/pci/pcie/portdrv.h              |   17 +
 drivers/pci/pcie/portdrv_core.c         |   12 +-
 drivers/pci/pcie/portdrv_pci.c          |   27 ++
 drivers/pci/probe.c                     |  292 ++++++++++++++++--
 drivers/pci/quirks.c                    |   14 +-
 drivers/pci/setup-bus.c                 |  506 +++++++++++++++++++++++++++----
 drivers/pci/slot.c                      |   55 ++++
 drivers/pcmcia/rsrc_mgr.c               |   13 +-
 drivers/pcmcia/rsrc_nonstatic.c         |   25 +-
 drivers/pcmcia/yenta_socket.c           |    5 +-
 include/acpi/acpi_bus.h                 |    6 +
 include/acpi/acpi_drivers.h             |    1 +
 include/acpi/acpixf.h                   |    6 +-
 include/acpi/actypes.h                  |   28 +--
 include/linux/ioport.h                  |    7 +-
 include/linux/pci-acpi.h                |    7 +
 include/linux/pci.h                     |  109 +++++--
 include/linux/pci_hotplug.h             |   41 +---
 include/linux/pci_ids.h                 |    3 +
 kernel/power/Kconfig                    |    5 +
 kernel/resource.c                       |   44 +++-
 113 files changed, 3007 insertions(+), 1360 deletions(-)
 delete mode 100644 drivers/pci/legacy.c
 create mode 100644 drivers/pci/pcie/pme/Makefile
 create mode 100644 drivers/pci/pcie/pme/pcie_pme.c
 create mode 100644 drivers/pci/pcie/pme/pcie_pme.h
 create mode 100644 drivers/pci/pcie/pme/pcie_pme_acpi.c


-- 
Jesse Barnes, Intel Open Source Technology Center
