Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbXFVVLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbXFVVLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXFVVLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:11:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53214 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXFVVLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:11:44 -0400
Date: Fri, 22 Jun 2007 23:10:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622211032.GA17607@elte.hu>
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <20070622210013.GA1353@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622210013.GA1353@infradead.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> Note that we also have a lot of inefficiency in the way we do deferred 
> processing.  Think of a setup where you run a XFS filesystem runs over 
> a megaraid adapter.
> 
>  (1) we get a real hardirq, which just clears the interrupt and then
>      deferes to a tasklet
>  (2) tasklet walks the producer / consumer queue and then calls scsi_done
>      for each completeted scsi command which ends up doing
>      raise_softirq_irqoff(BLOCK_SOFTIRQ);
>  (3) block softirq does the heavy lifting for command completion and finally
>      calls back into the bio's completion routine
>  (4) xfs wants to avoid irq safe locking and thus deferes the command to a
>      kthread

i dont understand - why is a tasklet used at all? Why not do it straight 
in the BLOCK_SOFTIRQ? Using tasklets there is extra, unnecessary 
overhead already.

	Ingo
