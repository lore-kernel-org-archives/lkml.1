Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906Ab0AMB1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0AMB1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839Ab0AMB1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:27:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753105Ab0AMB1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:27:33 -0500
Date: Tue, 12 Jan 2010 17:26:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chandru <chandru@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, stable@kernel.org
Subject: Re: [PATCH] ibmphp : read the length of ebda and map entire ebda
 region
Message-Id: <20100112172640.954027aa.akpm@linux-foundation.org>
In-Reply-To: <201001091712.25655.chandru@in.ibm.com>
References: <201001091712.25655.chandru@in.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jan 2010 17:12:25 +0530
Chandru <chandru@in.ibm.com> wrote:

> ibmphp driver currently maps only 1KB of ebda memory area into kernel address 
> space during driver initialization. This causes kernel oops when the driver is 
> modprobe'd and it accesses memory area beyond 1KB within ebda segment. The first 
> byte of ebda segment actually stores the length of the ebda region in 
> Kilobytes. Hence make use of the length parameter and map the entire ebda 
> region.
> 
> 
> Signed-off-by: Chandru Siddalingappa <chandru@linux.vnet.ibm.com>
> ---
> 
>  drivers/pci/hotplug/ibmphp_ebda.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.33-rc2/drivers/pci/hotplug/ibmphp_ebda.c.orig	2010-01-09 
> 15:23:54.000000000 +0530
> +++ linux-2.6.33-rc2/drivers/pci/hotplug/ibmphp_ebda.c	2010-01-09 
> 17:01:06.000000000 +0530
> @@ -245,7 +245,7 @@ static void __init print_ebda_hpc (void)
>  
>  int __init ibmphp_access_ebda (void)
>  {
> -	u8 format, num_ctlrs, rio_complete, hs_complete;
> +	u8 format, num_ctlrs, rio_complete, hs_complete, ebda_sz;
>  	u16 ebda_seg, num_entries, next_offset, offset, blk_id, sub_addr, re, rc_id, 
> re_id, base;

Your email client is performing wordwrapping on the patches.

>  	int rc = 0;
>  
> @@ -260,7 +260,14 @@ int __init ibmphp_access_ebda (void)
>  	iounmap (io_mem);
>  	debug ("returned ebda segment: %x\n", ebda_seg);
>  	
> -	io_mem = ioremap(ebda_seg<<4, 1024);
> +	io_mem = ioremap(ebda_seg<<4, 1);
> +	ebda_sz = readb(io_mem);
> +	iounmap(io_mem);

All the other ioremap() calls are checked for failure, so this one
should also be checked, no?

--- a/drivers/pci/hotplug/ibmphp_ebda.c~ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix
+++ a/drivers/pci/hotplug/ibmphp_ebda.c
@@ -261,6 +261,8 @@ int __init ibmphp_access_ebda (void)
 	debug ("returned ebda segment: %x\n", ebda_seg);
 	
 	io_mem = ioremap(ebda_seg<<4, 1);
+	if (!io_mem)
+		return -ENOMEM;
 	ebda_sz = readb(io_mem);
 	iounmap(io_mem);
 	debug("ebda size: %d(KiB)\n", ebda_sz);
_

> +	debug("ebda size: %d(KiB)\n", ebda_sz);
> +	if (ebda_sz == 0)
> +		return -ENOMEM;
> +
> +	io_mem = ioremap(ebda_seg<<4, (ebda_sz * 1024));

A kernel oops is somewhat serious.  Would I be correct in assuming that
this fix is needed in 2.6.32.x and perhaps earlier kernels?

