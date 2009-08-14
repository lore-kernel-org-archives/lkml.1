Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbZHNIvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbZHNIvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 04:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbZHNIvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 04:51:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46361 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZHNIvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 04:51:02 -0400
Subject: Re: [RFC patch 2/3] genirq: Add buslock support for irq chips on
 slow busses
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
In-Reply-To: <20090813193116.509070851@linutronix.de>
References: <20090813191535.945521006@linutronix.de>
	 <20090813193116.509070851@linutronix.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Aug 2009 10:50:11 +0200
Message-Id: <1250239811.5241.1198.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 19:40 +0000, Thomas Gleixner wrote:
>  
> +/**
> + *	disable_slowbus_irq - disable an slowbus irq and wait for completion
> + *	@irq: Interrupt to disable
> + *
> + *	Disable the selected interrupt line.  Enables and Disables are
> + *	nested.
> + *	This function waits for any pending IRQ handlers for this interrupt
> + *	to complete before returning. If you use this function while
> + *	holding a resource the IRQ handler may need you will deadlock.
> + *
> + *	This function must not be called from IRQ context.
> + */
> +void disable_slowbus_irq(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +
> +	if (!desc || !desc->chip || !desc->chip->bus_lock)
> +		return;
> +
> +	desc->chip->bus_lock(irq);
> +	disable_irq_nosync(irq);
> +	if (desc->action)
> +		synchronize_irq(irq);
> +	desc->chip->bus_sync_unlock(irq);
> +}
> +EXPORT_SYMBOL(disable_slowbus_irq);

Should we also not check that desc->chip->bus_lock is not set for the
regular function disable_irq()?

It seems to me mixing disable_irq() and disable_slowbus_irq() is a
recipe for disaster.

Same for the other slowbus functions of course.
