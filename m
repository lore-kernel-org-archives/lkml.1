Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZEGSVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZEGSVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZEGSV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:21:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:45927 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbZEGSVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:21:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,312,1239001200"; 
   d="scan'208";a="513450432"
Subject: Re: [PATCH 2/2] Intel-IOMMU, intr-remap: source-id checking
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: "Han, Weidong" <weidong.han@intel.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
In-Reply-To: <1241676996-27406-2-git-send-email-weidong.han@intel.com>
References: <1241676996-27406-1-git-send-email-weidong.han@intel.com>
	 <1241676996-27406-2-git-send-email-weidong.han@intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 07 May 2009 11:19:41 -0700
Message-Id: <1241720381.27006.8582.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-06 at 23:16 -0700, Han, Weidong wrote:
> @@ -634,6 +694,44 @@ static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
>  			       " 0x%Lx\n", scope->enumeration_id,
>  			       drhd->address);
>  
> +			bus = pci_find_bus(drhd->segment, scope->bus);
> +			path = (struct acpi_dmar_pci_path *)(scope + 1);
> +			count = (scope->length -
> +				 sizeof(struct acpi_dmar_device_scope))
> +				/ sizeof(struct acpi_dmar_pci_path);
> +
> +			while (count) {
> +				if (pdev)
> +					pci_dev_put(pdev);
> +
> +				if (!bus)
> +					break;
> +
> +				pdev = pci_get_slot(bus,
> +					PCI_DEVFN(path->dev, path->fn));
> +				if (!pdev)
> +					break;

ir_parse_ioapic_scope() happens very early in the boot. So, I don't
think we can do the pci related discovery here.

thanks,
suresh

> +
> +				path++;
> +				count--;
> +				bus = pdev->subordinate;
> +			}
> +
> +			if (pdev) { /* PCI discoverable IOAPIC*/
> +				ir_ioapic[ir_ioapic_num].bus =
> +					pdev->bus->number;
> +				ir_ioapic[ir_ioapic_num].devfn = pdev->devfn;
> +			} else { /* Not PCI discoverable IOAPIC */
> +				if (!bus)
> +					ir_ioapic[ir_ioapic_num].bus =
> +						scope->bus;
> +				else
> +					ir_ioapic[ir_ioapic_num].bus =
> +						bus->number;
> +				ir_ioapic[ir_ioapic_num].devfn =
> +					PCI_DEVFN(path->dev, path->fn);
> +			}
> +
>  			ir_ioapic[ir_ioapic_num].iommu = iommu;
>  			ir_ioapic[ir_ioapic_num].id = scope->enumeration_id;
>  			ir_ioapic_num++;


