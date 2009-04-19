Return-Path: <linux-kernel-owner+w=401wt.eu-S1760227AbZDSGQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbZDSGQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 02:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbZDSGPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 02:15:51 -0400
Received: from kroah.org ([198.145.64.141]:58278 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754802AbZDSGPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 02:15:50 -0400
Date: Sat, 18 Apr 2009 22:38:51 -0700
From: Greg KH <greg@kroah.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org, John W Linville <linville@tuxdriver.com>,
       bernhard@schiffner-limbach.de
Subject: Re: [PATCH] rtl8187se staging: Fix compilation warnings and procfs
	directory leak
Message-ID: <20090419053851.GA25290@kroah.com>
References: <49ea87c4.jfXxKzrtSmTK5/lF%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ea87c4.jfXxKzrtSmTK5/lF%Larry.Finger@lwfinger.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 09:09:08PM -0500, Larry Finger wrote:
> Fix some warnings during compilation and correct a programming error
> that was leaking a directory in /proc.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Tested-by: Bernhard Schiffner <bernhard@schiffner-limbach.de>
> ---
> 
> Greg,
> 
> Please incorporate this patch in wireless/staging as soon as is possible.
> I'm not sure what the rules are concerning such changes.

I take stuff through my staging tree, it has nothing to do with the
wireless tree.

> I have a number of patches that clean up the vendor code; however, I think
> I will hold them for the moment as they do not change the function of this
> driver and only improve the readability.

Why wait?

> I am now working on porting this driver to use mac80211 so that it may be
> included in mainline.

That's great!

A few questions:

> --- linux-2.6.orig/drivers/staging/rtl8187se/r8180.h
> +++ linux-2.6/drivers/staging/rtl8187se/r8180.h
> @@ -19,7 +19,7 @@
>  #define R8180H
>  
>  
> -#define RTL8180_MODULE_NAME "rtl8180"
> +#define RTL8180_MODULE_NAME "r8180"

Why change the name?

> --- linux-2.6.orig/drivers/staging/rtl8187se/r8180_core.c
> +++ linux-2.6/drivers/staging/rtl8187se/r8180_core.c
> @@ -640,11 +640,9 @@ void rtl8180_proc_init_one(struct net_de
>  {
>  	struct proc_dir_entry *e;
>  	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
> -	priv->dir_dev = create_proc_entry(dev->name,
> -					  S_IFDIR | S_IRUGO | S_IXUGO,
> -					  rtl8180_proc);
> +	priv->dir_dev = rtl8180_proc;
>  	if (!priv->dir_dev) {
> -		DMESGE("Unable to initialize /proc/net/rtl8180/%s\n",
> +		DMESGE("Unable to initialize /proc/net/r8180/%s\n",
>  		      dev->name);
>  		return;
>  	}

So put the files in the root proc dir?

> @@ -1736,17 +1727,7 @@ short alloc_tx_desc_ring(struct net_devi
>  		 * descriptor's buffer must be 256 byte aligned
>  		 * we shouldn't be here, since we set DMA mask !
>  		 */
> -		DMESGW("Fixing TX alignment");
> -		desc = (u32*)((u8*)desc + 256);
> -#if (defined(CONFIG_HIGHMEM64G) || defined(CONFIG_64BIT_PHYS_ADDR))
> -		desc = (u32*)((u64)desc &~ 0xff);
> -		dma_desc = (dma_addr_t)((u8*)dma_desc + 256);
> -		dma_desc = (dma_addr_t)((u64)dma_desc &~ 0xff);
> -#else
> -		desc = (u32*)((u32)desc &~ 0xff);
> -		dma_desc = (dma_addr_t)((u8*)dma_desc + 256);
> -		dma_desc = (dma_addr_t)((u32)dma_desc &~ 0xff);
> -#endif
> +		WARN(1, "DMA buffer is not aligned\n");
>  	}
>  	tmp=desc;
>  	for (i=0;i<count;i++)

What replaces this logic?  Is it not needed anymore?

thanks,

greg k-h
