Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbXFYUeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbXFYUeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbXFYUeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:34:09 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:51852 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbXFYUeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:34:07 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Steven Rostedt <rostedt@goodmis.org>
To: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
In-Reply-To: <1182802021.1689.50.camel@hinata.boston.redhat.com>
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	 <20070622204058.GA11777@elte.hu>
	 <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	 <20070622215953.GA22917@elte.hu>
	 <1182797325.1689.14.camel@hinata.boston.redhat.com>
	 <1182798678.5493.179.camel@localhost.localdomain>
	 <1182802021.1689.50.camel@hinata.boston.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 25 Jun 2007 16:31:04 -0400
Message-Id: <1182803464.5493.213.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 16:07 -0400, Kristian Høgsberg wrote:

> > Maybe we should be looking at something like GENERIC_SOFTIRQ to run
> > functions that a driver could add. But they would run only on the CPU
> > that scheduled them, and do not guarantee non-reentrant as tasklets do
> > today.
> 
> Sounds like this will fill the gap.  Of course, this won't reduce the
> number of delayed-execution mechanisms available...

I disagree. Adding a generic softirq is not really adding another
delayed-execution, it's just extending the sofitrq.  It would not have
any different semantics as a normal softirq, except that it would be
dynamic for modules to use.  A tasklet has different concepts than
softirq. It adds non-reentrancy and that the tasklet function can run
where it wasn't scheduled.

Adding a generic softirq would keep the same concepts as a softirq but
just extend the users for it. Tasklets are probably not the best for
critical sections since it can be postponed longer if it was scheduled
on another CPU that is handling a bunch of other tasklets. So the
latency of running the tasklet is higher and you lose a cache advantage
by jumping to another CPU to execute.

Work queues already exist, so all we need to do to replace tasklets is
to extend softirqs for those critical cases that tasklets are used, and
replace the rest with work queues. By removing the non critical tasklets
to work queues will even lower the latency to execution of the more
critical tasklets.

-- Steve


