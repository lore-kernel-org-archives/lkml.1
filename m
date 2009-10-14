Return-Path: <linux-kernel-owner+w=401wt.eu-S1760580AbZJNBu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbZJNBu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 21:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759253AbZJNBu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 21:50:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:40789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758942AbZJNBu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 21:50:28 -0400
Message-ID: <4AD52E37.80209@kernel.org>
Date: Wed, 14 Oct 2009 10:49:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev@lists.ozlabs.org
Subject: Re: New percpu & ppc64 perfs
References: <1255478358.2347.28.camel@pasglop>
In-Reply-To: <1255478358.2347.28.camel@pasglop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 01:49:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Benjamin.

Benjamin Herrenschmidt wrote:
> So I found (and fixed, though the patch isn't upstream yet) the problem
> that was causing the new percpu to hang when accessing the top of our
> vmalloc space.
> 
> However, I have some concerns about that choice of location for the
> percpu datas.
> 
> Basically, our MMU divides the address space into "segments" (of 256M or
> 1T depending on your processor capabilities) and those segments are SW
> loaded into a relatively small (64 entries) SLB buffer.
> 
> Thus, by moving the per-cpu to the end of the vmalloc space, you
> essentially make it use a different segment from the rest of the vmalloc
> space, which will overall degrade performances by increasing pressure on
> the SLB.
> 
> It would be nicer if we could provide an arch function to provide a
> "preferred" location for the per-cpu data.
> 
> I can easily cook up a patch but wanted to discuss that with you first.
> Any reason why we would keep it within vmalloc space for example ? IE. I
> could move VMALLOC_END to below the per-cpu reserved areas, or are they
> subject to expansion past boot time ?
> 
> Also, how big can they be ? Ie, will the top of the first 256M segment
> good enough or that will risk blowing out of space ? In general,
> machines with 256M segments won't have more than 64 or maybe 128 CPUs I
> believe. Bigger machines will have CPUs that support 1T segments.

Hmm... I don't think 256M segment will be enough.  Percpu area layout
will follow how numa memory is laidd out.  For example, if a machine
has 4 nodes (each one with one cpu) and memory for each node is 1G in
size and 1G apart, the first chunk will be embedded in the linear
mapping area (normal kernel addressable area) and each unit in the
chunk will be apart by between 1G and 2G.  As the first chunk is
embedded in the linear mapped area, this shouldn't cause any extra
overhead.

The vmalloc area is used when the first chunk is filled and another
chunk need to be allocated.  From the second chunk on, vmalloc area is
used to preserve the layout of the first chunk.  ie. Each of them will
span across 8G bytes (they will overlap tho, so even with many dynamic
chunks vm usage will only be slightly over 8G).

The reason why vmalloc area from the top is used is that I didn't want
this congruent allocation to compete with normal vmalloc allocations.
Depending on the numa layout, competition between linear allocation
and congruent allocation may create many unnecessary holes.

For 256M segment, I don't think much can be done but for 1T segment,
just limiting vmalloc area size to 1T should do the trick, no?

Thanks.

-- 
tejun
