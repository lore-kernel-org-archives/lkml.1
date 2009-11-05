Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZKEDHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZKEDHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 22:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbZKEDHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 22:07:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZKEDHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 22:07:45 -0500
Message-ID: <4AF24144.30003@redhat.com>
Date: Wed, 04 Nov 2009 22:06:44 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] tracing: Protect the buffer from recursion in perf
References: <1257373437-5332-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1257373437-5332-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
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
>     submit it to perf.
> 2) Perf will commit this event but will also protect some data using
>     rcu_read_lock
> 3) A recursion appears: rcu_read_lock triggers a lock_acquire event that
>     will fill the per cpu event and then submit the buffer to perf.
> 4) Perf detects a recursion and ignore it
> 5) Perf continue its work on the previous event, but its buffer has been
>     overwritten by the lock_acquire event, it has then been turned into
>     a lock_acquire event of rcu read lock
> 
> Such scenario also happens with lock_release with rcu_read_unlock().
> 
> We could turn the rcu_read_lock() into __rcu_read_lock() to drop the
> lock debugging from perf fast path, but that would make us lose
> the rcu debugging and that doesn't prevent from other possible kind of
> recursion from perf in the future.
> 
> This patch adds a recursion protection on the perf trace per cpu
> buffers to solve the problem.

OK, so you added a counter to find recursion.
I found a style issue, see below.

> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index a7f9460..d80928d 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -649,6 +649,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
>    *	struct ftrace_event_call *event_call =&event_<call>;
>    *	extern void perf_tp_event(int, u64, u64, void *, int);
>    *	struct ftrace_raw_##call *entry;
> +* 	struct perf_trace_buf *trace_buf;
  ^^ Here, we need a space :-)

Others looks good to me, Thanks!

Reviewed-by: Masami Hiramatsu <mhiramat@redhat.com>


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

