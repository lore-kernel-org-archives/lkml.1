Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342Ab0AWGVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab0AWGVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 01:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827Ab0AWGVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 01:21:15 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:64110 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab0AWGVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 01:21:14 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
References: <20100121013822.28781960.sfr@canb.auug.org.au> 
	<20100122005147.GD22003@redhat.com> <20100121170541.7425ff10.akpm@linux-foundation.org> 
	<alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> 
	<20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com> 
	<alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> 
	<20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> 
	<alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sat, 23 Jan 2010 01:20:53 -0500
Message-ID: <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
Subject: Re: linux-next: add utrace tree
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 19:22, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> There are cases where we really _want_ to have common code. We want to
> have a common VFS interface because we want to show _one_ interface to
> user space across a gazillion different filesystems. We want to have a
> common driver layer (as far as possible) because - again - we expose a
> metric shitload of drivers, and we want to have one unified interface to
> them.

So... Everybody agrees that ptrace() is horrible and a royal pain to
use, let alone use correctly and without bugs.  Everybody also agrees
that ptrace() needs to stay around for a long time to avoid breaking
all the existing users.

Now how do we get from here to a moderately portable API for
interrogating, controlling, and intercepting process state?
Essentially it would need to support all of the things that a powerful
debugger would want to do, including modifying registers and memory,
substituting syscall return values, etc.  I believe that "utrace" is
the kernel side of that API.

The killer app for this will be the ability to delete thousands of
lines of code from GDB, strace, and all the various other tools that
have to painfully work around the major interface gotchas of ptrace(),
while at the same time making their handling of complex processes much
more robust.

The *second* killer app for this is to make it much easier for people
to write new userspace debugging tools.  I love the various
crash-catching tools that different distributions or applications
provide, but they all basically have to trap the SIGSEGV and hope
they're still sensible enough to fork() and exec() a gdb process.

Furthermore, I would love to be able to write debugging tools for
scripting languages that allow me to step across Perl, C, PHP,
assembly code, etc, all within the same process.  In theory that's all
possible today, but given how much of a *pain* ptrace() is to use
correctly, nobody bothers.

Now, with all that said, "utrace" does not provide any of the
userspace side APIs today... but I think it is a necessary refactoring
if we want to provide a new ideal process-introspection interface
without breaking all the ptrace() users.

Think of the "utrace" interface as very much like the LSM interface.
Just like with LSMs, there is a lot of active research in debugging
and tracing tools, and nobody can even remotely agree what the hell
they want out of the hooks.  In theory you could add one hook for
every place each security module needs one... but then your fast-path
is littered with always-false test-and-jump statements.  What "utrace"
provides is the one single test in each fast path that then searches
for and executes the appropriate slow path(s) for that process.

I personally would be very happy to see "utrace" merged.

Cheers,
Kyle Moffett
