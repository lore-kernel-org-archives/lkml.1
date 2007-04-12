Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXDLQ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXDLQ4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965573AbXDLQ4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:56:18 -0400
Received: from mail.screens.ru ([213.234.233.54]:59738 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964934AbXDLQ4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:56:16 -0400
Date: Thu, 12 Apr 2007 20:00:04 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 7/8] Clean up workqueue.c with respect to the freezer based cpu-hotplug
Message-ID: <20070412160004.GA4183@tv-sign.ru>
References: <20070402053457.GA9076@in.ibm.com> <20070402054206.GG12962@in.ibm.com> <20070403114729.GA776@tv-sign.ru> <20070403135919.GB32444@in.ibm.com> <20070403150336.GA850@tv-sign.ru> <20070403171820.GA8646@in.ibm.com> <20070412022220.GA10176@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412022220.GA10176@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12, Srivatsa Vaddagiri wrote:
>
> On Tue, Apr 03, 2007 at 10:48:20PM +0530, Srivatsa Vaddagiri wrote:
> > > Actually, we should do this before destroy_workqueue() calls flush_workqueue().
> > > Otherwise flush_cpu_workqueue() can hang forever in a similar manner.
> > 
> > Yep. I guess these are a class of freezer deadlocks very similar to vfork
> > parent waiting on child case. I get a feeling these should become common
> > outside of kthread too (A waits on B for something, B gets frozen, which
> > means A won't freeze causing freezer to fail). Can freezer detect this
> > dependency somehow and thaw B automatically? Probably not that easy ..
> 
> I wonder if there is some value in "enforcing" an order in which
> processes get frozen i.e freeze A first before B. That may solve the
> deadlocks we have been discussing wrt kthread_stop and flush_workqueue
> as well.

Perhaps we can add "atomic_t xxx" to task_struct.

	int freezing(struct task_struct *p)
	{
		return test_tsk_thread_flag(p, TIF_FREEZE)
			&& atomic_read(&p->xxx) == 0;
	}

	void xxx_start(struct task_struct *p)
	{
		atomic_inc(p->xxx);
		thaw_process(p);
	}

	xxx_end(struct task_struct *p)
	{
		atomic_dec(p->xxx);
	}

Now,

	xxx_start(p);
	... wait for something which depends on p...
	xxx_end(p);

Of course we need other changes, freeze_process() should check ->xxx, etc.
I am not sure this makes sense.

Oleg.

