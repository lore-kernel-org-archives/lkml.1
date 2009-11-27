Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbZK0THM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbZK0THM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 14:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbZK0THM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 14:07:12 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:50938 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbZK0THK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 14:07:10 -0500
Date: Sat, 28 Nov 2009 00:37:05 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [GIT PULL v6] hw-breakpoints: Rewrite on top of perf events v6
Message-ID: <20091127190705.GB18408@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com> <20091124094421.GA3468@in.ibm.com> <20091124101342.GB5570@elte.hu> <20091124132127.GA5355@in.ibm.com> <20091126055903.GB5649@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126055903.GB5649@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 06:59:05AM +0100, Frederic Weisbecker wrote:
> On Tue, Nov 24, 2009 at 06:51:27PM +0530, K.Prasad wrote:
> > On Tue, Nov 24, 2009 at 11:13:42AM +0100, Ingo Molnar wrote:
> > > 
> > > * K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> > > 
<snipped>
> > > > - Proposed migration of register allocation logic to arch-specific 
> > > > files from kernel/hw_breakpoint.c. This is best done early to help 
> > > > easy porting of code to other architectures (we have an active 
> > > > interest in bringing support for PPC64 and S390). If done later, it 
> > > > will entail additional effort in porting for each architecture.
> > > 
> > > I think the general direction should be towards librarized common 
> > > frameworks.
> > > 
> > > If an architecture wants to do something special it should either extend 
> > > the core code, or, if it's too weird to be added to the core, override 
> > > it via its own implementation.
> > > 
> > Given the feeling that the generic set of constraints in the re-written
> > kernel/hw_breakpoint.c cannot accommodate the needs of various
> > processors (LKML ref:20091117013959.GG5293@nowher) and that
> > the register allocation logic should move to arch-specific code, it is
> > best done early to help easy porting for other archs. For instance
> > there's already a port to PPC64 against the layered hw-breakpoint
> > (found here: 20090903183930.GA4590@in.ibm.com) and one from the
> > community for SH (20091018062558.GA20535@linux-sh.org).
> > 
> > If such code migration is done while porting of a new architecture, then
> > it involves making changes to every other arch on which it is previously
> > implemented (or workaround using #ifdef).
> 
> As I said, we can probably workaround it by keeping the most part
> in the generic code and delegate special arch things to arch
> constraints.
> 

I think the register_<> interfaces can become wrappers around functions
that do the following:

- arch_validate(): Validate request by invoking an arch-dependant
  routine. Proceed if returned valid.
- arch-specific debugreg availability: Do something like
  if (arch_hw_breakpoint_availabile())
	bp = perf_event_create_kernel_counter();

  perf_event_create_kernel_counter()--->arch_install_hw_breakpoint();

This way, all book-keeping related work (no. of pinned/flexible/per-cpu)
will be moved to arch-specific files (will be helpful for PPC Book-E
implementation having two types of debug registers). Every new
architecture that intends to port to the new hw-breakpoint
implementation must define their arch_validate(),
arch_hw_breakpoint_available() and an arch_install_hw_breakpoint(),
while the hw-breakpoint code will be flexible enough to extend itself to
each of these archs.

This implementation would be even superior (in terms of extensibility)
to even the older hw-breakpoint layer implementation (despite it providing
a working layer for x86 and PPC64).

> > > > - Fix ptrace bugs that potentially alter the semantics of ptrace.
> > > 
> > > Is there a specific list of these bugs?
> > > 
> > 
> > As pointed out in 20091111130207.GA5676@in.ibm.com and
> > 20091112042502.GA3145@in.ibm.com, ptrace requests can a) lose register
> > slots when modifying the breakpoint addresses and b) new implementation
> > assumes that every DR7 write to be preceded by a write on DR0-DR3 which
> > need not be true.
> 
> The a) case is going to be fixed.
> But the b) situation must be reported as a user mistake (which is what is
> done currently): -EINVAL, -EIO or whatever. Enabling a breakpoint without
> having given an address is a userland bug.
> 

b) need not be a user mistake always (except perhaps the first time). As I
mentioned here 20091112042502.GA3145@in.ibm.com, DR7 enable/disable
without a DR0-DR3 write can be done by the user through ptrace for
optimising the number of write operations (and hence ptrace syscalls).

Consider the following steps which is entirely valid (in mainline ptrace)
but which would fail if assumed that a DR0-DR3 write precedes a DR7 write:
i) Set address on DR0
ii) Enable bits corresponding to DR0 in DR7
iii) Disable DR0 bits in DR7
iv) Re-enable DR0 bits in DR7

Thanks,
K.Prasad

