Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbYCUBcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbYCUBcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 21:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYCUBbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 21:31:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4725 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752602AbYCUBbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 21:31:45 -0400
Date: Thu, 20 Mar 2008 21:31:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       David Brownell <david-b@pacbell.net>,
       Richard Purdie <rpurdie@rpsys.net>, <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       <netdev@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, <linux-usb@vger.kernel.org>,
       <linux-wireless@vger.kernel.org>, <video4linux-list@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, <lm-sensors@lm-sensors.org>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
In-Reply-To: <20080320180802.426ad2d1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0803202126240.11234-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008, Andrew Morton wrote:

> On Thu, 20 Mar 2008 21:36:04 -0300 Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> 
> > Well, so far so good for LEDs, but what about the other users of in_atomic
> > that apparently should not be doing it either?
> 
> Ho hum.  Lots of cc's added.

...

> The usual pattern for most of the above is
> 
> 	if (!in_atomic())
> 		do_something_which_might_sleep();
> 
> problem is, in_atomic() returns false inside spinlock on non-preptible
> kernels.  So if anyone calls those functions inside spinlock they will
> incorrectly schedule and another task can then come in and try take the
> already-held lock.
> 
> Now, it happens that in_atomic() returns true on non-preemtible kernels
> when running in interrupt or softirq context.  But if the above code really
> is using in_atomic() to detect am-i-called-from-interrupt and NOT
> am-i-called-from-inside-spinlock, they should be using in_irq(),
> in_softirq() or in_interrupt().

Presumably most of these places are actually trying to detect 
am-i-allowed-to-sleep.  Isn't that what in_atomic() is supposed to do?  
Why doesn't it do that in non-preemptible kernels?

For that matter, isn't it also the sort of thing that might_sleep() is 
supposed to check?  But looking at the definitions in 
include/linux/kernel.h, it appears that might_sleep() does nothing at 
all when neither CONFIG_PREEMPT_VOLUNTARY nor 
CONFIG_DEBUG_SPINLOCK_SLEEP is set.

Alan Stern

