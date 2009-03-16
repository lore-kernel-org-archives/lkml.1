Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbZCPKdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbZCPKdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbZCPKdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:33:37 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:52211 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZCPKdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:33:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18878.11002.809624.875621@cargo.ozlabs.ibm.com>
Date: Mon, 16 Mar 2009 21:33:30 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] perfcounters: Make s/w counters in a group only count
 when group is on
In-Reply-To: <1237197403.7818.30.camel@twins>
References: <18873.48668.562126.113618@cargo.ozlabs.ibm.com>
	<1236939816.22914.3714.camel@twins>
	<18874.20538.785519.824803@cargo.ozlabs.ibm.com>
	<1236948283.22447.36.camel@twins>
	<18874.57621.950179.972863@cargo.ozlabs.ibm.com>
	<1237197403.7818.30.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> > So... I was about to restore that symmetry by implementing lazy PMU
> > context switching.  In the case where we have inherited counters, and
> > we are switching from one task to another that both have the same set
> > of inherited counters, we don't really need to do anything, because it
> > doesn't matter which set of counters the events get added into,
> > because they all get added together at the end anyway.
> 
> That is only true for actual counting counters, not the sampling kind.

Hmmm... I don't think inherited sampling counters work at present
anyway. :)  The events for a child process will go into the child
struct perf_counter, and the code doesn't currently provide any way to
read them out (unless I missed something).

> > It seems quite reasonable to me that things could happen that are
> > attributable to a task, but which happen when the task isn't running.
> > Not just context switches and migrations - there's a whole class of
> > things that the system does on behalf of a process that can happen
> > asynchronously.  I wouldn't want to say that those kind of things can
> > never be counted with software counters.
> 
> I've been thinking too much about sampling I think. It makes absolutely
> no sense in that light to have events that occur when the task isn't
> running, quite simply because its impossible to relate it to whatever
> the task is doing at that moment.
> 
> However for simple counting events it might make sense to have something
> like that.
> 
> Still HW counters can simply never do anything like that, and the lazy
> PMU thing you propose, while cool for simple stuff like perfstat, is
> something all-together different -- it doesn't keep counters enabled
> while their task is gone from the cpu, it avoids a counter update
> between related tasks.

As an implementation detail, I think we could get the situation where
a counter is active but its task isn't running in two cases: software
counters that count while their task is switched out, and hardware
counters that have been lazily left running past a context switch.
I was trying to handle both cases in a similar manner.

However, your new software counter code seems to be doing the right
thing with a task clock counter in a group that also has a hardware
counter, so my patch is no longer required.  But, I notice that the
counter->prev_state thing is still there.  It would be nice to get rid
of that.

Paul.
