Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZERFBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZERFBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 01:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbZERFBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 01:01:37 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:53977 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbZERFBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 01:01:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18960.59367.956231.752086@drongo.ozlabs.ibm.com>
Date: Mon, 18 May 2009 14:45:27 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: vatsa@in.ibm.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: perf counter issue -
 WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
In-Reply-To: <1242419228.32543.360.camel@laptop>
References: <20090513165433.GD16373@in.ibm.com>
	<20090513165724.GA32707@in.ibm.com>
	<20090515135604.GC16389@elte.hu>
	<20090515145144.GD13664@ghostprotocols.net>
	<20090515155807.GA25957@in.ibm.com>
	<1242404001.32543.100.camel@laptop>
	<1242409073.32543.187.camel@laptop>
	<1242419228.32543.360.camel@laptop>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> OK, so the cleanup isn't solid.. I've been poking at things, and below
> is the current state of my tinkering, but it seems to make things
> worse...
> 
> With only the callback in do_exit() the above test works but hackbench
> fails, with only the call in wait_task_zombie() hackbench works and the
> above fails.
> 
> With both, we segfault the kernel on a list op on either :-)

I don't know if this is the problem, but I have noticed a basic
lifetime issue: a counter on a task points to a context which is
embedded in the task_struct of the task being counted, but the counter
might outlive the task.  For example, task A puts a counter on task B,
task B dies and is reaped by its parent, but the counter still exists
because task A hasn't closed its fd.  When task A does close the fd,
perf_release will call perf_counter_remove_from_context which will go
and use counter->ctx, but that is in B's task struct, which has gone
away.

I want to change the task struct to have just a pointer to the context
rather than the context struct itself for other reasons (it will make
it much easier to implement lazy PMU switching).  If we do that we
could refcount the context and solve the lifetime issue that way.  I'm
working on a patch; hopefully I'll have more to report later today.

Paul.
