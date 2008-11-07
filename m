Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYKGIyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYKGIyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 03:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYKGIyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 03:54:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36154 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbYKGIyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 03:54:04 -0500
Date: Fri, 7 Nov 2008 09:53:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ken Chen <kenchen@google.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081107085352.GA27245@elte.hu>
References: <20081106203520.GD3578@elte.hu> <20081107003021.GA18666@google.com> <20081107004824.GA28780@x200.localdomain> <20081107074147.GA26607@elte.hu> <20081107075925.GA1825@elte.hu> <20081107082003.GA15800@x200.localdomain> <20081107083249.GD4435@elte.hu> <20081107084943.GA16147@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107084943.GA16147@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Fri, Nov 07, 2008 at 09:32:49AM +0100, Ingo Molnar wrote:
> > 
> > * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > 
> > > On Fri, Nov 07, 2008 at 08:59:25AM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > > 
> > > > > > > + * buffer size used for proc read.  See proc_info_read().
> > > > > > > + * 4K page size but our output routines use some slack for overruns
> > > > > > > + */
> > > > > > > +#define PROC_BLOCK_SIZE	(3*1024)
> > > > > 
> > > > > That sounds like a proper limit - the hard limit for this particular 
> > > > > printout function is 4096-170, so we are well within the 
> > > > > PROC_BLOCK_SIZE range.
> > > > 
> > > > ok, i've added Ken's patch to tip/core/stacktrace and started testing 
> > > > it.
> > > > 
> > > > Alexey, i've added your Acked-by because you appeared to like the 
> > > > patch - let me know if i should remove it.
> > > 
> > > Of course, I don't like it!
> > > 
> > > Switch to seqfiles, add entry in TID table as well.
> > >
> > > The idea is good, though.
> > 
> > oh well - Ken, could you please switch it to seqfiles?
> > 
> > It should be something like this to convert the currently sweet and 
> > trivial function into a much more complex seqfile iterator splitup:
> > 
> > - the ::start method does the kmalloc of a loop state structure like 
> >   this:
> > 
> >   {
> > 	struct stack_trace backtrace;
> > 	unsigned long entries[MAX_STACK_TRACE_DEPTH];
> > 
> > 	int iterator;
> >   }
> > 
> >   and saves the trace. (struct stack_trace trace can be on-stack, it's 
> >   only needed for the save_stack_trace() - and we keep the entries 
> >   after that.)
> > 
> > - the ::stop method does the kfree of the loop state.
> > 
> > - the ::show method prints a single line, based on ->entries[->iterator]
> > 
> > - the ::next method does ->iterator++, and returns NULL if iterator 
> >   reaches ->backtrace.nr_entries.
> > 
> > it will be more source code, larger kernel image, it will be more 
> > fragile and will be harder to review, and it wont actually matter in 
> > practice because 99.9999% of the backtraces we care about have a size 
> > smaller than 3K. (and where they get larger clipping them to the first 
> > 3K is perfectly fine)
> 
> Or you can do all of this in ->show(), without start/next/stop:
> 
> 	for (i = 0; i < N; i++)
> 		seq_printf(m, "[<%p>] %pS\n", x, x);

hm, is that preferred over the current fs/proc/base.c code?

If that's the preferred way of doing these things, why arent all the 
single-page procfs functions converted over to seq_file:

 #ifdef CONFIG_KALLSYMS
        INF("wchan",      S_IRUGO, pid_wchan),
 #endif
+#ifdef CONFIG_STACKTRACE
+       INF("stack",      S_IRUSR, pid_stack),
+#endif
 #ifdef CONFIG_SCHEDSTATS
        INF("schedstat",  S_IRUGO, pid_schedstat),
 #endif

?

Really, please realize what happened here. All this unnecessary work 
comes from Ken just having done the _natural_ thing when extending the 
existing upstream code: using the existing fs/proc/base.c methods as a 
template to write new code. If those templates use outdated APIs, then 
new code will be "outdated" too - and this confusion will go on 
forever.

	Ingo
