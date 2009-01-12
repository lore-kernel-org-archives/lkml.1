Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbZALPWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbZALPWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZALPWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:22:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59756 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbZALPWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:22:14 -0500
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
From: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, dcm@acm.org,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <496872E0.9030007@s5r6.in-berlin.de>
References: <1231571060.3538.18.camel@localhost.localdomain>
	 <49686465.70501@s5r6.in-berlin.de>
	 <20090110011557.9d94e111.akpm@linux-foundation.org>
	 <496872E0.9030007@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 10:20:20 -0500
Message-Id: <1231773620.6365.21.camel@gaara.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-10 at 11:05 +0100, Stefan Richter wrote:
> Andrew Morton wrote:
...
> > Are we sure that all the other callers of free_layer() are freeing
> > zeroed objects?
> > 
> > It would be cleaner, safer and quite possibly faster to remove the
> > constructor altogether and use kmem_cache_zalloc() to allocate new
> > objects.
> 
> Yes, it sounds at least safer if the allocation path should be fixed up.
> 
> The zeroing was done in idr_remove_all() though since Kristian added it
> in 2.6.23, until 2.6.26 inclusive.
> 
> Kristian, was there a deeper reason to do it at deallocation instead of
> allocation, and does the reason still apply today?

Oh wow, that's a long time ago... The idr implementation caches unused,
zeroed out idr_layers in a free list in the idr struct for later use.
If no layers are in the cache, the idr_pre_get() function will allocate
one from the kmem_cache, which will zero out the layer in the ctor, and
then add it to the idr free list.  There are two other ways a layer can
go back to the free list: 1) when we free up a layer by freeing the
entries one by one, in which case the layer is already zeroed out, or in
idr_remove_all(), where we just zero it out brute force.  The problem
isn't about returning un-zeroed-out objects to the kmem cache, the
problem is returning them to the idr free list.

As far as I know the kmem_cache allocator is plenty fast and we could
just drop the entire free list and allocate out of the kmem cache
everytime in idr_pre_alloc().  If we're doing that, we should really,
please, just drop the stupid idr_pre_get() then idr_get_new() and retry
if fail scheme.  Every idr use I've seen could just do the whole thing
under a mutex and not worry about the awkward retry idea.  We don't have
to break API, we can just add a new function idr_alloc_new(idr, ptr, id,
gfp) that just does idr_pre_alloc() and then idr_get_new() under the
assumption that the client has taken the required mutex.  If the client
protects access to the idr using a mutex or spinlock, we can do
idr_pre_get() and idr_get_new() in succession without anybody else
grabbing that new layer from under us in the meantime.  Same thing for
idr_get_new_above(), of course.  Anyways... :)

cheers,
Kristian



