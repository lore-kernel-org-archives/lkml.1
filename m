Return-Path: <linux-kernel-owner+w=401wt.eu-S933228AbXF2Noy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228AbXF2Noy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 09:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763499AbXF2Noq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 09:44:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40579 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763438AbXF2Nop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 09:44:45 -0400
Date: Fri, 29 Jun 2007 15:43:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070629134303.GA30257@elte.hu>
References: <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru> <20070628160001.GA15495@elte.hu> <20070629113423.GA9042@ms2.inr.ac.ru> <20070629122906.GA13035@elte.hu> <20070629132514.GA19021@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629132514.GA19021@ms2.inr.ac.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Kuznetsov <kuznet@ms2.inr.ac.ru> wrote:

> > as i said above (see the underlined sentence), hardirq contexts 
> > already run just fine with hardirqs enabled.
> 
> RENTRANCY PROTECTION! If does not matter _how_ they run, it matters 
> what context they preempt and what that context has to make to prevent 
> that preemption. [...]

again, there is no reason why this couldnt be done in a hardirq context. 
If a hardirq preempts another hardirq and the first hardirq already 
processes the 'softnet work', you dont do it from the second one but 
queue it with the first one. (into the already existing 
sd->completion_queue for tx work or queue->poll_list for rx work) It 
would be a simple additional flag in softnet_data.

once we forget about 'hardirq contexts run with irqs disabled', _there 
is just no technological point for softirqs_. They are an unnecessary 
abstraction!

once we concede that point, reentrancy protection does not have to be 
done via local_bh_disable(). For example we run just fine without it in 
-rt, local_bh_disable() is a NOP there. How is it done? By controlling 
execution of the _workflow_ that a softirq does. By implementing 
non-reentrancy via another, more flexible mechanism. (and by carefully 
fixing a few _other_, non-workflow assumptions that softnet does/did, 
such as the per-cpu-ness of softnet_data.)

Are we talking about the very same thing perhaps, just from a different 
angle? ;-)

	Ingo
