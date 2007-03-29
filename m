Return-Path: <linux-kernel-owner+w=401wt.eu-S1030344AbXC2RI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030344AbXC2RI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030360AbXC2RI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:08:58 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:31534 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030344AbXC2RI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:08:57 -0400
Date: Thu, 29 Mar 2007 19:08:55 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, mark.langsdorf@amd.com
Subject: Re: [PATCH] fix amd64-agp aperture validation
Message-ID: <20070329170855.GA3984@rhun.haifa.ibm.com>
References: <460B8DA8.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460B8DA8.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 08:58:00AM +0100, Jan Beulich wrote:

> Under CONFIG_DISCONTIGMEM, assuming that a !pfn_valid() implies all
> subsequent pfn-s are also invalid is wrong. Thus replace this by
> explicitly checking against the E820 map.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
> 
> --- linux-2.6.21-rc5/drivers/char/agp/amd64-agp.c	2007-03-26 15:20:14.000000000 +0200
> +++ 2.6.21-rc5-amd64-agp/drivers/char/agp/amd64-agp.c	2007-03-28 15:20:49.000000000 +0200
> @@ -14,6 +14,7 @@
>  #include <linux/agp_backend.h>
>  #include <linux/mmzone.h>
>  #include <asm/page.h>		/* PAGE_SIZE */
> +#include <asm/e820.h>
>  #include <asm/k8.h>
>  #include "agp.h"
>  
> @@ -259,7 +260,6 @@ static const struct agp_bridge_driver am
>  /* Some basic sanity checks for the aperture. */
>  static int __devinit aperture_valid(u64 aper, u32 size)
>  {
> -	u32 pfn, c;
>  	if (aper == 0) {
>  		printk(KERN_ERR PFX "No aperture\n");
>  		return 0;
> @@ -272,14 +272,9 @@ static int __devinit aperture_valid(u64 
>  		printk(KERN_ERR PFX "Aperture out of bounds\n");
>  		return 0;
>  	}
> -	pfn = aper >> PAGE_SHIFT;
> -	for (c = 0; c < size/PAGE_SIZE; c++) {
> -		if (!pfn_valid(pfn + c))
> -			break;
> -		if (!PageReserved(pfn_to_page(pfn + c))) {
> -			printk(KERN_ERR PFX "Aperture pointing to RAM\n");
> -			return 0;
> -		}
> +	if (e820_any_mapped(aper, aper + size, E820_RAM)) {
> +		printk(KERN_ERR PFX "Aperture pointing to RAM\n");
> +		return 0;
>  	}

This pretty much duplicates the checking done in
arch/x86-64/kernel/aperture.c:aperture_valid(), with slight variations
(e.g., 32MB vs. 64MB aperture size). Should these two functions be
consolidated?

Cheers,
Muli
