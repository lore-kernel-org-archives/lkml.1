Return-Path: <linux-kernel-owner+w=401wt.eu-S2992628AbXCGVg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992628AbXCGVg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992630AbXCGVg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:36:56 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59665 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992628AbXCGVgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:36:55 -0500
Date: Wed, 7 Mar 2007 13:33:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Williamson <alex.williamson@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Marcel Selhorst <tpm@selhorst.net>, Kylene Jo Hall <kjhall@us.ibm.com>
Subject: Re: [PATCH] tpm_infineon: add support for devices in mmio space
Message-Id: <20070307133326.fcf6f891.akpm@linux-foundation.org>
In-Reply-To: <1173290290.5941.204.camel@bling>
References: <1173290290.5941.204.camel@bling>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2007 10:58:10 -0700
Alex Williamson <alex.williamson@hp.com> wrote:

>  			 dev->name, dev_id->id);
> -		if (!((TPM_INF_BASE >> 8) & 0xff)) {
> +		if (!((tpm_dev.data_regs >> 8) & 0xff)) {
>  			rc = -EINVAL;
>  			goto err_last;
>  		}
>  		/* publish my base address and request region */
> -		if (request_region
> -		    (TPM_INF_BASE, TPM_INF_PORT_LEN, "tpm_infineon0") == NULL) {
> +		if (request_region(tpm_dev.data_regs, tpm_dev.data_size,
> +				   "tpm_infineon0") == NULL) {
>  			rc = -EINVAL;
>  			goto err_last;
>  		}
> -		if (request_region
> -		    (TPM_INF_ADDR, TPM_INF_ADDR_LEN, "tpm_infineon0") == NULL) {
> +		if (request_region(tpm_dev.config_port, tpm_dev.config_size,
> +				   "tpm_infineon0") == NULL) {
>  			rc = -EINVAL;
>  			goto err_last;
>  		}
> +	} else if (pnp_mem_valid(dev, 0) &&
> +	           !(pnp_mem_flags(dev, 0) & IORESOURCE_DISABLED)) {
> +
> +	    	tpm_dev.iotype = TPM_INF_IO_MEM;
> +
> +		tpm_dev.map_base = pnp_mem_start(dev, 0);
> +		tpm_dev.map_size = pnp_mem_len(dev, 0);
> +
> +		dev_info(&dev->dev, "Found %s with ID %s\n",
> +			 dev->name, dev_id->id);
> +
> +		/* publish my base address and request region */
> +		if (request_mem_region(tpm_dev.map_base, tpm_dev.map_size,
> +				       "tpm_infineon0") == NULL) {
> +			rc = -EINVAL;
> +			goto err_last;
> +		}
> +
> +		tpm_dev.mem_base = ioremap(tpm_dev.map_base, tpm_dev.map_size);
> +		if (tpm_dev.mem_base == NULL) {
> +			rc = -EINVAL;
> +			goto err_last;
> +		}
>
> ...
>
> err_last:
>	return rc;
> }
	
tpm_inf_pnp_probe() leaks resources all over the place if something goes
wrong.

