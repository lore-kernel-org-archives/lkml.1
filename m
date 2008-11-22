Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYKVHoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYKVHoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 02:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbYKVHoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 02:44:03 -0500
Received: from mail.vyatta.com ([76.74.103.46]:34226 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbYKVHoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 02:44:01 -0500
X-Spam-Flag: NO
X-Spam-Score: -1.299
Date: Fri, 21 Nov 2008 23:43:59 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: next-20081121:WARNING: at drivers/dma/dmaengine.c:665
 dma_async_device_unregister()
Message-ID: <20081121234359.767d4283@extreme>
In-Reply-To: <1227315224.32103.7.camel@dwillia2-linux.ch.intel.com>
References: <a4423d670811210240t77ec97d1pbe1ef0e4ae3a1a2e@mail.gmail.com>
	<1227315224.32103.7.camel@dwillia2-linux.ch.intel.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 17:53:44 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Fri, 2008-11-21 at 03:40 -0700, Alexander Beregalov wrote:
> > Hi
> > 
> > It occured during shutdown process:
> > 
> > sd 0:2:0:0: [sda] Synchronizing SCSI cache
> > ioatdma 0000:00:08.0: Removing dma and dca services
> > ------------[ cut here ]------------
> > WARNING: at drivers/dma/dmaengine.c:665 dma_async_device_unregister+0x90/0xd0()
> > dma_async_device_unregister called while 1 clients hold a reference
> ...
> > WARNING: at drivers/base/core.c:122 device_release+0x66/0x68()
> > Device 'dma0chan0' does not have a release() function, it is broken and must be
> > fixed.
> 
> The following fixes these up for me.  Maciej, do these look alright?:
> 
> commit 16f5de60e2406c0c879627177aecd7ef489c30e5
> Author: Dan Williams <dan.j.williams@intel.com>
> Date:   Fri Nov 21 17:48:55 2008 -0700
> 
>     dmaengine: add a release for dma class devices
>     
>     Resolves:
>     WARNING: at drivers/base/core.c:122 device_release+0x4d/0x52()
>     Device 'dma0chan0' does not have a release() function, it is broken and must be fixed.
>     
>     Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 6fc6595..94dcc64 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -103,9 +103,16 @@ static struct device_attribute dma_attrs[] = {
>  	__ATTR_NULL
>  };
>  
> +static void chan_dev_release(struct device *dev)
> +{
> +	/* nothing to do */
> +	do { } while (0);
> +}
> +
>  static struct class dma_devclass = {
>  	.name		= "dma",
>  	.dev_attrs	= dma_attrs,
> +	.dev_release	= chan_dev_release,
>  };

The warning is there for a reason. Device objects can live in sysfs even
after the module is removed. You just wallpapered over the problem..
