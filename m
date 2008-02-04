Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbYBDVMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbYBDVMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYBDVLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:11:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35532 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752772AbYBDVLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:11:51 -0500
Date: Mon, 4 Feb 2008 13:10:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2.6.24-mm1] error compiling net driver NE2000/NE1000
Message-Id: <20080204131038.699c28c1.akpm@linux-foundation.org>
In-Reply-To: <20080204162921.94984e72.pierre.peiffer@bull.net>
References: <20080204162921.94984e72.pierre.peiffer@bull.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 16:29:21 +0100
Pierre Peiffer <pierre.peiffer@bull.net> wrote:

> Hi,
> 
> 	When I compile the kernel 2.6.24-mm1 with:
> CONFIG_NET_ISA=y
> CONFIG_NE2000=y
> 
> I have the following compile error:
> ...
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `ne_block_output':
> linux-2.6.24-mm1/drivers/net/ne.c:797: undefined reference to `NS8390_init'
> drivers/built-in.o: In function `ne_drv_resume':
> linux-2.6.24-mm1/drivers/net/ne.c:858: undefined reference to `NS8390_init'
> drivers/built-in.o: In function `ne_probe1':
> linux-2.6.24-mm1/drivers/net/ne.c:539: undefined reference to `NS8390_init'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [sub-make] Error 2

Thanks for reporting this.

> As I saw that the file 8390p.c is compiled for this driver, but not the file 
> 8390.c which contains this function NS8390_init(), I fixed this error with
> the following patch.

Alan's
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
would be a prime suspect.  I assume this bug isn't present ing mainline or
in 2.6.24?

> As NS8390p_init() does the same thing than NS8390_init(), I suppose that this is the right fix ?
> 
> Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
> ---
>  drivers/net/ne.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: b/drivers/net/ne.c
> ===================================================================
> --- a/drivers/net/ne.c
> +++ b/drivers/net/ne.c
> @@ -536,7 +536,7 @@ static int __init ne_probe1(struct net_d
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	dev->poll_controller = eip_poll;
>  #endif
> -	NS8390_init(dev, 0);
> +	NS8390p_init(dev, 0);
>  
>  	ret = register_netdev(dev);
>  	if (ret)
> @@ -794,7 +794,7 @@ retry:
>  		if (time_after(jiffies, dma_start + 2*HZ/100)) {		/* 20ms */
>  			printk(KERN_WARNING "%s: timeout waiting for Tx RDC.\n", dev->name);
>  			ne_reset_8390(dev);
> -			NS8390_init(dev,1);
> +			NS8390p_init(dev,1);
>  			break;
>  		}
>  
> @@ -855,7 +855,7 @@ static int ne_drv_resume(struct platform
>  
>  	if (netif_running(dev)) {
>  		ne_reset_8390(dev);
> -		NS8390_init(dev, 1);
> +		NS8390p_init(dev, 1);
>  		netif_device_attach(dev);
>  	}
>  	return 0;


