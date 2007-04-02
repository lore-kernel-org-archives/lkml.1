Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbXDBFPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbXDBFPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbXDBFPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:15:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:7677 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbXDBFPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:15:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ctNZkIVOziX2bCoccY1+Ju3DPMYq/heFiiB7ALnpyZh8asdx/H+P2nwbZNHUCbBhUH9xwDxQ2Gmynewku4mtldwEwIGjnHQSNXTK2xDj7ZCCszMOROv5F6LCidL+uY9PB+V/T8+rSQpt+SWeMRzFW0u4Hl4Gcg/mghcvEKiEXqU=
Message-ID: <21d7e9970704012215n67487549vbc7592a4f181e288@mail.gmail.com>
Date: Mon, 2 Apr 2007 15:15:48 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: drm + 4GB RAM + swiotlb = drm craps out
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
In-Reply-To: <20070401.220841.89389711.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970704011644n3adbef2brc6bfeb288f5d0866@mail.gmail.com>
	 <20070401.201134.82699692.davem@davemloft.net>
	 <21d7e9970704012108m5fd9797bk45c4b39892c8d36f@mail.gmail.com>
	 <20070401.220841.89389711.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It might explain why my machine hung when I tried to use
> radeon with DRM on my sparc64 workstation :-)  I have
> investigating that on my todo list.

True, maybe the intersection is me + hw like that + radeon :-)

> I don't know what to recommend to you, getting 8MB of linear memory
> really just isn't practical.

This is the thing it doesn't need to be linear, I have a GART onboard
the radeon that I can fill in, I just need internally in the kernel to
access it linearly and in userspace to map it linearly, but it doesn't
need to be physcially linear, vmalloc_32 + map_single should in theory
be possible if.. see below...

>
> Perhaps we'll have to create something ugly like vmalloc_nobounce().
>
> Remind me again why you're ending up with swiotlb'd pages?
> vmalloc_32() uses GFP_KERNEL which should use entirely lowmem and thus
> RAM below 4GB and not anything which should need bounce buffering.

On a 64-bit machine GFP_KERNEL can give me any memory... it all works
fine on 32-bit highmem kernel as I don't get highmem... I really need
__GFP_DMA32 memory but we don't have a generic allocator that gives
this out that I can see..

> Are you expecting to be able to virtually remap these pages in
> PCI space as one huge 8MB chunk too and that's how swiotlb gets
> involved?  That won't work, sorry...

Well I feed the bus address for each page into a GART table in the GPU
and it does the linear stuff internally in the GPU memory
controller...

I suppose I want __GFP_I_D_RATHER_DIE_THAN_BOUNCE.

Dave.
