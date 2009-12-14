Return-Path: <linux-kernel-owner+w=401wt.eu-S932448AbZLNTJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbZLNTJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932401AbZLNTJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:09:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44983
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932400AbZLNTJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:09:04 -0500
Date: Mon, 14 Dec 2009 11:09:05 -0800 (PST)
Message-Id: <20091214.110905.207084342.davem@davemloft.net>
To: peterz@infradead.org
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: cpu_clock() in NMIs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1260781359.4165.42.camel@twins>
References: <20091213.182502.215092085.davem@davemloft.net>
	<1260781359.4165.42.camel@twins>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Mon, 14 Dec 2009 10:02:39 +0100

> I'm not sure, traditionally sched_clock() was always called with IRQs
> disabled, and on eg. x86 that is needed because we read the TSC and then
> scale that value depending on CPUfreq state, which can be changed by a
> CPUfreq interrupt. Allowing NMIs in between isn't really a problem,
> allowing IRQs in is.

Ok, that looks fine then.

But, speaking more generally, any local_irq_{disable,save}() done in
an NMI handler has a high probability of being a bug.  And it is a
bug if the IRQ disabling is there to prevent re-entry of the code
on the local cpu.

> Now, the SPARC implementation might be good without IRQs disabled, but
> we should at least look at all other arches before we do what you
> propose below. As it removes the IRQ disable from the callsites whereas
> it previously always had that.

Here's a quick audit:

1) Generic kernel/sched_clock.c implementation does a subtraction
   of jiffies with a constant, then does some constant math on it.
   Should be OK.

2) sparc64 is fine, just reads a register and multiplies with a
   boot time calculated value, then shifts down by a constant.
   Should be OK.

3) ARM mach-map, same situation as sparc64

4) ARM mach-pxa, same situation as sparc64

5) ARM mach-realview, multiplies counter a constant then divides by
   one, should be OK.

6) ARM mach-sa1100, same as mach-realview

7) ARM mach-u300, uses boot time computed multiplier and shift,
   should be OK.

8) ARM mach-versatile, same as mach-realview

9) ARM plat-IOP, same as mach-u300

10) ARM plat-omap, same as mach-u300

11) ARM plat-orion, same as sparc64

12) Blackfin, TS version is same as sparc64

    non-TS version is unnecessary duplication of generic weak
    function version in kernel/sched_clock.c and could be deleted

13) CRIS, another dup of kernel/sched_clock.c weak function

14) FRV, another dup of kernel/sched_clock.c weak function

15) IA64, same as sparc64 for native version.
    Paravirt version uses preemption disable, but also relies on
    IA64 always setting HAVE_UNSTABLE_SCHED_CLOCK which it does,
    and therefore IA64 would still disable interrupts with my change

16) m68knommu coldfire, multiplies by a constant then shifts down by
    one, should be OK

17) mn10300, same as sparc64

18) powerpc,  non-__USE_RTC() case is same as sparc64

    __USE_RTC() case also looks fine

19) s390, depends upon preemption being disabled so that
    stop_machine does not interrupt the sched_clock() call

    should be OK

20) x86 sets HAVE_UNSTABLE_SCHED_CLOCK

It should be safe.
