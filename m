Return-Path: <linux-kernel-owner+w=401wt.eu-S1763669AbXF1Qhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763669AbXF1Qhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758220AbXF1Qhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:37:47 -0400
Received: from mail.screens.ru ([213.234.233.54]:57168 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757824AbXF1Qhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:37:46 -0400
Date: Thu, 28 Jun 2007 20:37:36 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070628163736.GA525@tv-sign.ru>
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <e9c3a7c20706251846v17347ab2n4a1d314734528c95@mail.gmail.com> <1182823276.5493.240.camel@localhost.localdomain> <e9c3a7c20706251912i77ac75a0o60981590a08c34e6@mail.gmail.com> <Pine.LNX.4.58.0706280823020.19012@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0706280823020.19012@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28, Steven Rostedt wrote:
> 
> I also don't see any nice API to have the priority set for a workqueue
> thread from within the kernel. Looks like one needs to be added,
> otherwise, I need to have the wrapper dig into the workqueue structs to
> find the thread that handles the workqueue.

It is not so trivial to implement properly. Note that CPU_UP creates a new
cwq->thread, so somehow workqueue should "remember" its priority. This means
we should record it in workqueue_struct. The most simple way is to add yet
another parameter to __create_workqueue(), but this is nasty.

So, perhaps we should add "long nice" to "struct workqueue_struct", and then

	void set_workqueue_nice(struct workqueue_struct *wq, long nice)
	{
		const cpumask_t *cpu_map = wq_cpu_map(wq);
		struct cpu_workqueue_struct *cwq;
		int cpu;

		wq->nice = nice;

		mutex_lock(&workqueue_mutex);

		for_each_cpu_mask(cpu, *cpu_map) {
			cwq = per_cpu_ptr(wq->cpu_wq, cpu);
			if (cwq->thread)
				set_user_nice(cwq->thread, nice);
		}

		mutex_unlock(&workqueue_mutex);
	}

We could use for_each_cpu_online() instead, but then we should check
is_single_threaded().

Oleg.

