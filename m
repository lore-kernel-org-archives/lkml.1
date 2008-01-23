Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbYAWAT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbYAWAT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYAWASa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:18:30 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:6182 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbYAWAS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:18:29 -0500
From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 4/4] PCI: Run ACPI _OSC method on root bridges only
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, gregkh@suse.de,
       matthew@wil.cx, tom.l.nguyen@intel.com, linux-acpi@vger.kernel.org,
       Andrew Patterson <andrew.patterson@hp.com>
Date: Tue, 22 Jan 2008 17:18:27 -0700
Message-ID: <20080123001827.28190.7908.stgit@bluto.andrew>
In-Reply-To: <20080123001807.28190.32648.stgit@bluto.andrew>
References: <20080123001807.28190.32648.stgit@bluto.andrew>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Patterson <andrew.patterson@hp.com>

According to the PCI Firmware Specification Revision 3.0 section 4.5, _OSC
should only be called on a root brdige.  Here is the relevant passage: "The
_OSC interface defined in this section applies only to Host Bridge ACPI
devices that originate PCI, PCI-X, or PCI Express hierarchies". Changed the
code to find the parent root bridge of the device and call _OSC on that.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

 drivers/pci/pcie/aer/aerdrv_acpi.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index f685bf5..8c199ae 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -31,23 +31,13 @@ int aer_osc_setup(struct pcie_device *pciedev)
 {
 	acpi_status status = AE_NOT_FOUND;
 	struct pci_dev *pdev = pciedev->port;
-	acpi_handle handle = DEVICE_ACPI_HANDLE(&pdev->dev);
-	struct pci_bus *parent;
+	acpi_handle handle = 0;
 
-	while (!handle) {
-		if (!pdev || !pdev->bus->parent)
-			break;
-		parent = pdev->bus->parent;
-		if (!parent->self)
-			/* Parent must be a host bridge */
-			handle = acpi_get_pci_rootbridge_handle(
-					pci_domain_nr(parent),
-					parent->number);
-		else
-			handle = DEVICE_ACPI_HANDLE(
-					&(parent->self->dev));
-		pdev = parent->self;
-	}
+	/* Find root host bridge */
+	while (pdev->bus && pdev->bus->self)
+		pdev = pdev->bus->self;
+	handle = acpi_get_pci_rootbridge_handle(
+		pci_domain_nr(pdev->bus), pdev->bus->number);
 
 	if (handle) {
 		pcie_osc_support_set(OSC_EXT_PCI_CONFIG_SUPPORT);

