Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZKSTvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZKSTvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 14:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbZKSTvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 14:51:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49493 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbZKSTvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 14:51:02 -0500
Date: Thu, 19 Nov 2009 20:50:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Guenther <richard.guenther@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
Message-ID: <20091119195015.GA25185@elte.hu>
References: <20091119072040.GA23579@elte.hu>
 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
 <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>
 <1258653562.22249.682.camel@gandalf.stny.rr.com>
 <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>
 <alpine.LFD.2.00.0911191026420.2793@localhost.localdomain>
 <20091119184716.GA25458@elte.hu>
 <1258657614.22249.824.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258657614.22249.824.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2009-11-19 at 19:47 +0100, Ingo Molnar wrote:
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > Admittedly, anybody who compiles with -pg probably doesn't care deeply 
> > > about smaller and more efficient code, since the mcount call overhead 
> > > tends to make the thing moot anyway, but it really looks like a 
> > > win-win situation to just fix the mcount call sequence regardless.
> > 
> > Just a sidenote: due to dyn-ftrace, which patches out all mcounts during 
> > bootup to be NOPs (and opt-in patches them in again if someone runs the 
> > function tracer), the cost is not as large as one would have it with say 
> > -pg based user-space profiling.
> > 
> > It's not completely zero-cost as the pure NOPs balloon the i$ footprint 
> > a bit and GCC generates different code too in some cases. But it's 
> > certainly good enough that it's generally pretty hard to prove overhead 
> > via micro or macro benchmarks that the patched out mcounts call sites 
> > are there.
> 
> And frame pointers do add a little overhead as well. Too bad the mcount
> ABI wasn't something like this:
> 
> 
> 	<function>:
> 		call	mcount
> 		[...]
> 
> This way, the function address for mcount would have been (%esp) and 
> the parent address would be 4(%esp). Mcount would work without frame 
> pointers and this whole mess would also become moot.

In that case we could also fix up static callsites to this address as 
well (to jump +5 bytes into the function) and avoid the NOP as well in 
most cases. (That would in essence merge any slow-path function epilogue 
with the mcount cal instruction in terms of I$ footprint - i.e. it would 
be an even lower overhead feature.)

If only the kernel had its own compiler.

	Ingo
