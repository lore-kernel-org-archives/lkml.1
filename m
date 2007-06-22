Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbXFVUnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbXFVUnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXFVUn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:43:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45090 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbXFVUn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:43:26 -0400
Date: Fri, 22 Jun 2007 22:40:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622204058.GA11777@elte.hu>
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Whether we actually then want to do 6 is another matter. I think we'd 
> need some measuring and discussion about that.

basically tasklets have a number of limitations:

 - tasklets have certain latency limitations over real tasks. (for
   example they are not guaranteed to be re-executed when they are
   triggered while they are running, so artificial latencies can be
   introduced into the kernel workflow)

 - tasklets have certain execution limitations. (only atomic functions
   can be executed in them)

 - tasklets have certain fairness limitations. (they are executed in
   softirq context and thus preempt everything, even if there is some
   potentially more important, high-priority task waiting to be
   executed.)

 - the 'priority levels' approach of softirqs is not really 
   self-documenting - unlike real locks. As a result we've got some 
   vague coupling between network softirq processing and timer softirq 
   processing, which spilled over into tasklets as well. The 'hi' and
   'low' concept of tasklets isnt really used either. We should reduce 
   the amount of such opaque 'coupling' between workflows - it should be 
   spelled out explicitly via some synchronization construct.

 - tasklets are duplicated infrastructure (over existing workqueues) 
   that, if it's possible to do it compatibly, would be a good idea to 
   eliminate.

when it comes to 'deferred processing', we've basically got two 'prime' 
choices for deferred processing:

 - if it's high-performance then it goes into a softirq.

 - if performance is not important, or robustness and flexibility is 
   more important than performance, then workqueues are used.

basically tasklets do _neither_ really well. They are too 'global' to 
scale really well on SMP (even the RCU tasklet wasnt a real tasklet: it 
was a _per CPU tasklet_, which almost by definition is equivalent to a 
softirq, some some extra glue overhead ...), and tasklets are also too 
much tied to softirqs to be used as a generic processing context.

that's why i'd like them to be gently but firmly phased out =B-)

	Ingo
