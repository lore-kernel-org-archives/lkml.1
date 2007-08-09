Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbXHIVyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbXHIVyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbXHIVyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:54:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:30096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbXHIVyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:54:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,243,1183359600"; 
   d="scan'208";a="115676651"
Date: Thu, 9 Aug 2007 14:51:40 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [2.6 patch] cpqphp_ctrl.c: remove dead code
Message-Id: <20070809145140.654303a0.kristen.c.accardi@intel.com>
In-Reply-To: <20070723145105.GK26212@stusta.de>
References: <20070723145105.GK26212@stusta.de>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 16:51:05 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> If !mem_node we did already return -ENOMEM above in the function.
> 
> Spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Greg - you are listed as the maintainer for this driver.  Can you either
point me to someone who can review this patch or review it yourself?  
Looking at the code, it looks like it's possible that the driver writer
wanted this code patch to be able to be taken if it got IO resources
and not MEM resources, and if they didn't there's other cleanups that
should be done for the no iomem case.

Thanks,
Kristen


> 
> ---
> 
>  drivers/pci/hotplug/cpqphp_ctrl.c |   28 +++++++---------------------
>  1 file changed, 7 insertions(+), 21 deletions(-)
> 
> --- linux-2.6.22-rc6-mm1/drivers/pci/hotplug/cpqphp_ctrl.c.old	2007-07-23 15:13:27.000000000 +0200
> +++ linux-2.6.22-rc6-mm1/drivers/pci/hotplug/cpqphp_ctrl.c	2007-07-23 15:15:22.000000000 +0200
> @@ -2558,29 +2558,15 @@ static int configure_new_function(struct
>  			hold_IO_node = NULL;
>  		}
>  
> -		/* If we have memory resources copy them and fill in the
> -		 * bridge's memory range registers.  Otherwise, fill in the
> -		 * range registers with values that disable them. */
> -		if (mem_node) {
> -			memcpy(hold_mem_node, mem_node, sizeof(struct pci_resource));
> -			mem_node->next = NULL;
> -
> -			/* set Mem base and Limit registers */
> -			temp_word = mem_node->base >> 16;
> -			rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_BASE, temp_word);
> +		memcpy(hold_mem_node, mem_node, sizeof(struct pci_resource));
> +		mem_node->next = NULL;
>  
> -			temp_word = (mem_node->base + mem_node->length - 1) >> 16;
> -			rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_LIMIT, temp_word);
> -		} else {
> -			temp_word = 0xFFFF;
> -			rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_BASE, temp_word);
> -
> -			temp_word = 0x0000;
> -			rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_LIMIT, temp_word);
> +		/* set Mem base and Limit registers */
> +		temp_word = mem_node->base >> 16;
> +		rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_BASE, temp_word);
>  
> -			kfree(hold_mem_node);
> -			hold_mem_node = NULL;
> -		}
> +		temp_word = (mem_node->base + mem_node->length - 1) >> 16;
> +		rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_LIMIT, temp_word);
>  
>  		memcpy(hold_p_mem_node, p_mem_node, sizeof(struct pci_resource));
>  		p_mem_node->next = NULL;
> 
