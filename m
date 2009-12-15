Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZLOPFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZLOPFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbZLOPFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:05:19 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:44890 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZLOPFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:05:17 -0500
Date: Tue, 15 Dec 2009 09:04:04 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V7 1/8] this_cpu_ops: page allocator conversion
In-Reply-To: <4B270841.2000203@kernel.org>
Message-ID: <alpine.DEB.2.00.0912150855040.16754@router.home>
References: <20091214220320.665065925@quilx.com> <20091214220339.160361197@quilx.com> <4B270841.2000203@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009, Tejun Heo wrote:

> Hello,
>
> On 12/15/2009 07:03 AM, Christoph Lameter wrote:
> >  static __meminit void zone_pcp_init(struct zone *zone)
> >  {
> > -	int cpu;
> > -	unsigned long batch = zone_batchsize(zone);
> > +	/* Use boot pagesets until we have the per cpu allocator up */
> > +	zone->pageset = &per_cpu_var(boot_pageset);
>
> Ummm... this scares me a little bit.  Before it was a pointer to
> statically allocated area which can be used from basically anywhere.
> Now, it's being initialized to a percpu pointer which won't be
> available before setup_per_cpu_areas() is complete and the above
> initialization takes place from setup_arch() which is before percpu
> initialization.  I don't think there's anything which would access
> page allocator between the two places, but it still seems a bit risky.
> Maybe it's better to keep the boot_pageset a static array?  Or am I
> misunderstanding something?

A static array would have to be dimensioned to NR_CPUS. That is one thing
we are trying to avoid.

The assignment of the pageset "percpu" pointer does not mean that the pcp
is usable. It must first be properly initialized through setup_pageset().

setup_pageset() is run for each cpu. zone->pageset is the same for all
cpus that is why it is in zone_pcp_init() and not in setup_pageset().

The boot pageset initialization was moved into __build_all_zonelists(). We
could move the zone->pageset initialization there too?



