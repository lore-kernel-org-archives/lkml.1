Return-Path: <linux-kernel-owner+w=401wt.eu-S1761272AbZBMH03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761272AbZBMH03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 02:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZBMH0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 02:26:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40675 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbZBMH0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 02:26:17 -0500
Date: Fri, 13 Feb 2009 08:26:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: [patch] rt: sysprof hrtimer fix
Message-ID: <20090213072601.GA26946@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain> <20090213004812.GA5824@nowhere> <20090213021626.GA5807@nowhere> <20090213030919.GA5826@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213030919.GA5826@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > > It seems to run fine for all of them except sysprof. It passes the self-test 
> > > but doesn't produce any trace when I manually try.
> > > 
> > > Not completely sure this is only in -rt so I'm pulling very latest -tip and 
> > > will see if I find the same problem there.
> > 
> > About sysprof, it's an -rt problem, I don't see it on -tip. The sysprof hrtimer 
> > callback is never called.
> > 
> > I'm digging to see what is happening.
> 
> I didn't put my ftrace_printk at the right place. It doesn't come from hrtimer. 
> The problem comes from get_irq_regs() which always returns NULL on the sysprof 
> hrtimer calback, then the trace is immediately dropped by sysprof.

Ah, that makes sense - under -rt the default hrtimer execution is to
execute in a softirq context. Could you try the patch below please,
does it fix sysprof?

	Ingo

------------------>
Subject: rt: sysprof hrtimer fix
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Feb 13 08:22:14 CET 2009

Frederic Weisbecker noticed that sysprof does not work under
.29-rt2, and tracked it down to a NULL result that get_irq_regs()
gives to the sysprof plugin.

The reason for the NULL is that it executes in the HRTIMER_SOFTIRQ
context, hence it does not interrupt any real context and thus
there's no IRQ registers to take a look at.

Since the sysprof functionality is atomic, the fix is to move the
sysprof hrtimers to hardirq context.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_sysprof.c |    1 +
 1 file changed, 1 insertion(+)

Index: tip/kernel/trace/trace_sysprof.c
===================================================================
--- tip.orig/kernel/trace/trace_sysprof.c
+++ tip/kernel/trace/trace_sysprof.c
@@ -202,6 +202,7 @@ static void start_stack_timer(void *unus
 
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = stack_trace_timer_fn;
+	hrtimer->irqsafe = 1;
 
 	hrtimer_start(hrtimer, ns_to_ktime(sample_period), HRTIMER_MODE_REL);
 }
