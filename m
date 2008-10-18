Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYJRTQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYJRTQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbYJRTFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:05:19 -0400
Received: from mail.suse.de ([195.135.220.2]:38593 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbYJRTFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:05:15 -0400
Date: Sat, 18 Oct 2008 11:48:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Shaohua Li <shaohua.li@intel.com>
Subject: [patch 19/26] PCI: disable ASPM per ACPI FADT setting
Message-ID: <20081018184806.GS301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-disable-aspm-per-acpi-fadt-setting.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Shaohua Li <shaohua.li@intel.com>
commit 5fde244d39b88625ac578d83e6625138714de031 upstream

The ACPI FADT table includes an ASPM control bit. If the bit is set, do
not enable ASPM since it may indicate that the platform doesn't actually
support the feature.

Tested-by: Jack Howarth <howarth@bromo.msbb.uc.edu>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci-acpi.c   |    7 +++++++
 drivers/pci/pcie/aspm.c  |    5 +++++
 include/acpi/actbl.h     |    1 +
 include/linux/pci-aspm.h |    5 +++++
 4 files changed, 18 insertions(+)

--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/module.h>
+#include <linux/pci-aspm.h>
 #include <acpi/acpi.h>
 #include <acpi/acnamesp.h>
 #include <acpi/acresrc.h>
@@ -394,6 +395,12 @@ static int __init acpi_pci_init(void)
 		printk(KERN_INFO"ACPI FADT declares the system doesn't support MSI, so disable it\n");
 		pci_no_msi();
 	}
+
+	if (acpi_gbl_FADT.boot_flags & BAF_PCIE_ASPM_CONTROL) {
+		printk(KERN_INFO"ACPI FADT declares the system doesn't support PCIe ASPM, so disable it\n");
+		pcie_no_aspm();
+	}
+
 	ret = register_acpi_bus_type(&acpi_pci_bus);
 	if (ret)
 		return 0;
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -808,6 +808,11 @@ static int __init pcie_aspm_disable(char
 
 __setup("pcie_noaspm", pcie_aspm_disable);
 
+void pcie_no_aspm(void)
+{
+	aspm_disabled = 1;
+}
+
 #ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
 #include <linux/pci-acpi.h>
--- a/include/acpi/actbl.h
+++ b/include/acpi/actbl.h
@@ -277,6 +277,7 @@ enum acpi_prefered_pm_profiles {
 #define BAF_LEGACY_DEVICES              0x0001
 #define BAF_8042_KEYBOARD_CONTROLLER    0x0002
 #define BAF_MSI_NOT_SUPPORTED           0x0008
+#define BAF_PCIE_ASPM_CONTROL           0x0010
 
 #define FADT2_REVISION_ID               3
 #define FADT2_MINUS_REVISION_ID         2
--- a/include/linux/pci-aspm.h
+++ b/include/linux/pci-aspm.h
@@ -27,6 +27,7 @@ extern void pcie_aspm_init_link_state(st
 extern void pcie_aspm_exit_link_state(struct pci_dev *pdev);
 extern void pcie_aspm_pm_state_change(struct pci_dev *pdev);
 extern void pci_disable_link_state(struct pci_dev *pdev, int state);
+extern void pcie_no_aspm(void);
 #else
 static inline void pcie_aspm_init_link_state(struct pci_dev *pdev)
 {
@@ -40,6 +41,10 @@ static inline void pcie_aspm_pm_state_ch
 static inline void pci_disable_link_state(struct pci_dev *pdev, int state)
 {
 }
+
+static inline void pcie_no_aspm(void)
+{
+}
 #endif
 
 #ifdef CONFIG_PCIEASPM_DEBUG /* this depends on CONFIG_PCIEASPM */

-- 
