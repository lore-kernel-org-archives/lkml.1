Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbZBWUMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbZBWUMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZBWUMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:12:40 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49755 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbZBWUMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:12:39 -0500
Date: Mon, 23 Feb 2009 12:12:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: nickpiggin@yahoo.com.au, vegard.nossum@gmail.com, mingo@elte.hu,
       stable@kernel.org, npiggin@suse.de, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090223201236.GS6751@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220140157.GA12799@elte.hu> <20090222030030.GD6860@linux.vnet.ibm.com> <20090223051709.GA5990@linux.vnet.ibm.com> <200902240029.37815.nickpiggin@yahoo.com.au> <20090223161726.GD6751@linux.vnet.ibm.com> <20090223111009.d48ff81d.akpm@linux-foundation.org> <20090223193057.GL6751@linux.vnet.ibm.com> <20090223115926.ed03e954.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223115926.ed03e954.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 11:59:26AM -0800, Andrew Morton wrote:
> On Mon, 23 Feb 2009 11:30:57 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Mon, Feb 23, 2009 at 11:10:09AM -0800, Andrew Morton wrote:
> > > On Mon, 23 Feb 2009 08:17:26 -0800 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > On Tue, Feb 24, 2009 at 12:29:36AM +1100, Nick Piggin wrote:
> > > > > On Monday 23 February 2009 16:17:09 Paul E. McKenney wrote:
> > > > > 
> > > > > > The boot CPU runs in the context of its idle thread during boot-up.
> > > > > > During this time, idle_cpu(0) will always return nonzero, which will
> > > > > > fool Classic and Hierarchical RCU into deciding that a large chunk of
> > > > > > the boot-up sequence is a big long quiescent state.  This in turn causes
> > > > > > RCU to prematurely end grace periods during this time.
> > > > > >
> > > > > > This patch creates a new global variable that is set to 1 just before
> > > > > > the boot CPU first enters the scheduler, after which the idle task
> > > > > > really is idle.
> > > > > 
> > > > > Nice work all (btw. if this patch goes in rather than using system_state,
> > > > > then please make the variable __read_mostly).
> > > > 
> > > > Hmmm...  I misread this and made system_state be __read_mostly.  Let
> > > > me know if this is bad, easy to fix if needed.
> > > 
> > > Please don't use system_state.  The whole thing is just bad design. 
> > > It's a global variable, breaks encapsulation, creates interactions etc.
> > > CS-101 stuff.
> > 
> > OK.  Would it help if I wrapped an accessor function around system_state?
> 
> That doesn't help the core problem: system_state creates interactions
> between unrelated subsystems.  And the number of interactions grows
> exponentially with the number of subsystems which use system_state.
> 
> > I do need some sort of global state if I am to solve this problem.  ;-)
> 
> As I suggested before, please add a new state variable which is private
> to your subsystem.  That way it remains isolated from other subsystems.

OK, so my thought would be to have a function call into RCU from either
init_post() or from rest_init().  This function would then set a variable
private to RCU.

Seem reasonable?

							Thanx, Paul
