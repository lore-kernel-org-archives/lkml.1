Return-Path: <linux-kernel-owner+w=401wt.eu-S1763634AbZDCOPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763634AbZDCOPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZDCOPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:15:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39869 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZDCOPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:15:37 -0400
Date: Fri, 3 Apr 2009 16:15:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
       Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
       Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tracing tree with the parisc
	tree
Message-ID: <20090403141501.GE8875@elte.hu>
References: <20090401113740.7f425e02.sfr@canb.auug.org.au> <20090401175033.GE1443@bombadil.infradead.org> <20090402223205.e4ab7b5e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402223205.e4ab7b5e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Kyle,
> 
> On Wed, 1 Apr 2009 13:50:34 -0400 Kyle McMartin <kyle@mcmartin.ca> wrote:
> >
> > What's the optimal way to sort out multiple branches in this 
> > tree? Apparently Andrew is cross with me because the rtc-parisc 
> > branch didn't get picked up... Should I put a list of branches 
> > in my kernel.org public_html or something?
> 
> I am not quite sure what you are getting at.  If you have multiple 
> trees (or branches in a tree), I can merge them separately into 
> linux-next - just tell me what they are.

One solution, when there are lots of branches, is what we use in the 
-tip tree to auto-integrate the auto-*-next output branches.

It works like this:

For each output auto-*-next tree (there's 19 at the moment) there's 
a special file under the tip:tip/.tip/auto-branches/ directory.

Say the auto-tracing-next tree is represented via a list of topic 
branches in .tip/auto-branches/auto-tracing-next:

    tracing/core
    tracing/urgent
    tracing/ftrace
    tracing/mmiotrace
    tracing/sysprof
    tracing/nmisafe
    tracing/stack-tracer
    tracing/fastboot
    tracing/markers
    tracing/ring-buffer
    tracing/pipe
    tracing/tracepoints
    tracing/core-v2
    tracing/fastboot-v2
    tracing/core-v3
    tracing/function-return-tracer
    tracing/branch-tracer
    
    # dont know yet:
    # tracing/dump-tracer
    
    tracing/options
    tracing/profiling
    tracing/power-tracer
    tracing/powerpc

    # broken right now:
    # tracing/hw-branch-tracing

    tracing/function-graph-tracer
    tracing/blktrace
    tracing/graph-tracer
    tracing/docs
    tracing/kmemtrace
    tracing/kmemtrace2
    tracing/printk
    tracing/doc
    tracing/syscalls
    tracing/syscalls
    tracing/filters
    tracing/tasks
    tracing/kprobes
    tracing/hw-breakpoints
    tracing/blktrace-v2
    tracing/kmemtrace-v2

When things are quiet and there are no known regressions, i type:

  tip-integrate auto-tracing-next

and soon afterwards a new tree comes out. I dont have to do any 
manual integration, it's all automated, including the cached 
resolution of conflicts. If a new conflict comes up i get a shell 
prompt, fix the conflict, commit it and the integration continues.

If i'm happy with the end result i push it out.

As you can see it above, branches can be annotated and commented 
out. For example this branch:

    # broken right now:
    #tracing/hw-branch-tracing

was causing boot crashes so we excluded it from the 
auto-tracing-next output and linux-next wont crash due to these 
known and under-development problems.

Another branch:

    # dont know yet:
    # tracing/dump-tracer

Is holding commits i'm not sure we want to push upstream yet, so we 
dont push it into linux-next. (linux-next is meant for items that 
are intended for the next cycle.)

There's a similar list of topics for the other integration trees:

 auto-core-next         auto-latest                     auto-stackprotector-next
 auto-cpus4096-next     auto-oprofile-next              auto-timers-next
 auto-fastboot-next     auto-perfcounters-next          auto-tracing-next
 auto-generic-ipi-next  auto-rt-next                    auto-warnings-next
 auto-genirq-next       auto-safe-poison-pointers-next  auto-x86-next
 auto-iommu-next        auto-sched-next
 auto-kmemcheck-next    auto-sparseirq-next

Over 100 topic branches are active typically just before the merge 
window - they go down to below 10 after the merge window. So there's 
a constant ebb and flow in topic activity.

We also have a "tip-integrate-all" script that runs through all the 
-next branches and integrates them.

These tools can be found under the -tip:.tip/bin/ directory - 
there's currently 68 utility scripts there currently, to solve 
various probems all around integration tree maintenance, problems 
which are often not solved by the base Git toolset adequately.

Hope this helps,

	Ingo
