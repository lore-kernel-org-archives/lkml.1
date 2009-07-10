Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZGJMwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZGJMwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZGJMw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:52:28 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:63862 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbZGJMw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:52:27 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
 how many spinlocks to schedstat
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mitake@dcl.info.waseda.ac.jp
Cc: andi@firstfloor.org, fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090710.214547.34380852.mitake@dcl.info.waseda.ac.jp>
References: <20090706.142058.56800444.mitake@dcl.info.waseda.ac.jp>
	 <1246870279.8143.4.camel@twins> <20090706115451.GA29715@one.firstfloor.org>
	 <20090710.214547.34380852.mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 14:52:16 +0200
Message-Id: <1247230336.7529.34.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 21:45 +0900, mitake@dcl.info.waseda.ac.jp wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
> Date: Mon, 6 Jul 2009 13:54:51 +0200
> 
> Thank you for your replying, Peter and Andi.
> 
> > > Maybe re-use the LOCK_CONTENDED macros for this, but I'm not sure we
> > > want to go there and put code like this on the lock hot-paths for !debug
> > > kernels.
> > 
> > My concern was similar.
> > 
> > I suspect it would be in theory ok for the slow spinning path, but I am 
> > somewhat concerned about the additional cache miss for checking
> > the global flag even in this case. This could hurt when
> > the kernel is running fully cache hold, in that the cache miss
> > might be far more expensive that  short spin.
> 
> Yes, there will be overhead. This is certain.
> But there's the radical way to ignore this,
> adding subcategory to Kconfig for measuring spinlocks and #ifdef to spinlock.c.
> So people who wants to avoid this overhead can disable measurement of spinlocks completely.
> 
> And there's another way to avoid the overhead of measurement.
> Making _spin_lock variable of function pointer.
> When you don't want to measure spinlocks,
> assign _spin_lock_raw() which is equals to current _spin_lock().
> When you want to measure spinlocks,
> assign _spin_lock_perf() which locks and measures.
> This way will banish the cache miss problem you said.
> I think this may be useful for avoiding problem of recursion.

We already have that, its called CONFIG_LOCKDEP && CONFIG_EVENT_TRACING
&& CONFIG_EVENT_PROFILE, with those enabled you get tracepoints on every
lock acquire and lock release, and perf can already use those as event
sources.



