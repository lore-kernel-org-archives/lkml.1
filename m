Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbZF3B2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbZF3B2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbZF3B2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:28:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753054AbZF3B2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:28:34 -0400
Date: Mon, 29 Jun 2009 18:26:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Mikael Pettersson <mikpe@it.uu.se>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
In-Reply-To: <4A4966EF.6010809@kernel.org>
Message-ID: <alpine.LFD.2.01.0906291820060.3605@localhost.localdomain>
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <19013.29264.623540.275538@pilspetsen.it.uu.se> <4A45A5C1.5080701@zytor.com> <19013.59956.144640.331854@pilspetsen.it.uu.se> <20090629022911.GC20297@lackof.org> <4A484A8A.9020704@zytor.com>
 <19016.41349.636663.515540@pilspetsen.it.uu.se> <20090629112155.GJ5480@parisc-linux.org> <19016.44061.600652.676183@pilspetsen.it.uu.se> <4A490804.3040609@zytor.com> <4A494478.7020304@kernel.org> <4A494E3C.70304@kernel.org> <4A495C0D.2020807@zytor.com>
 <4A4966EF.6010809@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Jun 2009, Yinghai Lu wrote:
> +		end = round_up(start, ram_alignment(start)) - 1;
> +		if (start > (resource_size_t)end)
>  			continue;
> -		reserve_region_with_split(&iomem_resource, start,
> -						  end - 1, "RAM buffer");
> +		reserve_region_with_split(&iomem_resource, (resource_size_t)start,
> +					  (resource_size_t)end, "RAM buffer");

Hmm. You shouldn't need the casts with reserve_region_with_split(), and 
they just make things uglier.

Also, I wonder if we should do something like this instead

	#define MAX_RESOURCE_SIZE ((resource_size_t)-1)

	...
	end = round_up(start, ram_alignment(start)) - 1;
	if (end > MAX_RESOURCE_SIZE)
		end = MAX_RESOURCE_SIZE;
	if (start > end)
		continue;

Because otherwise we'll just be ignoring resources that cross the resource 
size boundary, which sounds wrong.

We _could_ have a RAM resource that crosses the 4GB boundary, after all.

Yeah, it doesn't happen much in practice, because usually the 3G-4G range 
is left for PCI mappings etc, so we might never hit this in practice, but 
still, this sounds like a more correct thing to do.

It also avoids the cast. We simply cap the end to the max that 
'resource_size_t' can hold.

That said, I have to admit that I'm getting tired of these bugs that only 
happen when we have a 32-bit resource_size_t. So I can understand the 
attraction to just forcing it to 64-bit and forgetting about these 
irritating issues.

		Linus
