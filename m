Return-Path: <linux-kernel-owner+w=401wt.eu-S1762772AbXGNSmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762772AbXGNSmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 14:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759466AbXGNSmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 14:42:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52965 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759305AbXGNSmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 14:42:16 -0400
Subject: Re: [PATCH -rt 4/5] use migrate_disable for __local_begin
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20070714183557.GG6975@Krystal>
References: <20070714175733.194012000@chello.nl>
	 <20070714175840.153584000@chello.nl> <20070714171644.GC6975@Krystal>
	 <1184434342.5284.49.camel@lappy>  <20070714183557.GG6975@Krystal>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 20:41:40 +0200
Message-Id: <1184438500.5284.64.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 14:35 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > On Sat, 2007-07-14 at 13:16 -0400, Mathieu Desnoyers wrote:
> > > * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > ---
> > > >  include/asm-i386/local.h   |    7 ++++---
> > > >  include/asm-x86_64/local.h |    7 ++++---
> > > >  2 files changed, 8 insertions(+), 6 deletions(-)
> > > > 
> > > > Index: linux-2.6/include/asm-i386/local.h
> > > > ===================================================================
> > > > --- linux-2.6.orig/include/asm-i386/local.h
> > > > +++ linux-2.6/include/asm-i386/local.h
> > > > @@ -197,11 +197,12 @@ static __inline__ long local_sub_return(
> > > >  #define __local_begin(__flags)					\
> > > >  {								\
> > > >  	(__flags) = 0;						\
> > > > -	preempt_disable();					\
> > > > +	migrate_disable();					\
> > > 
> > > Brrrr. That's wrong. Your non atomic __local*() updates only makes sense
> > > when preempt_disable/enable() protects them from concurrent threads on
> > > the same CPU, which is not the case of migrate_disable/enable(). This is
> > > why I suggest that you use local_begin/end() mapped to
> > > migrate_disable/enable() for normal local variables, and, if you really
> > > want a __local_begin/end(), then it should be mapped to
> > > preempt_disable/enable() and should state that it provides no protection
> > > against interrupts.
> > 
> > Sure, but on -rt it does suffice, this part of the patch is rather WIP.
> > 
> > 
> 
> Hrm, how can it suffice, I wonder ? migrate_disable() does not protect
> against other threads on the same CPU, so you could suffer from
> concurrent updates to the same variables. How is it different in -rt ?

I thought the idea was that all these local_* operation were atomic wrt
to the local cpu.

The only difference with -rt is that we generally don't care about
interrupts.

Anyway, I'm dropping all this local stuff, and just hard code it right
into slub.c



