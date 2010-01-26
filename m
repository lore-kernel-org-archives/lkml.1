Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697Ab0AZSrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab0AZSrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 13:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713Ab0AZSrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 13:47:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513Ab0AZSrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 13:47:08 -0500
Date: Tue, 26 Jan 2010 10:46:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: tromey@redhat.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
In-Reply-To: <877hr4g49l.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.2.00.1001261038150.3574@localhost.localdomain>
References: <20100121013822.28781960.sfr@canb.auug.org.au> <20100122005147.GD22003@redhat.com> <20100121170541.7425ff10.akpm@linux-foundation.org> <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> <20100122182827.GA13185@redhat.com>
 <20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com> <877hr4g49l.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Jan 2010, Andi Kleen wrote:

> Tom Tromey <tromey@redhat.com> writes:
> 
> > * Use an fd, not SIGCHLD+wait, to report inferior state changes to gdb.
> >   Internally we're already using a self-pipe to integrate this into
> >   gdb's main loop.  Relatedly, don't mess with the inferior's parentage.
> 
> How would having a kernel based solution be better over your
> user space simulation?

Oh, the reason we should do something in the kernel is that you really 
can't do certain things with the ptrace() interface. 

For example, think about how Wine and UML use ptrace - and then realize 
that that makes it impossible to attach a debugger from the outside. 
That's a real deficiency in ptrace - much more so than the fact that there 
are some odd details (ie the whole "read/write a word at a time" is just a 
quirky detail in comparison - not a fundamental problem).

> BTW there's the new signalfd() system call that might do it
> (haven't checked if it works for SIGCHLD)

No, you miss the point.

The problem isn't that you want to turn signals into a file descriptor 
just because you like file descriptors.

The problem is that anything that is based on reparenting and signals is 
fundamentally a "one parent only" kind of interface. See?

So the reason I think using an fd is a good idea is _not_ because gdb 
already uses an fd internally, but because it gives you a "connection" 
between the debugger and debuggee that is not fundamentally limited to a 
single controller.

(It doesn't have to be a file descriptor, of course, but could be any kind 
of other model that allows multiple connections. It's just that in unix 
terms, using a file descriptor as the "cookie" for the connection is a 
very natural model. So the important part isn't the file descriptor 
itself, it's the model you could build).

			Linus
