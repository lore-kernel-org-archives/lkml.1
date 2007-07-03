Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbXGCXbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbXGCXbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 19:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbXGCXbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 19:31:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35342 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017AbXGCXbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 19:31:38 -0400
Date: Tue, 3 Jul 2007 16:31:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de,
       "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH 2.6.21 3/3] x86_64 EFI64 support Try #2
Message-Id: <20070703163125.21114ad2.akpm@linux-foundation.org>
In-Reply-To: <20070702170708.062695000@em64tdvp.jf.intel.com>
References: <20070702170614.769378000@em64tdvp.jf.intel.com>
	<20070702170708.062695000@em64tdvp.jf.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jul 2007 10:06:17 -0700
Chandramouli Narayanan <mouli@linux.intel.com> wrote:

> EFI x86_64 support Patch 3 of 3 (try #2)
> ----------------------------------------
> - Fixed redundant check in efifb_init().
> 
> This patch depends on the EFI x86_64 patches 1/3 and 2/3.
> 
> This patch adds Graphics Output Protocol support to the kernel.
> x86_64 systems with UEFI2.0 firmware conform to UEFI 2.0 specification.
> UEFI2.0 spec deprecates Universal Graphics Adapter (UGA) protocol and
> only Graphics Output Protocol (GOP) is produced. Therefore, the boot loader
> needs to query the UEFI firmware with appropriate Output Protocol and
> pass the video information to the kernel. As a result of GOP
> protocol, an EFI framebuffer driver is needed for displaying console messages.
> Patch 3 of 3 adds a EFI framebuffer driver. The EFI frame buffer driver in this
> patch is based on the Intel Mac framebuffer driver.
> 
> The x86_64 ELILO bootloader takes care of passing the video information
> as appropriate for EFI firmware. 
> 

That's more like a changelog.

Please cc linux-fbdev-devel@lists.sourceforge.net and "Antonino A.  Daplas"
<adaplas@pol.net> on framebuffer driver patches.

>  
> +config FB_EFI
> +	bool "EFI-based Framebuffer Support"
> +	depends on (FB = y) && X86 && EFI

So this is selectable on i386 as well.  Has it been tested there?

> +	select FB_CFB_FILLRECT
> +	select FB_CFB_COPYAREA
> +	select FB_CFB_IMAGEBLIT
> +	help
> +	  This is the EFI frame buffer device driver. If the firmware on
> +	  your platform is UEFI2.0, select Y to add support for
> +	  Graphics Output Protocol for early console messages to appear.
> +
>  config FB_IMAC
>  	bool "Intel-based Macintosh Framebuffer Support"
>  	depends on (FB = y) && X86 && EFI
>
> ...
>
> --- linux-2.6.21-orig/drivers/video/efifb.c	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.21-uefi-finaltest4/drivers/video/efifb.c	2007-06-12 16:16:12.000000000 -0700
> @@ -0,0 +1,249 @@
> +/*
> + * framebuffer driver for Intel Based Mac's
> + *
> + * (c) 2006 Edgar Hucek <gimli@dark-green.com>
> + * Original efi driver written by Gerd Knorr <kraxel@goldbach.in-berlin.de>
> + *
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/fb.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/ioport.h>
> +#include <linux/mm.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/screen_info.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/dmi.h>
> +#include <linux/efi.h>
> +
> +#include <asm/io.h>

checkpatch.pl will save me work.

> +#ifndef __i386__
> +	//screen_info.imacpm_seg = 0;
> +#endif

hmm.

> +
> +	if (!request_mem_region(efifb_fix.smem_start, size_total, "efifb")) {
> +		printk(KERN_WARNING
> +		       "efifb: cannot reserve video memory at 0x%lx\n",
> +			efifb_fix.smem_start);

KERN_ERR?


