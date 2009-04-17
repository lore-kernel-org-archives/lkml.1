Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbZDQWUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbZDQWUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 18:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759045AbZDQWT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 18:19:56 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:36059 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756404AbZDQWTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:19:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EAM+X6ElMQW1W/2dsb2JhbACBTs4Rg30G
Date: Fri, 17 Apr 2009 18:19:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH] x86 entry_64.S lockdep fix
Message-ID: <20090417221942.GA24619@Krystal>
References: <20090416161543.199331330@goodmis.org> <20090416161746.831882528@goodmis.org> <1239900469.23397.3128.camel@laptop> <alpine.DEB.2.00.0904161343110.20429@gandalf.stny.rr.com> <1239904428.23397.3278.camel@laptop> <alpine.DEB.2.00.0904162254270.20429@gandalf.stny.rr.com> <alpine.DEB.2.00.0904170002030.20429@gandalf.stny.rr.com> <20090417045229.GA30001@Krystal> <alpine.DEB.2.00.0904170706510.20429@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904170706510.20429@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:17:05 up 48 days, 18:43,  2 users,  load average: 1.11, 0.65,
	0.59
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> 
> On Fri, 17 Apr 2009, Mathieu Desnoyers wrote:
> > > ---[ end trace 03d889e04bc7a9a7 ]---
> > > possible reason: unannotated irqs-on.
> > > irq event stamp: 12569
> > > hardirqs last  enabled at (12567): [<ffffffff8026206a>] local_bh_enable+0xaa/0x110
> > > hardirqs last disabled at (12569): [<ffffffff80610c76>] int3+0x16/0x40
> > > softirqs last  enabled at (12566): [<ffffffff80514d2b>] lock_sock_nested+0xfb/0x110
> > > softirqs last disabled at (12568): [<ffffffff8058454e>] tcp_prequeue_process+0x2e/0xa0
> > > 
> > > 
> > > Note, for some reason we hit int3 ??
> > > 
> > > Tracepoints do not use int3 does it?
> > > 
> > 
> > Not in your ftrace tree. My LTTng tree includes the immediate values,
> > which brienfly uses the int3 handler when enabling/disabling
> > tracepoints. But this seems unrelated to your problem.
> 
> Maybe something else is adding it :-/
> 
> > 
> > > I have kprobes defined but not any kprobe self tests on.
> > > 
> > 
> > Could this be a userspace breakpoint then ?
> 
> Nope, it happens right in the kernel. And the path I describe below points 
> out that we have a bug in irq tracing when we take a int3 in kernel space.
> 
> > 
> > > Anyway, let me describe what the above is and what I found in my 
> > > investigation.
> > > 
> > > The lockdep took a check_flags error when it noticed that interrupts were 
> > > enabled, but the current->hardirqs_enabled was 0. Lockdep thought 
> > > interrupts were disabled but they were in fact enabled.
> > > 
> > > 
> > > The last 4 lines of the warning have the numbers in the parenthesis 
> > > annotate the order of events: (Here they are in order)
> > > 
> > > softirqs last  enabled at (12566): [<ffffffff80514d2b>] lock_sock_nested+0xfb/0x110
> > > hardirqs last  enabled at (12567): [<ffffffff8026206a>] local_bh_enable+0xaa/0x110
> > > softirqs last disabled at (12568): [<ffffffff8058454e>] tcp_prequeue_process+0x2e/0xa0
> > > hardirqs last disabled at (12569): [<ffffffff80610c76>] int3+0x16/0x40
> > > 
> > > The last change that lockdep saw was interrupts being disabled by int3. I 
> > > still don't understand why int3 was enabled. I have startup tests for 
> > > ftrace and the event tracer, but this blob happened when I first ssh'd 
> > > into the box.
> > 
> > Also note that maybe some entry.S annotation could be missing, making
> > kallsyms think it was running within int3 when in fact it was running in
> > a different function. I would double-check with objdump givin the
> > ffffffff80610c76 address to make sure.
> 
> Actually, that was the first thing I did. Because I thought int3 was 
> weird.
> 
> 
> > 
> > Just giving my 2 cents before going to bed. I don't have any more brain
> > left for tonight.
> 
> Thanks,
> 
> -- Steve

I happened to have the following patch hanging around in my LTTng tree
for a while. Would it solve your problem by any chance ? I had to move
it a bit around in my patchset to put it before the nmi-safe int3
handler patch I have, but it should apply correctly.


x86 entry_64.S lockdep fix

Add missing lockdep irq on instrumentation to entry_64.S.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/entry_64.S	2009-04-17 17:44:18.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/entry_64.S	2009-04-17 17:53:42.000000000 -0400
@@ -1420,9 +1420,9 @@ ENTRY(paranoid_exit)
 	testl $3,CS(%rsp)
 	jnz   paranoid_userspace
 paranoid_swapgs:
-	TRACE_IRQS_IRETQ 0
 	SWAPGS_UNSAFE_STACK
 paranoid_restore:
+	TRACE_IRQS_IRETQ 0
 	RESTORE_ALL 8
 	jmp irq_return
 paranoid_userspace:

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
