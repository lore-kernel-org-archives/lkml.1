Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZA1Lu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZA1Lu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 06:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZA1Lur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 06:50:47 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36802 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZA1Luq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 06:50:46 -0500
Message-ID: <49804685.5030404@jp.fujitsu.com>
Date: Wed, 28 Jan 2009 20:50:29 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-pci@vger.kernel.org, "Barnes, Jesse" <jesse.barnes@intel.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, shaohua.li@intel.com,
       Grant Grundler <grundler@parisc-linux.org>
Subject: [PATCH 2/8] PCI/ACPI: fix wrong assumption in acpi_find_root_bridge_handle
References: <1231604250.3642.33.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901121604380.5859@localhost.localdomain>	 <1231807693.27151.21.camel@localhost.localdomain>	 <1232046108.5966.57.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901151421110.4737@localhost.localdomain>	 <1232049269.5966.64.camel@localhost.localdomain>	 <1232050347.5966.66.camel@localhost.localdomain>	 <4970242C.4010404@jp.fujitsu.com>	 <1232115546.3224.5.camel@localhost.localdomain>	 <4973D2EE.3060203@jp.fujitsu.com>	 <1232328216.3247.68.camel@localhost.localdomain>	 <4973EF64.2050404@jp.fujitsu.com> <1232558780.736.24.camel@localhost.localdomain> <497D1BD7.9000609@jp.fujitsu.com> <498045D1.60005@jp.fujitsu.com>
In-Reply-To: <498045D1.60005@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current acpi_find_root_bridge_handle() has a assumption that
pci_bus->self is NULL on the root pci bus. But it might not be true on
some platforms. Because of this wrong assumption, current
acpi_find_root_bridge_handle() might cause endless loop. We must check
pci_bus->parent instead.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 include/linux/pci-acpi.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6.29-rc2/include/linux/pci-acpi.h
===================================================================
--- linux-2.6.29-rc2.orig/include/linux/pci-acpi.h
+++ linux-2.6.29-rc2/include/linux/pci-acpi.h
@@ -53,12 +53,12 @@ extern acpi_status pci_osc_control_set(a
 int pci_acpi_osc_support(acpi_handle handle, u32 flags);
 static inline acpi_handle acpi_find_root_bridge_handle(struct pci_dev *pdev)
 {
-	/* Find root host bridge */
-	while (pdev->bus->self)
-		pdev = pdev->bus->self;
-
-	return acpi_get_pci_rootbridge_handle(pci_domain_nr(pdev->bus),
-			pdev->bus->number);
+	struct pci_bus *pbus = pdev->bus;
+	/* Find a PCI root bus */
+	while (pbus->parent)
+		pbus = pbus->parent;
+	return acpi_get_pci_rootbridge_handle(pci_domain_nr(pbus),
+					      pbus->number);
 }
 
 static inline acpi_handle acpi_pci_get_bridge_handle(struct pci_bus *pbus)


