Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbZKEDFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbZKEDFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 22:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbZKEDFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 22:05:19 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60987 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbZKEDFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 22:05:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AF240E7.8050200@jp.fujitsu.com>
Date: Thu, 05 Nov 2009 12:05:11 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, rdh@east.sun.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci/pcie: Avoid unnecessary PCIe link retrains
References: <19184.41676.262206.134000@gargle.gargle.HOWL> <20091104110321.5e58e112@jbarnes-piketon> <200911041628.17905.bjorn.helgaas@hp.com>
In-Reply-To: <200911041628.17905.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Wednesday 04 November 2009 12:03:21 pm Jesse Barnes wrote:
>> [Cc'ing linux-pci@vger.kernel.org too]
>>
>> On Tue, 3 Nov 2009 16:38:20 -0500
>> RDH <rdh@east.sun.com> wrote:
>>
>>> This patch avoids unnecessary PCIe link retraining sequences within
>>> the PCIe ASPM common clock setup code by issuing a link retrain
>>> command only if we are actually changing the PCIe clock configuration.
>>>
>>> Signed-off-by: Robert D. Houk <rdh@East.Sun.COM>
>>> ---
>>>  aspm.c |   20 ++++++++++++++++++++
>>>  1 file changed, 20 insertions(+)
>>> --- a/drivers/pci/pcie/aspm.c	2009-10-15 20:41:50.000000000
>>> -0400 +++ b/drivers/pci/pcie/aspm.c	2009-11-02
>>> 14:29:35.000000000 -0500 @@ -183,6 +183,7 @@ static void
>>> pcie_aspm_configure_common_c {
>>>  	int ppos, cpos, same_clock = 1;
>>>  	u16 reg16, parent_reg, child_reg[8];
>>> +	u16 lnkctl_ccc_or, lnkctl_ccc_and;
>>>  	unsigned long start_jiffies;
>>>  	struct pci_dev *child, *parent = link->pdev;
>>>  	struct pci_bus *linkbus = parent->subordinate;
>>> @@ -205,6 +206,25 @@ static void pcie_aspm_configure_common_c
>>>  	if (!(reg16 & PCI_EXP_LNKSTA_SLC))
>>>  		same_clock = 0;
>>>  
>>> +	/* Check upstream component for Common Clock Config */
>>> +	pci_read_config_word(parent, ppos + PCI_EXP_LNKCTL, &reg16);
>>> +	lnkctl_ccc_and = lnkctl_ccc_or = (reg16 &
>>> PCI_EXP_LNKCTL_CCC); +
>>> +	/* Scan downstream component for CCC, all functions */
>>> +	list_for_each_entry(child, &linkbus->devices, bus_list) {
>>> +		cpos = pci_find_capability(child, PCI_CAP_ID_EXP);
> 
> Some other places in pcie/aspm (e.g., pcie_set_clkpm_nocheck() and
> pcie_clkpm_cap_init()) check cpos for NULL.  Your code looks
> superficially similar, so maybe you should check it, too, although
> I do see many other place in aspm where we *don't* check it.
> 
> We look up this capability so often, I wonder if we should save it
> in the struct pci_dev or struct pcie_link or something in such a
> way that if we have a struct pcie_link, we are guaranteed that there
> is a PCIe capability, and we don't have to search for it again.
> 

I agree. There are a lot of codes using pci_find_capability() to
search PCIe capability offset in addition to ASPM driver. So I
think it's good idea to have PCIe cap offset in struct pci_dev.

To be honest, I have already made a following patch to add a new
field into struct pci_dev and some other patches to use this new
field a few months ago. But I have never posted them yet. If it
is a right direction, I would like to update and post them soon.

Thanks,
Kenji Kaneshige


There are a lot of codes that searches PCI express capability offset
in the PCI configuration space using pci_find_capability(). Caching it
in the struct pci_dev will reduce unncecessary search. This patch adds
an additional 'pcie_cap' fields into struct pci_dev, which is
initialized at pci device scan time (in set_pcie_port_type()).

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/pci/probe.c |    1 +
 include/linux/pci.h |    1 +
 2 files changed, 2 insertions(+)

Index: 20090825/drivers/pci/probe.c
===================================================================
--- 20090825.orig/drivers/pci/probe.c
+++ 20090825/drivers/pci/probe.c
@@ -693,6 +693,7 @@ static void set_pcie_port_type(struct pc
 	if (!pos)
 		return;
 	pdev->is_pcie = 1;
+	pdev->pcie_cap = pos;
 	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
 	pdev->pcie_type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
 }
Index: 20090825/include/linux/pci.h
===================================================================
--- 20090825.orig/include/linux/pci.h
+++ 20090825/include/linux/pci.h
@@ -218,6 +218,7 @@ struct pci_dev {
 	unsigned int	class;		/* 3 bytes: (base,sub,prog-if) */
 	u8		revision;	/* PCI revision, low byte of class word */
 	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
+	u8		pcie_cap;	/* PCI-E capability offset */
 	u8		pcie_type;	/* PCI-E device/port type */
 	u8		rom_base_reg;	/* which config register controls the ROM */
 	u8		pin;  		/* which interrupt pin this device uses */

