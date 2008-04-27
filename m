Return-Path: <linux-kernel-owner+w=401wt.eu-S1762680AbYD0SHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762680AbYD0SHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 14:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756585AbYD0SG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 14:06:58 -0400
Received: from www.tglx.de ([62.245.132.106]:47078 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799AbYD0SG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 14:06:58 -0400
Date: Sun, 27 Apr 2008 20:05:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: David Miller <davem@davemloft.net>, mingo@elte.hu,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [git pull] scheduler/misc fixes
In-Reply-To: <1209118778.7115.417.camel@twins>
Message-ID: <alpine.LFD.1.10.0804271957020.3261@apollo.tec.linutronix.de>
References: <20080424225530.GA8717@elte.hu>  <20080424.204620.88617191.davem@davemloft.net>  <1209109710.7115.400.camel@twins> <1209118778.7115.417.camel@twins>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2008, Peter Zijlstra wrote:
> So per b) any nohz wake needs to be done with an interrupt _and_ all
> such interrupts must pass through irq_enter().
> 
> As far as I can tell this is not nessecarily true (or desired from a
> performance POV) for all platforms, imagine the core2 monitor/mwait idle
> that wakes up because of a memory write. This doesn't require an
> interrupt at all to wake up.
> 
> So, are we going to require all waking interrupts (IPIs and regular) to
> do the irq_enter/exit() dance and add the perhaps unneeded overhead to
> these paths and require the non-interrupt driven wake-ups like
> monitor/mwait to do the touch_softlockup_watchdog() themselves?

regular irqs need to go through irq_enter()/exit() in any case.

IPIs are border line. As long as none of the IPI code relies on
jiffies, touches timers ... we don't. But we are on the safe side if
we do.

> Or,
> 
> Is Ingo's initial patch to make nohz_restart() also touch the softlockup
> watchdog the best fix (now that we understand what happens)?

Yes, we need it for mwait based wakeups which don't go through
interrupts at all.

Thanks,
	tglx
