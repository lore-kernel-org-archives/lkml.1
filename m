Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab0BAJn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 04:43:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:35160 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab0BAJnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 04:43:25 -0500
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
 switch at runqueue lock/unlock
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
In-Reply-To: <20100201073341.GH9085@laptop>
References: <20100131205254.407214951@polymtl.ca>
	 <20100131210013.446503342@polymtl.ca>  <20100201073341.GH9085@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 10:42:30 +0100
Message-ID: <1265017350.24455.122.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 18:33 +1100, Nick Piggin wrote:
> > Adds no overhead on x86, because LOCK-prefixed atomic operations of the spin
> > lock/unlock already imply a full memory barrier. Combines the spin lock
> > acquire/release barriers with the full memory barrier to diminish the
> > performance impact on other architectures. (per-architecture spinlock-mb.h
> > should be gradually implemented to replace the generic version)
> 
> It does add overhead on x86, as well as most other architectures.
> 
> This really seems like the wrong optimisation to make, especially
> given that there's not likely to be much using librcu yet, right?
> 
> I'd go with the simpler and safer version of sys_membarrier that does
> not do tricky synchronisation or add overhead to the ctxsw fastpath.
> Then if you see some actual improvement in a real program using librcu
> one day we can discuss making it faster.
> 
> As it is right now, the change will definitely slow down everybody
> not using librcu (ie. nearly everything). 

Right, so the problem with the 'slow'/'safe' version is that it takes
rq->lock for all relevant rqs. This renders while (1) sys_membarrier()
in a quite effective DoS.

Now, I'm not quite charmed by all this. Esp. this patch seems wrong. The
fact is on x86 we have all the required membarriers in place.

There's a number of LOCK ins before we set rq->curr and we have them
after. Adding more, like this patch effectively does
(smp_mb__{before,after}_unlock should be a full mb as Nick pointed out)
doesn't seem like a good idea at all.

And then there's !x86 to consider.

