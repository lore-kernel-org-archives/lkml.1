Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab0CFTpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 14:45:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643Ab0CFTpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 14:45:13 -0500
Date: Sat, 6 Mar 2010 11:43:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Chris Friesen <cfriesen@nortel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip] introduce sys_membarrier(): process-wide memory
 barrier (v9)
In-Reply-To: <20100304202304.GA13718@elte.hu>
Message-ID: <alpine.LFD.2.00.1003061135160.31447@localhost.localdomain>
References: <20100225232316.GA30196@Krystal> <20100304122304.GA6864@elte.hu> <alpine.LFD.2.00.1003040827100.7046@localhost.localdomain> <20100304202304.GA13718@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Ingo Molnar wrote:
> 
> Perhaps NOFPU could do lazy context saving: clear the TS flag and only save 
> the FPU state if it's actually used by the signal handler?

If we can get that working reliably, we probably shouldn't use NOFPU at 
all, and we should just do it unconditionally. That big (and almost always 
pointless) FPU state save is a _big_ performance issue on signal handling, 
and if we can do it lazily, we should.

However, I'm not at all convinced we can do this reliably. How do we 
detect the "signal frame is dead" case with things like siglongjmp() etc?

And if we can't detect that "frame no longer exists", we can't really do 
the lazy context saving.

Now, there's _also_ the issue of the signal handler function possibly 
actually looking at the FPU state on the stack, and for that, a SA_NOFPU 
would be a good way to say "you can't do that". So it's possible that even 
if we could reliably detect the frame liveness we'd really have to use 
that new flag anyway.

But if we do need a SA_NOFPU flag, then that means that basically no app 
will use it, and it will be some special case for some really unusual 
library. So I really don't think this whole thing is worth it unless you 
could do it automatically.

(The "user accesses the frame" case _could_ possibly be handled by 
pointing the FP frame to a special faulting location, and never nesting 
the FP optimization. Nested signal handlers are unusual enough that they 
aren't worth optimizing for anyway. So I'm sure that there are possible 
solutions for "automatically just do the right thing" in theory, but I 
suspect they get rather complex)

		Linus
