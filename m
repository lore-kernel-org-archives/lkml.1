Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbXFVVAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbXFVVAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbXFVVAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:00:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60625 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbXFVVAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:00:22 -0400
Date: Fri, 22 Jun 2007 22:00:13 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622210013.GA1353@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Dipankar Sarma <dipankar@in.ibm.com>,
	"David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
	kuznet@ms2.inr.ac.ru
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622204058.GA11777@elte.hu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 10:40:58PM +0200, Ingo Molnar wrote:
> when it comes to 'deferred processing', we've basically got two 'prime' 
> choices for deferred processing:
> 
>  - if it's high-performance then it goes into a softirq.
> 
>  - if performance is not important, or robustness and flexibility is 
>    more important than performance, then workqueues are used.
> 
> basically tasklets do _neither_ really well. They are too 'global' to 
> scale really well on SMP (even the RCU tasklet wasnt a real tasklet: it 
> was a _per CPU tasklet_, which almost by definition is equivalent to a 
> softirq, some some extra glue overhead ...), and tasklets are also too 
> much tied to softirqs to be used as a generic processing context.
> 
> that's why i'd like them to be gently but firmly phased out =B-)

Note that we also have a lot of inefficiency in the way we do deferred
processing.  Think of a setup where you run a XFS filesystem runs over
a megaraid adapter.

 (1) we get a real hardirq, which just clears the interrupt and then
     deferes to a tasklet
 (2) tasklet walks the producer / consumer queue and then calls scsi_done
     for each completeted scsi command which ends up doing
     raise_softirq_irqoff(BLOCK_SOFTIRQ);
 (3) block softirq does the heavy lifting for command completion and finally
     calls back into the bio's completion routine
 (4) xfs wants to avoid irq safe locking and thus deferes the command to a
     kthread

This is rather inefficient due to all the (semi-)context switches already
and not by far the worst setup given that a lot of dm modules can involve
another thread in the process.

Now if just plain convert tasklets to a thread based abstraction this
existing code becomes really dumb because we go from hardirq to process
context to go back to softirq context to go back to process context.

Ouch!

I think we need to put a little more though into how we can optimize our
irq path for the full stack.  Using irqthreads in an intelligent way might
be one option, but we'll need a lot of heavy benchmarking whatever way
we go.
