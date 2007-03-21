Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbXCUG1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbXCUG1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbXCUG1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:27:35 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:47653 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbXCUG1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:27:34 -0400
Message-ID: <4600D04B.6030305@cosmosbay.com>
Date: Wed, 21 Mar 2007 07:27:23 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Christoph Lameter <christoph@lameter.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of
 virt_to_slab(objp); nodeid = slabp->nodeid;
References: <20070320181235.77d28864.dada1@cosmosbay.com> <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org> <46005B7D.3090701@cosmosbay.com> <Pine.LNX.4.64.0703201715110.17799@graphe.net>
In-Reply-To: <Pine.LNX.4.64.0703201715110.17799@graphe.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 21 Mar 2007 07:27:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> On Tue, 20 Mar 2007, Eric Dumazet wrote:
> 
>> I understand we want to do special things (fallback and such tricks) at
>> allocation time, but I believe that we can just trust the real nid of memory
>> at free time.
> 
> Sorry no. The node at allocation time determines which node specific 
> structure tracks the slab. If we fall back then the node is allocated 
> from one node but entered in the node structure of another. Thus you 
> cannot free the slab without knowing the node at allocation time.

I think you dont understand my point.

When we enter kmem_cache_free(), we are not freeing a slab, but an object, 
knowing a pointer to this object.

The fast path is to put the pointer, into the cpu array cache. This object 
might be given back some cycles later, because of a kmem_cache_alloc() : No 
need to access the two cache lines (struct page, struct slab)

This fast path could be entered checking the node of the page, which is 
faster, but eventually different from the virt_to_slab(obj)->nodeid. Do we 
care ? Definitly not : Node is guaranted to be correct.

Then, if we must flush the cpu array cache because it is full, we *may* access 
the slabs of the objects we are flushing, and then check the 
virt_to_slab(obj)->nodeid to be able to do the correct thing.

Fortunatly, flushing cache array is not a frequent event, and the cost of 
access to cache lines (truct page, struct slab) can be amortized because 
several 'transfered or freed' objects might share them at this time.


Actually I had to disable NUMA on my platforms because it is just overkill and 
slower. Maybe its something OK for very big machines, and not dual nodes 
Opterons ? Let me know so that I dont waste your time (and mine)


Thank you
