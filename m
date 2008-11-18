Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYKRRGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYKRRGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbYKRRGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:06:38 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:57647 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbYKRRGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:06:37 -0500
Date: Tue, 18 Nov 2008 18:06:35 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: ftrace: preemptoff selftest not working
Message-ID: <20081118170635.GB4417@osiris.boeblingen.de.ibm.com>
References: <20081118125359.GA4417@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0811180826510.15003@gandalf.stny.rr.com> <20081118135221.GE31146@elte.hu> <alpine.DEB.1.10.0811180931270.15003@gandalf.stny.rr.com> <20081118144751.GA30358@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118144751.GA30358@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 03:47:51PM +0100, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > On Tue, 18 Nov 2008, Ingo Molnar wrote:
> > > 
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > > Hence the trace buffer will be empty. The patch below makes the 
> > > > > selftests working for me, since then they run in preemptible 
> > > > > context. But it is ugly and I'm not proposing it for upstream ;)
> > > > > 
> > > > > Just wanted to make you aware that there is a bug.
> > > > 
> > > > Yep, this might be a better answer than what I put into linux-tip 
> > > > (and my git repo).
> > > > 
> > > > See:
> > > > 
> > > >   ftrace: force pass of preemptoff selftest
> > > > 
> > > > The cause of the bug was the conversion of the BKL back to a 
> > > > spinlock, and making it non preempt.  The initcall code is called 
> > > > with the BKL applied which now means it can not preempt. This breaks 
> > > > the preempt tracer selftest.
> > > > 
> > > > My solution was to just force a pass if this is detected. Perhaps 
> > > > moving the test might be better.
> > > 
> > > it would be better to just drop the BKL in that selftest. (or in all 
> > > selftests - an elevated preempt count will skew a number of things)
> > 
> > I have no problem with that, but does the BKL play any role for 
> > being held? I have no idea why it is taken in boot up, so I'm 
> > hestiant to touch it.
> 
> we can drop it in selected initcalls just fine. Its only role is 
> old-style init functions racing with other async contexts of 
> themselves.

Something like below works fine for me...

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 kernel/trace/trace.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/kernel/trace/trace.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace.c
+++ linux-2.6/kernel/trace/trace.c
@@ -482,6 +482,13 @@ int register_tracer(struct tracer *type)
 	}
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
+	/*
+	 * When this gets called we hold the BKL which means that preemption
+	 * is disabled. Various trace selftests however need to disable
+	 * and enable preemption for successful tests. So we drop the BKL here
+	 * and grab it after the tests again.
+	 */
+	unlock_kernel();
 	if (type->selftest) {
 		struct tracer *saved_tracer = current_trace;
 		struct trace_array *tr = &global_trace;
@@ -515,6 +522,7 @@ int register_tracer(struct tracer *type)
 		}
 		printk(KERN_CONT "PASSED\n");
 	}
+	lock_kernel();
 #endif
 
 	type->next = trace_types;
