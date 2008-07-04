Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbYGDCtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbYGDCtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 22:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYGDCtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 22:49:16 -0400
Received: from demeter.kernel.org ([140.211.167.37]:46130 "EHLO
	hera.kernel.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754104AbYGDCtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 22:49:15 -0400
Message-ID: <486D8F88.9000904@kernel.org>
Date: Fri, 04 Jul 2008 11:48:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC PATCH] AHCI: speed up resume
References: <1215074882.3214.15.camel@rzhang-dt.sh.intel.com>
In-Reply-To: <1215074882.3214.15.camel@rzhang-dt.sh.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Zhang.

Zhang Rui wrote:
> During S3 resume, AHCI driver sleeps 1 second to wait for the HBA reset
> to finish. This is luxurious, :)
> 
> According to the AHCI 1.2 spec, We should poll the HOST_CTL register,
> and return error if the host reset is not finished within 1 second.
> 
> Test results show that the HBA reset can be done quickly(in usecs).
> And this patch may save nearly 1 second during resume.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> --
>  drivers/ata/ahci.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/drivers/ata/ahci.c
> ===================================================================
> --- linux-2.6.orig/drivers/ata/ahci.c	2007-05-03 11:06:33.000000000 +0800
> +++ linux-2.6/drivers/ata/ahci.c	2008-07-02 16:25:54.000000000 +0800
> @@ -1073,18 +1073,29 @@
>  
>  	/* global controller reset */
>  	if (!ahci_skip_host_reset) {
> +		int delay = msecs_to_jiffies(1000);
> +		int timeout;
> +
>  		tmp = readl(mmio + HOST_CTL);
>  		if ((tmp & HOST_RESET) == 0) {
>  			writel(tmp | HOST_RESET, mmio + HOST_CTL);
>  			readl(mmio + HOST_CTL); /* flush */
>  		}
>  
> -		/* reset must complete within 1 second, or
> +		/*
> + 		 * to perform host reset, OS should set HOST_RESET
> +		 * and poll until this bit is read to be "0"
> + 		 * reset must complete within 1 second, or
>  		 * the hardware should be considered fried.
>  		 */
> -		ssleep(1);
> +		timeout = jiffies + delay;
> +		while (jiffies < timeout) {
> +			tmp = readl(mmio + HOST_CTL);
> +			if (!(tmp & HOST_RESET))
> +				break;
> +			cpu_relax();
> +		}

Looks good in principle.  Just two things...

1. Please don't busy-loop.  e.g. No one would notice 10ms delay between
polls.

2. Please use ata_wait_register().

Thanks.

-- 
tejun
