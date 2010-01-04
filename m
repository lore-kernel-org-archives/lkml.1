Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549Ab0ADRWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab0ADRWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484Ab0ADRW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:22:27 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:39359 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab0ADRWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:22:25 -0500
Date: Mon, 4 Jan 2010 11:21:12 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V8 11/16] Generic support for this_cpu_cmpxchg
In-Reply-To: <20091222172436.GB12529@Krystal>
Message-ID: <alpine.DEB.2.00.1001041116010.7191@router.home>
References: <20091218222617.384355422@quilx.com> <20091218222653.560936448@quilx.com> <20091219144520.GA9134@Krystal> <alpine.DEB.2.00.0912220950030.12163@router.home> <20091222172436.GB12529@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009, Mathieu Desnoyers wrote:

> > > I am a bit concerned about the "generic" version of this_cpu_cmpxchg.
> > > Given that what LTTng needs is basically an atomic, nmi-safe version of
> > > the primitive (on all architectures that have something close to a NMI),
> > > this means that it could not switch over to your primitives until we add
> > > the equivalent support we currently have with local_t to all
> > > architectures. The transition would be faster if we create an
> > > atomic_cpu_*() variant which would map to local_t operations in the
> > > initial version.
> > >
> > > Or maybe have I missed something in your patchset that address this ?
> >
> > NMI safeness is not covered by this_cpu operations.
> >
> > We could add nmi_safe_.... ops?
> >
> > The atomic_cpu reference make me think that you want full (LOCK)
> > semantics? Then use the regular atomic ops?
>
> nmi_safe would probably make sense here.

I am not sure how to implement fallback for nmi_safe operations though
since there is no way of disabling NMIs.

> But given that we have to disable preemption to add precision in terms
> of trace clock timestamp, I wonder if we would really gain something
> considerable performance-wise.

Not sure what exactly you attempt to do there.

> I also thought about the design change this requires for the per-cpu
> buffer commit count pointer which would have to become a per-cpu pointer
> independent of the buffer structure, and I foresee a problem with
> Steven's irq off tracing which need to perform buffer exchanges while
> tracing is active. Basically, having only one top-level pointer for the
> buffer makes it possible to exchange it atomically, but if we have to
> have two separate pointers (one for per-cpu buffer, one for per-cpu
> commit count array), then we are stucked.

You just need to keep percpu pointers that are offsets into the percpu
area. They can be relocated as needed to the processor specific addresses
using the cpu ops.

> So given that per-cpu ops limits us in terms of data structure layout, I
> am less and less sure it's the best fit for ring buffers, especially if
> we don't gain much performance-wise.

I dont understand how exactly the ring buffer logic works and what you are
trying to do here.

The ringbuffers are per cpu structures right and you do not change cpus
while performing operations on them? If not then the per cpu ops are not
useful to you.

If you dont: How can you safely use the local_t operations for the
ringbuffer logic?

