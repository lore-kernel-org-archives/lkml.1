Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYCMWeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYCMWeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbYCMWdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:33:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754359AbYCMWdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:33:52 -0400
Date: Thu, 13 Mar 2008 15:32:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl,
       len.brown@intel.com, stable@kernel.org
Subject: Re: fix aperture vs. suspend problem
Message-Id: <20080313153248.f43bbce3.akpm@linux-foundation.org>
In-Reply-To: <20080313100531.GA3399@elf.ucw.cz>
References: <20080313100531.GA3399@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 11:05:31 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> 
> aperture_64.c takes a piece of memory and makes it into iommu
> window... but such window may not be saved by swsusp -- that leads to
> oops during suspend.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> index 608152a..88747f3 100644
> --- a/arch/x86/kernel/aperture_64.c
> +++ b/arch/x86/kernel/aperture_64.c
> @@ -18,6 +18,7 @@ #include <linux/pci_ids.h>
>  #include <linux/pci.h>
>  #include <linux/bitops.h>
>  #include <linux/ioport.h>
> +#include <linux/suspend.h>
>  #include <asm/e820.h>
>  #include <asm/io.h>
>  #include <asm/gart.h>
> @@ -76,6 +77,7 @@ static u32 __init allocate_aperture(void
>  	printk(KERN_INFO "Mapping aperture over %d KB of RAM @ %lx\n",
>  			aper_size >> 10, __pa(p));
>  	insert_aperture_resource((u32)__pa(p), aper_size);
> +	register_nosave_region((u32)__pa(p) >> PAGE_SHIFT, (u32)__pa(p+aper_size) >> PAGE_SHIFT);
>  
>  	return (u32)__pa(p);
>  }
> 

This is also needed in 2.6.24, perhaps earlier?
