Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbXFVVNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbXFVVNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbXFVVNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:13:42 -0400
Received: from www.osadl.org ([213.239.205.134]:37846 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751773AbXFVVNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:13:42 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
In-Reply-To: <20070622210013.GA1353@infradead.org>
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	 <20070622204058.GA11777@elte.hu>  <20070622210013.GA1353@infradead.org>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 23:13:30 +0200
Message-Id: <1182546810.20203.122.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 22:00 +0100, Christoph Hellwig wrote:
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
> 
> This is rather inefficient due to all the (semi-)context switches already
> and not by far the worst setup given that a lot of dm modules can involve
> another thread in the process.
> 
> Now if just plain convert tasklets to a thread based abstraction this
> existing code becomes really dumb because we go from hardirq to process
> context to go back to softirq context to go back to process context.
> 
> Ouch!
> 
> I think we need to put a little more though into how we can optimize our
> irq path for the full stack.  Using irqthreads in an intelligent way might
> be one option, but we'll need a lot of heavy benchmarking whatever way
> we go.

Your above scenario screams for a threaded interrupt handler, where you
actually can unify a lot of this into one single context.

	tglx


