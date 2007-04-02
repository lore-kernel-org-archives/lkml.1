Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbXDBFIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbXDBFIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbXDBFIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:08:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41124
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753220AbXDBFIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:08:42 -0400
Date: Sun, 01 Apr 2007 22:08:41 -0700 (PDT)
Message-Id: <20070401.220841.89389711.davem@davemloft.net>
To: airlied@gmail.com
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: drm + 4GB RAM + swiotlb = drm craps out
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970704012108m5fd9797bk45c4b39892c8d36f@mail.gmail.com>
References: <21d7e9970704011644n3adbef2brc6bfeb288f5d0866@mail.gmail.com>
	<20070401.201134.82699692.davem@davemloft.net>
	<21d7e9970704012108m5fd9797bk45c4b39892c8d36f@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dave Airlie" <airlied@gmail.com>
Date: Mon, 2 Apr 2007 14:08:13 +1000

> > >
> > > So when swiotlb happens, as you can guess it all falls apart as the
> > > drm never calls sync functions at any stage...
> >
> > You would have hit this on any platform that does caching
> > in the PCI controller as well.
> 
> We must not have a great intersect of radeon and such systems..

It might explain why my machine hung when I tried to use
radeon with DRM on my sparc64 workstation :-)  I have
investigating that on my todo list.

> It currently is required to be in a big 8MB chunk as it gets chopped
> up by the X server not the kernel, so kernel needs to allocate pages
> to back it when X inits, yes this is ugly, no it can't be fixed
> without time-travelling and fixing deployed X servers...
>
> Really we probably only need the ring buffer to be in coherent memory,
> the rest of the stuff is used for DMA buffers which are mainly filled
> by the CPU and read by the GPU. However I cannot change this without
> breaking X, the solution is really to use TTM for this sort of
> stuff.... I'm a bit worried as the AGP driver now uses vmalloc_32
> which really is a meaningless interface on 64-bit systems..

I don't know what to recommend to you, getting 8MB of linear memory
really just isn't practical.

Perhaps we'll have to create something ugly like vmalloc_nobounce().

Remind me again why you're ending up with swiotlb'd pages?
vmalloc_32() uses GFP_KERNEL which should use entirely lowmem and thus
RAM below 4GB and not anything which should need bounce buffering.

You should only get swiotlb'd pages if __GFP_HIGHMEM were set in
the gfp flags.

Are you expecting to be able to virtually remap these pages in
PCI space as one huge 8MB chunk too and that's how swiotlb gets
involved?  That won't work, sorry...
