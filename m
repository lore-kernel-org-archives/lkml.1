Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYFJGq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYFJGq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 02:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbYFJGqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 02:46:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50790 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYFJGqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 02:46:49 -0400
Subject: Re: [patch] sched: prevent bound kthreads from changing
	cpus_allowed
From: Peter Zijlstra <peterz@infradead.org>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       mingo@elte.hu, menage@google.com, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <484D99AD.4000306@qualcomm.com>
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>
	 <20080605152953.dcfefa47.pj@sgi.com>
	 <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com>
	 <484D99AD.4000306@qualcomm.com>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 08:44:00 +0200
Message-Id: <1213080240.31518.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-09 at 13:59 -0700, Max Krasnyanskiy wrote:
> David Rientjes wrote:
> >>  2) Sometimes calls to kthread_bind are binding to any online cpu, such as in:
> >>
> >> 	drivers/infiniband/hw/ehca/ehca_irq.c:	kthread_bind(cct->task, any_online_cpu(cpu_online_map));
> >>
> >>     In such cases, the PF_THREAD_BOUND seems inappropriate.  The caller of
> >>     kthread_bind() really doesn't seem to care where that thread is bound;
> >>     they just want it on a CPU that is still online.
> >>
> > 
> > This particular case is simply moving the thread to any online cpu so that 
> > it survives long enough for the subsequent kthread_stop() in 
> > destroy_comp_task().  So I don't see a problem with this instance.
> > 
> > A caller to kthread_bind() can always remove PF_THREAD_BOUND itself upon 
> > return, but I haven't found any cases in the tree where that is currently 
> > necessary.  And doing that would defeat the semantics of kthread_bind() 
> > where these threads are supposed to be bound to a specific cpu and not 
> > allowed to run on others.
> 
> Actually I have another use case here. Above example in particular may be ok 
> but it does demonstrate the issue nicely. Which is that in some cases kthreads 
> are bound to a CPU but do not have a strict "must run here" requirement and 
> could be moved if needed.
> For example I need an ability to move workqueue threads. Workqueue threads do 
> kthread_bind().

Per cpu workqueues should stay on their cpu.

What you're really looking for is a more fine grained alternative to
flush_workqueue().

