Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbYI0I1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbYI0I1u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 04:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYI0I1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 04:27:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:48121 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbYI0I1j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 04:27:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,319,1220252400"; 
   d="scan'208";a="341193242"
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Roland Dreier <rdreier@cisco.com>, Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Sat, 27 Sep 2008 16:27:36 +0800
Subject: [PATCH 0/6 v3] PCI: Linux kernel SR-IOV support
Thread-Topic: [PATCH 0/6 v3] PCI: Linux kernel SR-IOV support
Thread-Index: AckgeuUtHtCG72ooTAabiHR/lsUO6w==
Message-ID: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5EF@pdsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Following patches are intended to support SR-IOV capability in the Linux kernel. With these patches, people can turn a PCI device with the capability into multiple ones from software perspective, which can benefit KVM and achieve other purposes such as QoS, security, etc.

[PATCH 1/6 v3] PCI: export some functions and macros
[PATCH 2/6 v3] PCI: add new general functions
[PATCH 3/6 v3] PCI: support ARI capability
[PATCH 4/6 v3] PCI: support SR-IOV capability
[PATCH 5/6 v3] PCI: reserve bus range for SR-IOV device
[PATCH 6/6 v3] PCI: document the change

 b/Documentation/DocBook/kernel-api.tmpl |    2
 b/Documentation/PCI/pci-iov-howto.txt   |  228 ++++++++
 b/drivers/pci/Kconfig                   |   12
 b/drivers/pci/Makefile                  |    2
 b/drivers/pci/iov.c                     |  850 ++++++++++++++++++++++++++++++++
 b/drivers/pci/pci-sysfs.c               |   10
 b/drivers/pci/pci.c                     |    2
 b/drivers/pci/pci.h                     |   20
 b/drivers/pci/probe.c                   |   50 -
 b/drivers/pci/proc.c                    |    7
 b/drivers/pci/setup-bus.c               |    4
 b/drivers/pci/setup-res.c               |    2
 b/include/linux/pci.h                   |    5
 b/include/linux/pci_regs.h              |   15
 drivers/pci/iov.c                       |   24
 drivers/pci/pci-sysfs.c                 |  123 ++--
 drivers/pci/pci.c                       |  113 +++-
 drivers/pci/pci.h                       |   75 ++
 drivers/pci/probe.c                     |   40 +
 drivers/pci/setup-bus.c                 |    4
 drivers/pci/setup-res.c                 |   27 -
 include/linux/pci.h                     |   98 +++
 include/linux/pci_regs.h                |   22
 23 files changed, 1580 insertions(+), 155 deletions(-)

---

Single Root I/O Virtualization (SR-IOV) capability defined by PCI-SIG is intended to enable multiple system software to share PCI hardware resources. PCI device that supports this capability can be extended to one Physical Functions plus multiple Virtual Functions. Physical Function, which could be considered as the "real" PCI device, reflects the hardware instance and manages all physical resources. Virtual Functions are associated with a Physical Function and shares physical resources with the Physical Function. Software can control allocation of Virtual Functions via registers encapsulated in the capability structure.

SR-IOV specification can be found at http://www.pcisig.com/members/downloads/specifications/iov/sr-iov1.0_11Sep07.pdf

Devices that support SR-IOV are available from following vendors:
http://download.intel.com/design/network/ProdBrf/320025.pdf
http://www.netxen.com/products/chipsolutions/NX3031.html
http://www.neterion.com/products/x3100.html
