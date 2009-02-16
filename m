Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbZBPUxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbZBPUxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZBPUw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:52:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38636 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbZBPUw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:52:59 -0500
Date: Mon, 16 Feb 2009 21:49:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single
	ipi fallback for smp_call_function_many())
Message-ID: <20090216204902.GA6924@redhat.com>
References: <20090216163847.431174825@chello.nl> <20090216164114.433430761@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216164114.433430761@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to understand the barriers in smp.c, please help!

"generic-ipi: fix the smp_mb() placement" commit
561920a0d2bb6d63343e83acfd784c0a77bd28d1 added smp_read_barrier_depends()
to generic_smp_call_function_single_interrupt().

Why it is needed? The comment says:

	/*
	 * Need to see other stores to list head for checking whether
	 * list is empty without holding q->lock
	 */
	smp_read_barrier_depends();
	while (!list_empty(&q->list)) {

But we can't miss the addition to the call_single_queue.list,
if generic_exec_single() sees list_empty(&dst->list) it sends
another IPI?


This commit also removed the barrier from csd_flag_wait(), is this OK?
Without the barrier, csd_flag_wait() can return before we see the result
of data->func() ?

IOW,
	int VAR = 0;

	void func(coid *unused)
	{
		VAR = 1;
	}

Now,

	smp_call_function_single(0, func, NULL, 1);
	BUG_ON(VAR == 0);

afaics, the BUG_ON() above is possible. Is this OK ?

Oleg.

