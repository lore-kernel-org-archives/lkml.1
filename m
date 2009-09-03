Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZICIYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZICIYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 04:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZICIYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 04:24:51 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:37608 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbZICIYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 04:24:50 -0400
Subject: Re: INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected for
	kmemleak_lock
From: Catalin Marinas <catalin.marinas@arm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1251940799.2425.22.camel@dhcp231-106.rdu.redhat.com>
References: <1251838545.2158.67.camel@dhcp231-106.rdu.redhat.com>
	 <1251888848.28251.7.camel@pc1117.cambridge.arm.com>
	 <1251891877.28251.12.camel@pc1117.cambridge.arm.com>
	 <1251940799.2425.22.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 03 Sep 2009 09:24:39 +0100
Message-Id: <1251966279.22485.2.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2009 08:24:40.0202 (UTC) FILETIME=[FB4426A0:01CA2C6F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-02 at 21:19 -0400, Eric Paris wrote:
> On Wed, 2009-09-02 at 12:44 +0100, Catalin Marinas wrote:
> > On Wed, 2009-09-02 at 11:54 +0100, Catalin Marinas wrote:
> > > On Tue, 2009-09-01 at 16:55 -0400, Eric Paris wrote:
> > > > I wrote a multithreaded inotify syscall pounder intended to create
> > > > files, destroy files, create watches, and destroy watches with the
> > > > maximum number of races possible.  Instead after letting it run a while
> > > > I came upon this!  And then my system started to crash in all sorts of
> > > > fun and glorious ways (kmem_cache_alloc bugs/panics/whatever)
> > > > 
> > > > -Eric
> > > > 
> > > > [ 2235.913737] ======================================================
> > > > [ 2235.914084] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> > > > [ 2235.914084] 2.6.31-rc8-next-20090901 #64
> > > > [ 2235.914084] ------------------------------------------------------
> > > > [ 2235.914084] syscall_thrash/2516 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> > > > [ 2235.914084]  (kthread_create_lock){+.+...}, at: [<ffffffff81091543>] kthread_create+0x73/0x180
> > > > [ 2235.914084] 
> > > > [ 2235.914084] and this task is already holding:
> > > > [ 2235.914084]  (kmemleak_lock){..----}, at: [<ffffffff81152611>] create_object+0x161/0x2e0
> > > > [ 2235.914084] which would create a new lock dependency:
> > > > [ 2235.914084]  (kmemleak_lock){..----} -> (kthread_create_lock){+.+...}
> > > 
> > > Are there other messages from kmemleak printed before that? It looks to
> > > me like kmemleak got an exceptional situation (not being able to
> > > allocate memory or inserting a pointer into the prio search tree) and it
> > > disabled itself. When disabling, it starts a clean-up thread and AFAICT
> > > that's the only condition when kmemleak_lock -> kthread_create_lock
> > > dependency would be created.
> > > 
> > > I'm not sure whether disabling interrupts around kthread_run in
> > > kmemleak_cleanup() would solve the problem. Otherwise, maybe the
> > > kmemleak clean-up thread should take a different form or just a thread
> > > waiting for a clean-up event (it currently acquires a mutex and cannot
> > > be used in interrupt context).
> > 
> > It looks like the kthread_create_lock cannot be acquired in interrupt
> > context anyway, so the patch below changes this to a workqueue.
> > 
> > 
> > kmemleak: Do no create the clean-up thread during kmemleak_disable()
> 
> I'm not going to be able to test as it hasn't happened again.  I do
> remember seeing messages about kmem leaks being found around the time of
> the issue.  Although I was working the box as hard as I could, so maybe
> I accidentally OOM'd it.  Wish there were more I could do to test or
> confirm!

OK, no problem. Anyway, it found a potential bug in kmemleak, so the
patch I posted should fix it (unless anyone spots any issues with the
patch).

Thanks.

-- 
Catalin

