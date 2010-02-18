Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab0BREI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 23:08:58 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35746 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0BREIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 23:08:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B7CBD37.9000706@jp.fujitsu.com>
Date: Thu, 18 Feb 2010 13:08:23 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH 2/8] PCI PM: PCIe PME root port service driver (rev. 5)
References: <201002172335.47703.rjw@sisk.pl> <201002172339.08865.rjw@sisk.pl>
In-Reply-To: <201002172339.08865.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm sorry for the delayed comments.

> +
> +/**
> + * pcie_pme_interrupt_enable - Enable/disable PCIe PME interrupt generation.
> + * @dev: PCIe root port or event collector.
> + * @enable: Enable or disable the interrupt.
> + */
> +static void pcie_pme_interrupt_enable(struct pci_dev *dev, bool enable)
> +{
> +	int rtctl_pos;
> +	u16 rtctl;
> +
> +	rtctl_pos = pci_find_capability(dev, PCI_CAP_ID_EXP) + PCI_EXP_RTCTL;

How about

	rtctl_pos = pci_pcie_cap(dev) + PCI_EXP_RTCTL;

?

The pci_pcie_cap() returns PCIe capability offset saved in struct pci_dev.
By using this, we can avoid redundant search in PCI configuration space.

> +
> +/**
> + * pcie_pme_clear_status - Clear root port PME interrupt status.
> + * @dev: PCIe root port or event collector.
> + */
> +static void pcie_pme_clear_status(struct pci_dev *dev)
> +{
> +	int rtsta_pos;
> +	u32 rtsta;
> +
> +	rtsta_pos = pci_find_capability(dev, PCI_CAP_ID_EXP) + PCI_EXP_RTSTA;

Ditto.


> +/**
> + * pcie_pme_work_fn - Work handler for PCIe PME interrupt.
> + * @work: Work structure giving access to service data.
> + */
> +static void pcie_pme_work_fn(struct work_struct *work)
> +{
> +	struct pcie_pme_service_data *data =
> +			container_of(work, struct pcie_pme_service_data, work);
> +	struct pci_dev *port = data->srv->port;
> +	int rtsta_pos;
> +	u32 rtsta;
> +
> +	rtsta_pos = pci_find_capability(port, PCI_CAP_ID_EXP) + PCI_EXP_RTSTA;

Ditto.


> +/**
> + * pcie_pme_irq - Interrupt handler for PCIe root port PME interrupt.
> + * @irq: Interrupt vector.
> + * @context: Interrupt context pointer.
> + */
> +static irqreturn_t pcie_pme_irq(int irq, void *context)
> +{
> +	struct pci_dev *port;
> +	struct pcie_pme_service_data *data;
> +	int rtsta_pos;
> +	u32 rtsta;
> +	unsigned long flags;
> +
> +	port = ((struct pcie_device *)context)->port;
> +	data = get_service_data((struct pcie_device *)context);
> +
> +	rtsta_pos = pci_find_capability(port, PCI_CAP_ID_EXP) + PCI_EXP_RTSTA;

Ditto.


Thanks,
Kenji Kaneshige

