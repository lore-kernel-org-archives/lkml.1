Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbZIVJcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbZIVJcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 05:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbZIVJcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 05:32:16 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51274 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbZIVJcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 05:32:14 -0400
Date: Tue, 22 Sep 2009 10:32:20 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Tejun Heo <tj@kernel.org>
Cc: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       sachinp@in.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/3] powerpc: Allocate per-cpu areas for node IDs for
	SLQB to use as per-node areas
Message-ID: <20090922093220.GB12254@csn.ul.ie>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie> <1253549426-917-2-git-send-email-mel@csn.ul.ie> <4AB813F3.8060102@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4AB813F3.8060102@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 09:01:55AM +0900, Tejun Heo wrote:
> Mel Gorman wrote:
> > diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
> > index 1f68160..a5f52d4 100644
> > --- a/arch/powerpc/kernel/setup_64.c
> > +++ b/arch/powerpc/kernel/setup_64.c
> > @@ -588,6 +588,26 @@ void __init setup_per_cpu_areas(void)
> >  		paca[i].data_offset = ptr - __per_cpu_start;
> >  		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
> >  	}
> > +#ifdef CONFIG_SLQB
> > +	/* 
> > +	 * SLQB abuses DEFINE_PER_CPU to setup a per-node area. This trick
> > +	 * assumes that ever node ID will have a CPU of that ID to match.
> > +	 * On systems with memoryless nodes, this may not hold true. Hence,
> > +	 * we take a second pass initialising a "per-cpu" area for node-ids
> > +	 * that SLQB can use
> > +	 */
> > +	for_each_node_state(i, N_NORMAL_MEMORY) {
> > +
> > +		/* Skip node IDs that a valid CPU id exists for */
> > +		if (paca[i].data_offset)
> > +			continue;
> > +
> > +		ptr = alloc_bootmem_pages_node(NODE_DATA(cpu_to_node(i)), size);
> > +
> > +		paca[i].data_offset = ptr - __per_cpu_start;
> > +		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
> > +	}
> > +#endif /* CONFIG_SLQB */
> >  }
> >  #endif
> 
> Eh... I don't know.  This seems too hacky to me. 

I've come around to this opinion as well. There are probably too many
other architectures and corners where this is gotten wrong and a more
fundamental fix is needed for SLQB to be able to use this hack.

> Why not just
> allocate pointer array of MAX_NUMNODES and allocate per-node memory
> there? 

That's what patch 1 from V1 did. I'll make it Patch 1 for V3.

> This will be slightly more expensive but I doubt it will be
> noticeable.  The only extra overhead is the cachline footprint for the
> extra array.
> 

I'll compare the vmlinux's to quantify the exact penalty but basically,
I don't think it can be avoided at this point.

Thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
