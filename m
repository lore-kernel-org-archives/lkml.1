Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbZEGHlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbZEGHlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 03:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbZEGHkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 03:40:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254AbZEGHkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 03:40:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: <markus@google.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-mips@linux-mips.org, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
In-Reply-To: Markus Gutschke's message of  Wednesday, 6 May 2009 14:46:02 -0700 <904b25810905061446m73c42040nfff47c9b8950bcfa@mail.gmail.com>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com>
	<20090228030413.5B915FC3DA@magilla.sf.frob.com>
	<alpine.LFD.2.00.0902271932520.3111@localhost.localdomain>
	<alpine.LFD.2.00.0902271948570.3111@localhost.localdomain>
	<20090228072554.CFEA6FC3DA@magilla.sf.frob.com>
	<alpine.LFD.2.00.0902280916470.3111@localhost.localdomain>
	<904b25810905061146ged374f2se0afd24e9e3c1f06@mail.gmail.com>
	<20090506212913.GC4861@elte.hu>
	<904b25810905061446m73c42040nfff47c9b8950bcfa@mail.gmail.com>
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090507073121.2FAADFC39E@magilla.sf.frob.com>
Date: Thu,  7 May 2009 00:31:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ptrace has performance and/or reliability problems when used to
> sandbox threaded applications due to potential race conditions when
> inspecting system call arguments. We hope that we can avoid this
> problem with seccomp.

ptrace certainly has performance issues.  I take it the only "reliability
problems" you are talking about are MT races with modifications to user
memory that is relevant to a system call.  (Is there something else?)
That is not a "ptrace problem" per se at all.  It's an intrinsic problem
with any method based on "generic" syscall interception, if the filtering
and enforcement decisions depend on examining user memory.  By the same
token, no such method has a "reliability problem" if the filtering checks
only examine the registers (or other thread-synchronous state).

In the sense that I mean, seccomp is "generic syscall interception" too.
(That is, the checks/enforcement are "around" the call, rather than inside
it with direct atomicity controls binding the checks and uses together.)
The only reason seccomp does not have this "reliability problem" is that
its filtering is trivial and depends only on registers (in fact, only on
one register, the syscall number).

If you want to do checks that depend on shared or volatile state, then
syscall interception is really not the proper mechanism for you.  (Likely
examples include user memory, e.g. for file names in open calls, or ioctl
struct contents, etc., fd tables or filesystem details, etc.)  For that
you need mechanisms that look at stable kernel copies of user data that
are what the syscall will actually use, such as is done by audit, LSM, etc.

If you only have checks confined to thread-synchronous state such as the
user registers, then you don't have any "reliability problem" regardless
of the the particular syscall interception mechanism you use.  (ptrace has
many problems for this or any other purpose, but this is not one of them.)
That's unless you are referring to some other "reliability problem" that
I'm not aware of.  (And I'll leave aside the "is it registers or is it
user memory?" issue on ia64 as irrelevant, since, you know, it's ia64.)

If syscall interception is indeed an appropriate mechanism for your needs
and you want something tailored more specifically to your exact use in
future kernels, a module doing this would be easy to implement using the
utrace API.  (That might be a "compelling use" of utrace by virtue of the
Midas brand name effect, if nothing else. ;-)


Thanks,
Roland
