Return-Path: <linux-kernel-owner+w=401wt.eu-S932914AbZKXNVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbZKXNVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbZKXNVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:21:39 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:55213 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050AbZKXNVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:21:38 -0500
Date: Tue, 24 Nov 2009 18:51:27 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [GIT PULL v6] hw-breakpoints: Rewrite on top of perf events v6
Message-ID: <20091124132127.GA5355@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com> <20091124094421.GA3468@in.ibm.com> <20091124101342.GB5570@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124101342.GB5570@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 11:13:42AM +0100, Ingo Molnar wrote:
> 
> * K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> 
> > 
> > Hi Frederic, Ingo,
> > 		Here are a few concerns (roughly in decreasing order of
> > priority) about the perf-events integrated hw-breakpoint feature.
> > 
> > - Freeze the breakpoint interfaces: Owing to the many 
> > current/potential users of hw-breakpoint feature it is important to 
> > provide a stable interface to the end-user. Changes underneath the 
> > interface can be done in due course in a manner that does not affect 
> > the end-user's behaviour or function signature. The present breakpoint 
> > interface requires parameters that are best embedded in a structure 
> > for extensibility.
> 
> Well we have PERF_TYPE_BREAKPOINT right now. I agree that it should be 
> finalized in some sort of extensible ABI real soon - we dont want (and 
> dont need to) add all features that might be possible in the future.
> 

It is not about implementing futuristic features, but provide an
interface which we know isn't going to change in the near future and
will be flexible to accommodate arch-specific requirements. For
instance the register_wide_hw_breakpoint() has an interface as below:

struct perf_event **
register_wide_hw_breakpoint(unsigned long addr,
                            int len,
                            int type,
                            perf_callback_t triggered,
                            bool active)

Given the diversity seen in debug registers across processors, it isn't
prudent to demand/limit the parameters required to those seen above.
It can be made a part of one of perf-events' structures (with some fields
in arch-specific structures) and the ABI can accept a pointer to one
such structure.

In this way it would be easy to bring-in arch-specific quirks without
altering the interface's signature.

> > - Proposed migration of register allocation logic to arch-specific 
> > files from kernel/hw_breakpoint.c. This is best done early to help 
> > easy porting of code to other architectures (we have an active 
> > interest in bringing support for PPC64 and S390). If done later, it 
> > will entail additional effort in porting for each architecture.
> 
> I think the general direction should be towards librarized common 
> frameworks.
> 
> If an architecture wants to do something special it should either extend 
> the core code, or, if it's too weird to be added to the core, override 
> it via its own implementation.
> 

Given the feeling that the generic set of constraints in the re-written
kernel/hw_breakpoint.c cannot accommodate the needs of various
processors (LKML ref:20091117013959.GG5293@nowher) and that
the register allocation logic should move to arch-specific code, it is
best done early to help easy porting for other archs. For instance
there's already a port to PPC64 against the layered hw-breakpoint
(found here: 20090903183930.GA4590@in.ibm.com) and one from the
community for SH (20091018062558.GA20535@linux-sh.org).

If such code migration is done while porting of a new architecture, then
it involves making changes to every other arch on which it is previously
implemented (or workaround using #ifdef).

> > - Fix ptrace bugs that potentially alter the semantics of ptrace.
> 
> Is there a specific list of these bugs?
> 

As pointed out in 20091111130207.GA5676@in.ibm.com and
20091112042502.GA3145@in.ibm.com, ptrace requests can a) lose register
slots when modifying the breakpoint addresses and b) new implementation
assumes that every DR7 write to be preceded by a write on DR0-DR3 which
need not be true.

> > - Bring either true system_wide support or atleast workaround the 
> > side-effects of iterative per-cpu registration using single atomic 
> > enablement of all per-cpu breakpoints. This can avoid stray exceptions 
> > which would get delivered to the end-user even for failed breakpoint 
> > requests.
> 
> That can certainly be done when users of such facilities emerge. Right 
> now we have perf and ptrace as the two users - are they affected by 
> these problems?
> 

ksym_tracer - the ftrace plugin (kernel/trace/trace_ksym.c) using
hw-breakpoints will be affected. Spurious exceptions due to partially
registered breakpoint requests can be dangerous here.

Thanks,
K.Prasad

