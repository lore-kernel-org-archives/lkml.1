Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbYLPIey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbYLPIey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 03:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYLPIep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 03:34:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787AbYLPIeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 03:34:44 -0500
Date: Tue, 16 Dec 2008 00:34:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>
Subject: Re: [mmotm and linux-next][PATCH] irq: enclose irq_desc_lock_class
 in CONFIG_LOCKDEP
Message-Id: <20081216003428.43d37b6b.akpm@linux-foundation.org>
In-Reply-To: <20081216170635.DBB8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081216170635.DBB8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 17:08:43 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> 
> Applied after: linux-next.patch
> 
> ==
> Subject: [mmotm][PATCH] irq: enclose irq_desc_lock_class in CONFIG_LOCKDEP
> 
> commit 08678b0841267c1d00d771fe01548d86043d065e introduced
> irq_desc_lock_class variable.
> But it is used only if CONFIG_LOCKDEP=Y.
> otherwise, following warnings happend.
> 
> 	  CC      kernel/irq/handle.o
> 	kernel/irq/handle.c:26: warning: 'irq_desc_lock_class' defined but not used
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Yinghai Lu <yhlu.kernel@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/irq/handle.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: b/kernel/irq/handle.c
> ===================================================================
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -20,10 +20,12 @@
>  
>  #include "internals.h"
>  
> +#ifdef CONFIG_LOCKDEP
>  /*
>   * lockdep: we want to handle all irq_desc locks as a single lock-class:
>   */
>  static struct lock_class_key irq_desc_lock_class;
> +#endif
>  
>  /**
>   * handle_bad_irq - handle spurious and unhandled irqs
> 

No, lockdep.h (which we forgot to include) already handles that:

# define lockdep_set_class(lock, key)		do { (void)(key); } while (0)

the problem is that the code which references irq_desc_lock_class is
inside #ifdef CONFIG_SPARSE_IRQ, so this is a better fix:


--- a/kernel/irq/handle.c~irq-enclose-irq_desc_lock_class-in-config_lockdep
+++ a/kernel/irq/handle.c
@@ -13,6 +13,7 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/random.h>
+#include <linux/lockdep.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/rculist.h>
@@ -20,11 +21,6 @@
 
 #include "internals.h"
 
-/*
- * lockdep: we want to handle all irq_desc locks as a single lock-class:
- */
-static struct lock_class_key irq_desc_lock_class;
-
 /**
  * handle_bad_irq - handle spurious and unhandled irqs
  * @irq:       the interrupt number
@@ -61,6 +57,12 @@ void __init __attribute__((weak)) arch_e
 }
 
 #ifdef CONFIG_SPARSE_IRQ
+
+/*
+ * lockdep: we want to handle all irq_desc locks as a single lock-class:
+ */
+static struct lock_class_key irq_desc_lock_class;
+
 static struct irq_desc irq_desc_init = {
 	.irq	    = -1,
 	.status	    = IRQ_DISABLED,
_

