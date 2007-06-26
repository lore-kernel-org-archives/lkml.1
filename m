Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbXFZFIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbXFZFIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 01:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbXFZFII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 01:08:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271AbXFZFIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 01:08:04 -0400
Date: Mon, 25 Jun 2007 22:07:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH] fix section mismatch in chipsfb
Message-Id: <20070625220752.4b4104f3.akpm@linux-foundation.org>
In-Reply-To: <20070619221528.GA22413@aepfle.de>
References: <20070619221528.GA22413@aepfle.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007 00:15:28 +0200 Olaf Hering <olaf@aepfle.de> wrote:

> Maybe this is the correct fix:
> 
> WARNING: drivers/built-in.o(.text+0x8742a): Section mismatch: reference to .init.data:chipsfb_fix (between 'chipsfb_pci_init' and 'chipsfb_set_par')
> WARNING: drivers/built-in.o(.text+0x87432): Section mismatch: reference to .init.data:chipsfb_fix (between 'chipsfb_pci_init' and 'chipsfb_set_par')
> WARNING: drivers/built-in.o(.text+0x87442): Section mismatch: reference to .init.data:chipsfb_var (between 'chipsfb_pci_init' and 'chipsfb_set_par')
> WARNING: drivers/built-in.o(.text+0x8744a): Section mismatch: reference to .init.data:chipsfb_var (between 'chipsfb_pci_init' and 'chipsfb_set_par')
> 
> init_chips is only called from chipsfb_pci_init
> chipsfb_fix and chipsfb_var are only referenced from init_chips
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> --- a/drivers/video/chipsfb.c
> +++ b/drivers/video/chipsfb.c
> @@ -292,7 +292,7 @@ static void __init chips_hw_init(void)
>  		write_fr(chips_init_fr[i].addr, chips_init_fr[i].data);
>  }
>  
> -static struct fb_fix_screeninfo chipsfb_fix __initdata = {
> +static struct fb_fix_screeninfo chipsfb_fix __devinitdata = {
>  	.id =		"C&T 65550",
>  	.type =		FB_TYPE_PACKED_PIXELS,
>  	.visual =	FB_VISUAL_PSEUDOCOLOR,
> @@ -309,7 +309,7 @@ static struct fb_fix_screeninfo chipsfb_
>  	.smem_len =	0x100000,	/* 1MB */
>  };
>  
> -static struct fb_var_screeninfo chipsfb_var __initdata = {
> +static struct fb_var_screeninfo chipsfb_var __devinitdata = {
>  	.xres = 800,
>  	.yres = 600,
>  	.xres_virtual = 800,
> @@ -330,7 +330,7 @@ static struct fb_var_screeninfo chipsfb_
>  	.vsync_len = 8,
>  };
>  
> -static void __init init_chips(struct fb_info *p, unsigned long addr)
> +static void __devinit init_chips(struct fb_info *p, unsigned long addr)
>  {
>  	memset(p->screen_base, 0, 0x100000);
>  

It looks like the correct fix to me.
