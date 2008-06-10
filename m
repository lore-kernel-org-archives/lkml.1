Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYFJOwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYFJOwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbYFJOvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:51:53 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:59944 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbYFJOvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:51:52 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
Date: Tue, 10 Jun 2008 16:50:26 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Miles Lane" <miles.lane@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
References: <a44ae5cd0806100709rf4602f2x587631852502c0b5@mail.gmail.com> <200806101637.11473.mb@bu3sch.de> <19f34abd0806100742v176f50e8se463d2e70df44332@mail.gmail.com>
In-Reply-To: <19f34abd0806100742v176f50e8se463d2e70df44332@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101650.27180.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008 16:42:41 Vegard Nossum wrote:
> This change comes from
> 
> commit 353c409463ecba63c3a41a992d3f5fba935eada9
> Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date:   Fri May 23 19:02:30 2008 +0000


Ok, FUJITA Tomonori, please make sure a patch like the following goes
into the same trees that you submitted commit 353c409 to.
Also make sure to check b43legacy. I _guess_ you might have added
the same bug there.

Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2008-06-10 13:58:22.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2008-06-10 16:48:53.000000000 +0200
@@ -802,6 +802,7 @@ struct b43_dmaring *b43_setup_dmaring(st
 	if (!ring)
 		goto out;
 	ring->type = type;
+	ring->dev = dev;
 
 	nr_slots = B43_RXRING_SLOTS;
 	if (for_tx)
@@ -853,7 +854,6 @@ struct b43_dmaring *b43_setup_dmaring(st
 				 DMA_TO_DEVICE);
 	}
 
-	ring->dev = dev;
 	ring->nr_slots = nr_slots;
 	ring->mmio_base = b43_dmacontroller_base(type, controller_index);
 	ring->index = controller_index;


>     dma-mapping-add-the-device-argument-to-dma_mapping_error
> 
>     Add per-device dma_mapping_ops support for CONFIG_X86_64 as POWER
>     architecture does:
> 
>     This enables us to cleanly fix the Calgary IOMMU issue that some devices
>     are not behind the IOMMU (http://lkml.org/lkml/2008/5/8/423).
> 
>     I think that per-device dma_mapping_ops support would be also helpful for
>     KVM people to support PCI passthrough but Andi thinks that this makes it
>     difficult to support the PCI passthrough (see the above thread).  So I
>     CC'ed this to KVM camp.  Comments are appreciated.
> 
>     A pointer to dma_mapping_ops to struct dev_archdata is added.  If the
>     pointer is non NULL, DMA operations in asm/dma-mapping.h use it.  If it's
>     NULL, the system-wide dma_ops pointer is used as before.
> 
>     If it's useful for KVM people, I plan to implement a mechanism to register
>     a hook called when a new pci (or dma capable) device is created (it works
>     with hot plugging).  It enables IOMMUs to set up an appropriate
>     dma_mapping_ops per device.
> 
>     The major obstacle is that dma_mapping_error doesn't take a pointer to the
>     device unlike other DMA operations.  So x86 can't have dma_mapping_ops per
>     device.  Note all the POWER IOMMUs use the same dma_mapping_error function
>     so this is not a problem for POWER but x86 IOMMUs use different
>     dma_mapping_error functions.
> 
>     The first patch adds the device argument to dma_mapping_error.  The patch
>     is trivial but large since it touches lots of drivers and dma-mapping.h in
>     all the architecture.
> 
> (Added to Cc.)
> 
> 
> Vegard
> 



-- 
Greetings Michael.
