Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbYJUMti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbYJUMti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbYJUMtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:49:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:21797 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbYJUMtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:49:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,457,1220252400"; 
   d="scan'208";a="350686544"
Date: Tue, 21 Oct 2008 19:54:06 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "achiang@hp.com" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "greg@kroah.com" <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 14/15 v5] PCI: document the SR-IOV
Message-ID: <20081021115406.GO3185@yzhao12-linux.sh.intel.com>
References: <20081021114056.GA3185@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021114056.GA3185@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create how-to for SR-IOV user and device driver developer.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Alex Chiang <achiang@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 Documentation/PCI/pci-iov-howto.txt |  181 +++++++++++++++++++++++++++++++++++
 1 files changed, 181 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/PCI/pci-iov-howto.txt

diff --git a/Documentation/PCI/pci-iov-howto.txt b/Documentation/PCI/pci-iov-howto.txt
new file mode 100644
index 0000000..5632723
--- /dev/null
+++ b/Documentation/PCI/pci-iov-howto.txt
@@ -0,0 +1,181 @@
+		PCI Express Single Root I/O Virtualization HOWTO
+			Copyright (C) 2008 Intel Corporation
+
+
+1. Overview
+
+1.1 What is SR-IOV
+
+Single Root I/O Virtualization (SR-IOV) is a PCI Express Extended
+capability which makes one physical device appear as multiple virtual
+devices. The physical device is referred to as Physical Function while
+the virtual devices are referred to as Virtual Functions. Allocation
+of Virtual Functions can be dynamically controlled by Physical Function
+via registers encapsulated in the capability. By default, this feature
+is not enabled and the Physical Function behaves as traditional PCIe
+device. Once it's turned on, each Virtual Function's PCI configuration
+space can be accessed by its own Bus, Device and Function Number (Routing
+ID). And each Virtual Function also has PCI Memory Space, which is used
+to map its register set. Virtual Function device driver operates on the
+register set so it can be functional and appear as a real existing PCI
+device.
+
+2. User Guide
+
+2.1 How can I manage SR-IOV
+
+If a device supports SR-IOV, then there should be some entries under
+Physical Function's PCI device directory. These entries are in directory:
+	- /sys/bus/pci/devices/XXXX:BB:DD.F/iov/
+		(XXXX:BB:DD:F is the domain, bus, device and function number)
+
+To enable or disable SR-IOV:
+	- /sys/bus/pci/devices/XXXX:BB:DD.F/iov/enable
+		(writing 1/0 means enable/disable VFs, state change will
+		 notify PF driver)
+
+To change number of Virtual Functions:
+	- /sys/bus/pci/devices/XXXX:BB:DD.F/iov/numvfs
+		(writing positive integer to this file will change NumVFs)
+
+The total and initial number of VFs can get from:
+	- /sys/bus/pci/devices/XXXX:BB:DD.F/iov/totalvfs
+	- /sys/bus/pci/devices/XXXX:BB:DD.F/iov/initialvfs
+
+2.2 How can I use Virtual Functions
+
+Virtual Functions are treated as hot-plugged PCI devices in the kernel,
+so they should be able to work in the same way as real PCI devices.
+NOTE: Virtual Function device driver must be loaded to make it work.
+
+
+3. Developer Guide
+
+3.1 SR-IOV APIs
+
+To register SR-IOV service, Physical Function device driver needs to call:
+	int pci_iov_register(struct pci_dev *dev,
+		int (*callback)(struct pci_dev *, u32))
+	The 'callback' is a callback function that the SR-IOV code will invoke
+	it when events related to VFs happen (e.g. user enable/disable VFs).
+	The first argument is PF itself, the second argument is event type and
+	value. For now, following events type are supported:
+	- PCI_IOV_ENABLE: SR-IOV enable request
+	- PCI_IOV_DISABLE: SR-IOV disable request
+	- PCI_IOV_NUMVFS: changing Number of VFs request
+	And event values can be extract using following masks:
+	- PCI_IOV_NUM_VIRTFN: Number of Virtual Functions
+
+To unregister SR-IOV service, Physical Function device driver needs to call:
+	void pci_iov_unregister(struct pci_dev *dev)
+
+To enable SR-IOV, Physical Function device driver needs to call:
+	int pci_iov_enable(struct pci_dev *dev, int numvfs)
+	'numvfs' is the number of VFs that PF wants to enable.
+
+To disable SR-IOV, Physical Function device driver needs to call:
+	void pci_iov_disable(struct pci_dev *dev)
+
+Note: above two functions sleeps 1 second waiting on hardware transaction
+completion according to SR-IOV specification.
+
+3.2 Usage example
+
+Following piece of code illustrates the usage of APIs above.
+
+static int callback(struct pci_dev *dev, u32 event)
+{
+	int numvfs;
+
+	if (event & PCI_IOV_ENABLE) {
+		/*
+		 * request to enable SR-IOV.
+		 * Note: if the PF driver want to support PM, it has
+		 * to check the device power state here to see if this
+		 * request is allowed or not.
+		 */
+		...
+
+	} else if (event & PCI_IOV_DISABLE) {
+		/*
+		 * request to disable SR-IOV.
+		 */
+		...
+
+	} else if (event & PCI_IOV_NUMVFS) {
+		/*
+		 * request to change NumVFs.
+		 */
+		numvfs = event & PCI_IOV_NUM_VIRTFN;
+		...
+
+	} else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int __devinit dev_probe(struct pci_dev *dev,
+				const struct pci_device_id *id)
+{
+	int err;
+	int numvfs;
+
+	...
+	err = pci_iov_register(dev, callback);
+	...
+	err = pci_iov_enable(dev, numvfs);
+	...
+
+	return err;
+}
+
+static void __devexit dev_remove(struct pci_dev *dev)
+{
+	...
+	pci_iov_disable(dev);
+	...
+	pci_iov_unregister(dev);
+	...
+}
+
+#ifdef CONFIG_PM
+/*
+ * If Physical Function supports the power management, then the
+ * SR-IOV needs to be disabled before the adapter goes to sleep,
+ * because Virtual Functions will not work when the adapter is in
+ * the power-saving mode.
+ * The SR-IOV can be enabled again after the adapter wakes up.
+ */
+static int dev_suspend(struct pci_dev *dev, pm_message_t state)
+{
+	...
+	pci_iov_disable(dev);
+	...
+
+	return 0;
+}
+
+static int dev_resume(struct pci_dev *dev)
+{
+	int err;
+	int numvfs;
+
+	...
+	rc = pci_iov_enable(dev, numvfs);
+	...
+
+	return 0;
+}
+#endif
+
+static struct pci_driver dev_driver = {
+	.name =		"SR-IOV Physical Function driver",
+	.id_table =	dev_id_table,
+	.probe =	dev_probe,
+	.remove =	__devexit_p(dev_remove),
+#ifdef CONFIG_PM
+	.suspend =	dev_suspend,
+	.resume =	dev_resume,
+#endif
+};
-- 
1.5.6.4

