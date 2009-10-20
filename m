Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbZJTGbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbZJTGbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZJTGbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:31:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37817 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbZJTGbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 02:31:41 -0400
Date: Tue, 20 Oct 2009 08:31:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Russ Anderson <rja@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Cliff Wickman <cpw@sgi.com>
Subject: Re: [PATCH 2/2] x86: UV hardware performance counter and topology
	access
Message-ID: <20091020063137.GH8550@elte.hu>
References: <20090930210531.GC12090@sgi.com> <20091001074630.GA6738@elte.hu> <20091019185813.GA6122@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019185813.GA6122@sgi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russ Anderson <rja@sgi.com> wrote:

> On Thu, Oct 01, 2009 at 09:46:30AM +0200, Ingo Molnar wrote:
> >
> > * Russ Anderson <rja@sgi.com> wrote:
> >
> > > Adds device named "/dev/uv_hwperf" that supports an ioctl interface
> > > to call down into BIOS to read/write memory mapped performance
> > > monitoring registers.
> >
> > That's not acceptable - please integrate this with perf events properly.
> > See arch/x86/kernel/cpu/perf_event.c for details.
> 
> These performance counters come from the UV hub and give a myriad of 
> information about the performance of the SSI system.  There is one Hub 
> per node in the system.  The information obtained from the hubs 
> includes:
> 
>  - Cache hit/miss/snoop information (on the QPI as well as across the NumaLink
>    fabric)
>  - Messaging bandwidth between various areas of the hub
>  - TLB and execution information about the GRU (hardware data copy assist)
>  - Detailed QPI and NumaLink traffic measurements
> 
> Unfortunately, the hub doesn't have dedicated registers for any 
> performance information.  There are many general purpose registers on 
> each hub that are available for use to collect performance 
> information. Most metrics require about 8 MMRs to be written in order 
> to set up the metric.

There's no requirement to have dedicated registers. Constraints can be 
expressed in a number of ways. If you restrict these events to per cpu 
events only (i.e. no per task) then you can even express per socket or 
per hub registers properly.

( There's no implementation yet for such type of events - but they've 
  been mentioned before in context of Nehalem 'uncore events' for 
  example. The restriction to per cpu events should be the only core 
  code change needed, and looks fairly trivial to do. )

> > Precisely what kinds of events are being exposed by the UV BIOS 
> > interface? Also, how does the BIOS get them?
> 
> On ia64 linux calls down into bios (SN_SAL calls) to get this 
> information. (See include/asm-ia64/linux/asm/sn/sn_sal.h) The UV bios 
> calls are similar functionality ported to x86_64.  The ia64 code has 
> topology and performance counter code intermixed (due to comon 
> routines).  It may be cleaner to break them into separate patches to 
> keep clear the separate issues.
> 
> SGI bios stores information about the systems topology to configure 
> the hardware before booting the kernel.  This includes information 
> about the entire NUMAlink system, not just the part of the machine 
> running an individual kernel.  This includes hardware that the kernel 
> has no knowledge of (such as shared NUMAlink metarouters).  For 
> example, a system split into two partitions has two unique kernels on 
> each half of the machine.  The topology interface provides information 
> to users about hardware the kernel does not know about.  (Sample 
> output below.)
> 
> For the performance counter, a call into the bios results in multiple 
> MMRs being written to get the requested information.  Due to the 
> complicated signal routing, we have made fixed "profiles" that group 
> related metrics together.  It is more than just a one-to-one mapping 
> of MMRs to bios calls.

The thing is, we dont want to expose this on the BIOS level _at all_. We 
want to read and interpret those MMRs directly.

> >                                                The BIOS should be 
> > left out of that - the PMU driver should know about and access 
> > hardware registers directly.
> 
> That would significantly increase the amount of kernel code needed to 
> access the chipset performance counters.  It would also require more 
> low level hardware information to be passed to the kernel (such as 
> information to access share routers) and additional kernel code to 
> calculate topology information (that bios has already calculated). The 
> intent of the SN_SAL calls on ia64 was to simplify the kernel code.

The goal is to simplify the end result. Experience of the past 30 years 
tells us that shifting complexity from the kernel into the BIOS does not 
simplify the end result.

You could start out with a single straightforward MMR and see what it 
takes to expose it via perf.

Exposing system topology information and then mapping events to them and 
enumerating them sounds interesting from a tooling POV as well - this is 
something that people want to see and want to measure - not just on SGI 
UV systems. We want to mix that with various sources of system fault 
information as well (machine check events, etc.) - based on a topology 
as well - so there's wider synergy possible.

	Ingo
