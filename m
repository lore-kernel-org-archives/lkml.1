Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZGJNqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZGJNqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 09:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZGJNqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 09:46:31 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:33580 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbZGJNqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 09:46:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xl6QMMeKoDYBTVsr0AgLFpz7gLX0vmkJ6X4Yjid+uY40sxbx8meix2tLgCqme2mYbc
         VKrztd51IgR9nVT47pSFSeGJ5NfQq3XfKxiH1erROxjL0chFxWtxqkouHyjAghPxWtCI
         JIlZBiWHm+IPrj2T+jZkLxYzlwDyd5tz3p58E=
Date: Fri, 10 Jul 2009 15:46:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mitake@dcl.info.waseda.ac.jp,
       andi@firstfloor.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
	how many spinlocks to schedstat
Message-ID: <20090710134625.GB6237@nowhere>
References: <20090706.142058.56800444.mitake@dcl.info.waseda.ac.jp> <1246870279.8143.4.camel@twins> <20090706115451.GA29715@one.firstfloor.org> <20090710.214547.34380852.mitake@dcl.info.waseda.ac.jp> <1247230336.7529.34.camel@twins> <20090710134307.GB23481@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710134307.GB23481@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 03:43:07PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Fri, 2009-07-10 at 21:45 +0900, mitake@dcl.info.waseda.ac.jp wrote:
> > > From: Andi Kleen <andi@firstfloor.org>
> > > Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
> > > Date: Mon, 6 Jul 2009 13:54:51 +0200
> > > 
> > > Thank you for your replying, Peter and Andi.
> > > 
> > > > > Maybe re-use the LOCK_CONTENDED macros for this, but I'm not sure we
> > > > > want to go there and put code like this on the lock hot-paths for !debug
> > > > > kernels.
> > > > 
> > > > My concern was similar.
> > > > 
> > > > I suspect it would be in theory ok for the slow spinning path, but I am 
> > > > somewhat concerned about the additional cache miss for checking
> > > > the global flag even in this case. This could hurt when
> > > > the kernel is running fully cache hold, in that the cache miss
> > > > might be far more expensive that  short spin.
> > > 
> > > Yes, there will be overhead. This is certain.
> > > But there's the radical way to ignore this,
> > > adding subcategory to Kconfig for measuring spinlocks and #ifdef to spinlock.c.
> > > So people who wants to avoid this overhead can disable measurement of spinlocks completely.
> > > 
> > > And there's another way to avoid the overhead of measurement. 
> > > Making _spin_lock variable of function pointer. When you don't 
> > > want to measure spinlocks, assign _spin_lock_raw() which is 
> > > equals to current _spin_lock(). When you want to measure 
> > > spinlocks, assign _spin_lock_perf() which locks and measures. 
> > > This way will banish the cache miss problem you said. I think 
> > > this may be useful for avoiding problem of recursion.
> > 
> > We already have that, its called CONFIG_LOCKDEP && 
> > CONFIG_EVENT_TRACING && CONFIG_EVENT_PROFILE, with those enabled 
> > you get tracepoints on every lock acquire and lock release, and 
> > perf can already use those as event sources.
> 
> Yes, that could be reused for this facility too.
> 
> 	Ingo


I wonder if the lock_*() events should become independant from lockdep
so that we don't need to always enable lockdep to get the lock events at the
same time.

It could be a separate option.

