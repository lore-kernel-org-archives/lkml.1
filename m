Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614Ab0AXFGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab0AXFGB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 00:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328Ab0AXFF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 00:05:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749Ab0AXFFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 00:05:49 -0500
Date: Sat, 23 Jan 2010 21:04:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kyle Moffett <kyle@moffetthome.net>
cc: "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
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
In-Reply-To: <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
References: <20100121013822.28781960.sfr@canb.auug.org.au>  <20100122005147.GD22003@redhat.com> <20100121170541.7425ff10.akpm@linux-foundation.org>  <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>  <20100122182827.GA13185@redhat.com>
 <20100122200129.GG22003@redhat.com>  <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>  <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>  <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Jan 2010, Kyle Moffett wrote:
> 
> Now how do we get from here to a moderately portable API for
> interrogating, controlling, and intercepting process state?

Umm? ptrace?

It's not _pretty_, but it's a hell of a lot more portable than utrace is 
ever going to be. Yes, the details differ between OS's (and between 
architectures), but let's face it, things like register state probing is 
_never_ going to be portable across different architectures simply because 
the register state isn't the same.

> The killer app for this will be the ability to delete thousands of
> lines of code from GDB, strace, and all the various other tools that
> have to painfully work around the major interface gotchas of ptrace(),
> while at the same time making their handling of complex processes much
> more robust.

No. There is absolutely _no_ reason to believe that gdb et al would ever 
delete the ptrace interfaces anyway. 

That really is my point. Adding a new interface, when an old and crufty 
(but working) interface is inevitably going to be around anyway - and is 
inevitably always going to have portability issues - is STUPID.

Let's take strace, for example.

Yes, ptrace() is crufty, but have you actually looked at strace source 
code? The problem isn't really a crufty interface to read registers etc, 
the bigger problem for strace is that different architectures and OS's 
have different system call argument rules, different ways to read/write 
system call numbers yadda yadda yadda.

Take a look at strace sources some day. Moving away from ptrace on Linux 
(even if you decided that you don't care about old versions of the kernel 
that don't know anything else) would simplify ABSOLUTELY NOTHING.

Really. Quiet the reverse, I suspect. The Solaris and FreeBSD support uses 
ptrace too, afaik, so you' just be confusing the issue.

And the fact is, strace would still end up supporting ptrace anyway, just 
so that you could run it on old kernels.

So the whole "making a new utrace interface would simpligy things" is 
simply a total lie. The fact that ptrace is a bit of an odd interface IN 
NO WAY means that any other interface would end up being appreciably 
simpler.

It would just result in _more_ code in strace, and more confusion.

		Linus
