Return-Path: <linux-kernel-owner+w=401wt.eu-S964941AbZGQQon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964941AbZGQQon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 12:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964917AbZGQQon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 12:44:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58673 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964884AbZGQQom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 12:44:42 -0400
Date: Fri, 17 Jul 2009 18:43:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] kmemleak: Scan all thread stacks
Message-ID: <20090717164346.GC5131@elte.hu>
References: <20090717093359.8288.45464.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090717093359.8288.45464.stgit@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> This patch changes the for_each_process() loop with the
> do_each_thread()/while_each_thread() pair. It also replaces the
> read_lock(&tasklist_lock) with rcu_read_lock() and task_lock(p).
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
> 
> My questions:
> 
> 1. Is it correct that for_each_process() used currently by kmemleak may
>    not loop through all the possible kernel thread stacks?

yes. You need the full, all tasks variant:

        do_each_thread(g, p) {
        ...
        } while_each_thread(g, p);


> 2. Is it safe to use rcu_read_lock() and task_lock() when scanning the
>    corresponding kernel stack (thread_info structure)? The loop doesn't
>    do any modification to the task list. The reason for this is to
>    allow kernel preemption when scanning the stacks.

you cannot generally preempt while holding the RCU read-lock.

	Ingo
