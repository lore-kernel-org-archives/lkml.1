Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab0BHWoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:44:23 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:15875 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab0BHWoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:44:22 -0500
Subject: [PATCH v2 0/7] PCI: try "pci=use_crs" again
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-pci@vger.kernel.org, Peter Haight <peterh@sapros.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 08 Feb 2010 15:44:18 -0700
Message-ID: <20100208224236.27954.4358.stgit@bob.kio>
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

We use ACPI to enumerate all the PCI host bridges in the system, and part of
the host bridge description is the "_CRS" (current resource settings" property,
which lists the address space used by the bridge.  On x86, we currently ignore
most of the _CRS information.  This patch series changes this, so we will use
_CRS to learn about the host bridge windows.

Since most x86 machines with multiple host bridges are relatively new, this
series only turns this on for machines with BIOS dates of 2010 or newer and for
a few machines we know to require it.

These apply on be6e9f7853e.  I added an initial patch to clean up the
formatting of the disabled window printk.

Changes since v1:
    - rebase to be6e9f7853e
    - add patch to clean up "disabled window" printk
    - add bugzilla reference comment in use_crs DMI quirk

---

Bjorn Helgaas (7):
      PCI: make disabled window printk style match the enabled ones
      PCI: break out primary/secondary/subordinate for readability
      PCI: split up pci_read_bridge_bases()
      PCI: read bridge windows before filling in subtractive decode resources
      PCI: replace bus resource table with a list
      x86/PCI: use host bridge _CRS info by default on 2010 and newer machines
      PCI: reference bridge window resources explicitly


 Documentation/kernel-parameters.txt |    8 +-
 arch/ia64/include/asm/acpi.h        |    1 
 arch/ia64/pci/pci.c                 |   20 ++--
 arch/x86/include/asm/pci_x86.h      |    1 
 arch/x86/pci/acpi.c                 |  105 +++++++++++++++-------
 arch/x86/pci/bus_numa.c             |    9 +-
 arch/x86/pci/common.c               |    3 +
 drivers/acpi/pci_root.c             |    1 
 drivers/pci/bus.c                   |   50 ++++++++++
 drivers/pci/hotplug/shpchp_sysfs.c  |   15 ++-
 drivers/pci/pci.c                   |    6 +
 drivers/pci/probe.c                 |  108 +++++++++++++++--------
 drivers/pci/quirks.c                |    4 -
 drivers/pci/setup-bus.c             |  168 ++++++++++++++++++-----------------
 drivers/pcmcia/rsrc_nonstatic.c     |    7 +
 drivers/pcmcia/yenta_socket.c       |   46 ++++++----
 include/acpi/acpi_drivers.h         |    1 
 include/linux/pci.h                 |   27 ++++--
 18 files changed, 370 insertions(+), 210 deletions(-)
