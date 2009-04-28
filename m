Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbZD1PQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbZD1PQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756325AbZD1PQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:16:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:59635 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741AbZD1PQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:16:41 -0400
Message-ID: <49F71D45.2030700@kernel.org>
Date: Tue, 28 Apr 2009 08:14:13 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, Kay Sievers <kay.sievers@vrfy.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] driver: make dev_set_name(, NULL) work
References: <49E8FD0B.2050308@zytor.com> <49E96731.1000501@kernel.org> <alpine.LFD.2.00.0904181141100.4042@localhost.localdomain> <49EA27B9.3030004@kernel.org> <20090418192314.GA22107@suse.de> <ac3eb2510904181300v2593c36dua6c2420828860706@mail.gmail.com> <1240086446.2411.9.camel@poy> <20090418203718.GD30144@elte.hu> <49EA4EB9.2030307@kernel.org> <49F6B1E6.7050008@kernel.org> <20090428145144.GA8352@suse.de>
In-Reply-To: <20090428145144.GA8352@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Apr 28, 2009 at 12:36:06AM -0700, Yinghai Lu wrote:
>> while looking dev_set_name() calling, there is one
>> 	dev_set_name(&dev->dev, NULL)
>> to used to try to free the device name, before kfree that device.
> 
> What's wrong with that?
> 
>> need to move the check for device_add in
>> | commit 8a577ffc75d9194fe8cdb7479236f2081c26ca1f
>> | Author: Kay Sievers <kay.sievers@vrfy.org>
>> | Date:   Sat Apr 18 15:05:45 2009 -0700
>> |
>> |    driver: dont update dev_name via device_add path
>> from kobject_set_name_vargs to kobject_add_vargs instead.
>>
>> in kobject_set_name_vargs will check if fmt is NULL.
>>
>> actually we need to use dev_set_name(,NULL) later on failing path
>> and release to prevent leaking
> 
> Are you sure?
> 
> confused,
> 

in arch/arm/common/sa111.c


static int
sa1111_init_one_child(struct sa1111 *sachip, struct resource *parent,
                      struct sa1111_dev_info *info)
{
        struct sa1111_dev *dev;
        int ret;

        dev = kzalloc(sizeof(struct sa1111_dev), GFP_KERNEL);
        if (!dev) {
                ret = -ENOMEM;
                goto out;
        }

        dev_set_name(&dev->dev, "%4.4lx", info->offset);
        dev->devid       = info->devid;
        dev->dev.parent  = sachip->dev;
        dev->dev.bus     = &sa1111_bus_type;
        dev->dev.release = sa1111_dev_release;
        dev->dev.coherent_dma_mask = sachip->dev->coherent_dma_mask;
        dev->res.start   = sachip->phys + info->offset;
        dev->res.end     = dev->res.start + 511;
        dev->res.name    = dev_name(&dev->dev);
        dev->res.flags   = IORESOURCE_MEM;
        dev->mapbase     = sachip->base + info->offset;
        dev->skpcr_mask  = info->skpcr_mask;
        memmove(dev->irq, info->irq, sizeof(dev->irq));

        ret = request_resource(parent, &dev->res);
        if (ret) {
                printk("SA1111: failed to allocate resource for %s\n",
                        dev->res.name);
                dev_set_name(&dev->dev, NULL);
                kfree(dev);
                goto out;
        }


when first dev_set_name is called, dev->dev.kobj.name will initialized from kmalloc.
so before kfree(dev), do we need to kfree that name?

YH
