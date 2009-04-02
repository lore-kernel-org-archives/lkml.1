Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbZDBOd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbZDBOd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757637AbZDBOdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:33:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:49165 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbZDBOdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:33:16 -0400
Subject: Re: [tip:irq/genirq] genirq: do not execute DEBUG_SHIRQ when irq
 setup failed
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       henrix@sapo.pt, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-ba71604fad348656071a2a76eef9a67dab85a773@git.kernel.org>
References: <20090401170635.GA4392@hades.domain.com>
	 <tip-ba71604fad348656071a2a76eef9a67dab85a773@git.kernel.org>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 20:02:27 +0530
Message-Id: <1238682747.3099.16.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 14:03 +0000, Luis Henriques wrote:
> Commit-ID:  ba71604fad348656071a2a76eef9a67dab85a773
> Gitweb:     http://git.kernel.org/tip/ba71604fad348656071a2a76eef9a67dab85a773
> Author:     Luis Henriques <henrix@sapo.pt>
> AuthorDate: Wed, 1 Apr 2009 18:06:35 +0100
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Thu, 2 Apr 2009 16:02:39 +0200
> 
> genirq: do not execute DEBUG_SHIRQ when irq setup failed
> 
> When requesting an IRQ, the DEBUG_SHIRQ code executes a fake IRQ just to make
> sure the driver is ready to receive an IRQ immediately.  The problem was that
> this fake IRQ was being executed even if interrupt line failed to be allocated
> by __setup_irq.
> 
> Signed-off-by: Luis Henriques <henrix@sapo.pt>
> LKML-Reference: <20090401170635.GA4392@hades.domain.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> 
> ---
>  kernel/irq/manage.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 1516ab7..beeb7d1 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -768,7 +768,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
>  		kfree(action);
>  
>  #ifdef CONFIG_DEBUG_SHIRQ
> -	if (irqflags & IRQF_SHARED) {
> +	if (!retval & (irqflags & IRQF_SHARED)) {
>  		/*
>  		 * It's a shared IRQ -- the driver ought to be prepared for it
>  		 * to happen immediately, so let's make sure....

What is this ?

There is no retval:

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=blob;f=kernel/irq/manage.c;h=a3eb7baf1e46f2c735edb4cc44e0386cfbc4989e;hb=HEAD

*/
696 static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
697 {
698         struct irq_desc *desc = irq_to_desc(irq);
699         struct irqaction *action, **action_ptr;
700         struct task_struct *irqthread;
701         unsigned long flags;
702 
703         WARN(in_interrupt(), "Trying to free IRQ %
d from IRQ context!\n", irq);
704 
705         if (!desc)
706                 return NULL;
707 
708         spin_lock_irqsave(&desc->lock, flags);
709 
710         /*
711
         * There can be multiple actions per IRQ descriptor, find the right
712          * one based on the dev_id:
713          */
714         action_ptr = &desc->action;
715         for (;;) {
716                 action = *action_ptr;
717 
718                 if (!action) {
719                         WARN(1, "Trying to free already-free IRQ %d
\n", irq);
720                         spin_unlock_irqrestore(&desc->lock, flags);
721 
722                         return NULL;
723                 }
724 
725                 if (action->dev_id == dev_id)
726                         break;
727                 action_ptr = &action->next;
728         }
729 
730         /* Found it - now remove it from the list of entries: */
731         *action_ptr = action->next;
732 
733         /* Currently used only by UML, might disappear one day: */
734 #ifdef CONFIG_IRQ_RELEASE_METHOD
735         if (desc->chip->release)
736                 desc->chip->release(irq, dev_id);
737 #endif
738 
739         /* If this was the last handler, shut down the IRQ line: */
740         if (!desc->action) {
741                 desc->status |= IRQ_DISABLED;
742                 if (desc->chip->shutdown)
743                         desc->chip->shutdown(irq);
744                 else
745                         desc->chip->disable(irq);
746         }
747 
748         irqthread = action->thread;
749         action->thread = NULL;
750 
751         spin_unlock_irqrestore(&desc->lock, flags);
752 
753         unregister_handler_proc(irq, action);
754 
755         /* Make sure it's not being used on another CPU: */
756         synchronize_irq(irq);
757 
758         if (irqthread) {
759                 if (!test_bit(IRQTF_DIED, &action->thread_flags))
760                         kthread_stop(irqthread);
761                 put_task_struct(irqthread);
762         }
763 
764 #ifdef CONFIG_DEBUG_SHIRQ
765         /*
766
         * It's a shared IRQ -- the driver ought to be prepared for an IRQ
767
         * event to happen even now it's being freed, so let's make sure that
768          * is so by doing an extra call to the handler ....
769          *
770
         * ( We do this after actually deregistering it, to make sure that a
771          *   'real' IRQ doesn't run in * parallel with our fake. )
772          */
773         if (action->flags & IRQF_SHARED) {
774                 local_irq_save(flags);
775                 action->handler(irq, dev_id);
776                 local_irq_restore(flags);
777         }
778 #endif
779         return action;
780 }


