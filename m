Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbYCWWle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbYCWWle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 18:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbYCWWlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 18:41:24 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59047 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbYCWWlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 18:41:19 -0400
Date: Sun, 23 Mar 2008 22:34:55 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, paulus@samba.org,
       ralf@linux-mips.org, davem@davemloft.net, lethal@linux-sh.org,
       jdike@addtoit.com
Subject: Re: tick-common.c hack for s390 needed
Message-ID: <20080323223455.GA746@flint.arm.linux.org.uk>
References: <20080318093119.GA8669@osiris.boeblingen.de.ibm.com> <20080319054545.GA18834@infradead.org> <20080321101504.GI20420@elte.hu> <20080321132559.GA4128@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0803211545160.3781@apollo.tec.linutronix.de> <20080322203223.GA31521@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080322203223.GA31521@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 09:32:23PM +0100, Heiko Carstens wrote:
> Generic code is not supposed to include irq.h. Replace this include
> by linux/hardirq.h instead and add/replace an include of linux/irq.h
> in asm header files where necessary.
> This change should only matter for architectures that make use of
> GENERIC_CLOCKEVENTS.
> Architectures in question are mips, x86, arm, sh, powerpc, uml and sparc64.
> 
> I did some cross compile tests for mips, x86_64, arm, powerpc and sparc64.
> This patch fixes also build breakages caused by the include replacement in
> tick-common.h.

I generally dislike adding optional linux/* includes in asm/* includes -
I'm nervous about this causing include loops.

However, there's a separate point to be discussed here.

That is, what interfaces are expected of every architecture in the kernel.
If generic code wants to be able to set the affinity of interrupts, then
that needs to become part of the interfaces listed in linux/interrupt.h
rather than linux/irq.h.

So what I suggest is this approach instead (against Linus' tree of a
couple of days ago) - we move irq_set_affinity() and irq_can_set_affinity()
to linux/interrupt.h, change the linux/irq.h includes to linux/interrupt.h
and include asm/irq_regs.h where needed (asm/irq_regs.h is supposed to be
rarely used include since not much touches the stacked parent context
registers.)

Build tested on ARM PXA family kernels and ARM's Realview platform
kernels which both use genirq.

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index f8ab4ce..355e3b0 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -102,6 +102,25 @@ extern void disable_irq_nosync(unsigned int irq);
 extern void disable_irq(unsigned int irq);
 extern void enable_irq(unsigned int irq);
 
+#ifdef CONFIG_SMP
+
+extern int irq_set_affinity(unsigned int irq, cpumask_t cpumask);
+extern int irq_can_set_affinity(unsigned int irq);
+
+#else /* CONFIG_SMP */
+
+static inline int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
+{
+	return -EINVAL;
+}
+
+static inline int irq_can_set_affinity(unsigned int irq)
+{
+	return 0;
+}
+
+#endif /* CONFIG_SMP */
+
 #ifdef CONFIG_GENERIC_HARDIRQS
 /*
  * Special lockdep variants of irq disabling/enabling.
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 176e5e7..1883a85 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -228,21 +228,11 @@ static inline void set_pending_irq(unsigned int irq, cpumask_t mask)
 
 #endif /* CONFIG_GENERIC_PENDING_IRQ */
 
-extern int irq_set_affinity(unsigned int irq, cpumask_t cpumask);
-extern int irq_can_set_affinity(unsigned int irq);
-
 #else /* CONFIG_SMP */
 
 #define move_native_irq(x)
 #define move_masked_irq(x)
 
-static inline int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
-{
-	return -EINVAL;
-}
-
-static inline int irq_can_set_affinity(unsigned int irq) { return 0; }
-
 #endif /* CONFIG_SMP */
 
 #ifdef CONFIG_IRQBALANCE
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index e1bd50c..fdfa0c7 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -14,7 +14,7 @@
 #include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/hrtimer.h>
-#include <linux/irq.h>
+#include <linux/interrupt.h>
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 1bea399..4f38865 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -14,12 +14,14 @@
 #include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/hrtimer.h>
-#include <linux/irq.h>
+#include <linux/interrupt.h>
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/tick.h>
 
+#include <asm/irq_regs.h>
+
 #include "tick-internal.h"
 
 /*
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 0258d31..450c049 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -14,7 +14,7 @@
 #include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/hrtimer.h>
-#include <linux/irq.h>
+#include <linux/interrupt.h>
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>


-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
