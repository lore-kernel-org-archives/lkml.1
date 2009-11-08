Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbZKHVAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbZKHVAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 16:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbZKHVAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 16:00:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:49882 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078AbZKHVAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 16:00:19 -0500
Subject: Re: [PATCH 5/6] hw-breakpoints: Arbitrate access to pmu following
 registers constraints
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <19186.45014.502448.698606@cargo.ozlabs.ibm.com>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com>
	 <1257275474-5285-6-git-send-email-fweisbec@gmail.com>
	 <19186.45014.502448.698606@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 07:56:21 +1100
Message-ID: <1257713781.13611.284.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-05 at 21:58 +1100, Paul Mackerras wrote:
> Frederic Weisbecker writes:
> 
> > Allow or refuse to build a counter using the breakpoints pmu following
> > given constraints.
> 
> As far as I can see, you assume each CPU has HBP_NUM breakpoint
> registers which are all interchangeable and can all be used either for
> data breakpoints or instruction breakpoints.  Is that accurate?
> 
> If so, we'll need to extend it a bit for Power since we have some CPUs
> that have one data breakpoint register and one instruction breakpoint
> register.  In general on powerpc the instruction and data breakpoint
> facilities are separate, i.e. we have no registers that can be used
> for either.

Additionally, we have more fancy facilities that I don't see exposed at
all through this interface (we are building an ad-hoc ptrace based
interface today so that gdb can make use of them) and we have one guy
with crazy constraints that we don't know yet how to deal with:

Among others features:

 - Pairing of two data or instruction breakpoints to create a ranges
breakpoint
 - Data value compare option
 - Instruction value compare option

And now the crazy constraints:

 - On one embedded core at least we have a case where the core has 4
threads, but the data (4) and instruction (2) breakpoint registers are
shared. The 'enable' bits are split so a given data breakpoint can be
enabled only on some HW threads but that's about it.

I'm not sure if there's a realistic way to handle the later constraint
though other than just not allowing use of the HW breakpoint function on
those cores at all.

Ben.

> > +static void toggle_bp_slot(struct perf_event *bp, bool enable)
> > +{
> > +	int cpu = bp->cpu;
> > +	unsigned int *nr;
> > +	struct task_struct *tsk = bp->ctx->task;
> > +
> > +	/* Flexible */
> > +	if (!bp->attr.pinned) {
> > +		if (cpu >= 0) {
> > +			nr = &per_cpu(nr_bp_flexible, cpu);
> > +			goto toggle;
> > +		}
> > +
> > +		for_each_online_cpu(cpu) {
> > +			nr = &per_cpu(nr_bp_flexible, cpu);
> > +			goto toggle;
> 
> ...
> 
> > +toggle:
> > +	*nr = enable ? *nr + 1 : *nr - 1;
> > +}
> 
> This won't do what I think you want.  In the case where
> !bp->attr.pinned and cpu == -1, it will only update the count for the
> first online cpu, not all of them.
> 
> Paul.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


