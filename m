Return-Path: <linux-kernel-owner+w=401wt.eu-S1765296AbYEOUql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765296AbYEOUql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755782AbYEOUq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:46:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYEOUq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:46:26 -0400
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>
In-Reply-To: <20080515132713.18f1b953@infradead.org>
References: <20080514174955.GA515@elte.hu>
	 <alpine.LFD.1.10.0805151020460.3019@woody.linux-foundation.org>
	 <20080515132713.18f1b953@infradead.org>
Content-Type: text/plain
Date: Thu, 15 May 2008 22:45:55 +0200
Message-Id: <1210884355.6524.21.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-15 at 13:27 -0700, Arjan van de Ven wrote:
> On Thu, 15 May 2008 10:41:54 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > So looking a bit more at your trivial fixups, I'd suggest strongly
> > that they be re-organized a bit.
> 
> > >
> > > diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
> > > index 6eab9bf..e12e571 100644
> > > --- a/net/sunrpc/sched.c
> > > +++ b/net/sunrpc/sched.c
> > > @@ -224,9 +224,15 @@ EXPORT_SYMBOL_GPL(rpc_destroy_wait_queue);
> > >  
> > >  static int rpc_wait_bit_killable(void *word)
> > >  {
> > > +	int bkl = kernel_locked();
> > > +
> > >  	if (fatal_signal_pending(current))
> > >  		return -ERESTARTSYS;
> > > +	if (bkl)
> > > +		unlock_kernel();
> > >  	schedule();
> > > +	if (bkl)
> > > +		lock_kernel();
> > >  	return 0;
> > >  }
> > 
> > The above doesn't even work in general. It depends on having just a
> > single level of locking, and is ugly to boot. So wow about we just
> > expose some version of
> > 
> > 	depth = release_kernel_lock()
> > 	..
> > 	reacquire_kernel_lock(depth);
> > 
> > to existing BKL users as a way to safely release and re-aquire it 
> > regardless of depth. That makes the code more generic, but it *also*
> > makes it more readable than that "if (bkl) [un]lock_kernel()"
> > sequence.
> 
> 
> can we make this even more specific/restricted? Like having something
> like
> 
> call_bkl_unlocked(function_pointer, argument);
> 
> or something that will internally do the full unlock and then the
> function call. The last thing we need is another nailgun that BKL using
> code can use to staple themselves to something big and fast moving.
> By having a more restricted interface... less likely.
> Maybe we can even get away with only a
> 
> drop_bkl_and_schedule();
> 
> and nothing else.

No, that would defeat the whole purpose of the exercise. This drop on
schedule property makes it possible to have inverse lock order and not
deadlock.

That also makes the manual re-acquire on a different level pretty ugly
and deadlock prone.

The whole purpose of this patch series was to get rid of this exact
problem so that the BKL turns into something that resembles a normal
lock within the regular locking hierarchy.

