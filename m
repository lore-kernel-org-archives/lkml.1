Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbZJBRgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbZJBRgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZJBRgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:36:20 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:39570 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754357AbZJBRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:36:19 -0400
Date: Fri, 2 Oct 2009 13:30:58 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, mingo@elte.hu, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 12/20] Move early initialization of pagesets
 out of zone_wait_table_init()
In-Reply-To: <20091002141618.GO21906@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0910021326050.26189@gentwo.org>
References: <20091001212521.123389189@gentwo.org> <20091001212559.879284755@gentwo.org> <20091002141618.GO21906@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009, Mel Gorman wrote:

> On Thu, Oct 01, 2009 at 05:25:33PM -0400, cl@linux-foundation.org wrote:
> > Explicitly initialize the pagesets after the per cpu areas have been
> > initialized. This is necessary in order to be able to use per cpu
> > operations in later patches.
> >
>
> Can you be more explicit about this? I think the reasoning is as follows
>
> A later patch will use DEFINE_PER_CPU which allocates memory later in
> the boot-cycle after zones have already been initialised. Without this
> patch, use of DEFINE_PER_CPU would result in invalid memory accesses
> during pageset initialisation.

Nope. Pagesets are not statically allocated per cpu data. They are
allocated with the per cpu allocator.

The per cpu allocator is not initialized that early in boot. We cannot
allocate the pagesets then. Therefore we use a fake single item pageset
(like used now for NUMA boot) to take its place until the slab and percpu
allocators are up. Then we allocate the real pagesets.

> > -static __meminit void zone_pcp_init(struct zone *zone)
> > +/*
> > + * Early setup of pagesets.
> > + *
> > + * In the NUMA case the pageset setup simply results in all zones pcp
> > + * pointer being directed at a per cpu pageset with zero batchsize.
> > + *
>
> The batchsize becomes 1, not 0 if you look at setup_pageset() but that aside,
> it's unclear from the comment *why* the batchsize is 1 in the NUMA case.
> Maybe something like the following?
>
> =====
> In the NUMA case, the boot_pageset is used until the slab allocator is
> available to allocate per-zone pagesets as each CPU is brought up. At
> this point, the batchsize is set to 1 to prevent pages "leaking" onto the
> boot_pageset freelists.
> =====
>
> Otherwise, nothing in the patch jumped out at me other than to double
> check CPU-up events actually result in process_zones() being called and
> that boot_pageset is not being accidentally used in the long term.

This is already explained in a commment where boot_pageset is defined.
Should we add some more elaborate comments to zone_pcp_init()?


