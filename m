Return-Path: <linux-kernel-owner+w=401wt.eu-S1030776AbXDLVbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030776AbXDLVbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030780AbXDLVbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:31:41 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:49278 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030776AbXDLVbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:31:40 -0400
X-Greylist: delayed 764 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2007 17:31:40 EDT
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [AppArmor 00/41] AppArmor security module overview
Date: Thu, 12 Apr 2007 21:13:53 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <evm7eh$h12$1@taverner.cs.berkeley.edu>
References: <20070412090809.917795000@suse.de> <20070412135028.GE5881@ucw.cz>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1176412433 17442 128.32.168.222 (12 Apr 2007 21:13:53 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 12 Apr 2007 21:13:53 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek  wrote:
>You can do the same with ptrace. If that's not fast enough... improve
>ptrace?

I did my Master's thesis on a system called Janus that tried using ptrace
for this goal.  The bottom line is that ptrace sucks for this purpose.
It is a kludge.  It is not the right approach.  I do not know of any
satisfactory way to improve ptrace for this purpose; you have to throw
away ptrace and start over.

At the time I did the work, ptrace has all sorts of serious problems.
Here are some of them.  There was no way to follow fork securely.
There was no way to deny a single system call without killing the process
entirely.  Performance was poor, because ptrace context-switches on every
read() and write().  Handling of signals is a mess: ptrace overloads the
signal mechanism to deliver its events, which in retrospect was a lousy
design decision it makes the tracer complex and error-prone and makes
it hard to maintain the transparency of tracing.  ptrace breaks wait(),
and consequently handling wait() and other signal-related system calls
transparently and securely is ugly at best.  Handling signals is probably
feasible but a total mess, and that's the last thing you want in the
security-critical part of your system.  In addition, ptrace operates
at the wrong level of abstraction and forces the user-level tracer to
maintain a lot of shadow state that must be kept in sync with state held
by the kernel.  That's an opportunity for security holes.  Also, ptrace
has no way to force the tracee to die if the tracer unexpectedly dies,
which is risky when using ptrace for security confinement.  I haven't
checked whether these problems are still present in the current
implementation of ptrace, but I'd guess that many probably still are,
because many are fundamental consequences of how ptrace works.

Before advocating ptrace for this purpose, I encourage you to study some
of the relevant literature.  Start with Chapter 4 of my Master's thesis.
  http://www.cs.berkeley.edu/~daw/papers/janus-masters.ps
Then, read Tal Garfinkel's paper on system call interposition.
  http://www.stanford.edu/~talg/papers/traps/abstract.html
Then, read about Ostia.
  http://www.stanford.edu/~talg/papers/NDSS04/abstract.html
I think these may change your mind about the suitability of ptrace for
this task.
