Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYI0I3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYI0I3v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 04:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYI0I24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 04:28:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:48396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbYI0I2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 04:28:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,319,1220252400"; 
   d="scan'208";a="52139149"
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
Date: Sat, 27 Sep 2008 16:28:45 +0800
Subject: [PATCH 6/6 v3] PCI: document the change
Thread-Topic: [PATCH 6/6 v3] PCI: document the change
Thread-Index: Ackgew6THR3pQWt1Tvy3dEUCNXXO+w==
Message-ID: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F6@pdsmsx502.ccr.corp.intel.com>
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
 Documentation/DocBook/kernel-api.tmpl |    2 +
 Documentation/PCI/pci-iov-howto.txt   |  227 +++++++++++++++++++++++++++++++++
 2 files changed, 229 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/PCI/pci-iov-howto.txt

diff --git a/Documentation/DocBook/kernel-api.tmpl b/Documentation/DocBook/kernel-api.tmpl
index b7b1482..c6ceb39 100644
--- a/Documentation/DocBook/kernel-api.tmpl
+++ b/Documentation/DocBook/kernel-api.tmpl
@@ -239,6 +239,7 @@ X!Ekernel/module.c
      </sect1>

      <sect1><title>PCI Support Library</title>
+!Iinclude/linux/pci.h
 !Edrivers/pci/pci.c
 !Edrivers/pci/pci-driver.c
 !Edrivers/pci/remove.c
@@ -251,6 +252,7 @@ X!Edrivers/pci/hotplug.c
 -->
 !Edrivers/pci/probe.c
 !Edrivers/pci/rom.c
+!Edrivers/pci/iov.c
      </sect1>
      <sect1><title>PCI Hotplug Support Library</title>
 !Edrivers/pci/hotplug/pci_hotplug_core.c
diff --git a/Documentation/PCI/pci-iov-howto.txt b/Documentation/PCI/pci-iov-howto.txt
new file mode 100644
index 0000000..ff1969e
--- /dev/null
+++ b/Documentation/PCI/pci-iov-howto.txt
@@ -0,0 +1,227 @@
+               PCI Express Single Root I/O Virtualization HOWTO
+                       Copyright (C) 2008 Intel Corporation
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
+1.2 What is ARI
+
+Alternative Routing-ID Interpretation (ARI) allows a PCI Express Endpoint
+to use its device number field as part of function number. Traditionally,
+an Endpoint can only have 8 functions, and the device number of all
+Endpoints is zero. With ARI enabled, an Endpoint can have up to 256
+functions by using device number in conjunction with function number to
+indicate a function in the device. This is almost transparent to the Linux
+kernel because the Linux kernel still can use 8-bit bus number field plus
+8-bit devfn number field to locate a function. ARI is managed via the ARI
+Forwarding bit in the Device Capabilities 2 register of the PCI Express
+Capability on the Root Port or the Downstream Port and a new ARI Capability
+on the Endpoint.
+
+
+2. User Guide
+
+2.1 How can I manage SR-IOV
+
+If a device supports SR-IOV, then there should be some entries under
+Physical Function's PCI device directory. These entries are in directory:
+       - /sys/bus/pci/devices/BB:DD.F/iov/
+               (BB:DD:F is bus:dev:fun)
+and
+       - /sys/bus/pci/devices/BB:DD.F/iov/N
+               (N is VF number from 0 to initialvfs-1)
+
+To enable or disable SR-IOV:
+       - /sys/bus/pci/devices/BB:DD.F/iov/enable
+               (writing 1/0 means enable/disable VFs, state change will
+                notify PF driver)
+
+To change number of Virtual Functions:
+       - /sys/bus/pci/devices/BB:DD.F/iov/numvfs
+               (writing positive integer to this file will change NumVFs)
+
+The total and initial number of VFs can get from:
+       - /sys/bus/pci/devices/BB:DD.F/iov/totalvfs
+       - /sys/bus/pci/devices/BB:DD.F/iov/initialvfs
+
+The identifier of a VF that belongs to this PF can get from:
+       - /sys/bus/pci/devices/BB:DD.F/iov/N/rid
+               (for all class of devices)
+
+For network device, there are:
+       - /sys/bus/pci/devices/BB:DD.F/iov/N/mac
+       - /sys/bus/pci/devices/BB:DD.F/iov/N/vlan
+               (value update will notify PF driver)
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
+       int pci_iov_register(struct pci_dev *dev,
+               int (*notify)(struct pci_dev *, u32), char **entries)
+
+Note: entries could be NULL if PF driver doesn't want to create new entries
+under /sys/bus/pci/devices/BB:DD.F/iov/N/.
+
+To unregister SR-IOV service, Physical Function device driver needs to call:
+       void pci_iov_unregister(struct pci_dev *dev)
+
+To enable SR-IOV, Physical Function device driver needs to call:
+       int pci_iov_enable(struct pci_dev *dev, int numvfs)
+
+To disable SR-IOV, Physical Function device driver needs to call:
+       void pci_iov_disable(struct pci_dev *dev)
+
+Note: above two functions sleeps 1 second waiting on hardware transaction
+completion according to SR-IOV specification.
+
+To read or write VFs configuration:
+       - int pci_iov_read_config(struct pci_dev *dev, int id,
+                       char *entry, char *buf, int size);
+       - int pci_iov_write_config(struct pci_dev *dev, int id,
+                       char *entry, char *buf);
+3.2 Usage example
+
+Following piece of code illustrates the usage of APIs above.
+
+static char *entries[] = { "foo", "bar", NULL };
+
+static int callback(struct pci_dev *dev, u32 event)
+{
+       int err;
+       int vfn;
+       int numvfs;
+
+       if (event & PCI_IOV_ENABLE) {
+               /*
+                * request to enable SR-IOV, NumVFs is available.
+                * Note: if the PF want to support PM, it has to
+                * check the device power state here to see if
+                * the request is allowed or not.
+                */
+
+               numvfs = event & PCI_IOV_NUM_VIRTFN;
+
+       } else if (event & PCI_IOV_DISABLE) {
+               /*
+                * request to disable SR-IOV.
+                */
+               ...
+
+       } else if (event & PCI_IOV_RD_CONF) {
+               /*
+                * request to read VF configuration, Virtual
+                * Function Number is available.
+                */
+
+               vfn = event & PCI_IOV_VIRTFN_ID;
+
+               /* pass the config to SR-IOV code so user can read it */
+               err = pci_iov_write_config(dev, vfn, entry, buf);
+
+       } else if (event & PCI_IOV_WR_CONF) {
+               /*
+                * request to write VF configuration, Virtual
+                * Function Number is available.
+                */
+
+               vfn = event & PCI_IOV_VIRTFN_ID;
+
+               /* read the config that has been written by user */
+               err = pci_iov_read_config(dev, vfn, entry, buf, size);
+
+       } else
+               return -EINVAL;
+
+       return err;
+}
+
+static int __devinit dev_probe(struct pci_dev *dev,
+                               const struct pci_device_id *id)
+{
+       int err;
+
+       err = pci_iov_register(dev, callback, entries);
+       ...
+
+       err = pci_iov_enable(dev, nr_virtfn, callback);
+
+       ...
+
+       return err;
+}
+
+static void __devexit dev_remove(struct pci_dev *dev)
+{
+       ...
+
+       pci_iov_disable(dev);
+
+       ...
+
+       pci_iov_unregister(dev);
+
+       ...
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
+       ...
+
+       pci_iov_disable(dev);
+
+       ...
+}
+
+static int dev_resume(struct pci_dev *dev)
+{
+       ...
+
+       pci_iov_enable(dev, numvfs);
+
+       ...
+}
+#endif
+
+static struct pci_driver dev_driver = {
+       .name =         "SR-IOV Physical Function driver",
+       .id_table =     dev_id_table,
+       .probe =        dev_probe,
+       .remove =       __devexit_p(dev_remove),
+#ifdef CONFIG_PM
+       .suspend =      dev_suspend,
+       .resume =       dev_resume,
+#endif
+};
--
1.5.6.4

