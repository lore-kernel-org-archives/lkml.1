Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbYCGCyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbYCGCyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 21:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYCGCyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 21:54:39 -0500
Received: from relay2.sgi.com ([192.48.171.30]:50159 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750771AbYCGCyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 21:54:37 -0500
Date: Thu, 6 Mar 2008 18:54:19 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
       dada1@cosmosbay.com
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
In-Reply-To: <20080307023223.GD21185@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803061841220.29959@schroedinger.engr.sgi.com>
References: <20080303201701.GF8974@wotan.suse.de>
 <Pine.LNX.4.64.0803031315160.4131@schroedinger.engr.sgi.com>
 <20080305000637.GA1510@wotan.suse.de> <20080304.161003.129716254.davem@davemloft.net>
 <Pine.LNX.4.64.0803051257030.30742@schroedinger.engr.sgi.com>
 <20080306025758.GB27150@wotan.suse.de> <Pine.LNX.4.64.0803061453360.16212@schroedinger.engr.sgi.com>
 <20080307022355.GB21185@wotan.suse.de> <Pine.LNX.4.64.0803061825120.29527@schroedinger.engr.sgi.com>
 <20080307023223.GD21185@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It doesn't say start of cache line. It says align them *on* cachelines.
> 2 32 byte objects on a 64 byte cacheline are aligned on the cacheline.
> 2.67 24 bytes objects on a 64 byte cacheline are not aligned on the
> cacheline.

2 32 byte objects means only one is aligned on a cache line.

Certainly cacheline contention is reduced and performance potentially 
increased if there are less objects in a cacheline.

The same argument can be made of aligning 8 byte objects on 32 byte 
boundaries. Instead of 8 objects per cacheline you only have two. Why 8?

Isnt all of this a bit arbitrary and contrary to the intend of avoiding 
cacheline contention?

The cleanest solution to this is to specify the alignment for each 
slabcache if such an alignment is needed. The alignment can be just a 
global constant or function like cache_line_size(). 

I.e. define

	int smp_align;

On bootup check the number of running cpus and then pass smp_align as
the align parameter (most slabcaches have no other alignment needs, if 
they do then we can combine these using max).

If we want to do more sophisticated things then lets have function that
aligns the object on power of two boundaries like SLAB_HWCACHE_ALIGN does
now:

	sub_cacheline_align(size)

Doing so will make it more transparent as to what is going on and which 
behavior we want. And we can get rid of SLAB_HWCACHE_ALIGN with the weird
semantics. Specifying smp_align wil truly always align on a cacheline 
boundary if we are on an SMP system.

