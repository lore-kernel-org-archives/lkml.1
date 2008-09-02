Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbYIBOzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbYIBOzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYIBOza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:55:30 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41452 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYIBOza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:55:30 -0400
Date: Tue, 2 Sep 2008 07:55:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org
Subject: Re: [PATCH, RFC, tip/core/rcu] v3 scalable classic RCU
	implementation
Message-ID: <20080902145512.GA6748@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <1220088780.8426.1.camel@twins> <20080830141001.GD7107@linux.vnet.ibm.com> <1220110858.14894.46.camel@lappy.programming.kicks-ass.net> <20080902132608.GA7751@Krystal> <1220362914.8609.51.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220362914.8609.51.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 03:41:54PM +0200, Peter Zijlstra wrote:
> On Tue, 2008-09-02 at 09:26 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > > On Sat, 2008-08-30 at 07:10 -0700, Paul E. McKenney wrote:
> > > > On Sat, Aug 30, 2008 at 11:33:00AM +0200, Peter Zijlstra wrote:
> > > > > On Fri, 2008-08-29 at 17:49 -0700, Paul E. McKenney wrote:
> > > > > 
> > > > > > Some shortcomings:
> > > > > > 
> > > > > > o	Entering and leaving dynticks idle mode is a quiescent state,
> > > > > > 	but the current patch doesn't take advantage of this (noted
> > > > > > 	by Manfred).  It appears that it should be possible to make
> > > > > > 	nmi_enter() and nmi_exit() provide an in_nmi(), which would make
> > > > > > 	it possible for rcu_irq_enter() and rcu_irq_exit() to figure
> > > > > > 	out whether it is safe to tell RCU about the quiescent state --
> > > > > > 	and also greatly simplify the code.
> > > > > 
> > > > > Already done and available in the -tip tree, curtesy of Mathieu.
> > > > 
> > > > Very cool!!!  I see one of his patches at http://lkml.org/lkml/2008/4/17/342,
> > > > but how do I find out which branch of -tip this is on?  (I am learning
> > > > git, but it is a slow process...)
> > > > 
> > > > This would also simplify preemptable RCU's dyntick interface, removing
> > > > the need for proofs.
> > > 
> > > Not sure - my git-foo isn't good enough either :-(
> > > 
> > > All I can offer is that its available in tip/master (the collective
> > > merge of all of tip's branches) as commit:
> > > 0d84b78a606f1562532cd576ee8733caf5a4aed3, which I found using
> > > git-annotate include/linux/hardirq.h
> > > 
> > > How to find from which particular topic branch it came from, I too am
> > > clueless.
> > > 
> > 
> > If you're interested in knowing the topic it came from : it's required
> > so a following patch can use a "popf; ret" instead of iret to return
> > from trap handlers executed in NMI context. There is an architectural
> > problem on x86 causing NMIs to be reactivated after the first iret
> > encountered, which leads to NMI handler races if nmi handlers trap. This
> > works around the problem by returning from the trap handlers without
> > using the iret instruction.
> > 
> > It's useful to Immediate Values which put a temporary breakpoint in the
> > instruction stream when proceeding to code modification and also useful
> > to LTTng (available in the -lttng tree) which writes tracing data to
> > vmap'd memory buffers (which can cause a minor page fault).
> > 
> > I'm glad to see NMI context detection is useful to others too !
> 
> While an interesting detail, its not the answer to the question.
> 
> Given a bunch of topic branches, and a branch that has all those topic
> merged, how, for any particular commit from the merge branch, do you
> find from which topic branch it originiated?
> 
> IOW, the answer to the above question would have been a series of git
> commands that would have resulted in something like tip/tracing/nmisafe

I guess that it turned out that there was a series of mutt commands that
eventually got the answer.  That said, a series of git commands would
be quite nice.  ;-)

But it would appear that the series of git commands would need to come
from someone with better git-foo than either Mathieu or myself.  :-/

							Thanx, Paul
