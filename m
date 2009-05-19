Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbZESIY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbZESIY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbZESIYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:24:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55308 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbZESIYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:24:49 -0400
Date: Tue, 19 May 2009 10:24:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zhaolei <zhaolei@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, laijs@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH v4] ftrace: add a tracepoint for
	__raise_softirq_irqoff()
Message-ID: <20090519082435.GB15286@elte.hu>
References: <alpine.DEB.2.00.0905111003280.14976@gandalf.stny.rr.com> <20090511142734.GA12722@Krystal> <alpine.DEB.2.00.0905111039470.2492@gandalf.stny.rr.com> <20090511151353.GA14391@Krystal> <4A094677.5090900@cn.fujitsu.com> <4A0BF82A.2070208@cn.fujitsu.com> <20090514124013.GC21241@Krystal> <alpine.DEB.2.00.0905140926010.30591@gandalf.stny.rr.com> <4A0CCB2E.10202@cn.fujitsu.com> <6A70E08D65F749FA92475F8BA1F9510D@zhaoleiwin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6A70E08D65F749FA92475F8BA1F9510D@zhaoleiwin>
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


* Zhaolei <zhaolei@cn.fujitsu.com> wrote:

> * From: "Xiao Guangrong" <xiaoguangrong@cn.fujitsu.com>
> > Steven Rostedt wrote:
> >> On Thu, 14 May 2009, Mathieu Desnoyers wrote:
> >>>> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> >>>>
> >>>> This patch is modified from Mathieu Desnoyers' patch. The original patch
> >>>> can be found here: 
> >>>> http://marc.info/?l=linux-kernel&m=123791201816245&w=2
> >>>> This tracepoint can trace the time stamp when softirq action is raised. 
> >>>>
> >>>> Changelog for v1 -> v2: 
> >>>> 1: Use TRACE_EVENT instead of DEFINE_TRACE
> >>>> 2: Move the tracepoint from raise_softirq_irqoff() to
> >>>>    __raise_softirq_irqoff()
> >>>>
> >>>> Changelog for v2 -> v3: 
> >>>> Move the definition of __raise_softifq_irqoff() to .c file when
> >>>> CONFIG_TRACEPOINTS is enabled, to avoid recursive includes
> >>>>
> >>>> Changelog for v3 -> v4: 
> >>>> 1: Come back to v2, and use forward declarations to avoid
> >>>>    recursive includes as Mathieu's suggestion
> >>>> 2: Modifiy the tracepoint name
> >>>> 3: Add comments for this tracepoint
> >>>>
> >>> This is a step in the right direction, but please see my email to Lai
> >>> about the fact that this assumes correct and undocumented include
> >>> dependencies in kernel/trace/events.c. Not explicitely stating the
> >>> include dependencies is a build error waiting to happen.
> >>>
> >>> Including interrupt.h under a ifdef would allow keeping track of
> >>> TRACE_EVENT specific build dependencies neatly on a per header basis.
> >> 
> >> This is all moot, the events.c file no longer exists and as not an issue.
> >> 
> > 
> > As Steve's says, use ftrace in ftrace.h not in events.c now. 
> > So, this mistake does not exist.
> > Dose this patch has other error? I expect for your views.
> > 
> > Thanks for your review, is great help to me. ;-) 
> 
> Hello,
> 
> It seems Mathieu has no other comments on this patch now.
> Ingo, what is your opinion on this patch?

There's a complication: this area of the softirq code needs fixes 
(unrelated to tracing).
 
This API:

inline void raise_softirq_irqoff(unsigned int nr)
{
        __raise_softirq_irqoff(nr);

        /*
         * If we're in an interrupt or softirq, we're done
         * (this also catches softirq-disabled code). We will
         * actually run the softirq once we return from
         * the irq or softirq.
         *
         * Otherwise we wake up ksoftirqd to make sure we
         * schedule the softirq soon.
         */
        if (!in_interrupt())
                wakeup_softirqd();
}

is broken with RT tasks (as recently reported to lkml), as when a 
real-time task wakes up ksoftirqd (which has lower priority) it wont 
execute and we starve softirq execution.

The proper solution would be to have a new API:

	raise_softirq_check()

and to remove the wakeup_softirqd() hack from raise_softirq_irqoff() 
- and put raise_softirq_check() to all places that use 
raise_softirq*() from process context.
 
raise_softirq_check() would execute softirq handlers from process 
context, if there's any pending ones. It has to be called outside of 
bh critical sections - i.e. often a bit after the raise_softirq() 
has been done.

__raise_softirq_irqoff() would be made private to kernel/softirq.c, 
and we'd only have two public APIs to trigger softirqs: 
raise_softirq() and raise_softirq_irqoff(). Both just set the 
pending flag and dont do any wakeup.

As a side-effect of these fixes, the tracepoints will be sorted out 
as well - there wont be any need to hack into 
__raise_softirq_irqoff().

	Ingo
