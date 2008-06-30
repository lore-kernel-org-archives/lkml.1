Return-Path: <linux-kernel-owner+w=401wt.eu-S933404AbYF3WPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbYF3WPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762544AbYF3WPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:15:43 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:63228 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762094AbYF3WPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:15:41 -0400
Date: Tue, 1 Jul 2008 00:14:17 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueues: make get_online_cpus() useable for
	work->func()
Message-ID: <20080630221417.GA4727@osiris.boeblingen.de.ibm.com>
References: <20080629165131.GA11215@tv-sign.ru> <20080630134349.GB7686@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630134349.GB7686@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 03:43:49PM +0200, Heiko Carstens wrote:
> On Sun, Jun 29, 2008 at 08:51:31PM +0400, Oleg Nesterov wrote:
> > workqueue_cpu_callback(CPU_DEAD) flushes cwq->thread under
> > cpu_maps_update_begin(). This means that the multithreaded workqueues can't
> > use get_online_cpus() due to the possible deadlock, very bad and very old
> > problem.
> > 
> > Introduce the new state, CPU_POST_DEAD, which is called after
> > cpu_hotplug_done() but before cpu_maps_update_done().
> > 
> > Change workqueue_cpu_callback() to use CPU_POST_DEAD instead of CPU_DEAD.
> > This means that create/destroy functions can't rely on get_online_cpus()
> > any longer and should take cpu_add_remove_lock instead.
> 
> Ah, nice!
> 
> > --- 26-rc2/kernel/cpu.c~WQ_4_GET_ONLINE_CPUS	2008-05-18 15:44:18.000000000 +0400
> > +++ 26-rc2/kernel/cpu.c	2008-06-29 20:03:19.000000000 +0400
> > @@ -261,6 +261,11 @@ out_allowed:
> >  	set_cpus_allowed_ptr(current, &old_allowed);
> >  out_release:
> >  	cpu_hotplug_done();
> > +	if (!err) {
> 
> This should be (!err && !cpu_online(cpu)), no?
> 
> This is because it might be that __stop_machine_run() succeeded, but
> take_cpu_down() failed and therefore our cpu is still online.

Erk.. it's ok as is since err will contain the return value of take_cpu_down()
after err = kthread_stop(p).
Never mind, just ignore me :)
