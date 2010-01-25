Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925Ab0AYVmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0AYVmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869Ab0AYVml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:42:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595Ab0AYVmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:42:39 -0500
Date: Mon, 25 Jan 2010 13:41:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tom Tromey <tromey@redhat.com>
cc: Kyle Moffett <kyle@moffetthome.net>, "Frank Ch. Eigler" <fche@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>,
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
In-Reply-To: <m33a1tnbd9.fsf@fleche.redhat.com>
Message-ID: <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
References: <20100121013822.28781960.sfr@canb.auug.org.au> <20100122005147.GD22003@redhat.com> <20100121170541.7425ff10.akpm@linux-foundation.org> <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> <20100122182827.GA13185@redhat.com>
 <20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Jan 2010, Tom Tromey wrote:
> 
> There are definitely things we would like from such an API.  Here's a
> few I can think of immediately, there are probably others.
> 
> * Use an fd, not SIGCHLD+wait, to report inferior state changes to gdb.
>   Internally we're already using a self-pipe to integrate this into
>   gdb's main loop.  Relatedly, don't mess with the inferior's parentage.

As I kind of alluded to elsewhere, I heartily agree with this. The really 
major design mistake of ptrace (as opposed to just various ugly corners) 
is how it has no connection information, and that ends up being one of the 
main reasons why you can't have two ptracers working on the same thing.

(There are other things that complicate that too, of course, like simply 
just trying to manage various per-thread state like debug registers etc, 
but that's a separate class of complications).

> * Support "displaced stepping" in the kernel; I think this would improve
>   performance when debugging in non-stop mode.

Don't we already do that at least on x86? Just doing a single-step should 
work on an instruction even if it has a breakpoint on it, because we set 
the TF bit.

Or maybe I'm not understanding what displaced stepping means to you.

> * Support some kind of breakpoint expression in the kernel; this would
>   improve performance of conditional breakpoints.  Perhaps the existing
>   gdb agent expressions could be used.

I suspect it might be reasonable to do simple expressions on breakpoints, 
but not the kind of things gdb exports to users. IOW, maybe you could have 
a single conditional on a single value (register or memory) associated 
with an expression.

Regardless, internally to the kernel your two later issues are "details". 
The "how to connect to the debuggee" is a much more fundamental issue, and 
has the biggest design/interface impact. The other would likely just be 
new ptrace command extensions that somebody would have to just implement 
the grotty details on.

		Linus
