Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbYFJRFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbYFJRFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbYFJRFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:05:24 -0400
Received: from smtp-out.google.com ([216.239.33.17]:30846 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbYFJRFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:05:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=T2jEpWQ4uuxrbFmzKW9mZP4u9eQmUtPlZtwLmBlxxmr8oSiCprku+gZnHQ7o/BrAa
	4cUEUFqmmGmawGYeuklAQ==
Date: Tue, 10 Jun 2008 10:04:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Max Krasnyansky <maxk@qualcomm.com>
cc: Paul Jackson <pj@sgi.com>, mingo@elte.hu, peterz@infradead.org,
       menage@google.com, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch] sched: prevent bound kthreads from changing
 cpus_allowed
In-Reply-To: <484E01B8.7000907@qualcomm.com>
Message-ID: <alpine.DEB.1.10.0806100949560.7848@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com> <20080605152953.dcfefa47.pj@sgi.com> <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com> <484D99AD.4000306@qualcomm.com> <alpine.DEB.1.10.0806091447300.10680@chino.kir.corp.google.com>
 <484E01B8.7000907@qualcomm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008, Max Krasnyansky wrote:

> > I'd also like to hear why you choose to move your workqueue threads off 
> > their originating cpu.
> CPU isolation. ie To avoid kernel activity on certain CPUs.
> 

This probably isn't something that you should be doing, at least with the 
workqueue threads.  The slab cache reaper, for example, depends on being 
able to drain caches for each cpu and will be neglected if they are moved.

I'm curious why you haven't encountered problems with this while isolating 
per-cpu workqueue threads in cpusets that don't have access to their own 
cpu.

Regardless, we'd need a patch to the slab layer and ack'd by the 
appropriate people at this point to allow the exception.

> Yes cpusets are not only about cpu affinity. But again the behaviour should be
> consistent across the board. cpuset.cpus must apply to all the task in the
> set, not just some of the tasks.
> 

It has always been possible to assign a task to a cpu and then further 
constrict its set of allowable cpus with sched_setaffinity().  So, while 
the cpus_allowed in this case are always a subset of the cpuset's cpus, 
you could still describe this as inconsistent.

> To sum it up here is what I'm suggesting:
> kthread_bind(task, cpu)
> {
>    // Set PF_THREAD_BOUND
>    // Move into root cpuset
>    // Bind to the cpu
> }
> 

kthread_bind() usually happens immediately following kthread_create(), so 
it should already be in the root cpuset.  If it has been forked in a 
different cpuset, however, implicitly moving it may be more harmful than 
any inconsistency that exists in cpus_allowed.

		David
