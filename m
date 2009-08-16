Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbZHPNWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbZHPNWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 09:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbZHPNWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 09:22:33 -0400
Received: from www.tglx.de ([62.245.132.106]:35397 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbZHPNWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 09:22:32 -0400
Date: Sun, 16 Aug 2009 15:22:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Buesch <mb@bu3sch.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Threaded interrupt handlers broken?
In-Reply-To: <200908161445.53147.mb@bu3sch.de>
Message-ID: <alpine.LFD.2.00.0908161519280.2782@localhost.localdomain>
References: <200908161153.14081.mb@bu3sch.de> <200908161214.37008.mb@bu3sch.de> <200908161445.53147.mb@bu3sch.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Aug 2009, Michael Buesch wrote:
> On Sunday 16 August 2009 12:14:36 Michael Buesch wrote:
> I need the following patch for threaded IRQs to work.
> The first hunk obviously is incorrect. But without it the thread_fn is
> never called.
> 
> Index: wireless-testing/kernel/irq/manage.c
> ===================================================================
> --- wireless-testing.orig/kernel/irq/manage.c	2009-08-15 22:22:07.000000000 +0200
> +++ wireless-testing/kernel/irq/manage.c	2009-08-16 14:05:23.000000000 +0200
> @@ -504,7 +504,7 @@ static int irq_thread(void *data)
>  		atomic_inc(&desc->threads_active);
>  
>  		spin_lock_irq(&desc->lock);
> -		if (unlikely(desc->status & IRQ_DISABLED)) {
> +		if (0&&unlikely(desc->status & IRQ_DISABLED)) {

So the interrupt is marked disabled. How do you setup the handler ?
And what does the primary handler do ? Can you post your driver code please?
>  			/*
>  			 * CHECKME: We might need a dedicated
>  			 * IRQ_THREAD_PENDING flag here, which
> @@ -520,7 +520,7 @@ static int irq_thread(void *data)
>  			action->thread_fn(action->irq, action->dev_id);
>  		}
>  
> -		wake = atomic_dec_and_test(&desc->threads_active);
> +		wake = !atomic_dec_and_test(&desc->threads_active);

So you wake when the thread counter is != 0 after the decrement.

 #define atomic_dec_and_test(v) (atomic_sub_return(1, (v)) == 0)

Thanks,

	tglx
