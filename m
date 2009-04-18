Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbZDRNzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbZDRNzS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 09:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbZDRNzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 09:55:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62534 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbZDRNzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 09:55:03 -0400
Date: Sat, 18 Apr 2009 09:54:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] x86 entry_64.S lockdep fix
In-Reply-To: <20090417221942.GA24619@Krystal>
Message-ID: <alpine.DEB.2.00.0904180953390.1016@gandalf.stny.rr.com>
References: <20090416161543.199331330@goodmis.org> <20090416161746.831882528@goodmis.org> <1239900469.23397.3128.camel@laptop> <alpine.DEB.2.00.0904161343110.20429@gandalf.stny.rr.com> <1239904428.23397.3278.camel@laptop> <alpine.DEB.2.00.0904162254270.20429@gandalf.stny.rr.com>
 <alpine.DEB.2.00.0904170002030.20429@gandalf.stny.rr.com> <20090417045229.GA30001@Krystal> <alpine.DEB.2.00.0904170706510.20429@gandalf.stny.rr.com> <20090417221942.GA24619@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 17 Apr 2009, Mathieu Desnoyers wrote:
> 
> I happened to have the following patch hanging around in my LTTng tree
> for a while. Would it solve your problem by any chance ? I had to move
> it a bit around in my patchset to put it before the nmi-safe int3
> handler patch I have, but it should apply correctly.
> 
> 
> x86 entry_64.S lockdep fix
> 
> Add missing lockdep irq on instrumentation to entry_64.S.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  arch/x86/kernel/entry_64.S |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/arch/x86/kernel/entry_64.S
> ===================================================================
> --- linux-2.6-lttng.orig/arch/x86/kernel/entry_64.S	2009-04-17 17:44:18.000000000 -0400
> +++ linux-2.6-lttng/arch/x86/kernel/entry_64.S	2009-04-17 17:53:42.000000000 -0400
> @@ -1420,9 +1420,9 @@ ENTRY(paranoid_exit)
>  	testl $3,CS(%rsp)
>  	jnz   paranoid_userspace
>  paranoid_swapgs:
> -	TRACE_IRQS_IRETQ 0
>  	SWAPGS_UNSAFE_STACK
>  paranoid_restore:
> +	TRACE_IRQS_IRETQ 0

This is buggy. If you go here via userspace, you just did a swapgs, and 
the %gs register (process context) is now zero. If you call kernel code 
that does anything with "current" you will crash the system.

-- Steve


>  	RESTORE_ALL 8
>  	jmp irq_return
>  paranoid_userspace:
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
