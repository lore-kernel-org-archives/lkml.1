Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab0BBLd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 06:33:26 -0500
Received: from smtp.citrix.com ([66.165.176.89]:8990 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666Ab0BBLdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 06:33:25 -0500
X-IronPort-AV: E=Sophos;i="4.49,389,1262581200"; 
   d="scan'208";a="7043267"
Subject: Re: [Xen-devel] [PATCH 6/6] xen/hybrid: Enable grant table and
 xenbus
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Sheng Yang <sheng@linux.intel.com>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1265098747-10117-7-git-send-email-sheng@linux.intel.com>
References: <1265098747-10117-1-git-send-email-sheng@linux.intel.com>
	 <1265098747-10117-7-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 2 Feb 2010 11:33:10 +0000
Message-ID: <1265110390.2965.22456.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 08:19 +0000, Sheng Yang wrote:
> Notice one memory region(0xfbfe0000ul - 0xfc000000ul) would be reserved in the
> bios E820 table. This memory region would be used as grant table.

I queried this requirement in a reply to the hypervisor patch.

> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 05a31e5..d7dfba9 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1071,6 +1071,9 @@ static int __init xlblk_init(void)
>  	if (!xen_domain())
>  		return -ENODEV;
>  
> +	if (xen_hybrid_domain() && !xen_hybrid_evtchn_enabled())
> +		return -ENODEV;
> +

This seems ugly, at the very least the check should be something like
xen_evtchn_enabled() but preferable would be to hook up evtchn's by
demuxing the PCI device IRQ (the exiting PVonHVM drivers mechanism) in
the case where hybrid evtchn's are not available and encapsulating the
differences inside the evtchn code, there should be no need to scatter
these sorts of checks throughout every driver.

If you don't want to demux the PCI device IRQ for the non-hybrid case
another option might be simply return failure from the evtchn operations
if hybrid evtchns are not available and to ensure that the drivers
handle that sort of error gracefully (which they should in any case). At
least the difference in mode would be encapsulated that way.

(same for netfront).

>  	if (register_blkdev(XENVBD_MAJOR, DEV_NAME)) {
>  		printk(KERN_WARNING "xen_blk: can't get major %d with name %s\n",
>  		       XENVBD_MAJOR, DEV_NAME);
> diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
> index c721c0a..74cbb25 100644
> --- a/drivers/input/xen-kbdfront.c
> +++ b/drivers/input/xen-kbdfront.c
> @@ -341,6 +341,10 @@ static int __init xenkbd_init(void)
>  	if (!xen_domain())
>  		return -ENODEV;
>  
> +	/* Xen Hybrid domain don't need vkbd */
> +	if (xen_hybrid_domain())
> +		return -ENODEV;
> +

Why disallow it if the platform has specified it (same for fbfront)?

> diff --git a/include/xen/xen.h b/include/xen/xen.h
> index aace9cc..632e76f 100644
> --- a/include/xen/xen.h
> +++ b/include/xen/xen.h
> @@ -5,6 +5,7 @@ enum xen_domain_type {
>  	XEN_NATIVE,		/* running on bare hardware    */
>  	XEN_PV_DOMAIN,		/* running in a PV domain      */
>  	XEN_HVM_DOMAIN,		/* running in a Xen hvm domain */
> +	XEN_HYBRID_DOMAIN,	/* running in a Xen hybrid hvm domain */
>  };

I don't think you should need to distinguish HYBRID from HVM mode...

Ian.

