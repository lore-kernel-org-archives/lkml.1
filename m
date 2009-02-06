Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbZBFBx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbZBFBx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZBFBxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:53:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbZBFBxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:53:50 -0500
Date: Thu, 5 Feb 2009 17:53:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ring-buffer: add NMI protection for spinlocks
Message-Id: <20090205175321.e1455c0e.akpm@linux-foundation.org>
In-Reply-To: <20090206011350.976972261@goodmis.org>
References: <20090206011315.360405659@goodmis.org>
	<20090206011350.976972261@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Feb 2009 20:13:16 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: prevent deadlock in NMI
> 
> The ring buffers are not yet totally lockless with writing to
> the buffer. When a writer crosses a page, it grabs a per cpu spinlock
> to protect against a reader. The spinlocks taken by a writer are not
> to protect against other writers, since a writer can only write to
> its own per cpu buffer. The spinlocks protect against readers that
> can touch any cpu buffer. The writers are made to be reentrant
> with the spinlocks disabling interrupts.
> 
> The problem arises when an NMI writes to the buffer, and that write
> crosses a page boundary. If it grabs a spinlock, it can be racing
> with another writer (since disabling interrupts does not protect
> against NMIs) or with a reader on the same CPU. Luckily, most of the
> users are not reentrant and protects against this issue. But if a
> user of the ring buffer becomes reentrant (which is what the ring
> buffers do allow), if the NMI also writes to the ring buffer then
> we risk the chance of a deadlock.
> 
> This patch moves the ftrace_nmi_enter called by nmi_enter() to the
> ring buffer code. It replaces the current ftrace_nmi_enter that is
> used by arch specific code to arch_ftrace_nmi_enter and updates
> the Kconfig to handle it.
> 
> When an NMI is called, it will set a per cpu variable in the ring buffer
> code and will clear it when the NMI exits. If a write to the ring buffer
> crosses page boundaries inside an NMI, a trylock is used on the spin
> lock instead. If the spinlock fails to be acquired, then the entry
> is discarded.
> 
> This bug appeared in the ftrace work in the RT tree, where event tracing
> is reentrant. This workaround solved the deadlocks that appeared there.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/x86/Kconfig           |    1 +
>  arch/x86/kernel/ftrace.c   |    8 +++---
>  include/linux/ftrace_irq.h |   10 ++++++++-
>  kernel/trace/Kconfig       |    8 +++++++
>  kernel/trace/ring_buffer.c |   48 ++++++++++++++++++++++++++++++++++++++++++-
>  5 files changed, 68 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 4277640..3da7121 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -34,6 +34,7 @@ config X86
>  	select HAVE_FUNCTION_TRACER
>  	select HAVE_FUNCTION_GRAPH_TRACER
>  	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
> +	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE || FUNCTION_GRAPH_TRACER
>  	select HAVE_KVM
>  	select HAVE_ARCH_KGDB
>  	select HAVE_ARCH_TRACEHOOK
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 4d33224..4c68358 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -113,7 +113,7 @@ static void ftrace_mod_code(void)
>  					     MCOUNT_INSN_SIZE);
>  }
>  
> -void ftrace_nmi_enter(void)
> +void arch_ftrace_nmi_enter(void)
>  {
>  	atomic_inc(&in_nmi);

This in_nmi thing looks a bit awkward.  It's not very clear from the
code what it does or why it exists, but it looks like I'm going to have
to get used to that...

Surely it is buggy?  It's incremented by _any_ cpu, so code which reads
it (eg, prepare_ftrace_return()) will bale out if some other CPU
happened to be in the middle of taking an NMI.

Would it not be better to make in_nmi a per-cpu thing, make it a piece
of first-class kernel infrastructure, add a nice interface to it, hoist
it up into generic code, call that code from arch NMI handlers, call
that interface from ftrace, etc?  Or perhaps it could be implemented in
task_struct, alongside in_irq(), in_softirq(), etc.  There are three bits
left in ->preempt_count.

This approach would remove the duplication which this patch is
attempting to add.

Plus there's already quite a bit of duplication in
arch/x86/kernel/ftrace.c between the
CONFIG_DYNAMIC_FTRACE/!CONFIG_DYNAMIC_FTRACE hunks.  Two definitions of
in_nmi, duplicated inc/dec thereof?



