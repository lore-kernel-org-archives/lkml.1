Return-Path: <linux-kernel-owner+w=401wt.eu-S1762169AbXEPRGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762169AbXEPRGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbXEPRGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:06:47 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14259 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXEPRGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:06:46 -0400
Date: Wed, 16 May 2007 10:10:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Peter Oruba" <peter.oruba@amd.com>
Cc: gregkh@suse.de, cramerj@intel.com, john.ronciak@intel.com,
       jesse.brandeburg@intel.com, jeffrey.t.kirsher@intel.com,
       auke-jan.h.kok@intel.com, rolandd@cisco.com, halr@voltaire.com,
       linux-driver@qlogic.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [PATCH 1/2] PCI-X/PCI-Express read control interfaces
Message-Id: <20070516101027.b3767f18.randy.dunlap@oracle.com>
In-Reply-To: <200705151359.15116.peter.oruba@amd.com>
References: <200705151350.28330.peter.oruba@amd.com>
	<200705151359.15116.peter.oruba@amd.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 13:59:13 +0200 Peter Oruba wrote:

> This patch introduces an interface to read and write PCI-X / PCI-Express 
> maximum read byte count values from PCI config space. There is a second 
> function that returns the maximum _designed_ read byte count, which marks the 
> maximum value for a device, since some drivers try to set MMRBC to the 
> highest allowed value and rely on such a function.
> 
> Signed-off by: Peter Oruba <peter.oruba@amd.com>
> Based on patch set by Stephen Hemminger <shemminger@linux-foundation.org>
> 
> ---
> diff -uprN -X linux-2.6.22-rc1.orig/Documentation/dontdiff 
> linux-2.6.22-rc1.orig/drivers/pci/pci.c linux-2.6.22-rc1/drivers/pci/pci.c
> --- linux-2.6.22-rc1.orig/drivers/pci/pci.c	2007-05-14 11:29:39.473498000 
> +0200
> +++ linux-2.6.22-rc1/drivers/pci/pci.c	2007-05-15 11:44:33.804254000 +0200
> @@ -1375,6 +1375,170 @@ pci_set_consistent_dma_mask(struct pci_d
>  #endif
>  
>  /**
> + * pcix_get_max_mmrbc - get PCI-X maximum designed memory read byte count
> + * @dev: PCI device to query
> + *
> + * Returns mmrbc: maximum designed memory read count in bytes
> + *    or appropriate error value.
> + */
> +int
> +pcix_get_max_mmrbc(struct pci_dev *dev)

Kernel style is like so (referring to multiple occurrences):

int pcix_get_max_mmrbc(struct pci_dev *dev)

Yes, that source file does it both ways (and needs to be Fixed).


> +{
> +	int ret, err, cap;
> +	u32 stat;
> +	
> +	cap = pci_find_capability(dev, PCI_CAP_ID_PCIX);
> +	if (!cap)
> +		return -EINVAL;
> +
> +	err = pci_read_config_dword(dev, cap + PCI_X_STATUS, &stat);
> +	if (err)
> +		return -EINVAL;
> +
> +	ret = (stat & PCI_X_STATUS_MAX_READ) >> 12;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(pcix_get_max_mmrbc);
> +
> +
> +/**
> + * pcix_set_mmrbc - set PCI-X maximum memory read byte count
> + * @dev: PCI device to query
> + * @mmrbc: maximum memory read count in bytes
> + *    valid values are 512, 1024, 2048, 4096
> + *
> + * If possible sets maximum memory read byte count, some bridges have erratas

	"errata" is plural.

> + * that prevent this.
> + */
> +int
> +pcix_set_mmrbc(struct pci_dev *dev, int mmrbc)
> +{
...
> +}
> +EXPORT_SYMBOL(pcix_set_mmrbc);
> +
> +/**
> + * pcie_get_readrq - get PCI Express read request size
> + * @dev: PCI device to query
> + *
> + * Returns maximum memory read request in bytes
> + *    or appropriate error value.
> + */
> +int pcie_get_readrq(struct pci_dev *dev)

:)

> +{
> +	int ret, cap;
> +	u16 ctl;
> +
> +	cap = pci_find_capability(dev, PCI_CAP_ID_EXP);
> +	if (!cap)
> +		return -EINVAL;
> +
> +	ret = pci_read_config_word(dev, cap + PCI_EXP_DEVCTL, &ctl);
> +	if (!ret)
> +	ret = 128 << ((ctl & PCI_EXP_DEVCTL_READRQ) >> 12);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(pcie_get_readrq);
> +


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
