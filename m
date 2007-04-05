Return-Path: <linux-kernel-owner+w=401wt.eu-S2992698AbXDENfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992698AbXDENfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 09:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992700AbXDENfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 09:35:15 -0400
Received: from mail.screens.ru ([213.234.233.54]:49227 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992698AbXDENfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 09:35:13 -0400
Date: Thu, 5 Apr 2007 17:34:49 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@elte.hu,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 3/8] Use process freezer for cpu-hotplug
Message-ID: <20070405133449.GA834@tv-sign.ru>
References: <20070402053457.GA9076@in.ibm.com> <20070402053824.GC12962@in.ibm.com> <20070405105356.GA713@tv-sign.ru> <20070405121423.GC16173@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070405121423.GC16173@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05, Gautham R Shenoy wrote:
>
> > > @@ -147,6 +147,7 @@ cpu_callback(struct notifier_block *nfb,
> > >  	case CPU_DEAD:
> > >  		p = per_cpu(watchdog_task, hotcpu);
> > >  		per_cpu(watchdog_task, hotcpu) = NULL;
> > > +		thaw_process(p);
> > >  		kthread_stop(p);
> > 
> > As it was already discussed, this is racy. As Srivatsa (imho rightly)
> > suggested, kthread_stop(p) should thaw process itself. This also allows
> > us to kill at least some of wait_for_die loops.
> > 
> 
> Well, in this case this is not racy. Remember, we're doing a
> thaw_process(p) in CPU_DEAD where p *is* frozen for cpu hotplug. So
> the where we might call a freeze_process(p) after we do a thaw_process
> doesn't seem to be feasible.

Oops, yes.

> > However, the change in kthread_stop(p) in not enough to close the race.
> > We can check kthread_should_stop() in refrigerator(), this looks like
> > a most simple approach for now.
> > 
> 
> Why the check kthread_should_stop() refrigerator() ?
> As vatsa mentioned, we would be doing 
> 
> task_lock(p);
> freezer_exempt(p, FE_ALL); /* Doesn't exist as of now, but we can work
> 				it out */
> thaw_process(p);
> task_unlock(p);

Please look at http://marc.info/?l=linux-kernel&m=117562018530190, we can't
change p->flags unless we know it is frozen.

> > Alternatively, Srivatsa suggests to introduce a new task_lock() protected
> > task_struct->freezer_state (so we can reliably set FE_ALL). Surely this is
> > more poweful, but needs more changes. I am not sure. Perhaps we can do
> > this later.
> 
> This needs an extra field! We're supposed to be miserly when it comes to
> adding new fields to task_struct, now aren't we :-)

That is why "Perhaps we can do this later" :)

> > In any case, imho "try3" should add thaw_process() to kthread_stop().
> > Gautham, Srivatsa, do you agree?
> > 
> 
> Completely. Working on it now.

Great!

Oleg.

