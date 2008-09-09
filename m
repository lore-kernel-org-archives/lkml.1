Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbYIIARY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbYIIARY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 20:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbYIIARP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 20:17:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46808
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753864AbYIIARP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 20:17:15 -0400
Date: Mon, 08 Sep 2008 17:17:08 -0700 (PDT)
Message-Id: <20080908.171708.43575256.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, wli@holomorphy.com,
       sparclinux@vger.kernel.org, manfred@colorfullife.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] prevent sparc64 from invoking irq handlers on offline
 CPUs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080903154217.GA6807@linux.vnet.ibm.com>
References: <20080903004211.GD6748@linux.vnet.ibm.com>
	<20080903.022138.31681256.davem@davemloft.net>
	<20080903154217.GA6807@linux.vnet.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 3 Sep 2008 08:42:17 -0700

> Here are the situations I can think of (no doubt betraying my ignorance
> of modern processor irq hardware in general and of sparc64 in particular):
> 
> o	Pending device irq.  There should be a limited number of these,
> 	and the fixup_irqs() call prevents any more from appearing.

Correct.

> o	Pending scheduling-clock interrupts.  Does fixup_irqs() turn
> 	these off as well?  (It does if the scheduling-clock interrupt
> 	is one of the 0..NR_IRQS irqs.)  On the other hand, leaving
> 	one of these pending should not be a problem (famous last
> 	words).

No, the timer interrupts are controlled differently, as the IRQ source
lives inside of the CPU rather in some external entity.

I need to fix that by invoking tick_ops->disable_irq() here.  I'll take
care of this.

> o	Pending IPIs.  There should again be a limited number of these.
> 	Except that an IPI handler could possibly IPI this CPU, as could
> 	a device irq handler, I suppose.  (We cannot receive additional
> 	IPIs from other CPUs, as they are spinning with irqs disabled.)

And IPI handler runs in HW irq context, therefore such an IPI-creates-an-IPI
should not be allowed, at least not directly.

Actually the restriction seems to be that an IPI cannot be sent when
"irqs_disabled()", hmmm...

> o	Timer irqs.  Not sure what happens to add_timer() calls from
> 	a CPU that is going offline.  The hope would be that they get
> 	queued to some other CPU?

This case is interesting, and I'm no sure what happens here.

> Now, an IPI handler cannot be allowed to send a synchronous IPI to
> anyone, because the other CPUs are spinning with irqs disabled until
> __cpu_disable() returns.  And in any context, a handler for a synchronous
> IPI cannot be allowed to send a synchronous IPI to any set of CPUs that
> might include the sender of the currently running handler, as doing so
> would result in deadlock.

Exactly.
