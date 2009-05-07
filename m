Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbZEGWPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbZEGWPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZEGWPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:15:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48089 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZEGWPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:15:04 -0400
Date: Fri, 8 May 2009 00:14:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adam Langley <agl@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, markus@google.com
Subject: Re: [RFC 1/1] seccomp: Add bitmask of allowed system calls.
Message-ID: <20090507221447.GE28770@elte.hu>
References: <396556a20805301217k293e5718h6bbf02b234897235@europa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <396556a20805301217k293e5718h6bbf02b234897235@europa>
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


(i've restored the Cc: line of the previous thread)

* Adam Langley <agl@google.com> wrote:

> (This is a discussion email rather than a patch which I'm 
> seriously proposing be landed.)
> 
> In a recent thread[1] my colleague, Markus, mentioned that we 
> (Chrome Linux) are investigating using seccomp to implement our 
> rendering sandbox[2] on Linux.
> 
> In the same thread, Ingo mentioned[3] that he thought a bitmap of 
> allowed system calls would be reasonable. If we had such a thing, 
> many of the acrobatics that we currently need could be avoided. 
> Since we need to support the currently existing kernels, we'll 
> need to have the code for both, but allowing signal handling, 
> gettimeofday, epoll etc would save a lot of overhead for common 
> operations.
> 
> The patch below implements such a scheme. It's written on top of 
> the current seccomp for the moment, although it looks like seccomp 
> might be written in terms of ftrace soon[4].
> 
> Briefly, it adds a second seccomp mode (2) where one uploads a 
> bitmask. Syscall n is allowed if, and only if, bit n is true in 
> the bitmask. If n is beyond the range of the bitmask, the syscall 
> is denied.
> 
> If prctl is allowed by the bitmask, then a process may switch to 
> mode 1, or may set a new bitmask iff the new bitmask is a subset 
> of the current one. (Possibly moving to mode 1 should only be 
> allowed if read, write, sigreturn, exit are in the currently 
> allowed set.)
> 
> If a process forks/clones, the child inherits the seccomp state of 
> the parent. (And hopefully I'm managing the memory correctly 
> here.)
> 
> Ingo subsequently floated the idea of a more expressive interface 
> based on ftrace which could introspect the arguments, although I 
> think the discussion had fallen off list at that point.
> 
> He suggested using an ftrace parser which I'm not familiar with, but can
> be summed up with:
>   seccomp_prctl("sys_write", "fd == 3")  // allow writes only to fd 3

It's the ftrace filter parser and execution engine.

I.e. we first parse the filter expression when setting up a seccomp 
context. Each syscall has the following attributes:

 on                # enabled unconditionally
 off               # disabled unconditionally
 filtered

In the filtered case, the filter can be simple:

	"fd == 0"

To restrict sys_write() to a single fd (but still allow sys_read() 
from other fds).

Or as complex as:

	(fd == 4 || fd == 5) && (buf == 0x12340000) && (size <= 4096)

To restrict IO to two specific fds and to restrict output to a 
specific memory address and to restrict size to 4K or smaller.

This is how the filter engine works: we parse the string and save it 
into a binay expression structure (cache) that can later on be run 
by the engine in a pretty fast way. (without any string parsing or 
formatting overhead in the validation fastpath)

The filter is thus evaluated in the sandbox task's context, without 
the need for any context-switching. It's very, very fast. It is i 
think faster than LSM rules, and it is also atomic and lockless (RCU 
based).

> In general, I believe that ftrace based solutions cannot safely 
> validate arguments which are in user-space memory when multiple 
> threads could be racing to change the memory between ftrace and 
> the eventual copy_from_user. Because of this, many useful 
> arguments (such as the sockaddr to connect, the filename to open 
> etc) are out of reach. LSM hooks appear to be the best way to 
> impose limits in such cases. (Which we are also experimenting 
> with).

That assessment is incorrect, there's no difference between safety 
here really.

LSM cannot magically inspect user-space memory either when multiple 
threads may access it. The point would be to define filters for 
system call _arguments_, which are inherently thread-local and safe.

> However, such a parser could be very useful in one particular 
> case: socketcall on IA32. Allowing recvmsg and sendmsg, but not 
> socket, connect etc is certainly something that we would be 
> interested in.

There are two problems with the bitmap scheme, which i also 
suggested in a previous thread but then found it to be lacking:

1) enumeration: you define a bitmap. That will be problematic 
   between compat and native 64-bit (both have different syscall 
   vectors).

2) flexibility. It's an on/off selection per syscall. With the 
   filter we have on, off, or filtered. That's a _whole_ lot more 
   flexible.

The filter expression based solution does not suffer from this: it 
is string enumerated. "sys_read" means that syscall, and we could 
specify whether it's the compat or the native one.

	Ingo
