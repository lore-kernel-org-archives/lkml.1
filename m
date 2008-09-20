Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYITVcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYITVcV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 17:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYITVcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 17:32:13 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:48471 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYITVcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 17:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=FzqQ6V5j2WW8hn0b58VhyyGi87qYrLQujVkrsLR2cl5/rCUPhKoevrMPAAe+Td+fqU
         v8dxgHstkUMikDJ5T1O9/f6XIGE/a2RhaVZaJMWfNC1RaVTLlBAfm9ea6nk3Gq5IzJmg
         9m/y9iygBcbcysZohRhvBQ8arXn89lbt7nKBo=
Message-ID: <e9c3a7c20809201432y31da1e00mf3a20c60b918fab1@mail.gmail.com>
Date: Sat, 20 Sep 2008 14:32:09 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Timur Tabi" <timur@freescale.com>
Subject: Re: [PATCH] fsl-dma: allow Freescale Elo DMA driver to be compiled as a module
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       leoli@freescale.com
In-Reply-To: <1221755059-27204-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221755059-27204-1-git-send-email-timur@freescale.com>
X-Google-Sender-Auth: 1a349135d712ce1b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ added Li Yang to the cc ]

On Thu, Sep 18, 2008 at 9:24 AM, Timur Tabi <timur@freescale.com> wrote:
> Modify the Freescale Elo / Elo Plus DMA driver so that it can be compiled as
> a module.
>
> The primary change is to stop treating the DMA controller as a bus, and the
> DMA channels as devices on the bus.  This is because the Open Firmware (OF)
> kernel code does not allow busses to be removed, so although we can call
> of_platform_bus_probe() to probe the DMA channels, there is no
> of_platform_bus_remove().  Therefore, the DMA channels must be manually probed.
>
> Signed-off-by: Timur Tabi <timur@freescale.com>

I am not familiar with the Open Firmware interface so I'll trust you
on that piece, but please see 2 comments below.

Thanks,
Dan

> ---
>
> This patch is for the 2.6.28 kernel.  This patch exposes a bug in the dmatest
> module, so my other patch "dmatest: properly handle duplicate DMA channels"
> should be applied if this patch is applied.
>
>  drivers/dma/Kconfig  |   10 ++--
>  drivers/dma/fsldma.c |  165 ++++++++++++++++++++++++++++++++++----------------
>  drivers/dma/fsldma.h |    2 +
>  3 files changed, 119 insertions(+), 58 deletions(-)
>
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index cd30390..9dfd502 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -48,13 +48,13 @@ config DW_DMAC
>          can be integrated in chips such as the Atmel AT32ap7000.
>
>  config FSL_DMA
> -       bool "Freescale MPC85xx/MPC83xx DMA support"
> -       depends on PPC
> +       tristate "Freescale Elo and Elo Plus DMA support"
> +       depends on PPC_83xx || PPC_85xx || PPC_86xx
>        select DMA_ENGINE
>        ---help---
> -         Enable support for the Freescale DMA engine. Now, it support
> -         MPC8560/40, MPC8555, MPC8548 and MPC8641 processors.
> -         The MPC8349, MPC8360 is also supported.
> +         Enable support for the Freescale Elo and Elo Plus DMA controllers.
> +         The Elo is the DMA controller on 83xx parts, and the Elo Plus is
> +         the DMA controller on 85xx and 86xx parts.
>
>  config MV_XOR
>        bool "Marvell XOR engine support"
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index c0059ca..327c485 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -372,6 +372,10 @@ static int fsl_dma_alloc_chan_resources(struct dma_chan *chan,
>        struct fsl_dma_chan *fsl_chan = to_fsl_chan(chan);
>        LIST_HEAD(tmp_list);
>
> +       /* Has this channel already been allocated? */
> +       if (fsl_chan->desc_pool)
> +               return 1;
> +
>        /* We need the descriptor to be aligned to 32bytes
>         * for meeting FSL DMA specification requirement.
>         */
> @@ -381,7 +385,7 @@ static int fsl_dma_alloc_chan_resources(struct dma_chan *chan,
>        if (!fsl_chan->desc_pool) {
>                dev_err(fsl_chan->dev, "No memory for channel %d "
>                        "descriptor dma pool.\n", fsl_chan->id);
> -               return 0;
> +               return -ENOMEM;
>        }

The last three hunks should be broken out into a separate 'fix' patch
with its own changelog.

>
>        return 1;
> @@ -410,6 +414,8 @@ static void fsl_dma_free_chan_resources(struct dma_chan *chan)
>        }
>        spin_unlock_irqrestore(&fsl_chan->desc_lock, flags);
>        dma_pool_destroy(fsl_chan->desc_pool);
> +
> +       fsl_chan->desc_pool = NULL;
>  }
>
>  static struct dma_async_tx_descriptor *
> @@ -912,33 +918,37 @@ out:
>        return err;
>  }
>
> -static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
> -                       const struct of_device_id *match)
> +static int __devinit fsl_dma_chan_probe(struct fsl_dma_device *fdev,
> +       struct device_node *node, u32 feature, const char *compatible)
>  {
> -       struct fsl_dma_device *fdev;
>        struct fsl_dma_chan *new_fsl_chan;
> +       const u32 *iprop;
>        int err;
>
> -       fdev = dev_get_drvdata(dev->dev.parent);
> -       BUG_ON(!fdev);
> -
>        /* alloc channel */
>        new_fsl_chan = kzalloc(sizeof(struct fsl_dma_chan), GFP_KERNEL);
>        if (!new_fsl_chan) {
> -               dev_err(&dev->dev, "No free memory for allocating "
> +               dev_err(fdev->dev, "No free memory for allocating "
>                                "dma channels!\n");
>                return -ENOMEM;
>        }
>
> +       new_fsl_chan->of_dev = of_platform_device_create(node, NULL, fdev->dev);
> +       if (!new_fsl_chan->of_dev) {
> +               dev_err(fdev->dev, "cannot create platform device\n");
> +               err = -EINVAL;
> +               goto err_no_dev;
> +       }
> +
>        /* get dma channel register base */
> -       err = of_address_to_resource(dev->node, 0, &new_fsl_chan->reg);
> +       err = of_address_to_resource(node, 0, &new_fsl_chan->reg);
>        if (err) {
> -               dev_err(&dev->dev, "Can't get %s property 'reg'\n",
> -                               dev->node->full_name);
> +               dev_err(fdev->dev, "Can't get %s property 'reg'\n",
> +                               node->full_name);
>                goto err_no_reg;
>        }
>
> -       new_fsl_chan->feature = *(u32 *)match->data;
> +       new_fsl_chan->feature = feature;
>
>        if (!fdev->feature)
>                fdev->feature = new_fsl_chan->feature;
> @@ -948,17 +958,22 @@ static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
>         */
>        WARN_ON(fdev->feature != new_fsl_chan->feature);
>
> -       new_fsl_chan->dev = &dev->dev;
> +       new_fsl_chan->dev = &new_fsl_chan->of_dev->dev;
>        new_fsl_chan->reg_base = ioremap(new_fsl_chan->reg.start,
>                        new_fsl_chan->reg.end - new_fsl_chan->reg.start + 1);
>
> -       new_fsl_chan->id = ((new_fsl_chan->reg.start - 0x100) & 0xfff) >> 7;
> -       if (new_fsl_chan->id > FSL_DMA_MAX_CHANS_PER_DEVICE) {
> -               dev_err(&dev->dev, "There is no %d channel!\n",
> -                               new_fsl_chan->id);
> +       iprop = of_get_property(node, "cell-index", NULL);
> +       if (!iprop) {
> +               dev_err(fdev->dev, "missing cell-index property\n");
> +               return -EINVAL;
> +       }
> +       if (*iprop >= FSL_DMA_MAX_CHANS_PER_DEVICE) {
> +               dev_err(fdev->dev, "invalid cell-index value %u\n", *iprop);
>                err = -EINVAL;
>                goto err_no_chan;
>        }
> +       new_fsl_chan->id = *iprop;
> +
>        fdev->chan[new_fsl_chan->id] = new_fsl_chan;
>        tasklet_init(&new_fsl_chan->tasklet, dma_do_tasklet,
>                        (unsigned long)new_fsl_chan);
> @@ -988,14 +1003,14 @@ static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
>                        &fdev->common.channels);
>        fdev->common.chancnt++;
>
> -       new_fsl_chan->irq = irq_of_parse_and_map(dev->node, 0);
> +       new_fsl_chan->irq = irq_of_parse_and_map(node, 0);
>        if (new_fsl_chan->irq != NO_IRQ) {
>                err = request_irq(new_fsl_chan->irq,
>                                        &fsl_dma_chan_do_interrupt, IRQF_SHARED,
>                                        "fsldma-channel", new_fsl_chan);
>                if (err) {
> -                       dev_err(&dev->dev, "DMA channel %s request_irq error "
> -                               "with return %d\n", dev->node->full_name, err);
> +                       dev_err(fdev->dev, "DMA channel %s request_irq error "
> +                               "with return %d\n", node->full_name, err);
>                        goto err_no_irq;
>                }
>        }
> @@ -1004,8 +1019,8 @@ static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
>        if (err)
>                goto err_self_test;
>
> -       dev_info(&dev->dev, "#%d (%s), irq %d\n", new_fsl_chan->id,
> -                               match->compatible, new_fsl_chan->irq);
> +       dev_info(fdev->dev, "#%d (%s), irq %d\n", new_fsl_chan->id,
> +                               compatible, new_fsl_chan->irq);
>
>        return 0;
>
> @@ -1016,42 +1031,30 @@ err_no_irq:
>  err_no_chan:
>        iounmap(new_fsl_chan->reg_base);
>  err_no_reg:
> +       of_device_unregister(new_fsl_chan->of_dev);
> +err_no_dev:
>        kfree(new_fsl_chan);
>        return err;
>  }
>
> -const u32 mpc8540_dma_ip_feature = FSL_DMA_IP_85XX | FSL_DMA_BIG_ENDIAN;
> -const u32 mpc8349_dma_ip_feature = FSL_DMA_IP_83XX | FSL_DMA_LITTLE_ENDIAN;
> -
> -static struct of_device_id of_fsl_dma_chan_ids[] = {
> -       {
> -               .compatible = "fsl,eloplus-dma-channel",
> -               .data = (void *)&mpc8540_dma_ip_feature,
> -       },
> -       {
> -               .compatible = "fsl,elo-dma-channel",
> -               .data = (void *)&mpc8349_dma_ip_feature,
> -       },
> -       {}
> -};
> -
> -static struct of_platform_driver of_fsl_dma_chan_driver = {
> -       .name = "of-fsl-dma-channel",
> -       .match_table = of_fsl_dma_chan_ids,
> -       .probe = of_fsl_dma_chan_probe,
> -};
> -
> -static __init int of_fsl_dma_chan_init(void)
> +static void fsl_dma_chan_remove(struct fsl_dma_chan *fchan)
>  {
> -       return of_register_platform_driver(&of_fsl_dma_chan_driver);
> +       if (fchan) {
> +               of_device_unregister(fchan->of_dev);
> +
> +               free_irq(fchan->irq, fchan);
> +               list_del(&fchan->common.device_node);
> +               iounmap(fchan->reg_base);
> +               kfree(fchan);
> +       }
>  }

removing a NULL fchan should be an error right?  Perhaps move the
check up to of_fsl_dma_remove().

>
>  static int __devinit of_fsl_dma_probe(struct of_device *dev,
>                        const struct of_device_id *match)
>  {
>        int err;
> -       unsigned int irq;
>        struct fsl_dma_device *fdev;
> +       struct device_node *child;
>
>        fdev = kzalloc(sizeof(struct fsl_dma_device), GFP_KERNEL);
>        if (!fdev) {
> @@ -1085,9 +1088,9 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
>        fdev->common.device_issue_pending = fsl_dma_memcpy_issue_pending;
>        fdev->common.dev = &dev->dev;
>
> -       irq = irq_of_parse_and_map(dev->node, 0);
> -       if (irq != NO_IRQ) {
> -               err = request_irq(irq, &fsl_dma_do_interrupt, IRQF_SHARED,
> +       fdev->irq = irq_of_parse_and_map(dev->node, 0);
> +       if (fdev->irq != NO_IRQ) {
> +               err = request_irq(fdev->irq, &fsl_dma_do_interrupt, IRQF_SHARED,
>                                        "fsldma-device", fdev);
>                if (err) {
>                        dev_err(&dev->dev, "DMA device request_irq error "
> @@ -1097,7 +1100,21 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
>        }
>
>        dev_set_drvdata(&(dev->dev), fdev);
> -       of_platform_bus_probe(dev->node, of_fsl_dma_chan_ids, &dev->dev);
> +
> +       /* We cannot use of_platform_bus_probe() because there is no
> +        * of_platform_bus_remove.  We have to manually instantiate every DMA
> +        * channel object.
> +        */
> +       for_each_child_of_node(dev->node, child) {
> +               if (of_device_is_compatible(child, "fsl,eloplus-dma-channel"))
> +                       fsl_dma_chan_probe(fdev, child,
> +                               FSL_DMA_IP_85XX | FSL_DMA_BIG_ENDIAN,
> +                               "fsl,eloplus-dma-channel");
> +               if (of_device_is_compatible(child, "fsl,elo-dma-channel"))
> +                       fsl_dma_chan_probe(fdev, child,
> +                               FSL_DMA_IP_83XX | FSL_DMA_LITTLE_ENDIAN,
> +                               "fsl,elo-dma-channel");
> +       }
>
>        dma_async_device_register(&fdev->common);
>        return 0;
> @@ -1109,6 +1126,31 @@ err_no_reg:
>        return err;
>  }
>
> +static int of_fsl_dma_remove(struct of_device *of_dev)
> +{
> +       struct fsl_dma_device *fdev;
> +       unsigned int i;
> +
> +       fdev = dev_get_drvdata(&of_dev->dev);
> +
> +       dma_async_device_unregister(&fdev->common);
> +
> +       for (i = 0; i < FSL_DMA_MAX_CHANS_PER_DEVICE; i++) {
> +               fsl_dma_chan_remove(fdev->chan[i]);
> +               fdev->chan[i] = NULL;
> +       }
> +
> +       if (fdev->irq != NO_IRQ)
> +               free_irq(fdev->irq, fdev);
> +
> +       iounmap(fdev->reg_base);
> +
> +       kfree(fdev);
> +       dev_set_drvdata(&of_dev->dev, NULL);
> +
> +       return 0;
> +}
> +
>  static struct of_device_id of_fsl_dma_ids[] = {
>        { .compatible = "fsl,eloplus-dma", },
>        { .compatible = "fsl,elo-dma", },
> @@ -1116,15 +1158,32 @@ static struct of_device_id of_fsl_dma_ids[] = {
>  };
>
>  static struct of_platform_driver of_fsl_dma_driver = {
> -       .name = "of-fsl-dma",
> +       .name = "fsl-elo-dma",
>        .match_table = of_fsl_dma_ids,
>        .probe = of_fsl_dma_probe,
> +       .remove = of_fsl_dma_remove,
>  };
>
>  static __init int of_fsl_dma_init(void)
>  {
> -       return of_register_platform_driver(&of_fsl_dma_driver);
> +       int ret;
> +
> +       pr_info("Freescale Elo / Elo Plus DMA driver\n");
> +
> +       ret = of_register_platform_driver(&of_fsl_dma_driver);
> +       if (ret)
> +               pr_err("fsldma: failed to register platform driver\n");
> +
> +       return ret;
> +}
> +
> +static void __exit of_fsl_dma_exit(void)
> +{
> +       of_unregister_platform_driver(&of_fsl_dma_driver);
>  }
>
> -subsys_initcall(of_fsl_dma_chan_init);
>  subsys_initcall(of_fsl_dma_init);
> +module_exit(of_fsl_dma_exit);
> +
> +MODULE_DESCRIPTION("Freescale Elo / Elo Plus DMA driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
> index 6faf07b..e0902dd 100644
> --- a/drivers/dma/fsldma.h
> +++ b/drivers/dma/fsldma.h
> @@ -114,6 +114,7 @@ struct fsl_dma_device {
>        struct dma_device common;
>        struct fsl_dma_chan *chan[FSL_DMA_MAX_CHANS_PER_DEVICE];
>        u32 feature;            /* The same as DMA channels */
> +       int irq;                /* Channel IRQ */
>  };
>
>  /* Define macros for fsl_dma_chan->feature property */
> @@ -135,6 +136,7 @@ struct fsl_dma_chan {
>        struct dma_chan common;         /* DMA common channel */
>        struct dma_pool *desc_pool;     /* Descriptors pool */
>        struct device *dev;             /* Channel device */
> +       struct of_device *of_dev;       /* OF device */
>        struct resource reg;            /* Resource for register */
>        int irq;                        /* Channel IRQ */
>        int id;                         /* Raw id of this channel */
> --
> 1.5.5
>
