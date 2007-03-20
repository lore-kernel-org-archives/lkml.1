Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbXCTWJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbXCTWJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbXCTWJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:09:27 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:55668 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbXCTWJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:09:21 -0400
Message-ID: <46005B7D.3090701@cosmosbay.com>
Date: Tue, 20 Mar 2007 23:09:01 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Christoph Lameter <christoph@lameter.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of
 virt_to_slab(objp); nodeid = slabp->nodeid;
References: <20070320181235.77d28864.dada1@cosmosbay.com> <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org>
In-Reply-To: <20070320213218.GA13952@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 20 Mar 2007 23:09:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
>>> Is it possible virt_to_slab(objp)->nodeid being different from pfn_to_nid(objp) ?
>> It is possible the page allocator falls back to another node than 
>> requested. We would need to check that this never occurs.
> 
> The only way to ensure that would be to set a strict mempolicy.
> But I'm not sure that's a good idea -- after all you don't want
> to fail an allocation in this case.
> 
> But pfn_to_nid on the object like proposed by Eric should work anyways.
> But I'm not sure the tables used for that will be more often cache hot
> than the slab.

pfn_to_nid() on most x86_64 machines access one cache line (struct memnode).

Node 0 MemBase 0000000000000000 Limit 0000000280000000
Node 1 MemBase 0000000280000000 Limit 0000000480000000
NUMA: Using 31 for the hash shift.

On this example, we use only 8 bytes of memnode.embedded_map[] to find nid of 
all 16 GB of ram. On profiles I have, memnode is always hot (no cache miss on it).

While virt_to_slab() has to access :

1) struct page -> page_get_slab() (page->lru.prev) (one cache miss)
2) struct slab -> nodeid (one other cache miss)


So using pfn_to_nid() would avoid 2 cache misses.

I understand we want to do special things (fallback and such tricks) at 
allocation time, but I believe that we can just trust the real nid of memory 
at free time.


