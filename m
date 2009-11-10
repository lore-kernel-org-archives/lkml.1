Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbZKJK1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbZKJK1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbZKJK1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:27:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:50859 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZKJK1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:27:49 -0500
Subject: Re: [PATCH v2] tracing: Protect the buffer from recursion in perf
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>
In-Reply-To: <1257477185-7838-1-git-send-email-fweisbec@gmail.com>
References: <4AF24144.30003@redhat.com>
	 <1257477185-7838-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 10 Nov 2009 11:27:42 +0100
Message-ID: <1257848862.4648.33.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 04:13 +0100, Frederic Weisbecker wrote:
> While tracing using events with perf, if one enables the
> lockdep:lock_acquire event, it will infect every other perf trace
> events.
> 
> Basically, you can enable whatever set of trace events through perf
> but if this event is part of the set, the only result we can get is a
> long list of lock_acquire events of rcu read lock, and only that.
> 
> This is because of a recursion inside perf.
> 
> 1) When a trace event is triggered, it will fill a per cpu buffer and
>    submit it to perf.
> 2) Perf will commit this event but will also protect some data using
>    rcu_read_lock
> 3) A recursion appears: rcu_read_lock triggers a lock_acquire event that
>    will fill the per cpu event and then submit the buffer to perf.
> 4) Perf detects a recursion and ignore it
> 5) Perf continue its work on the previous event, but its buffer has been
>    overwritten by the lock_acquire event, it has then been turned into
>    a lock_acquire event of rcu read lock
> 
> Such scenario also happens with lock_release with rcu_read_unlock().
> 
> We could turn the rcu_read_lock() into __rcu_read_lock() to drop the
> lock debugging from perf fast path, but that would make us lose
> the rcu debugging and that doesn't prevent from other possible kind of
> recursion from perf in the future.
> 
> This patch adds a recursion protection based on a counter on the perf
> trace per cpu buffers to solve the problem.

There already is recursion protection in
kernel/perf_event.c:perf_swevent_recursion_context() and thereabouts.
Could you not fix this by widening its scope?
