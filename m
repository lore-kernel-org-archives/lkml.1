Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbYJNLai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbYJNLai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbYJNLa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:30:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:62922 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247AbYJNLa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:30:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,409,1220252400"; 
   d="scan'208";a="347864302"
Date: Tue, 14 Oct 2008 18:34:24 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: linux-pci@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, randy.dunlap@oracle.com,
       grundler@parisc-linux.org, achiang@hp.com, matthew@wil.cx,
       rdreier@cisco.com, greg@kroah.com, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH 0/8 v4] PCI: Linux kernel SR-IOV support
Message-ID: <20081014103424.GA1704@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Following patches are intended to support SR-IOV capability in the
Linux kernel. With these patches, people can turn a PCI device with
the capability into multiple ones from software perspective, which
will benefit KVM and achieve other purposes such as QoS, security,
and etc.

[PATCH 1/8 v4] PCI: define PCI resource names in a 'enum'
[PATCH 2/8 v4] PCI: export __pci_read_base
[PATCH 3/8 v4] PCI: export pci_alloc_child_bus
[PATCH 4/8 v4] PCI: add a wrapper for resource_alignment
[PATCH 5/8 v4] PCI: add a new function to map BAR offset
[PATCH 6/8 v4] PCI: support the SR-IOV capability
[PATCH 7/8 v4] PCI: reserve bus range for the SR-IOV device
[PATCH 8/8 v4] PCI: document the changes

---

 b/Documentation/DocBook/kernel-api.tmpl |    1 
 b/Documentation/PCI/pci-iov-howto.txt   |  223 ++++++++
 b/drivers/pci/Kconfig                   |   12 
 b/drivers/pci/Makefile                  |    2 
 b/drivers/pci/iov.c                     |  853 ++++++++++++++++++++++++++++++++
 b/drivers/pci/pci-sysfs.c               |    4 
 b/drivers/pci/pci.c                     |   19 
 b/drivers/pci/pci.h                     |    9 
 b/drivers/pci/probe.c                   |    2 
 b/drivers/pci/proc.c                    |    7 
 b/drivers/pci/setup-bus.c               |    4 
 b/drivers/pci/setup-res.c               |    8 
 b/include/linux/pci.h                   |   38 -
 b/include/linux/pci_regs.h              |   22 
 drivers/pci/iov.c                       |   24 
 drivers/pci/pci-sysfs.c                 |    4 
 drivers/pci/pci.c                       |   61 ++
 drivers/pci/pci.h                       |   65 ++
 drivers/pci/probe.c                     |   39 -
 drivers/pci/setup-res.c                 |   14 
 include/linux/pci.h                     |   57 ++
 21 files changed, 1397 insertions(+), 71 deletions(-)

---

Single Root I/O Virtualization (SR-IOV) capability defined by PCI-SIG
is intended to enable multiple system software to share PCI hardware
resources.  PCI device that supports this capability can be extended
to one Physical Functions plus multiple Virtual Functions. Physical
Function, which could be considered as the "real" PCI device, reflects
the hardware instance and manages all physical resources. Virtual
Functions are associated with a Physical Function and shares physical
resources with the Physical Function.Software can control allocation of
Virtual Functions via registers encapsulated in the capability structure.

SR-IOV specification can be found at
http://www.pcisig.com/members/downloads/specifications/iov/sr-iov1.0_11Sep07.pdf

Devices that support SR-IOV are available from following vendors:
http://download.intel.com/design/network/ProdBrf/320025.pdf
http://www.netxen.com/products/chipsolutions/NX3031.html
http://www.neterion.com/products/x3100.html
