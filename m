Return-Path: <linux-kernel-owner+w=401wt.eu-S1751774AbZGaJAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbZGaJAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 05:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZGaJAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 05:00:14 -0400
Received: from relay.gothnet.se ([82.193.160.251]:50585 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751370AbZGaJAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 05:00:13 -0400
Message-ID: <4A72B28D.8050801@shipmail.org>
Date: Fri, 31 Jul 2009 10:59:57 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
Organization: VMware
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Pekka Paalanen <pq@iki.fi>
CC: Thomas Hellstrom <thellstrom@vmware.com>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ttm: Fix ttm in-kernel copying of pages with	non-standard
 caching attributes.
References: <1248422254-32193-1-git-send-email-thellstrom@vmware.com>	<1248422254-32193-2-git-send-email-thellstrom@vmware.com> <20090730190010.649589ba@iki.fi>
In-Reply-To: <20090730190010.649589ba@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Paalanen wrote:
> Hi,
>
> since I see this patch in Linus' tree, and I likely have to patch
> TTM in Nouveau's compat-branch to compile with older kernels,
> I have a question below.
>
> (The Nouveau kernel tree's compat branch offers drm.ko, ttm.ko and
> nouveau.ko to be built against kernels 2.6.28 and later.)
>
> On Fri, 24 Jul 2009 09:57:34 +0200
> Thomas Hellstrom <thellstrom@vmware.com> wrote:
>
>   
>> For x86 this affected highmem pages only, since they were always kmapped
>> cache-coherent, and this is fixed using kmap_atomic_prot().
>>
>> For other architectures that may not modify the linear kernel map we
>> resort to vmap() for now, since kmap_atomic_prot() generally uses the
>> linear kernel map for lowmem pages. This of course comes with a
>> performance impact and should be optimized when possible.
>>
>> Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
>> ---
>>  drivers/gpu/drm/ttm/ttm_bo_util.c |   63 ++++++++++++++++++++++++++++++------
>>  1 files changed, 52 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
>> index 3e5d0c4..ce2e6f3 100644
>> --- a/drivers/gpu/drm/ttm/ttm_bo_util.c
>> +++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
>> @@ -136,7 +136,8 @@ static int ttm_copy_io_page(void *dst, void *src, unsigned long page)
>>  }
>>  
>>  static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
>> -				unsigned long page)
>> +				unsigned long page,
>> +				pgprot_t prot)
>>  {
>>  	struct page *d = ttm_tt_get_page(ttm, page);
>>  	void *dst;
>> @@ -145,17 +146,35 @@ static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
>>  		return -ENOMEM;
>>  
>>  	src = (void *)((unsigned long)src + (page << PAGE_SHIFT));
>> -	dst = kmap(d);
>> +
>> +#ifdef CONFIG_X86
>> +	dst = kmap_atomic_prot(d, KM_USER0, prot);
>> +#else
>> +	if (prot != PAGE_KERNEL)
>> +		dst = vmap(&d, 1, 0, prot);
>> +	else
>> +		dst = kmap(d);
>> +#endif
>>     
>
> What are the implications of choosing the non-CONFIG_X86 path
> even on x86?
>   

The only implication is a slowdown if dealing with highmem pages or 
pages with
a non standard caching policy. Also you need the patch I just posted to 
dri-devel / lkml to make it compile.
I should've done more thorough testing of the non-x86 path.

> Is kmap_atomic_prot() simply an optimization allowed by the x86
> arch, and the alternate way also works, although it uses the
> precious vmalloc address space?
>   

Exactly, although it's only using one page out of vmalloc space and for 
the time it
takes to copy a page to / from io.

> Since kmap_atomic_prot() is not exported on earlier kernels,
> I'm tempted to just do the non-CONFIG_X86 path.
>   
For compat I think that should be fine. If your driver is using 
accelerated copy to / from
VRAM, you shouldn't even hit this path.

/Thomas





