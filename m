Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZHPJyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZHPJyF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZHPJyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:54:04 -0400
Received: from bu3sch.de ([62.75.166.246]:36564 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbZHPJyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:54:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linux-kernel@vger.kernel.org
Subject: Threaded interrupt handlers broken?
Date: Sun, 16 Aug 2009 11:53:13 +0200
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908161153.14081.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was trying to use threaded interrupt handlers, but the code always crashes
within irq_thread() with a "BUG: spinlock bad magic 00000000".
The spinlock that's not properly initialized is from the wait_for_threads waitqueue.
It crashes on line 526 (see below).
The initialization of the waitqueue struct seems to depend on whether the IRQ is
shared or not. I don't know if that's correct, but I patched it to unconditionally
initialize the struct. That did not help.

Any ideas?


490 static int irq_thread(void *data)
491 {
492         struct sched_param param = { .sched_priority = MAX_USER_RT_PRIO/2, };
493         struct irqaction *action = data;
494         struct irq_desc *desc = irq_to_desc(action->irq);
495         int wake;
496 
497         sched_setscheduler(current, SCHED_FIFO, &param);
498         current->irqaction = action;
499 
500         while (!irq_wait_for_interrupt(action)) {
501 
502                 irq_thread_check_affinity(desc, action);
503 
504                 atomic_inc(&desc->threads_active);
505 
506                 spin_lock_irq(&desc->lock);
507                 if (unlikely(desc->status & IRQ_DISABLED)) {
508                         /*
509                          * CHECKME: We might need a dedicated
510                          * IRQ_THREAD_PENDING flag here, which
511                          * retriggers the thread in check_irq_resend()
512                          * but AFAICT IRQ_PENDING should be fine as it
513                          * retriggers the interrupt itself --- tglx
514                          */
515                         desc->status |= IRQ_PENDING;
516                         spin_unlock_irq(&desc->lock);
517                 } else {
518                         spin_unlock_irq(&desc->lock);
519 
520                         action->thread_fn(action->irq, action->dev_id);
521                 }
522 
523                 wake = atomic_dec_and_test(&desc->threads_active);
524 
525                 if (wake && waitqueue_active(&desc->wait_for_threads))
526                         wake_up(&desc->wait_for_threads);                <<<<<<<<<<<<<<<<<<<<<<<<
527         }
528 
529         /*
530          * Clear irqaction. Otherwise exit_irq_thread() would make
531          * fuzz about an active irq thread going into nirvana.
532          */
533         current->irqaction = NULL;
534         return 0;
535 }

-- 
Greetings, Michael.
