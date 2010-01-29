Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850Ab0A2ANp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab0A2ANp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 19:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143Ab0A2ANo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 19:13:44 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:46124 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab0A2ANo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 19:13:44 -0500
Subject: Re: [PATCH]PCIE AER: PCI access remove spinlock protection in
 aer_inject
From: Andrew Patterson <andrew.patterson@hp.com>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: jbarnes@virtuousgeek.org, andi@firstfloor.org, ying.huang@intel.com,
       youquan.song@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <20100128163405.GA2944@youquan-linux.bj.intel.com>
References: <20100128163405.GA2944@youquan-linux.bj.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 17:13:42 -0700
Message-ID: <1264724022.13212.175.camel@bluto.andrew>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 11:34 -0500, Youquan,Song wrote:
> Move the PCI configuration access code out of the spin_lock protection because
> pci_read_aer already includes spin_lock protection which will replace the PCI
> access method if have aer error injected.
> 
> Signed-off-by: Youquan, Song <youquan.song@intel.com>
> ---
> 

I posted a similar patch on the linux-pci mailing list -- details at:

http://www.spinics.net/lists/linux-pci/msg07609.html

This version has already been accepted in the linux-pci tree.  I should
have cc'd lkml.

Andrew

> 
> diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
> index 8c30a95..953a0b9 100644
> --- a/drivers/pci/pcie/aer/aer_inject.c
> +++ b/drivers/pci/pcie/aer/aer_inject.c
> @@ -357,6 +357,22 @@ static int aer_inject(struct aer_error_inj *einj)
>  		goto out_put;
>  	}
>  
> +	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_COR_MASK, &mask);
> +	if (einj->cor_status && !(einj->cor_status & ~mask)) {
> +		ret = -EINVAL;
> +		printk(KERN_WARNING "The correctable error(s) is masked "
> +				"by device\n");
> +		goto out_put;
> +	}
> +
> +	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_UNCOR_MASK, &mask);
> +	if (einj->uncor_status && !(einj->uncor_status & ~mask)) {
> +		ret = -EINVAL;
> +		printk(KERN_WARNING "The uncorrectable error(s) is masked "
> +				"by device\n");
> +		goto out_put;
> +	}
> +
>  	spin_lock_irqsave(&inject_lock, flags);
>  
>  	err = __find_aer_error_by_dev(dev);
> @@ -374,24 +390,6 @@ static int aer_inject(struct aer_error_inj *einj)
>  	err->header_log2 = einj->header_log2;
>  	err->header_log3 = einj->header_log3;
>  
> -	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_COR_MASK, &mask);
> -	if (einj->cor_status && !(einj->cor_status & ~mask)) {
> -		ret = -EINVAL;
> -		printk(KERN_WARNING "The correctable error(s) is masked "
> -				"by device\n");
> -		spin_unlock_irqrestore(&inject_lock, flags);
> -		goto out_put;
> -	}
> -
> -	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_UNCOR_MASK, &mask);
> -	if (einj->uncor_status && !(einj->uncor_status & ~mask)) {
> -		ret = -EINVAL;
> -		printk(KERN_WARNING "The uncorrectable error(s) is masked "
> -				"by device\n");
> -		spin_unlock_irqrestore(&inject_lock, flags);
> -		goto out_put;
> -	}
> -
>  	rperr = __find_aer_error_by_dev(rpdev);
>  	if (!rperr) {
>  		rperr = rperr_alloc;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Andrew Patterson
Hewlett-Packard

