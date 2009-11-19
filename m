Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbZKSOQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbZKSOQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZKSOQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:16:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:34658 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbZKSOQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:16:08 -0500
Subject: Re: yield() in i2c non-happy paths hits BUG under -rt patch
From: Peter Zijlstra <peterz@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       linux-i2c@vger.kernel.org, rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091119150008.6e757c26@hyperion.delvare>
References: <c384c5ea0911071101u7415d37o2611c542e5fae309@mail.gmail.com>
	 <20091107210147.3e754278@hyperion.delvare>
	 <4AF7148C.9090706@thebigcorporation.com>
	 <20091112211255.09cd884a@hyperion.delvare>
	 <alpine.LFD.2.00.0911132139560.24119@localhost.localdomain>
	 <20091116155606.GC29479@sirena.org.uk>
	 <c384c5ea0911171650t1c441dc4v746d31e4154fcb30@mail.gmail.com>
	 <20091118010520.4cd397d4@lxorguk.ukuu.org.uk>
	 <c384c5ea0911180828x7c857189w3316c93bb78100ab@mail.gmail.com>
	 <20091118175202.490989d8@hyperion.delvare>
	 <alpine.LFD.2.00.0911182127040.24119@localhost.localdomain>
	 <20091119130526.23a69b85@hyperion.delvare>
	 <20091119125906.6ad00edd@lxorguk.ukuu.org.uk>
	 <1258636014.4372.328.camel@twins>
	 <20091119150008.6e757c26@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Nov 2009 15:15:54 +0100
Message-ID: <1258640154.3931.407.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 15:00 +0100, Jean Delvare wrote:

> > 	cond_resched();
> 
> Are you saying that most calls to yield() should be replaced with calls
> to cond_resched()?

No, depends on the reason yield() is used. Some cases can be replaced by
locking constructs, such as a condition variable.

> I admit I a little skeptical. While the description of cond_resched()
> ("latency reduction via explicit rescheduling in places that are safe")
> sounds promising, following the calls leads me to:
> 
> static inline int need_resched(void)
> {
> 	return unlikely(test_thread_flag(TIF_NEED_RESCHED));
> }
> 
> So apparently the condition for need_resched() to do anything is
> considered unlikely... suggesting that cond_resched() is a no-op in
> most cases? I don't quite get the point of moving away from sched()
> because it is a no-op, if we end up with a no-op under a different name.

TIF_NEED_RESCHED gets set by the scheduler whenever it decides current
needs to get preempted, its unlikely() because that reduces the code
impact of cond_resched() and similar in the case we don't schedule, if
we do schedule() a mis-predicted branch isn't going to be noticed on the
overhead of scheduling.

So there's a few cases,

1) PREEMPT=n
2) Voluntary preempt
3) PREEMPT=y


1) non of this has any effect, if the scheduler wants to reschedule a
task that's in the kernel, it'll have to wait until it gets back to
user-space.

2) uses cond_resched() and similar to have explicit preemption points,
so we don't need to wait as long as 1).

3) preempts directly when !preempt_count(), when IRQs are disabled, the
IPI that will accompany TIF_NEED_RESCHED will be delayed and
local_irq_enable()/restore() will effect a reschedule due to the pending
IPI. If preemption was disabled while the IPI hit nothing will happen,
but preempt_enable() will do the reschedule once preempt_count reaches
0.



