Return-Path: <linux-kernel-owner+w=401wt.eu-S1752249AbXDBDLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbXDBDLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 23:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbXDBDLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 23:11:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37805
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752192AbXDBDLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 23:11:38 -0400
Date: Sun, 01 Apr 2007 20:11:34 -0700 (PDT)
Message-Id: <20070401.201134.82699692.davem@davemloft.net>
To: airlied@gmail.com
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: drm + 4GB RAM + swiotlb = drm craps out
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970704011644n3adbef2brc6bfeb288f5d0866@mail.gmail.com>
References: <21d7e9970704011644n3adbef2brc6bfeb288f5d0866@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dave Airlie" <airlied@gmail.com>
Date: Mon, 2 Apr 2007 09:44:41 +1000

> Okay I've got a bug reported before and now again about > 4GB + radeon
> blows up the DRM... on Intel hw...
> 
> What the drm currently does for the PCI GART table is it allocates a
> chunk of memory (8MB) with vmalloc_32(), then when it decides to use
> it it goes through every page of it calls pci_map_single() (with
> PCI_DMA_TODEVICE, which is probably wrong...) with every page from the
> vmalloc mapping and puts the bus addresses of the pages into the PCI
> GART table on the GPU.
> 
> So when swiotlb happens, as you can guess it all falls apart as the
> drm never calls sync functions at any stage...

You would have hit this on any platform that does caching
in the PCI controller as well.

> The main problem is the ring buffer and scratch write back, these
> values are read/write from both the CPU and GPU quite a lot, so this
> leads me to think I should really just be using dma_alloc_coherent for
> the whole lot, however this is an 8MB mapping and possibly could be
> getting larger in the future and dynamic as we do dynamic PCIEGART
> support for the radeons...
> 
> So I suppose I'm asking for ideas on the "correct" way to do this, and
> perhaps any quick way to patch up the problem I'm seeing now by making
> swiotlb not get involved ....

Coherent memory was created for precisely the case where the cpu
and the device frequently access the memory.

8MB is indeed a lot for the kind of allocation that the coherent
DMA implementation uses.

Does it really have to be all in one big 8MB chunk?  I doubt it.
Perhaps you can therefore create multiple DMA pools instead?  See
include/linux/dmapool.h
