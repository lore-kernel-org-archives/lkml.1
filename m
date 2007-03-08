Return-Path: <linux-kernel-owner+w=401wt.eu-S1751850AbXCHNrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbXCHNrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 08:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbXCHNrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 08:47:40 -0500
Received: from www.osadl.org ([213.239.205.134]:44643 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751850AbXCHNrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 08:47:40 -0500
Subject: Re: Sleeping thread not receive signal until it wakes up
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Luong Ngo <luong.ngo@gmail.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0703080752570.17167@chaos.analogic.com>
References: <1b2aacd80703062131g6c8578fgf200dd05a502c49f@mail.gmail.com>
	 <Pine.LNX.4.61.0703070813070.12338@chaos.analogic.com>
	 <1b2aacd80703071128v5227382do2277d0b85ca3b20c@mail.gmail.com>
	 <Pine.LNX.4.61.0703071457060.13923@chaos.analogic.com>
	 <1b2aacd80703071628y29b7d862h84eb5e853dd6f4d7@mail.gmail.com>
	 <Pine.LNX.4.61.0703080752570.17167@chaos.analogic.com>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 14:53:51 +0100
Message-Id: <1173362032.24738.1058.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 08:01 -0500, linux-os (Dick Johnson) wrote:
> > Anything kernel configuration I need to be aware of to enable
> > preemption in kernel?
> >
> >
> > Thank you,
> > LNgo
> >
> 
> First, in the ioctl, if you need spin-locks, you need to use
> spin_lock_irqsave/spin_unlock/irqrestore. The ones that don't
> save and restore are for the ISR where we know that the interrupts
> are already off and don't intend to turn them on. Further, make

As usual completely wrong:

ioctl code is called with interrupts enabled. So if you need to protect
against interrupts it is completely correct to use spin_lock_irq /
spin_unlock_irq. There is nothing to save and nothing to restore.

> sure that you don't try to schedule() with the interrupts off.
> 
> interruptible_sleep_on(&qu);
>                          ^______ Where is this?

Not included in the pseudo code.

> This must be accessible both in the ISR and in the ioctl(). It
> also needs to have been properly initialized when your module
> was installed (see numerious code samples in the kernel).

Instead of blurbing about obvious things you should point Luong to the
real problems:

include/linux/wait.h:
/*
 * These are the old interfaces to sleep waiting for an event.
 * They are racy.  DO NOT use them, use the wait_event* interfaces above.
 * We plan to remove these interfaces during 2.7.
 */
extern void FASTCALL(sleep_on(wait_queue_head_t *q));
extern long FASTCALL(sleep_on_timeout(wait_queue_head_t *q,
                                      signed long timeout));
extern void FASTCALL(interruptible_sleep_on(wait_queue_head_t *q));
extern long FASTCALL(interruptible_sleep_on_timeout(wait_queue_head_t *q,
                                                    signed long timeout));

Luong, please use wait_event_interruptible() instead.

	spin_lock_irq(dev->lock);
	do_whatever_you_need_to_initialize(dev);
	dev->event_happened = 0;
	spin_unlock_irq(dev->lock);
	
	res = wait_event_interruptible(&dev->queue, dev->event_happened != 0);

Thanks,

	tglx


