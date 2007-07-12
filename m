Return-Path: <linux-kernel-owner+w=401wt.eu-S935388AbXGLROF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935388AbXGLROF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 13:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbXGLRNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 13:13:53 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36286 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbXGLRNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 13:13:52 -0400
Subject: Re: [Patch RT] Fix CFS load balancing for RT tasks
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Linux RT Users <linux-rt-users@vger.kernel.org>,
       Darren Hart <dvhltc@us.ibm.com>, john stultz <johnstul@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1184258515.3000.11.camel@josh-work.beaverton.ibm.com>
References: <20070711164708.48907792@frecb000686.frec.bull.fr>
	 <1184258515.3000.11.camel@josh-work.beaverton.ibm.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 12 Jul 2007 10:13:57 -0700
Message-Id: <1184260438.3000.16.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 09:41 -0700, Josh Triplett wrote:
> On Wed, 2007-07-11 at 16:47 +0200, Sébastien Dugué wrote:
> >   there seems to be something wrong with the way the CFS balances (or does not
> > balance) RT tasks. This was evidenced using the sched_football testcase
> > available from the RT wiki (http://rt.wiki.kernel.org/index.php/IBM_Test_Cases)
> > which I modified and attached to this mail.
> > 
> >   The testcase starts a number of threads which fall into 3 categories:
> > 
> > 	1 referee thread: SCHED_FIFO, RT prio 5
> > 	ncpus defensive threads: SCHED_FIFO, RT prio 4
> > 	ncpus offensive threads: SCHED_FIFO, RT prio 3
> > 
> > 	(ncpus being the number of CPUs)
> > 
> >   To make a long story short, the defensive threads should end up distributed
> > among all CPUs, but that's not the case. For example, on a dual HT Xeon box,
> > after task migration stabilizes we have the following running on the different
> > CPUs:
> > 
> >   CPU 0: defense2
> >   CPU 1: referee offense2 offense3 offense4 defense3
> >   CPU 2: offense1
> >   CPU 3: defense1 defense4
> > 
> > which clearly show the imbalance between CPU 2 and CPU 3 where offense1
> > should not be allowed to run while the higher prio defense1 and defense4
> > are sharing the same CPU.
> > 
> >   The following patch fixes this by re-enabling the RT overload detection
> > for the CFS. It may not be the right solution, maybe it should be incorporated
> > into the other load balancing mechanisms. I did not digg deep enough yet
> > to make that call ;-)
> 
> 2.6.21.5-rt20 plus this patch passed 1000 runs of the standard
> sched_football on an 8 processor (quad dual-core) x86-64 box.  Nice
> work.

Hmmm, seems I spoke a bit too soon; due to a bug in the test log
checker, the test failed but the log checker said PASS.  Actual results:
$ grep 'Final ball position' rt-tests.log | sort | uniq -c
    960 Final ball position: 0
     39 Final ball position: 1
      1 Final ball position: 2

So it failed 4% of the runs.  However, it failed much less
spectacularly; rather than overrunning the integer maximum, it only
reached 1-2.  Still a huge improvement despite not solving the problem
completely.

> >   The RT overload mechanism of the O(1) scheduler has not been activated
> > in the new CFS.
> > 
> >   This patch fixes that by inserting calls to inc_rt_tasks() and dec_rt_tasks()
> > in enqueue_task_rt() and dequeue_task_rt() respectively, which enables the
> > balance_rt_tasks() to be run in the rt_overload case.
> > 
> > 
> > Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>
> 
> Acked-by: Josh Triplett <josh@kernel.org>

Ack still valid despite the above.

- Josh Triplett


