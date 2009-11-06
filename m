Return-Path: <linux-kernel-owner+w=401wt.eu-S1759116AbZKFBPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116AbZKFBPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 20:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbZKFBPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 20:15:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40746 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318AbZKFBPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 20:15:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AF37896.4070406@jp.fujitsu.com>
Date: Fri, 06 Nov 2009 10:15:02 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>, Matthew Wilcox <matthew@wil.cx>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, rdh@east.sun.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci/pcie: Avoid unnecessary PCIe link retrains
References: <19184.41676.262206.134000@gargle.gargle.HOWL> <200911051159.26046.bjorn.helgaas@hp.com> <20091105190707.GM10555@parisc-linux.org> <200911051329.41893.bjorn.helgaas@hp.com>
In-Reply-To: <200911051329.41893.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Thursday 05 November 2009 12:07:07 pm Matthew Wilcox wrote:
>> On Thu, Nov 05, 2009 at 12:59:25PM -0600, Bjorn Helgaas wrote:
>>> Here's another possibility, the idea being to collect all the PCIe
>>> stuff in one place.  This would require a lot of changes in the PCIe
>>> driver code, but most of them would be trivial.
>> I don't like the idea of kmallocing a 6- or 10-byte data structure
>> ... better to keep it in the pci_dev.  Maybe embedding a pcie_dev inside
>> the pci_dev would be a good idea, but unless there're more things to
>> move to it, this seems like a net loss to me.
> 
> That's true, it's not worth it for such a small structure.  I figured
> there would probably be more PCIe-related stuff that could go there,
> e.g., embedding the link_state directly.  But I haven't looked to
> see whether there actually is enough PCIe stuff to make it worthwhile.
> 

In my understanding, there are the following PCIe specific data in
struct pci_dev. It is not many.

	u8 pcie_cap;			*I added this time
	u8 pcie_type;
	struct pcie_link_state *link_state;
	unsigned int ari_enabled:1;
	unsigned int is_pcie:1;		*No longer needed and will be removed.
	unsigned int aer_firmware_first:1;

How about keeping cap offset in pci_dev so far and introducing the
following wrapper function?

static inline pcie_cap(struct pci_dev *pdev)
{
        return pdev->pcie_cap;
}

When we actually need a new data structure for PCIe-related stuff in the
future, all we need to do would be changing this wrapper like below.

static inline pcie_cap(struct pci_dev *pdev)
{
	struct pcie_dev *pcie = pdev->pcie;
	if (pcie)
		return pcie->cap;
	return 0;
}

Thanks,
Kenji Kaneshige

