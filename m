Return-Path: <linux-kernel-owner+w=401wt.eu-S932737AbXF2N0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbXF2N0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 09:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762546AbXF2N01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 09:26:27 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:40175 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1763452AbXF2N01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 09:26:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=Fe1Tr17s9pH4OQCFDbndauA9hcaSwrLU5Co2uDTo6KQHc1oLJKuLFu8E6z4WGrvGc3v/sKUOuN/CuooqD0Q/Pjj5djRXM+zR9TGHgGA9QjbTCpmFHkUfHolt+uYqXZ7VbqHv+iuqhir9Wm6Gval8usnUXqqIJuxWztH2/dTEJxU=;
Date: Fri, 29 Jun 2007 17:25:14 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20070629132514.GA19021@ms2.inr.ac.ru>
References: <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru> <20070628160001.GA15495@elte.hu> <20070629113423.GA9042@ms2.inr.ac.ru> <20070629122906.GA13035@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629122906.GA13035@elte.hu>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> > The difference between softirqs and hardirqs lays not in their 
> > "heavyness". It is in reentrancy protection, which has to be done with 
> > local_irq_disable(), unless networking is not isolated from hardirqs. 
> 
> i know that pretty well ;)

You forgot about this again in the next sentence. :-)


> as i said above (see the underlined sentence), hardirq contexts already 
> run just fine with hardirqs enabled.

RENTRANCY PROTECTION! If does not matter _how_ they run, it matters what
context they preempt and what that context has to make to prevent that
preemption. If you still do not get the point, make
	sed -e 's/local_bh_/local_irq_/'
over net/* and kill softirqs. Everything will work just fine.
Moreover, if you deal only with a single TCP connection
(and sysctl tcp_low_latency is not set), even hardirq latency will not suck,
all real work is done at process context.


> also, network softirq locking dependencies arent all that magic or 
> complex either: they do not operate on sockets that are already locked 
> by a user context, they are per CPU and they are not preempted by 
> 'themselves', nor are they preempted by certain other softirqs (such as 
> they are not preempted by the timer softirq). Am i missing some point of 
> yours?

I would not say I understood what you wanted to say. :-)

Does my statement about sed match your view? :-)


What I know is that there is no hairy locking dependencies at all
and there is no magic there. Especially, on level of sockets.
The things, which are troublesome are various shared trees/hash tables
(e.g. socket hash tables), which are modified both by incoming network
packets and process contexts.

I have some obscure suspicion that naive dream of "realtime" folks is
to move all those "bad" things to some kernel threads and to talk
to those threads passing some messages. I hope this suspicion is wrong,
otherwise I would say: go to Mach, pals. :-(

Alexey
