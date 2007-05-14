Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbXENPWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbXENPWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 11:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbXENPWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 11:22:22 -0400
Received: from science.horizon.com ([192.35.100.1]:16317 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755412AbXENPWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 11:22:21 -0400
Date: 14 May 2007 11:22:18 -0400
Message-ID: <20070514152218.19773.qmail@science.horizon.com>
From: linux@horizon.com
To: learninglinux4@gmail.com
Subject: Re: Why can't we sleep in an ISR?
Cc: linux-kernel@vger.kernel.org, linux-newbie@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sleeping in an ISR is not fundamentally impossible - I could design
a multitasker that permitted it - but has significant problems, and
most multitaskers, including Linux, forbid it.

The first problem is the scheduler.  "Sleeping" is actually a call
into the scheduler to choose another process to run.  There are times -
so-called critical sections - when the scheduler can't be called.

If an interrupt can call the scheduler, then every criticial section
has to disable interrupts.  Otherwise, an interrupt might arrive and
end up calling the scheduler.  This increases interrupt latency.

If interrupts are forbidden to sleep, then there's no need to
disable interrupts in critical sections, so interrupts can be responded
to faster.  Most multitaskers find this worth the price.

The second problem is shared interrupts.  You want to sleep until something
happens.  The processor hears about that event via an interrupt.  Inside
an ISR, interrupts are disabled.

You have to somehow enable the interrupt that will wake up the sleeping
ISR without enabling the interrupt that the ISR is in the middle of handling
(or the handler will start a second time and make a mess).

This is complicated and prone to error.  And, in the case of shared interrupts
(as allowed by PCI), it's possible that the the interrupt you need
to wait for is exactly the same interrupt as what you're in the middle
of handling.  So it might be impossible!

The third problem is that you're obviously increasing the latency of the
interrupt whose handler you're sleeping in.

Finally, if you're even *thinking* of wanting to sleep in an ISR,
you probably have a deadlock waiting to happen.
