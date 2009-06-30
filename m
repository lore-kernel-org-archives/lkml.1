Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbZF3A3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbZF3A3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbZF3A3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:29:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41234 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZF3A3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:29:06 -0400
Message-ID: <4A495C0D.2020807@zytor.com>
Date: Mon, 29 Jun 2009 17:27:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Mikael Pettersson <mikpe@it.uu.se>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>	<19013.29264.623540.275538@pilspetsen.it.uu.se>	<4A45A5C1.5080701@zytor.com>	<19013.59956.144640.331854@pilspetsen.it.uu.se>	<20090629022911.GC20297@lackof.org>	<4A484A8A.9020704@zytor.com>	<19016.41349.636663.515540@pilspetsen.it.uu.se>	<20090629112155.GJ5480@parisc-linux.org> <19016.44061.600652.676183@pilspetsen.it.uu.se> <4A490804.3040609@zytor.com> <4A494478.7020304@kernel.org> <4A494E3C.70304@kernel.org>
In-Reply-To: <4A494E3C.70304@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>  			continue;
> @@ -1409,8 +1409,10 @@ void __init e820_reserve_resources_late(
>  		end = round_up(start, ram_alignment(start));
>  		if (start == end)
>  			continue;
> -		reserve_region_with_split(&iomem_resource, start,
> -						  end - 1, "RAM buffer");
> +		if (end != (resource_size_t)end)
> +			continue;
> +		reserve_region_with_split(&iomem_resource, (resource_size_t)start,
> +					  (resource_size_t)(end - 1), "RAM buffer");
>  	}
>  }
>  

That doesn't quite look right; for one thing it doesn't handle the
(admittedly somewhat unlikely) case of end pointing to the end of the
address space.

Something like:

	if (start > (resource_size_t)end-1)
		continue;

... should work better.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

