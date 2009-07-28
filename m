Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbZG1WTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbZG1WTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbZG1WTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:19:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755574AbZG1WTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:19:34 -0400
Date: Tue, 28 Jul 2009 15:19:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: airlied@redhat.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH linux-next] agp: correct missing cleanup on error in
 agp_add_bridge
Message-Id: <20090728151918.9b1a793e.akpm@linux-foundation.org>
In-Reply-To: <4A6BB1A1.50308@gmail.com>
References: <4A6BB1A1.50308@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jul 2009 22:30:09 -0300
Kevin Winchester <kjwinchester@gmail.com> wrote:

> 
> While investigating a kmemleak detected leak, I encountered the
> agp_add_bridge function.  It appears to be responsible for freeing
> the agp_bridge_data in the case of a failure, but it is only doing
> so for some errors.
> 
> Fix it to always free the bridge data if a failure condition is
> encountered.
> 
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> ---
> 
> Note that this seems like a reasonable change to me, but this patch
> did not get rid of the kmemleak report, so I don't even have that as
> evidence of its correctness.  Please review.
> 
> diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
> index cfa5a64..aebd82c 100644
> --- a/drivers/char/agp/backend.c
> +++ b/drivers/char/agp/backend.c
> @@ -263,18 +263,22 @@ int agp_add_bridge(struct agp_bridge_data *bridge)
>  {
>         int error;
>  
> -       if (agp_off)
> -               return -ENODEV;
> +       if (agp_off) {
> +               error = -ENODEV;
> +               goto err_put_bridge;
> +       }
>  
>         if (!bridge->dev) {
>                 printk (KERN_DEBUG PFX "Erk, registering with no pci_dev!\n");
> -               return -EINVAL;
> +               error = -EINVAL;
> +               goto err_put_bridge;
>         }
>  
>         /* Grab reference on the chipset driver. */
>         if (!try_module_get(bridge->driver->owner)) {
>                 dev_info(&bridge->dev->dev, "can't lock chipset driver\n");
> -               return -EINVAL;
> +               error = -EINVAL;
> +               goto err_put_bridge;
>         }
>  
>         error = agp_backend_initialize(bridge);
> @@ -304,6 +308,7 @@ frontend_err:
>         agp_backend_cleanup(bridge);
>  err_out:
>         module_put(bridge->driver->owner);
> +err_put_bridge:
>         agp_put_bridge(bridge);
>         return error;
>  }

Looks right to me.

The code is ill-designed.  The callee (agp_add_bridge) should not be
freeing things which the caller allocated.  Because the callee
shouldn't assume that the caller will no longer use the data and the
callee shouldn't assume that the caller allocated the memory via
kmalloc().  Callers of agp_add_bridge() should be doing the
agp_put_bridge().

Your email client replaced all the tabs with spaces.  I fixed that up.
