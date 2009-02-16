Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbZBPVEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbZBPVEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZBPVD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:03:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44874 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbZBPVD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:03:58 -0500
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove
 single ipi fallback for smp_call_function_many())
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090216204902.GA6924@redhat.com>
References: <20090216163847.431174825@chello.nl>
	 <20090216164114.433430761@chello.nl>  <20090216204902.GA6924@redhat.com>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 22:03:21 +0100
Message-Id: <1234818201.30178.386.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 21:49 +0100, Oleg Nesterov wrote:
> I am trying to understand the barriers in smp.c, please help!
> 
> "generic-ipi: fix the smp_mb() placement" commit
> 561920a0d2bb6d63343e83acfd784c0a77bd28d1 added smp_read_barrier_depends()
> to generic_smp_call_function_single_interrupt().
> 
> Why it is needed? The comment says:
> 
> 	/*
> 	 * Need to see other stores to list head for checking whether
> 	 * list is empty without holding q->lock
> 	 */
> 	smp_read_barrier_depends();
> 	while (!list_empty(&q->list)) {
> 
> But we can't miss the addition to the call_single_queue.list,
> if generic_exec_single() sees list_empty(&dst->list) it sends
> another IPI?

I was about to write a response, but found it to be a justification for
the read_barrier_depends() at the end of the loop. 

> This commit also removed the barrier from csd_flag_wait(), is this OK?
> Without the barrier, csd_flag_wait() can return before we see the result
> of data->func() ?
> 
> IOW,
> 	int VAR = 0;
> 
> 	void func(coid *unused)
> 	{
> 		VAR = 1;
> 	}
> 
> Now,
> 
> 	smp_call_function_single(0, func, NULL, 1);
> 	BUG_ON(VAR == 0);
> 
> afaics, the BUG_ON() above is possible. Is this OK ?

Would it not be the caller's responsibility to provide the needed
serialization in this case?

