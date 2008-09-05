Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbYIELIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbYIELIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 07:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYIELIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 07:08:04 -0400
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:45387 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbYIELID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 07:08:03 -0400
Date: Fri, 5 Sep 2008 12:07:56 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] PCI: add interface to set visible size of VPD
Message-ID: <20080905110755.GI7908@solarflare.com>
References: <20080904205636.130211023@vyatta.com> <20080904205718.708966839@vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904205718.708966839@vyatta.com>
User-Agent: Mutt/1.4.1i
X-Originating-Smarthost02-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> The VPD on all devices may not be 32K. Unfortunately, there is no
> generic way to find the size, so this adds a simple API hook
> to reset it.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> --- a/drivers/pci/access.c	2008-09-04 11:29:22.000000000 -0700
> +++ b/drivers/pci/access.c	2008-09-04 11:38:29.000000000 -0700
> @@ -332,6 +332,24 @@ int pci_vpd_pci22_init(struct pci_dev *d
>  }
>  
>  /**
> + * pci_vpd_size - Set available Vital Product Data size
> + * @dev:	pci device struct
> + * @size:	available memory in bytes
> + *
> + * Adjust size of available VPD area.
> + */
> +int pci_vpd_size(struct pci_dev *dev, size_t size)
> +{
> +	if (!dev->vpd)
> +		return -EINVAL;
> +	if (size > PCI_VPD_PCI22_SIZE)
> +		return -EINVAL;

This assumes that PCI 2.2 VPD is the only VPD implementation (which is true
at the moment, but at least PCI 2.1 VPD should be added).  Maybe this should
compare with the current length instead?

Ben.

> +	dev->vpd->len = size;
> +	return 0;
> +}
> +EXPORT_SYMBOL(pci_vpd_size);
> +
> +/**
>   * pci_block_user_cfg_access - Block userspace PCI config reads/writes
>   * @dev:	pci device struct
>   *
> --- a/include/linux/pci.h	2008-09-04 11:28:45.000000000 -0700
> +++ b/include/linux/pci.h	2008-09-04 11:29:15.000000000 -0700
> @@ -653,6 +653,7 @@ int pci_bus_find_capability(struct pci_b
>  /* Vital product data routines */
>  int pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
>  int pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void *buf);
> +int pci_vpd_size(struct pci_dev *dev, size_t size);
>  
>  /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
>  void pci_bus_assign_resources(struct pci_bus *bus);
> 
> -- 
> 

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.
