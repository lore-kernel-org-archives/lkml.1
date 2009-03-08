Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbZCHQZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbZCHQZV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbZCHQZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:25:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40388 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbZCHQZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:25:05 -0400
Date: Sun, 8 Mar 2009 17:24:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>
Subject: Re: [RFC][PATCH 1/2] tracing/ftrace: syscall tracing infrastructure
Message-ID: <20090308162444.GG19658@elte.hu>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236401580-5758-2-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> +static const struct syscall_trace_entry syscall_trace_entries[] = {
> +	/* For open, the first argument is a string, hence the given mask */
> +	[SYSCALL_TRACE_OPEN]	= SYS_TRACE_ENTRY(open, 3, 0x1),
> +	[SYSCALL_TRACE_CLOSE]	= SYS_TRACE_ENTRY(close, 1, 0),
> +	[SYSCALL_TRACE_READ]	= SYS_TRACE_ENTRY(read, 3, 0),
> +	[SYSCALL_TRACE_WRITE]	= SYS_TRACE_ENTRY(read, 3, 0),
> +};

s/read/write in the last entry i guess.

But i think the whole concept of duplicating the syscall table 
is the wrong way around.

Note that we dont have to build this information at all - in 
2.6.29-rc1 all syscalls got wrapper macros:

 SYSCALL_DEFINE1(nice, int, increment)
 SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
 SYSCALL_DEFINE3(sched_setaffinity, pid_t, pid, unsigned int, len,
                 unsigned long __user *, user_mask_ptr)

We also have the syscall table itself.

So what we can do: by changing the SYSCALL_DEFINEX() macros we 
can emit the following information into a table:

  (syscall_fn_address, syscall_name_string, #of arguments, array 
   of argument names and type sizeof()s)

then during bootup we can match up the sys_call_table[] to the 
secondary table we built, so that we can order the secondary 
table based on syscall NR. 99% of the syscalls will match up 
just fine.

	Ingo
