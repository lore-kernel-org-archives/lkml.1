Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbXD1Nro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbXD1Nro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbXD1Nrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:47:37 -0400
Received: from www.osadl.org ([213.239.205.134]:49398 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756236AbXD1NrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:47:19 -0400
From: =?utf-8?q?Hans-J=C3=BCrgen_Koch?= <hjk@linutronix.de>
To: Matthieu CASTET <castet.matthieu@free.fr>
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
Date: Sat, 28 Apr 2007 15:49:28 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070427224957.GA17967@kroah.com> <pan.2007.04.28.13.00.14@free.fr>
In-Reply-To: <pan.2007.04.28.13.00.14@free.fr>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704281549.29572.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 28 April 2007 15:00 schrieb Matthieu CASTET:
>
> uio_dummy.c (that should be present according documentation) seems
> missing.

Well, uio_dummy was created during development to have something to
test with. It calls uio_event_notify() from a timer routine to 
simulate interrupts without having a real hardware device.

Besides that, uio_dummy has no real use. It might or might not be
useful to put it in mainline. IMHO, we should include it because
it shows ow UIO works and gives developers the possibility to test
at least parts of their userspace code without having the real hardware
(e.g. on their laptop).

>
> I find the doc not very clear for the devices where there is no
> interrupt : they speak of some kernel timer, but a userspace timer could
> be used (and even the userspace driver could be written without kernel
> support at all).

I'm afraid the doc too much emphasizes that timer. The reason was probably
that I worked with uio_dummy at the time I wrote the doc. Fact is that you
will rarely use a timer to generate interrupts. The only application I can
think of is something where you want to poll a device, say, every 10msec.
Then it might sometimes be the simplest solution to do it that way. But even
then there are probably userspace-only solutions most of the time.

But in general you're right, if a device doesn't generate hardware 
interrupts, you don't need UIO.

>
> At the end of the doc there is something about IRQ_HANDLED vs IRQ_NONE.
> Last time I check kernel irq code, in both case next irq handler are
> called. The only difference was that if all handler reply IRQ_NONE, the
> kernel gave an error about an unexpected interrupt.

It works like any other driver that handles interrupts. If you want to
support shared interrupts, your handler needs to be able to find out 
whether its device caused the interrupt or something else. You return
IRQ_HANDLED in the first case and IRQ_NONE in the second. If an interrupt
occurs and there's no driver that handles it, then the kernel has every
right to complain. Whoever enabled the interrupt must also be able to
handle it. That's one of the reasons why we need a kernel module to
handle interrupts, you can't do that from userspace.

>
> Also why sysfs is used for describing the mapping instead of something
> like an ioctl ?

Introducing new ioctls is ugly.

> UIO could be useful in embedded system where sysfs is not always
> desirable.

I see your point. But we need to make some information available for
userspace, in a standardized way. It was a design decision, and I still
find it quite good.

Thanks,
Hans
 
