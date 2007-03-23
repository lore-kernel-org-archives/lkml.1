Return-Path: <linux-kernel-owner+w=401wt.eu-S934023AbXCWHqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934023AbXCWHqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 03:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXCWHqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 03:46:00 -0400
Received: from sp604005mt.neufgp.fr ([84.96.92.11]:40116 "EHLO smtp.Neuf.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752674AbXCWHqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 03:46:00 -0400
Date: Fri, 23 Mar 2007 08:45:49 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] slab: NUMA kmem_cache diet
In-reply-to: <Pine.LNX.4.64.0703230907010.17666@sbz-30.cs.Helsinki.FI>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, apw@shadowen.org, hch@lst.de,
       manfred@colorfullife.com, christoph@lameter.com, pj@sgi.com
Message-id: <460385AD.10502@cosmosbay.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <Pine.LNX.4.64.0701021545290.21477@sbz-30.cs.Helsinki.FI>
 <4603047C.4070904@cosmosbay.com>
 <Pine.LNX.4.64.0703230907010.17666@sbz-30.cs.Helsinki.FI>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg a écrit :
> (Please inline patches to the mail, makes it easier to review.)
> 
> On Thu, 22 Mar 2007, Eric Dumazet wrote:
>> Some NUMA machines have a big MAX_NUMNODES (possibly 1024), but fewer possible
>> nodes. This patch dynamically sizes the 'struct kmem_cache' to allocate only
>> needed space.
>>
>> I moved nodelists[] field at the end of struct kmem_cache, and use the
>> following computation in kmem_cache_init()
> 
> Hmm, what seems bit worrying is:
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index abf46ae..b187618 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -389,7 +389,6 @@ struct kmem_cache {
>         unsigned int buffer_size;
>         u32 reciprocal_buffer_size;
>  /* 3) touched by every alloc & free from the backend */
> -       struct kmem_list3 *nodelists[MAX_NUMNODES];
> 
> I think nodelists is placed at the beginning of the struct for a reason. 
> But I have no idea if it actually makes any difference...

It might make a difference if STATS is on, because freehit/freemiss might 
share a cache line with nodelists. Apart that, a kmem_cache struct is 
read_mostly : All changes are done outside of it, via array_cache or nodelists[].


Anyway slab STATS is already a SMP/NUMA nightmare because of cache line ping 
pongs. We might place STATS counter in a/some dedicated cache line(s)...

