Return-Path: <linux-kernel-owner+w=401wt.eu-S932549AbZD1Pou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbZD1Pou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761614AbZD1Poc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:44:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:56496 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762113AbZD1Pob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:44:31 -0400
Date: Tue, 28 Apr 2009 08:39:06 -0700
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH] use dev_set_name(,NULL) to prevent leaking
Message-ID: <20090428153906.GA8896@suse.de>
References: <20090418192314.GA22107@suse.de> <ac3eb2510904181300v2593c36dua6c2420828860706@mail.gmail.com> <1240086446.2411.9.camel@poy> <20090418203718.GD30144@elte.hu> <49EA4EB9.2030307@kernel.org> <49F6B1E6.7050008@kernel.org> <49F6B350.9080703@kernel.org> <ac3eb2510904280125w11a58388u6a51997e28609009@mail.gmail.com> <49F71EF6.3050102@kernel.org> <49F72205.7030306@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F72205.7030306@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 08:34:29AM -0700, Yinghai Lu wrote:
> Yinghai Lu wrote:
> > Kay Sievers wrote:
> >> On Tue, Apr 28, 2009 at 09:42, Yinghai Lu <yinghai@kernel.org> wrote:
> >>> those about 1/3 dev_set_name() etc.
> >> put_device()?
> >>
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/base/core.c;h=4aa527b8a91381289eb175b33f46e3e418d10374;hb=HEAD#l848
> >>
> > ok, normal release path seems right, put_device will free the name.
> > 
> > how about other fail path, that there is not put_device involved?
> > 
>  
> looks like need to follow this pattern
> 
> static int
> sa1111_init_one_child(struct sa1111 *sachip, struct resource *parent,
>                       struct sa1111_dev_info *info)
> {
>         struct sa1111_dev *dev;
>         int ret;
> 
>         dev = kzalloc(sizeof(struct sa1111_dev), GFP_KERNEL);
>         if (!dev) {
>                 ret = -ENOMEM;
>                 goto out;
>         }
> 
>         dev_set_name(&dev->dev, "%4.4lx", info->offset);
>         dev->devid       = info->devid;
>         dev->dev.parent  = sachip->dev;
>         dev->dev.bus     = &sa1111_bus_type;
>         dev->dev.release = sa1111_dev_release;
>         dev->dev.coherent_dma_mask = sachip->dev->coherent_dma_mask;
>         dev->res.start   = sachip->phys + info->offset;
>         dev->res.end     = dev->res.start + 511;
>         dev->res.name    = dev_name(&dev->dev);
>         dev->res.flags   = IORESOURCE_MEM;
>         dev->mapbase     = sachip->base + info->offset;
>         dev->skpcr_mask  = info->skpcr_mask;
>         memmove(dev->irq, info->irq, sizeof(dev->irq));
> 
>         ret = request_resource(parent, &dev->res);
>         if (ret) {
>                 printk("SA1111: failed to allocate resource for %s\n",
>                         dev->res.name);
>                 dev_set_name(&dev->dev, NULL); ============> clear the name
>                 kfree(dev);
>                 goto out;
>         }
>         
> 
>         ret = device_register(&dev->dev);
>         if (ret) {
>                 release_resource(&dev->res);
>                 put_device(&dev->dev);   ==================> put the device...
>                 kfree(dev);
>                 goto out;
>         }

You can just do a "put_device()" in both places, and it should be fine.

thanks,

greg k-h
