Return-Path: <linux-kernel-owner+w=401wt.eu-S1761180AbZCTD1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761180AbZCTD1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbZCTDYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:24:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:53819 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373AbZCTDYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:24:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,392,1233561600"; 
   d="scan'208";a="396042895"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v12 8/8] PCI: manual for SR-IOV user and driver developer
Date: Fri, 20 Mar 2009 11:25:18 +0800
Message-Id: <1237519518-24048-9-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
References: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Randy Dunlap <rdunlap@xenotime.net>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 Documentation/DocBook/kernel-api.tmpl |    1 +
 Documentation/PCI/pci-iov-howto.txt   |   99 +++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/PCI/pci-iov-howto.txt

diff --git a/Documentation/DocBook/kernel-api.tmpl b/Documentation/DocBook/kernel-api.tmpl
index bc962cd..58c1945 100644
--- a/Documentation/DocBook/kernel-api.tmpl
+++ b/Documentation/DocBook/kernel-api.tmpl
@@ -199,6 +199,7 @@ X!Edrivers/pci/hotplug.c
 -->
 !Edrivers/pci/probe.c
 !Edrivers/pci/rom.c
+!Edrivers/pci/iov.c
      </sect1>
      <sect1><title>PCI Hotplug Support Library</title>
 !Edrivers/pci/hotplug/pci_hotplug_core.c
diff --git a/Documentation/PCI/pci-iov-howto.txt b/Documentation/PCI/pci-iov-howto.txt
new file mode 100644
index 0000000..fc73ef5
--- /dev/null
+++ b/Documentation/PCI/pci-iov-howto.txt
@@ -0,0 +1,99 @@
+		PCI Express I/O Virtualization Howto
+		Copyright (C) 2009 Intel Corporation
+		    Yu Zhao <yu.zhao@intel.com>
+
+
+1. Overview
+
+1.1 What is SR-IOV
+
+Single Root I/O Virtualization (SR-IOV) is a PCI Express Extended
+capability which makes one physical device appear as multiple virtual
+devices. The physical device is referred to as Physical Function (PF)
+while the virtual devices are referred to as Virtual Functions (VF).
+Allocation of the VF can be dynamically controlled by the PF via
+registers encapsulated in the capability. By default, this feature is
+not enabled and the PF behaves as traditional PCIe device. Once it's
+turned on, each VF's PCI configuration space can be accessed by its own
+Bus, Device and Function Number (Routing ID). And each VF also has PCI
+Memory Space, which is used to map its register set. VF device driver
+operates on the register set so it can be functional and appear as a
+real existing PCI device.
+
+2. User Guide
+
+2.1 How can I enable SR-IOV capability
+
+The device driver (PF driver) will control the enabling and disabling
+of the capability via API provided by SR-IOV core. If the hardware
+has SR-IOV capability, loading its PF driver would enable it and all
+VFs associated with the PF.
+
+2.2 How can I use the Virtual Functions
+
+The VF is treated as hot-plugged PCI devices in the kernel, so they
+should be able to work in the same way as real PCI devices. The VF
+requires device driver that is same as a normal PCI device's.
+
+3. Developer Guide
+
+3.1 SR-IOV API
+
+To enable SR-IOV capability:
+	int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
+	'nr_virtfn' is number of VFs to be enabled.
+
+To disable SR-IOV capability:
+	void pci_disable_sriov(struct pci_dev *dev);
+
+To notify SR-IOV core of Virtual Function Migration:
+	irqreturn_t pci_sriov_migration(struct pci_dev *dev);
+
+3.2 Usage example
+
+Following piece of code illustrates the usage of the SR-IOV API.
+
+static int __devinit dev_probe(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	pci_enable_sriov(dev, NR_VIRTFN);
+
+	...
+
+	return 0;
+}
+
+static void __devexit dev_remove(struct pci_dev *dev)
+{
+	pci_disable_sriov(dev);
+
+	...
+}
+
+static int dev_suspend(struct pci_dev *dev, pm_message_t state)
+{
+	...
+
+	return 0;
+}
+
+static int dev_resume(struct pci_dev *dev)
+{
+	...
+
+	return 0;
+}
+
+static void dev_shutdown(struct pci_dev *dev)
+{
+	...
+}
+
+static struct pci_driver dev_driver = {
+	.name =		"SR-IOV Physical Function driver",
+	.id_table =	dev_id_table,
+	.probe =	dev_probe,
+	.remove =	__devexit_p(dev_remove),
+	.suspend =	dev_suspend,
+	.resume =	dev_resume,
+	.shutdown =	dev_shutdown,
+};
-- 
1.5.6.4

