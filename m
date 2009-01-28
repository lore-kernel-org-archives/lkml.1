Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZA1Lvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZA1Lvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 06:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZA1Lvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 06:51:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36859 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZA1Lvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 06:51:43 -0500
Message-ID: <498046BE.1000809@jp.fujitsu.com>
Date: Wed, 28 Jan 2009 20:51:26 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-pci@vger.kernel.org, "Barnes, Jesse" <jesse.barnes@intel.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, shaohua.li@intel.com,
       Grant Grundler <grundler@parisc-linux.org>
Subject: [PATCH 3/8] PCI hotplug: fix wrong assumption in acpi_get_hp_params_from_firmware
References: <1231604250.3642.33.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901121604380.5859@localhost.localdomain>	 <1231807693.27151.21.camel@localhost.localdomain>	 <1232046108.5966.57.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901151421110.4737@localhost.localdomain>	 <1232049269.5966.64.camel@localhost.localdomain>	 <1232050347.5966.66.camel@localhost.localdomain>	 <4970242C.4010404@jp.fujitsu.com>	 <1232115546.3224.5.camel@localhost.localdomain>	 <4973D2EE.3060203@jp.fujitsu.com>	 <1232328216.3247.68.camel@localhost.localdomain>	 <4973EF64.2050404@jp.fujitsu.com> <1232558780.736.24.camel@localhost.localdomain> <497D1BD7.9000609@jp.fujitsu.com> <498045D1.60005@jp.fujitsu.com>
In-Reply-To: <498045D1.60005@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current acpi_get_hp_params_from_firmware() has a assumption that
pci_bus->self is NULL on the root pci bus. But it might not true on
some platforms. Because of this wrong assumption, current
acpi_get_hp_params_from_firmware() might cause endless loop. We must
check pci_bus->parent instead.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/pci/hotplug/acpi_pcihp.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

Index: linux-2.6.29-rc2/drivers/pci/hotplug/acpi_pcihp.c
===================================================================
--- linux-2.6.29-rc2.orig/drivers/pci/hotplug/acpi_pcihp.c
+++ linux-2.6.29-rc2/drivers/pci/hotplug/acpi_pcihp.c
@@ -333,19 +333,14 @@ acpi_status acpi_get_hp_params_from_firm
 {
 	acpi_status status = AE_NOT_FOUND;
 	acpi_handle handle, phandle;
-	struct pci_bus *pbus = bus;
-	struct pci_dev *pdev;
+	struct pci_bus *pbus;
 
-	do {
-		pdev = pbus->self;
-		if (!pdev) {
-			handle = acpi_get_pci_rootbridge_handle(
-				pci_domain_nr(pbus), pbus->number);
+	handle = NULL;
+	for (pbus = bus; pbus; pbus = pbus->parent) {
+		handle = acpi_pci_get_bridge_handle(pbus);
+		if (handle)
 			break;
-		}
-		handle = DEVICE_ACPI_HANDLE(&(pdev->dev));
-		pbus = pbus->parent;
-	} while (!handle);
+	}
 
 	/*
 	 * _HPP settings apply to all child buses, until another _HPP is


