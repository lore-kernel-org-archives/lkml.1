Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbYCCNqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbYCCNqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 08:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYCCNq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 08:46:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbYCCNq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 08:46:26 -0500
Date: Mon, 3 Mar 2008 14:46:22 +0100
From: Nick Piggin <npiggin@suse.de>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [rfc][patch 3/3] use SLAB_ALIGN_SMP
Message-ID: <20080303134622.GD13138@wotan.suse.de>
References: <20080303093449.GA15091@wotan.suse.de> <20080303093624.GC15091@wotan.suse.de> <47CBCAB0.2040604@cosmosbay.com> <20080303124142.GB13138@wotan.suse.de> <47CBF683.10201@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47CBF683.10201@cosmosbay.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 02:00:51PM +0100, Eric Dumazet wrote:
> Nick Piggin a écrit :
> >On Mon, Mar 03, 2008 at 10:53:52AM +0100, Eric Dumazet wrote:
> >  
> >>Nick Piggin a écrit :
> >>    
> >>>Use SLAB_SMP_ALIGN in a few places.
> >>>
> >>> 
> >>>      
> >>I dont understand why you added SLAB_SMP_ALIGN, without removing 
> >>SLAB_HWCACHE_ALIGN on these places.
> >>    
> >
> >Because I thought that in most of the cases, we also want some cacheline
> >alignment on UP systems as well because we care about the layout of the
> >structure WRT the cachelines for the mandatory/capacity miss cases, as
> >well as wanting to avoid false sharing misses on SMP.
> >
> >Actually I didn't think _too_ hard about them, possibly some could be
> >removed. But the problem is that these things do require careful
> >thought so I should not change them unless I have done that ;)
> >
> >I guess there are some basic guidelines -- if size is a problem (ie if
> >there can be lots of these structures), then that is going to be a
> >factor; if the total pool of objects is likely to be fairly densely
> >resident in cache, then it will start to favour dense packing rather
> >than good alignment.
> >
> >  
> Well, if a kmem_cache_create() is used, this is probably because number 
> of objects can be large, so kmalloc() power-of-two granularity could 
> waste lot of ram.

Or because you want explicit control over alignment ;)

 
> But yes, you are right that SLAB_SMP_ALIGN doesnt imply SLAB_HWCACHE_ALIGN
> 
> - SMP_ALIGN is a hint about false sharing (when object contains a refcnt 
> for example), that is a concern only if
> 
> num_possible_cpus() > 1
> 
> While HWCACHE_ALIGN might be a hint saying :
> - The writer carefully designed the structure so that max performance is 
> obtained when all objects starts on a cache line boundary, even on 
> Uniprocessor.

Yes. In which case, we are also happy if the objects are small if they
share cachelines (so long as they are still nicely aligned, which slub
currently does not do)... unless SMP_ALIGN is set, of course.

 
> But I suspect some uses of HWCACHE_ALIGN are not a hint but a strong 
> requirement.
> 
> Maybe we need to use three flags to separate the meanings ?
> 
> 
> SLAB_HINT_SMP_ALIGN
> SLAB_HINT_HWCACHE_ALIGN
> SLAB_HWCACHE_ALIGN /* strong requirement that two objects dont share a 
> cache line */

Possibly, but I'm beginning to prefer that strong requirements should
request the explicit alignment (they can even use cache_line_size() after
Pekka's patch to make it generic). I don't like how the name implies
that you get a guarantee, however I guess in practice people are using it
more as a hint (or because they vaguely hope it makes their code run
faster :))

So I wouldn't be adverse to a rename...
