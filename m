Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbYGCXWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbYGCXWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 19:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbYGCXV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 19:21:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44509 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702AbYGCXV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 19:21:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH] AHCI: speed up resume
Date: Fri, 4 Jul 2008 01:23:49 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, tj@kernel.org
References: <1215074882.3214.15.camel@rzhang-dt.sh.intel.com>
In-Reply-To: <1215074882.3214.15.camel@rzhang-dt.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807040123.50337.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of July 2008, Zhang Rui wrote:
> During S3 resume, AHCI driver sleeps 1 second to wait for the HBA reset
> to finish. This is luxurious, :)
> 
> According to the AHCI 1.2 spec, We should poll the HOST_CTL register,
> and return error if the host reset is not finished within 1 second.
> 
> Test results show that the HBA reset can be done quickly(in usecs).
> And this patch may save nearly 1 second during resume.

That's a lot.

How heavily has it been tested?

Rafael


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
>  
> -		tmp = readl(mmio + HOST_CTL);
>  		if (tmp & HOST_RESET) {
>  			dev_printk(KERN_ERR, host->dev,
>  				   "controller reset failed (0x%x)\n", tmp);
> 
> 
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
