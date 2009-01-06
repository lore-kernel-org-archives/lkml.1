Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZAFScz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZAFScz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZAFSce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:32:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51540
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754379AbZAFScc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:32:32 -0500
Date: Tue, 06 Jan 2009 10:32:34 -0800 (PST)
Message-Id: <20090106.103234.163615537.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org, srostedt@redhat.com,
       mingo@elte.hu, sparclinux@vger.kernel.org
Subject: Re: ftrace breaks sparc64 build
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.1.10.0901051458460.25066@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901051428370.27085@gandalf.stny.rr.com>
	<20090105195415.GA6204@uranus.ravnborg.org>
	<alpine.DEB.1.10.0901051458460.25066@gandalf.stny.rr.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 5 Jan 2009 15:05:11 -0500 (EST)

> Probably the same issue. The problem is that the first use of a variable 
> is in the OR section of an if statement that does a return.
> 
> 	if (x || !(y = init_me())
> 		return;
> 
> 	use_me(y);
> 
> IMHO I find this sloppy code. When reading the code it can cause reviewers 
> trouble, and wasted time, to see that y is indeed initialized. I'm 
> impressed that gcc was able to figure it out.

I'm pretty much in firm disagreement here.

This code is pretty clear.  The only way to get to use_me() is
by initializing 'y'.  It's very straightforward.

There are many conditionals in the kernel where this order
of evaluation and side effects is depended upon.  Some of them
just happen to warn now because of the branch tracer.

> Have you always been compiling with -Werror?

arch/sparc*/ builds with -Werror for 5+ years.

> The reason that gcc complains is because you have the
> "branch_tracer" on that converts 'if ()' into a macro (as you saw in
> your -E compile). This makes the if statement more complex, and goes
> beyond gcc's ability to know that the above 'y' is initialized
> properly. I would work on fixing this in the branch tracer, but
> honestly, I'm kind of glad that gcc barfs on it.  This will help us
> point out this kind of sloppy initializations (sorry if I'm
> offending anybody about calling it sloppy). I just believe that it
> makes the code a bit more obfuscated to initialize in an if
> statement, and a second part of a complex if statement at that!

Keep in mind all this code was fine and built warning free before the
if() obfuscation done by the branch tracer.  If I wrote the branch
tracer, I'd probably search for these kinds of excuses too :-)
