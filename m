Return-Path: <linux-kernel-owner+w=401wt.eu-S1752418AbYI0I2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbYI0I2w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 04:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYI0I2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 04:28:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:33527 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbYI0I2I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 04:28:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,319,1220252400"; 
   d="scan'208";a="385042740"
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
Date: Sat, 27 Sep 2008 16:28:04 +0800
Subject: [PATCH 3/6 v3] PCI: support ARI capability
Thread-Topic: [PATCH 3/6 v3] PCI: support ARI capability
Thread-Index: AckgevYorUQfGP5hTWyXLNVLEInYVw==
Message-ID: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F3@pdsmsx502.ccr.corp.intel.com>
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

Add Alternative Routing-ID Interpretation (ARI) support.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Alex Chiang <achiang@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/pci.c        |   31 +++++++++++++++++++++++++++++++
 drivers/pci/pci.h        |   12 ++++++++++++
 drivers/pci/probe.c      |    3 +++
 include/linux/pci.h      |    1 +
 include/linux/pci_regs.h |   14 ++++++++++++++
 5 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 400d3b3..fe9efc4 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1260,6 +1260,37 @@ void pci_pm_init(struct pci_dev *dev)
        }
 }

+/**
+ * pci_ari_init - turn on ARI forwarding if it's supported
+ * @dev: the PCI device
+ */
+void pci_ari_init(struct pci_dev *dev)
+{
+       int pos;
+       u32 cap;
+       u16 ctrl;
+
+       if (!dev->is_pcie || (dev->pcie_type != PCI_EXP_TYPE_ROOT_PORT &&
+                               dev->pcie_type != PCI_EXP_TYPE_DOWNSTREAM))
+               return;
+
+       pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
+       if (!pos)
+               return;
+
+       pci_read_config_dword(dev, pos + PCI_EXP_DEVCAP2, &cap);
+
+       if (!(cap & PCI_EXP_DEVCAP2_ARI))
+               return;
+
+       pci_read_config_word(dev, pos + PCI_EXP_DEVCTL2, &ctrl);
+       ctrl |= PCI_EXP_DEVCTL2_ARI;
+       pci_write_config_word(dev, pos + PCI_EXP_DEVCTL2, ctrl);
+
+       dev->ari_enabled = 1;
+       dev_info(&dev->dev, "ARI forwarding enabled.\n");
+}
+
 int
 pci_get_interrupt_pin(struct pci_dev *dev, struct pci_dev **bridge)
 {
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 9f0fa0e..593b415 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -165,5 +165,17 @@ extern struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 extern int pci_resource_alignment(struct pci_dev *dev, int resno);
 extern int pci_resource_bar(struct pci_dev *dev, int resno,
                            enum pci_bar_type *type);
+extern void pci_ari_init(struct pci_dev *dev);
+/**
+ * pci_ari_fwd_enabled - query ARI forwarding status
+ * @dev: the PCI device
+ *
+ * Returns 1 if ARI forwarding is enabled, or 0 if not enabled;
+ * returns negative on failure.
+ */
+static inline int pci_ari_enabled(struct pci_dev *dev)
+{
+       return dev->ari_enabled;
+}

 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b9f759d..06b9a75 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1019,6 +1019,9 @@ static void pci_init_capabilities(struct pci_dev *dev)

        /* Vital Product Data */
        pci_vpd_pci22_init(dev);
+
+       /* Alternative Routing-ID Forwarding */
+       pci_ari_init(dev);
 }

 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a0d6381..497d639 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -237,6 +237,7 @@ struct pci_dev {
        unsigned int    broken_parity_status:1; /* Device generates false positive parity */
        unsigned int    msi_enabled:1;
        unsigned int    msix_enabled:1;
+       unsigned int    ari_enabled:1;  /* ARI forwarding */
        unsigned int    is_managed:1;
        unsigned int    is_pcie:1;
        pci_dev_flags_t dev_flags;
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index 450684f..eb6686b 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -419,6 +419,10 @@
 #define  PCI_EXP_RTCTL_CRSSVE  0x10    /* CRS Software Visibility Enable */
 #define PCI_EXP_RTCAP          30      /* Root Capabilities */
 #define PCI_EXP_RTSTA          32      /* Root Status */
+#define PCI_EXP_DEVCAP2                36      /* Device Capabilities 2 */
+#define  PCI_EXP_DEVCAP2_ARI   0x20    /* Alternative Routing-ID */
+#define PCI_EXP_DEVCTL2                40      /* Device Control 2 */
+#define  PCI_EXP_DEVCTL2_ARI   0x20    /* Alternative Routing-ID */

 /* Extended Capabilities (PCI-X 2.0 and Express) */
 #define PCI_EXT_CAP_ID(header)         (header & 0x0000ffff)
@@ -429,6 +433,7 @@
 #define PCI_EXT_CAP_ID_VC      2
 #define PCI_EXT_CAP_ID_DSN     3
 #define PCI_EXT_CAP_ID_PWR     4
+#define PCI_EXT_CAP_ID_ARI     14

 /* Advanced Error Reporting */
 #define PCI_ERR_UNCOR_STATUS   4       /* Uncorrectable Error Status */
@@ -536,5 +541,14 @@
 #define HT_CAPTYPE_GEN3                0xD0    /* Generation 3 hypertransport configuration */
 #define HT_CAPTYPE_PM          0xE0    /* Hypertransport powermanagement configuration */

+/* Alternative Routing-ID Interpretation */
+#define PCI_ARI_CAP            0x04    /* ARI Capability Register */
+#define  PCI_ARI_CAP_MFVC      0x0001  /* MFVC Function Groups Capability */
+#define  PCI_ARI_CAP_ACS       0x0002  /* ACS Function Groups Capability */
+#define  PCI_ARI_CAP_NFN(x)    (((x) >> 8) & 0xff) /* Next Function Number */
+#define PCI_ARI_CTRL           0x06    /* ARI Control Register */
+#define  PCI_ARI_CTRL_MFVC     0x0001  /* MFVC Function Groups Enable */
+#define  PCI_ARI_CTRL_ACS      0x0002  /* ACS Function Groups Enable */
+#define  PCI_ARI_CTRL_FG(x)    (((x) >> 4) & 7) /* Function Group */

 #endif /* LINUX_PCI_REGS_H */
--
1.5.6.4

