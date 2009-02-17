Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbZBQK2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbZBQK2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZBQK16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:27:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:36697 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbZBQK15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:27:57 -0500
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove
 single ipi fallback for smp_call_function_many())
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <npiggin@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090217101130.GA8660@wotan.suse.de>
References: <20090216163847.431174825@chello.nl>
	 <20090216164114.433430761@chello.nl> <20090216204902.GA6924@redhat.com>
	 <1234818201.30178.386.camel@laptop> <20090216213205.GA9098@redhat.com>
	 <1234820704.30178.396.camel@laptop> <20090216220214.GA10093@redhat.com>
	 <1234823097.30178.406.camel@laptop> <20090216231946.GA12009@redhat.com>
	 <1234862974.4744.31.camel@laptop>  <20090217101130.GA8660@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 11:27:33 +0100
Message-Id: <1234866453.4744.58.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 11:11 +0100, Nick Piggin wrote:

> But in that case, cpu0 should see list_empty and send another IPI,
> because our load of list_empty has moved before the unlock of the
> lock, so there can't be another item concurrently put on the list.

Suppose a first smp_call_function_single()

So cpu0 does:

 spin_lock(dst->lock);
 ipi = list_empty(dst->list);
 list_add_tail(data->list, dst->list);
 spin_unlock(dst->lock);

 if (ipi) /* true */
   send_single_ipi(cpu);

then cpu1 does:

 while (!list_empty(q->list))

and observes no entries, quits the ipi handler, and stuff is stuck.

cpu0 will observe a non-empty queue and will not raise another ipi, cpu1
got the ipi, but observed no work and hence will not remove it.

> But hmm, why even bother with all this complexity? Why not just
> remove the outer loop completely? Do the lock and the list_replace_init
> unconditionally. It would turn tricky lockless code into simple locked
> code... we've already taken an interrupt anyway, so chances are pretty
> high that we have work here to do, right?

Well, that's a practical suggestion, and I agree.

It was just fun arguing with Oleg ;-)

