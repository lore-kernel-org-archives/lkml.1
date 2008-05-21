Return-Path: <linux-kernel-owner+w=401wt.eu-S934907AbYEUGqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934907AbYEUGqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 02:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbYEUGpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 02:45:51 -0400
Received: from wm26.inbox.com ([64.135.83.26]:4883 "HELO WM26.inbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756377AbYEUGpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 02:45:51 -0400
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2008 02:45:51 EDT
Mime-Version: 1.0
Date: Tue, 20 May 2008 22:35:37 -0800
Message-ID: <8E0F58A2820.00000313zw@zh-kernel.org>
From: Zhang Wei <zw@zh-kernel.org>
Subject: RE: [PATCH] fsldma: fix incorrect exit path for initialization
To: Li Yang <leoli@freescale.com>, dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1211351459-32355-1-git-send-email-leoli@freescale.com>
X-Mailer: INBOX.COM
X-Originating-IP: 65.113.40.1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-IWM-ACU: tX17z_7ICMsuYVkBp8AESeb5FnBv14XJRTUXoY3rKsvlAUwQ1Prq7mpbazYU
  Vj87T3EvPOu3MNVmJhberZQXO06-CWZGPbbOdgEKIPxL9L5JrWVryeXaxLP5
  SYLon8yaQNV3adY4@
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: leoli@freescale.com
> 
> Signed-off-by: Li Yang <leoli@freescale.com>
> Cc: Zhang Wei <zw@zh-kernel.org>

Acked-by: Zhang Wei <zw@zh-kernel.org>

> ---
>  drivers/dma/fsldma.c |   31 ++++++++++++++++---------------
>  1 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 054eabf..724f6fd 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -809,8 +809,7 @@ static int fsl_dma_self_test(struct fsl_dma_chan
> *fsl_chan)
>  	if (!src) {
>  		dev_err(fsl_chan->dev,
>  				"selftest: Cannot alloc memory for test!\n");
> -		err = -ENOMEM;
> -		goto out;
> +		return -ENOMEM;
>  	}
> 
>  	dest = src + test_size;
> @@ -842,7 +841,7 @@ static int fsl_dma_self_test(struct fsl_dma_chan
> *fsl_chan)
>  	if (fsl_dma_is_complete(chan, cookie, NULL, NULL) != DMA_SUCCESS) {
>  		dev_err(fsl_chan->dev, "selftest: Time out!\n");
>  		err = -ENODEV;
> -		goto out;
> +		goto free_resources;
>  	}
> 
>  	/* Test free and re-alloc channel resources */
> @@ -927,8 +926,7 @@ static int __devinit of_fsl_dma_chan_probe(struct
> of_device *dev,
>  	if (!new_fsl_chan) {
>  		dev_err(&dev->dev, "No free memory for allocating "
>  				"dma channels!\n");
> -		err = -ENOMEM;
> -		goto err;
> +		return -ENOMEM;
>  	}
> 
>  	/* get dma channel register base */
> @@ -936,7 +934,7 @@ static int __devinit of_fsl_dma_chan_probe(struct
> of_device *dev,
>  	if (err) {
>  		dev_err(&dev->dev, "Can't get %s property 'reg'\n",
>  				dev->node->full_name);
> -		goto err;
> +		goto err_no_reg;
>  	}
> 
>  	new_fsl_chan->feature = *(u32 *)match->data;
> @@ -958,7 +956,7 @@ static int __devinit of_fsl_dma_chan_probe(struct
> of_device *dev,
>  		dev_err(&dev->dev, "There is no %d channel!\n",
>  				new_fsl_chan->id);
>  		err = -EINVAL;
> -		goto err;
> +		goto err_no_chan;
>  	}
>  	fdev->chan[new_fsl_chan->id] = new_fsl_chan;
>  	tasklet_init(&new_fsl_chan->tasklet, dma_do_tasklet,
> @@ -997,23 +995,26 @@ static int __devinit of_fsl_dma_chan_probe(struct
> of_device *dev,
>  		if (err) {
>  			dev_err(&dev->dev, "DMA channel %s request_irq error "
>  				"with return %d\n", dev->node->full_name, err);
> -			goto err;
> +			goto err_no_irq;
>  		}
>  	}
> 
>  	err = fsl_dma_self_test(new_fsl_chan);
>  	if (err)
> -		goto err;
> +		goto err_self_test;
> 
>  	dev_info(&dev->dev, "#%d (%s), irq %d\n", new_fsl_chan->id,
>  				match->compatible, new_fsl_chan->irq);
> 
>  	return 0;
> -err:
> -	dma_halt(new_fsl_chan);
> -	iounmap(new_fsl_chan->reg_base);
> +
> +err_self_test:
>  	free_irq(new_fsl_chan->irq, new_fsl_chan);
> +err_no_irq:
>  	list_del(&new_fsl_chan->common.device_node);
> +err_no_chan:
> +	iounmap(new_fsl_chan->reg_base);
> +err_no_reg:
>  	kfree(new_fsl_chan);
>  	return err;
>  }
> @@ -1054,8 +1055,7 @@ static int __devinit of_fsl_dma_probe(struct
> of_device *dev,
>  	fdev = kzalloc(sizeof(struct fsl_dma_device), GFP_KERNEL);
>  	if (!fdev) {
>  		dev_err(&dev->dev, "No enough memory for 'priv'\n");
> -		err = -ENOMEM;
> -		goto err;
> +		return -ENOMEM;
>  	}
>  	fdev->dev = &dev->dev;
>  	INIT_LIST_HEAD(&fdev->common.channels);
> @@ -1065,7 +1065,7 @@ static int __devinit of_fsl_dma_probe(struct
> of_device *dev,
>  	if (err) {
>  		dev_err(&dev->dev, "Can't get %s property 'reg'\n",
>  				dev->node->full_name);
> -		goto err;
> +		goto err_no_reg;
>  	}
> 
>  	dev_info(&dev->dev, "Probe the Freescale DMA driver for %s "
> @@ -1103,6 +1103,7 @@ static int __devinit of_fsl_dma_probe(struct
> of_device *dev,
> 
>  err:
>  	iounmap(fdev->reg_base);
> +err_no_reg:
>  	kfree(fdev);
>  	return err;
>  }
> --
> 1.5.5.1.248.g4b17

____________________________________________________________
FREE 3D MARINE AQUARIUM SCREENSAVER - Watch dolphins, sharks & orcas on your desktop!
Check it out at http://www.inbox.com/marineaquarium
