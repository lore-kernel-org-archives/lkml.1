Return-Path: <linux-kernel-owner+w=401wt.eu-S1751716AbZKCO6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbZKCO6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZKCO6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:58:50 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:51115 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZKCO6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:58:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j3AR2ERWJVzYmMw9CdBV4BqLR2T2Go1GHheXW7NeC+Wjh5vFARw2hZ6rj9zrgJFo/1
         bvuQhZ9NteiQpZLwjIKPWeg9nOOEa56Lr5CJEjXd2d2VoMe4CsGwldz7w8ao8xBQdehi
         iECjk5oj3qVgH5ZPZnKT63KJN5rytiwJ8tOnM=
MIME-Version: 1.0
In-Reply-To: <20091103134342.24414.82986.sendpatchset@prarit.bos.redhat.com>
References: <20091103134342.24414.82986.sendpatchset@prarit.bos.redhat.com>
Date: Tue, 3 Nov 2009 22:58:54 +0800
Message-ID: <2674af740911030658m76b702cfxb67723984286c4bb@mail.gmail.com>
Subject: Re: [PATCH]: use spin_lock_irqsave in try_one_irq()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This happens because the &desc->lock is taken with spin_lock_irqsave and
> just a spin_lock.  In the try_one_irq(), this lock really should be a
> spin_lock_irqsave().
>

Cc'ed Ingo and Thomas.

The reason is that try_one_irq() is called both from hardirq context and softirq
context. And by default the timer handler poll_all_shared_irqs() is
called with irq enabled.
Then the two usage will cause inconsistent.

So I think the following patch is also workable to you.

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 114e704..11affbc 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -111,6 +111,7 @@ static void poll_all_shared_irqs(void)

 	for_each_irq_desc(i, desc) {
 		unsigned int status;
+		unsigned long flags;

 		if (!i)
 			 continue;
@@ -121,7 +122,9 @@ static void poll_all_shared_irqs(void)
 		if (!(status & IRQ_SPURIOUS_DISABLED))
 			continue;

+		local_irq_save(flags);
 		try_one_irq(i, desc);
+		local_irq_restore(flags);
 	}
 }

> I have not yet narrowed down the reason for the spurious interrupt (although
> I suspect it maybe to do with the radeon driver).
>
> Successfully tested by me.
>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>
> --- linux-2.6.31.x86_64.orig/kernel/irq/spurious.c      2009-09-09 18:13:59.000000000 -0400
> +++ linux-2.6.31.x86_64/kernel/irq/spurious.c   2009-10-26 10:55:56.709845786 -0400
> @@ -27,8 +27,9 @@ static int try_one_irq(int irq, struct i
>  {
>        struct irqaction *action;
>        int ok = 0, work = 0;
> +       unsigned long flags;
>
> -       spin_lock(&desc->lock);
> +       spin_lock_irqsave(&desc->lock, flags);
>        /* Already running on another processor */
>        if (desc->status & IRQ_INPROGRESS) {
>                /*
> @@ -37,13 +38,13 @@ static int try_one_irq(int irq, struct i
>                 */
>                if (desc->action && (desc->action->flags & IRQF_SHARED))
>                        desc->status |= IRQ_PENDING;
> -               spin_unlock(&desc->lock);
> +               spin_unlock_irqrestore(&desc->lock, flags);
>                return ok;
>        }
>        /* Honour the normal IRQ locking */
>        desc->status |= IRQ_INPROGRESS;
>        action = desc->action;
> -       spin_unlock(&desc->lock);
> +       spin_unlock_irqrestore(&desc->lock, flags);
>
>        while (action) {
>                /* Only shared IRQ handlers are safe to call */
> @@ -56,7 +57,7 @@ static int try_one_irq(int irq, struct i
>        }
>        local_irq_disable();
>        /* Now clean up the flags */
> -       spin_lock(&desc->lock);
> +       spin_lock_irqsave(&desc->lock, flags);
>        action = desc->action;
>
>        /*
> @@ -68,9 +69,9 @@ static int try_one_irq(int irq, struct i
>                 * Perform real IRQ processing for the IRQ we deferred
>                 */
>                work = 1;
> -               spin_unlock(&desc->lock);
> +               spin_unlock_irqrestore(&desc->lock, flags);
>                handle_IRQ_event(irq, action);
> -               spin_lock(&desc->lock);
> +               spin_lock_irqsave(&desc->lock, flags);
>                desc->status &= ~IRQ_PENDING;
>        }
>        desc->status &= ~IRQ_INPROGRESS;
> @@ -80,7 +81,7 @@ static int try_one_irq(int irq, struct i
>         */
>        if (work && desc->chip && desc->chip->end)
>                desc->chip->end(irq);
> -       spin_unlock(&desc->lock);
> +       spin_unlock_irqrestore(&desc->lock, flags);
>
>        return ok;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
