Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbZHPMpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbZHPMpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 08:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZHPMpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 08:45:53 -0400
Received: from bu3sch.de ([62.75.166.246]:59297 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbZHPMpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 08:45:53 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Threaded interrupt handlers broken?
Date: Sun, 16 Aug 2009 14:45:52 +0200
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>
References: <200908161153.14081.mb@bu3sch.de> <200908161214.37008.mb@bu3sch.de>
In-Reply-To: <200908161214.37008.mb@bu3sch.de>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908161445.53147.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 August 2009 12:14:36 Michael Buesch wrote:
> > 506                 spin_lock_irq(&desc->lock);
> > 507                 if (unlikely(desc->status & IRQ_DISABLED)) {
> > 508                         /*
> > 509                          * CHECKME: We might need a dedicated
> > 510                          * IRQ_THREAD_PENDING flag here, which
> > 511                          * retriggers the thread in check_irq_resend()
> > 512                          * but AFAICT IRQ_PENDING should be fine as it
> > 513                          * retriggers the interrupt itself --- tglx
> > 514                          */
> > 515                         desc->status |= IRQ_PENDING;
> > 516                         spin_unlock_irq(&desc->lock);
> > 517                 } else {
> > 518                         spin_unlock_irq(&desc->lock);
> > 519 
> > 520                         action->thread_fn(action->irq, action->dev_id);
> > 521                 }
> > 522 
> > 523                 wake = atomic_dec_and_test(&desc->threads_active);
> 
> Is this test logic inverted? atomic_dec_and_test() means
> (threads_active - 1) == 0
> Shouldn't it be like this?
> (threads_active - 1) != 0

I need the following patch for threaded IRQs to work.
The first hunk obviously is incorrect. But without it the thread_fn is
never called.

Index: wireless-testing/kernel/irq/manage.c
===================================================================
--- wireless-testing.orig/kernel/irq/manage.c	2009-08-15 22:22:07.000000000 +0200
+++ wireless-testing/kernel/irq/manage.c	2009-08-16 14:05:23.000000000 +0200
@@ -504,7 +504,7 @@ static int irq_thread(void *data)
 		atomic_inc(&desc->threads_active);
 
 		spin_lock_irq(&desc->lock);
-		if (unlikely(desc->status & IRQ_DISABLED)) {
+		if (0&&unlikely(desc->status & IRQ_DISABLED)) {
 			/*
 			 * CHECKME: We might need a dedicated
 			 * IRQ_THREAD_PENDING flag here, which
@@ -520,7 +520,7 @@ static int irq_thread(void *data)
 			action->thread_fn(action->irq, action->dev_id);
 		}
 
-		wake = atomic_dec_and_test(&desc->threads_active);
+		wake = !atomic_dec_and_test(&desc->threads_active);
 
 		if (wake && waitqueue_active(&desc->wait_for_threads))
 			wake_up(&desc->wait_for_threads);



-- 
Greetings, Michael.
