Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbXDDQYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbXDDQYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbXDDQYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:24:33 -0400
Received: from mail.screens.ru ([213.234.233.54]:34179 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbXDDQYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:24:32 -0400
Date: Wed, 4 Apr 2007 19:28:28 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 7/8] Clean up workqueue.c with respect to the freezer based cpu-hotplug
Message-ID: <20070404152828.GA416@tv-sign.ru>
References: <20070402053457.GA9076@in.ibm.com> <20070402054206.GG12962@in.ibm.com> <20070403114729.GA776@tv-sign.ru> <20070403135919.GB32444@in.ibm.com> <20070403150336.GA850@tv-sign.ru> <20070403171820.GA8646@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403171820.GA8646@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03, Srivatsa Vaddagiri wrote:
>
> On Tue, Apr 03, 2007 at 07:03:36PM +0400, Oleg Nesterov wrote:
> 
> > is better to introduce a new helper for that, kthread_thaw_stop() or
> > something.
> 
> Will think of that.

I changed my mind :) The problem is general, I am starting to believe
it is better to change kthread_stop().

> > > kthread_stop(p)
> > > {
> > > 	int old_exempt_flags;
> > > 
> > > 	task_lock(p);
> > > 	old_exempt_flags = p->flags;
> > > 	p->flags |= PFE_ALL;	/* Exempt 'p' from being frozen? */
> > 
> > I agree, we should mark this thread as non-freezable, but we can't modify
> > p->flags, this is racy. "current" owns its ->flags and it is not atomic.
> > Note that thaw_process() checks frozen(p) when it clears PF_FROZEN.
> 
> I suspected that we cannot modify p->flags just like that. How abt
> moving freezer exemption bits to a separate field, which is protected by
> task_lock?

Probably yes... In that case it makes sense to move PF_FREEZER_SKIP/PF_FROZEN
to the new field as well.

Perhaps we can ignore this problem for now. Freezer is not 100% reliable
anyway. For example,

	worker_thread:

		for (;;) {
			try_to_freeze();

			prepare_to_wait();
			if (...)
				schedule();
			finish_wait();
		}

This is racy, we can miss freeze_process()->signal_wake_up() if it happens
between try_to_freeze() and prepare_to_wait(). We have to check TIF_FREEZE
before entering schedule() if we want to fix this race.

Should we? I don't know. This will uglify the code, and the probability
of this race is very low.

Oleg.

