Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab0BLQ7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 11:59:52 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:22110 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab0BLQ7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:59:49 -0500
Subject: [PATCH v3 0/7] PCI: try "pci=use_crs" again
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
       Peter Haight <peterh@sapros.com>, Gary Hade <garyhade@us.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-am33-list@redhat.com, Yinghai Lu <yinghai@kernel.org>,
       linux-alpha@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Date: Fri, 12 Feb 2010 09:59:46 -0700
Message-ID: <20100212165532.19522.47240.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Historically, Linux has assumed a single PCI host bridge, with that bridge
claiming all the address space left after RAM and legacy devices are taken out.

If the system contains multiple host bridges, we can no longer operate under
that assumption.  We have to know what parts of the address space are claimed
by each bridge so that when we assign resources to a PCI device, we take them
from a range claimed by the upstream host bridge.

On x86 and ia64, we use ACPI to enumerate all the PCI host bridges in the
system, and part of the host bridge description is the "_CRS" (current resource
settings" property, which lists the address space used by the bridge.  On x86,
we currently ignore most of the _CRS information.  This patch series changes
this, so we will use _CRS to learn about the host bridge windows.

Since most x86 machines with multiple host bridges are relatively new, this
series only turns this on for machines with BIOS dates of 2008 or newer.

Changes from v2 to v3:
    - Fix alpha, powerpc, and mn10300 references to pci_bus resource table
    - Turn on "pci=use_crs" for 2008 and newer, not 2010 and newer
    - Remove Toshiba A355 quirk (BIOS date is 2009, so automatically included)
    - Remove IBM x3850 and x3950 quirks (BIOS dates in 2008, so automatically
      included)
    - Leave IBM x3800 quirk (pre-2008 BIOS)
    - Use "bool" for pci_use_crs (new to me, but I see akpm suggesting it)
    - Reorder so the important patches are first

Changes from v1 to v2:
    - Rebase to be6e9f7853e
    - Add patch to clean up "disabled window" printk
    - Add bugzilla reference comment in use_crs DMI quirk

---

Bjorn Helgaas (7):
      PCI: split up pci_read_bridge_bases()
      PCI: read bridge windows before filling in subtractive decode resources
      PCI: replace bus resource table with a list
      x86/PCI: use host bridge _CRS info by default on 2008 and newer machines
      PCI: make disabled window printk style match the enabled ones
      PCI: break out primary/secondary/subordinate for readability
      PCI: reference bridge window resources explicitly


 Documentation/kernel-parameters.txt  |    8 +-
 arch/alpha/kernel/pci.c              |    5 +
 arch/ia64/include/asm/acpi.h         |    1 
 arch/ia64/pci/pci.c                  |   20 ++--
 arch/mn10300/unit-asb2305/pci.c      |    7 +
 arch/powerpc/kernel/pci-common.c     |   26 +++--
 arch/powerpc/kernel/pci_64.c         |   18 ++--
 arch/powerpc/kernel/pci_of_scan.c    |   12 ++
 arch/powerpc/platforms/fsl_uli1575.c |   15 ++-
 arch/x86/include/asm/pci_x86.h       |    1 
 arch/x86/pci/acpi.c                  |   82 ++++++++++-------
 arch/x86/pci/bus_numa.c              |    9 +-
 arch/x86/pci/bus_numa.h              |    3 -
 arch/x86/pci/common.c                |    3 +
 drivers/acpi/pci_root.c              |    1 
 drivers/eisa/pci_eisa.c              |    4 -
 drivers/pci/bus.c                    |   50 ++++++++++
 drivers/pci/hotplug/shpchp_sysfs.c   |   15 ++-
 drivers/pci/pci.c                    |    6 +
 drivers/pci/probe.c                  |  108 +++++++++++++++-------
 drivers/pci/quirks.c                 |    4 -
 drivers/pci/setup-bus.c              |  168 +++++++++++++++++-----------------
 drivers/pcmcia/rsrc_nonstatic.c      |    7 +
 drivers/pcmcia/yenta_socket.c        |   46 +++++----
 include/acpi/acpi_drivers.h          |    1 
 include/linux/pci.h                  |   27 ++++-
 26 files changed, 401 insertions(+), 246 deletions(-)
