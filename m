Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbYHOKAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbYHOKAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 06:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYHOKA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 06:00:29 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:7528 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbYHOKA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 06:00:28 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [PATCH 00/07] dyn_array/nr_irqs/sparse_irq support v10 - fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080815093546.GA9312@elte.hu>
References: <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080815082735.GC4776@elte.hu>
	 <86802c440808150134x5bf005fmdcb0f557422af365@mail.gmail.com>
	 <20080815085120.GA18748@elte.hu>  <20080815093546.GA9312@elte.hu>
Content-Type: text/plain
Date: Fri, 15 Aug 2008 12:00:30 +0200
Message-Id: <1218794430.10800.237.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-15 at 11:35 +0200, Ingo Molnar wrote:

> looks wrong - it should be unconditional (i've done that via the patch 
> below). I dont remember why we made early_init_irq_lock_class() 
> dependent on CONFIG_TRACE_IRQFLAGS before. Peter, do you have any 
> memories?

Nope, git suggests I poke you about it.. :-)

commit 243c7621aac4ed1aa79524c9a1cecf7c05a28124
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jul 3 00:25:06 2006 -0700

    [PATCH] lockdep: annotate genirq
    
    Teach special (recursive) locking code to the lock validator.  Has no effect
    on non-lockdep kernels.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 80ec7a4..316e0fb 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -270,6 +270,12 @@ static inline int lockdep_internal(void)
 struct lock_class_key { };
 #endif /* !LOCKDEP */
 
+#if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_GENERIC_HARDIRQS)
+extern void early_init_irq_lock_class(void);
+#else
+# define early_init_irq_lock_class()		do { } while (0)
+#endif
+
 #ifdef CONFIG_TRACE_IRQFLAGS
 extern void early_boot_irqs_off(void);
 extern void early_boot_irqs_on(void);
diff --git a/init/main.c b/init/main.c
index fc473d4..628b8e9 100644
--- a/init/main.c
+++ b/init/main.c
@@ -466,6 +466,7 @@ asmlinkage void __init start_kernel(void)
 
 	local_irq_disable();
 	early_boot_irqs_off();
+	early_init_irq_lock_class();
 
 /*
  * Interrupts are still disabled. Do necessary setups, then
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index aeb6e39..a7b497e 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -249,3 +249,19 @@ out:
 	return 1;
 }
 
+#ifdef CONFIG_TRACE_IRQFLAGS
+
+/*
+ * lockdep: we want to handle all irq_desc locks as a single lock-class:
+ */
+static struct lock_class_key irq_desc_lock_class;
+
+void early_init_irq_lock_class(void)
+{
+	int i;
+
+	for (i = 0; i < NR_IRQS; i++)
+		lockdep_set_class(&irq_desc[i].lock, &irq_desc_lock_class);
+}
+
+#endif


