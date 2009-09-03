Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZICTXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZICTXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbZICTXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:23:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44205 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120AbZICTXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:23:18 -0400
Date: Thu, 3 Sep 2009 21:22:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>,
       Paul Mackerras <paulus@samba.org>, David Gibson <dwg@au1.ibm.com>
Subject: Re: [Patch 0/1] HW-BKPT: Allow per-cpu kernel-space Hardware
	Breakpoint requests
Message-ID: <20090903192257.GA25363@elte.hu>
References: <20090820172719.GA16499@in.ibm.com> <20090821142811.GF11098@elte.hu> <20090826033637.GB6245@nowhere> <20090826091642.GB7743@elte.hu> <20090826114954.GA6009@nowhere> <20090826180245.GA4438@in.ibm.com> <20090829134107.GD24123@elte.hu> <20090901063845.GB25221@in.ibm.com> <20090901235128.GE6108@nowhere> <20090903182810.GA3952@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903182810.GA3952@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* K.Prasad <prasad@linux.vnet.ibm.com> wrote:

> On Wed, Sep 02, 2009 at 01:51:33AM +0200, Frederic Weisbecker wrote:
> > On Tue, Sep 01, 2009 at 12:08:45PM +0530, K.Prasad wrote:
> > > On Sat, Aug 29, 2009 at 03:41:07PM +0200, Ingo Molnar wrote:
> > > > 
> > > > * K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > I am not sure if pmus can handle, (or want to handle) all the 
> > > > > intricacies involved with the hw-breakpoint layer [...]
> > > > 
> > > > Which are those intricacies? It's all rather straightforward 
> > > > register scheduling and reservation stuff - which perfcounters 
> > > > already solves in a very rich way.
> > > > 
> > > > 	Ingo
> > > 
> [edited]
> > > And post integration, in-kernel users like ptrace, kgdb* and xmon*
> > > which hitherto have interacted directly with the debug registers
> > > (through set_debugreg()/set_dabr()) should route their requests through the
> > > perf-layer. It is difficult to imagine ptrace's idempotent requests
> > > (through ptrace_<get><set>_debugreg()) having to pass through perf-layer
> > > (and becoming dependant on CONFIG_PERF_COUNTERS), not to mention the
> > > tricks required to synchronise signal generation timing with exception
> > > behaviour (especially on PPC64).
> > > * - Not converted to use hw-breakpoint layer yet
> > 
> > 
> > Actually, I see the perf layer here as a middle man between
> > 
> > - the very hardware stuff (dr[0-467]) handling, reading, writing, updating
> > - the core API (register_kernel_breakpoint(), register_user_breakpoint() etc..)
> > 
> > And this middle man can handle so much things on its own that the two above
> > gets utterly shrinked.
> > 
> > Also the ptrace thing is tricky in itself, and that can't be helped easily.
> > Because of the direct writing to debug registers done by POKE_USR,
> > whatever the current breakpoint API with or without perf integration, we still
> > need subterfuges to carry it.
> >
> 
> The reverse-dependancy this would create over perf (CONFIG_PERF) for the
> hw-breakpoint layer is an undesirable side-effect, and gives rise to
> atleast two immediate questions:
> 
> - Handling of requests for hw-breakpoint from users like ptrace when
>   CONFIG_PERF is not turned on

This is basically just a build/layering logistics question and it is 
solved easily - we could have a library mode for it.

> - Managing 'register scheduling and reservation' on architectures where
>   perf layer isn't ported. An inefficient way of handling this would be
>   to retain the existing register allocation code of hw-breakpoint for
>   such architectures - thereby artificially imposing arch-specific code
>   into generic stuff.

Minimally porting perf to enable a hw-breakpoints PMU extension is 
very easy in practice. For example on s390 it took just 15 lines of 
code:

  12310e9: [S390] Enable tick based perf_counter on s390.

    arch/s390/Kconfig                    |    1 +
    arch/s390/include/asm/perf_counter.h |    8 ++++++++
    tools/perf/perf.h                    |    6 ++++++
    3 files changed, 15 insertions(+), 0 deletions(-)

On FRV it took 38 lines (60% of which are boilerplace copyright 
notices), on PARISC 15 lines.

By far the most complexity is in factoring out the hw-breakpoint 
code itself - and that has to be done regardless of the register 
scheduling model.

> A solution here would be to detach parts of perf layer's code that 
> handle register scheduling and reservation (which I learn are in 
> kernel/perf_counter.c) into a separate entity (outside the ambit 
> of CONFIG_PERF) that can serve the needs of both hw-breakpoint and 
> perf thereby eliminating the two issues enumerated above.
>
> The tight coupling between the functions that perform register 
> scheduling (in kernel/perf_counter.c) and perf's data structures 
> is quite apparent and does suggest non-trivial amount of effort to 
> detach them into a layer of its own.
> 
> However this might be quite necessary in order to balance between 
> a desire to re-use the 'register scheduling and reservation' code 
> of perf-layer while not running into issues as above.
> 
> This, along with the framework (described in the previous mail) to 
> retain the hw-breakpoint's APIs + code interacting with debug 
> registers (including exception handling) would be a good 
> compromise.

I dont think the librarization is all that complex. It's very much 
desired, as we'd reuse an existing piece of infrastructure to 
implement another one - this is always good.

	Ingo
