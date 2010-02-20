Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab0BTBay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 20:30:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:56174 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526Ab0BTBaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 20:30:18 -0500
Date: Sat, 20 Feb 2010 01:27:37 GMT
From: tip-bot for Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbarnes@virtuousgeek.org, jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F07559FB80CFD@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80CFD@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] PCI: Add pci_bus_find_ext_capability
Message-ID: <tip-cf4c43dd439b90a1a876b3f836ebe745abb9a269@git.kernel.org>
Git-Commit-ID: cf4c43dd439b90a1a876b3f836ebe745abb9a269
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 20 Feb 2010 01:27:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf4c43dd439b90a1a876b3f836ebe745abb9a269
Gitweb:     http://git.kernel.org/tip/cf4c43dd439b90a1a876b3f836ebe745abb9a269
Author:     Jesse Barnes <jbarnes@virtuousgeek.org>
AuthorDate: Wed, 15 Jul 2009 13:13:00 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 19 Feb 2010 16:12:26 -0800

PCI: Add pci_bus_find_ext_capability

For use by code that needs to walk extended capability lists before
pci_dev structures are set up.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
LKML-Reference: <43F901BD926A4E43B106BF17856F07559FB80CFD@orsmsx508.amr.corp.intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
