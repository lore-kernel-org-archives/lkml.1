Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYKJWav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYKJWav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYKJWah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:30:37 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:48756 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYKJWag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:30:36 -0500
From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH v4 0/7] call _OSC support during root bridge discovery
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: andrew.patterson@hp.com, matthew@wil.cx, kaneshige.kenji@jp.fujitsu.com,
       bjorn.helgaas@hp.com
Date: Mon, 10 Nov 2008 15:30:35 -0700
Message-ID: <20081110223035.30539.88942.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v4 of the "call _OSC support during root bridge discovery"
patchset.  

We now call pci_acpi_osc_support() twice during
acpi_pci_root_add(). Once at the beginning with a default flag
OSC_PCI_SEGMENT_GROUPS_SUPPORT set since we need this to evaluate _SEG
and _BBN. And once again after the bus is scanned to set all the other
_OSC flags. The second call is performed after all PCI quirks are
finished.


I recently reported a problem where a machine with close to a 100 PCIe
root bridges was taking half an hour to just call _OSC.  The root
cause is the AER code calling:

        pcie_osc_support_set(OSC_EXT_PCI_CONFIG_SUPPORT);

for each bridge.  The pcie_osc_support_set() function also iterates
over each bridge, so _OSC is called a quadratic number of times.

One solution to this problem would be to just move the call to
pcie_osc_support_set() to aer_service_init(), so _OSC support is only
called on each bridge once.

Matthew Wilcox came up with a better solution.  He says "Why should a
driver be calling pcie_osc_support_set() anyway?  This is something
the PCI core should be taking care of for it."

Matthew provided a patch for this solution that I massaged into the
following patch series.

It creates a new function (pci_acpi_osc_support()) which is called
from pci_root.c before we call any other methods on the device (as
recommended by the ACPI spec).  Since we know what capabilities the
system supports, individual modules do not now need to inform the core
of their support for various capabilities.

Some work that still needs to be done (provided by Matthew): 

o All the existing _OSC code should be moved from pci-acpi.c to
  pci_root.c.  I also think the acpi_osc_data should be made part of
  the acpi_pci_root struct, eliminating a separate allocation.

o We could also use an interface that iterates over all existing
  busses calling _OSC with new flags.  Shouldn't be hard, once it's
  integrated into pci_root.c.

o Further ahead, we don't actually check that the bits we asked for
  (in 'control') were actually granted to us.  The PCI firmware spec
  is quite explicit about interdependencies amongst the bits.

o We also need to re-evaluate _OSC when coming out of S4.

This patch series duplicates currently functionality while removing
our quadratic problem.  I believe that it can be applied now while the
above new functionality can be implemented some time in the future.

This patch series applies to the linux-next branch of pci-2.6 git
repository.  I expect it will also work with linux-next.

Diff stats:

 arch/x86/pci/common.c              |    8 +++++++
 drivers/acpi/pci_root.c            |   20 +++++++++++++++++++
 drivers/pci/msi.c                  |   31 ++++++++++-------------------
 drivers/pci/pci-acpi.c             |   37 ++++++++++++-----------------------
 drivers/pci/pci.c                  |   15 ++++++++++++-
 drivers/pci/pci.h                  |    2 -
 drivers/pci/pcie/aer/aerdrv_acpi.c |    1 -
 drivers/pci/pcie/aspm.c            |   27 ++++++++-----------------
 include/linux/pci-acpi.h           |   14 ++----------
 include/linux/pci.h                |   16 +++++++++++++++
 10 files changed, 93 insertions(+), 78 deletions(-)

Commits:

  - Include missing acpi.h file in pci-acpi.h.
  - Call _OSC support during root bridge discovery.
  - PCI extended config _OSC support called when root bridge added.
  - PCIe ASPM _OSC support capabilities called when root bridge added.
  - PCIe AER _OSC support capabilities called when root bridge added.
  - PCI MSI _OSC support capabilities called when root bridge added.
  - Remove obsolete _OSC capability support functions.

-- 
Andrew Patterson

