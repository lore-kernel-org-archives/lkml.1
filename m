Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbZB1FMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbZB1FMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 00:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbZB1FMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 00:12:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790AbZB1FMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 00:12:38 -0500
Date: Fri, 27 Feb 2009 21:12:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: me@felipebalbi.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       dmitry.torokhov@gmail.com, sameo@openedhand.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs (was: ...)
Message-Id: <20090227211203.4ebb0524.akpm@linux-foundation.org>
In-Reply-To: <200902272046.50572.david-b@pacbell.net>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	<200902271830.37207.david-b@pacbell.net>
	<20090227183949.90f231e6.akpm@linux-foundation.org>
	<200902272046.50572.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 20:46:50 -0800 David Brownell <david-b@pacbell.net> wrote:

>   drivers/mfd/twl4030-irq.c
> 
> Where you'll observe twl_init_irq() at line 688 setting
> up the thread and the Primary IRQ Handler (PIH) dispatch.
> That's pretty much bog-standard chained IRQ setup code,
> except that it chains through a thread.

OK, that's clever.  I never knew that anyone was doing that.  afaict
MFD is the only such place...

Yes, it's regrettable that it's a private-to-mfd implementation.  I
expect a lot of i2c clients (at least) would like this.

> When an IRQ comes in, handle_twl4030_pih() acks and masks
> that top level IRQ.  Then it wakes twl4030_irq_thread(),
> which issues I2C operations to read the IRQ status from
> the chip ... first PIH to find out which SIH modules are
> raising an IRQ, then SIH to dispatch that status.  Then
> handle_irq() from that thread to invoke the handler in
> that thread context; it will issue more I2C ops.

yup.

> And the lockdep thing kicks in through handle_irq(),
> where the IRQ handler wrongly gets invoked with the
> IRQs disabled -- iff lockdep is enabled.  Otherwise,
> that IRQ thread is just like any other thread.

OK.

Perhaps it would be somewhat less dirty to do something like

--- a/kernel/irq/manage.c~a
+++ a/kernel/irq/manage.c
@@ -689,7 +689,8 @@ int request_irq(unsigned int irq, irq_ha
 	/*
 	 * Lockdep wants atomic interrupt handlers:
 	 */
-	irqflags |= IRQF_DISABLED;
+	if (!(irqflags & IRQF_NO_LOCKDEP_HACK))
+		irqflags |= IRQF_DISABLED;
 #endif
 	/*
 	 * Sanity-check: shared interrupts must pass in a real dev-ID,
_

