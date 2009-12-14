Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbZLNJAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbZLNJAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZLNJAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:00:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:39462 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZLNJAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:00:43 -0500
Subject: Re: cpu_clock() in NMIs
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <20091213.182502.215092085.davem@davemloft.net>
References: <20091213.182502.215092085.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 14 Dec 2009 10:02:39 +0100
Message-ID: <1260781359.4165.42.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-13 at 18:25 -0800, David Miller wrote:
> The background is that I was trying to resolve a sparc64 perf
> issue when I discovered this problem.
> 
> On sparc64 I implement pseudo NMIs by simply running the kernel
> at IRQ level 14 when local_irq_disable() is called, this allows
> performance counter events to still come in at IRQ level 15.
> 
> This doesn't work if any code in an NMI handler does local_irq_save()
> or local_irq_disable() since the "disable" will kick us back to cpu
> IRQ level 14 thus letting NMIs back in and we recurse.
> 
> The only path which that does that in the perf event IRQ handling path
> is the code supporting frequency based events.  It uses cpu_clock().
> 
> cpu_clock() simply invokes sched_clock() with IRQs disabled.
> 
> And that's a fundamental bug all on it's own, particularly for the
> HAVE_UNSTABLE_SCHED_CLOCK case.  NMIs can thus get into the
> sched_clock() code interrupting the local IRQ disable code sections
> of it.
> 
> Furthermore, for the not-HAVE_UNSTABLE_SCHED_CLOCK case, the IRQ
> disabling done by cpu_clock() is just pure overhead and completely
> unnecessary.
> 
> So the core problem is that sched_clock() is not NMI safe, but we
> are invoking it from NMI contexts in the perf events code (via
> cpu_clock()).
> 
> A less important issue is the overhead of IRQ disabling when it isn't
> necessary in cpu_clock().  Maybe something simple like the patch below
> to handle that.

I'm not sure, traditionally sched_clock() was always called with IRQs
disabled, and on eg. x86 that is needed because we read the TSC and then
scale that value depending on CPUfreq state, which can be changed by a
CPUfreq interrupt. Allowing NMIs in between isn't really a problem,
allowing IRQs in is.

Now, the SPARC implementation might be good without IRQs disabled, but
we should at least look at all other arches before we do what you
propose below. As it removes the IRQ disable from the callsites whereas
it previously always had that.



