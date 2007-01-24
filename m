Return-Path: <linux-kernel-owner+w=401wt.eu-S1030231AbXAXIsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030231AbXAXIsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 03:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030232AbXAXIsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 03:48:41 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58076 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030231AbXAXIsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 03:48:40 -0500
Date: Wed, 24 Jan 2007 00:48:26 -0800
From: Andrew Morton <akpm@osdl.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: adaplas@pol.net, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: [PATCH] Recognize video=gx1fb:... option
Message-Id: <20070124004826.0d1adffe.akpm@osdl.org>
In-Reply-To: <20070119211051.GC5013@martell.zuzino.mipt.ru>
References: <20070119211051.GC5013@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jan 2007 00:10:51 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Juergen Beisert reported that the following option doesn't work for him
> 
> 	video=gx1fb:1024x768-16@60
> 
> though sisfb was able to parse similar option correctly.
> 

And does this patch fix it for him? ;)

> ---
> 
>  drivers/video/geode/gx1fb_core.c |   29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> --- a/drivers/video/geode/gx1fb_core.c
> +++ b/drivers/video/geode/gx1fb_core.c
> @@ -401,6 +401,30 @@ static void gx1fb_remove(struct pci_dev 
>  	framebuffer_release(info);
>  }
>  
> +#ifndef MODULE
> +static void __init gx1fb_setup(char *options)
> +{
> +	char *this_opt;
> +
> +	if (!options || !*options)
> +		return;
> +
> +	while ((this_opt = strsep(&options, ","))) {
> +		if (!*this_opt)
> +			continue;
> +
> +		if (!strncmp(this_opt, "mode:", 5))
> +			strlcpy(mode_option, this_opt + 5, sizeof(mode_option));
> +		else if (!strncmp(this_opt, "crt:", 4))
> +			crt_option = !!simple_strtoul(this_opt + 4, NULL, 0);
> +		else if (!strncmp(this_opt, "panel:", 6))
> +			strlcpy(panel_option, this_opt + 6, sizeof(panel_option));
> +		else
> +			strlcpy(mode_option, this_opt, sizeof(mode_option));
> +	}
> +}
> +#endif
> +
>  static struct pci_device_id gx1fb_id_table[] = {
>  	{ PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_VIDEO,
>  	  PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY << 16,
> @@ -420,8 +444,11 @@ static struct pci_driver gx1fb_driver = 
>  static int __init gx1fb_init(void)
>  {
>  #ifndef MODULE
> -	if (fb_get_options("gx1fb", NULL))
> +	char *option = NULL;
> +
> +	if (fb_get_options("gx1fb", &option))
>  		return -ENODEV;
> +	gx1fb_setup(option);
>  #endif
>  	return pci_register_driver(&gx1fb_driver);
>  }

Possibly this should go through Jordan's git-geode tree.  But that tree
seems to be kinda dead, so I'll file this under fbdev.

