Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbXBHSpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbXBHSpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 13:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbXBHSpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 13:45:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55232 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbXBHSph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 13:45:37 -0500
Date: Thu, 8 Feb 2007 18:45:34 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pm3fb: kill pci_find_device usage
In-Reply-To: <20070131170620.13d88820@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702081845050.7686@pentafluge.infradead.org>
References: <20070131170620.13d88820@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 31 Jan 2007, Alan wrote:

> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/video/pm3fb.c linux-2.6.20-rc6-mm3/drivers/video/pm3fb.c
> --- linux.vanilla-2.6.20-rc6-mm3/drivers/video/pm3fb.c	2007-01-31 14:20:10.000000000 +0000
> +++ linux-2.6.20-rc6-mm3/drivers/video/pm3fb.c	2007-01-31 14:36:25.000000000 +0000
> @@ -3299,14 +3299,12 @@
>  		fb_info[i].dev = NULL;
>  	}
>  
> -	dev =
> -	    pci_find_device(PCI_VENDOR_ID_3DLABS,
> +	dev = pci_get_device(PCI_VENDOR_ID_3DLABS,
>  			    PCI_DEVICE_ID_3DLABS_PERMEDIA3, dev);
>  
>  	for (i = 0; ((i < PM3_MAX_BOARD) && dev); i++) {
>  		dev_array[i] = dev;
> -		dev =
> -		    pci_find_device(PCI_VENDOR_ID_3DLABS,
> +		dev = pci_get_device(PCI_VENDOR_ID_3DLABS,
>  				    PCI_DEVICE_ID_3DLABS_PERMEDIA3, dev);
>  	}
>  
> @@ -3353,7 +3351,7 @@
>  	/* now, initialize... or not */
>  	for (i = 0; i < PM3_MAX_BOARD; i++) {
>  		l_fb_info = &(fb_info[i]);
> -		if ((l_fb_info->dev) && (!disable[i])) {	/* PCI device was found and not disabled by user */
> +		if (l_fb_info->dev && !disable[i]) {	/* PCI device was found and not disabled by user */
>  			DPRINTK(2,
>  				"found @%lx Vendor %lx Device %lx ; base @ : %lx - %lx - %lx - %lx - %lx - %lx, irq %ld\n",
>  				(unsigned long) l_fb_info->dev,
> @@ -3608,7 +3606,7 @@
>  
>  	pm3fb_init();
>  
> -	return (0);
> +	return 0;
>  }
>  
>  void cleanup_module(void)
> @@ -3619,23 +3617,18 @@
>  		struct pm3fb_info *l_fb_info;
>  		for (i = 0; i < PM3_MAX_BOARD; i++) {
>  			l_fb_info = &(fb_info[i]);
> -			if ((l_fb_info->dev != NULL)
> -			    && (!(disable[l_fb_info->board_num]))) {
> -				if (l_fb_info->vIOBase !=
> -				    (unsigned char *) -1) {
> +			pci_dev_put(l_fb_info->dev);
> +			if (l_fb_info->dev != NULL  && !(disable[l_fb_info->board_num])) {
> +				if (l_fb_info->vIOBase != (unsigned char *) -1) {
>  					pm3fb_unmapIO(l_fb_info);
>  					release_mem_region(l_fb_info->p_fb,
> -							   l_fb_info->
> -							   fb_size);
> -					release_mem_region(l_fb_info->
> -							   pIOBase,
> -							   PM3_REGS_SIZE);
> +						   l_fb_info->fb_size);
> +					release_mem_region(l_fb_info->pIOBase,
> +						   PM3_REGS_SIZE);
>  				}
> -				unregister_framebuffer(&l_fb_info->gen.
> -						       info);
> +				unregister_framebuffer(&l_fb_info->gen.info);
>  			}
>  		}
>  	}
> -	return;
>  }
>  #endif /* MODULE */

Acked-By: James Simmons <jsimmons@infradead.org>

