Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbYKWIIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbYKWIIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 03:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYKWII2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 03:08:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41069 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbYKWII1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 03:08:27 -0500
Date: Sun, 23 Nov 2008 09:08:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: jia zhang <jia.zhang2008@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       Arjan van de Ven <arjan@infradead.org>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: [PATCH] x86: clean up stack overflow debug check
Message-ID: <20081123080816.GA30453@elte.hu>
References: <4928B72D.20901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4928B72D.20901@gmail.com>
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


* jia zhang <jia.zhang2008@gmail.com> wrote:

> stack_overflow_check() should consider the stack usage of pt_regs, 
> and thus it could warn us in advance. Additionally, it looks a bit 
> good that the warning time starts at INITIAL_JIFFIES.
> 
> Signed-off-by: jia zhang <jia.zhang2008@gmail.com>
> ---
> Assume at the moment rsp get close to the check point before 
> interrupt arrives. When interrupt really happens, thread_info will 
> be partly overrode.
> 
>  arch/x86/kernel/irq_64.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> --- a/arch/x86/kernel/irq_64.c
> +++ b/arch/x86/kernel/irq_64.c
> @@ -29,11 +29,12 @@
>  static inline void stack_overflow_check(struct pt_regs *regs)
>  {
>  	u64 curbase = (u64)task_stack_page(current);
> -	static unsigned long warned = -60*HZ;
> +	static unsigned long warned = INITIAL_JIFFIES - 60*HZ;
>  
>  	if (regs->sp >= curbase && regs->sp <= curbase + THREAD_SIZE &&
> -	    regs->sp <  curbase + sizeof(struct thread_info) + 128 &&
> -	    time_after(jiffies, warned + 60*HZ)) {
> +			regs->sp < curbase + sizeof(struct thread_info) +
> +			sizeof(struct pt_regs) + 128 &&
> +			time_after(jiffies, warned + 60*HZ)) {
>  		printk("do_IRQ: %s near stack overflow (cur:%Lx,sp:%lx)\n",
>  		       current->comm, curbase, regs->sp);
>  		show_stack(NULL,NULL);

applied to tip/x86/debug, thanks! I also applied the clean up patch 
below on top of your fix.

	Ingo

----------------->
>From f377fa123d0ec621e8e361ecc3f2a8ee70e81a2e Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 23 Nov 2008 09:02:26 +0100
Subject: [PATCH] x86: clean up stack overflow debug check

Impact: cleanup

Simplify the irq-sampled stack overflow debug check:

 - eliminate an #idef

 - use WARN_ONCE() to emit a single warning (all bets are off
   after the first such warning anyway)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/irq_64.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index b842fc8..1d3d0e7 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -18,7 +18,6 @@
 #include <asm/idle.h>
 #include <asm/smp.h>
 
-#ifdef CONFIG_DEBUG_STACKOVERFLOW
 /*
  * Probabilistic stack overflow check:
  *
@@ -28,20 +27,18 @@
  */
 static inline void stack_overflow_check(struct pt_regs *regs)
 {
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
 	u64 curbase = (u64)task_stack_page(current);
-	static unsigned long warned = INITIAL_JIFFIES - 60*HZ;
-
-	if (regs->sp >= curbase && regs->sp <= curbase + THREAD_SIZE &&
-			regs->sp < curbase + sizeof(struct thread_info) +
-			sizeof(struct pt_regs) + 128 &&
-			time_after(jiffies, warned + 60*HZ)) {
-		printk("do_IRQ: %s near stack overflow (cur:%Lx,sp:%lx)\n",
-		       current->comm, curbase, regs->sp);
-		show_stack(NULL,NULL);
-		warned = jiffies;
-	}
-}
+
+	WARN_ONCE(regs->sp >= curbase &&
+		  regs->sp <= curbase + THREAD_SIZE &&
+		  regs->sp <  curbase + sizeof(struct thread_info) +
+					sizeof(struct pt_regs) + 128,
+
+		  "do_IRQ: %s near stack overflow (cur:%Lx,sp:%lx)\n",
+			current->comm, curbase, regs->sp);
 #endif
+}
 
 /*
  * do_IRQ handles all normal device IRQ's (the special
@@ -61,9 +58,7 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 	irq_enter();
 	irq = __get_cpu_var(vector_irq)[vector];
 
-#ifdef CONFIG_DEBUG_STACKOVERFLOW
 	stack_overflow_check(regs);
-#endif
 
 	desc = irq_to_desc(irq);
 	if (likely(desc))
