Return-Path: <linux-kernel-owner+w=401wt.eu-S935138AbXGMG4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935138AbXGMG4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbXGMG4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:56:19 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35319 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbXGMG4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:56:18 -0400
Date: Fri, 13 Jul 2007 08:54:03 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Linux RT Users <linux-rt-users@vger.kernel.org>,
       Darren Hart <dvhltc@us.ibm.com>, john stultz <johnstul@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch RT] Fix CFS load balancing for RT tasks
Message-ID: <20070713085403.35370914@frecb000686.frec.bull.fr>
In-Reply-To: <1184258515.3000.11.camel@josh-work.beaverton.ibm.com>
References: <20070711164708.48907792@frecb000686.frec.bull.fr>
	<1184258515.3000.11.camel@josh-work.beaverton.ibm.com>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/07/2007 09:00:39,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/07/2007 09:00:42,
	Serialize complete at 13/07/2007 09:00:42
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Josh,

On Thu, 12 Jul 2007 09:41:55 -0700 Josh Triplett <josht@linux.vnet.ibm.com> wrote:

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

  Thanks, but a nightly run revealed that there is still a bug. At least
now CFS is on par with O(1).


> 
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
> 
> - Josh Triplett

  Sébastien.
