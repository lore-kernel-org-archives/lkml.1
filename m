Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbZDSJLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbZDSJLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 05:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZDSJLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 05:11:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37985 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbZDSJLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 05:11:35 -0400
Date: Sun, 19 Apr 2009 11:10:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] x86 entry_64.S lockdep fix
Message-ID: <20090419091046.GA31192@elte.hu>
References: <1239900469.23397.3128.camel@laptop> <alpine.DEB.2.00.0904161343110.20429@gandalf.stny.rr.com> <1239904428.23397.3278.camel@laptop> <alpine.DEB.2.00.0904162254270.20429@gandalf.stny.rr.com> <alpine.DEB.2.00.0904170002030.20429@gandalf.stny.rr.com> <20090417045229.GA30001@Krystal> <alpine.DEB.2.00.0904170706510.20429@gandalf.stny.rr.com> <20090417221942.GA24619@Krystal> <alpine.DEB.2.00.0904180953390.1016@gandalf.stny.rr.com> <20090419041119.GB26365@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090419041119.GB26365@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > On Fri, 17 Apr 2009, Mathieu Desnoyers wrote:
> > > 
> > > I happened to have the following patch hanging around in my LTTng tree
> > > for a while. Would it solve your problem by any chance ? I had to move
> > > it a bit around in my patchset to put it before the nmi-safe int3
> > > handler patch I have, but it should apply correctly.
> > > 
> > > 
> > > x86 entry_64.S lockdep fix
> > > 
> > > Add missing lockdep irq on instrumentation to entry_64.S.
> > > 
> > > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > > ---
> > >  arch/x86/kernel/entry_64.S |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > Index: linux-2.6-lttng/arch/x86/kernel/entry_64.S
> > > ===================================================================
> > > --- linux-2.6-lttng.orig/arch/x86/kernel/entry_64.S	2009-04-17 17:44:18.000000000 -0400
> > > +++ linux-2.6-lttng/arch/x86/kernel/entry_64.S	2009-04-17 17:53:42.000000000 -0400
> > > @@ -1420,9 +1420,9 @@ ENTRY(paranoid_exit)
> > >  	testl $3,CS(%rsp)
> > >  	jnz   paranoid_userspace
> > >  paranoid_swapgs:
> > > -	TRACE_IRQS_IRETQ 0
> > >  	SWAPGS_UNSAFE_STACK
> > >  paranoid_restore:
> > > +	TRACE_IRQS_IRETQ 0
> > 
> > This is buggy. If you go here via userspace, you just did a swapgs, and 
> > the %gs register (process context) is now zero. If you call kernel code 
> > that does anything with "current" you will crash the system.
> > 
> 
> Argh, I should not have extracted my fix from my patchset and try to
> reorder the patches that late in the day. Sorry, you are indeed right.
> On the bright side, the patch I send earlier has never hit a repository.
> Here is a more sensible version.
> 
> 
> Add missing lockdep irq on instrumentation to entry_64.S.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  arch/x86/kernel/entry_64.S |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6-lttng/arch/x86/kernel/entry_64.S
> ===================================================================
> --- linux-2.6-lttng.orig/arch/x86/kernel/entry_64.S	2009-04-17 18:34:51.000000000 -0400
> +++ linux-2.6-lttng/arch/x86/kernel/entry_64.S	2009-04-18 23:41:28.000000000 -0400
> @@ -1422,7 +1422,10 @@ ENTRY(paranoid_exit)
>  paranoid_swapgs:
>  	TRACE_IRQS_IRETQ 0
>  	SWAPGS_UNSAFE_STACK
> +	RESTORE_ALL 8
> +	jmp irq_return
>  paranoid_restore:
> +	TRACE_IRQS_IRETQ 0
>  	RESTORE_ALL 8
>  	jmp irq_return
>  paranoid_userspace:

Yeah - that is exactly the fix from Steve that i have queued up two 
days ago - see it attached below.

	Ingo

------------>
>From 0300e7f1a525ae4e4ac05344624adf0e5f13ea52 Mon Sep 17 00:00:00 2001
From: Steven Rostedt <srostedt@redhat.com>
Date: Fri, 17 Apr 2009 08:33:52 -0400
Subject: [PATCH] lockdep, x86: account for irqs enabled in paranoid_exit

I hit the check_flags error of lockdep:

 WARNING: at kernel/lockdep.c:2893 check_flags+0x1a7/0x1d0()
 [...]
 hardirqs last  enabled at (12567): [<ffffffff8026206a>] local_bh_enable+0xaa/0x110
 hardirqs last disabled at (12569): [<ffffffff80610c76>] int3+0x16/0x40
 softirqs last  enabled at (12566): [<ffffffff80514d2b>] lock_sock_nested+0xfb/0x110
 softirqs last disabled at (12568): [<ffffffff8058454e>] tcp_prequeue_process+0x2e/0xa0

The check_flags warning of lockdep tells me that lockdep thought interrupts
were disabled, but they were really enabled.

The numbers in the above parenthesis show the order of events:

 12566: softirqs last enabled:  lock_sock_nested
 12567: hardirqs last enabled:  local_bh_enable
 12568: softirqs last disabled: tcp_prequeue_process
 12566: hardirqs last disabled: int3

int3 is a breakpoint!

Examining this further, I have CONFIG_NET_TCPPROBE enabled which adds
break points into the kernel.

The paranoid_exit of the return of int3 does not account for enabling
interrupts on return to kernel. This code is a bit tricky since it
is also used by the nmi handler (when lockdep is off), and we must be
careful about the swapgs. We can not call kernel code after the swapgs
has been performed.

[ Impact: fix lockdep check_flags warning + self-turn-off ]

Acked-by: Peter Zijlsta <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_64.S |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index a331ec3..38946c6 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1410,7 +1410,10 @@ ENTRY(paranoid_exit)
 paranoid_swapgs:
 	TRACE_IRQS_IRETQ 0
 	SWAPGS_UNSAFE_STACK
+	RESTORE_ALL 8
+	jmp irq_return
 paranoid_restore:
+	TRACE_IRQS_IRETQ 0
 	RESTORE_ALL 8
 	jmp irq_return
 paranoid_userspace:
