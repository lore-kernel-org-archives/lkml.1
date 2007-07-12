Return-Path: <linux-kernel-owner+w=401wt.eu-S1765611AbXGLRKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765611AbXGLRKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 13:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbXGLRKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 13:10:40 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50223 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbXGLRKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 13:10:39 -0400
Subject: Re: [Patch RT] Fix CFS load balancing for RT tasks
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Linux RT Users <linux-rt-users@vger.kernel.org>,
       Darren Hart <dvhltc@us.ibm.com>, john stultz <johnstul@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20070711164708.48907792@frecb000686.frec.bull.fr>
References: <20070711164708.48907792@frecb000686.frec.bull.fr>
Content-Type: text/plain; charset=utf-8
Date: Thu, 12 Jul 2007 09:41:55 -0700
Message-Id: <1184258515.3000.11.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 16:47 +0200, Sébastien Dugué wrote:
>   there seems to be something wrong with the way the CFS balances (or does not
> balance) RT tasks. This was evidenced using the sched_football testcase
> available from the RT wiki (http://rt.wiki.kernel.org/index.php/IBM_Test_Cases)
> which I modified and attached to this mail.
> 
>   The testcase starts a number of threads which fall into 3 categories:
> 
> 	1 referee thread: SCHED_FIFO, RT prio 5
> 	ncpus defensive threads: SCHED_FIFO, RT prio 4
> 	ncpus offensive threads: SCHED_FIFO, RT prio 3
> 
> 	(ncpus being the number of CPUs)
> 
>   To make a long story short, the defensive threads should end up distributed
> among all CPUs, but that's not the case. For example, on a dual HT Xeon box,
> after task migration stabilizes we have the following running on the different
> CPUs:
> 
>   CPU 0: defense2
>   CPU 1: referee offense2 offense3 offense4 defense3
>   CPU 2: offense1
>   CPU 3: defense1 defense4
> 
> which clearly show the imbalance between CPU 2 and CPU 3 where offense1
> should not be allowed to run while the higher prio defense1 and defense4
> are sharing the same CPU.
> 
>   The following patch fixes this by re-enabling the RT overload detection
> for the CFS. It may not be the right solution, maybe it should be incorporated
> into the other load balancing mechanisms. I did not digg deep enough yet
> to make that call ;-)

2.6.21.5-rt20 plus this patch passed 1000 runs of the standard
sched_football on an 8 processor (quad dual-core) x86-64 box.  Nice
work.

>   The RT overload mechanism of the O(1) scheduler has not been activated
> in the new CFS.
> 
>   This patch fixes that by inserting calls to inc_rt_tasks() and dec_rt_tasks()
> in enqueue_task_rt() and dequeue_task_rt() respectively, which enables the
> balance_rt_tasks() to be run in the rt_overload case.
> 
> 
> Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>

Acked-by: Josh Triplett <josh@kernel.org>

- Josh Triplett


