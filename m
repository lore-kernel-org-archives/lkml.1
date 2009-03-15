Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbZCOFAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbZCOFAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 01:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZCOE75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 00:59:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40179 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbZCOE74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 00:59:56 -0400
Date: Sun, 15 Mar 2009 05:59:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Subject: Re: [PATCH 1/2 v2] tracing/syscalls: core infrastructure for
	syscalls tracing
Message-ID: <20090315045904.GA20949@elte.hu>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com> <1236955332-10133-2-git-send-email-fweisbec@gmail.com> <20090314205105.b67bdb6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090314205105.b67bdb6a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 13 Mar 2009 15:42:11 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > +void start_ftrace_syscalls(void)
> > +{
> > +	unsigned long flags;
> > +	struct task_struct *g, *t;
> > +
> > +	if (atomic_inc_return(&refcount) != 1)
> > +		goto out;
> > +
> > +	arch_init_ftrace_syscalls();
> > +	read_lock_irqsave(&tasklist_lock, flags);
> > +
> > +	do_each_thread(g, t) {
> > +		set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > +	} while_each_thread(g, t);
> > +
> > +	read_unlock_irqrestore(&tasklist_lock, flags);
> > +out:
> > +	atomic_dec(&refcount);
> > +}
> > +
> > +void stop_ftrace_syscalls(void)
> > +{
> > +	unsigned long flags;
> > +	struct task_struct *g, *t;
> > +
> > +	if (atomic_dec_return(&refcount))
> > +		goto out;
> > +
> > +	read_lock_irqsave(&tasklist_lock, flags);
> > +
> > +	do_each_thread(g, t) {
> > +		clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > +	} while_each_thread(g, t);
> > +
> > +	read_unlock_irqrestore(&tasklist_lock, flags);
> > +out:
> > +	atomic_inc(&refcount);
> > +}
> 
> What is this `refcount' thing trying to do?  afacit it does 
> not prevent the two loops from running concurrently and making 
> a mess.
> 
> If it _is_ trying to prevent that from happening, then why not 
> use plain old mutex_lock()?

yeah - already commented about that to Frederic over IRC. A 
plain flag, checked inside the tasklist lock is more than 
enough.

	Ingo
