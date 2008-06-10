Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbYFJRUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbYFJRUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbYFJRUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:20:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42996 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYFJRUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:20:01 -0400
Subject: Re: [patch] sched: prevent bound kthreads from
	changing	cpus_allowed
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Max Krasnyansky <maxk@qualcomm.com>, David Rientjes <rientjes@google.com>,
       Paul Jackson <pj@sgi.com>, mingo@elte.hu, menage@google.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080610170005.GA6038@tv-sign.ru>
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>
	 <20080605152953.dcfefa47.pj@sgi.com>
	 <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com>
	 <484D99AD.4000306@qualcomm.com> <1213080240.31518.5.camel@twins>
	 <484E9FE8.9040504@qualcomm.com>  <20080610170005.GA6038@tv-sign.ru>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 19:19:46 +0200
Message-Id: <1213118386.19005.9.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 21:00 +0400, Oleg Nesterov wrote:
> On 06/10, Max Krasnyansky wrote:
> > 
> > Peter Zijlstra wrote:
> > >
> > > Per cpu workqueues should stay on their cpu.
> > >
> > > What you're really looking for is a more fine grained alternative to
> > > flush_workqueue().
> > Actually I had a discussion on that with Oleg Nesterov. If you remember my
> > original solution (ie centralized cpu_isolate_map) was to completely redirect
> > work onto other cpus. Then you pointed out that it's the flush_() that really
> > makes the box stuck. So I started thinking about redoing the flush. While
> > looking at the code I realized that if I only change the flush_() then queued
> > work can get stale so to speak. ie Machine does not get stuck but some work
> > submitted on the isolated cpus will sit there for a long time. Oleg pointed
> > out exact same thing. So the simplest solution that does not require any
> > surgery to the workqueue is to just move the threads to other cpus.
> 
> Cough... I'd like to mention that I _personally agree with Peter, cwq->thread's
> should stay on their cpu.
> 
> I just meant that from the workqueue.c pov it is (afaics) OK to move cwq->thread
> to other CPUs, in a sense that this shouldn't add races or hotplug problems, etc.
> But still this doesn't look right to me.

The advantage of creating a more flexible or fine-grained flush is that
large machine also profit from it.

A simple scheme would be creating a workqueue context that is passed
along on enqueue, and then passed to flush.

This context could:

 - either track the individual worklets and employ a completion scheme
to wait for them;

 - or track on which cpus the worklets are enqueued and flush only those
few cpus.

Doing this would solve your case since nobody (except those having
business) will enqueue something on the isolated cpus.

And it will improve the large machine case for the same reasons - it
won't have to iterate all cpus.

Of course, things that use schedule_on_each_cpu() will still end up
doing things on your isolated cpus, but getting around those would
probably get you into some correctness trouble.



