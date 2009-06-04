Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbZFDXrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbZFDXrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 19:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZFDXrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 19:47:03 -0400
Received: from mga07.intel.com ([143.182.124.22]:64974 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752350AbZFDXrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 19:47:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,307,1241420400"; 
   d="scan'208";a="150873169"
Date: Fri, 5 Jun 2009 01:49:12 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] MFD: ASIC3: add clock handling for MFD cells
Message-ID: <20090604234911.GC5460@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1244140576-18006-1-git-send-email-philipp.zabel@gmail.com> <1244140576-18006-3-git-send-email-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244140576-18006-3-git-send-email-philipp.zabel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Thu, Jun 04, 2009 at 08:36:11PM +0200, Philipp Zabel wrote:
> +
> +struct asic3_clk {
> +	int enabled;
You probably want to use a kref here.

> +static int asic3_clk_enable(struct asic3 *asic, struct asic3_clk *clk)
> +{
> +	unsigned long flags;
> +	u32 cdex;
> +
> +	spin_lock_irqsave(&asic->lock, flags);
> +	if (clk->enabled++ == 0) {
using the kref API here would definitely be nicer.

Cheers,
Samuel.

> +		cdex = asic3_read_register(asic, ASIC3_OFFSET(CLOCK, CDEX));
> +		cdex |= clk->cdex;
> +		asic3_write_register(asic, ASIC3_OFFSET(CLOCK, CDEX), cdex);
> +	}
> +	spin_unlock_irqrestore(&asic->lock, flags);
> +
> +	return 0;
> +}
> +
> +static void asic3_clk_disable(struct asic3 *asic, struct asic3_clk *clk)
> +{
> +	unsigned long flags;
> +	u32 cdex;
> +
> +	WARN_ON(clk->enabled == 0);
> +
> +	spin_lock_irqsave(&asic->lock, flags);
> +	if (--clk->enabled == 0) {
> +		cdex = asic3_read_register(asic, ASIC3_OFFSET(CLOCK, CDEX));
> +		cdex &= ~clk->cdex;
> +		asic3_write_register(asic, ASIC3_OFFSET(CLOCK, CDEX), cdex);
> +	}
> +	spin_unlock_irqrestore(&asic->lock, flags);
> +}
>  
>  /* Core */
>  static int __init asic3_probe(struct platform_device *pdev)
> @@ -638,6 +713,11 @@ static int __init asic3_probe(struct platform_device *pdev)
>  		goto out_irq;
>  	}
>  
> +	/* Making a per-device copy is only needed for the
> +	 * theoretical case of multiple ASIC3s on one board:
> +	 */
> +	memcpy(asic->clocks, asic3_clk_init, sizeof(asic3_clk_init));
> +
>  	dev_info(asic->dev, "ASIC3 Core driver\n");
>  
>  	return 0;
> -- 
> 1.6.3.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
