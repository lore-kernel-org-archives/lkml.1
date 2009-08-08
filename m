Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZHHX4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZHHX4g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 19:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZHHX4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 19:56:35 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45325 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbZHHX4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 19:56:35 -0400
Date: Sat, 8 Aug 2009 16:56:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PREEMPT_RCU in next/mmotm
Message-ID: <20090808235634.GB6866@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Pine.LNX.4.64.0908081956580.12300@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908081956580.12300@sister.anvils>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 08, 2009 at 08:34:03PM +0100, Hugh Dickins wrote:
> Hi Paul,
> 
> Is CONFIG_PREEMPT_RCU=y expected to be working in -next (or mmotm)?
> 
> I ask because it appears to break down on PowerPC G5 when I try two
> "make -j20" kernel builds in parallel.  The "filp" slab which usually
> contains a couple of thousand objects or so, jumps up to a couple of
> hundred thousand before the builds complete, and continues rising
> from then on - I think that's a sign of RCU in disgrace?
> And rebooting hangs thereafter.

That would indeed be bad.

> And I notice that include/linux/rcupreempt.h currently says:
> static inline void synchronize_rcu_expedited(void)
> {
> 	synchronize_rcu();  /* Placeholder for new rcupreempt implementation. */
> }
> which gives an impression of work in progress?

Yep, but I would be surprised if this was causing your problem.  In fact,
I would be surprised if this function was being invoked.  Then again,
I have been surprised more than once.

For whatever it is worth, with luck, include/linux/rcupreempt.h disappears
entirely at some point.

> CONFIG_PREEMPT_TREE=y seems okay on PowerPC; and when I briefly tried

CONFIG_TREE_RCU=y, you mean, right?

> CONFIG_PREEMPT_RCU=y on x86_64, it didn't show above symptoms there.

Interesting...

> I did try bisecting yesterday's linux-next git, but that led me to
> 
> commit 8ca17c6082feee5841a7b0e91d00e18c3f85f063
> Merge: dafcc6e... 7256cf0...
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Mon Aug 3 15:50:37 2009 +0200
> 
>     Merge branch 'core/rcu' into auto-sched-next
> 
> rather than to any particular patch of yours which that merges:
> which seemed odd, but I'm not accustomed to bisecting next.

I honestly don't know how "git bisect" interacts with merges.

> Another odd thing is that mmotm .DATE=2009-07-30-05-01, the last
> I tried before Thursday's, showed no such symptoms: yet appears to
> contain all the larger RCU changes, just lacking some more recent
> on/offline race fixes.  I didn't notice any likely difference
> between those mmotm trees down in arch/powerpc either.
> 
> My guess is that there's some other issue which is triggering
> the RCU disgrace, but that is just a guess.

The one other issue I know of is one that apparently happens only on
one of Ingo's machines, which suddenly decides that it need not inform
RCU when onlining a CPU (at boot time).

But you seem to be making it past boot, and I would guess that you are
not doing any hotplug CPU operations, right?

> Config attached.  Any suggestions?

/me scratches head...  Will try some more CONFIG_PREEMPT_RCU testing
locally.

							Thanx, Paul
