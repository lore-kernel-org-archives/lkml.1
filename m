Return-Path: <linux-kernel-owner+w=401wt.eu-S1946117AbXD3XlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946117AbXD3XlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946118AbXD3XlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:41:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61055 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946117AbXD3Xk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:40:58 -0400
Date: Mon, 30 Apr 2007 16:37:12 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Bill Irwin <bill.irwin@oracle.com>
Cc: linux-kernel@vger.kernel.org, bunk@stusta.de, akpm@osdl.org,
       gcoady@gmail.com, zlynx@acm.org, dgc@sgi.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, hch@infradead.org, jengelh@linux01.gwdg.de,
       zwane@infradead.org, neilb@suse.de, jens.axboe@oracle.com,
       eric@provenscaling.com, wli@holomorphy.com
Subject: [2/3] unconditional i386 IRQ stacks
Message-ID: <20070430233712.GI26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	linux-kernel@vger.kernel.org, bunk@stusta.de, akpm@osdl.org,
	gcoady@gmail.com, zlynx@acm.org, dgc@sgi.com,
	alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, hch@infradead.org,
	jengelh@linux01.gwdg.de, zwane@infradead.org, neilb@suse.de,
	jens.axboe@oracle.com, eric@provenscaling.com
References: <20070430232351.GG26598@holomorphy.com> <20070430233309.GH26598@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430233309.GH26598@holomorphy.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ stacks are a valuable stability feature. This patch makes them
unconditional, as there is no circumstance under which they do not
improve stability and they have no meaningful performance impact.

Signed-off-by: William Irwin <bill.irwin@oracle.com>


Index: stack-paranoia/include/asm-i386/irq.h
===================================================================
--- stack-paranoia.orig/include/asm-i386/irq.h	2007-04-30 14:29:14.390652748 -0700
+++ stack-paranoia/include/asm-i386/irq.h	2007-04-30 14:32:46.742754004 -0700
@@ -24,14 +24,9 @@
 # define ARCH_HAS_NMI_WATCHDOG		/* See include/linux/nmi.h */
 #endif
 
-#ifdef CONFIG_4KSTACKS
-  extern void irq_ctx_init(int cpu);
-  extern void irq_ctx_exit(int cpu);
-# define __ARCH_HAS_DO_SOFTIRQ
-#else
-# define irq_ctx_init(cpu) do { } while (0)
-# define irq_ctx_exit(cpu) do { } while (0)
-#endif
+void irq_ctx_init(int);
+void irq_ctx_exit(int);
+#define __ARCH_HAS_DO_SOFTIRQ
 
 #ifdef CONFIG_IRQBALANCE
 extern int irqbalance_disable(char *str);
Index: stack-paranoia/arch/i386/kernel/irq.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/irq.c	2007-04-30 14:31:14.717509785 -0700
+++ stack-paranoia/arch/i386/kernel/irq.c	2007-04-30 14:43:02.869865087 -0700
@@ -49,7 +49,6 @@
 #endif
 }
 
-#ifdef CONFIG_4KSTACKS
 /*
  * per-CPU IRQ handling contexts (thread information and stack)
  */
@@ -60,7 +59,6 @@
 
 static DEFINE_PER_CPU(union irq_ctx *, hardirq_ctx);
 static DEFINE_PER_CPU(union irq_ctx *, softirq_ctx);
-#endif
 
 /*
  * do_IRQ handles all normal device IRQ's (the special
@@ -73,10 +71,8 @@
 	/* high bit used in ret_from_ code */
 	int irq = ~regs->orig_eax;
 	struct irq_desc *desc = irq_desc + irq;
-#ifdef CONFIG_4KSTACKS
 	union irq_ctx *curctx, *irqctx;
 	u32 *isp;
-#endif
 
 	if (unlikely((unsigned)irq >= NR_IRQS)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
@@ -100,9 +96,6 @@
 		}
 	}
 #endif
-
-#ifdef CONFIG_4KSTACKS
-
 	curctx = (union irq_ctx *) current_thread_info();
 	irqctx = per_cpu(hardirq_ctx, smp_processor_id());
 
@@ -138,7 +131,6 @@
 			: "memory", "cc"
 		);
 	} else
-#endif
 		desc->handle_irq(irq, desc);
 
 	irq_exit();
@@ -146,8 +138,6 @@
 	return 1;
 }
 
-#ifdef CONFIG_4KSTACKS
-
 /*
  * These should really be __section__(".bss.page_aligned") as well, but
  * gcc's 3.0 and earlier don't handle that correctly.
@@ -251,7 +241,6 @@
 }
 
 EXPORT_SYMBOL(do_softirq);
-#endif
 
 /*
  * Interrupt statistics:
