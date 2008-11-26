Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbYKZFT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbYKZFT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 00:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYKZFRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 00:17:17 -0500
Received: from sous-sol.org ([216.99.217.87]:58088 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751240AbYKZFRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 00:17:16 -0500
Date: Tue, 25 Nov 2008 21:17:13 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: jbarnes@virtuousgeek.org
Cc: greg@kroah.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, allen.m.kay@intel.com, jun.nakajima@intel.com
Subject: [PATCH 2/2 v2] PCI: pci-stub module to reserve pci device
Message-ID: <20081126051713.GB22700@sequoia.sous-sol.org>
References: <20081126033610.GB19881@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126033610.GB19881@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing device assignment with KVM there's currently nothing to
protect the device from having a driver in the host as well as the guest.
This trivial module just binds the pci device on the host to a stub
driver so that a real host driver can't bind to the device.  It has no
pci id table, it supports only dynamic ids.

 # echo "8086 10f5" > /sys/bus/pci/drivers/pci-stub/new_id
 # echo -n 0000:00:19.0 > /sys/bus/pci/drivers/e1000e/unbind
 # echo -n 0000:00:19.0 > /sys/bus/pci/drivers/pci-stub/bind
 # ls -l /sys/bus/pci/devices/0000:00:19.0/driver
 lrwxrwxrwx 1 root root 0 2008-11-25 19:10 /sys/bus/pci/devices/0000:00:19.0/driver -> ../../../bus/pci/drivers/pci-stub

Cc: "Kay, Allen M" <allen.m.kay@intel.com>
Cc: "Nakajima, Jun" <jun.nakajima@intel.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/Kconfig    |    9 +++++++++
 drivers/pci/Makefile   |    2 ++
 drivers/pci/pci-stub.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pci/pci-stub.c

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index e1ca425..2a4501d 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -42,6 +42,15 @@ config PCI_DEBUG
 
 	  When in doubt, say N.
 
+config PCI_STUB
+	tristate "PCI Stub driver"
+	depends on PCI
+	help
+	  Say Y or M here if you want be able to reserve a PCI device
+	  when it is going to be assigned to a guest operating system.
+
+	  When in doubt, say N.
+
 config HT_IRQ
 	bool "Interrupts on hypertransport devices"
 	default y
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index af3bfe2..3d07ce2 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -53,6 +53,8 @@ obj-$(CONFIG_HOTPLUG) += setup-bus.o
 
 obj-$(CONFIG_PCI_SYSCALL) += syscall.o
 
+obj-$(CONFIG_PCI_STUB) += pci-stub.o
+
 ifeq ($(CONFIG_PCI_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
 endif
diff --git a/drivers/pci/pci-stub.c b/drivers/pci/pci-stub.c
new file mode 100644
index 0000000..74fbec0
--- /dev/null
+++ b/drivers/pci/pci-stub.c
@@ -0,0 +1,47 @@
+/* pci-stub - simple stub driver to reserve a pci device
+ *
+ * Copyright (C) 2008 Red Hat, Inc.
+ * Author:
+ * 	Chris Wright
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ *
+ * Usage is simple, allocate a new id to the stub driver and bind the
+ * device to it.  For example:
+ * 
+ * # echo "8086 10f5" > /sys/bus/pci/drivers/pci-stub/new_id
+ * # echo -n 0000:00:19.0 > /sys/bus/pci/drivers/e1000e/unbind
+ * # echo -n 0000:00:19.0 > /sys/bus/pci/drivers/pci-stub/bind
+ * # ls -l /sys/bus/pci/devices/0000:00:19.0/driver
+ * .../0000:00:19.0/driver -> ../../../bus/pci/drivers/pci-stub
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+
+static int pci_stub_probe(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	return 0;
+}
+
+static struct pci_driver stub_driver = {
+	.name		= "pci-stub",
+	.id_table	= NULL,	/* only dynamic id's */
+	.probe		= pci_stub_probe,
+};
+
+static int __init pci_stub_init(void)
+{
+	return pci_register_driver(&stub_driver);
+}
+
+static void __exit pci_stub_exit(void)
+{
+	pci_unregister_driver(&stub_driver);
+}
+
+module_init(pci_stub_init);
+module_exit(pci_stub_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Chris Wright <chrisw@sous-sol.org>");
-- 
1.6.0.3

