Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbZEHCWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbZEHCWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 22:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZEHCWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:22:39 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:47347 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbZEHCWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:22:39 -0400
X-Greylist: delayed 1417 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 May 2009 22:22:39 EDT
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
Date: Fri, 8 May 2009 01:59:03 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <gu03l7$tb8$1@taverner.cs.berkeley.edu>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com> <20090506212913.GC4861@elte.hu> <904b25810905061446m73c42040nfff47c9b8950bcfa@mail.gmail.com> <20090507073121.2FAADFC39E@magilla.sf.frob.com>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1241747943 30056 128.32.168.222 (8 May 2009 01:59:03 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Fri, 8 May 2009 01:59:03 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath  wrote:
>> Ptrace has performance and/or reliability problems when used to
>> sandbox threaded applications due to potential race conditions when
>> inspecting system call arguments. We hope that we can avoid this
>> problem with seccomp.
>
>ptrace certainly has performance issues.  I take it the only "reliability
>problems" you are talking about are MT races with modifications to user
>memory that is relevant to a system call.  (Is there something else?)

As of 1999, I believe there were some other issues for using ptrace
securely:

1. I do not know of a good way to reliably ensure that all children of
a traced program will be traced as well.  If you wait for the fork()
call to return, check the pid, and start tracing the child process,
you are subject to race conditions.  (strace's solution is to modify
the code of the traced program to put a trapping instruction immediately
after the call site to fork().  This is a grody hack and I had a hard
time convincing myself that this will be secure in all cases.)

2. ptrace disrupts the process hierarchy and Unix signals.  Because of
the way ptrace overloads signals to deliver tracing events, tracing is
not transparent.  For instance, if the parent and child are both traced,
and the parent waits for a signal from the child, things may no longer
work the same way while being traced.  Working around this requires
non-trivial code.  Complexity is the enemy of security and makes it hard
to gain confidence this doesn't introduce subtle issues.

3. If the tracing application should happen to die unexpectedly
(OOM, anyone?), I believe the traced application continues running,
now without any security checks.

4. I seem to recall that when I looked at this in 1999, if the traced
app makes a syscall that should not be allowed, I couldn't find a good
way to prevent that syscall from executing.  I don't know if current
ptrace has solved this problem.

Disclaimer: I haven't checked whether these all still apply today.
