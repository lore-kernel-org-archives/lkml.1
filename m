Return-Path: <linux-kernel-owner+w=401wt.eu-S1760411AbXEQTWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbXEQTWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbXEQTWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:22:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60900 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754437AbXEQTWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:22:31 -0400
Date: Thu, 17 May 2007 12:19:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>
Subject: Re: [PATCH] fix kmalloc(0) in arch/ia64/pci/pci.c
Message-Id: <20070517121959.b1b374fa.akpm@linux-foundation.org>
In-Reply-To: <20070517110056.779944a2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070517110056.779944a2.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 11:00:56 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Fix following kmalloc(0) message. patch is agaisnt 2.6.22-rc1-mm1.
> 
> ==
> BUG: at mm/slab.c:792 __find_general_cachep()
> 
> Call Trace:
>  [<a000000100013f20>] show_stack+0x40/0xa0
>                                 sp=e000014042227b00 bsp=e000014042220f90
>  [<a000000100013fb0>] dump_stack+0x30/0x60
>                                 sp=e000014042227cd0 bsp=e000014042220f78
>  [<a00000010014fe10>] kmem_find_general_cachep+0x90/0x140
>                                 sp=e000014042227cd0 bsp=e000014042220f48
>  [<a0000001001504f0>] __kmalloc_node+0x30/0xa0
>                                 sp=e000014042227cd0 bsp=e000014042220f18
>  [<a0000001004eb700>] pci_acpi_scan_root+0x180/0x4a0
>                                 sp=e000014042227cd0 bsp=e000014042220ed0
>  [<a000000100361140>] acpi_pci_root_add+0x4e0/0x700
>                                 sp=e000014042227cf0 bsp=e000014042220e90
>  [<a00000010035b240>] acpi_device_probe+0xa0/0x160
>                                 sp=e000014042227d10 bsp=e000014042220e58
>  [<a0000001003e4550>] driver_probe_device+0x250/0x380
>                                 sp=e000014042227d10 bsp=e000014042220e18
>  [<a0000001003e4900>] __driver_attach+0xc0/0x160
>                                 sp=e000014042227d10 bsp=e000014042220de0
>  [<a0000001003e2980>] bus_for_each_dev+0x80/0x100
>                                 sp=e000014042227d10 bsp=e000014042220da8
>  [<a0000001003e4120>] driver_attach+0x40/0x60
>                                 sp=e000014042227d30 bsp=e000014042220d88
>  [<a0000001003e3170>] bus_add_driver+0xf0/0x3c0
>                                 sp=e000014042227d30 bsp=e000014042220d48
>  [<a0000001003e4e00>] driver_register+0x140/0x160
>                                 sp=e000014042227d30 bsp=e000014042220d28
>  [<a00000010035ded0>] acpi_bus_register_driver+0x50/0x80
>                                 sp=e000014042227d30 bsp=e000014042220d08
>  [<a0000001007d6000>] acpi_pci_root_init+0x20/0x60
>                                 sp=e000014042227d30 bsp=e000014042220cf0
>  [<a0000001007a46b0>] kernel_init+0x450/0x7c0
>                                 sp=e000014042227d30 bsp=e000014042220ca8
>  [<a000000100012550>] kernel_thread_helper+0x30/0x60
>                                 sp=e000014042227e30 bsp=e000014042220c80
>  [<a0000001000090c0>] start_kernel_thread+0x20/0x40
>                                 sp=e000014042227e30 bsp=e000014042220c80
> ==
> 
> Fix kmalloc(0)
> 
> Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Index: linux-2.6.22-rc1-mm1/arch/ia64/pci/pci.c
> ===================================================================
> --- linux-2.6.22-rc1-mm1.orig/arch/ia64/pci/pci.c
> +++ linux-2.6.22-rc1-mm1/arch/ia64/pci/pci.c
> @@ -354,6 +354,8 @@ pci_acpi_scan_root(struct acpi_device *d
>  
>  	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_window,
>  			&windows);
> +	if (!windows)
> +		goto out2;
>  	controller->window = kmalloc_node(sizeof(*controller->window) * windows,
>  			GFP_KERNEL, controller->node);
>  	if (!controller->window)
> 

This is a significant change in functionality.  Can you please explain why
it doesn't break things?

