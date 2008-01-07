Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYAGTAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYAGTAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYAGS76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 13:59:58 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:47159 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339AbYAGS75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 13:59:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAH4FgkdMROHU/2dsb2JhbACBWKZM
Date: Mon, 7 Jan 2008 13:59:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, dipankar@in.ibm.com, ego@in.ibm.com,
       paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] Markers Implementation for Preempt RCU Boost
	Tracing
Message-ID: <20080107185954.GA16041@Krystal>
References: <20071231060911.GB6461@in.ibm.com> <20071231102045.GB30380@elte.hu> <y0modc4vr7a.fsf@ton.toronto.redhat.com> <20080102124734.GC11208@elte.hu> <20080102163309.GC11496@redhat.com> <20080102170157.GA11161@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080102170157.GA11161@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:56:31 up 65 days, 1 min,  5 users,  load average: 0.28, 0.18,
	0.18
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Frank Ch. Eigler <fche@redhat.com> wrote:
> 
> > > [...] this is a general policy matter. It is _so much easier_ to add 
> > > markers if they _can_ have near-zero overhead (as in 1-2 
> > > instructions). Otherwise we'll keep arguing about it, especially if 
> > > any is added to performance-critical codepath. (where we are 
> > > counting instructions)
> > 
> > The effect of the immediate-values patch, combined with gcc 
> > CFLAGS+=-freorder-blocks, *is* to keep the overhead at 1-2 
> > dcache-impact-free instructions.  The register saves, parameter 
> > evaluation, the function call, can all be moved out of line.
> 
> well, -freorder-blocks seems to be default-enabled at -O2 on gcc 4.2, so 
> we should already be getting that, right?
> 
> There's one thing that would make out-of-line tracepoints have a lot 
> less objectionable to me: right now the 'out of line' area is put to the 
> end of functions. That splinters the kernel image with inactive, rarely 
> taken areas of code - blowing up its icache footprint considerably. For 
> example sched.o has ~100 functions, with the average function size being 
> 200 bytes. At 64 bytes L1 cacheline size that's a 10-20% icache waste 
> already.

Hrm, I agree this can be a problem on architectures with more standard
associative icaches, but aren't most x86_64 machines (and modern x86_32)
using an instruction trace cache instead ? This makes the problem
irrelevant.

But I agree that, as Frank proposed, -freorder-blocks-and-partition
could help us in that matter for the architectures using an associative
L1 icache.

Mathieu

> 
> It's true that keeping the off-site code within the function keeps total 
> codesize slightly smaller, because the offsets (and hence the 
> conditional jumps) are thus 8 bit - but that's below 1% and the 
> cache-blow-up aspect is more severe in practice at 10-20%.
> 
> So it would be nice if we could collect all this offline code and stuff 
> it away into another portion of the kernel image. (or, into another 
> portion of the object file - which would still be good enough in 
> practice)
> 
> 	Ingo

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
