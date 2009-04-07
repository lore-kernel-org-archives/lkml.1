Return-Path: <linux-kernel-owner+w=401wt.eu-S1759559AbZDGReO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbZDGReO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbZDGRdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:33:54 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:10617 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756AbZDGRdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:33:53 -0400
Subject: Re: [PATCH next] pci: fix build error with !PCIE_ECRC
From: Andrew Patterson <andrew.patterson@hp.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org
In-Reply-To: <20090407123707.GA18687@orion>
References: <20090407123707.GA18687@orion>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 17:33:49 +0000
Message-Id: <1239125629.19984.196.camel@grinch>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 16:37 +0400, Alexander Beregalov wrote:
> Fix this build error:
> drivers/built-in.o: In function `pci_init_capabilities':
> drivers/pci/probe.c:989: undefined reference to `pcie_set_ecrc_checking'
> drivers/built-in.o: In function `pci_setup':
> drivers/pci/pci.c:2547: undefined reference to `pcie_ecrc_get_policy'
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
> 
>  drivers/pci/pci.c        |    2 ++
>  drivers/pci/pcie/Kconfig |    2 +-
>  drivers/pci/probe.c      |    2 ++
>  3 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index f61b2cf..f1c393e 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2543,8 +2543,10 @@ static int __init pci_setup(char *str)
>  			} else if (!strncmp(str, "resource_alignment=", 19)) {
>  				pci_set_resource_alignment_param(str + 19,
>  							strlen(str + 19));
> +#ifdef CONFIG_PCIE_ECRC
>  			} else if (!strncmp(str, "ecrc=", 5)) {
>  				pcie_ecrc_get_policy(str + 5);
> +#endif
>  			} else {
>  				printk(KERN_ERR "PCI: Unknown option `%s'\n",
>  						str);
> diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
> index a79e52b..9d0e727 100644
> --- a/drivers/pci/pcie/Kconfig
> +++ b/drivers/pci/pcie/Kconfig
> @@ -52,7 +52,7 @@ config PCIEASPM_DEBUG
>  #
>  config PCIE_ECRC
>  	bool "PCI Express ECRC support"
> -	depends on PCI
> +	depends on PCI && PCIEPORTBUS

We really only need this.  There are empty functions in
include/linux/pci.h to handle the case where PCIE_ECRC is not defined.
The problem is that the code in drivers/pci/pcie is only compiled if
PCIEPORTBUS is defined.  This feature does not depend on any PCIEPORTBUS
code. So either ecrc.c needs to be moved to drivers/pci or we need to
not assume that drivers/pci/pcie is only for the portbus driver.


>  	help
>  	  Enables PCI Express ECRC (transaction layer end-to-end CRC
>  	  checking)
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index d5125a1..8d402a8 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -985,8 +985,10 @@ static void pci_init_capabilities(struct pci_dev *dev)
>  	/* Single Root I/O Virtualization */
>  	pci_iov_init(dev);
>  
> +#ifdef CONFIG_PCIE_ECRC
>  	/* PCIe end-to-end CRC checking */
>  	pcie_set_ecrc_checking(dev);
> +#endif
>  }
>  
>  void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
> 
-- 
Andrew Patterson
Hewlett-Packard

