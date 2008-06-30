Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYF3HCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYF3HCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 03:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYF3HB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 03:01:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44798 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbYF3HB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 03:01:56 -0400
Date: Mon, 30 Jun 2008 09:01:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH 1/2] stacktrace: add saved stack traces to
	backtrace self-test
Message-ID: <20080630070135.GC9561@elte.hu>
References: <20080627160448.GB8852@damson.getinternet.no> <20080627160821.GA30232@elte.hu> <20080627192055.GA8435@elte.hu> <19f34abd0806271229v6119e6f8ub9fb1b6e231abebf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806271229v6119e6f8ub9fb1b6e231abebf@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Fri, Jun 27, 2008 at 9:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > FYI, it needed the fixlet below.
> >
> >        Ingo
> >
> 
> Oh. I'm sorry :-(
> 
> (I'll admit that I've never worked with modules before. I'll try to 
> remember now.)

i too work with bzImages most of the time. They are convenient 
single-file objects that are easy to distribute and easy to use, and 
they also have no Linux-distribution-flavor dependencies. (module load 
order can be influenced by things like /etc/modprobe.conf and other 
details - make reproduction harder and testing less conclusive, etc.)

> > ------------->
> > commit 7bcebd2e3ee8435e2ff0f674a409f46961fda3cc
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Fri Jun 27 21:20:17 2008 +0200
> >
> >    stacktrace: export print_stack_trace and save_stack_trace
> >
> >    fix:
> >
> >    ERROR: "print_stack_trace" [kernel/backtracetest.ko] undefined!
> >    ERROR: "save_stack_trace" [kernel/backtracetest.ko] undefined!
> >
> >    Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >
> >    Conflicts:
> >
> >    Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >
> > diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
> > index c28c342..b7b483b 100644
> > --- a/arch/x86/kernel/stacktrace.c
> > +++ b/arch/x86/kernel/stacktrace.c
> > @@ -74,10 +74,4 @@ void save_stack_trace(struct stack_trace *trace)
> >        if (trace->nr_entries < trace->max_entries)
> >                trace->entries[trace->nr_entries++] = ULONG_MAX;
> >  }
> > -
> > -void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
> > -{
> > -       dump_trace(tsk, NULL, NULL, 0, &save_stack_ops_nosched, trace);
> > -       if (trace->nr_entries < trace->max_entries)
> > -               trace->entries[trace->nr_entries++] = ULONG_MAX;
> > -}
> 
> Why is this removed, though? (It seems unrelated, and that's a useful 
> function.)

that was an oversight - thanks - fixed it - updated commit below.

	Ingo

---------------->
commit a73d1be0974856741a258928966b8a03ae6bb74f
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jun 27 21:20:17 2008 +0200

    stacktrace: fix modular build, export print_stack_trace and save_stack_trace
    
    fix:
    
    ERROR: "print_stack_trace" [kernel/backtracetest.ko] undefined!
    ERROR: "save_stack_trace" [kernel/backtracetest.ko] undefined!
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    
    and fix:
    
      Building modules, stage 2.
      MODPOST 376 modules
    ERROR: "print_stack_trace" [kernel/backtracetest.ko] undefined!
    make[1]: *** [__modpost] Error 1
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index c28c342..a03e7f6 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -74,6 +74,7 @@ void save_stack_trace(struct stack_trace *trace)
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
+EXPORT_SYMBOL_GPL(save_stack_trace);
 
 void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
@@ -81,3 +82,4 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
+EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index 7eaea9d..94b527e 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -6,6 +6,7 @@
  *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  */
 #include <linux/sched.h>
+#include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/stacktrace.h>
 
@@ -21,4 +22,5 @@ void print_stack_trace(struct stack_trace *trace, int spaces)
 		print_ip_sym(trace->entries[i]);
 	}
 }
+EXPORT_SYMBOL_GPL(print_stack_trace);
 
