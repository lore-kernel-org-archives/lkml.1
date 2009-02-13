Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbZBMMFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbZBMMFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZBMMFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:05:00 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:57791 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZBMME7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:04:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S0Q3EUaovpgBUDuxPlzQ1bwPnTr9uTfpomvbCfN9YdD3CDQUaw8pIV3Ep/QtE4rhg4
         aRWeKq9l4/lNC2ClgcsYPoGqoMR7PS6yeggLUFwnPVbYvb2NqTjiQltyiGeBlDcdOXrP
         cNctGmSzXIKuQqkIpZKYVvr4dXdvAcEE0SZRw=
Date: Fri, 13 Feb 2009 13:04:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: Re: [patch] rt: sysprof hrtimer fix
Message-ID: <20090213120451.GA5782@nowhere>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain> <20090213004812.GA5824@nowhere> <20090213021626.GA5807@nowhere> <20090213030919.GA5826@nowhere> <20090213072601.GA26946@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213072601.GA26946@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 08:26:01AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > > It seems to run fine for all of them except sysprof. It passes the self-test 
> > > > but doesn't produce any trace when I manually try.
> > > > 
> > > > Not completely sure this is only in -rt so I'm pulling very latest -tip and 
> > > > will see if I find the same problem there.
> > > 
> > > About sysprof, it's an -rt problem, I don't see it on -tip. The sysprof hrtimer 
> > > callback is never called.
> > > 
> > > I'm digging to see what is happening.
> > 
> > I didn't put my ftrace_printk at the right place. It doesn't come from hrtimer. 
> > The problem comes from get_irq_regs() which always returns NULL on the sysprof 
> > hrtimer calback, then the trace is immediately dropped by sysprof.
> 
> Ah, that makes sense - under -rt the default hrtimer execution is to
> execute in a softirq context. Could you try the patch below please,
> does it fix sysprof?
> 
> 	Ingo

Yes! Thanks :-)

Tested-by: Frederic Weisbecker <fweisbec@gmail.com>

So, just a thing.
-rt make the hrtimer's timers running on softirq context because the hrtimer_interrupt
doesn't run as a threaded interrupt, and then it is not preemptible right?

In that case, sysprof will continue to run in hardirq context, as before, and
it will considerably increase the latency. And that matters here.
So I think it is important to put it on the reminder:

-------------------->
Subject: [PATCH] rt: add sysprof to the latency overhead reminder
From: Frederic Weisbecker <fweisbec@gmail.com>

Since sysprof uses the hrtimer on hardirq with interrupts disabled, it
adds a latency overhead.

Add it to the latency reminder.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
--- linux-2.6.29-rc4/init/~main.c	2009-02-13 12:51:54.000000000 +0100
+++ linux-2.6.29-rc4/init/main.c	2009-02-13 12:55:40.000000000 +0100
@@ -904,7 +904,7 @@ static int __init kernel_init(void * unu
 	WARN_ON(irqs_disabled());
 #endif
 
-#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_IRQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_STACK_TRACER) + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) + defined(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) + (defined(CONFIG_FTRACE) - defined(CONFIG_FTRACE_MCOUNT_RECORD)))
+#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_IRQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_STACK_TRACER) + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) + defined(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) + defined(CONFIG_SYSPROF_TRACER) + (defined(CONFIG_FTRACE) - defined(CONFIG_FTRACE_MCOUNT_RECORD)))
 
 #if DEBUG_COUNT > 0
 	printk(KERN_ERR "*****************************************************************************\n");
@@ -924,6 +924,9 @@ static int __init kernel_init(void * unu
 #ifdef CONFIG_PREEMPT_TRACER
 	printk(KERN_ERR "*        CONFIG_PREEMPT_TRACER                                              *\n");
 #endif
+#ifdef CONFIG_SYSPROF_TRACER
+	printk(KERN_ERR "*        CONFIG_SYSPROF_TRACER                                              *\n");
+#endif
 #ifdef CONFIG_FTRACE
 	printk(KERN_ERR "*        CONFIG_FTRACE                                                      *\n");
 #endif




