Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbZIQUIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbZIQUIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZIQUIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:08:35 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:51172 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbZIQUIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:08:35 -0400
Date: Thu, 17 Sep 2009 16:08:32 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: test for "spurious" IRQ ignores possible IRQ_WAKE_THREAD value
In-Reply-To: <20090917193416.GE8817@lenovo>
Message-ID: <alpine.LFD.2.00.0909171605320.5014@localhost>
References: <alpine.LFD.2.00.0909141627500.4124@localhost> <alpine.LFD.2.00.0909141632390.4329@localhost> <20090917193416.GE8817@lenovo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
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
> It could that IRQ_WAKE_THREAD is just missed here. I suppose it was
> brough there as thread irq merged. But I think only Thomas know for
> sure, I definitely miss something :) CC'ed

  actually, after a bit more reading, i found this in
kernel/irq/handle.c:
                ...
                switch (ret) {
                case IRQ_WAKE_THREAD:
                        /*
                         * Set result to handled so the spurious check
                         * does not trigger.
                         */
                        ret = IRQ_HANDLED;
                        ...

so it looks like that value of IRQ_WAKE_THREAD is simply "mapped" to
IRQ_HANDLED, and perhaps that's done before __report_bad_irq is ever
called so that that latter routine never sees a value of
IRQ_WAKE_THREAD.  but that's just a guess.

rday
--


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
