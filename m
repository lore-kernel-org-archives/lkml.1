Return-Path: <linux-kernel-owner+w=401wt.eu-S1751004AbZKEBiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004AbZKEBiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 20:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbZKEBiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 20:38:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46688 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZKEBiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 20:38:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AF22C82.2040105@jp.fujitsu.com>
Date: Thu, 05 Nov 2009 10:38:10 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: rdh@east.sun.com
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci/pcie: Avoid unnecessary PCIe link retrains
References: <19184.41676.262206.134000@gargle.gargle.HOWL> <20091104110321.5e58e112@jbarnes-piketon>
In-Reply-To: <20091104110321.5e58e112@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> [Cc'ing linux-pci@vger.kernel.org too]
> 
> On Tue, 3 Nov 2009 16:38:20 -0500
> RDH <rdh@east.sun.com> wrote:
> 
>> This patch avoids unnecessary PCIe link retraining sequences within
>> the PCIe ASPM common clock setup code by issuing a link retrain
>> command only if we are actually changing the PCIe clock configuration.
>>
>> Signed-off-by: Robert D. Houk <rdh@East.Sun.COM>
>> ---
>>  aspm.c |   20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>> --- a/drivers/pci/pcie/aspm.c	2009-10-15 20:41:50.000000000
>> -0400 +++ b/drivers/pci/pcie/aspm.c	2009-11-02
>> 14:29:35.000000000 -0500 @@ -183,6 +183,7 @@ static void
>> pcie_aspm_configure_common_c {
>>  	int ppos, cpos, same_clock = 1;
>>  	u16 reg16, parent_reg, child_reg[8];
>> +	u16 lnkctl_ccc_or, lnkctl_ccc_and;
>>  	unsigned long start_jiffies;
>>  	struct pci_dev *child, *parent = link->pdev;
>>  	struct pci_bus *linkbus = parent->subordinate;
>> @@ -205,6 +206,25 @@ static void pcie_aspm_configure_common_c
>>  	if (!(reg16 & PCI_EXP_LNKSTA_SLC))
>>  		same_clock = 0;
>>  
>> +	/* Check upstream component for Common Clock Config */
>> +	pci_read_config_word(parent, ppos + PCI_EXP_LNKCTL, &reg16);
>> +	lnkctl_ccc_and = lnkctl_ccc_or = (reg16 &
>> PCI_EXP_LNKCTL_CCC); +
>> +	/* Scan downstream component for CCC, all functions */
>> +	list_for_each_entry(child, &linkbus->devices, bus_list) {
>> +		cpos = pci_find_capability(child, PCI_CAP_ID_EXP);
>> +		pci_read_config_word(child, cpos + PCI_EXP_LNKCTL,
>> &reg16);
>> +		lnkctl_ccc_and &= (reg16 & PCI_EXP_LNKCTL_CCC);
>> +		lnkctl_ccc_or |= (reg16 & PCI_EXP_LNKCTL_CCC);
>> +	}
>> +
>> +	/* If we want Common Clock OFF and no device/function has it
>> on */
>> +	/* or we want Common Clock ON and every device/function has
>> it on */
>> +	/* then there is no need to retrain PCIe links */
>> +	if (((same_clock == 0) && (lnkctl_ccc_or == 0))
>> +            || ((same_clock == 1) && (lnkctl_ccc_and ==
>> PCI_EXP_LNKCTL_CCC)))
>> +		return;		/* Don't retrain link(s) */
>> +
>>  	/* Configure downstream component, all functions */
>>  	list_for_each_entry(child, &linkbus->devices, bus_list) {
>>  		cpos = pci_find_capability(child, PCI_CAP_ID_EXP);
>>
> 
> Seems ok to me, anyone have comments?
> 

Hi Robert,

How about like below? IMHO, it is easier to understand.
(Please note that I don't test it yet)

Thanks,
Kenji Kaneshige


---
 drivers/pci/pcie/aspm.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: 20091026/drivers/pci/pcie/aspm.c
===================================================================
--- 20091026.orig/drivers/pci/pcie/aspm.c
+++ 20091026/drivers/pci/pcie/aspm.c
@@ -186,6 +186,7 @@ static void pcie_aspm_configure_common_c
 	unsigned long start_jiffies;
 	struct pci_dev *child, *parent = link->pdev;
 	struct pci_bus *linkbus = parent->subordinate;
+	bool ccc_updated = false;
 	/*
 	 * All functions of a slot should have the same Slot Clock
 	 * Configuration, so just check one function
@@ -214,7 +215,10 @@ static void pcie_aspm_configure_common_c
 			reg16 |= PCI_EXP_LNKCTL_CCC;
 		else
 			reg16 &= ~PCI_EXP_LNKCTL_CCC;
+		if (reg16 == child_reg[PCI_FUNC(child->devfn)])
+			continue;
 		pci_write_config_word(child, cpos + PCI_EXP_LNKCTL, reg16);
+		ccc_updated = true;
 	}
 
 	/* Configure upstream component */
@@ -224,7 +228,14 @@ static void pcie_aspm_configure_common_c
 		reg16 |= PCI_EXP_LNKCTL_CCC;
 	else
 		reg16 &= ~PCI_EXP_LNKCTL_CCC;
-	pci_write_config_word(parent, ppos + PCI_EXP_LNKCTL, reg16);
+	if (reg16 != parent_reg) {
+		pci_write_config_word(parent, ppos + PCI_EXP_LNKCTL, reg16);
+		ccc_updated = true;
+	}
+
+	/* Don't need to retrain link if there is no change in CCC */
+	if (!ccc_updated)
+		return;
 
 	/* Retrain link */
 	reg16 |= PCI_EXP_LNKCTL_RL;


