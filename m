Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbZLVRY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbZLVRY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 12:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZLVRY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 12:24:58 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:39269 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754282AbZLVRY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 12:24:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuoEADOQMEtGGNs5/2dsb2JhbACBStUchDME
Date: Tue, 22 Dec 2009 12:24:36 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V8 11/16] Generic support for this_cpu_cmpxchg
Message-ID: <20091222172436.GB12529@Krystal>
References: <20091218222617.384355422@quilx.com> <20091218222653.560936448@quilx.com> <20091219144520.GA9134@Krystal> <alpine.DEB.2.00.0912220950030.12163@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912220950030.12163@router.home>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:18:57 up 6 days,  1:37,  4 users,  load average: 0.83, 0.32,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> On Sat, 19 Dec 2009, Mathieu Desnoyers wrote:
> 
> > I am a bit concerned about the "generic" version of this_cpu_cmpxchg.
> > Given that what LTTng needs is basically an atomic, nmi-safe version of
> > the primitive (on all architectures that have something close to a NMI),
> > this means that it could not switch over to your primitives until we add
> > the equivalent support we currently have with local_t to all
> > architectures. The transition would be faster if we create an
> > atomic_cpu_*() variant which would map to local_t operations in the
> > initial version.
> >
> > Or maybe have I missed something in your patchset that address this ?
> 
> NMI safeness is not covered by this_cpu operations.
> 
> We could add nmi_safe_.... ops?
> 
> The atomic_cpu reference make me think that you want full (LOCK)
> semantics? Then use the regular atomic ops?

nmi_safe would probably make sense here.

But given that we have to disable preemption to add precision in terms
of trace clock timestamp, I wonder if we would really gain something
considerable performance-wise.

I also thought about the design change this requires for the per-cpu
buffer commit count pointer which would have to become a per-cpu pointer
independent of the buffer structure, and I foresee a problem with
Steven's irq off tracing which need to perform buffer exchanges while
tracing is active. Basically, having only one top-level pointer for the
buffer makes it possible to exchange it atomically, but if we have to
have two separate pointers (one for per-cpu buffer, one for per-cpu
commit count array), then we are stucked.

So given that per-cpu ops limits us in terms of data structure layout, I
am less and less sure it's the best fit for ring buffers, especially if
we don't gain much performance-wise.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
