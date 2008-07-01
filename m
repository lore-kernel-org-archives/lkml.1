Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbYGAOI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbYGAOI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758767AbYGAOHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:07:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37913 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758744AbYGAOHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:07:42 -0400
Date: Tue, 1 Jul 2008 14:43:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: avorontsov@ru.mvista.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] serial: 8250: fix shared interrupts issues with SMP and
 RT kernels
Message-ID: <20080701144353.7285805d@lxorguk.ukuu.org.uk>
In-Reply-To: <20080701134343.GA1865@polina.dev.rtsoft.ru>
References: <20080623232957.GA5111@polina.dev.rtsoft.ru>
	<20080624001221.GA20685@elte.hu>
	<20080701134343.GA1865@polina.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > again, please let the -rt maintainers sort out which patches need to be 
> > propagated to upstream maintainers.
> 
> This appears to be not only RT issue though. In theory, this can be

Agreed - RT is showing up a real bug here.

> triggered on SMP also. Thanks to Daniel Walker for pointing this out.

It looks correct to me except that you cannot use spin_lock/disable_irq
in that way safely. You must always disable_irq before taking the lock,
or prove it is safe and use disable_irq_nosync

The reason:
		CPU#0 spin_lock_... [taken]
		CPU#1 IRQ
		CPU#1 spin_lock [waits]
		CPU#0 disable_irq (deadlock)

Note that is also not generally safe to do

		disable IRQ on device
		spin_lock
		disable_irq

because IRQ propogation occurs asynchronously to PCI bus traffic even on
PC class systems (especially Pentium-PII era boxes with SMP). You can
disable the device IRQ and still have an IRQ 'in flight' that arrives
afterwards.

So the fix needs some reworking in its ordering I think

Alan
