Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbZESS4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbZESS4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 14:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZESS4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 14:56:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39967 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbZESS4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 14:56:38 -0400
Date: Tue, 19 May 2009 20:51:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: INFO: possible circular locking dependency at
	cleanup_workqueue_thread
Message-ID: <20090519185140.GA32012@redhat.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com> <20090517071834.GA8507@elte.hu> <1242559101.28127.63.camel@johannes.local> <20090518194749.GA3501@redhat.com> <1242723104.17164.5.camel@johannes.local> <20090519120010.GA14782@redhat.com> <1242747203.4797.39.camel@johannes.local> <20090519160936.GA25720@redhat.com> <1242750470.4797.42.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242750470.4797.42.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19, Johannes Berg wrote:
>
> On Tue, 2009-05-19 at 18:09 +0200, Oleg Nesterov wrote:
>
> > > Right. But exactly this happens in the hibernate case --
> >
> > not sure I understand your "exactly this" ;)
> >
> > But your explanation of the deadlock below looks great!
>
> Yeah... I got side-tracked, I had a scenario in mind that actually
> needed cpu_add_remove_lock().
>
> > except I don't understand how cpu_add_remove_lock makes the difference...
> > And thus I can't understand why cpu_down() (called lockless) have the
> > same problems. Please see below.
> >
> > > Anyway, you can have a deadlock like this:
> > >
> > > CPU 3			CPU 2				CPU 1
> > > 							suspend/hibernate
> > > 			something:
> > > 			rtnl_lock()			device_pm_lock()
> > > 							-> mutex_lock(&dpm_list_mtx)
> > >
> > > 			mutex_lock(&dpm_list_mtx)
> > >
> > > linkwatch_work
> > >  -> rtnl_lock()
> > > 							disable_nonboot_cpus()
> >
> > let's suppose disable_nonboot_cpus() does not take cpu_add_remove_lock,
> >
> > > 							-> flush CPU 3 workqueue
> >
> > in this case the deadlock is still here?
> >
> > We can't flush because we hold the lock (dpm_list_mtx) which depends
> > on another lock taken by work->func(), the "classical" bug with flush.
> >
> > No?
>
> Yeah, it looks like cpu_add_remove_lock doesn't make a difference...
> It's just lockdep reporting a longer chain that also leads to a
> deadlock.

So. we should not call cpu_down/disable_nonboot_cpus under device_pm_lock().

At first glance this was changed by

	PM: Change hibernation code ordering
	4aecd6718939eb3c4145b248369b65f7483a8a02

	PM: Change suspend code ordering
	900af0d973856d6feb6fc088c2d0d3fde57707d3

commits. Rafael, could you take a look?


> OTOH just replace dpm_list_mtx with cpu_add_remove_lock and
> you have the same scenario...

Yes, but

> happens too, I guess, somehow.

Oh, I hope not ;) nobody should use cpu_maps_update_begin() except
cpu_down/up pathes. And workqueue.c, which uses it exactly because
we want to call _cpu_down()->flush_cpu_workqueue() without any other
locks held. But if the caller of cpu_down() holds some lock, then
we have the usual problems with the flush under lock.

Oleg.

