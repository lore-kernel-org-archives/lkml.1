Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZINRR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZINRR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZINRRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:17:51 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44072 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZINRRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:17:51 -0400
Date: Mon, 14 Sep 2009 22:47:41 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/5] hw-breakpoints: Rewrite the hw-breakpoints layer on
	top of perf counters
Message-ID: <20090914171741.GA29531@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com> <1252571367-25876-4-git-send-email-fweisbec@gmail.com> <20090910142540.GA3512@in.ibm.com> <20090910185304.GD6421@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910185304.GD6421@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 08:53:06PM +0200, Frederic Weisbecker wrote:
> On Thu, Sep 10, 2009 at 07:55:40PM +0530, K.Prasad wrote:
> > On Thu, Sep 10, 2009 at 10:29:25AM +0200, Frederic Weisbecker wrote:
> > > This patch rebase the implementation of the breakpoints API on top of
> > > perf counters instances.
> > > 
> > > The core breakpoint API has changed a bit:
> > > 
> > > - register_kernel_hw_breakpoint() now takes a cpu as a parameter. For
> > >   now it doesn't support all cpu wide breakpoints but this may be
> > >   implemented soon.
> > 
> > Is there a reason why perf doesn't support counters effective on all
> > CPUs (and all processes)?
> > Atleast, it is vital for debugging aspects of hw-breakpoints...say to
> > answer "Who all did a 'write' on the kernel variable that turned corrupt", etc.
> > 
> > The implementation to iteratively register a breakpoint on all CPUs would
> > (as in trace_ksym.c) result in unclean semantics for the end user, when, a
> > register_kernel_<> request fails on a given CPU and all previously
> > registered breakpoints have to be reverted (but the user might have
> > received a few breakpoint triggers by then as a result of the successful
> > ones...i.e. register request fails, but still received 'some' output).
> 
> 
> (Please shrink the end of the message if you don't answer in further parts.
> I'm especially a bad example of what not to do :-)
> 
> Yeah it would be very convenient to have that. Is it possible considering
> the current internal design of perf?
>

It is already done by hw-breakpoints (which can also support cpumask) and
finding ways to re-use existing breakpoint code post perf integration should
do the trick.

There's an unconditional __perf_counter_init() and
perf_install_in_context() in register_user_hw_breakpoint_cpu() in
your patch which can rather be done after checks that ensure the
availability of a debug register on every CPU requested, update some
book-keeping variables and run on those CPUs (through IPIs?). By virtue
of being 'pinned' onto the CPU, I presume, they would remain enabled until
being removed through an explicit 'unregister' request - functionally
the same as the present register_kernel_hw_breakpoint() in -tip.

The other suggestion to enable/disable all breakpoints atomically (to
implement breakpoints on all CPUs), if possible, would be elegant too.

In any case, an iterative registration for all CPUs from the end-user
doesn't provide the abstraction that exists, and is undesirable. For
instance, it cannot handle cases where a CPU becomes online post
breakpoint registration (and such misses are expensive during
debugging).

Thanks,
K.Prasad



