Return-Path: <linux-kernel-owner+w=401wt.eu-S934069AbXCTUUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069AbXCTUUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934066AbXCTUUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:20:25 -0400
Received: from graphe.net ([209.204.138.32]:51139 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934064AbXCTUUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:20:24 -0400
X-Greylist: delayed 1528 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2007 16:20:24 EDT
Date: Tue, 20 Mar 2007 12:54:45 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of
 virt_to_slab(objp); nodeid = slabp->nodeid;
In-Reply-To: <20070320181235.77d28864.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703201248530.12664@graphe.net>
References: <20070320181235.77d28864.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007, Eric Dumazet wrote:

> 
> I noticed on a small x86_64 NUMA setup (2 nodes) that cache_free_alien() is very expensive.
> This is because of a cache miss on struct slab.
> At the time an object is freed (call to kmem_cache_free() for example), the underlying 'struct slab' is not anymore cache-hot.
> 
> struct slab *slabp = virt_to_slab(objp);
> nodeid = slabp->nodeid; // cache miss
> 
> So we currently need slab only to lookup nodeid, to be able to use the cachep cpu cache, or not.
> 
> Couldn't we use something less expensive, like pfn_to_nid() ?

Nodeid describes the node that the slab was allocated for which may 
not be equal to the node that the page came from. But if GFP_THISNODE is 
used then this should always be the same. That those two nodeid are 
different was certainly frequent before the GFP_THISNODE work went in. Now 
it may just occur in corner cases. Perhaps during bootup on 
some machines that boot with empty nodes. I vaguely recall a powerpc 
issue.

> Is it possible virt_to_slab(objp)->nodeid being different from pfn_to_nid(objp) ?

It is possible the page allocator falls back to another node than 
requested. We would need to check that this never occurs.

If we are sure then we could drop the nodeid field completely.

