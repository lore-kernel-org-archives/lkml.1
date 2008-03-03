Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYCCHtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYCCHtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 02:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYCCHsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 02:48:51 -0500
Received: from neuf-infra-smtp-out-sp604006av.neufgp.fr ([84.96.92.121]:33678
	"EHLO neuf-infra-smtp-out-sp604006av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267AbYCCHsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 02:48:51 -0500
Message-ID: <47CBAD4E.7080901@cosmosbay.com>
Date: Mon, 03 Mar 2008 08:48:30 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] alloc_percpu() fails to allocate percpu data
References: <47BDBC23.10605@cosmosbay.com> <200802232023.52352.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0802271140470.1790@schroedinger.engr.sgi.com> <200803031414.43076.nickpiggin@yahoo.com.au>
In-Reply-To: <200803031414.43076.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin a écrit :
> On Thursday 28 February 2008 06:44, Christoph Lameter wrote:
>> On Sat, 23 Feb 2008, Nick Piggin wrote:
>>> What I don't understand is why the slab allocators have something like
>>> this in it:
>>>
>>>         if ((flags & SLAB_HWCACHE_ALIGN) &&
>>>                         size > cache_line_size() / 2)
>>>                 return max_t(unsigned long, align, cache_line_size());
>>>
>>> If you ask for HWCACHE_ALIGN, then you should get it. I don't
>>> understand, why do they think they knows better than the caller?
>> Tradition.... Its irks me as well.
>>
>>> Things like this are just going to lead to very difficult to track
>>> performance problems. Possibly correctness problems in rare cases.
>>>
>>> There could be another flag for "maybe align".
>> SLAB_HWCACHE_ALIGN *is* effectively a maybe align flag given the above
>> code.
>>
>> If we all agree then we could change this to have must have semantics? It
>> has the potential of enlarging objects for small caches.
>>
>> SLAB_HWCACHE_ALIGN has an effect that varies according to the alignment
>> requirements of the architecture that the kernel is build on. We may be in
>> for some surprises if we change this.
> 
> I think so. If we ask for HWCACHE_ALIGN, it must be for a good reason.
> If some structures get too bloated for no good reason, then the problem
> is not with the slab allocator but with the caller asking for
> HWCACHE_ALIGN.
> 

HWCACHE_ALIGN is commonly used, even for large structures, because the 
processor cache line on x86 is not known at compile time (can go from 32 bytes 
to 128 bytes).

The problem that above code is trying to address is about small objects.

Because at the time code using HWCACHE_ALIGN was written, cache line size was 
32 bytes. Now we have CPU with 128 bytes cache lines, we would waste space if 
SLAB_HWCACHE_ALIGN was honored for small objects.

Some occurences of SLAB_HWCACHE_ALIGN are certainly not usefull, we should zap 
them. Last one I removed was the one for "struct flow_cache_entry"  (commit 
dd5a1843d566911dbb077c4022c4936697495af6 : [IPSEC] flow: reorder "struct 
flow_cache_entry" and remove SLAB_HWCACHE_ALIGN)

