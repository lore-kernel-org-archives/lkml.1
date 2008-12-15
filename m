Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbYLOAhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbYLOAhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 19:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYLOAhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 19:37:32 -0500
Received: from ozlabs.org ([203.10.76.45]:45941 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbYLOAhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 19:37:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18757.42682.109305.676647@drongo.ozlabs.ibm.com>
Date: Mon, 15 Dec 2008 11:37:14 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: eranian@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vince Weaver <vince@deater.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
In-Reply-To: <20081214231332.GA26942@elte.hu>
References: <20081211155230.GA4230@elte.hu>
	<Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	<1229070345.12883.12.camel@twins>
	<7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com>
	<1229073834.12883.41.camel@twins>
	<7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com>
	<7c86c4470812121001i765d663bq6db3080b633a1eef@mail.gmail.com>
	<20081214231332.GA26942@elte.hu>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * stephane eranian <eranian@googlemail.com> wrote:
> 
> > Hi,
> > 
> > Given the level of abstractions you are using for the API, and given 
> > your argument that the kernel can do the HW resource scheduling better 
> > than anybody else.
> > 
> > What happens in the following test case:
> > 
> >    - 2-way system (cpu0, cpu1)
> > 
> >    - on cpu0, two processes P1, P2, each self-monitoring and counting event E1.
> >      Event E1 can only be measured on counter C1.
> > 
> >    - on cpu1, there is a cpu-wide session, monitoring event E1, thus using C1
> > 
> >    - the scheduler decides to migrate P1 onto CPU1. You now have a
> >      conflict on C1.
> > 
> > How is this managed?
> 
> If there's a single unit of sharable resource [such as an event counter, 
> or a physical CPU], then there's just three main possibilities: either 
> user 1 gets it all, or user 2 gets it all, or they share it.
> 
> We've implemented the essence of these variants, with sharing the resource 
> being the sane default, and with the sysadmin also having a configuration 
> vector to reserve the resource to himself permanently. (There could be 
> more variations of this.)
> 
> What is your point?

Note that Stephane said *counting* event E1.

One of the important things about counting (as opposed to sampling) is
that it matters whether or not the event is being counted the whole
time or only part of the time.  Thus it puts constraints on counter
scheduling and reporting that don't apply for sampling.

In other words, if I'm counting an event, I want it to be counted all
the time (i.e. whenever the task is executing, for a per-task counter,
or continuously for a per-cpu counter).  If that causes conflicts and
the kernel decides not to count the event for part of the time, that
is very much second-best, and I absolutely need to know that that
happened, and also when the kernel started and stopped counting the
event (so I can scale the result to get some idea what the result
would have been if it had been counted the whole time).

Now, I haven't digested V4 yet, so you might have already implemented
something like that.  Have you? :)

Paul.
