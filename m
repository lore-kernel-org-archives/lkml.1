Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab0BCXkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 18:40:11 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:31115 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848Ab0BCXj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 18:39:59 -0500
Subject: [PATCH v1 0/7] PCI: try enabling "pci=use_crs" again
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-pci@vger.kernel.org, Peter Haight <peterh@sapros.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 03 Feb 2010 16:38:55 -0700
Message-ID: <20100203233617.10803.92102.stgit@bob.kio>
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
a few machines that we know need it.

These apply on 0148b041be4e7, which is the current head of the linux-next
branch of Jesse's pci-2.6 git tree.  The first patch is just Jeff Garrett's
patch to remove intel_bus.c, so that is only here for people who want to test
the rest of the patches.  I expect Jesse will pick up Jeff's patch via Linus'
tree.

Gary and Peter have some of these problem machines, so I'm hoping they can give
this a whirl.

Larry, you reported the problem the last time I tried to turn on "pci=use_crs"
by default.  This series shouldn't affect your machine because it's not in the
whitelist, but I expect that if you boot the current kernel with "pci=use_crs",
it should still fail, and if you boot with these patches and "pci=use_crs", it
*should* work.  I know it's a lot to ask, but it'd be great if you had a chance
to try that.

Bjorn

---

Bjorn Helgaas (7):
      x86/PCI: remove IOH range fetching
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
 arch/x86/pci/Makefile               |    2 
 arch/x86/pci/acpi.c                 |  105 +++++++++++++++-------
 arch/x86/pci/bus_numa.c             |    9 +-
 arch/x86/pci/common.c               |    3 +
 arch/x86/pci/intel_bus.c            |   94 --------------------
 drivers/acpi/pci_root.c             |    1 
 drivers/pci/bus.c                   |   50 ++++++++++-
 drivers/pci/hotplug/shpchp_sysfs.c  |   15 ++-
 drivers/pci/pci.c                   |    6 +
 drivers/pci/probe.c                 |  102 +++++++++++++++-------
 drivers/pci/quirks.c                |    4 -
 drivers/pci/setup-bus.c             |  166 ++++++++++++++++++-----------------
 drivers/pcmcia/rsrc_nonstatic.c     |    7 +
 drivers/pcmcia/yenta_socket.c       |   46 ++++++----
 include/acpi/acpi_drivers.h         |    1 
 include/linux/pci.h                 |   27 ++++--
 20 files changed, 367 insertions(+), 301 deletions(-)
 delete mode 100644 arch/x86/pci/intel_bus.c

-- 
