Return-Path: <linux-kernel-owner+w=401wt.eu-S1751805AbZIQTwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbZIQTwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbZIQTwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:52:37 -0400
Received: from www.tglx.de ([62.245.132.106]:36269 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZIQTwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:52:36 -0400
Date: Thu, 17 Sep 2009 21:52:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: test for "spurious" IRQ ignores possible IRQ_WAKE_THREAD value
In-Reply-To: <20090917193416.GE8817@lenovo>
Message-ID: <alpine.LFD.2.00.0909172150590.2889@localhost.localdomain>
References: <alpine.LFD.2.00.0909141627500.4124@localhost> <alpine.LFD.2.00.0909141632390.4329@localhost> <20090917193416.GE8817@lenovo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009, Cyrill Gorcunov wrote:
> [Robert P. J. Day - Mon, Sep 14, 2009 at 04:34:48PM -0400]
> | On Mon, 14 Sep 2009, Robert P. J. Day wrote:
> | 
> | >   never ashamed to embarrass myself in public, i just noticed the
> | > following.  from kernel/irq/spurious.c:
> | >
> | > ...
> | > static void
> | > __report_bad_irq(unsigned int irq, struct irq_desc *desc,
> | >                  irqreturn_t action_ret)
> | > {
> | >         struct irqaction *action;
> | >
> | >         if (action_ret != IRQ_HANDLED && action_ret != IRQ_NONE) {
> | >                 printk(KERN_ERR "irq event %d: bogus return value %x\n",
> | >                                 irq, action_ret);
> | >
> | >   but from include/linux/irqreturn.h, we see *three* possible return
> | > values:
> | >
> | > enum irqreturn {
> | >         IRQ_NONE,
> | >         IRQ_HANDLED,
> | >         IRQ_WAKE_THREAD,
> | > };
> | >
> | > typedef enum irqreturn irqreturn_t;
> | > #define IRQ_RETVAL(x)   ((x) != IRQ_NONE)
> | >
> | >   is there an inconsistency here?
> | 
> ...
> 
> Hi Robert,
> 
> It could that IRQ_WAKE_THREAD is just missed here. I suppose it
> was brough there as thread irq merged. But I think only Thomas
> know for sure, I definitely miss something :) CC'ed

from kernel/irq/handle.c:

		trace_irq_handler_entry(irq, action);
		ret = action->handler(irq, action->dev_id);
		trace_irq_handler_exit(irq, action, ret);

		switch (ret) {
		case IRQ_WAKE_THREAD:
			/*
			 * Set result to handled so the spurious check
			 * does not trigger.
			 */
			ret = IRQ_HANDLED;

So nothing to worry about :)

Thanks,

	tglx
