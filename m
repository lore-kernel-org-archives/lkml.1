Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbYFLITd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbYFLITd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYFLITR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:19:17 -0400
Received: from sh.osrg.net ([192.16.179.4]:33512 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757517AbYFLITO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:19:14 -0400
Date: Thu, 12 Jun 2008 16:29:33 +0900
To: alexisb@us.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       muli@il.ibm.com, mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: [PATCH -mm] x86 calgary: fix handling of devces that aren't
	behind the Calgary
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1213233906.8567.146.camel@alexis>
References: <20080531133114P.tomof@acm.org>
	<1213233906.8567.146.camel@alexis>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080612163403K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 18:25:06 -0700
Alexis Bruemmer <alexisb@us.ibm.com> wrote:

> On Sat, 2008-05-31 at 13:31 +0900, FUJITA Tomonori wrote:
> > The calgary code can give drivers addresses above 4GB which is very
> > bad for hardware that is only 32bit DMA addressable:
> > 
> > http://lkml.org/lkml/2008/5/8/423
> > 
> > This patch tries to fix the problem by using per-device
> > dma_mapping_ops support. This fixes the calgary code to use swiotlb or
> > nommu properly for devices which are not behind the Calgary/CalIOC2.
> > 
> > With this patch, the calgary code sets the global dma_ops to swiotlb
> > or nommu, and the dma_ops of devices behind the Calgary/CalIOC2 to
> > calgary_dma_ops. So the calgary code can handle devices safely that
> > aren't behind the Calgary/CalIOC2.
> > 
> > I think that bus_register_notifier works nicely for hotplugging (the
> > calgary code can register a hook to set the device-per ops to
> > calgary_dma_ops) though I don't know the calgary code needs it.
> > 
> > This patch is against -mm (depends on the per-device dma_mapping_ops
> > patchset in -mm).
> > 
> > This is only compile tested.
> So this patch dose not completely work.  The problem is that devices
> that are controlled by the CalIO2/calgary are not getting the calgary
> dma_ops assigned to them.  Having the proper changes to pci-dma.c helped
> (thank you) but still didn't quite get us there.  From what I could tell
> having the per device dma_ops being assigned in calgary_init_one was not
> correct.  The dev being past to calgary_init_one is only ever an IBM
> CalIO2/calgary device which meant that many devices that are being
> controlled by the CalI02/calgary, such as the the MegaRAID SAS
> controller, were not getting the calgary based dma ops assigned to them.

Thanks, now I see what's wrong in my patch.


> I have attached an updated patch that does assign the per device calgary
> dma_ops correctly and have successfully tested it on an IBM x3950 M2.  I
> think there is a better way to do this, but this does work.

Looks good though I have one minor comment.


> Thank you some much for your help and work on this problem!

You're welcome! I just want to improve IOMMUs and dma mapping code.


> Alexis 
> 
> 
> > Thanks,
> > 
> > ==
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] x86 calgary: fix handling of devces that aren't behind the Calgary
> > 
> > The calgary code can give drivers addresses above 4GB which is very
> > bad for hardware that is only 32bit DMA addressable.
> > 
> > With this patch, the calgary code sets the global dma_ops to swiotlb
> > or nommu properly, and the dma_ops of devices behind the
> > Calgary/CalIOC2 to calgary_dma_ops. So the calgary code can handle
> > devices safely that aren't behind the Calgary/CalIOC2.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> <snip>
> 
> Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>


> @@ -1230,6 +1197,21 @@ static int __init calgary_init(void)
>  			goto error;
>  	} while (1);
>  
> +	dev = NULL;
> +	do {
> +		struct iommu_table *tbl;
> +		dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
> +
> +		if (!dev)
> +			break;
> +
> +		tbl = find_iommu_table(&dev->dev);
> +
> +		if(translation_enabled(tbl))
> +			dev->dev.archdata.dma_ops = &calgary_dma_ops;
> +
> +	} while (1);

for_each_pci_dev would simplify the code a bit?

dev = NULL;

for_each_pci_dev(dev) {
	struct iommu_table *tbl;

	tbl = find_iommu_table(&dev->dev);

	if(translation_enabled(tbl))
		dev->dev.archdata.dma_ops = &calgary_dma_ops;
}
