Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbXDBEIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbXDBEIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 00:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbXDBEIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 00:08:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:60258 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbXDBEIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 00:08:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b8IcvFztsgqMkDTEirPUTp7j/ne8asRWZTHTmhE3FcsNIeagYH4M256qEi6BQgXG4EiCbVlVaYKYF0j+SwkUDmIgwwC2SN+lU81IkwY/GRSB5blB334gPGWv70IfdC3oMXE1fnlkRkJnZPQcw6X4iMWqXLArKSmlaIku7zGRm9c=
Message-ID: <21d7e9970704012108m5fd9797bk45c4b39892c8d36f@mail.gmail.com>
Date: Mon, 2 Apr 2007 14:08:13 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: drm + 4GB RAM + swiotlb = drm craps out
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
In-Reply-To: <20070401.201134.82699692.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970704011644n3adbef2brc6bfeb288f5d0866@mail.gmail.com>
	 <20070401.201134.82699692.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > So when swiotlb happens, as you can guess it all falls apart as the
> > drm never calls sync functions at any stage...
>
> You would have hit this on any platform that does caching
> in the PCI controller as well.

We must not have a great intersect of radeon and such systems..

>
> Coherent memory was created for precisely the case where the cpu
> and the device frequently access the memory.
>
> 8MB is indeed a lot for the kind of allocation that the coherent
> DMA implementation uses.
>
> Does it really have to be all in one big 8MB chunk?  I doubt it.
> Perhaps you can therefore create multiple DMA pools instead?  See
> include/linux/dmapool.h

It currently is required to be in a big 8MB chunk as it gets chopped
up by the X server not the kernel, so kernel needs to allocate pages
to back it when X inits, yes this is ugly, no it can't be fixed
without time-travelling and fixing deployed X servers...

Really we probably only need the ring buffer to be in coherent memory,
the rest of the stuff is used for DMA buffers which are mainly filled
by the CPU and read by the GPU. However I cannot change this without
breaking X, the solution is really to use TTM for this sort of
stuff.... I'm a bit worried as the AGP driver now uses vmalloc_32
which really is a meaningless interface on 64-bit systems..

Dave.
