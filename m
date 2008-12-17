Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759019AbYLQKkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019AbYLQKkt (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 05:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbYLQKkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 05:40:39 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37581 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbYLQKki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 05:40:38 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [mmotm and linux-next][PATCH] irq: enclose irq_desc_lock_class in CONFIG_LOCKDEP
Cc: kosaki.motohiro@jp.fujitsu.com,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Yinghai Lu" <yhlu.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
In-Reply-To: <2f11576a0812160458y1c376878vc5fc7f3d208aa344@mail.gmail.com>
References: <20081216121815.GA25019@elte.hu> <2f11576a0812160458y1c376878vc5fc7f3d208aa344@mail.gmail.com>
Message-Id: <20081217193815.F674.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 17 Dec 2008 19:40:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> or, following #ifdef ?
> >>
> >> #if defined(CONFIG_SPARSE_IRQ) || defined(CONFIG_TRACE_IRQFLAGS)
> >>
> >>  /*
> >>  * lockdep: we want to handle all irq_desc locks as a single lock-class:
> >>  */
> >>  static struct lock_class_key irq_desc_lock_class;
> >
> > instead of increasing the #ifdef jungle, how about removing some? For
> > example is this distinction:
> >
> >> >  #ifndef CONFIG_SPARSE_IRQ
> >
> > really needed? We should use symmetric lock class annotations, regardless
> > of how irq_desc[] is laid out.
> 
> it seems make much sense. I'll test your idea tommorow.

Ingo, you are right. I confirmed your idea works well.


I tested following ten pattern.

o handle.c can compile without any warnings?

SPARSE_IRQ	TRACE_IRQ	LOCKDEP
------------------------------------------
n		n		n
Y		n		n
n		Y		n
n		n		Y
Y		Y		n
N		Y		Y
Y		n		Y
Y		Y		Y


o builded kernel works well? (tested on x86_64)

SPARSE_IRQ	TRACE_IRQ	LOCKDEP
------------------------------------------
n		n		n
Y		Y		Y


==
Subject: [PATCH] irq: remove unnecessary ifdef

commit 08678b0841267c1d00d771fe01548d86043d065e introduced
irq_desc_lock_class variable.

But it is used only if CONFIG_SPARSE_IRQ=Y or CONFIG_TRACE_IRQFLAGS=Y.
otherwise, following warnings happend.

	CC      kernel/irq/handle.o
	kernel/irq/handle.c:26: warning: 'irq_desc_lock_class' defined but not used

Actually, current early_init_irq_lock_class has a bit strange and messy ifdef.
In addition, it is not valueable.

1. this function protected by !CONFIG_SPARSE_IRQ. but it is not necessary.
   if CONFIG_SPARSE_IRQ=Y, desc of all irq number are initialized by NULL at first.
   then this function calling is safe.

2. this function protected by CONFIG_TRACE_IRQFLAGS too. but it is not necessary too.
   because lockdep_set_class() doesn't have bad side effect even if CONFIG_TRACE_IRQFLAGS=n, 

This patch bloat kernel size a bit on CONFIG_TRACE_IRQFLAGS=n and CONFIG_SPARSE_IRQ=Y.
that's ok. early_init_irq_lock_class() is not fastpatch at all.

To avoid ifdef messy is important than few byte diet.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
---
 include/linux/lockdep.h |    2 +-
 kernel/irq/handle.c     |    5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

Index: b/kernel/irq/handle.c
===================================================================
--- a/kernel/irq/handle.c	2008-12-17 10:45:56.000000000 +0900
+++ b/kernel/irq/handle.c	2008-12-17 17:26:42.000000000 +0900
@@ -417,11 +417,8 @@ out:
 }
 #endif
 
-
-#ifdef CONFIG_TRACE_IRQFLAGS
 void early_init_irq_lock_class(void)
 {
-#ifndef CONFIG_SPARSE_IRQ
 	struct irq_desc *desc;
 	int i;
 
@@ -431,9 +428,7 @@ void early_init_irq_lock_class(void)
 
 		lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 	}
-#endif
 }
-#endif
 
 #ifdef CONFIG_SPARSE_IRQ
 unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
Index: b/include/linux/lockdep.h
===================================================================
--- a/include/linux/lockdep.h	2008-12-17 10:46:26.000000000 +0900
+++ b/include/linux/lockdep.h	2008-12-17 17:27:18.000000000 +0900
@@ -407,7 +407,7 @@ do {								\
 
 #endif /* CONFIG_LOCKDEP */
 
-#if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_GENERIC_HARDIRQS)
+#ifdef CONFIG_GENERIC_HARDIRQS
 extern void early_init_irq_lock_class(void);
 #else
 static inline void early_init_irq_lock_class(void)




