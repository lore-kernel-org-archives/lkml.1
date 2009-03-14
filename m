Return-Path: <linux-kernel-owner+w=401wt.eu-S1764210AbZCNBk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764210AbZCNBk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbZCNBU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:57 -0400
Received: from kroah.org ([198.145.64.141]:35313 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753872AbZCNBUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:39 2009
Message-Id: <20090314011039.556622621@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:32 -0700
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
       alan@lxorguk.ukuu.org.uk, Andrew Patterson <andrew.patterson@hp.com>,
       Jesse Barnes <jbarnes@hobbes.lan>
Subject: [patch 055/114] PCI: Enable PCIe AER only after checking firmware support
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=pci-enable-pcie-aer-only-after-checking-firmware-support.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Patterson <andrew.patterson@hp.com>

commit 1f9f13c8d59c1d8da1a602b71d1ab96d1d37d69e upstream.

The PCIe port driver currently sets the PCIe AER error reporting bits for
any root or switch port without first checking to see if firmware will grant
control. This patch moves setting these bits to the AER service driver
aer_enable_port routine.  The bits are then set for the root port and any
downstream switch ports after the check for firmware support (aer_osc_setup)
is made. The patch also unsets the bits in a similar fashion when the AER
service driver is unloaded.

Reviewed-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Signed-off-by: Jesse Barnes <jbarnes@hobbes.lan>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pcie/aer/aerdrv_core.c |   48 ++++++++++++++++++++++++++++++-------
 drivers/pci/pcie/portdrv_pci.c     |    2 -
 2 files changed, 39 insertions(+), 11 deletions(-)

--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -108,6 +108,34 @@ int pci_cleanup_aer_correct_error_status
 }
 #endif  /*  0  */
 
+
+static void set_device_error_reporting(struct pci_dev *dev, void *data)
+{
+	bool enable = *((bool *)data);
+
+	if (dev->pcie_type != PCIE_RC_PORT &&
+	    dev->pcie_type != PCIE_SW_UPSTREAM_PORT &&
+	    dev->pcie_type != PCIE_SW_DOWNSTREAM_PORT)
+		return;
+
+	if (enable)
+		pci_enable_pcie_error_reporting(dev);
+	else
+		pci_disable_pcie_error_reporting(dev);
+}
+
+/**
+ * set_downstream_devices_error_reporting - enable/disable the error reporting  bits on the root port and its downstream ports.
+ * @dev: pointer to root port's pci_dev data structure
+ * @enable: true = enable error reporting, false = disable error reporting.
+ */
+static void set_downstream_devices_error_reporting(struct pci_dev *dev,
+						   bool enable)
+{
+	set_device_error_reporting(dev, &enable);
+	pci_walk_bus(dev->subordinate, set_device_error_reporting, &enable);
+}
+
 static int find_device_iter(struct device *device, void *data)
 {
 	struct pci_dev *dev;
@@ -525,15 +553,11 @@ void aer_enable_rootport(struct aer_rpc 
 	pci_read_config_dword(pdev, aer_pos + PCI_ERR_UNCOR_STATUS, &reg32);
 	pci_write_config_dword(pdev, aer_pos + PCI_ERR_UNCOR_STATUS, reg32);
 
-	/* Enable Root Port device reporting error itself */
-	pci_read_config_word(pdev, pos+PCI_EXP_DEVCTL, &reg16);
-	reg16 = reg16 |
-		PCI_EXP_DEVCTL_CERE |
-		PCI_EXP_DEVCTL_NFERE |
-		PCI_EXP_DEVCTL_FERE |
-		PCI_EXP_DEVCTL_URRE;
-	pci_write_config_word(pdev, pos+PCI_EXP_DEVCTL,
-		reg16);
+	/*
+	 * Enable error reporting for the root port device and downstream port
+	 * devices.
+	 */
+	set_downstream_devices_error_reporting(pdev, true);
 
 	/* Enable Root Port's interrupt in response to error messages */
 	pci_write_config_dword(pdev,
@@ -553,6 +577,12 @@ static void disable_root_aer(struct aer_
 	u32 reg32;
 	int pos;
 
+	/*
+	 * Disable error reporting for the root port device and downstream port
+	 * devices.
+	 */
+	set_downstream_devices_error_reporting(pdev, false);
+
 	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
 	/* Disable Root's interrupt in response to error messages */
 	pci_write_config_dword(pdev, pos + PCI_ERR_ROOT_COMMAND, 0);
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -101,8 +101,6 @@ static int __devinit pcie_portdrv_probe 
 
 	pcie_portdrv_save_config(dev);
 
-	pci_enable_pcie_error_reporting(dev);
-
 	return 0;
 }
 


