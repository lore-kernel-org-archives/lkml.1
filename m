Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbZCOEEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbZCOEEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 00:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZCOEEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 00:04:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987AbZCOEEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 00:04:15 -0400
Date: Sat, 14 Mar 2009 20:51:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
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
Message-Id: <20090314205105.b67bdb6a.akpm@linux-foundation.org>
In-Reply-To: <1236955332-10133-2-git-send-email-fweisbec@gmail.com>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com>
	<1236955332-10133-2-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Mar 2009 15:42:11 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:

> +void start_ftrace_syscalls(void)
> +{
> +	unsigned long flags;
> +	struct task_struct *g, *t;
> +
> +	if (atomic_inc_return(&refcount) != 1)
> +		goto out;
> +
> +	arch_init_ftrace_syscalls();
> +	read_lock_irqsave(&tasklist_lock, flags);
> +
> +	do_each_thread(g, t) {
> +		set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> +	} while_each_thread(g, t);
> +
> +	read_unlock_irqrestore(&tasklist_lock, flags);
> +out:
> +	atomic_dec(&refcount);
> +}
> +
> +void stop_ftrace_syscalls(void)
> +{
> +	unsigned long flags;
> +	struct task_struct *g, *t;
> +
> +	if (atomic_dec_return(&refcount))
> +		goto out;
> +
> +	read_lock_irqsave(&tasklist_lock, flags);
> +
> +	do_each_thread(g, t) {
> +		clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> +	} while_each_thread(g, t);
> +
> +	read_unlock_irqrestore(&tasklist_lock, flags);
> +out:
> +	atomic_inc(&refcount);
> +}

What is this `refcount' thing trying to do?  afacit it does not prevent the
two loops from running concurrently and making a mess.

If it _is_ trying to prevent that from happening, then why not use plain old
mutex_lock()?

If the code is or some reason correct then it certainly is not sufficiently
obvious to be let uncommented.

