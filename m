Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYGWXtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYGWXtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbYGWXti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:49:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbYGWXth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:49:37 -0400
Message-ID: <4887C2F7.6040506@redhat.com>
Date: Wed, 23 Jul 2008 19:47:03 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: joro@8bytes.org
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, ed.pollard@ibm.com, epollard@redhat.com
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
References: <20080723111928.15828.42561.sendpatchset@prarit.bos.redhat.com>	<20080723221033.GD13662@8bytes.org> <20080724081528F.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080724081528F.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Interesting. Have you experienced any problems because of that
>> misbehavior in the GART code? AMD IOMMU currently also violates this
>> requirement. I will send a patch to fix that there too.
>>     
>
>   

Joerg,  yes I can see misbehavior caused by this code.  O/w I wouldn't 
be spending my time fixing it :) :)

See below ....

> IIRC, only PARISC and POWER IOMMUs follow the above rule. So I also
> wondered what problem he hit.
>   

I wonder if IBM's Calgary IOMMU needs this fix? ... I've added Ed 
Pollard to find out.

On big memory footprint (16G or above) systems it is possible that the 
e820 map reserves most of the lower 4G of memory for system use*.  So 
it's possible that the 4G region is almost completely reserved at boot 
time and so the kernel starts using the IOMMU for DMA (see 
dma_alloc_coherent()).  The addresses returned are not properly aligned, 
and this causes serious problems for some drivers that require a 
physical aligned address for the device.

P.

* I have one large system with 64G of memory on which I can reproduce 
this issue very quickly.  Even booting the system with mem=16G seems to 
cause the problem, although I did have to load a module that reserved a 
few M of DMA addresses before I started alloc'ing from the IOMMU.

I also reproduced this on a smaller system by loading one module that 
reserved as much DMA-able region as possible, and then loaded another 
module that reserved from the IOMMU.  While this situation is a bit 
contrived the bug still hit -- the returned addresses are not properly 
aligned.

