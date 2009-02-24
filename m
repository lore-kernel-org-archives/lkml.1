Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbZBXDhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbZBXDhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZBXDhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:37:18 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47826 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbZBXDhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:37:16 -0500
Date: Mon, 23 Feb 2009 19:37:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090224033712.GA7173@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220140157.GA12799@elte.hu> <20090223193351.GA11921@elte.hu> <20090223204359.GT6751@linux.vnet.ibm.com> <200902241423.21091.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902241423.21091.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 02:23:19PM +1100, Nick Piggin wrote:
> On Tuesday 24 February 2009 07:43:59 Paul E. McKenney wrote:
> > On Mon, Feb 23, 2009 at 08:33:51PM +0100, Ingo Molnar wrote:
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > On Mon, 23 Feb 2009 08:17:26 -0800 "Paul E. McKenney" 
> <paulmck@linux.vnet.ibm.com> wrote:
> > > > > On Tue, Feb 24, 2009 at 12:29:36AM +1100, Nick Piggin wrote:
> > > > > > On Monday 23 February 2009 16:17:09 Paul E. McKenney wrote:
> > > > > > > The boot CPU runs in the context of its idle thread during
> > > > > > > boot-up. During this time, idle_cpu(0) will always return
> > > > > > > nonzero, which will fool Classic and Hierarchical RCU into
> > > > > > > deciding that a large chunk of the boot-up sequence is a big long
> > > > > > > quiescent state.  This in turn causes RCU to prematurely end
> > > > > > > grace periods during this time.
> > > > > > >
> > > > > > > This patch creates a new global variable that is set to 1 just
> > > > > > > before the boot CPU first enters the scheduler, after which the
> > > > > > > idle task really is idle.
> > > > > >
> > > > > > Nice work all (btw. if this patch goes in rather than using
> > > > > > system_state, then please make the variable __read_mostly).
> > > > >
> > > > > Hmmm...  I misread this and made system_state be __read_mostly.  Let
> > > > > me know if this is bad, easy to fix if needed.
> > > >
> > > > Please don't use system_state.  The whole thing is just bad
> > > > design. It's a global variable, breaks encapsulation, creates
> > > > interactions etc. CS-101 stuff.
> > >
> > > ok, i've removed the patch - Paul, would you mind to re-send
> > > your original flag solution, with it marked __read_mostly and
> > > with the extern declarations put into a suitable header file?
> > >
> > > Paul, incidentally, this very minute i tracked down that the
> > > patch is also causing boot lockups in -tip testing. I havent yet
> > > fully debugged it, but a question comes immediately: if there's
> > > no grace periods during bootup, wont rcu_sync() & friends just
> > > hang indefinitely?
> >
> > Ouch!!!  Indeed they would.
> >
> > > More thought is needed.
> >
> > One fix would be to sprinkle calls to rcu_qsctr_inc() through the
> > boot process.  But a much better approach would be for me to make
> > synchronize_rcu() check this same flag, and simply return if called
> > during early boot.  The rationale for this is that there is but a single
> > CPU during early boot, so tinyrcu.c's optimization can be used.  ;-)
> 
> Well can you simply return if called if num_online_cpus() == 1, regardless
> of the state of boot?

Yep!

And that is indeed what I do in http://lkml.org/lkml/2009/2/23/305.

						Thanx, Paul

> > Out of both paranoia and self defense, I would check num_online_cpus()
> > in my proposed call into RCU.  ;-)
> >
> > Seem reasonable?  And does synchronize_sched() also need the UP-only
> > optimization?
> 
