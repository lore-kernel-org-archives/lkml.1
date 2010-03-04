Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0CDQhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:37:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755922Ab0CDQhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:37:36 -0500
Date: Thu, 4 Mar 2010 08:34:16 -0800 (PST)
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
In-Reply-To: <20100304122304.GA6864@elte.hu>
Message-ID: <alpine.LFD.2.00.1003040827100.7046@localhost.localdomain>
References: <20100225232316.GA30196@Krystal> <20100304122304.GA6864@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Ingo Molnar wrote:
> 
>  - SA_NOFPU: on x86 to skip the FPU/SSE save/restore, for such fast in/out special 
>    purpose signal handlers? (can whip up a quick patch for you if you want)

I'd love to do this, but it's wrong.

It's too damn easy to use the FPU by mistake in user land, without ever 
being aware of it. memset()/memcpy are obvious potential users SSE, but 
they might be called in non-obvious ways implicitly by the compiler (ie 
structure copy and setup).

And modern glibc ends up using SSE4 even for things like strstr and 
strlen, so it really is creeping into all kinds of trivial helper 
functions that might not be obvious. So SA_NOFPU is a lovely idea, but 
it's also an idea that sucks rotten eggs in practice, with quite possibly 
the same _binary_ working or not working depending on what kind of CPU and 
what shared library it happens to be using.

Too damn fragile, in other words.

(Now, if it's accompanied by the kernel actually _testing_ that there is 
no FPU activity, by setting the TS flag and checking at fault time and 
causing a SIGFPE, then that would be better. At least you'd get a nice 
clear signal rather than random FPU state corruption. But you're still in 
the situation that now the binary might work on some machines and setups, 
and not on others.

>  - SA_RUNNING: a way to signal only running threads - as a way for user-space 
>    based concurrency control mechanisms to deschedule running threads (or, like
>    in your case, to implement barrier / garbage collection schemes).

Hmm. This sounds less fundamentally broken, but at the same time also 
_way_ more invasive in the signal handling layer. It's already one of our 
more "exciting" layers out there.

		Linus
