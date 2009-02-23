Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZBWTe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZBWTe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 14:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbZBWTeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 14:34:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39080 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbZBWTeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 14:34:18 -0500
Date: Mon, 23 Feb 2009 20:33:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090223193351.GA11921@elte.hu>
References: <20090220140157.GA12799@elte.hu> <20090222030030.GD6860@linux.vnet.ibm.com> <20090223051709.GA5990@linux.vnet.ibm.com> <200902240029.37815.nickpiggin@yahoo.com.au> <20090223161726.GD6751@linux.vnet.ibm.com> <20090223111009.d48ff81d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223111009.d48ff81d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 23 Feb 2009 08:17:26 -0800 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Tue, Feb 24, 2009 at 12:29:36AM +1100, Nick Piggin wrote:
> > > On Monday 23 February 2009 16:17:09 Paul E. McKenney wrote:
> > > 
> > > > The boot CPU runs in the context of its idle thread during boot-up.
> > > > During this time, idle_cpu(0) will always return nonzero, which will
> > > > fool Classic and Hierarchical RCU into deciding that a large chunk of
> > > > the boot-up sequence is a big long quiescent state.  This in turn causes
> > > > RCU to prematurely end grace periods during this time.
> > > >
> > > > This patch creates a new global variable that is set to 1 just before
> > > > the boot CPU first enters the scheduler, after which the idle task
> > > > really is idle.
> > > 
> > > Nice work all (btw. if this patch goes in rather than using system_state,
> > > then please make the variable __read_mostly).
> > 
> > Hmmm...  I misread this and made system_state be __read_mostly.  Let
> > me know if this is bad, easy to fix if needed.
> 
> Please don't use system_state.  The whole thing is just bad 
> design. It's a global variable, breaks encapsulation, creates 
> interactions etc. CS-101 stuff.

ok, i've removed the patch - Paul, would you mind to re-send 
your original flag solution, with it marked __read_mostly and 
with the extern declarations put into a suitable header file?

Paul, incidentally, this very minute i tracked down that the 
patch is also causing boot lockups in -tip testing. I havent yet 
fully debugged it, but a question comes immediately: if there's 
no grace periods during bootup, wont rcu_sync() & friends just 
hang indefinitely?

More thought is needed.

	Ingo
