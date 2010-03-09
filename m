Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab0CIHA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 02:00:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab0CIHAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 02:00:23 -0500
Date: Tue, 9 Mar 2010 17:59:57 +1100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, Chris Friesen <cfriesen@nortel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip] introduce sys_membarrier(): process-wide memory
 barrier (v9)
Message-ID: <20100309065957.GY8653@laptop>
References: <20100225232316.GA30196@Krystal>
 <20100304122304.GA6864@elte.hu>
 <alpine.LFD.2.00.1003040827100.7046@localhost.localdomain>
 <20100304202304.GA13718@elte.hu>
 <alpine.LFD.2.00.1003061135160.31447@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003061135160.31447@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 11:43:26AM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 4 Mar 2010, Ingo Molnar wrote:
> > 
> > Perhaps NOFPU could do lazy context saving: clear the TS flag and only save 
> > the FPU state if it's actually used by the signal handler?
> 
> If we can get that working reliably, we probably shouldn't use NOFPU at 
> all, and we should just do it unconditionally. That big (and almost always 
> pointless) FPU state save is a _big_ performance issue on signal handling, 
> and if we can do it lazily, we should.
> 
> However, I'm not at all convinced we can do this reliably. How do we 
> detect the "signal frame is dead" case with things like siglongjmp() etc?
> 
> And if we can't detect that "frame no longer exists", we can't really do 
> the lazy context saving.
> 
> Now, there's _also_ the issue of the signal handler function possibly 
> actually looking at the FPU state on the stack, and for that, a SA_NOFPU 
> would be a good way to say "you can't do that". So it's possible that even 
> if we could reliably detect the frame liveness we'd really have to use 
> that new flag anyway.
> 
> But if we do need a SA_NOFPU flag, then that means that basically no app 
> will use it, and it will be some special case for some really unusual 
> library. So I really don't think this whole thing is worth it unless you 
> could do it automatically.

The library is librcu, which I suspect will become quite important for
parallel programming in future (maybe I hope for too much).

But maybe it's better to not merge _any_ librcu special case until
we see results from programs using it. More general speedups or features
(that also help librcu) is a different story.

