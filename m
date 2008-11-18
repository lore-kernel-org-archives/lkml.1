Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbYKRU4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbYKRU4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 15:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYKRU4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 15:56:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60164 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbYKRU4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 15:56:15 -0500
Date: Tue, 18 Nov 2008 21:55:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: ftrace: preemptoff selftest not working
Message-ID: <20081118205558.GA6243@elte.hu>
References: <20081118125359.GA4417@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0811180826510.15003@gandalf.stny.rr.com> <20081118135221.GE31146@elte.hu> <alpine.DEB.1.10.0811180931270.15003@gandalf.stny.rr.com> <20081118144751.GA30358@elte.hu> <20081118170635.GB4417@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0811181220530.15003@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811181220530.15003@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Tue, 18 Nov 2008, Heiko Carstens wrote:
> > > 
> > > we can drop it in selected initcalls just fine. Its only role is 
> > > old-style init functions racing with other async contexts of 
> > > themselves.
> > 
> > Something like below works fine for me...
> > 
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>

i've applied it in the form below to tip/tracing/ftrace, thanks guys!

Since it's only about the self-test, and since they have not been 
working for a long time, i'm punting this to v2.6.29, not .28.

	Ingo

------------->
>From a22506347d038a66506c6f57e9b97104128e280d Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Tue, 18 Nov 2008 18:06:35 +0100
Subject: [PATCH] ftrace: preemptoff selftest not working

Impact: fix preemptoff and preemptirqsoff tracer self-tests

I was wondering why the preemptoff and preemptirqsoff tracer selftests
don't work on s390. After all its just that they get called from
non-preemptible context:

kernel_init() will execute all initcalls, however the first line in
kernel_init() is lock_kernel(), which causes the preempt_count to be
increased. Any later calls to add_preempt_count() (especially those
from the selftests) will therefore not result in a call to
trace_preempt_off() since the check below in add_preempt_count()
will be false:

        if (preempt_count() == val)
                trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));

Hence the trace buffer will be empty.

Fix this by releasing the BKL during the self-tests.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 396fda0..1689212 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -532,6 +532,13 @@ int register_tracer(struct tracer *type)
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
@@ -562,6 +569,7 @@ int register_tracer(struct tracer *type)
 		}
 		printk(KERN_CONT "PASSED\n");
 	}
+	lock_kernel();
 #endif
 
 	type->next = trace_types;
