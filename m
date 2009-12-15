Return-Path: <linux-kernel-owner+w=401wt.eu-S1758918AbZLOA3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918AbZLOA3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZLOA3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:29:19 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:32479 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758900AbZLOA3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:29:18 -0500
Subject: Re: [PATCH]PCIe AER: reject aer inject if hardware mask error
 reporting
From: Andrew Patterson <andrew.patterson@hp.com>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: jbarnes@virtuousgeek.org, andi@firstfloor.org, ying.huang@intel.com,
       kent.liu@intel.com, youquan.song@intel.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20091211234855.GB7196@youquan-linux.bj.intel.com>
References: <20091211234855.GB7196@youquan-linux.bj.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 17:29:14 -0700
Message-ID: <1260836954.19155.84.camel@bluto.andrew>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 18:48 -0500, Youquan,Song wrote:
> Correcteable/Uncorrectable Error Mask Register are used by PCIe AER driver 
> which will controls the reporting of idividual errors to PCIe RC via PCIe
> error messages. 
> 
> If hardware masks special error reporting to RC, the aer_inject driver should
>  not inject aer error.
> 
> Signed-off-by: Youquan, Song <youquan.song@intel.com>
> Acked-by: Ying, Huang <ying.huang@intel.com>
> ---
> 
> diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
> index ad77f0c..fa2bc22 100644
> --- a/drivers/pci/pcie/aer/aer_inject.c
> +++ b/drivers/pci/pcie/aer/aer_inject.c
> @@ -302,7 +302,7 @@ static int aer_inject(struct aer_error_inj *einj)
>  	unsigned long flags;
>  	unsigned int devfn = PCI_DEVFN(einj->dev, einj->fn);
>  	int pos_cap_err, rp_pos_cap_err;
> -	u32 sever;
> +	u32 sever, mask;
>  	int ret = 0;
>  
>  	dev = pci_get_bus_and_slot(einj->bus, devfn);

This does not apply.  Please respin against latest linux-2.6 or pci-2.6.

> @@ -354,6 +354,22 @@ static int aer_inject(struct aer_error_inj *einj)
>  	err->header_log2 = einj->header_log2;
>  	err->header_log3 = einj->header_log3;
>  
> +	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_COR_MASK, &mask);
> +	if (einj->cor_status && !(einj->cor_status & ~mask)) {
> +		ret = -EINVAL;
> +		printk(KERN_WARNING "The correctable error is masked by device\n");

You can inject multiple correctable errors with the aer-inject user-land
tool, so perhaps this should be re-worded as:

"The correctable error(s) are masked by the device\n"

> +		spin_unlock_irqrestore(&inject_lock, flags);
> +		goto out_put;
> +	}
> +
> +	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_UNCOR_MASK, &mask);
> +	if (einj->uncor_status && !(einj->uncor_status & ~mask)) {
> +		ret = -EINVAL;
> +		printk(KERN_WARNING "The uncorrectable error is masked by device\n");

Same as above

> +		spin_unlock_irqrestore(&inject_lock, flags);
> +		goto out_put;
> +	}
> +

You can also simultaneously inject correctable and uncorrectable errors,
so I don't particularly like returning errors here.  Perhaps you should
just print the warning message out and just not inject the masked
errors.

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

