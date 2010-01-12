Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379Ab0ALIOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0ALIOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024Ab0ALIOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:14:21 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:58629 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab0ALIOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:14:21 -0500
Date: Tue, 12 Jan 2010 13:44:12 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
Message-ID: <20100112081412.GD28425@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com> <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com> <20100112053559.GL5243@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112053559.GL5243@nowhere>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 06:36:00AM +0100, Frederic Weisbecker wrote:
> On Mon, Jan 11, 2010 at 05:55:53PM +0530, Srikar Dronamraju wrote:
> > +static const struct utrace_engine_ops uprobe_utrace_ops = {
> > +	.report_quiesce = uprobe_report_quiesce,
> > +	.report_signal = uprobe_report_signal,
> > +	.report_exit = uprobe_report_exit,
> > +	.report_clone = uprobe_report_clone,
> > +	.report_exec = uprobe_report_exec
> > +};
> 
> 
> So, as stated before, uprobe seems to handle too much standalone
> policies such as freeing on exec, always inherit on clone and never
> on fork. Such rules should be decided from uprobe clients not
> from uprobe itself and that makes it not enough flexible to
> be usable for now.

The freeing on exec is only housekeeping of uprobe data structures. And
probepoints are inherited only on CLONE_THREAD and not otherwise, simply
since the existing probes can be hit in the new thread's context. Not
sure what other policy you are hinting at.

> For example if we want it to be usable by perf, we have two ways:
> 
> - a trace event. Unfortunately, like I explained in a previous
>   mail, this doesn't seem to be a suitable interface for this
>   particular case.
> 
> - a performance monitoring unit, with the existing unified interface
>   struct pmu, usable by perf.
> 
> 
> Typically, to use it with perf toward a pmu, perf tools need to
> create a uprobe on perf process and activate its hook on the next exec.
> Thereafter, it's up to perf to decide if we inherit through clone
> and fork.

As mentioned above, the inheritance is only for threads. It should be
fairly easy to inherit probes on fork, and that can be made a perf based
policy decision.

> Here I fear utrace and perf are going to collide.

Utrace does not mandate any of the above concerns you've mentioned.
Utrace just provides callbacks at the said events and uprobes can be
tweaked to accommodate perf's requirements as possible, as feasible.

> See how could be the final struct pmu (we need to extend it
> to support utrace):
> 
> struct pmu {
> 	enable() -> called we schedule in a context where we want
>                     a uprobe to be active. Called very often
>         disable() -> the above opposite
> 
>         /* Not yet existing callbacks */
> 
>         hook_task() -> called when a process is created which
>                        we want to activate our hook
>                        would be typically called once on
>                        exec if we have set enable_on_exec
>                        and also on clone()/fork()
>                        if we want to inherit.
> }
> 
> 
> The above hook_task (could be divided in more precise callback events
> like hook_on_exec, hook_on_clone, etc...) would be needed by perf
> to drive correctly utrace and this is going to collide with utrace
> callbacks that notify execs and forks.
> 
> Probably utrace can be kept for all the utrace breakpoint signal
> handling an so. But I guess the rest can be implemented on top
> of a struct pmu and driven by perf like we did with hardware
> breakpoints re-implementation.
> 
> Just an idea.

Well, I wonder if perf can ride on utrace's callbacks for the
hook_task() for the clone/fork cases?

Ananth
