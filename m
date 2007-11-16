Return-Path: <linux-kernel-owner+w=401wt.eu-S1762844AbXKPSaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762844AbXKPSaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbXKPSaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:30:13 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:63399 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbXKPSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:30:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HADtwPUdMROHU/2dsb2JhbACBXw
Date: Fri, 16 Nov 2007 13:25:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
       gregkh@suse.de, akpm@osdl.org, linux-kernel@vger.kernel.org,
       perfmon2-devel@lists.sourceforge.net, perfmon@napali.hpl.hp.com,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: PMC core internal API design
Message-ID: <20071116182506.GA23446@Krystal>
References: <20071107003454.GA13374@kroah.com> <20071109120627.60ec9ab4.akpm@linux-foundation.org> <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <20071113183239.GF4319@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071113183239.GF4319@frankl.hpl.hp.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:00:46 up 12 days, 23:06,  5 users,  load average: 1.94, 2.16,
	1.85
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephane Eranian (eranian@hpl.hp.com) wrote:
> Hello,
> 
> On Tue, Nov 13, 2007 at 04:17:18PM +0100, Robert Richter wrote:
> > On 10.11.07 21:32:39, Andi Kleen wrote:
> > > It would be really good to extract a core perfmon and start with
> > > that and then add stuff as it makes sense.
> > > 
> > > e.g. core perfmon could be something simple like just support
> > > to context switch state and initialize counters in a basic way 
> > > and perhaps get counter numbers for RDPMC in ring3 on x86[1]
> > 
> > Perhaps a core could provide also as much functionality so that
> > Perfmon can be used with an *unpatched* kernel using loadable modules?
> > One drawback with today's Perfmon is that it can not be used with a
> > vanilla kernel. But maybe such a core is by far too complex for a
> > first merge.
> > 
> Note that I am not against the gradual approach such as:
> 	- system-wide only counting

(jumping in late in the game)

Linux Trace Toolkit Next Generation would _happily_ use global PMC
counters, but I would prefer to interact with an internal kernel API
rather than being required to start/stop counters from user-space. There
is a big precision loss involved in having to start things from
userspace.

Ideally, this API would manage access to available PMCs and even use the
same counters for both system-wide tracing/profiling done at the same
time as user-space profiling. This would however involve having a
wrapper around both user-space and kernel-space performance counter
reads, which is fine with me. I would suggest that user-space still go
through a system call for this, since this is available a early boot,
before the filesystem is mounted.

This API could offer to in-kernel architecture _independent_ PMC control
interface to :
- list available PMCs
  - That would involve mapping the common PMCs to some generic
    identifier
- attach to these PMCs, with a certain priority

We could call a single connexion to a PMC a "virtual PMC". All PMC
accesses should then be done through this internally managed structure
(giving callbacks to be called after a certain count, reads, stop...).
We could have virtual PMCs that are : system wide, or per thread.

As a starting point, we could limit one virtual PMC attached to a
physical PMC at a given time. Later, we could add support for multiple
virtual PMCs connected to a single physical PMC. The priorities could be
used to kick out the PMC users with lower priorities (that involves that
a PMC read could fail!).

Then, to get interrupts or signals upon PMC overflow, we could manage
each physical PMC like a timer, using the lowest requested value for the
next time were are to be awakened. Some logic would have to be added to
the pmc read operation to get the "real" expected value, but this is
nothing difficult.

Those were the ideas I had last OLS after hearing the talk about
perfmon2. I hope they can be useful. If things need to be clarified, I
will gladly discuss them further.

Mathieu

P.S. : the rest of the feature list _should_ be easy to implement on top
of this internal architecture.

> 	- per-thread counting
> 	- user-level sampling support
> 	- in-kernel sampling buffer support
> 	- in-kernel customizable sampling buffer formats via modules
> 	- event set multiplexing
> 	- PMU description modules
> 
> It would obvisouly cause a lot of troubles to existing perfmon libraries and
> applications (e.g. PAPI). It would also be fairly tricky to do because you'd 
> have to make sure that in the beginning, you leave enough flexiblity such that
> you can add the rest while maintaining total backward compatibility. But given
> that we already have the full solution, it could just be a matter of dropping
> features without disrupting the user level API. Of course there would be a bigger
> burden on the maintainer because he would have two trees to maintain but I think
> that is already commonplace in many of the kernel-related projects.
> 
> Let's take a simple example. The set of syscalls necessary to control a system-wide
> monitoring session is exactly the same as for a per-thread session. The difference is
> just a flag when the session is created. Thus, we could keep the same set of syscalls,
> but only accept system-wide sessions. Later on, when we add per-thread, we would just
> have to expose the per-thread session flag.
> 
> Having said that, does not mean that this is necessarily what we will do. I am just
> try to present my understanding of the comments from Andrew, Andi and others.
> 
> I think that going with a kernel module will not address the 'complexity/bloat' perception
> that some people have. There is a logic to that, I did not just wakeup one day saying
> 'wouldn't it be cool to add set multiplexing?'. There was a true need expressed by users or
> developers and it was justfied by what the hardware offered then. This unfortunately still
> stands today. I admit that justification is not necessarily spelled out clearly in the code. So
> I understand most of those worries and I am trying to figure out how we could best address them.
> 
> -- 
> -Stephane
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
