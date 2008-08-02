Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbYHBARZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbYHBARZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 20:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYHBARR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 20:17:17 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38012 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbYHBARQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 20:17:16 -0400
Date: Fri, 1 Aug 2008 17:17:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 01/15] Kernel Tracepoints
Message-ID: <20080802001711.GC6733@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1216130356.12595.184.camel@twins> <20080715142710.GC20037@Krystal> <1216132928.12595.201.camel@twins> <20080715152224.GE20037@Krystal> <1216135902.12595.214.camel@twins> <20080715160813.GB27626@Krystal> <1216139149.12595.224.camel@twins> <20080715165122.GB30082@Krystal> <20080801211020.GQ14851@linux.vnet.ibm.com> <1217635437.9016.29.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217635437.9016.29.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 02:03:57AM +0200, Peter Zijlstra wrote:
> On Fri, 2008-08-01 at 14:10 -0700, Paul E. McKenney wrote:
> 
> > Yeah, I was thinking in terms of rcu_dereference() working with both
> > rcu_assign_pointer() and an as-yet-mythical rcu_assign_index().  Perhaps
> > this would be a good time to get better names:
> > 
> > Current:	rcu_assign_pointer()	rcu_dereference()
> > New Pointers:	rcu_publish_pointer()	rcu_subscribe_pointer()
> > New Indexes:	rcu_publish_index()	rcu_subscribe_index()
> 
> Is it really worth the effort, splitting it out into these two cases?

Either we should split out into the pointer/index cases, or the
definition of rcu_assign_pointer() should probably lose its current
check for NULL...

> > And, while I am at it, work in a way of checking for either being in
> > the appropriate RCU read-side critical section and/or having the
> > needed lock/mutex/whatever held -- something I believe PeterZ was
> > prototyping some months back.
> 
> Yeah - I have (bitrotted a bit, but should be salvageable) lockdep
> annotations for rcu_dereference().
> 
> The problem with them is the huge amount of false positives.. Take for
> example the Radix tree code, its perfectly fine to use the radix tree
> code without RCU - say you do the old rwlock style, still it uses
> rcu_dereference().
> 
> I never figured out a suitable way to annotate that.

My thought was to add a second argument that contained a boolean.  If
the rcu_dereference() was either within an RCU read-side critical
section on the one hand or if the boolean evaluated to "true" on the
other, then no assertion.  This would require SPIN_LOCK_HELD() or
similar primitives.  (And one of the reasons for the renaming

Of course, in the case of radix tree, it would be necessary to pass the
boolean in through the radix-tree read-side APIs, which would perhaps be
a bit annoying.

							Thanx, Paul
