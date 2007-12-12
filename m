Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbXLLLES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbXLLLES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759478AbXLLLD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:03:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37523 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758493AbXLLLD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:03:57 -0500
Date: Wed, 12 Dec 2007 12:03:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, markus.t.metzger@gmail.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: x86, ptrace: support for branch trace store(BTS)
Message-ID: <20071212110330.GD1611@elte.hu>
References: <20071210123809.A14251@sedona.ch.intel.com> <20071210202052.GA26002@elte.hu> <029E5BE7F699594398CA44E3DDF5544401130A1E@swsmsx413.ger.corp.intel.com> <20071211145301.GA19427@elte.hu> <029E5BE7F699594398CA44E3DDF554440115D3C5@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029E5BE7F699594398CA44E3DDF554440115D3C5@swsmsx413.ger.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> Andi suggested to make this a sysctl.

that's just as arbitrary ...

> Would it be safe to drop the artificial limit and let the limit be the 
> available memory?

no, that would be a DoS :-/

mlock() is rlimit controlled and is available to unprivileged users - up 
to a small amount of memory can be locked down. But i agree that mlock() 
can be problematic - see below.

> > There's also no real mechanism that i can see to create a guaranteed 
> > flow of this information between the debugger and debuggee (unless i 
> > missed something), the code appears to overflow the array, and 
> > destroy earlier entries, right? That's "by design" for debugging, 
> > but quite a limitation for instrumentation which might want to have 
> > a reliable stream of the data (and would like the originating task 
> > to block until the debugger had an opportunity to siphoon out the 
> > data).
> 
> That's correct as well. My focus is on debugging. And that's actually 
> the most useful behavior in that case. I'm not sure what you mean with 
> 'instrumentation'.

the branch trace can be used to generate a very finegrained 
profile/histogram of code execution - even of rarely executed codepaths 
which cannot be captured via timer/perf-counter based profiling.

another potential use would be for call graph coverage testing. (which 
currently requires compiler-inserted calls - would be much nicer if we 
could do this via the hardware.)

etc. Branch tracing isnt just for debugging i think - as long as the 
framework is flexible enough.

> The actual physical memory consumption will be worse (or at best 
> equal) compared to kalloc()ed memory, since we need to pin down entire 
> pages, whereas kalloc() would allocate just the memory that is 
> actually needed.

i agree that mlock() has problems. A different model would be: no mlock 
and no get_user_pages() - something quite close to what you have 
already. Data is streamed out of the internal (hardware-filled, 
kmalloc()-ed, user-inaccessible) buffer, we stop task execution until it 
is copied to the larger, user-provided buffer. The debugging feature you 
are interested in could be enabled as a special-case of this mechanism: 
if the user-space buffer is not larger than the hardware buffer then no 
streaming is needed, you can just capture into the kernel buffer. 
User-space would have to do a PTRACE_BTS_DRAIN_BUFFER call (or something 
like that) to get the "final portion" of the branch trace out into the 
user-space buffer. [which, in your debugging special-case, would the 
full internal buffer.]

that way the kmalloc()-ed buffer becomes an internal detail of buffering 
that you rarely have to be aware of. (it could still be queried - like 
your patch does it now.)

or something else that is intelligent. Basically, what we'd like to have 
is a future-proof, extensible approach that does not necessarily stop at 
debugging and integrates this hardware capability into Linux 
intelligently.

	Ingo
