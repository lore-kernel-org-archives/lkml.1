Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbXFYVRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbXFYVRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbXFYVRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:17:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50578 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbXFYVRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:17:34 -0400
Date: Mon, 25 Jun 2007 23:15:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kristian H?gsberg <krh@redhat.com>
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
Message-ID: <20070625211551.GA29390@elte.hu>
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <1182797325.1689.14.camel@hinata.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182797325.1689.14.camel@hinata.boston.redhat.com>
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


* Kristian H?gsberg <krh@redhat.com> wrote:

> OK, here's a yell.  I'm using tasklets in the new firewire stack for 
> all interrupt handling.  All my interrupt handler does is read out the 
> event mask and schedule the appropriate tasklets.  Most of these 
> tasklets typically just end up scheduling work or completing a 
> completion, so moving it to a workqueue is pretty pointless.  In 
> particular, the isochronous DMA events must be handled with as little 
> latency as possible, so a workqueue in that code path would be pretty 
> bad.

regarding workqueues - would it be possible for you to test Steve's 
patch and get us performance numbers? Do you have any test with tons of 
tasklet activity that would definitely show the performance impact of 
workqueues? Workqueue priority can be set, and your handler should 
probably be SCHED_FIFO.

right now the tasklet-emulation workqueue is globally locked, etc., but 
if you use per-cpu workqueues then you'd probably get better scalability 
than tasklets. (yes, despite the extra scheduling (which only costs ~1 
microsecond) that the workqueue has to do.) Scheduling is pretty cheap, 
the basic overhead of servicing a single interrupt is often 10 times 
more expensive than a context-switch.

> I'm not strongly attached to tasklets, and it sounds like I got it 
> wrong and used the wrong delayed execution mechanism.  But that's just 
> another data point that suggests that there are too many of these.  I 
> guess I need to sit down and look into porting that to softirqs?

i'd like to stress that your approach is completely fine and valid - and 
if what we propose impacts performance negatively without any acceptable 
(and robust) replacement solution offered by us then our patch wont be 
done - simple as that. Softirqs could be an additional (performance) 
advantage on SMP systems with multiple firewire interrupt sources, but 
it would have to be measured too.

	Ingo
