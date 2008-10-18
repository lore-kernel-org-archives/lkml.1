Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbYJRTQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbYJRTQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbYJRTFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:05:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbYJRTFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:05:18 -0400
Date: Sat, 18 Oct 2008 11:48:09 -0700
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
Subject: [patch 20/26] PCI: disable ASPM on pre-1.1 PCIe devices
Message-ID: <20081018184809.GT301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-disable-aspm-on-pre-1.1-pcie-devices.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Shaohua Li <shaohua.li@intel.com>

commit 149e16372a2066c5474d8a8db9b252afd57eb427 upstream

Disable ASPM on pre-1.1 PCIe devices, as many of them don't implement it
correctly.

Tested-by: Jack Howarth <howarth@bromo.msbb.uc.edu>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pcie/aspm.c  |   13 +++++++++++++
 drivers/pci/probe.c      |    3 ++-
 include/linux/pci_regs.h |    1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -510,6 +510,7 @@ static int pcie_aspm_sanity_check(struct
 {
 	struct pci_dev *child_dev;
 	int child_pos;
+	u32 reg32;
 
 	/*
 	 * Some functions in a slot might not all be PCIE functions, very
@@ -519,6 +520,18 @@ static int pcie_aspm_sanity_check(struct
 		child_pos = pci_find_capability(child_dev, PCI_CAP_ID_EXP);
 		if (!child_pos)
 			return -EINVAL;
+
+		/*
+		 * Disable ASPM for pre-1.1 PCIe device, we follow MS to use
+		 * RBER bit to determine if a function is 1.1 version device
+		 */
+		pci_read_config_dword(child_dev, child_pos + PCI_EXP_DEVCAP,
+			&reg32);
+		if (!(reg32 & PCI_EXP_DEVCAP_RBER)) {
+			printk("Pre-1.1 PCIe device detected, "
+				"disable ASPM for %s\n", pci_name(pdev));
+			return -EINVAL;
+		}
 	}
 	return 0;
 }
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1047,7 +1047,8 @@ int pci_scan_slot(struct pci_bus *bus, i
 		}
 	}
 
-	if (bus->self)
+	/* only one slot has pcie device */
+	if (bus->self && nr)
 		pcie_aspm_init_link_state(bus->self);
 
 	return nr;
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -373,6 +373,7 @@
 #define  PCI_EXP_DEVCAP_ATN_BUT	0x1000	/* Attention Button Present */
 #define  PCI_EXP_DEVCAP_ATN_IND	0x2000	/* Attention Indicator Present */
 #define  PCI_EXP_DEVCAP_PWR_IND	0x4000	/* Power Indicator Present */
+#define  PCI_EXP_DEVCAP_RBER	0x8000	/* Role-Based Error Reporting */
 #define  PCI_EXP_DEVCAP_PWR_VAL	0x3fc0000 /* Slot Power Limit Value */
 #define  PCI_EXP_DEVCAP_PWR_SCL	0xc000000 /* Slot Power Limit Scale */
 #define PCI_EXP_DEVCTL		8	/* Device Control */

-- 
