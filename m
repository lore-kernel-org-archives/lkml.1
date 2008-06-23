Return-Path: <linux-kernel-owner+w=401wt.eu-S1761894AbYFWRyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761894AbYFWRyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbYFWRyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:54:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39815 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762006AbYFWRyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:54:35 -0400
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
	with irqs disable
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1214241561.19392.21.camel@elijah.suse.cz>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
	 <20080507073017.GJ32195@elte.hu>
	 <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com>
	 <1214241561.19392.21.camel@elijah.suse.cz>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 19:54:13 +0200
Message-Id: <1214243653.3223.363.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 19:19 +0200, Petr Tesarik wrote:
> On Wed, 2008-05-07 at 11:49 -0700, Christoph Lameter wrote:
> > Subject: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin with irqs disabled
> > 
> > The nice spinlock functions that enable interrupts while spinning are only
> > usable if GENERIC_LOCKBREAK is set (and we do not debug locks but lock
> > debugging would not be used for a production configuration).
> > 
> > Factor out the dependencies on the ->lock_break field from the nice functions
> > into a set of BREAKLOCK macros (cannot be functions since the type of the lock
> > variable varies).
> > 
> > The nice spinlock function can then also be used if !GENERIC_LOCKBREAK
> > 
> > Signed-off-by: Christoph Lameter <clameter@sgi.com>
> > 
> > ---
> >  kernel/spinlock.c |   40 ++++++++++++++++++++++++++++++----------
> >  1 file changed, 30 insertions(+), 10 deletions(-)
> > 
> > Index: linux-2.6/kernel/spinlock.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/spinlock.c	2008-05-07 11:19:31.000000000 -0700
> > +++ linux-2.6/kernel/spinlock.c	2008-05-07 11:40:56.000000000 -0700
> > @@ -65,7 +65,7 @@ EXPORT_SYMBOL(_write_trylock);
> >   * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
> >   * not re-enabled during lock-acquire (which the preempt-spin-ops do):
> >   */
> > -#if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
> > +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> 
> Maybe I'm just blind, but doesn't this change effectively disable any
> arch-specific optimized code for _raw_*_lock?
> 
> If CONFIG_DEBUG_LOCK_ALLOC is set, then CONFIG_DEBUG_SPINLOCK must also
> be set, so in that case the debugging versions of _raw_*_lock are used.
> But if CONFIG_DEBUG_LOCK_ALLOC is _not_ set, then the locks are built
> with _trylock and _can_lock primitives.
> 
> What am I missing here?

No, I think you're right.

I've been playing with these patches:

  http://programming.kicks-ass.net/kernel-patches/spinlocks/

But as it stands it breaks !CONFIG_PREEMPT... ought to find some other
cycles to spend on it..



