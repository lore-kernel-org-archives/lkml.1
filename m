Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbZFRIWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbZFRIWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 04:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbZFRIWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 04:22:33 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:19776 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZFRIWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 04:22:32 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH RFC] softirq: fix ksoftirq starved
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4A39B25C.2040801@cn.fujitsu.com>
References: <20090511151353.GA14391@Krystal>
	 <4A094677.5090900@cn.fujitsu.com> <4A0BF82A.2070208@cn.fujitsu.com>
	 <20090514124013.GC21241@Krystal>
	 <alpine.DEB.2.00.0905140926010.30591@gandalf.stny.rr.com>
	 <4A0CCB2E.10202@cn.fujitsu.com>
	 <6A70E08D65F749FA92475F8BA1F9510D@zhaoleiwin>
	 <20090519082435.GB15286@elte.hu> <4A31BF1D.1050400@cn.fujitsu.com>
	 <4A32251C.8060001@cn.fujitsu.com> <20090617145333.GD6846@elte.hu>
	 <4A39B25C.2040801@cn.fujitsu.com>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 10:22:35 +0200
Message-Id: <1245313355.13761.23103.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-18 at 11:19 +0800, Lai Jiangshan wrote:
> Ingo Molnar wrote:
> > * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> > 
> >> --- a/kernel/sched.c
> >> +++ b/kernel/sched.c
> >> @@ -5307,6 +5307,7 @@ need_resched:
> >>  	release_kernel_lock(prev);
> >>  need_resched_nonpreemptible:
> >>  
> >> +	schedule_softirq_check();
> >>  	schedule_debug(prev);
> > 
> > hm, this slows down the scheduler fast-path ...
> > 
> > 	Ingo
> > 
> > 
> 
> It's true. But:
> 
> The overheads are:
> 
> Overhead-A: the function call statement "schedule_softirq_check();"
> It can be gotten rid off by a macro or inline function.
> 
> Overhead-B: __get_cpu_var() and the test statement.
> 
> Overhead-C: do_softirq()
> In my patch, we test a variable and then call do_softirq() when
> the variable is true. do_softirq() can be called from process
> context or from schedule() or by any other ways, but it must be
> called and avoids starvation in this condition.
> So we need pay this overhead. It is no worse than before.
> 
> Is it a critical thing when it slows down the scheduler fast-path
> because of the "Overhead-B"?
> 
> Or I misunderstand something?

I think its overhead-c, actually calling do_softirq from the schedule()
path that a really whacky idea.

Why not make whoemever needs the softirq to happen (eg. network ops)
poll this flag, so that regular RT processes don't get penalized by
random softirq muck?

It seems to me this approach basically gives softirqs higher prio than
RT processes, not something to be done lightly.

