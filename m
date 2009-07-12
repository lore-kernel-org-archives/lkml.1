Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbZGLHYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbZGLHYE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 03:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZGLHXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 03:23:53 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:64307 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZGLHXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 03:23:52 -0400
Date: Sun, 12 Jul 2009 16:23:37 +0900 (JST)
Message-Id: <20090712.162337.287595819039280884.mitake@dcl.info.waseda.ac.jp>
To: a.p.zijlstra@chello.nl
Cc: andi@firstfloor.org, fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
 how many spinlocks to schedstat
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <1247230336.7529.34.camel@twins>
References: <20090706115451.GA29715@one.firstfloor.org>
	<20090710.214547.34380852.mitake@dcl.info.waseda.ac.jp>
	<1247230336.7529.34.camel@twins>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
Date: Fri, 10 Jul 2009 14:52:16 +0200

> On Fri, 2009-07-10 at 21:45 +0900, mitake@dcl.info.waseda.ac.jp wrote:
> > From: Andi Kleen <andi@firstfloor.org>
> > Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
> > Date: Mon, 6 Jul 2009 13:54:51 +0200
> > 
> > Thank you for your replying, Peter and Andi.
> > 
> > > > Maybe re-use the LOCK_CONTENDED macros for this, but I'm not sure we
> > > > want to go there and put code like this on the lock hot-paths for !debug
> > > > kernels.
> > > 
> > > My concern was similar.
> > > 
> > > I suspect it would be in theory ok for the slow spinning path, but I am 
> > > somewhat concerned about the additional cache miss for checking
> > > the global flag even in this case. This could hurt when
> > > the kernel is running fully cache hold, in that the cache miss
> > > might be far more expensive that  short spin.
> > 
> > Yes, there will be overhead. This is certain.
> > But there's the radical way to ignore this,
> > adding subcategory to Kconfig for measuring spinlocks and #ifdef to spinlock.c.
> > So people who wants to avoid this overhead can disable measurement of spinlocks completely.
> > 
> > And there's another way to avoid the overhead of measurement.
> > Making _spin_lock variable of function pointer.
> > When you don't want to measure spinlocks,
> > assign _spin_lock_raw() which is equals to current _spin_lock().
> > When you want to measure spinlocks,
> > assign _spin_lock_perf() which locks and measures.
> > This way will banish the cache miss problem you said.
> > I think this may be useful for avoiding problem of recursion.
> 
> We already have that, its called CONFIG_LOCKDEP && CONFIG_EVENT_TRACING
> && CONFIG_EVENT_PROFILE, with those enabled you get tracepoints on every
> lock acquire and lock release, and perf can already use those as event
> sources.
> 
> 
> 
> 

Thanks, I understood your advice. Using infrastructure of ftrace is good idea, so I'll use it.

But I have a question.
I can't enable CONFIG_EVENT_PROFILE because it depends on CONFIG_EVENT_TRACER.
And CONFIG_EVENT_TRACER seems something never enabled.

% git grep EVENT_TRACER
arch/arm/configs/cm_x300_defconfig:# CONFIG_EVENT_TRACER is not set
arch/arm/configs/davinci_all_defconfig:# CONFIG_EVENT_TRACER is not set
arch/arm/configs/ep93xx_defconfig:# CONFIG_EVENT_TRACER is not set
...
arch/x86/configs/i386_defconfig:# CONFIG_EVENT_TRACER is not set
arch/x86/configs/x86_64_defconfig:# CONFIG_EVENT_TRACER is not set
init/Kconfig:   depends on PERF_COUNTERS && EVENT_TRACER

In addition, this is the output of searching this on menuconfig
    Symbol: EVENT_TRACER [=EVENT_TRACER]          
and, there is a log in git

commit a7abe97fd8e7a6ccabba5a04a9f17be9211d418c
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Mon Apr 20 10:59:34 2009 -0400

    tracing: rename EVENT_TRACER config to ENABLE_EVENT_TRACING

    Currently we have two configs: EVENT_TRACING and EVENT_TRACER.
    All tracers enable EVENT_TRACING. The EVENT_TRACER is only a
    convenience to enable the EVENT_TRACING when no other tracers
    are enabled.

Does EVENT_TRACER make any sense?
If doesn't, can I remove dependency of CONFIG_EVENT_PROFILE?
