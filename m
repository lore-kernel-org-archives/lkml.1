Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0BMBkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:40:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:28881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab0BMBkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:40:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,464,1262592000"; 
   d="scan'208,223";a="492151429"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Du, Alek" <alek.du@intel.com>, "Tang, Feng" <feng.tang@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Feb 2010 17:40:07 -0800
Subject: [PATCH 1/9] PCI: add pci_bus_find_ext_capability
Thread-Topic: [PATCH 1/9] PCI: add pci_bus_find_ext_capability
Thread-Index: AcqsTXkRRcGrjgzeQDGiNKM6vj7cOA==
Message-ID: <43F901BD926A4E43B106BF17856F07559FB80CFD@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 84aabace8ffe48c4f01721b9bc56c6ecd8e673a6 Mon Sep 17 00:00:00 2001
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Wed, 15 Jul 2009 13:13:00 -0700
Subject: [PATCH 1/9] PCI: add pci_bus_find_ext_capability

For use by code that needs to walk extended capability lists before
pci_dev structures are set up.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 drivers/pci/pci.c   |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    2 ++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 315fea4..aad62af 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -297,6 +297,49 @@ int pci_find_ext_capability(struct pci_dev *dev, int cap)
 }
 EXPORT_SYMBOL_GPL(pci_find_ext_capability);
 
+/**
+ * pci_bus_find_ext_capability - find an extended capability
+ * @bus:   the PCI bus to query
+ * @devfn: PCI device to query
+ * @cap:   capability code
+ *
+ * Like pci_find_ext_capability() but works for pci devices that do not have a
+ * pci_dev structure set up yet.
+ *
+ * Returns the address of the requested capability structure within the
+ * device's PCI configuration space or 0 in case the device does not
+ * support it.
+ */
+int pci_bus_find_ext_capability(struct pci_bus *bus, unsigned int devfn,
+				int cap)
+{
+	u32 header;
+	int ttl;
+	int pos = PCI_CFG_SPACE_SIZE;
+
+	/* minimum 8 bytes per capability */
+	ttl = (PCI_CFG_SPACE_EXP_SIZE - PCI_CFG_SPACE_SIZE) / 8;
+
+	if (!pci_bus_read_config_dword(bus, devfn, pos, &header))
+		return 0;
+	if (header == 0xffffffff || header == 0)
+		return 0;
+
+	while (ttl-- > 0) {
+		if (PCI_EXT_CAP_ID(header) == cap)
+			return pos;
+
+		pos = PCI_EXT_CAP_NEXT(header);
+		if (pos < PCI_CFG_SPACE_SIZE)
+			break;
+
+		if (!pci_bus_read_config_dword(bus, devfn, pos, &header))
+			break;
+	}
+
+	return 0;
+}
+
 static int __pci_find_next_ht_cap(struct pci_dev *dev, int pos, int ht_cap)
 {
 	int rc, ttl = PCI_FIND_CAP_TTL;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c1968f4..65f8a8f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -631,6 +631,8 @@ enum pci_lost_interrupt_reason pci_lost_interrupt(struct pci_dev *dev);
 int pci_find_capability(struct pci_dev *dev, int cap);
 int pci_find_next_capability(struct pci_dev *dev, u8 pos, int cap);
 int pci_find_ext_capability(struct pci_dev *dev, int cap);
+int pci_bus_find_ext_capability(struct pci_bus *bus, unsigned int devfn,
+				int cap);
 int pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
 int pci_find_next_ht_capability(struct pci_dev *dev, int pos, int ht_cap);
 struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
-- 
1.6.5.3

