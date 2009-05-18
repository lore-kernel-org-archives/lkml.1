Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbZERJwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbZERJwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758946AbZERJq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:46:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:2484 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758924AbZERJqy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:46:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,208,1241420400"; 
   d="scan'208";a="691330056"
From: "Han, Weidong" <weidong.han@intel.com>
To: "'Ingo Molnar'" <mingo@elte.hu>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'dwmw2@infradead.org'" <dwmw2@infradead.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>
Date: Mon, 18 May 2009 17:46:22 +0800
Subject: RE: [PATCH 2/2] Intel-IOMMU, intr-remap: source-id checking
Thread-Topic: [PATCH 2/2] Intel-IOMMU, intr-remap: source-id checking
Thread-Index: AcnSO031hCPtwKsBSROvEnaAT4mNkwFYLqNQ
Message-ID: <715D42877B251141A38726ABF5CABF2C054568FA16@pdsmsx503.ccr.corp.intel.com>
References: <1241676996-27406-1-git-send-email-weidong.han@intel.com>
 <1241676996-27406-2-git-send-email-weidong.han@intel.com>
 <1241720381.27006.8582.camel@localhost.localdomain>
 <715D42877B251141A38726ABF5CABF2C01A6DD4900@pdsmsx503.ccr.corp.intel.com>
 <20090511132027.GC32693@elte.hu>
In-Reply-To: <20090511132027.GC32693@elte.hu>
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

Ingo Molnar wrote:
> * Han, Weidong <weidong.han@intel.com> wrote:
> 
>> Siddha, Suresh B wrote:
>>> On Wed, 2009-05-06 at 23:16 -0700, Han, Weidong wrote:
>>>> @@ -634,6 +694,44 @@ static int ir_parse_ioapic_scope(struct
>>>>  			       acpi_dmar_header *header, " 0x%Lx\n",
>>>>  			       scope->enumeration_id, drhd->address);
>>>> 
>>>> +			bus = pci_find_bus(drhd->segment, scope->bus);
>>>> +			path = (struct acpi_dmar_pci_path *)(scope + 1); +			count =
>>>> (scope->length - +				 sizeof(struct acpi_dmar_device_scope))
>>>> +				/ sizeof(struct acpi_dmar_pci_path);
>>>> +
>>>> +			while (count) {
>>>> +				if (pdev)
>>>> +					pci_dev_put(pdev);
>>>> +
>>>> +				if (!bus)
>>>> +					break;
>>>> +
>>>> +				pdev = pci_get_slot(bus,
>>>> +					PCI_DEVFN(path->dev, path->fn));
>>>> +				if (!pdev)
>>>> +					break;
>>> 
>>> ir_parse_ioapic_scope() happens very early in the boot. So, I
>>> don't think we can do the pci related discovery here.
>>> 
>> 
>> Thanks for your pointing it out. It should enable the source-id
>> checking for io-apic's after the pci subsystem is up. I will
>> change it.
> 
> Note, there's ways to do early PCI quirks too, check
> arch/x86/kernel/early-quirks.c. It's done by reading the PCI
> configuration space directly via a careful early-capable subset of
> the PCI config space APIs.
> 
> But it's a method of last resort.
> 

Thanks for your reminder. It can use direct PCI access here as follows. It's easy and clean. I think it's better than adding the source-id checking for io-apic's after the pci subsystem is up. I will send out updated patches after some tests.
 
@@ -634,6 +695,24 @@ static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
                               " 0x%Lx\n", scope->enumeration_id,
                               drhd->address);

+                       bus = scope->bus;
+                       path = (struct acpi_dmar_pci_path *)(scope + 1);
+                       count = (scope->length -
+                                sizeof(struct acpi_dmar_device_scope))
+                               / sizeof(struct acpi_dmar_pci_path);
+
+                       while (--count > 0) {
+                               /* Access PCI directly due to the PCI
+                                * subsystem isn't initialized yet.
+                                */
+                               bus = read_pci_config_byte(bus, path->dev,
+                                       path->fn, PCI_SECONDARY_BUS);
+                               path++;
+                       }
+
+                       ir_ioapic[ir_ioapic_num].bus = bus;
+                       ir_ioapic[ir_ioapic_num].devfn =
+                                       PCI_DEVFN(path->dev, path->fn);
                        ir_ioapic[ir_ioapic_num].iommu = iommu;
                        ir_ioapic[ir_ioapic_num].id = scope->enumeration_id;
                        ir_ioapic_num++;




