Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850Ab0AWLYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab0AWLYL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 06:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701Ab0AWLYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 06:24:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44706 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612Ab0AWLYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 06:24:08 -0500
Date: Sat, 23 Jan 2010 12:23:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100123112333.GA15455@elte.hu>
References: <20100122005147.GD22003@redhat.com>
 <20100121170541.7425ff10.akpm@linux-foundation.org>
 <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>
 <20100122182827.GA13185@redhat.com>
 <20100122200129.GG22003@redhat.com>
 <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
 <20100122221348.GA4263@redhat.com>
 <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
 <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kyle Moffett <kyle@moffetthome.net> wrote:

> On Fri, Jan 22, 2010 at 19:22, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > There are cases where we really _want_ to have common code. We want to
> > have a common VFS interface because we want to show _one_ interface to
> > user space across a gazillion different filesystems. We want to have a
> > common driver layer (as far as possible) because - again - we expose a
> > metric shitload of drivers, and we want to have one unified interface to
> > them.
> 
> So... Everybody agrees that ptrace() is horrible and a royal pain to use, 
> let alone use correctly and without bugs.  Everybody also agrees that 
> ptrace() needs to stay around for a long time to avoid breaking all the 
> existing users.
> 
> Now how do we get from here to a moderately portable API for interrogating, 
> controlling, and intercepting process state? Essentially it would need to 
> support all of the things that a powerful debugger would want to do, 
> including modifying registers and memory, substituting syscall return 
> values, etc.  I believe that "utrace" is the kernel side of that API.

The problem is, utrace does not do that really.

What utrace does is that it provides an opaque set of APIs for unspecified and 
out of tree _kernel_ modules (such as systemtap). It doesnt support any 
'application' per se. It basically removes the kernel's freedom at shaping its 
own interaction with debug application.

If utrace was a 'better ptrace' syscall, where the syscall itself is the goal 
of the hookery, it would all be rather different. People could argue about 
_that_ interface (and the hooks would be a pure kernel internal 
implementational detail - not an interface specification), and once people 
agree about that ABI and there's enough application momentum behind it, the 
hooks are really not that opaque anymore - they are for that ABI and not more.

Note that it's still a _big_ hurdle: it's hard to agree on a new syscall and 
it's hard to get 'application momentum' behind it. Special Linux system calls 
have a checkered past, they tend to not be used by much anything, and thus 
they tend to be a breeding ground of both bugs, maintenance complexity and 
security problems. Lack of attention is never good.

In that sense it might be better to fix/enhance ptrace, if there's interest. 
I've written a handful of ptrace extensions in the past (none of them went 
upstream tho), it can be done in a useful manner and the code is pretty 
hackable. There are basic problems left to be solved: for example why is there 
still no 'memory block copy' call, why are we _still_ limited to one word per 
system call PTRACE_PEEK* memory copies? It's ridiculous. SparcLinux has 
PTRACE_WRITE*/READ* support that implements this, but none of the other 
architectures have it so it's essentially unused.

Or another possible direction would be to extend the perf events syscall with 
interception capabilities. It's far more performant at extracting application 
state without scheduling than any ptrace method - and interception/injection 
would be a natural next step - if there's interest.

Thanks,

	Ingo
