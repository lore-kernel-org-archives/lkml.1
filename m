Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbXFVHKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbXFVHKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbXFVHKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:10:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40305 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbXFVHKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:10:09 -0400
Date: Fri, 22 Jun 2007 08:09:48 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622070948.GA21291@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Dipankar Sarma <dipankar@in.ibm.com>,
	"David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
	kuznet@ms2.inr.ac.ru
References: <20070622040014.234651401@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622040014.234651401@goodmis.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 12:00:14AM -0400, Steven Rostedt wrote:
> The most part, tasklets today are not used for time critical functions.
> Running tasklets in thread context is not harmful to performance of
> the overall system. But running them in interrupt context is, since
> they increase the overall latency for high priority tasks.

I think we probably want some numbers, at least for tasklets used in
potentially performance critical code.

> Even in Matthew's paper, he says that work queues have replaced tasklets.
> But this is not truly the case.  Tasklets are common and plentiful.
> But to go and replace each driver that uses a tasklet with a work queue
> would be very painful.
> 
> I've developed this way to replace all tasklets with work queues without
> having to change all the drivers that use them.  I created an API that
> uses the tasklet API as a wrapper to a work queue.  This API doesn't need
> to be permanent. It shows 1) that work queues can replace tasklets, and
> 2) we can remove a duplicate functionality from the kernel.  This API
> only needs to be around until we removed all uses of tasklets from
> all drivers.

I don't like this wrapping at all.  What you're doing is a tradeoff to
do less work today in exchange for more maintaince overhead and more crufty
code in the future.  So while I sympathize a lot with trying to get rid
of tasklets I'd rather prefer to convert individual drivers over until
all users are gone.  It's not exactly a very complicated conversion either.

> 6) This is the magic to make tasklets into work queues. It allows for
> the kernel to be configured either with the normal tasklets, as it is
> today, or with the tasklets-as-work-queues.

And this is something that might be fine for benchmarking, but not something
we should put in.  Keeping two wildly different implementation of core
functionality with very different behaviour around is quite bad.  Better
kill tasklets once for all.

