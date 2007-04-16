Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbXDPHqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbXDPHqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 03:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932409AbXDPHqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 03:46:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46150 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932398AbXDPHqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 03:46:50 -0400
Date: Mon, 16 Apr 2007 09:46:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Wagner <daw-usenet@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 00/41] AppArmor security module overview
Message-ID: <20070416074612.GB2146@elf.ucw.cz>
References: <20070412090809.917795000@suse.de> <20070412135028.GE5881@ucw.cz> <evm7eh$h12$1@taverner.cs.berkeley.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <evm7eh$h12$1@taverner.cs.berkeley.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >You can do the same with ptrace. If that's not fast enough... improve
> >ptrace?
> 
> I did my Master's thesis on a system called Janus that tried using ptrace
> for this goal.  The bottom line is that ptrace sucks for this purpose.
> It is a kludge.  It is not the right approach.  I do not know of any
> satisfactory way to improve ptrace for this purpose; you have to throw
> away ptrace and start over.
> 
> At the time I did the work, ptrace has all sorts of serious problems.
> Here are some of them.  There was no way to follow fork securely.

Actually there is now. I did something similar called subterfugue and
we solved this one.

> There was no way to deny a single system call without killing the process
> entirely.  Performance was poor, because ptrace context-switches on
> every
> read() and write().

You can't deny a system call, but you can turn it into getpid(), then
fake the return value. You probably could invent ptrace extensions,
like solaris did, to avoid context switches.

>  Handling of signals is a mess: ptrace overloads the
> signal mechanism to deliver its events, which in retrospect was a lousy
> design decision it makes the tracer complex and error-prone and makes
> it hard to maintain the transparency of tracing.  ptrace breaks wait(),
> and consequently handling wait() and other signal-related system calls
> transparently and securely is ugly at best

We got this solved in linux, I believe.

> .  Handling signals is probably
> feasible but a total mess, and that's the last thing you want in the
> security-critical part of your system.  In addition, ptrace operates
> at the wrong level of abstraction and forces the user-level tracer to
> maintain a lot of shadow state that must be kept in sync with state held
> by the kernel.  That's an opportunity for security holes.  Also, ptrace
> has no way to force the tracee to die if the tracer unexpectedly dies,
> which is risky when using ptrace for security confinement.  

I think we actually have a flag for "kill this if tracer dies"... or
we could add it.

> I haven't
> checked whether these problems are still present in the current
> implementation of ptrace, but I'd guess that many probably still are,
> because many are fundamental consequences of how ptrace works.
> 
> Before advocating ptrace for this purpose, I encourage you to study some
> of the relevant literature.  Start with Chapter 4 of my Master's
> thesis.

I'm not advocating it. I've done this before, see subterfugue.org. It
was a ugly hack, mostly because it was filename based. Unfortunately
AA is also filename-based.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
