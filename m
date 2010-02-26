Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935761Ab0BZJgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:36:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47145
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935611Ab0BZJgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:36:21 -0500
Date: Fri, 26 Feb 2010 01:36:37 -0800 (PST)
Message-Id: <20100226.013637.255461265.davem@davemloft.net>
To: hancockrwd@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [RFC PATCH] fix problems with NETIF_F_HIGHDMA in networking
 drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B834159.7070105@gmail.com>
References: <4B834159.7070105@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Hancock <hancockrwd@gmail.com>
Date: Mon, 22 Feb 2010 20:45:45 -0600

> Many networking drivers have issues with the use of the NETIF_F_HIGHDMA flag.
> This flag actually indicates whether or not the device/driver can handle
> skbs located in high memory (as opposed to lowmem). However, many drivers
> incorrectly treat this flag as indicating that 64-bit DMA is supported, which
> has nothing to do with its actual function. It makes no sense to make setting
> NETIF_F_HIGHDMA conditional on whether a 64-bit DMA mask has been set, as many
> drivers do, since if highmem DMA is supported at all, it should work regardless
> of whether 64-bit DMA is supported. Failing to set NETIF_F_HIGHDMA when it
> should be can hurt performance on architectures which use highmem since it
> results in needless data copying.
> 
> This fixes up the networking drivers which currently use NETIF_F_HIGHDMA to
> not do so conditionally on DMA mask settings.
> 
> For the USB kaweth and usbnet drivers, this patch also uncomments and corrects
> some code to set NETIF_F_HIGHDMA based on the USB host controller's DMA mask.
> These drivers should be able to access highmem unless the host controller is
> non-DMA-capable, which is indicated by the DMA mask being null.
> 
> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>

Well, if the device isn't using 64-bit DMA addressing and the platform
uses direct (no-iommu) mapping of physical to DMA addresses , won't
your change break things?  The device will get a >4GB DMA address or
the DMA mapping layer will signal an error.

That's really part of the what the issue is I think.

So, this trigger the check in check_addr() in
arch/x86/kernel/pci-nommu.c when such packets try to get mapped by the
driver, right?

That will make the DMA mapping call fail, and the packet will be
dropped permanently.  And hey, on top of it, many of these drivers you
remove the setting from don't even check the mapping call return
values for errors.

So even bigger breakage.  One example is drivers/net/8139cp.c,
it just does dma_map_single() and uses the result.

It really depends upon that NETIF_F_HIGHDMA setting for correct
operation.

And even if something like swiotlb is available, now we're going
to do bounce buffering which is largely equivalent to what
a lack of NETIF_F_HIGHDMA will do.  Except that once NETIF_F_HIGHDMA
copies the packet to lowmem it will only do that once, whereas if
the packet goes to multiple devices swiotlb might copy the packet
to a bounce buffer multiple times.

We definitely can't apply your patch as-is.
