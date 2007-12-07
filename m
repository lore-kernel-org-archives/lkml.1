Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbXLGLI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbXLGLI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 06:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbXLGLIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 06:08:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57315 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbXLGLIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 06:08:18 -0500
Date: Fri, 7 Dec 2007 12:07:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071207110725.GA8256@elte.hu>
References: <20071207021952.6f0ac922@morte> <20071207084559.GA11162@elte.hu> <20071207023241.15274ef6.akpm@linux-foundation.org> <20071207104013.GC27307@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207104013.GC27307@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > > -				t = printk_clock();
> > > +				t = cpu_clock(printk_cpu);
> > >  				nanosec_rem = do_div(t, 1000000000);
> > >  				tlen = sprintf(tbuf,
> > >  						"<%c>[%5lu.%06lu] ",
> > 
> > A bit risky - it's quite an expansion of code which no longer can call 
> > printk.
> > 
> > You might want to take that WARN_ON out of __update_rq_clock() ;)
> 
> hm, dont we already detect printk recursions and turn them into a 
> silent return instead of a hang/crash?

ugh, we dont. So i guess the (tested) patch below is highly needed. (If 
such incidents become frequent then we could save the stackdump of the 
recursion via save_stack_trace() too - but i wanted to keep the initial 
code simple.)

	Ingo

---------------->
Subject: printk: make printk more robust by not allowing recursion
From: Ingo Molnar <mingo@elte.hu>

make printk more robust by allowing recursion only if there's a crash
going on. Also add recursion detection.

I've tested it with an artificially injected printk recursion - instead
of a lockup or spontaneous reboot or other crash, the output was a well
controlled:

[   41.057335] SysRq : <2>BUG: recent printk recursion!
[   41.057335] loglevel0-8 reBoot Crashdump show-all-locks(D) tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks Unmount shoW-blocked-tasks

also do all this printk logic with irqs disabled.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/printk.c |   52 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 10 deletions(-)

Index: linux/kernel/printk.c
===================================================================
--- linux.orig/kernel/printk.c
+++ linux/kernel/printk.c
@@ -623,30 +623,57 @@ asmlinkage int printk(const char *fmt, .
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int printk_cpu = UINT_MAX;
 
+const char printk_recursion_bug_msg [] =
+			KERN_CRIT "BUG: recent printk recursion!\n";
+static int printk_recursion_bug;
+
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
+	static int log_level_unknown = 1;
+	static char printk_buf[1024];
+
 	unsigned long flags;
-	int printed_len;
+	int printed_len = 0;
+	int this_cpu;
 	char *p;
-	static char printk_buf[1024];
-	static int log_level_unknown = 1;
 
 	boot_delay_msec();
 
 	preempt_disable();
-	if (unlikely(oops_in_progress) && printk_cpu == smp_processor_id())
-		/* If a crash is occurring during printk() on this CPU,
-		 * make sure we can't deadlock */
-		zap_locks();
-
 	/* This stops the holder of console_sem just where we want him */
 	raw_local_irq_save(flags);
+	this_cpu = smp_processor_id();
+
+	/*
+	 * Ouch, printk recursed into itself!
+	 */
+	if (unlikely(printk_cpu == this_cpu)) {
+		/*
+		 * If a crash is occurring during printk() on this CPU,
+		 * then try to get the crash message out but make sure
+		 * we can't deadlock. Otherwise just return to avoid the
+		 * recursion and return - but flag the recursion so that
+		 * it can be printed at the next appropriate moment:
+		 */
+		if (!oops_in_progress) {
+			printk_recursion_bug = 1;
+			goto out_restore_irqs;
+		}
+		zap_locks();
+	}
+
 	lockdep_off();
 	spin_lock(&logbuf_lock);
-	printk_cpu = smp_processor_id();
+	printk_cpu = this_cpu;
 
+	if (printk_recursion_bug) {
+		printk_recursion_bug = 0;
+		strcpy(printk_buf, printk_recursion_bug_msg);
+		printed_len = sizeof(printk_recursion_bug_msg);
+	}
 	/* Emit the output into the temporary buffer */
-	printed_len = vscnprintf(printk_buf, sizeof(printk_buf), fmt, args);
+	printed_len += vscnprintf(printk_buf + printed_len,
+				  sizeof(printk_buf), fmt, args);
 
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
@@ -675,6 +702,10 @@ asmlinkage int vprintk(const char *fmt, 
 					loglev_char = default_message_loglevel
 						+ '0';
 				}
+				if (panic_timeout) {
+					panic_timeout = 0;
+					printk("recurse!\n");
+				}
 				t = cpu_clock(printk_cpu);
 				nanosec_rem = do_div(t, 1000000000);
 				tlen = sprintf(tbuf,
@@ -739,6 +770,7 @@ asmlinkage int vprintk(const char *fmt, 
 		printk_cpu = UINT_MAX;
 		spin_unlock(&logbuf_lock);
 		lockdep_on();
+out_restore_irqs:
 		raw_local_irq_restore(flags);
 	}
 
