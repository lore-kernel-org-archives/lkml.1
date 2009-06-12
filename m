Return-Path: <linux-kernel-owner+w=401wt.eu-S1759171AbZFLTxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171AbZFLTxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 15:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbZFLTwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 15:52:49 -0400
Received: from www.tglx.de ([62.245.132.106]:40891 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbZFLTws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 15:52:48 -0400
Date: Fri, 12 Jun 2009 21:52:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kevin Hilman <khilman@deeprootsystems.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: do not disable IRQ_WAKEUP marked irqs on
 suspend
In-Reply-To: <87hbylb8u3.fsf@deeprootsystems.com>
Message-ID: <alpine.LFD.2.00.0906122039420.2800@localhost.localdomain>
References: <cMiA9-1MZ-13@gated-at.bofh.it> <87fxe5fi9v.fsf@deeprootsystems.com> <alpine.LFD.2.00.0906122005140.2800@localhost.localdomain> <87hbylb8u3.fsf@deeprootsystems.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Kevin Hilman wrote:
>   http://lkml.org/lkml/2009/5/4/448
> 
> Only difference is I did the checking outside of the lock, which is
> probably wrong.  In any case, you'll be interested in the thread that
> follows.

Hmm, darn. That means that on hardware which has trouble with the
delayed disable and therefor uses it's own chip->disable_irq() method
the suspend logic is wreckaged.

But there is always a way to get broken hardware tamed. :)

suspend does:
	__disable_irq();
		status |= IRQ_SUSPENDED;
		chip->disable_irq();

resume does:
       __enable_irq();
		status &= ~IRQ_SUSPENDED;
		chip->enable_irq();

So

-      set_irq_handler(handle_level_irq);
+      set_irq_handler(my_own_handler);

+my_own_handler()
+{
+	if (!(status & IRQ_SUSPENDED)) {
+	       handle_level_irq();
+	} else {
+	       mask_at_hardware_level();
+	       status |= IRQ_PENDING;
+	       save_important_information();
+	} 
+}

my_disable_irq()
{
+	if (!(status & IRQ_SUSPENDED))
	       mask_at_hardware_level();
}

my_enable_irq()
{
+	if (important_information_has_been_saved)
+	       replay_what_happened();
+
        unmask_at_hardware_level();
}

Ugly, but that might work somehow. Not sure about the replay part, but
that can be deferred via some more hackery as well :)

Raphael, these delayed disable and the chip->irq_disable() override
implications vs. suspend really need to be documented. The current
comment of suspend_device_irqs() is bogus:

 * During system-wide suspend or hibernation device interrupts need to be
 * disabled at the chip level and this function is provided for this purpose.
   ^^^^^^^^^^^^^^^^^^^^^^^^^^

Thanks,

	tglx
