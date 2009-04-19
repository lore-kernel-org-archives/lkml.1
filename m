Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbZDSELb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbZDSELb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 00:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbZDSELW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 00:11:22 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:59424 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750777AbZDSELW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 00:11:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqsGACw+6klMQW1W/2dsb2JhbACBTssWg30G
Date: Sun, 19 Apr 2009 00:11:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] x86 entry_64.S lockdep fix
Message-ID: <20090419041119.GB26365@Krystal>
References: <20090416161746.831882528@goodmis.org> <1239900469.23397.3128.camel@laptop> <alpine.DEB.2.00.0904161343110.20429@gandalf.stny.rr.com> <1239904428.23397.3278.camel@laptop> <alpine.DEB.2.00.0904162254270.20429@gandalf.stny.rr.com> <alpine.DEB.2.00.0904170002030.20429@gandalf.stny.rr.com> <20090417045229.GA30001@Krystal> <alpine.DEB.2.00.0904170706510.20429@gandalf.stny.rr.com> <20090417221942.GA24619@Krystal> <alpine.DEB.2.00.0904180953390.1016@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904180953390.1016@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:08:32 up 50 days, 34 min,  2 users,  load average: 0.73, 0.79,
	0.67
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Fri, 17 Apr 2009, Mathieu Desnoyers wrote:
> > 
> > I happened to have the following patch hanging around in my LTTng tree
> > for a while. Would it solve your problem by any chance ? I had to move
> > it a bit around in my patchset to put it before the nmi-safe int3
> > handler patch I have, but it should apply correctly.
> > 
> > 
> > x86 entry_64.S lockdep fix
> > 
> > Add missing lockdep irq on instrumentation to entry_64.S.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > ---
> >  arch/x86/kernel/entry_64.S |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6-lttng/arch/x86/kernel/entry_64.S
> > ===================================================================
> > --- linux-2.6-lttng.orig/arch/x86/kernel/entry_64.S	2009-04-17 17:44:18.000000000 -0400
> > +++ linux-2.6-lttng/arch/x86/kernel/entry_64.S	2009-04-17 17:53:42.000000000 -0400
> > @@ -1420,9 +1420,9 @@ ENTRY(paranoid_exit)
> >  	testl $3,CS(%rsp)
> >  	jnz   paranoid_userspace
> >  paranoid_swapgs:
> > -	TRACE_IRQS_IRETQ 0
> >  	SWAPGS_UNSAFE_STACK
> >  paranoid_restore:
> > +	TRACE_IRQS_IRETQ 0
> 
> This is buggy. If you go here via userspace, you just did a swapgs, and 
> the %gs register (process context) is now zero. If you call kernel code 
> that does anything with "current" you will crash the system.
> 

Argh, I should not have extracted my fix from my patchset and try to
reorder the patches that late in the day. Sorry, you are indeed right.
On the bright side, the patch I send earlier has never hit a repository.
Here is a more sensible version.


Add missing lockdep irq on instrumentation to entry_64.S.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/x86/kernel/entry_64.S |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6-lttng/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/entry_64.S	2009-04-17 18:34:51.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/entry_64.S	2009-04-18 23:41:28.000000000 -0400
@@ -1422,7 +1422,10 @@ ENTRY(paranoid_exit)
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



> -- Steve
> 
> 
> >  	RESTORE_ALL 8
> >  	jmp irq_return
> >  paranoid_userspace:
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
