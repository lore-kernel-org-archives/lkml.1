Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbYJNL65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbYJNL65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbYJNL6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:58:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:59964 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394AbYJNL62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:58:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,409,1220252400"; 
   d="scan'208";a="451009455"
Date: Tue, 14 Oct 2008 19:01:57 +0800
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
Subject: [PATCH 8/8 v4] PCI: document the changes
Message-ID: <20081014110157.GH1734@yzhao12-linux.sh.intel.com>
References: <20081014103424.GA1704@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014103424.GA1704@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create how-to for SR-IOV user and device driver developer.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 Documentation/DocBook/kernel-api.tmpl |    1 +
 Documentation/PCI/pci-iov-howto.txt   |  222 +++++++++++++++++++++++++++++++++
 2 files changed, 223 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/PCI/pci-iov-howto.txt

diff --git a/Documentation/DocBook/kernel-api.tmpl b/Documentation/DocBook/kernel-api.tmpl
index b7b1482..5cb6491 100644
--- a/Documentation/DocBook/kernel-api.tmpl
+++ b/Documentation/DocBook/kernel-api.tmpl
@@ -251,6 +251,7 @@ X!Edrivers/pci/hotplug.c
 -->
 !Edrivers/pci/probe.c
 !Edrivers/pci/rom.c
+!Edrivers/pci/iov.c
      </sect1>
      <sect1><title>PCI Hotplug Support Library</title>
 !Edrivers/pci/hotplug/pci_hotplug_core.c
diff --git a/Documentation/PCI/pci-iov-howto.txt b/Documentation/PCI/pci-iov-howto.txt
new file mode 100644
index 0000000..15d846d
--- /dev/null
+++ b/Documentation/PCI/pci-iov-howto.txt
@@ -0,0 +1,222 @@
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
+		(XXXX:BB:DD:F is domain:bus:dev:fun)
+and
+	- /sys/bus/pci/devices/XXXX:BB:DD.F/iov/N
+		(N is VF number from 0 to initialvfs-1)
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
+The identifier of a VF that belongs to this PF can get from:
+	- /sys/bus/pci/devices/XXXX:BB:DD.F/iov/N/rid
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
+		int (*notify)(struct pci_dev *, u32), char **entries)
+	The 'notify' is a callback function that the SR-IOV code will invoke
+	it when events related to VFs happen (e.g. user read/write the sysfs
+	entries). The first argument is PF itself, the second argument is
+	event type and value. For now, following events type are supported:
+	- PCI_IOV_ENABLE: SR-IOV enable request
+	- PCI_IOV_DISABLE: SR-IOV disable request
+	- PCI_IOV_RD_CONF: read configuration
+	- PCI_IOV_WR_CONF: write configuration
+	- PCI_IOV_POST_EVENT: post event
+	And event values can be extract using following masks:
+	- PCI_IOV_VIRTFN_ID: Virtual Function Number
+	- PCI_IOV_NUM_VIRTFN: num of Virtual Functions
+	- PCI_IOV_EVENT_TYPE: event type (pre/post)
+	The 'entries' is is a list of sysfs entry names that will be to
+	created by the SR-IOV code.
+
+Note: entries could be NULL if PF driver doesn't want to create new entries
+under /sys/bus/pci/devices/XXXX:BB:DD.F/iov/N/.
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
+To read or write VFs configuration:
+	- int pci_iov_read_config(struct pci_dev *dev, int vfn,
+			char *entry, char *buf, int size);
+	- int pci_iov_write_config(struct pci_dev *dev, int vfn,
+			char *entry, char *buf);
+3.2 Usage example
+
+Following piece of code illustrates the usage of APIs above.
+
+static char *entries[] = { "foo", "bar", NULL };
+
+static int callback(struct pci_dev *dev, u32 event)
+{
+	int err;
+	int vfn;
+	int numvfs;
+
+	if (event & PCI_IOV_ENABLE) {
+		/*
+		 * request to enable SR-IOV, NumVFs is available.
+		 * Note: if the PF want to support PM, it has to
+		 * check the device power state here to see if
+		 * the request is allowed or not.
+		 */
+
+		numvfs = event & PCI_IOV_NUM_VIRTFN;
+
+	} else if (event & PCI_IOV_DISABLE) {
+		/*
+		 * request to disable SR-IOV.
+		 */
+		...
+
+	} else if (event & PCI_IOV_RD_CONF) {
+		/*
+		 * request to read VF configuration, Virtual
+		 * Function Number is available.
+		 */
+
+		vfn = event & PCI_IOV_VIRTFN_ID;
+
+		/* pass the config to SR-IOV code so user can read it */
+		err = pci_iov_write_config(dev, vfn, entry, buf);
+
+	} else if (event & PCI_IOV_WR_CONF) {
+		/*
+		 * request to write VF configuration, Virtual
+		 * Function Number is available.
+		 */
+
+		vfn = event & PCI_IOV_VIRTFN_ID;
+
+		/* read the config that has been written by user */
+		err = pci_iov_read_config(dev, vfn, entry, buf, size);
+
+	} else
+		return -EINVAL;
+
+	return err;
+}
+
+static int __devinit dev_probe(struct pci_dev *dev,
+				const struct pci_device_id *id)
+{
+	int err;
+
+	err = pci_iov_register(dev, callback, entries);
+	...
+
+	err = pci_iov_enable(dev, nr_virtfn, callback);
+
+	...
+
+	return err;
+}
+
+static void __devexit dev_remove(struct pci_dev *dev)
+{
+	...
+
+	pci_iov_disable(dev);
+
+	...
+
+	pci_iov_unregister(dev);
+
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
+
+	pci_iov_disable(dev);
+
+	...
+}
+
+static int dev_resume(struct pci_dev *dev)
+{
+	...
+
+	pci_iov_enable(dev, numvfs);
+
+	...
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

