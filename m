Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbZEVWXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbZEVWXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 18:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbZEVWXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 18:23:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56280 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270AbZEVWXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 18:23:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: INFO: possible circular locking dependency at cleanup_workqueue_thread
Date: Sat, 23 May 2009 00:23:15 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com> <20090519185140.GA32012@redhat.com> <1242989166.4606.5.camel@johannes.local>
In-Reply-To: <1242989166.4606.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905230023.16377.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 May 2009, Johannes Berg wrote:
> On Tue, 2009-05-19 at 20:51 +0200, Oleg Nesterov wrote:
> 
> > > > > Anyway, you can have a deadlock like this:
> > > > >
> > > > > CPU 3			CPU 2				CPU 1
> > > > > 							suspend/hibernate
> > > > > 			something:
> > > > > 			rtnl_lock()			device_pm_lock()
> > > > > 							-> mutex_lock(&dpm_list_mtx)
> > > > >
> > > > > 			mutex_lock(&dpm_list_mtx)
> > > > >
> > > > > linkwatch_work
> > > > >  -> rtnl_lock()
> > > > > 							disable_nonboot_cpus()
> > > >
> > > > let's suppose disable_nonboot_cpus() does not take cpu_add_remove_lock,
> > > >
> > > > > 							-> flush CPU 3 workqueue
> > > >
> > > > in this case the deadlock is still here?
> > > >
> > > > We can't flush because we hold the lock (dpm_list_mtx) which depends
> > > > on another lock taken by work->func(), the "classical" bug with flush.
> > > >
> > > > No?
> > >
> > > Yeah, it looks like cpu_add_remove_lock doesn't make a difference...
> > > It's just lockdep reporting a longer chain that also leads to a
> > > deadlock.
> > 
> > So. we should not call cpu_down/disable_nonboot_cpus under device_pm_lock().
> > 
> > At first glance this was changed by
> > 
> > 	PM: Change hibernation code ordering
> > 	4aecd6718939eb3c4145b248369b65f7483a8a02
> > 
> > 	PM: Change suspend code ordering
> > 	900af0d973856d6feb6fc088c2d0d3fde57707d3
> > 
> > commits. Rafael, could you take a look?
> 
> I just arrived at the same conclusion, heh. I can't say I understand
> these changes though, the part about calling the platform differently
> may make sense, but calling why disable non-boot CPUs at a different
> place?

Because the ordering of platform callbacks and cpu[_up()|_down()] is also
important, at least on resume.

In principle we can call device_pm_unlock() right before calling
disable_nonboot_cpus() and take the lock again right after calling
enable_nonboot_cpus(), if that helps.

Thanks,
Rafael
